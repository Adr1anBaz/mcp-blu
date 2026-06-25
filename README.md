# campus-db

Sistema local que expone info del campus (lugares, restaurantes, tiendas, puertas, labs) via **MCP server** (puerto 8000) y expone un **route server con Dijkstra** sobre el grafo de navegacion (puerto 8001). Ambos usan el mismo `MCP_BEARER_TOKEN`.

**Servicios:**
| Servicio | Puerto | Auth |
|----------|--------|------|
| PostgreSQL + pgvector | 5432 | `campus_user` / `campus_password` |
| MCP server | 8000 | `Bearer MCP_BEARER_TOKEN` (en `/mcp`) |
| Route server (Dijkstra) | 8001 | `Bearer MCP_BEARER_TOKEN` (en `/route`) |

---

## Fast deploy

### 1. Variables de entorno

```bash
cp .env.example .env
cp mcp-server/.env.example mcp-server/.env
```

Editar ambos `.env` con el mismo `MCP_BEARER_TOKEN`. Defaults:

```
DATABASE_URL=postgresql://campus_user:campus_password@localhost:5432/campus_db
MCP_BEARER_TOKEN=change-me-to-a-random-secret
ROUTE_SERVER_PORT=8001
```

### 2. Levantar PostgreSQL

```bash
docker compose up -d
```

Schema (`db/init/001_init.sql`) y seed (`db/seeds/001_seed.sql`) corren automaticamente la primera vez.

```bash
docker compose down        # mantiene datos
docker compose down -v     # borra todo
```

### 3. Encender MCP server (tools para LLMs)

**uv (recomendado):**
```bash
cd mcp-server
uv run server.py
```

**pip:**
```bash
cd mcp-server
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
python server.py
```

**Docker:**
```bash
cd mcp-server
docker build -t campus-mcp .
docker run --env-file .env -p 8000:8000 campus-mcp
```

Queda en `http://0.0.0.0:8000/mcp`.

### 4. Encender route server (Dijkstra HTTP)

Lee el grafo de `navigation_nodes` + `navigation_edges` (peso = `distance_meters`), resuelve origen/destino por su nodo `front_door`, y devuelve secuencia de `route_segments`.

**uv (recomendado):**
```bash
uv run route_server.py
```

**pip:**
```bash
python -m venv .venv && source .venv/bin/activate
pip install -r mcp-server/requirements.txt
python route_server.py
```

Queda en `http://0.0.0.0:8001`.

---

## Uso

### MCP server (tools)

En `.claude.json` o via `claude mcp add`:

```json
{
  "mcpServers": {
    "campus-db": {
      "type": "streamable-http",
      "url": "http://<server-ip>:8000/mcp",
      "headers": { "Authorization": "Bearer <MCP_BEARER_TOKEN>" }
    }
  }
}
```

Tools disponibles: `health_check`, `database_summary`, `list_places`, `search_places`, `get_place_detail`, `get_place_detail_by_name`, `get_restaurant_menu`, `get_restaurant_menu_by_name`, `search_food`, `get_store_products`, `search_products`, `find_office_by_need`, `get_gates`, `search_semantic_documents`, `get_current_crowd_levels`.

### Route server (Dijkstra)

```bash
# Health (sin auth)
curl http://localhost:8001/health

# Ruta entre dos places (place_id = UUID)
curl "http://localhost:8001/route?origin=<uuid>&destination=<uuid>" \
  -H "Authorization: Bearer $MCP_BEARER_TOKEN"
```

Respuesta:

```json
{
  "nodes_ordered": ["nodo A", "nodo B", "nodo C"],
  "route_files":   ["a_to_b.csv", "b_to_c.csv"],
  "total_distance_m": 47.30
}
```

Errores: `400` faltan params · `401` token invalido · `404` sin ruta o place sin nodo `front_door`.

### CLI Dijkstra (one-shot)

```bash
python dijkstra_demo.py <place_id_origen> <place_id_destino>
```

Imprime el mismo JSON que el endpoint `/route`.

---

## Estructura

```
campus-db/
├── docker-compose.yml
├── db/
│   ├── init/001_init.sql       # schema
│   └── seeds/001_seed.sql      # datos de prueba
├── mcp-server/
│   ├── server.py               # MCP server (tools)
│   ├── .env
│   └── .venv/
├── route_server.py             # HTTP Dijkstra server (puerto 8001)
├── dijkstra_demo.py            # CLI Dijkstra
├── .env / .env.example
├── schema.md                   # modelo de datos
└── docs/GRAFO_FUNCIONAMIENTO.md
```

---

## Conexion directa a DB (debug)

```bash
docker exec -it campus_postgres psql -U campus_user -d campus_db
```

Ver grafo:

```sql
SELECT fn.name AS desde, tn.name AS hasta, ne.distance_meters
FROM navigation_edges ne
JOIN navigation_nodes fn ON fn.id = ne.from_node_id
JOIN navigation_nodes tn ON tn.id = ne.to_node_id
WHERE ne.status = 'active';
```