"""
Dijkstra determinista para los 3 salones del Edificio L.

Grafo hardcodeado (4 aristas, todas bidireccionales):
  Pasillo Salon L <-> L-A   20.0 m   (hallway)
  Pasillo Salon L <-> L-B    8.0 m   (hallway)
  Pasillo Salon L <-> L-C   14.0 m   (hallway)
  L-B         <-> L-C        0.5 m   (door)

Uso:  python dijkstra_demo.py
"""

import heapq

NODES = ["Pasillo", "L-A", "L-B", "L-C"]

EDGES = [
    ("Pasillo", "L-A", 20.0, "hallway"),
    ("Pasillo", "L-B",  8.0, "hallway"),
    ("Pasillo", "L-C", 14.0, "hallway"),
    ("L-B",     "L-C",  0.5, "door"),
]


def dijkstra(graph, start):
    """Shortest-path tree desde `start`. Devuelve (dist, prev)."""
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


def path(prev, start, end):
    """Reconstruye la lista de nodos del camino mas corto de start a end."""
    out, cur = [], end
    while cur is not None:
        out.append(cur)
        cur = prev[cur]
    return list(reversed(out)) if out and out[-1] == start else []


def main():
    # Lista de adyacencia: nodo -> [(vecino, peso), ...]
    graph = {n: [] for n in NODES}
    for a, b, w, _ in EDGES:
        graph[a].append((b, w))
        graph[b].append((a, w))

    print("=== Dijkstra: 3 salones del Edificio L ===\n")

    # 1) Desde el Pasillo (punto de partida natural del robot)
    dist, prev = dijkstra(graph, "Pasillo")
    print("Distancias desde Pasillo Salon L:")
    for target in ("L-A", "L-B", "L-C"):
        print(f"  Pasillo -> {target:5s}  {dist[target]:5.1f} m   via {' -> '.join(path(prev, 'Pasillo', target))}")

    # 2) Pares salon-a-salon (3 unicos porque el grafo es no-dirigido)
    print("\nPares salon-a-salon:")
    for a, b in (("L-A", "L-B"), ("L-A", "L-C"), ("L-B", "L-C")):
        d, p = dijkstra(graph, a)
        print(f"  {a} -> {b}    {d[b]:5.1f} m   via {' -> '.join(path(p, a, b))}")


if __name__ == "__main__":
    main()
