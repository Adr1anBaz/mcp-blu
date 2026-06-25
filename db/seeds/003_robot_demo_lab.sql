-- =============================================================
-- 003_robot_demo_lab.sql
-- Tres salones adicionales dentro del Edificio L para el demo MVP
-- del robot: navegacion salon-a-salon con diferentes amenidades
-- y horarios.
--
-- Salones:
--   1. Salon L-A Proyeccion        (classroom, proyectores)
--   2. Salon L-B Motion Capture    (lab, camaras VICON)
--   3. Salon L-C Computo           (lab, workstations GPU)
--
-- Notas:
--   - Pensado para correr DESPUES de 002_rich_seed.sql.
--   - Usa ON CONFLICT para el periodo academico y la categoria
--     "Salon" / "Laboratorio" para que sea idempotente.
-- =============================================================

-- Periodo academico (idempotente: lo reusa si 002 ya lo creo)
INSERT INTO academic_terms (id, name, starts_on, ends_on, active) VALUES
  ('00000000-0000-0000-0000-000000005001', 'Otono 2026', '2026-08-03', '2026-12-11', TRUE)
  ON CONFLICT (id) DO NOTHING;

-- Categorias (idempotente)
INSERT INTO categories (id, name, parent_id) VALUES
  ('00000000-0000-0000-0000-000000011031', 'Salon', NULL),
  ('00000000-0000-0000-0000-000000011032', 'Laboratorio', NULL)
  ON CONFLICT (id) DO NOTHING;

