"""
Dijkstra sobre el grafo real de navegacion (lee de PostgreSQL).

Uso:
  python dijkstra_demo.py <origen_place_id> <destino_place_id>

Los argumentos son place_id (UUID) de la tabla `places`.
Para cada lugar, se toma su nodo de entrada (role = 'front_door')
y se corre Dijkstra entre ambos nodos.
"""

import heapq
import os
import sys
from pathlib import Path

import psycopg
from dotenv import load_dotenv
from psycopg.rows import dict_row

load_dotenv(Path(__file__).parent / "mcp-server" / ".env")
DATABASE_URL = os.getenv("DATABASE_URL")


def place_to_node(place_id):
    with psycopg.connect(DATABASE_URL, row_factory=dict_row) as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT p.name AS place_name, nn.name AS node_name
                FROM places p
                JOIN place_navigation_nodes pnn ON pnn.place_id = p.id
                JOIN navigation_nodes nn ON nn.id = pnn.navigation_node_id
                WHERE p.id = %s AND pnn.role = 'front_door';
                """,
                (place_id,),
            )
            row = cur.fetchone()
    if not row:
        sys.exit(f"Error: lugar {place_id} no existe o no tiene nodo front_door")
    return row["place_name"], row["node_name"]


def load_graph():
    graph = {}
    with psycopg.connect(DATABASE_URL, row_factory=dict_row) as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT fn.name AS a, tn.name AS b, ne.distance_meters AS w
                FROM navigation_edges ne
                JOIN navigation_nodes fn ON fn.id = ne.from_node_id
                JOIN navigation_nodes tn ON tn.id = ne.to_node_id
                WHERE ne.status = 'active';
                """
            )
            for row in cur.fetchall():
                a, b, w = row["a"], row["b"], float(row["w"])
                graph.setdefault(a, []).append((b, w))
                graph.setdefault(b, []).append((a, w))
    return graph


def dijkstra(graph, start):
    dist = {n: float("inf") for n in graph}
    prev = {n: None for n in graph}
    dist[start] = 0.0
    pq = [(0.0, start)]
    while pq:
        d, u = heapq.heappop(pq)
        if d > dist[u]:
            continue
        for v, w in graph[u]:
            nd = d + w
            if nd < dist[v]:
                dist[v] = nd
                prev[v] = u
                heapq.heappush(pq, (nd, v))
    return dist, prev


def reconstruct(prev, start, end):
    out, cur = [], end
    while cur is not None:
        out.append(cur)
        cur = prev[cur]
    return list(reversed(out)) if out and out[-1] == start else []


def main():
    if len(sys.argv) != 3:
        sys.exit("Uso: python dijkstra_demo.py <origen_place_id> <destino_place_id>")

    origin_id, dest_id = sys.argv[1], sys.argv[2]
    origin_place, origin_node = place_to_node(origin_id)
    dest_place, dest_node = place_to_node(dest_id)

    graph = load_graph()
    dist, prev = dijkstra(graph, origin_node)
    route = reconstruct(prev, origin_node, dest_node)

    if not route:
        sys.exit(f"Sin ruta entre {origin_node} y {dest_node}")

    print(f"Origen:  {origin_place}  ({origin_node})")
    print(f"Destino: {dest_place}  ({dest_node})")
    print(f"\nRuta optima ({dist[dest_node]:.1f} m, {len(route)} nodos):")
    for i, node in enumerate(route):
        print(f"  {i}. {node}")


if __name__ == "__main__":
    main()
