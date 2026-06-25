# Funcionamiento del Grafo de Navegacion

El campus se modela como un **grafo topologico** pensado para que un
robot se mueva de un punto a otro. La base de datos es la fuente de
verdad: la tabla `places` (lo que el humano conoce) se separa del
grafo (`navigation_nodes` + `navigation_edges` + `route_segments`) y
se conectan por una tabla puente.

## Las 4 capas

1. **Places** (`db/init/001_init.sql`): lugares del mundo real
   (restaurantes, laboratorios, puertas). Capa semantica, lo que el
   LLM responde al preguntar "donde como".
2. **Nodos** (`navigation_nodes`): vertices del grafo. Puntos donde
   el robot puede estar parado. Algunos **no** son `places` (un
   pasillo no es un lugar, pero el robot pasa por el).
3. **Aristas** (`navigation_edges`): conexiones entre dos nodos con
   un peso. El peso es la **distancia en metros** entre los nodos
   (`distance_meters NUMERIC(6,2)`).
4. **Route segments** (`route_segments`): tramo ejecutable por el
   robot asociado a una arista. Guarda el CSV con la ruta grabada.
   `expected_duration_seconds` aqui solo registra cuanto tarda la
   grabacion — **no** es el peso del grafo.

## Por que un `place` no es un nodo

Son conceptos distintos. Entre un salon y otro hay pasillos,
esquinas y puertas que no son lugares, son puntos de paso. Si el
grafo solo tuviera nodos en los `places`, no habria forma de
representar el camino entre ellos. `schema.md:730`: "No todos los
`places` son nodos y no todos los nodos son `places`."

## Tipos de nodo

`node_type` en `db/init/001_init.sql:253-264`:

- `place_anchor` — anclado a un `place` (puerta, entrada)
- `hallway` — punto en un pasillo
- `intersection` — bifurcacion, decision de giro
- `door` / `stairs` / `elevator` — transiciones
- `gate` — puerta de acceso al campus
- `robot_start` — posicion inicial conocida del robot
- `other` — reservado

## Tipos de arista

`edge_type` en `db/init/001_init.sql:297-307`:

- `walk` / `hallway` — tramo normal a pie
- `stairs` / `elevator` — sube/baja o llama elevador
- `ramp` — accesibilidad, perfil de velocidad distinto
- `outdoor` — afuera (afecta sensores)
- `restricted` — geometria existe pero no transitable

`status` (`active | closed | slow | restricted`) actua como filtro:
Dijkstra ignora las aristas que no esten `active`. `slow` podria
multiplicar el peso para reflejar congestion.

## El peso: distancia en metros

El campo **`distance_meters`** en `navigation_edges` es **el**
parametro del Dijkstra. Usamos la distancia fisica entre los dos
nodos, no el tiempo. Esto independiza el calculo de la velocidad
del robot (que puede variar) y la ruta optima es la mas corta
independientemente de quien la recorra.

Valores de referencia del seed:
- 5.00 m — pasillo corto dentro de un edificio
- 15.00 m — pasillo largo entre dos alas
- 30–50 m — trayectos al aire libre entre edificios

## Un lugar puede tener varios nodos

`place_navigation_nodes` (`db/init/001_init.sql:275-289`) es la
tabla puente N a N entre `places` y `navigation_nodes`, con un
campo `role`:

- `main_entrance` — entrada principal
- `exit` — salida (puede ser otra puerta)
- `front_door` — puerta frontal
- `pickup_point` / `dropoff_point` — recogida / entrega
- `anchor` — punto interno de referencia (escritorio, proyector)

Ejemplo real de un salon:

```
Salon A101
  ├─ nodo "puerta principal"     -> main_entrance, front_door
  ├─ nodo "puerta trasera"       -> exit
  └─ nodo "escritorio profesor"  -> anchor (reorientacion)
```

Los nodos internos se conectan con aristas: puedes ir de la puerta
al escritorio del profesor sin salir del salon. Eso es **navegar
dentro del mismo `place`**.

## Flujo para resolver una ruta

1. Buscar `place` origen y destino por nombre.
2. Resolver su `navigation_node` (tipicamente `front_door`) via
   `place_navigation_nodes`.
3. Correr Dijkstra sobre `navigation_edges` con peso =
   `distance_meters` (excluyendo `status != 'active'`).
4. Devolver secuencia de aristas.
5. Por cada arista, obtener su `route_segment` (el CSV que el
   robot ejecuta).
6. Entregar al robot la lista de segmentos.

## Estado actual

El grafo esta **modelado y sembrado** pero **aun no implementado**
el servicio de ruteo (Dijkstra/A*) en el MCP server. Los tools
disponibles hoy son de consulta (`search_places`,
`get_place_detail`, ...). El "Route Service" aparece como
arquitectura futura en `schema.md:962-971`.
