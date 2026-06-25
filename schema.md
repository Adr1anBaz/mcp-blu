# Resumen de Base de Datos — Campus MCP / Robot Navigation

Este documento resume la estructura actual de la base de datos local del sistema. La base está pensada para almacenar información de lugares dentro de una universidad, permitir búsquedas semánticas con embeddings y, más adelante, alimentar un sistema de rutas para un robot mediante grafos.

## Stack actual

La base corre localmente con:

```txt
PostgreSQL + pgvector + Docker Compose
```

- **PostgreSQL**: base relacional principal.
- **pgvector**: extensión para guardar embeddings y hacer búsqueda semántica.
- **Docker Compose**: entorno local reproducible.

La base actual se llama:

```txt
campus_db
```

El usuario local es:

```txt
campus_user
```

---

# 1. Idea general del modelo

La base está organizada en cinco bloques principales:

```txt
1. Lugares y estructura del campus
2. Horarios y disponibilidad
3. Información específica por tipo de lugar
4. Búsqueda semántica / embeddings
5. Navegación por grafos para el robot
```

La tabla central es:

```txt
places
```

Todo lo que el usuario puede buscar como destino o lugar relevante vive ahí:

```txt
Restaurantes
Laboratorios
Salones
Tiendas
Oficinas
Departamentos
Puertas
Áreas comunes
```

---

# 2. Núcleo del campus

## `campuses`

Guarda uno o varios campus.

Sirve para poder escalar el sistema si después se tienen varias universidades o sedes.

Relaciones:

```txt
campuses 1 ─── N buildings
campuses 1 ─── N places
campuses 1 ─── N navigation_nodes
```

Campos importantes:

```txt
id
name
description
created_at
updated_at
```

---

## `buildings`

Guarda edificios o zonas del campus.

Ejemplos:

```txt
Edificio L
Zona de comida
Biblioteca
Área deportiva
```

Relaciones:

```txt
buildings N ─── 1 campuses
buildings 1 ─── N places
buildings 1 ─── N navigation_nodes
```

Sirve para organizar lugares y nodos de navegación.

---

## `places`

Es la tabla central del sistema.

Guarda cualquier lugar relevante dentro de la universidad.

Tipos actuales:

```txt
restaurant
classroom
lab
store
office
department
gate
common_area
```

Campos importantes:

```txt
id
campus_id
building_id
name
type
description
floor
room_code
status
metadata
created_at
updated_at
```

`metadata` es un campo `JSONB` para guardar atributos flexibles.

Ejemplo:

```json
{
  "ambiente": "tranquilo",
  "ideal_para": ["trabajar", "estudiar"],
  "ruido": "bajo"
}
```

Esto permite agregar información sin modificar la estructura de tablas cada vez.

---

# 3. Categorías

## `categories`

Guarda categorías jerárquicas.

Ejemplo:

```txt
Restaurante
  ├── Café
  ├── Comida rápida
  └── Comida saludable
```

Relaciones:

```txt
categories 1 ─── N categories
categories N ─── N places
```

---

## `place_categories`

Tabla pivote entre lugares y categorías.

Relaciones:

```txt
places N ─── N categories
```

Sirve porque un lugar puede tener varias categorías.

Ejemplo:

```txt
Giornale
- Restaurante
- Café
- Comida casual
```

---

# 4. Horarios y excepciones

## `opening_hours`

Guarda el horario normal de un lugar.

Aplica para:

```txt
Restaurantes
Tiendas
Oficinas
Salones
Laboratorios
Puertas
```

Relación:

```txt
places 1 ─── N opening_hours
```

Campos importantes:

```txt
place_id
day_of_week
opens_at
closes_at
valid_from
valid_to
```

Ejemplo:

```txt
Laboratorio L
Lunes a viernes
08:00 - 20:00
```

---

## `schedule_exceptions`

Guarda excepciones al horario normal.

Ejemplos:

```txt
Cerrado por vacaciones
Cerrado por mantenimiento
Horario especial por evento
```

Relación:

```txt
places 1 ─── N schedule_exceptions
```

