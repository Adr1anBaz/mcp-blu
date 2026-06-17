# Campus DB — MCP Server

MCP server that exposes campus information (places, restaurants, menus, stores, offices, gates) over Streamable HTTP.

## Quick start

### Option A: uv (recommended)

```bash
cd mcp-server
cp .env.example .env        # edit with your credentials
uv run server.py
```

That's it. `uv run` creates the venv, installs dependencies from `pyproject.toml`, and runs the server in one command.

### Option B: pip

```bash
cd mcp-server
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env        # edit with your credentials
python server.py
```

### Option C: Docker (Alpine)

```bash
cd mcp-server
docker build -t campus-mcp .
docker run --env-file .env -p 8000:8000 campus-mcp
```

The server starts on `http://0.0.0.0:8000`. The MCP endpoint is at `/mcp`.

## Environment variables

| Variable | Required | Description |
|----------|----------|-------------|
| `DATABASE_URL` | Yes | PostgreSQL connection string |
| `MCP_BEARER_TOKEN` | Yes | Secret token that clients must send in the `Authorization: Bearer <token>` header |

## Connecting from Claude Code

Add this to your project's MCP config (via `claude mcp add` or `.claude.json`):

```json
{
  "campus-db": {
    "type": "streamable-http",
    "url": "http://<your-server-ip>:8000/mcp",
    "headers": {
      "Authorization": "Bearer <your-MCP_BEARER_TOKEN>"
    }
  }
}
```

## Testing the connection

```bash
curl -X POST http://localhost:8000/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer <your-token>" \
  -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}'
```

## API usage (for custom agents)

All communication goes through `POST /mcp` using JSON-RPC 2.0. Every request needs these headers:

```
Content-Type: application/json
Accept: application/json
Authorization: Bearer <your-token>
```

### Step 1: Initialize the session

```bash
curl -X POST http://localhost:8000/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer <your-token>" \
  -d '{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "initialize",
    "params": {
      "protocolVersion": "2024-11-05",
      "capabilities": {},
      "clientInfo": {"name": "my-agent", "version": "1.0"}
    }
  }'
```

Returns server capabilities and protocol version.

### Step 2: List available tools

```bash
curl -X POST http://localhost:8000/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer <your-token>" \
  -d '{
    "jsonrpc": "2.0",
    "id": 2,
    "method": "tools/list",
    "params": {}
  }'
```

Returns all tools with their names, descriptions, and input schemas. Cache this response — it won't change unless you restart the server.

### Step 3: Call a tool

```bash
curl -X POST http://localhost:8000/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer <your-token>" \
  -d '{
    "jsonrpc": "2.0",
    "id": 3,
    "method": "tools/call",
    "params": {
      "name": "search_places",
      "arguments": {"query": "cafetería"}
    }
  }'
```

Returns the tool result in `result.content` (array of content blocks, typically `{"type": "text", "text": "..."}` with JSON inside).

### Other available methods

| Method | Description |
|--------|-------------|
| `ping` | Health check — returns `{}` |
| `notifications/initialized` | Notify server that client finished init (no response) |
| `resources/list` | List static resources exposed by the server |
| `resources/read` | Read a specific resource |
| `prompts/list` | List prompt templates |
| `prompts/get` | Get a specific prompt template |

### Typical agent flow

```
initialize → tools/list (cache it) → tools/call (in a loop, as the LLM requests)
```

Your agent reads the tool list, passes it to the LLM as available functions, and when the LLM decides to call one, you send `tools/call` and feed the result back into the conversation.

---

## Available tools

- `health_check` — verify DB connectivity
- `database_summary` — count of places by type
- `list_places` — list all places, optionally filter by type
- `search_places` — search by name, description, building, etc.
- `get_place_detail` / `get_place_detail_by_name` — full info with hours and profiles
- `get_restaurant_menu` / `get_restaurant_menu_by_name` — menus and items
- `search_food` — search menu items, optionally by max price
- `get_store_products` / `search_products` — store inventory
- `find_office_by_need` — search offices by services/department
- `get_gates` — list campus gates with permissions
- `search_semantic_documents` — text search over documents
- `get_current_crowd_levels` — latest crowd levels per place