-- =============================================================
-- 1. Lugares (los 3 salones, todos en Edificio L = ...0101)
-- =============================================================
INSERT INTO places (id, campus_id, building_id, name, type, description, floor, room_code, status, metadata) VALUES
  ('00000000-0000-0000-0000-000000002601', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000101', 'Salon L-A Proyeccion', 'classroom', 'Salon con proyector 4K, pantalla motorizada, sistema de audio y pizarrón blanco. Pensado para presentaciones, seminarios y defensas de tesis.', '1', 'L-A', 'active', '{"uso": "presentaciones", "ideal_para": ["defensas", "seminarios", "clases magistrales"]}'),
  ('00000000-0000-0000-0000-000000002602', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000101', 'Salon L-B Motion Capture', 'lab', 'Laboratorio con sistema VICON de captura de movimiento: 12 camaras infrarrojas, volumen de captura 4x4x3 m, marcadores reflectantes y software VICON Nexus.', '1', 'L-B', 'active', '{"uso": "motion capture", "sistema": "VICON", "ideal_para": ["biomecanica", "robotica", "animacion", "validacion de trayectorias"]}'),
  ('00000000-0000-0000-0000-000000002603', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000101', 'Salon L-C Computo', 'lab', 'Laboratorio con 20 workstations de alto rendimiento: GPU NVIDIA RTX 4090, CPU i9-13900K, 64 GB RAM, 2 TB NVMe, doble monitor 27".', '1', 'L-C', 'active', '{"uso": "computo de alto rendimiento", "ideal_para": ["entrenamiento de modelos", "simulacion", "vision por computadora", "renderizado"]}');

-- =============================================================
-- 2. Perfiles de cuarto (equipos, capacidad, reservable)
-- =============================================================
INSERT INTO room_profiles (place_id, room_type, capacity, equipment, reservable, notes) VALUES
  ('00000000-0000-0000-0000-000000002601', 'classroom', 40, '{"projector": true, "projector_resolution": "4K", "screen_motorized": true, "speakers": true, "hdmi": true, "whiteboard": true, "power_outlets": true, "wifi": true}', TRUE, 'Reservable para defensas y seminarios. Avisar con 24h.'),
  ('00000000-0000-0000-0000-000000002602', 'lab', 15, '{"vicon_cameras": 12, "vicon_model": "Vantage V5", "vicon_capture_volume_m": {"x": 4, "y": 4, "z": 3}, "reflective_markers": 200, "vicon_software": "VICON Nexus", "calibration_wand": true, "force_plates": 2, "whiteboard": true, "power_outlets": true}', FALSE, 'Sistema VICON listo para captura. Requiere calibracion antes de cada sesion.'),
  ('00000000-0000-0000-0000-000000002603', 'lab', 20, '{"workstations": 20, "gpu": "NVIDIA RTX 4090", "vram_gb": 24, "cpu": "Intel i9-13900K", "ram_gb": 64, "storage_tb": 2, "storage_type": "NVMe", "monitors_per_ws": 2, "monitor_size_in": 27, "os": "Ubuntu 22.04", "cuda": "12.x", "whiteboard": true, "power_outlets": true}', TRUE, 'Workstations pensadas para entrenamiento de redes neuronales y simulacion. Reservable fuera de horario de clase.');

-- Categorias por salon
INSERT INTO place_categories (place_id, category_id) VALUES
  ('00000000-0000-0000-0000-000000002601', '00000000-0000-0000-0000-000000011031'),
  ('00000000-0000-0000-0000-000000002602', '00000000-0000-0000-0000-000000011032'),
  ('00000000-0000-0000-0000-000000002603', '00000000-0000-0000-0000-000000011032');

-- =============================================================
-- 3. Horarios de apertura (lun a vie 08:00-20:00, sab 09:00-14:00)
-- =============================================================
INSERT INTO opening_hours (place_id, day_of_week, opens_at, closes_at) VALUES
  ('00000000-0000-0000-0000-000000002601', 1, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000002601', 2, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000002601', 3, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000002601', 4, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000002601', 5, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000002601', 6, '09:00', '14:00'),
  ('00000000-0000-0000-0000-000000002602', 1, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000002602', 2, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000002602', 3, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000002602', 4, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000002602', 5, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000002603', 1, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000002603', 2, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000002603', 3, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000002603', 4, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000002603', 5, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000002603', 6, '09:00', '14:00');

-- =============================================================
-- 4. Eventos (clases) - Otono 2026
--    L-A: Lunes 09:00-11:00  (Presentaciones y Seminarios)
--    L-B: Martes 10:00-12:00 (Lab Motion Capture)
--    L-C: Miercoles 14:00-16:00 (Computo de alto rendimiento)
--    -> En cualquier horario, maximo un salon esta ocupado.
-- =============================================================
INSERT INTO room_events (id, place_id, academic_term_id, title, event_type, starts_at, ends_at, recurrence_rule, source, notes) VALUES
  -- Salon L-A: Lunes 09:00-11:00 (Presentaciones)
  ('00000000-0000-0000-0000-000000006101', '00000000-0000-0000-0000-000000002601', '00000000-0000-0000-0000-000000005001', 'Presentaciones y Seminarios', 'class', '2026-08-10 09:00:00', '2026-08-10 11:00:00', 'WEEKLY:MO', 'registro escolar', 'Seminarios de alumnos. Salon L-A Proyeccion.'),
  ('00000000-0000-0000-0000-000000006102', '00000000-0000-0000-0000-000000002601', '00000000-0000-0000-0000-000000005001', 'Presentaciones y Seminarios', 'class', '2026-08-17 09:00:00', '2026-08-17 11:00:00', 'WEEKLY:MO', 'registro escolar', 'Seminarios de alumnos. Salon L-A Proyeccion.'),
  ('00000000-0000-0000-0000-000000006103', '00000000-0000-0000-0000-000000002601', '00000000-0000-0000-0000-000000005001', 'Defensa de Tesis - M. Hernandez', 'exam', '2026-08-24 09:00:00', '2026-08-24 11:00:00', null, 'registro escolar', 'Defensa de tesis. Salon L-A Proyeccion.'),

  -- Salon L-B: Martes 10:00-12:00 (Motion Capture)
  ('00000000-0000-0000-0000-000000006104', '00000000-0000-0000-0000-000000002602', '00000000-0000-0000-0000-000000005001', 'Lab Motion Capture', 'class', '2026-08-11 10:00:00', '2026-08-11 12:00:00', 'WEEKLY:TU', 'registro escolar', 'Practica con sistema VICON. Salon L-B.'),
  ('00000000-0000-0000-0000-000000006105', '00000000-0000-0000-0000-000000002602', '00000000-0000-0000-0000-000000005001', 'Lab Motion Capture', 'class', '2026-08-18 10:00:00', '2026-08-18 12:00:00', 'WEEKLY:TU', 'registro escolar', 'Practica con sistema VICON. Salon L-B.'),
  ('00000000-0000-0000-0000-000000006106', '00000000-0000-0000-0000-000000002602', '00000000-0000-0000-0000-000000005001', 'Calibracion VICON', 'maintenance', '2026-08-25 08:00:00', '2026-08-25 10:00:00', null, 'mantenimiento', 'Calibracion del sistema VICON. Cerrado ese dia.'),

  -- Salon L-C: Miercoles 14:00-16:00 (Computo)
  ('00000000-0000-0000-0000-000000006107', '00000000-0000-0000-0000-000000002603', '00000000-0000-0000-0000-000000005001', 'Computo Alto Rendimiento', 'class', '2026-08-12 14:00:00', '2026-08-12 16:00:00', 'WEEKLY:WE', 'registro escolar', 'Entrenamiento de modelos. Salon L-C.'),
  ('00000000-0000-0000-0000-000000006108', '00000000-0000-0000-0000-000000002603', '00000000-0000-0000-0000-000000005001', 'Computo Alto Rendimiento', 'class', '2026-08-19 14:00:00', '2026-08-19 16:00:00', 'WEEKLY:WE', 'registro escolar', 'Entrenamiento de modelos. Salon L-C.');

-- =============================================================
-- 5. Grafo de navegacion para el demo del robot
--    Topologia: pasillo existente (3002) -> sub-pasillo L (7101)
--                                       -> Salon L-A (7102)
--                                       -> Salon L-B (7103)
--                                       -> Salon L-C (7104)
-- =============================================================
INSERT INTO navigation_nodes (id, campus_id, building_id, name, node_type, floor, orientation_hint, localization_hint) VALUES
  ('00000000-0000-0000-0000-000000007101', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000101', 'Pasillo Salon L', 'hallway', '1', 'Mirando hacia los nuevos salones del Edificio L', 'Sub-pasillo dentro del Edificio L, conecta los 3 salones del demo'),
  ('00000000-0000-0000-0000-000000007102', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000101', 'Entrada Salon L-A Proyeccion', 'place_anchor', '1', 'Mirando hacia la puerta del salon L-A', 'Frente a la puerta del Salon L-A Proyeccion'),
  ('00000000-0000-0000-0000-000000007103', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000101', 'Entrada Salon L-B Motion Capture', 'place_anchor', '1', 'Mirando hacia la puerta del salon L-B', 'Frente a la puerta del Salon L-B VICON'),
  ('00000000-0000-0000-0000-000000007104', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000101', 'Entrada Salon L-C Computo', 'place_anchor', '1', 'Mirando hacia la puerta del salon L-C', 'Frente a la puerta del Salon L-C Computo');

-- Vincular places con sus nodos
INSERT INTO place_navigation_nodes (place_id, navigation_node_id, role) VALUES
  ('00000000-0000-0000-0000-000000002601', '00000000-0000-0000-0000-000000007102', 'front_door'),
  ('00000000-0000-0000-0000-000000002602', '00000000-0000-0000-0000-000000007103', 'front_door'),
  ('00000000-0000-0000-0000-000000002603', '00000000-0000-0000-0000-000000007104', 'front_door');

-- Aristas (todas bidireccionales para simplificar ruteo del robot)
INSERT INTO navigation_edges (id, from_node_id, to_node_id, distance_meters, bidirectional, edge_type, status) VALUES
  -- pasillo principal Edificio L -> sub-pasillo Salon L
  ('00000000-0000-0000-0000-000000008101', '00000000-0000-0000-0000-000000003002', '00000000-0000-0000-0000-000000007101', 8.00, TRUE, 'hallway', 'active'),
  -- sub-pasillo Salon L -> cada salon
  ('00000000-0000-0000-0000-000000008102', '00000000-0000-0000-0000-000000007101', '00000000-0000-0000-0000-000000007102', 5.00, TRUE, 'hallway', 'active'),
  ('00000000-0000-0000-0000-000000008103', '00000000-0000-0000-0000-000000007101', '00000000-0000-0000-0000-000000007103', 8.00, TRUE, 'hallway', 'active'),
  ('00000000-0000-0000-0000-000000008104', '00000000-0000-0000-0000-000000007101', '00000000-0000-0000-0000-000000007104', 10.00, TRUE, 'hallway', 'active');

-- Route segments (tramos que el robot puede ejecutar)
INSERT INTO route_segments (edge_id, segment_key, route_file_name, instruction_key, expected_duration_seconds, start_orientation_hint, end_orientation_hint, robot_mode, reversible) VALUES
  ('00000000-0000-0000-0000-000000008101', 'pasillo_l_to_pasillo_salon_l', 'pasillo_l_to_pasillo_salon_l.csv', 'pasillo_l_to_pasillo_salon_l', 20, 'Iniciar en el pasillo principal del Edificio L mirando al sub-pasillo.', 'Terminar en el sub-pasillo Salon L.', 'follow_recorded_route', FALSE),
  ('00000000-0000-0000-0000-000000008102', 'pasillo_salon_l_to_la', 'pasillo_salon_l_to_la.csv', 'pasillo_salon_l_to_la', 15, 'Iniciar en el sub-pasillo Salon L mirando al Salon L-A.', 'Terminar frente al Salon L-A Proyeccion.', 'follow_recorded_route', FALSE),
  ('00000000-0000-0000-0000-000000008103', 'pasillo_salon_l_to_lb', 'pasillo_salon_l_to_lb.csv', 'pasillo_salon_l_to_lb', 20, 'Iniciar en el sub-pasillo Salon L mirando al Salon L-B.', 'Terminar frente al Salon L-B Motion Capture.', 'follow_recorded_route', FALSE),
  ('00000000-0000-0000-0000-000000008104', 'pasillo_salon_l_to_lc', 'pasillo_salon_l_to_lc.csv', 'pasillo_salon_l_to_lc', 25, 'Iniciar en el sub-pasillo Salon L mirando al Salon L-C.', 'Terminar frente al Salon L-C Computo.', 'follow_recorded_route', FALSE);

-- =============================================================
-- 6. Documentos semanticos (descripciones naturales para el agente)
-- =============================================================
INSERT INTO semantic_documents (entity_type, entity_id, title, content, metadata, embedding_model) VALUES
  ('place', '00000000-0000-0000-0000-000000002601', 'Salon L-A Proyeccion', 'El Salon L-A es un salon del Edificio L pensado para presentaciones, seminarios y defensas de tesis. Cuenta con proyector 4K, pantalla motorizada, sistema de audio, pizarrón blanco, HDMI, tomacorrientes y wifi. Capacidad para 40 personas. Se puede reservar fuera del horario de clase.', '{"source": "seed", "amenities": ["proyector 4K", "audio", "pantalla motorizada", "wifi", "HDMI"]}', NULL),
  ('place', '00000000-0000-0000-0000-000000002602', 'Salon L-B Motion Capture', 'El Salon L-B es un laboratorio del Edificio L equipado con un sistema VICON de captura de movimiento. Tiene 12 camaras VICON Vantage V5, volumen de captura de 4x4x3 metros, 200 marcadores reflectantes, software VICON Nexus, dos plataformas de fuerza y herramientas de calibracion. Ideal para biomecanica, robotica, validacion de trayectorias y animacion. Capacidad 15 personas. Requiere calibracion antes de cada sesion.', '{"source": "seed", "amenities": ["VICON", "motion capture", "camaras infrarrojas", "plataformas de fuerza", "marcadores reflectantes"]}', NULL),
  ('place', '00000000-0000-0000-0000-000000002603', 'Salon L-C Computo', 'El Salon L-C es un laboratorio del Edificio L con 20 workstations de alto rendimiento equipadas con GPU NVIDIA RTX 4090 (24 GB VRAM), CPU Intel i9-13900K, 64 GB de RAM, 2 TB NVMe, doble monitor de 27 pulgadas y Ubuntu 22.04 con CUDA 12. Pensado para entrenamiento de redes neuronales, simulacion, vision por computadora y renderizado. Capacidad 20 personas. Reservable fuera de horario de clase.', '{"source": "seed", "amenities": ["GPU RTX 4090", "64 GB RAM", "doble monitor", "Ubuntu", "CUDA"]}', NULL);