Esto evita modificar el horario base cuando hay cambios temporales.

---

# 5. Restaurantes

## `restaurant_profiles`

Guarda datos propios de restaurantes.

Relación:

```txt
places 1 ─── 1 restaurant_profiles
```

Campos importantes:

```txt
place_id
cuisine_type
average_price
payment_methods
accepts_card
notes
```

---

## `menus`

Guarda menús asociados a un restaurante.

Relación:

```txt
places 1 ─── N menus
```

Ejemplos:

```txt
Menú principal
Menú desayuno
Menú bebidas
```

---

## `menu_items`

Guarda productos o platillos dentro de un menú.

Relación:

```txt
menus 1 ─── N menu_items
```

Campos importantes:

```txt
name
description
category
price
currency
dietary_tags
available
metadata
```

Ejemplo:

```txt
Panini de queso
$95 MXN
Vegetariano
```

---

## `crowd_levels`

Guarda información de concurrencia.

Relación:

```txt
places 1 ─── N crowd_levels
```

Campos importantes:

```txt
place_id
observed_at
level
percentage
source
```

Niveles posibles:

```txt
low
medium
high
full
```

Sirve para responder preguntas como:

```txt
¿Qué restaurante está menos lleno?
¿Dónde puedo comer rápido?
¿A qué hora suele llenarse Giornale?
```

---

# 6. Tiendas

## `store_profiles`

Guarda datos generales de una tienda.

Relación:

```txt
places 1 ─── 1 store_profiles
```

Ejemplos de tipo:

```txt
Papelería
Librería
Tecnología
Conveniencia
```

---

## `products`

Guarda productos vendidos en tiendas.

Relación:

```txt
places 1 ─── N products
```

Campos importantes:

```txt
name
description
category
price
currency
available
metadata
```

Sirve para responder:

```txt
¿Dónde compro una libreta?
¿Cuánto cuesta este producto?
¿Qué tienda vende X?
```

---

# 7. Salones y laboratorios

## `room_profiles`

Guarda datos específicos de salones, laboratorios o espacios académicos.

Relación:

```txt
places 1 ─── 1 room_profiles
```

Campos importantes:

```txt
room_type
capacity
equipment
reservable
notes
```

Ejemplo de `equipment`:

```json
{
  "computers": 25,
  "projector": true,
  "whiteboard": true,
  "power_outlets": true
}
```

Sirve para filtrar espacios por equipamiento.

---

## `academic_terms`

Guarda periodos académicos.

Ejemplo:

```txt
Primavera 2026
Otoño 2026
```

Relación:

```txt
academic_terms 1 ─── N room_events
```

Sirve para asociar horarios de clase a un periodo específico.

---

## `room_events`

Guarda clases, exámenes, reservas o mantenimientos dentro de salones/labs.

Relación:

```txt
places 1 ─── N room_events
academic_terms 1 ─── N room_events
```

Tipos posibles:

```txt
class
exam
reservation
maintenance
```

Sirve para saber si un salón o laboratorio está libre en un momento específico.

Lógica básica:

```txt
Un salón está disponible si:
1. Está abierto según opening_hours
2. No tiene schedule_exception de cierre
3. No tiene room_event activo en ese horario
```

---

# 8. Oficinas y departamentos

## `office_profiles`

Guarda información de oficinas o departamentos.

Relación:

```txt
places 1 ─── 1 office_profiles
```

Campos importantes:

```txt
department_type
purpose
contact_email
phone
website_url
services
```

Ejemplo de `services`:

```json
[
  "pagos",
  "facturación",
  "aclaraciones financieras",
  "becas"
]
```

Sirve para preguntas como:

```txt
¿A dónde voy si tengo problemas con pagos?
¿Dónde resuelvo temas de materias?
¿Dónde pido una constancia?
```

---

# 9. Puertas

## `gate_profiles`

Guarda información de entradas y salidas del campus.

Relación:

```txt
places 1 ─── 1 gate_profiles
```

Campos importantes:

```txt
gate_type
entry_allowed
exit_allowed
adjacent_streets
security_notes
```

Ejemplo:

