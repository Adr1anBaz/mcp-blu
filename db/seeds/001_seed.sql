-- Campus
INSERT INTO campuses (id, name, description)
VALUES (
  '00000000-0000-0000-0000-000000000001',
  'Campus Demo',
  'Campus de prueba para sistema de lugares, MCP y robot.'
);

-- Buildings
INSERT INTO buildings (id, campus_id, name, code, description)
VALUES
(
  '00000000-0000-0000-0000-000000000101',
  '00000000-0000-0000-0000-000000000001',
  'Edificio L',
  'L',
  'Edificio donde se encuentra el Laboratorio L.'
),
(
  '00000000-0000-0000-0000-000000000102',
  '00000000-0000-0000-0000-000000000001',
  'Zona de comida',
  'FOOD',
  'Zona donde se encuentran restaurantes y cafeterías.'
);

-- Places
INSERT INTO places (
  id, campus_id, building_id, name, type, description, floor, room_code, metadata
)
VALUES
(
  '00000000-0000-0000-0000-000000001001',
  '00000000-0000-0000-0000-000000000001',
  '00000000-0000-0000-0000-000000000101',
  'Laboratorio L',
  'lab',
  'Laboratorio con computadoras para prácticas y trabajo académico.',
  '1',
  'L-101',
  '{"ambiente": "tranquilo", "ideal_para": ["trabajar", "estudiar"], "ruido": "bajo"}'
),
(
  '00000000-0000-0000-0000-000000001002',
  '00000000-0000-0000-0000-000000000001',
  '00000000-0000-0000-0000-000000000102',
  'Giornale',
  'restaurant',
  'Restaurante dentro del campus con café, alimentos y bebidas.',
  '1',
  null,
  '{"ambiente": "casual", "ideal_para": ["comer", "reunirse"], "ruido": "medio"}'
),
(
  '00000000-0000-0000-0000-000000001003',
  '00000000-0000-0000-0000-000000000001',
  null,
  'Puerta 10',
  'gate',
  'Entrada y salida principal del campus.',
  null,
  null,
  '{"requiere_credencial": true}'
);

-- Room profile
INSERT INTO room_profiles (
  place_id, room_type, capacity, equipment, reservable, notes
)
VALUES (
  '00000000-0000-0000-0000-000000001001',
  'lab',
  25,
  '{"computers": 25, "projector": true, "whiteboard": true, "power_outlets": true}',
  false,
  'Ideal para prácticas técnicas.'
);

-- Restaurant profile
INSERT INTO restaurant_profiles (
  place_id, cuisine_type, average_price, payment_methods, accepts_card, notes
)
VALUES (
  '00000000-0000-0000-0000-000000001002',
  'café y comida casual',
  120,
  '["cash", "card"]',
  true,
  'Suele estar concurrido en horas de comida.'
);

-- Menu
INSERT INTO menus (id, place_id, name, description, active)
VALUES (
  '00000000-0000-0000-0000-000000002001',
  '00000000-0000-0000-0000-000000001002',
  'Menú principal',
  'Café, bebidas y alimentos casuales.',
  true
);

INSERT INTO menu_items (
  menu_id, name, description, category, price, currency, dietary_tags, available
)
VALUES
(
  '00000000-0000-0000-0000-000000002001',
  'Café americano',
  'Café caliente regular.',
  'bebida',
  45,
  'MXN',
  '["vegetariano"]',
  true
),
(
  '00000000-0000-0000-0000-000000002001',
  'Panini de queso',
  'Panini caliente con queso.',
  'comida',
  95,
  'MXN',
  '["vegetariano"]',
  true
);

-- Gate profile
INSERT INTO gate_profiles (
  place_id, gate_type, entry_allowed, exit_allowed, adjacent_streets, security_notes
)
VALUES (
  '00000000-0000-0000-0000-000000001003',
  'pedestrian',
  true,
  true,
  'Vasco de Quiroga, Prolongación Paseo de la Reforma',
  'Requiere credencial para entrar.'
);

-- Opening hours
INSERT INTO opening_hours (
  place_id, day_of_week, opens_at, closes_at
)
VALUES
-- Laboratorio L lunes-viernes
('00000000-0000-0000-0000-000000001001', 1, '08:00', '20:00'),
('00000000-0000-0000-0000-000000001001', 2, '08:00', '20:00'),
('00000000-0000-0000-0000-000000001001', 3, '08:00', '20:00'),
('00000000-0000-0000-0000-000000001001', 4, '08:00', '20:00'),
('00000000-0000-0000-0000-000000001001', 5, '08:00', '20:00'),

-- Giornale lunes-viernes
('00000000-0000-0000-0000-000000001002', 1, '07:30', '19:00'),
('00000000-0000-0000-0000-000000001002', 2, '07:30', '19:00'),
('00000000-0000-0000-0000-000000001002', 3, '07:30', '19:00'),
('00000000-0000-0000-0000-000000001002', 4, '07:30', '19:00'),
('00000000-0000-0000-0000-000000001002', 5, '07:30', '19:00'),

