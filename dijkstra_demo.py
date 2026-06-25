"""
Dijkstra sobre el grafo real de navegacion (lee de PostgreSQL).

Uso:
  python dijkstra_demo.py <origen_place_id> <destino_place_id>

Salida (JSON):
  {
    "nodes_ordered": ["nodo1", "nodo2", ...],
    "route_files":   ["archivo1.csv", "archivo2.csv", ...]
  }

Los place_id se resuelven a su nodo front_door; los route_file_name
se obtienen de route_segments en la DB.
"""

import heapq
import json
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
    return row["node_name"]


def load_graph():
    """Retorna (adj, edge_map, segments).
      adj       : { nodo: [(vecino, peso), ...] }
      edge_map  : { (nodo_a, nodo_b): edge_id }   (ambas direcciones)
      segments  : { edge_id: route_file_name }
    """
    adj, edge_map, segments = {}, {}, {}
    with psycopg.connect(DATABASE_URL, row_factory=dict_row) as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT ne.id, fn.name AS a, tn.name AS b, ne.distance_meters AS w
                FROM navigation_edges ne
                JOIN navigation_nodes fn ON fn.id = ne.from_node_id
                JOIN navigation_nodes tn ON tn.id = ne.to_node_id
                WHERE ne.status = 'active';
                """
            )
            for row in cur.fetchall():
                eid, a, b, w = row["id"], row["a"], row["b"], float(row["w"])
                adj.setdefault(a, []).append((b, w))
                adj.setdefault(b, []).append((a, w))
                edge_map[(a, b)] = eid
                edge_map[(b, a)] = eid

            cur.execute(
                "SELECT edge_id, route_file_name FROM route_segments WHERE active = TRUE;"
            )
            for row in cur.fetchall():
                segments[row["edge_id"]] = row["route_file_name"]
    return adj, edge_map, segments


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
    origin_node = place_to_node(origin_id)
    dest_node = place_to_node(dest_id)

    adj, edge_map, segments = load_graph()
    dist, prev = dijkstra(adj, origin_node)
    node_path = reconstruct(prev, origin_node, dest_node)

    if not node_path:
        sys.exit(f"Sin ruta entre {origin_node} y {dest_node}")

    route_files = []
    for u, v in zip(node_path, node_path[1:]):
        eid = edge_map.get((u, v))
        route_files.append(segments.get(eid) if eid else None)

    result = {
        "nodes_ordered": node_path,
        "route_files": route_files,
        "total_distance_m": round(dist[dest_node], 2),
    }
    print(json.dumps(result, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