```txt
Puerta 10
Calles: Vasco de Quiroga, Prolongación Paseo de la Reforma
```

No se está usando geolocalización. Las calles se guardan como texto simple.

---

# 10. Búsqueda semántica

## `semantic_documents`

Guarda textos preparados para generar embeddings.

Relación flexible:

```txt
semantic_documents puede apuntar a:
- places
- menu_items
- products
- office_profiles
- room_profiles
- gate_profiles
```

Campos importantes:

```txt
entity_type
entity_id
title
content
metadata
embedding
embedding_model
source_hash
updated_at
```

La idea es que esta tabla no guarde la verdad principal del sistema. La verdad está en las tablas relacionales.

`semantic_documents` sirve para búsqueda por significado.

Ejemplo:

```txt
content:
"Laboratorio L es un espacio tranquilo con computadoras, proyector, pizarrón y contactos eléctricos. Es ideal para estudiar, trabajar o hacer prácticas técnicas."
```

Si el usuario pregunta:

```txt
¿Dónde puedo trabajar con computadora?
```

El sistema puede encontrar el Laboratorio L aunque el usuario no haya dicho literalmente “laboratorio”.

## Relación entre JSONB y embeddings

El JSONB no se embebea crudo.

Se usa como fuente para generar texto.

Ejemplo JSONB:

```json
{
  "ambiente": "tranquilo",
  "ideal_para": ["trabajar", "estudiar"],
  "ruido": "bajo"
}
```

Texto para embedding:

```txt
Este lugar es tranquilo, ideal para trabajar o estudiar, y tiene bajo nivel de ruido.
```

La regla recomendada es:

```txt
Embeddings = encontrar candidatos por significado
SQL normal = validar condiciones exactas
```

Ejemplo:

```txt
Pregunta: "quiero un lugar tranquilo para estudiar"

1. Embedding encuentra lugares similares
2. SQL valida:
   - está abierto
   - no hay clase
   - tiene el equipo necesario
   - no está cerrado
```

---

# 11. Navegación por grafos

La navegación está pensada para que un robot pueda llevar a una persona de un punto a otro.

La idea clave:

```txt
places = lugares que el usuario entiende
navigation_nodes = puntos del grafo que el robot puede usar
navigation_edges = conexiones entre nodos
route_segments = tramos ejecutables por el robot
```

No todos los `places` son nodos y no todos los nodos son `places`.

---

## `navigation_nodes`

Guarda puntos del grafo.

Relaciones:

```txt
campuses 1 ─── N navigation_nodes
buildings 1 ─── N navigation_nodes
navigation_nodes N ─── N places
```

Tipos posibles:

```txt
place_anchor
hallway
intersection
door
stairs
elevator
gate
robot_start
other
```

Ejemplos:

```txt
Nodo frente a Laboratorio L
Nodo pasillo Laboratorio L
Nodo entrada Giornale
```

Sirve para representar puntos donde el robot puede iniciar o terminar un tramo.

---

## `place_navigation_nodes`

Conecta lugares con nodos de navegación.

Relación:

```txt
places N ─── N navigation_nodes
```

Campos importantes:

```txt
place_id
navigation_node_id
role
```

Roles posibles:

```txt
main_entrance
exit
pickup_point
dropoff_point
front_door
anchor
```

Ejemplo:

```txt
Laboratorio L → Nodo frente a Laboratorio L → front_door
Giornale → Nodo entrada Giornale → front_door
```

Esto es importante porque un lugar puede tener más de un nodo asociado.

---

## `navigation_edges`

Une dos nodos del grafo.

Relación:

```txt
navigation_nodes 1 ─── N navigation_edges
```

Cada edge representa una conexión navegable.

Campos importantes:

```txt
from_node_id
to_node_id
duration_seconds
bidirectional
edge_type
status
metadata
```

Tipos posibles:

```txt
walk
hallway
stairs
elevator
ramp
outdoor
restricted
```

Estados posibles:

```txt
active
closed
slow
restricted
```

El campo más importante para Dijkstra es:

```txt
distance_meters
```

