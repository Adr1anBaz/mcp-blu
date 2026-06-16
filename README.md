# campus-db

Sistema local que expone informacion de un campus universitario (lugares, restaurantes, tiendas, puertas, laboratorios) a traves de un **MCP server** (Model Context Protocol). Permite que un LLM (como Claude) consulte la base de datos en tiempo real usando tools.

La base de datos tambien incluye un **grafo de navegacion** pensado para alimentar un robot que se mueve por el campus.

**Stack:**
- PostgreSQL 17 + pgvector (Docker)
- Python MCP server (FastMCP + psycopg)
- Docker Compose para la base de datos

---

## Estructura del proyecto

```
campus-db/
├── docker-compose.yml          # Levanta PostgreSQL con pgvector
├── db/
│   ├── init/001_init.sql       # Schema completo (se ejecuta al crear el container)
│   └── seeds/001_seed.sql      # Datos de prueba
├── mcp-server/
│   ├── server.py               # MCP server con todos los tools
│   ├── .env                    # DATABASE_URL
│   └── .venv/                  # Virtual environment Python
└── DATABASE_OVERVIEW.md        # Documentacion del modelo de datos
```

---

## Setup completo (desde cero)

```bash
# 1. Levantar PostgreSQL con schema + seed (automatico)
docker compose up -d

# 2. Levantar el MCP server
cd mcp-server
cp .env.example .env        # editar si cambias credenciales o token
uv run server.py            # o: pip install -r requirements.txt && python server.py
```

Listo. El MCP server queda en `http://0.0.0.0:8000/mcp`.

### Base de datos

Docker Compose levanta PostgreSQL en `localhost:5432` con:
- **User:** `campus_user`
- **Password:** `campus_password`
- **Database:** `campus_db`

El schema y seed se ejecutan automaticamente la primera vez que se crea el container.

```bash
docker compose down        # mantiene datos
docker compose down -v     # borra todo y empieza de cero
```

### Conectar a Claude Code como MCP tool

Agregar en tu configuracion de Claude Code (via `claude mcp add` o en `.claude.json`):

```json
{
  "mcpServers": {
    "campus-db": {
      "type": "streamable-http",
      "url": "http://<server-ip>:8000/mcp",
      "headers": {
        "Authorization": "Bearer <tu-MCP_BEARER_TOKEN>"
      }
    }
  }
}
```

---

## Tools disponibles (MCP)

| Tool | Que hace |
|------|----------|
| `health_check` | Verifica conexion a la DB |
| `database_summary` | Resumen: total de places y conteo por tipo |
| `list_places` | Lista lugares, opcionalmente filtrados por tipo |
| `search_places` | Busca por nombre, descripcion, tipo, room code, edificio |
| `get_place_detail` | Detalle completo de un lugar por UUID |
| `get_place_detail_by_name` | Detalle completo buscando por nombre |
| `get_restaurant_menu` | Menu de un restaurante por UUID |
| `get_restaurant_menu_by_name` | Menu buscando por nombre del restaurante |
| `search_food` | Busca items de menu, con filtro de precio opcional |
| `get_store_products` | Productos de una tienda por UUID |
| `search_products` | Busca productos, con filtro de precio opcional |
| `find_office_by_need` | Busca oficinas/departamentos por servicio o proposito |
| `get_gates` | Lista puertas con permisos de entrada/salida |
| `search_semantic_documents` | Busca en documentos semanticos (lexical por ahora) |
| `get_current_crowd_levels` | Niveles de afluencia mas recientes por lugar |

---

## Como agregar un nuevo tool

Editar `mcp-server/server.py`. El patron es:

```python
@mcp.tool()
def mi_nuevo_tool(param1: str, param2: Optional[int] = None) -> list[dict]:
    """
    Descripcion que el LLM ve para decidir cuando usar este tool.
    """
    return query_db(
        "SELECT ... FROM ... WHERE ... ILIKE %s LIMIT 20;",
        (f"%{param1}%",),
    )
```

**Reglas:**
1. Decorar con `@mcp.tool()`
2. El docstring es la descripcion que ve el LLM — hacerlo claro y util
3. Usar `query_db()` para consultas read-only (ya esta configurado con `SET TRANSACTION READ ONLY`)
4. Los tipos de retorno se serializan automaticamente gracias a `normalize()`
5. Reiniciar el server despues de agregar tools

---

## Como agregar datos a la base

### Opcion A: Agregar un nuevo archivo SQL seed

Crear `db/seeds/002_mi_data.sql` y ejecutar:
```bash
docker exec -i campus_postgres psql -U campus_user -d campus_db < db/seeds/002_mi_data.sql
```

### Opcion B: Modificar el schema

Editar `db/init/001_init.sql` (solo aplica al recrear el container desde cero con `docker compose down -v && docker compose up -d`).

Para cambios incrementales en una DB existente, correr el ALTER/CREATE directamente:
```bash
docker exec -i campus_postgres psql -U campus_user -d campus_db -c "ALTER TABLE ..."
```

---

## Modelo de datos (resumen)

```
campuses -> buildings -> places (tabla central)
                           ├── opening_hours
                           ├── schedule_exceptions
                           ├── restaurant_profiles -> menus -> menu_items
                           ├── store_profiles -> products
                           ├── room_profiles -> room_events
                           ├── office_profiles
                           ├── gate_profiles
                           └── crowd_levels

places <-> navigation_nodes <-> navigation_edges -> route_segments
                                                     (para robot)

semantic_documents (embeddings con pgvector, busqueda lexical por ahora)
```

Tipos de place: `restaurant`, `classroom`, `lab`, `store`, `office`, `department`, `gate`, `common_area`.

---

## Conexion directa a la DB (debugging)

```bash
docker exec -it campus_postgres psql -U campus_user -d campus_db
```

O desde tu maquina:
```bash
psql postgresql://campus_user:campus_password@localhost:5432/campus_db
```