-- Puerta 10 lunes-viernes
('00000000-0000-0000-0000-000000001003', 1, '06:00', '22:00'),
('00000000-0000-0000-0000-000000001003', 2, '06:00', '22:00'),
('00000000-0000-0000-0000-000000001003', 3, '06:00', '22:00'),
('00000000-0000-0000-0000-000000001003', 4, '06:00', '22:00'),
('00000000-0000-0000-0000-000000001003', 5, '06:00', '22:00');

-- Navigation nodes
INSERT INTO navigation_nodes (
  id, campus_id, building_id, name, node_type, floor, orientation_hint, localization_hint
)
VALUES
(
  '00000000-0000-0000-0000-000000003001',
  '00000000-0000-0000-0000-000000000001',
  '00000000-0000-0000-0000-000000000101',
  'Nodo frente a Laboratorio L',
  'place_anchor',
  '1',
  'Mirando hacia el pasillo principal',
  'Frente a la puerta del laboratorio L'
),
(
  '00000000-0000-0000-0000-000000003002',
  '00000000-0000-0000-0000-000000000001',
  '00000000-0000-0000-0000-000000000101',
  'Nodo pasillo Laboratorio L',
  'hallway',
  '1',
  'Mirando hacia la zona de comida',
  'Pasillo principal del edificio L'
),
(
  '00000000-0000-0000-0000-000000003003',
  '00000000-0000-0000-0000-000000000001',
  '00000000-0000-0000-0000-000000000102',
  'Nodo entrada Giornale',
  'place_anchor',
  '1',
  'Mirando hacia la entrada del restaurante',
  'Frente a Giornale'
);

-- Place to navigation node
INSERT INTO place_navigation_nodes (
  place_id, navigation_node_id, role
)
VALUES
(
  '00000000-0000-0000-0000-000000001001',
  '00000000-0000-0000-0000-000000003001',
  'front_door'
),
(
  '00000000-0000-0000-0000-000000001002',
  '00000000-0000-0000-0000-000000003003',
  'front_door'
);

-- Navigation edges
INSERT INTO navigation_edges (
  id, from_node_id, to_node_id, duration_seconds, bidirectional, edge_type, status
)
VALUES
(
  '00000000-0000-0000-0000-000000004001',
  '00000000-0000-0000-0000-000000003001',
  '00000000-0000-0000-0000-000000003002',
  35,
  true,
  'hallway',
  'active'
),
(
  '00000000-0000-0000-0000-000000004002',
  '00000000-0000-0000-0000-000000003002',
  '00000000-0000-0000-0000-000000003003',
  90,
  true,
  'walk',
  'active'
);

-- Route segments
INSERT INTO route_segments (
  edge_id,
  segment_key,
  route_file_name,
  instruction_key,
  expected_duration_seconds,
  start_orientation_hint,
  end_orientation_hint,
  robot_mode,
  reversible
)
VALUES
(
  '00000000-0000-0000-0000-000000004001',
  'laboratorio_l_to_pasillo_l',
  'laboratorio_l_to_pasillo_l.csv',
  'laboratorio_l_to_pasillo_l',
  35,
  'Iniciar frente al Laboratorio L mirando hacia el pasillo.',
  'Terminar en el pasillo principal mirando hacia la zona de comida.',
  'follow_recorded_route',
  false
),
(
  '00000000-0000-0000-0000-000000004002',
  'pasillo_l_to_giornale',
  'pasillo_l_to_giornale.csv',
  'pasillo_l_to_giornale',
  90,
  'Iniciar en pasillo del Laboratorio L mirando hacia la zona de comida.',
  'Terminar frente a Giornale.',
  'follow_recorded_route',
  false
);

-- Semantic documents without real embeddings yet
INSERT INTO semantic_documents (
  entity_type, entity_id, title, content, metadata, embedding_model
)
VALUES
(
  'place',
  '00000000-0000-0000-0000-000000001001',
  'Laboratorio L',
  'Laboratorio L es un espacio tranquilo con computadoras, proyector, pizarrón y contactos eléctricos. Es ideal para estudiar, trabajar o hacer prácticas técnicas.',
  '{"source": "seed"}',
  null
),
(
  'place',
  '00000000-0000-0000-0000-000000001002',
  'Giornale',
  'Giornale es un restaurante casual dentro del campus. Vende café, bebidas y comida como paninis. Es útil para comer, reunirse o tomar café.',
  '{"source": "seed"}',
  null
),
(
  'place',
  '00000000-0000-0000-0000-000000001003',
  'Puerta 10',
  'Puerta 10 es una entrada y salida peatonal del campus. Conecta con Vasco de Quiroga y Prolongación Paseo de la Reforma. Requiere credencial para entrar.',
  '{"source": "seed"}',
  null
);