Ese es el peso de la conexión (distancia en metros entre los dos nodos).

Ejemplo:

```txt
Nodo frente a Laboratorio L → Nodo pasillo Laboratorio L
distance_meters: 5.00
```

---

## `route_segments`

Guarda el tramo ejecutable por el robot asociado a un edge.

Relación:

```txt
navigation_edges 1 ─── N route_segments
```

Campos importantes:

```txt
edge_id
segment_key
route_file_name
instruction_key
expected_duration_seconds
start_orientation_hint
end_orientation_hint
robot_mode
reversible
reverse_segment_id
version
active
metadata
```

Ejemplo:

```txt
edge:
Nodo frente a Laboratorio L → Nodo pasillo Laboratorio L

route_segment:
laboratorio_l_to_pasillo_l.csv
```

Esto permite que Dijkstra devuelva una secuencia de edges y luego el robot sepa qué archivo/tramo ejecutar.

---

# 12. Flujo esperado para rutas

Ejemplo:

```txt
Usuario: "Llévame de Laboratorio L a Giornale"
```

Flujo:

```txt
1. Buscar place origen: Laboratorio L
2. Buscar place destino: Giornale
3. Obtener navigation_node asociado a cada place
4. Correr Dijkstra sobre navigation_edges
5. Obtener secuencia de edges
6. Obtener route_segments de cada edge
7. Devolver archivos/tramos al robot
```

Ejemplo de resultado:

```txt
1. laboratorio_l_to_pasillo_l.csv
2. pasillo_l_to_giornale.csv
```

---

# 13. Cómo se conecta esto con MCP

El MCP no debería exponer SQL libre.

Lo ideal es exponer herramientas seguras, por ejemplo:

```txt
search_places(query, filters)
get_place_detail(place_id)
get_restaurant_menu(place_id)
find_available_rooms(datetime, duration)
semantic_search_places(query)
get_route(origin_place, destination_place)
```

El MCP llama a servicios internos. Los servicios internos consultan PostgreSQL.

Arquitectura futura:

```txt
MCP Server
  ├── Place Service
  ├── Semantic Search Service
  ├── Availability Service
  └── Route Service
        └── Dijkstra / A*
```

La base sigue siendo la fuente de verdad.

---

# 14. Resumen de relaciones principales

```txt
campuses
  ├── buildings
  ├── places
  └── navigation_nodes

buildings
  ├── places
  └── navigation_nodes

places
  ├── opening_hours
  ├── schedule_exceptions
  ├── restaurant_profiles
  │     └── menus
  │           └── menu_items
  ├── store_profiles
  │     └── products
  ├── room_profiles
  │     └── room_events
  ├── office_profiles
  ├── gate_profiles
  ├── crowd_levels
  ├── place_categories
  │     └── categories
  └── place_navigation_nodes
        └── navigation_nodes

navigation_nodes
  └── navigation_edges
        └── route_segments

semantic_documents
  └── apunta de forma flexible a entidades como places, products, menu_items, rooms u offices
```

---

# 15. Estado actual del seed

Actualmente el seed de prueba crea:

```txt
Campus Demo

Edificios:
- Edificio L
- Zona de comida

Lugares:
- Laboratorio L
- Giornale
- Puerta 10

Nodos:
- Nodo frente a Laboratorio L
- Nodo pasillo Laboratorio L
- Nodo entrada Giornale

Edges:
- Laboratorio L → Pasillo L, 35 segundos
- Pasillo L → Giornale, 90 segundos

Route segments:
- laboratorio_l_to_pasillo_l.csv
- pasillo_l_to_giornale.csv

Semantic documents:
- Laboratorio L
- Giornale
- Puerta 10
```

---

# 16. Regla mental del sistema

```txt
places
= qué lugares existen

profiles
= detalles propios de cada tipo de lugar

opening_hours + room_events
= disponibilidad real

semantic_documents
= búsqueda inteligente por significado

navigation_nodes + navigation_edges
= grafo lógico de movimiento

route_segments
= tramos ejecutables por el robot

MCP
= interfaz segura para que un agente consulte todo
```

