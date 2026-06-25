"""
HTTP server para Dijkstra sobre el grafo de navegacion.

Puerto por defecto: 8001 (MCP server vive en 8000).
Auth: Bearer token, mismo que MCP_BEARER_TOKEN.

Uso:
  python route_server.py

Endpoint:
  GET /route?origin=<place_id>&destination=<place_id>
  Headers: Authorization: Bearer <token>

  GET /health
  (sin auth)

Variables de entorno (en .env de la raiz):
  DATABASE_URL        postgresql://...
  MCP_BEARER_TOKEN    mismo token que el MCP server
  ROUTE_SERVER_PORT   default 8001
"""

import heapq
import os
from pathlib import Path

import psycopg
import uvicorn
from dotenv import load_dotenv
from psycopg.rows import dict_row
from starlette.applications import Starlette
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
from starlette.responses import JSONResponse
from starlette.routing import Route

# Carga .env de la raiz; si no tiene DATABASE_URL, cae al del mcp-server.
load_dotenv(Path(__file__).parent / ".env")
if not os.getenv("DATABASE_URL"):
    load_dotenv(Path(__file__).parent / "mcp-server" / ".env")

DATABASE_URL = os.getenv("DATABASE_URL")
MCP_BEARER_TOKEN = os.getenv("MCP_BEARER_TOKEN")
ROUTE_SERVER_PORT = int(os.getenv("ROUTE_SERVER_PORT", "8001"))

if not DATABASE_URL:
    raise RuntimeError("DATABASE_URL no esta definida en .env")


def place_to_node(place_id):
    with psycopg.connect(DATABASE_URL, row_factory=dict_row) as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT nn.name AS node_name
                FROM places p
                JOIN place_navigation_nodes pnn ON pnn.place_id = p.id
                JOIN navigation_nodes nn ON nn.id = pnn.navigation_node_id
                WHERE p.id = %s AND pnn.role = 'front_door';
                """,
                (place_id,),
            )
            row = cur.fetchone()
    return row["node_name"] if row else None


def load_graph():
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


def compute_route(origin_id, dest_id):
    origin_node = place_to_node(origin_id)
    dest_node = place_to_node(dest_id)
    if not origin_node:
        return {"error": f"origen {origin_id} no existe o sin nodo front_door"}, 404
    if not dest_node:
        return {"error": f"destino {dest_id} no existe o sin nodo front_door"}, 404

    adj, edge_map, segments = load_graph()
    dist, prev = dijkstra(adj, origin_node)
    node_path = reconstruct(prev, origin_node, dest_node)
    if not node_path:
        return {"error": f"sin ruta entre {origin_node} y {dest_node}"}, 404

    route_files = []
    for u, v in zip(node_path, node_path[1:]):
        eid = edge_map.get((u, v))
        route_files.append(segments.get(eid) if eid else None)

    return {
        "nodes_ordered": node_path,
        "route_files": route_files,
        "total_distance_m": round(dist[dest_node], 2),
    }, 200


async def route_endpoint(request: Request):
    origin = request.query_params.get("origin")
    destination = request.query_params.get("destination")
    if not origin or not destination:
        return JSONResponse(
            {"error": "faltan parametros: origin y destination"},
            status_code=400,
        )
    result, status = compute_route(origin, destination)
    return JSONResponse(result, status_code=status)


async def health_endpoint(request: Request):
    return JSONResponse({"status": "ok", "service": "route-server"})


class BearerAuthMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request, call_next):
        # /health queda sin auth para probes
        if request.url.path == "/health":
            return await call_next(request)
        if not MCP_BEARER_TOKEN:
            return await call_next(request)
        parts = request.headers.get("authorization", "").split()
        if len(parts) != 2 or parts[0].lower() != "bearer":
            return JSONResponse(
                {"error": "unauthorized", "error_description": "Bearer token required"},
                status_code=401,
            )
        if parts[1] != MCP_BEARER_TOKEN:
            return JSONResponse(
                {"error": "invalid_token", "error_description": "Invalid bearer token"},
                status_code=401,
            )
        return await call_next(request)


app = Starlette(
    routes=[
        Route("/route", route_endpoint, methods=["GET"]),
        Route("/health", health_endpoint, methods=["GET"]),
    ],
)
app.add_middleware(BearerAuthMiddleware)


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=ROUTE_SERVER_PORT)
