-- =============================================================
-- 002_rich_seed.sql
-- Datos adicionales para demos del agente MCP
--
-- Contenido:
--   1. Edificios nuevos
--   2. Categorias y place_categories
--   3. Periodo academico activo
--   4. Restaurantes (8) con menus y platillos
--   5. Oficinas de profesores (8) + oficinas administrativas (3)
--   6. Salones y laboratorios (7)
--   7. Tiendas y productos
--   8. Areas comunes
--   9. Horarios de apertura
--  10. Eventos en salones (clases) para Otono 2026
--  11. Niveles de afluencia
--  12. Nodos y aristas de navegacion adicionales
--  13. Documentos semanticos
-- =============================================================

-- =============================================================
-- 1. Edificios
-- =============================================================
INSERT INTO buildings (id, campus_id, name, code, description) VALUES
  ('00000000-0000-0000-0000-000000000201', '00000000-0000-0000-0000-000000000001', 'Edificio A', 'A', 'Edificio de Ingenierias: oficinas de profesores, salones y laboratorios de control, robotica y circuitos.'),
  ('00000000-0000-0000-0000-000000000202', '00000000-0000-0000-0000-000000000001', 'Edificio B', 'B', 'Edificio Academico con salones, aulas multimedia y oficinas del area de computacion.'),
  ('00000000-0000-0000-0000-000000000203', '00000000-0000-0000-0000-000000000001', 'Biblioteca Central', 'LIB', 'Biblioteca con acervo general, salas de estudio silenciosas y cubiculos individuales.'),
  ('00000000-0000-0000-0000-000000000204', '00000000-0000-0000-0000-000000000001', 'Centro de Investigacion', 'CI', 'Centro dedicado a proyectos de investigacion y laboratorio de prototipos.');

-- =============================================================
-- 2. Categorias
-- =============================================================
INSERT INTO categories (id, name, parent_id) VALUES
  ('00000000-0000-0000-0000-000000011001', 'Comida', NULL),
  ('00000000-0000-0000-0000-000000011002', 'Cafe', '00000000-0000-0000-0000-000000011001'),
  ('00000000-0000-0000-0000-000000011003', 'Comida Mexicana', '00000000-0000-0000-0000-000000011001'),
  ('00000000-0000-0000-0000-000000011004', 'Comida Japonesa', '00000000-0000-0000-0000-000000011001'),
  ('00000000-0000-0000-0000-000000011005', 'Comida China', '00000000-0000-0000-0000-000000011001'),
  ('00000000-0000-0000-0000-000000011006', 'Comida Italiana', '00000000-0000-0000-0000-000000011001'),
  ('00000000-0000-0000-0000-000000011007', 'Sandwiches', '00000000-0000-0000-0000-000000011001'),
  ('00000000-0000-0000-0000-000000011008', 'Vegetariano', '00000000-0000-0000-0000-000000011001'),
  ('00000000-0000-0000-0000-000000011009', 'Comida Corrida', '00000000-0000-0000-0000-000000011003'),

  ('00000000-0000-0000-0000-000000011020', 'Comercio', NULL),
  ('00000000-0000-0000-0000-000000011021', 'Papeleria', '00000000-0000-0000-0000-000000011020'),
  ('00000000-0000-0000-0000-000000011022', 'Tienda de Conveniencia', '00000000-0000-0000-0000-000000011020'),

  ('00000000-0000-0000-0000-000000011030', 'Espacio Academico', NULL),
  ('00000000-0000-0000-0000-000000011031', 'Salon', '00000000-0000-0000-0000-000000011030'),
  ('00000000-0000-0000-0000-000000011032', 'Laboratorio', '00000000-0000-0000-0000-000000011030'),

  ('00000000-0000-0000-0000-000000011040', 'Atencion y Servicios', NULL),
  ('00000000-0000-0000-0000-000000011041', 'Servicios Escolares', '00000000-0000-0000-0000-000000011040'),
  ('00000000-0000-0000-0000-000000011042', 'Becas', '00000000-0000-0000-0000-000000011040'),
  ('00000000-0000-0000-0000-000000011043', 'Atencion a Profesores', '00000000-0000-0000-0000-000000011040');

-- =============================================================
-- 3. Periodo academico activo
-- =============================================================
INSERT INTO academic_terms (id, name, starts_on, ends_on, active) VALUES
  ('00000000-0000-0000-0000-000000005001', 'Otono 2026', '2026-08-03', '2026-12-11', TRUE);

-- =============================================================
-- 4. Restaurantes
-- =============================================================
INSERT INTO places (id, campus_id, building_id, name, type, description, floor, room_code, status, metadata) VALUES
  ('00000000-0000-0000-0000-000000001201', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000102', 'Tacos Don Julio', 'restaurant', 'Taqueria mexicana con tacos al pastor, suadero, carnitas y tortas. Servicio rapido para llevar.', '1', 'FOOD-1', 'active', '{"ambiente": "casual", "ideal_para": ["comer rapido", "antojitos"], "ruido": "alto", "estilo": "mexicano callejero"}'),
  ('00000000-0000-0000-0000-000000001202', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000102', 'Sushi Nagoya', 'restaurant', 'Restaurante de comida japonesa con sushi, ramen, nigiri y gyozas. Opcion popular para sentarse a comer.', '1', 'FOOD-2', 'active', '{"ambiente": "tranquilo", "ideal_para": ["sentarse a comer", "reuniones"], "ruido": "bajo", "estilo": "japones tradicional"}'),
  ('00000000-0000-0000-0000-000000001203', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000102', 'Dragon Dorado', 'restaurant', 'Comida china con chow mein, kung pao, dim sum y pato pekines. Porciones generosas.', '1', 'FOOD-3', 'active', '{"ambiente": "familiar", "ideal_para": ["comer en grupo"], "ruido": "medio", "estilo": "chino cantonés"}'),
  ('00000000-0000-0000-0000-000000001204', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000102', 'Cafe Borrego', 'restaurant', 'Cafeteria con espresso, capuchino, reposteria, sandwiches y opciones frias como frappes.', '1', 'FOOD-4', 'active', '{"ambiente": "acogedor", "ideal_para": ["estudiar", "trabajar", "tomar cafe"], "ruido": "bajo", "estilo": "cafeteria de especialidad", "wifi": true}'),
  ('00000000-0000-0000-0000-000000001205', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000102', 'La Bella Italia', 'restaurant', 'Comida italiana con pizzas a la piedra, pastas frescas, risottos y postres clasicos como tiramisu.', '1', 'FOOD-5', 'active', '{"ambiente": "romantico", "ideal_para": ["citas", "cenas"], "ruido": "bajo", "estilo": "italiano tradicional"}'),
  ('00000000-0000-0000-0000-000000001206', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000102', 'Green Bowl', 'restaurant', 'Opciones vegetarianas y saludables: buddha bowls, wraps, ensaladas, smoothies y jugos naturales.', '1', 'FOOD-6', 'active', '{"ambiente": "moderno", "ideal_para": ["comer saludable", "vegetarianos"], "ruido": "bajo", "estilo": "vegano y saludable"}'),
  ('00000000-0000-0000-0000-000000001207', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000102', 'El Rincon del Sabor', 'restaurant', 'Comida corrida mexicana con sopa, arroz, guisado, agua y postre a precio fijo.', '1', 'FOOD-7', 'active', '{"ambiente": "casual", "ideal_para": ["comida corrida", "presupuesto bajo"], "ruido": "medio", "estilo": "fonda mexicana"}'),
  ('00000000-0000-0000-0000-000000001208', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000102', 'Subway Campus', 'restaurant', 'Sandwiches personalizables de 15cm, ensaladas, combos y bebidas. Servicio rapido.', '1', 'FOOD-8', 'active', '{"ambiente": "moderno", "ideal_para": ["comer rapido", "para llevar"], "ruido": "bajo", "estilo": "fast casual"}');

-- Restaurant profiles
INSERT INTO restaurant_profiles (place_id, cuisine_type, average_price, payment_methods, accepts_card, notes) VALUES
  ('00000000-0000-0000-0000-000000001201', 'mexicana', 75, '["cash", "card", "transfer"]', TRUE, 'Mejor hora para evitar fila: antes de las 13:00.'),
  ('00000000-0000-0000-0000-000000001202', 'japonesa', 160, '["cash", "card"]', TRUE, 'Acepta reservaciones para grupos de 6 o mas.'),
  ('00000000-0000-0000-0000-000000001203', 'china', 140, '["cash", "card"]', TRUE, 'Porciones para compartir, recomendado ir en grupo.'),
  ('00000000-0000-0000-0000-000000001204', 'cafe y reposteria', 80, '["cash", "card", "app"]', TRUE, 'Wifi gratuito y tomacorrientes en cada mesa.'),
  ('00000000-0000-0000-0000-000000001205', 'italiana', 170, '["cash", "card"]', TRUE, 'Ideal para cenas y reuniones pequenas.'),
  ('00000000-0000-0000-0000-000000001206', 'vegetariana/vegana', 110, '["cash", "card"]', TRUE, 'Opciones sin gluten disponibles.'),
  ('00000000-0000-0000-0000-000000001207', 'mexicana - comida corrida', 95, '["cash"]', FALSE, 'Solo efectivo. Menu cambia diario.'),
  ('00000000-0000-0000-0000-000000001208', 'sandwiches', 100, '["cash", "card"]', TRUE, 'Combo del dia incluye papas y bebida.');

-- Categorias por restaurante
INSERT INTO place_categories (place_id, category_id) VALUES
  ('00000000-0000-0000-0000-000000001201', '00000000-0000-0000-0000-000000011003'),
  ('00000000-0000-0000-0000-000000001202', '00000000-0000-0000-0000-000000011004'),
  ('00000000-0000-0000-0000-000000001203', '00000000-0000-0000-0000-000000011005'),
  ('00000000-0000-0000-0000-000000001204', '00000000-0000-0000-0000-000000011002'),
  ('00000000-0000-0000-0000-000000001205', '00000000-0000-0000-0000-000000011006'),
  ('00000000-0000-0000-0000-000000001206', '00000000-0000-0000-0000-000000011008'),
  ('00000000-0000-0000-0000-000000001207', '00000000-0000-0000-0000-000000011009'),
  ('00000000-0000-0000-0000-000000001208', '00000000-0000-0000-0000-000000011007');

-- Menus (uno por restaurante)
INSERT INTO menus (id, place_id, name, description, active) VALUES
  ('00000000-0000-0000-0000-000000002101', '00000000-0000-0000-0000-000000001201', 'Menu principal', 'Tacos, tortas, bebidas y antojitos mexicanos.', TRUE),
  ('00000000-0000-0000-0000-000000002102', '00000000-0000-0000-0000-000000001202', 'Menu principal', 'Sushi, nigiri, ramen, entradas y bebidas.', TRUE),
  ('00000000-0000-0000-0000-000000002103', '00000000-0000-0000-0000-000000001203', 'Menu principal', 'Platos fuertes chinos, dim sum, sopas y bebidas.', TRUE),
  ('00000000-0000-0000-0000-000000002104', '00000000-0000-0000-0000-000000001204', 'Menu principal', 'Cafe de especialidad, bebidas frias, reposteria y sandwiches.', TRUE),
  ('00000000-0000-0000-0000-000000002105', '00000000-0000-0000-0000-000000001205', 'Menu principal', 'Pizzas, pastas, entradas y postre.', TRUE),
  ('00000000-0000-0000-0000-000000002106', '00000000-0000-0000-0000-000000001206', 'Menu principal', 'Bowls, ensaladas, smoothies y opciones veganas.', TRUE),
  ('00000000-0000-0000-0000-000000002107', '00000000-0000-0000-0000-000000001207', 'Menu del dia', 'Comida corrida: sopa, arroz, guisado, agua y postre.', TRUE),
  ('00000000-0000-0000-0000-000000002108', '00000000-0000-0000-0000-000000001208', 'Menu principal', 'Sandwiches personalizables, ensaladas y combos.', TRUE);

-- =============================================================
-- Platillos por restaurante
-- =============================================================

-- Tacos Don Julio
INSERT INTO menu_items (menu_id, name, description, category, price, currency, dietary_tags, available) VALUES
  ('00000000-0000-0000-0000-000000002101', 'Tacos al pastor (3 pzas)', 'Tacos de tortilla de maiz con carne de pastor, pina, cebolla y cilantro.', 'tacos', 65, 'MXN', '["no vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002101', 'Tacos de suadero (3 pzas)', 'Tacos de suadero con cebolla y cilantro.', 'tacos', 60, 'MXN', '["no vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002101', 'Tacos de carnitas (3 pzas)', 'Tacos de carnitas con salsa verde.', 'tacos', 65, 'MXN', '["no vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002101', 'Quesadilla de queso', 'Quesadilla de maiz con queso Oaxaca.', 'antojitos', 45, 'MXN', '["vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002101', 'Gringa de pastor', 'Tortilla de harina con queso y pastor.', 'antojitos', 75, 'MXN', '["no vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002101', 'Torta de milanesa', 'Torta con milanesa de res, jitomate, aguacate y frijoles.', 'tortas', 85, 'MXN', '["no vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002101', 'Guacamole con totopos', 'Porcion de guacamole con totopos.', 'entrada', 55, 'MXN', '["vegetariano", "vegano"]', TRUE),
  ('00000000-0000-0000-0000-000000002101', 'Agua de horchata', 'Agua fresca de horchata, vaso de 500ml.', 'bebida', 30, 'MXN', '["vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002101', 'Refresco de cola', 'Refresco de cola en botella.', 'bebida', 25, 'MXN', '["vegetariano"]', TRUE);

-- Sushi Nagoya
INSERT INTO menu_items (menu_id, name, description, category, price, currency, dietary_tags, available) VALUES
  ('00000000-0000-0000-0000-000000002102', 'Roll Philadelphia (8 pzas)', 'Roll de salmon, queso crema y aguacate.', 'roll', 135, 'MXN', '["pescado"]', TRUE),
  ('00000000-0000-0000-0000-000000002102', 'Roll Spicy Tuna (8 pzas)', 'Roll de atun con salsa spicy y ajonjoli.', 'roll', 145, 'MXN', '["pescado", "picante"]', TRUE),
  ('00000000-0000-0000-0000-000000002102', 'Nigiri de salmon (2 pzas)', 'Bola de arroz con salmon fresco encima.', 'nigiri', 85, 'MXN', '["pescado"]', TRUE),
  ('00000000-0000-0000-0000-000000002102', 'Nigiri de atun (2 pzas)', 'Bola de arroz con atun fresco.', 'nigiri', 90, 'MXN', '["pescado"]', TRUE),
  ('00000000-0000-0000-0000-000000002102', 'Ramen tonkotsu', 'Fideos en caldo de cerdo con huevo, cebollin y chashu.', 'plato fuerte', 165, 'MXN', '["no vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002102', 'Yakimeshi', 'Arroz frito estilo japones con verduras y huevo.', 'plato fuerte', 95, 'MXN', '["vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002102', 'Edamame', 'Vainas de edamame con sal marina.', 'entrada', 55, 'MXN', '["vegetariano", "vegano"]', TRUE),
  ('00000000-0000-0000-0000-000000002102', 'Gyozas de cerdo (5 pzas)', 'Empanadas japonesas de cerdo al vapor.', 'entrada', 75, 'MXN', '["no vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002102', 'Te verde', 'Te verde caliente en tetera pequena.', 'bebida', 35, 'MXN', '["vegetariano", "vegano"]', TRUE),
  ('00000000-0000-0000-0000-000000002102', 'Mochi de matcha (3 pzas)', 'Bolitas de arroz glutinoso con relleno de matcha.', 'postre', 60, 'MXN', '["vegetariano"]', TRUE);

-- Dragon Dorado
INSERT INTO menu_items (menu_id, name, description, category, price, currency, dietary_tags, available) VALUES
  ('00000000-0000-0000-0000-000000002103', 'Chow mein de res', 'Fideos salteados con res y verduras.', 'plato fuerte', 135, 'MXN', '["no vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002103', 'Kung pao chicken', 'Pollo troceado con cacahuates, chiles y verduras.', 'plato fuerte', 145, 'MXN', '["no vegetariano", "picante"]', TRUE),
  ('00000000-0000-0000-0000-000000002103', 'Pollo agridulce', 'Pieces de pollo empanizado en salsa agridulce.', 'plato fuerte', 155, 'MXN', '["no vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002103', 'Pato pekines (porcion)', 'Pato asado estilo pekines con panqueques.', 'plato fuerte', 245, 'MXN', '["no vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002103', 'Arroz frito cantonés', 'Arroz frito con huevo, jamon y cebollin.', 'acompañamiento', 75, 'MXN', '["no vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002103', 'Rollos primavera (3 pzas)', 'Rollos primavera fritos con verduras.', 'entrada', 55, 'MXN', '["vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002103', 'Dim sum de cerdo (4 pzas)', 'Bollos al vapor rellenos de cerdo.', 'entrada', 85, 'MXN', '["no vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002103', 'Wonton soup', 'Sopa de wontones de cerdo en caldo claro.', 'sopa', 70, 'MXN', '["no vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002103', 'Te de jazmin', 'Te de jazmin caliente.', 'bebida', 30, 'MXN', '["vegetariano", "vegano"]', TRUE);

-- Cafe Borrego
INSERT INTO menu_items (menu_id, name, description, category, price, currency, dietary_tags, available) VALUES
  ('00000000-0000-0000-0000-000000002104', 'Espresso doble', 'Doble shot de espresso.', 'cafe', 40, 'MXN', '["vegetariano", "vegano"]', TRUE),
  ('00000000-0000-0000-0000-000000002104', 'Cappuccino', 'Espresso con leche vaporizada y espuma.', 'cafe', 55, 'MXN', '["vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002104', 'Latte vainilla', 'Cafe con leche y jarabe de vainilla.', 'cafe', 65, 'MXN', '["vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002104', 'Americano', 'Espresso diluido con agua caliente.', 'cafe', 45, 'MXN', '["vegetariano", "vegano"]', TRUE),
  ('00000000-0000-0000-0000-000000002104', 'Mocha', 'Espresso, leche vaporizada y chocolate.', 'cafe', 70, 'MXN', '["vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002104', 'Frappe de caramelo', 'Cafe frio batido con hielo y caramelo.', 'bebida fria', 75, 'MXN', '["vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002104', 'Smoothie de frutos rojos', 'Licuado de fresa, arandano y frambuesa.', 'bebida fria', 85, 'MXN', '["vegetariano", "vegano"]', TRUE),
  ('00000000-0000-0000-0000-000000002104', 'Croissant de almendras', 'Croissant hojaldrado con crema de almendras.', 'reposteria', 55, 'MXN', '["vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002104', 'Muffin de arandanos', 'Muffin esponjoso de arandanos.', 'reposteria', 45, 'MXN', '["vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002104', 'Sandwich de jamon y queso', 'Sandwich de pan artesanal con jamon, queso y vegetales.', 'comida', 85, 'MXN', '["no vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002104', 'Bagel con queso crema', 'Bagel tostado con queso crema y cebollin.', 'comida', 65, 'MXN', '["vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002104', 'Galleta de chispas de chocolate', 'Galleta casera con chispas de chocolate.', 'reposteria', 25, 'MXN', '["vegetariano"]', TRUE);

-- La Bella Italia
INSERT INTO menu_items (menu_id, name, description, category, price, currency, dietary_tags, available) VALUES
  ('00000000-0000-0000-0000-000000002105', 'Pizza margherita', 'Pizza con salsa de jitomate, mozzarella y albahaca.', 'pizza', 145, 'MXN', '["vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002105', 'Pizza pepperoni', 'Pizza con pepperoni y mozzarella.', 'pizza', 165, 'MXN', '["no vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002105', 'Spaghetti carbonara', 'Pasta con panceta, huevo y parmesano.', 'pasta', 155, 'MXN', '["no vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002105', 'Fettuccine alfredo', 'Pasta en salsa de crema y parmesano.', 'pasta', 145, 'MXN', '["vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002105', 'Lasagna bolognesa', 'Lasagna con carne molida, bechamel y queso.', 'pasta', 165, 'MXN', '["no vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002105', 'Risotto de hongos', 'Risotto cremoso con hongos mixtos.', 'plato fuerte', 175, 'MXN', '["vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002105', 'Bruschetta (3 pzas)', 'Pan tostado con jitomate, albahaca y aceite de oliva.', 'entrada', 75, 'MXN', '["vegetariano", "vegano"]', TRUE),
  ('00000000-0000-0000-0000-000000002105', 'Ensalada caprese', 'Ensalada de jitomate, mozzarella y albahaca.', 'entrada', 95, 'MXN', '["vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002105', 'Tiramisu', 'Postre italiano con cafe, mascarpone y cacao.', 'postre', 85, 'MXN', '["vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002105', 'Cannoli (2 pzas)', 'Cannoli sicilianos rellenos de ricotta.', 'postre', 65, 'MXN', '["vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002105', 'Limonada italiana', 'Limonada con jarabe y hierbabuena.', 'bebida', 45, 'MXN', '["vegetariano", "vegano"]', TRUE);

-- Green Bowl
INSERT INTO menu_items (menu_id, name, description, category, price, currency, dietary_tags, available) VALUES
  ('00000000-0000-0000-0000-000000002106', 'Buddha bowl de quinoa', 'Bowl con quinoa, garbanzos, aguacate, vegetales rostizados y aderezo.', 'plato fuerte', 135, 'MXN', '["vegetariano", "vegano", "sin gluten"]', TRUE),
  ('00000000-0000-0000-0000-000000002106', 'Ensalada Cesar vegana', 'Lechuga romana, crutones veganos, aderezo cesar y parmesano vegano.', 'ensalada', 115, 'MXN', '["vegetariano", "vegano"]', TRUE),
  ('00000000-0000-0000-0000-000000002106', 'Wrap de hummus y vegetales', 'Tortilla de espinaca con hummus, pimientos, espinaca y pepino.', 'plato fuerte', 95, 'MXN', '["vegetariano", "vegano"]', TRUE),
  ('00000000-0000-0000-0000-000000002106', 'Bowl de acai', 'Bowl con pure de acai, granola, platano y fresas.', 'desayuno', 125, 'MXN', '["vegetariano", "vegano"]', TRUE),
  ('00000000-0000-0000-0000-000000002106', 'Tostadas de aguacate', 'Pan integral con aguacate, huevo y semillas.', 'desayuno', 85, 'MXN', '["vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002106', 'Smoothie verde', 'Licuado de espinaca, manzana, jengibre y limon.', 'bebida', 75, 'MXN', '["vegetariano", "vegano"]', TRUE),
  ('00000000-0000-0000-0000-000000002106', 'Jugo de naranja natural', 'Jugo de naranja recien exprimido.', 'bebida', 45, 'MXN', '["vegetariano", "vegano"]', TRUE),
  ('00000000-0000-0000-0000-000000002106', 'Sopa de lentejas', 'Sopa casera de lentejas con verduras.', 'sopa', 85, 'MXN', '["vegetariano", "vegano", "sin gluten"]', TRUE),
  ('00000000-0000-0000-0000-000000002106', 'Tamal vegano de champiñones', 'Tamal de masa vegana relleno de champiñones.', 'antojito', 45, 'MXN', '["vegetariano", "vegano"]', TRUE),
  ('00000000-0000-0000-0000-000000002106', 'Brownie vegano', 'Brownie de chocolate sin ingredientes animales.', 'postre', 55, 'MXN', '["vegetariano", "vegano"]', TRUE);

-- El Rincon del Sabor
INSERT INTO menu_items (menu_id, name, description, category, price, currency, dietary_tags, available) VALUES
  ('00000000-0000-0000-0000-000000002107', 'Comida corrida del dia', 'Incluye sopa, arroz, guisado, agua del dia y postre.', 'menu', 95, 'MXN', '["no vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002107', 'Menu ejecutivo', 'Tres tiempos: entrada, plato fuerte y postre.', 'menu', 115, 'MXN', '["no vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002107', 'Sopa de fideo', 'Sopa de fideo con jitomate y pollo deshebrado.', 'entrada', 45, 'MXN', '["no vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002107', 'Sopa azteca', 'Sopa de tortilla con chile pasilla, aguacate y queso.', 'entrada', 50, 'MXN', '["vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002107', 'Arroz rojo', 'Porcion de arroz rojo a la mexicana.', 'acompañamiento', 25, 'MXN', '["vegetariano", "vegano"]', TRUE),
  ('00000000-0000-0000-0000-000000002107', 'Frijoles charros', 'Frijoles con chorizo y tocino.', 'acompañamiento', 35, 'MXN', '["no vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002107', 'Pollo en mole', 'Pierna y muslo de pollo en mole poblano.', 'plato fuerte', 85, 'MXN', '["no vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002107', 'Bistec a la mexicana', 'Bistec de res con jitomate, cebolla y chile.', 'plato fuerte', 95, 'MXN', '["no vegetariano", "picante"]', TRUE),
  ('00000000-0000-0000-0000-000000002107', 'Flan napolitano', 'Flan casero con caramelo.', 'postre', 45, 'MXN', '["vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002107', 'Agua de jamaica', 'Agua fresca de jamaica.', 'bebida', 25, 'MXN', '["vegetariano", "vegano"]', TRUE);

-- Subway Campus
INSERT INTO menu_items (menu_id, name, description, category, price, currency, dietary_tags, available) VALUES
  ('00000000-0000-0000-0000-000000002108', 'Sub Veggie (15cm)', 'Sandwich de vegetales frescos con aderezo a elegir.', 'sandwich', 85, 'MXN', '["vegetariano", "vegano"]', TRUE),
  ('00000000-0000-0000-0000-000000002108', 'Sub de pavo (15cm)', 'Sandwich de pavo con vegetales y aderezo.', 'sandwich', 95, 'MXN', '["no vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002108', 'Sub de pollo teriyaki (15cm)', 'Sandwich de pollo con salsa teriyaki y vegetales.', 'sandwich', 105, 'MXN', '["no vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002108', 'Sub italiano BMT (15cm)', 'Sandwich de pepperoni, jamon y salami con vegetales.', 'sandwich', 110, 'MXN', '["no vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002108', 'Sub de atun (15cm)', 'Sandwich de mezcla de atun con vegetales.', 'sandwich', 95, 'MXN', '["pescado"]', TRUE),
  ('00000000-0000-0000-0000-000000002108', 'Ensalada de pollo', 'Ensalada con pollo, vegetales y aderezo.', 'ensalada', 95, 'MXN', '["no vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002108', 'Papa horneada con queso', 'Papa horneada rellena de queso y brocoli.', 'acompañamiento', 55, 'MXN', '["vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002108', 'Combo sub + papas + bebida', 'Sub de 15cm, papas y bebida embotellada.', 'combo', 135, 'MXN', '["no vegetariano"]', TRUE),
  ('00000000-0000-0000-0000-000000002108', 'Agua embotellada', 'Agua embotellada 500ml.', 'bebida', 20, 'MXN', '["vegetariano", "vegano"]', TRUE),
  ('00000000-0000-0000-0000-000000002108', 'Galleta de chispas', 'Galleta de chispas de chocolate.', 'postre', 25, 'MXN', '["vegetariano"]', TRUE);

-- =============================================================
-- 5. Oficinas de profesores (8) y oficinas administrativas (3)
-- =============================================================
INSERT INTO places (id, campus_id, building_id, name, type, description, floor, room_code, status, metadata) VALUES
  ('00000000-0000-0000-0000-000000001301', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000201', 'Oficina del Dr. Roberto Sanchez Mendoza', 'office', 'Profesor titular del area de Control y Sistemas. Imparte Control Clasico y asesoria de proyectos terminales.', '3', 'A-301', 'active', '{"departamento": "Ingenieria de Control", "cubiculo": "A-301", "extension": "4501"}'),
  ('00000000-0000-0000-0000-000000001302', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000201', 'Oficina de la Dra. Maria Gonzalez Herrera', 'office', 'Profesora del area de Control Avanzado y Sistemas No Lineales. Atiende dudas y proyectos relacionados.', '3', 'A-302', 'active', '{"departamento": "Ingenieria de Control", "cubiculo": "A-302", "extension": "4502"}'),
  ('00000000-0000-0000-0000-000000001303', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000201', 'Oficina del Dr. Carlos Mendoza Ruiz', 'office', 'Profesor del area de Robotica. Imparte Robotica y Manipuladores, atiende proyectos de robotica movil y brazos roboticos.', '3', 'A-303', 'active', '{"departamento": "Ingenieria de Robotica", "cubiculo": "A-303", "extension": "4503"}'),
  ('00000000-0000-0000-0000-000000001304', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000202', 'Oficina de la Dra. Ana Lopez Vega', 'office', 'Profesora de Circuitos Digitales y Diseno Logico. Atiende dudas sobre FPGA, VHDL y proyectos de electronica digital.', '2', 'B-201', 'active', '{"departamento": "Ingenieria Electronica", "cubiculo": "B-201", "extension": "4520"}'),
  ('00000000-0000-0000-0000-000000001305', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000201', 'Oficina del Dr. Luis Ramirez Castro', 'office', 'Profesor de Sistemas Embebidos y Arquitectura de Computadoras. Atiende proyectos con microcontroladores.', '3', 'A-304', 'active', '{"departamento": "Ingenieria de Control", "cubiculo": "A-304", "extension": "4504"}'),
  ('00000000-0000-0000-0000-000000001306', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000202', 'Oficina de la Dra. Patricia Ruiz Ortega', 'office', 'Profesora de Inteligencia Artificial y Aprendizaje Maquina. Atiende proyectos de IA, redes neuronales y NLP.', '2', 'B-202', 'active', '{"departamento": "Ciencias de la Computacion", "cubiculo": "B-202", "extension": "4521"}'),
  ('00000000-0000-0000-0000-000000001307', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000201', 'Oficina del Dr. Fernando Torres Blanco', 'office', 'Profesor de Microcontroladores e Interfaces. Imparte laboratorio con Arduino, STM32 y ESP32.', '3', 'A-305', 'active', '{"departamento": "Ingenieria Electronica", "cubiculo": "A-305", "extension": "4505"}'),
  ('00000000-0000-0000-0000-000000001308', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000202', 'Oficina del Dr. Javier Navarro Fuentes', 'office', 'Profesor de Vision por Computadora y Procesamiento de Imagenes. Atiende proyectos con OpenCV y deep learning.', '2', 'B-203', 'active', '{"departamento": "Ciencias de la Computacion", "cubiculo": "B-203", "extension": "4522"}'),

  ('00000000-0000-0000-0000-000000001351', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000203', 'Servicios Escolares', 'department', 'Departamento de Servicios Escolares. Trámites de inscripción, reinscripción, constancias y kardex.', '1', 'LIB-101', 'active', '{"departamento": "Servicios Escolares", "extension": "4100"}'),
  ('00000000-0000-0000-0000-000000001352', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000203', 'Oficina de Becas y Financiamiento', 'department', 'Atención a trámites de becas, apoyos económicos y financiamiento educativo.', '1', 'LIB-102', 'active', '{"departamento": "Becas", "extension": "4101"}'),
  ('00000000-0000-0000-0000-000000001353', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000203', 'Mesa de Atencion Biblioteca', 'office', 'Atencion a usuarios de la biblioteca: prestamos, devoluciones, reservaciones de cubiculos y salas.', '1', 'LIB-001', 'active', '{"departamento": "Biblioteca", "extension": "4200"}');

-- Office profiles
INSERT INTO office_profiles (place_id, department_type, purpose, contact_email, phone, website_url, services) VALUES
  ('00000000-0000-0000-0000-000000001301', 'Academico - Control', 'Atencion a alumnos de Control Clasico, teoria de control y proyectos terminales del area. Horario de oficina: lunes y miercoles 12:00-14:00.', 'roberto.sanchez@universidad.edu', '+52 55 5555 4501', 'https://universidad.edu/control/sanchez', '["Control Clasico", "Teoria de Control", "Lun-Mie 12:00-14:00", "asesoria", "proyectos terminales"]'),
  ('00000000-0000-0000-0000-000000001302', 'Academico - Control', 'Atencion de Control Avanzado y Sistemas No Lineales. Horario de oficina: martes y jueves 12:00-14:00.', 'maria.gonzalez@universidad.edu', '+52 55 5555 4502', 'https://universidad.edu/control/gonzalez', '["Control Avanzado", "Sistemas No Lineales", "Mar-Jue 12:00-14:00", "asesoria", "proyectos"]'),
  ('00000000-0000-0000-0000-000000001303', 'Academico - Robotica', 'Atencion a alumnos de Robotica, manipuladores y proyectos de robotica movil. Horario de oficina: lunes y miercoles 14:00-16:00.', 'carlos.mendoza@universidad.edu', '+52 55 5555 4503', 'https://universidad.edu/robotica/mendoza', '["Robotica", "Manipuladores", "Lun-Mie 14:00-16:00", "brazos roboticos", "ROS", "asesoria"]'),
  ('00000000-0000-0000-0000-000000001304', 'Academico - Electronica', 'Atencion a alumnos de Circuitos Digitales, FPGA y VHDL. Horario de oficina: viernes 14:00-17:00.', 'ana.lopez@universidad.edu', '+52 55 5555 4520', 'https://universidad.edu/electronica/lopez', '["Circuitos Digitales", "Diseno Logico", "Vie 14:00-17:00", "FPGA", "VHDL", "asesoria"]'),
  ('00000000-0000-0000-0000-000000001305', 'Academico - Sistemas Embebidos', 'Atencion sobre Sistemas Embebidos, RTOS y arquitectura de microcontroladores. Horario de oficina: martes y jueves 10:00-12:00.', 'luis.ramirez@universidad.edu', '+52 55 5555 4504', 'https://universidad.edu/embebidos/ramirez', '["Sistemas Embebidos", "Arquitectura de Computadoras", "Mar-Jue 10:00-12:00", "RTOS", "asesoria"]'),
  ('00000000-0000-0000-0000-000000001306', 'Academico - Inteligencia Artificial', 'Atencion sobre Inteligencia Artificial, Machine Learning y redes neuronales. Horario de oficina: miercoles y viernes 12:00-14:00.', 'patricia.ruiz@universidad.edu', '+52 55 5555 4521', 'https://universidad.edu/ia/ruiz', '["Inteligencia Artificial", "Machine Learning", "Mie-Vie 12:00-14:00", "redes neuronales", "deep learning", "asesoria"]'),
  ('00000000-0000-0000-0000-000000001307', 'Academico - Microcontroladores', 'Atencion sobre Microcontroladores, interfaces y programacion de bajo nivel. Horario de oficina: lunes 14:00-17:00.', 'fernando.torres@universidad.edu', '+52 55 5555 4505', 'https://universidad.edu/micro/torres', '["Microcontroladores", "Arduino", "STM32", "ESP32", "Lun 14:00-17:00", "asesoria", "laboratorio"]'),
  ('00000000-0000-0000-0000-000000001308', 'Academico - Vision por Computadora', 'Atencion sobre Vision por Computadora, procesamiento de imagenes y OpenCV. Horario de oficina: martes y jueves 16:00-18:00.', 'javier.navarro@universidad.edu', '+52 55 5555 4522', 'https://universidad.edu/vision/navarro', '["Vision por Computadora", "Procesamiento de Imagenes", "Mar-Jue 16:00-18:00", "OpenCV", "deep learning", "asesoria"]'),

  ('00000000-0000-0000-0000-000000001351', 'Servicios Escolares', 'Tramites de inscripcion, reinscripcion, altas y bajas de materias, constancias de estudios, kardex y credencial.', 'servicios.escolares@universidad.edu', '+52 55 5555 4100', 'https://universidad.edu/servicios-escolares', '["inscripcion", "reinscripcion", "constancias", "kardex", "credencial", "cambio de horario"]'),
  ('00000000-0000-0000-0000-000000001352', 'Becas y Financiamiento', 'Solicitud de becas, renovaciones, apoyos socioeconomicos y financiamientos educativos.', 'becas@universidad.edu', '+52 55 5555 4101', 'https://universidad.edu/becas', '["becas", "apoyos economicos", "financiamiento", "solicitud de beca", "renovacion de beca"]'),
  ('00000000-0000-0000-0000-000000001353', 'Biblioteca', 'Atencion a usuarios: prestamo y devolucion de libros, reservacion de cubiculos y salas de estudio.', 'biblioteca@universidad.edu', '+52 55 5555 4200', 'https://universidad.edu/biblioteca', '["prestamo de libros", "devolucion", "reservacion de cubiculo", "sala de estudio", "asesoria bibliografica"]');

INSERT INTO place_categories (place_id, category_id) VALUES
  ('00000000-0000-0000-0000-000000001351', '00000000-0000-0000-0000-000000011041'),
  ('00000000-0000-0000-0000-000000001352', '00000000-0000-0000-0000-000000011042'),
  ('00000000-0000-0000-0000-000000001353', '00000000-0000-0000-0000-000000011043');

-- =============================================================
-- 6. Salones y laboratorios
-- =============================================================
INSERT INTO places (id, campus_id, building_id, name, type, description, floor, room_code, status, metadata) VALUES
  ('00000000-0000-0000-0000-000000001401', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000201', 'Salon A-201', 'classroom', 'Salon tradicional con pizarrón y proyector. Capacidad para 40 alumnos.', '2', 'A-201', 'active', '{"capacidad": 40, "pizarron": true, "proyector": true}'),
  ('00000000-0000-0000-0000-000000001402', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000201', 'Salon A-202', 'classroom', 'Salon tradicional con pizarrón, proyector y tomas de corriente en cada butaca.', '2', 'A-202', 'active', '{"capacidad": 35, "pizarron": true, "proyector": true, "tomas_electricas": true}'),
  ('00000000-0000-0000-0000-000000001403', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000201', 'Salon A-203', 'classroom', 'Salon para grupos pequeños. Capacidad 25, ideal para seminarios.', '2', 'A-203', 'active', '{"capacidad": 25, "pizarron": true, "proyector": true}'),
  ('00000000-0000-0000-0000-000000001404', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000202', 'Salon B-101', 'classroom', 'Salon con butacas moviles, proyector y pantalla de 80 pulgadas.', '1', 'B-101', 'active', '{"capacidad": 30, "pizarron": true, "proyector": true, "pantalla_80": true}'),

  ('00000000-0000-0000-0000-000000001451', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000201', 'Laboratorio de Robotica', 'lab', 'Laboratorio equipado con brazos roboticos, ROS y kits de robotica movil.', '1', 'A-LAB1', 'active', '{"robots": 6, "ROS": true, "camaras": true, "capacidad": 20}'),
  ('00000000-0000-0000-0000-000000001452', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000201', 'Laboratorio de Circuitos Digitales', 'lab', 'Laboratorio con osciloscopios, fuentes de poder, generadores y kits de FPGA.', '1', 'A-LAB2', 'active', '{"osciloscopios": 12, "fuentes": 12, "FPGA_kits": 12, "capacidad": 24}'),
  ('00000000-0000-0000-0000-000000001453', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000201', 'Laboratorio de Control', 'lab', 'Laboratorio con plantas de control, motores DC, servos y tarjetas de adquisicion.', '1', 'A-LAB3', 'active', '{"plantas_control": 8, "motores_DC": 8, "DAQ": true, "capacidad": 20}');

INSERT INTO room_profiles (place_id, room_type, capacity, equipment, reservable, notes) VALUES
  ('00000000-0000-0000-0000-000000001401', 'classroom', 40, '{"computers": 0, "projector": true, "whiteboard": true, "power_outlets": false}', FALSE, 'Salon para clases teoricas.'),
  ('00000000-0000-0000-0000-000000001402', 'classroom', 35, '{"computers": 0, "projector": true, "whiteboard": true, "power_outlets": true}', FALSE, 'Salon con tomas electricas para laptops.'),
  ('00000000-0000-0000-0000-000000001403', 'classroom', 25, '{"computers": 0, "projector": true, "whiteboard": true, "power_outlets": true}', TRUE, 'Ideal para seminarios. Reservable fuera de horario de clase.'),
  ('00000000-0000-0000-0000-000000001404', 'classroom', 30, '{"computers": 0, "projector": true, "whiteboard": true, "screen_80": true}', TRUE, 'Pantalla grande para presentaciones.'),
  ('00000000-0000-0000-0000-000000001451', 'lab', 20, '{"robots": 6, "ROS": true, "cameras": true, "computers": 10, "whiteboard": true, "projector": true}', TRUE, 'Reservable para proyectos. Solicitar llave con el Dr. Mendoza.'),
  ('00000000-0000-0000-0000-000000001452', 'lab', 24, '{"oscilloscopes": 12, "power_supplies": 12, "function_generators": 12, "FPGA_kits": 12, "whiteboard": true}', FALSE, 'Laboratorio de practicas de circuitos digitales.'),
  ('00000000-0000-0000-0000-000000001453', 'lab', 20, '{"plants": 8, "DC_motors": 8, "DAQ_cards": 8, "computers": 10, "whiteboard": true, "projector": true}', TRUE, 'Reservable para practicas de control avanzado.');

INSERT INTO place_categories (place_id, category_id) VALUES
  ('00000000-0000-0000-0000-000000001401', '00000000-0000-0000-0000-000000011031'),
  ('00000000-0000-0000-0000-000000001402', '00000000-0000-0000-0000-000000011031'),
  ('00000000-0000-0000-0000-000000001403', '00000000-0000-0000-0000-000000011031'),
  ('00000000-0000-0000-0000-000000001404', '00000000-0000-0000-0000-000000011031'),
  ('00000000-0000-0000-0000-000000001451', '00000000-0000-0000-0000-000000011032'),
  ('00000000-0000-0000-0000-000000001452', '00000000-0000-0000-0000-000000011032'),
  ('00000000-0000-0000-0000-000000001453', '00000000-0000-0000-0000-000000011032');

-- =============================================================
-- 7. Tiendas y productos
-- =============================================================
INSERT INTO places (id, campus_id, building_id, name, type, description, floor, room_code, status, metadata) VALUES
  ('00000000-0000-0000-0000-000000001501', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000102', 'Papeleria Campus', 'store', 'Papeleria con utiles escolares, cuadernos, plumas, calculadoras y material de dibujo.', '1', 'FOOD-9', 'active', '{"horario_popular": "antes de examenes"}'),
  ('00000000-0000-0000-0000-000000001502', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000102', 'Tienda de Conveniencia El Anexo', 'store', 'Tienda con botanas, bebidas, articulos de higiene y snacks.', '1', 'FOOD-10', 'active', '{"abierta_fines_semana": true}');

INSERT INTO store_profiles (place_id, store_type, notes) VALUES
  ('00000000-0000-0000-0000-000000001501', 'papeleria', 'Acepta pagos con efectivo y tarjeta. Venta de calculadoras cientificas y graficadoras.'),
  ('00000000-0000-0000-0000-000000001502', 'conveniencia', 'Abierta hasta tarde. Vende refrescos, jugos, dulces y articulos de primera necesidad.');

INSERT INTO place_categories (place_id, category_id) VALUES
  ('00000000-0000-0000-0000-000000001501', '00000000-0000-0000-0000-000000011021'),
  ('00000000-0000-0000-0000-000000001502', '00000000-0000-0000-0000-000000011022');

-- Productos Papeleria Campus
INSERT INTO products (place_id, name, description, category, price, currency, available) VALUES
  ('00000000-0000-0000-0000-000000001501', 'Cuaderno profesional cuadro chico', 'Cuaderno de 100 hojas, cuadro chico.', 'cuadernos', 45, 'MXN', TRUE),
  ('00000000-0000-0000-0000-000000001501', 'Cuaderno profesional cuadro grande', 'Cuaderno de 100 hojas, cuadro grande.', 'cuadernos', 45, 'MXN', TRUE),
  ('00000000-0000-0000-0000-000000001501', 'Libreta profesional 200 hojas', 'Libreta gruesa de 200 hojas.', 'cuadernos', 95, 'MXN', TRUE),
  ('00000000-0000-0000-0000-000000001501', 'Pluma negra punta fina', 'Pluma de tinta negra 0.5mm.', 'escritura', 18, 'MXN', TRUE),
  ('00000000-0000-0000-0000-000000001501', 'Set de plumas de colores (12)', 'Set con 12 plumas de colores.', 'escritura', 85, 'MXN', TRUE),
  ('00000000-0000-0000-0000-000000001501', 'Lapiz del No. 2', 'Lapiz grafito del No. 2.', 'escritura', 8, 'MXN', TRUE),
  ('00000000-0000-0000-0000-000000001501', 'Calculadora cientifica CASIO fx-991', 'Calculadora cientifica con funciones avanzadas.', 'calculadoras', 650, 'MXN', TRUE),
  ('00000000-0000-0000-0000-000000001501', 'Calculadora graficadora TI-84 Plus', 'Calculadora graficadora para ingenieria.', 'calculadoras', 4200, 'MXN', TRUE),
  ('00000000-0000-0000-0000-000000001501', 'Carpeta de argollas 3 pulgadas', 'Carpeta de argillas tamaño carta.', 'organizacion', 120, 'MXN', TRUE),
  ('00000000-0000-0000-0000-000000001501', 'Paquete de hojas blancas (500)', 'Paquete de 500 hojas tamano carta.', 'papel', 145, 'MXN', TRUE),
  ('00000000-0000-0000-0000-000000001501', 'USB 32GB', 'Memoria USB 3.0 de 32GB.', 'tecnologia', 195, 'MXN', TRUE);

-- Productos Tienda de Conveniencia
INSERT INTO products (place_id, name, description, category, price, currency, available) VALUES
  ('00000000-0000-0000-0000-000000001502', 'Refresco de cola 600ml', 'Refresco de cola en botella.', 'bebidas', 22, 'MXN', TRUE),
  ('00000000-0000-0000-0000-000000001502', 'Agua embotellada 1L', 'Agua purificada embotellada.', 'bebidas', 18, 'MXN', TRUE),
  ('00000000-0000-0000-0000-000000001502', 'Jugo de naranja 500ml', 'Jugo de naranja pasteurizado.', 'bebidas', 28, 'MXN', TRUE),
  ('00000000-0000-0000-0000-000000001502', 'Cafe soluble frasco 200g', 'Cafe soluble para preparar.', 'bebidas', 165, 'MXN', TRUE),
  ('00000000-0000-0000-0000-000000001502', 'Papas fritas bolsa', 'Bolsa de papas fritas sabor queso.', 'botanas', 18, 'MXN', TRUE),
  ('00000000-0000-0000-0000-000000001502', 'Chocolate con leche', 'Barra de chocolate con leche.', 'dulces', 15, 'MXN', TRUE),
  ('00000000-0000-0000-0000-000000001502', 'Galletas surtidas paquete', 'Paquete de galletas surtidas.', 'dulces', 35, 'MXN', TRUE),
  ('00000000-0000-0000-0000-000000001502', 'Cargador USB-C 1m', 'Cable de carga USB-C de 1 metro.', 'tecnologia', 95, 'MXN', TRUE),
  ('00000000-0000-0000-0000-000000001502', 'Audifonos 3.5mm', 'Audifonos con cable jack 3.5mm.', 'tecnologia', 145, 'MXN', TRUE),
  ('00000000-0000-0000-0000-000000001502', 'Cubrebocas paquete (10)', 'Paquete de 10 cubrebocas desechables.', 'higiene', 55, 'MXN', TRUE);

-- =============================================================
-- 8. Areas comunes
-- =============================================================
INSERT INTO places (id, campus_id, building_id, name, type, description, floor, room_code, status, metadata) VALUES
  ('00000000-0000-0000-0000-000000001551', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000203', 'Sala de Estudio Silenciosa', 'common_area', 'Sala de estudio en silencio absoluto. Capacidad 30 personas. Ideal para examenes parciales.', '2', 'LIB-201', 'active', '{"silencio_obligatorio": true, "capacidad": 30}'),
  ('00000000-0000-0000-0000-000000001552', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000203', 'Sala de Estudio Grupal Atrium', 'common_area', 'Sala con pizarrón y proyector para trabajos en equipo. Capacidad 8 personas.', '2', 'LIB-202', 'active', '{"pizarron": true, "proyector": true, "capacidad": 8, "reservable": true}'),
  ('00000000-0000-0000-0000-000000001553', '00000000-0000-0000-0000-000000000001', null, 'Jardin Central', 'common_area', 'Espacio al aire libre con bancos y mesas. Ideal para comer o descansar entre clases.', null, null, 'active', '{"aire_libre": true, "banos_cerca": true, "mesas": true}');

-- =============================================================
-- 9. Horarios de apertura
-- =============================================================

-- Restaurantes: lunes a sabado 08:00-21:00, domingo Cafe Borrego 09:00-18:00
INSERT INTO opening_hours (place_id, day_of_week, opens_at, closes_at) VALUES
  -- Tacos Don Julio
  ('00000000-0000-0000-0000-000000001201', 1, '08:00', '21:00'),
  ('00000000-0000-0000-0000-000000001201', 2, '08:00', '21:00'),
  ('00000000-0000-0000-0000-000000001201', 3, '08:00', '21:00'),
  ('00000000-0000-0000-0000-000000001201', 4, '08:00', '21:00'),
  ('00000000-0000-0000-0000-000000001201', 5, '08:00', '22:00'),
  ('00000000-0000-0000-0000-000000001201', 6, '09:00', '21:00'),
  -- Sushi Nagoya
  ('00000000-0000-0000-0000-000000001202', 1, '11:00', '21:00'),
  ('00000000-0000-0000-0000-000000001202', 2, '11:00', '21:00'),
  ('00000000-0000-0000-0000-000000001202', 3, '11:00', '21:00'),
  ('00000000-0000-0000-0000-000000001202', 4, '11:00', '21:00'),
  ('00000000-0000-0000-0000-000000001202', 5, '11:00', '22:00'),
  ('00000000-0000-0000-0000-000000001202', 6, '12:00', '22:00'),
  -- Dragon Dorado
  ('00000000-0000-0000-0000-000000001203', 1, '11:00', '21:00'),
  ('00000000-0000-0000-0000-000000001203', 2, '11:00', '21:00'),
  ('00000000-0000-0000-0000-000000001203', 3, '11:00', '21:00'),
  ('00000000-0000-0000-0000-000000001203', 4, '11:00', '21:00'),
  ('00000000-0000-0000-0000-000000001203', 5, '11:00', '22:00'),
  -- Cafe Borrego
  ('00000000-0000-0000-0000-000000001204', 1, '07:30', '21:00'),
  ('00000000-0000-0000-0000-000000001204', 2, '07:30', '21:00'),
  ('00000000-0000-0000-0000-000000001204', 3, '07:30', '21:00'),
  ('00000000-0000-0000-0000-000000001204', 4, '07:30', '21:00'),
  ('00000000-0000-0000-0000-000000001204', 5, '07:30', '22:00'),
  ('00000000-0000-0000-0000-000000001204', 6, '09:00', '18:00'),
  -- La Bella Italia
  ('00000000-0000-0000-0000-000000001205', 1, '13:00', '22:00'),
  ('00000000-0000-0000-0000-000000001205', 2, '13:00', '22:00'),
  ('00000000-0000-0000-0000-000000001205', 3, '13:00', '22:00'),
  ('00000000-0000-0000-0000-000000001205', 4, '13:00', '22:00'),
  ('00000000-0000-0000-0000-000000001205', 5, '13:00', '23:00'),
  ('00000000-0000-0000-0000-000000001205', 6, '13:00', '23:00'),
  -- Green Bowl
  ('00000000-0000-0000-0000-000000001206', 1, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000001206', 2, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000001206', 3, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000001206', 4, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000001206', 5, '08:00', '20:00'),
  -- El Rincon del Sabor
  ('00000000-0000-0000-0000-000000001207', 1, '08:00', '18:00'),
  ('00000000-0000-0000-0000-000000001207', 2, '08:00', '18:00'),
  ('00000000-0000-0000-0000-000000001207', 3, '08:00', '18:00'),
  ('00000000-0000-0000-0000-000000001207', 4, '08:00', '18:00'),
  ('00000000-0000-0000-0000-000000001207', 5, '08:00', '18:00'),
  -- Subway Campus
  ('00000000-0000-0000-0000-000000001208', 1, '08:00', '21:00'),
  ('00000000-0000-0000-0000-000000001208', 2, '08:00', '21:00'),
  ('00000000-0000-0000-0000-000000001208', 3, '08:00', '21:00'),
  ('00000000-0000-0000-0000-000000001208', 4, '08:00', '21:00'),
  ('00000000-0000-0000-0000-000000001208', 5, '08:00', '21:00'),

  -- Oficinas de profesores: lunes a viernes 10:00-18:00
  ('00000000-0000-0000-0000-000000001301', 1, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001301', 2, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001301', 3, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001301', 4, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001301', 5, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001302', 1, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001302', 2, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001302', 3, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001302', 4, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001302', 5, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001303', 1, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001303', 2, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001303', 3, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001303', 4, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001303', 5, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001304', 1, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001304', 2, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001304', 3, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001304', 4, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001304', 5, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001305', 1, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001305', 2, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001305', 3, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001305', 4, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001305', 5, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001306', 1, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001306', 2, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001306', 3, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001306', 4, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001306', 5, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001307', 1, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001307', 2, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001307', 3, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001307', 4, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001307', 5, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001308', 1, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001308', 2, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001308', 3, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001308', 4, '10:00', '18:00'),
  ('00000000-0000-0000-0000-000000001308', 5, '10:00', '18:00'),

  -- Servicios Escolares, Becas y Biblioteca: lunes a viernes 09:00-17:00
  ('00000000-0000-0000-0000-000000001351', 1, '09:00', '17:00'),
  ('00000000-0000-0000-0000-000000001351', 2, '09:00', '17:00'),
  ('00000000-0000-0000-0000-000000001351', 3, '09:00', '17:00'),
  ('00000000-0000-0000-0000-000000001351', 4, '09:00', '17:00'),
  ('00000000-0000-0000-0000-000000001351', 5, '09:00', '17:00'),
  ('00000000-0000-0000-0000-000000001352', 1, '09:00', '17:00'),
  ('00000000-0000-0000-0000-000000001352', 2, '09:00', '17:00'),
  ('00000000-0000-0000-0000-000000001352', 3, '09:00', '17:00'),
  ('00000000-0000-0000-0000-000000001352', 4, '09:00', '17:00'),
  ('00000000-0000-0000-0000-000000001352', 5, '09:00', '17:00'),
  ('00000000-0000-0000-0000-000000001353', 1, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000001353', 2, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000001353', 3, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000001353', 4, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000001353', 5, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000001353', 6, '09:00', '14:00'),

  -- Salones: lunes a viernes 07:00-22:00, sabado 08:00-18:00
  ('00000000-0000-0000-0000-000000001401', 1, '07:00', '22:00'),
  ('00000000-0000-0000-0000-000000001401', 2, '07:00', '22:00'),
  ('00000000-0000-0000-0000-000000001401', 3, '07:00', '22:00'),
  ('00000000-0000-0000-0000-000000001401', 4, '07:00', '22:00'),
  ('00000000-0000-0000-0000-000000001401', 5, '07:00', '22:00'),
  ('00000000-0000-0000-0000-000000001401', 6, '08:00', '18:00'),
  ('00000000-0000-0000-0000-000000001402', 1, '07:00', '22:00'),
  ('00000000-0000-0000-0000-000000001402', 2, '07:00', '22:00'),
  ('00000000-0000-0000-0000-000000001402', 3, '07:00', '22:00'),
  ('00000000-0000-0000-0000-000000001402', 4, '07:00', '22:00'),
  ('00000000-0000-0000-0000-000000001402', 5, '07:00', '22:00'),
  ('00000000-0000-0000-0000-000000001402', 6, '08:00', '18:00'),
  ('00000000-0000-0000-0000-000000001403', 1, '07:00', '22:00'),
  ('00000000-0000-0000-0000-000000001403', 2, '07:00', '22:00'),
  ('00000000-0000-0000-0000-000000001403', 3, '07:00', '22:00'),
  ('00000000-0000-0000-0000-000000001403', 4, '07:00', '22:00'),
  ('00000000-0000-0000-0000-000000001403', 5, '07:00', '22:00'),
  ('00000000-0000-0000-0000-000000001404', 1, '07:00', '22:00'),
  ('00000000-0000-0000-0000-000000001404', 2, '07:00', '22:00'),
  ('00000000-0000-0000-0000-000000001404', 3, '07:00', '22:00'),
  ('00000000-0000-0000-0000-000000001404', 4, '07:00', '22:00'),
  ('00000000-0000-0000-0000-000000001404', 5, '07:00', '22:00'),
  -- Labs con horario de practica
  ('00000000-0000-0000-0000-000000001451', 1, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000001451', 2, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000001451', 3, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000001451', 4, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000001451', 5, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000001452', 1, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000001452', 2, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000001452', 3, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000001452', 4, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000001452', 5, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000001453', 1, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000001453', 2, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000001453', 3, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000001453', 4, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000001453', 5, '08:00', '20:00'),

  -- Tiendas: lunes a sabado
  ('00000000-0000-0000-0000-000000001501', 1, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000001501', 2, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000001501', 3, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000001501', 4, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000001501', 5, '08:00', '20:00'),
  ('00000000-0000-0000-0000-000000001501', 6, '09:00', '15:00'),
  ('00000000-0000-0000-0000-000000001502', 1, '07:00', '23:00'),
  ('00000000-0000-0000-0000-000000001502', 2, '07:00', '23:00'),
  ('00000000-0000-0000-0000-000000001502', 3, '07:00', '23:00'),
  ('00000000-0000-0000-0000-000000001502', 4, '07:00', '23:00'),
  ('00000000-0000-0000-0000-000000001502', 5, '07:00', '23:00'),
  ('00000000-0000-0000-0000-000000001502', 6, '08:00', '22:00'),
  ('00000000-0000-0000-0000-000000001502', 7, '09:00', '20:00');

-- =============================================================
-- 10. Eventos en salones (clases Otono 2026)
-- =============================================================
-- Cada clase se inserta con varias sesiones a lo largo del semestre
-- para que el agente pueda encontrar el horario recurrente.

-- Control Clasico - Dr. Roberto Sanchez - Salon A-201 - Lun y Mie 10:00-12:00
INSERT INTO room_events (id, place_id, academic_term_id, title, event_type, starts_at, ends_at, recurrence_rule, source, notes) VALUES
  ('00000000-0000-0000-0000-000000006001', '00000000-0000-0000-0000-000000001401', '00000000-0000-0000-0000-000000005001', 'Control Clasico - Grupo 01', 'class', '2026-08-10 10:00:00', '2026-08-10 12:00:00', 'WEEKLY:MO,WE', 'registro escolar', 'Imparte Dr. Roberto Sanchez'),
  ('00000000-0000-0000-0000-000000006002', '00000000-0000-0000-0000-000000001401', '00000000-0000-0000-0000-000000005001', 'Control Clasico - Grupo 01', 'class', '2026-08-12 10:00:00', '2026-08-12 12:00:00', 'WEEKLY:MO,WE', 'registro escolar', 'Imparte Dr. Roberto Sanchez'),
  ('00000000-0000-0000-0000-000000006003', '00000000-0000-0000-0000-000000001401', '00000000-0000-0000-0000-000000005001', 'Control Clasico - Grupo 01', 'class', '2026-08-17 10:00:00', '2026-08-17 12:00:00', 'WEEKLY:MO,WE', 'registro escolar', 'Imparte Dr. Roberto Sanchez'),
  ('00000000-0000-0000-0000-000000006004', '00000000-0000-0000-0000-000000001401', '00000000-0000-0000-0000-000000005001', 'Control Clasico - Grupo 01', 'class', '2026-08-19 10:00:00', '2026-08-19 12:00:00', 'WEEKLY:MO,WE', 'registro escolar', 'Imparte Dr. Roberto Sanchez'),

-- Control Avanzado - Dra. Maria Gonzalez - Salon A-202 - Mar y Jue 14:00-16:00
  ('00000000-0000-0000-0000-000000006005', '00000000-0000-0000-0000-000000001402', '00000000-0000-0000-0000-000000005001', 'Control Avanzado - Grupo 01', 'class', '2026-08-11 14:00:00', '2026-08-11 16:00:00', 'WEEKLY:TU,TH', 'registro escolar', 'Imparte Dra. Maria Gonzalez'),
  ('00000000-0000-0000-0000-000000006006', '00000000-0000-0000-0000-000000001402', '00000000-0000-0000-0000-000000005001', 'Control Avanzado - Grupo 01', 'class', '2026-08-13 14:00:00', '2026-08-13 16:00:00', 'WEEKLY:TU,TH', 'registro escolar', 'Imparte Dra. Maria Gonzalez'),
  ('00000000-0000-0000-0000-000000006007', '00000000-0000-0000-0000-000000001402', '00000000-0000-0000-0000-000000005001', 'Control Avanzado - Grupo 01', 'class', '2026-08-18 14:00:00', '2026-08-18 16:00:00', 'WEEKLY:TU,TH', 'registro escolar', 'Imparte Dra. Maria Gonzalez'),
  ('00000000-0000-0000-0000-000000006008', '00000000-0000-0000-0000-000000001402', '00000000-0000-0000-0000-000000005001', 'Control Avanzado - Grupo 01', 'class', '2026-08-20 14:00:00', '2026-08-20 16:00:00', 'WEEKLY:TU,TH', 'registro escolar', 'Imparte Dra. Maria Gonzalez'),

-- Robotica - Dr. Carlos Mendoza - Lab Robotica - Lun y Mie 16:00-18:00
  ('00000000-0000-0000-0000-000000006009', '00000000-0000-0000-0000-000000001451', '00000000-0000-0000-0000-000000005001', 'Robotica - Grupo 01', 'class', '2026-08-10 16:00:00', '2026-08-10 18:00:00', 'WEEKLY:MO,WE', 'registro escolar', 'Practica en Lab Robotica. Imparte Dr. Carlos Mendoza'),
  ('00000000-0000-0000-0000-000000006010', '00000000-0000-0000-0000-000000001451', '00000000-0000-0000-0000-000000005001', 'Robotica - Grupo 01', 'class', '2026-08-12 16:00:00', '2026-08-12 18:00:00', 'WEEKLY:MO,WE', 'registro escolar', 'Practica en Lab Robotica. Imparte Dr. Carlos Mendoza'),
  ('00000000-0000-0000-0000-000000006011', '00000000-0000-0000-0000-000000001451', '00000000-0000-0000-0000-000000005001', 'Robotica - Grupo 01', 'class', '2026-08-17 16:00:00', '2026-08-17 18:00:00', 'WEEKLY:MO,WE', 'registro escolar', 'Practica en Lab Robotica. Imparte Dr. Carlos Mendoza'),
  ('00000000-0000-0000-0000-000000006012', '00000000-0000-0000-0000-000000001451', '00000000-0000-0000-0000-000000005001', 'Robotica - Grupo 01', 'class', '2026-08-19 16:00:00', '2026-08-19 18:00:00', 'WEEKLY:MO,WE', 'registro escolar', 'Practica en Lab Robotica. Imparte Dr. Carlos Mendoza'),

-- Circuitos Digitales - Dra. Ana Lopez - Lab Circuitos - Vie 10:00-13:00
  ('00000000-0000-0000-0000-000000006013', '00000000-0000-0000-0000-000000001452', '00000000-0000-0000-0000-000000005001', 'Circuitos Digitales - Grupo 01', 'class', '2026-08-14 10:00:00', '2026-08-14 13:00:00', 'WEEKLY:FR', 'registro escolar', 'Practica en Lab Circuitos. Imparte Dra. Ana Lopez'),
  ('00000000-0000-0000-0000-000000006014', '00000000-0000-0000-0000-000000001452', '00000000-0000-0000-0000-000000005001', 'Circuitos Digitales - Grupo 01', 'class', '2026-08-21 10:00:00', '2026-08-21 13:00:00', 'WEEKLY:FR', 'registro escolar', 'Practica en Lab Circuitos. Imparte Dra. Ana Lopez'),
  ('00000000-0000-0000-0000-000000006015', '00000000-0000-0000-0000-000000001452', '00000000-0000-0000-0000-000000005001', 'Circuitos Digitales - Grupo 01', 'class', '2026-08-28 10:00:00', '2026-08-28 13:00:00', 'WEEKLY:FR', 'registro escolar', 'Practica en Lab Circuitos. Imparte Dra. Ana Lopez'),

-- Sistemas Embebidos - Dr. Luis Ramirez - Lab Control - Mar y Jue 10:00-12:00
  ('00000000-0000-0000-0000-000000006016', '00000000-0000-0000-0000-000000001453', '00000000-0000-0000-0000-000000005001', 'Sistemas Embebidos - Grupo 01', 'class', '2026-08-11 10:00:00', '2026-08-11 12:00:00', 'WEEKLY:TU,TH', 'registro escolar', 'Practica en Lab Control. Imparte Dr. Luis Ramirez'),
  ('00000000-0000-0000-0000-000000006017', '00000000-0000-0000-0000-000000001453', '00000000-0000-0000-0000-000000005001', 'Sistemas Embebidos - Grupo 01', 'class', '2026-08-13 10:00:00', '2026-08-13 12:00:00', 'WEEKLY:TU,TH', 'registro escolar', 'Practica en Lab Control. Imparte Dr. Luis Ramirez'),
  ('00000000-0000-0000-0000-000000006018', '00000000-0000-0000-0000-000000001453', '00000000-0000-0000-0000-000000005001', 'Sistemas Embebidos - Grupo 01', 'class', '2026-08-18 10:00:00', '2026-08-18 12:00:00', 'WEEKLY:TU,TH', 'registro escolar', 'Practica en Lab Control. Imparte Dr. Luis Ramirez'),

-- Inteligencia Artificial - Dra. Patricia Ruiz - Salon B-101 - Mie y Vie 14:00-16:00
  ('00000000-0000-0000-0000-000000006019', '00000000-0000-0000-0000-000000001404', '00000000-0000-0000-0000-000000005001', 'Inteligencia Artificial - Grupo 01', 'class', '2026-08-12 14:00:00', '2026-08-12 16:00:00', 'WEEKLY:WE,FR', 'registro escolar', 'Imparte Dra. Patricia Ruiz'),
  ('00000000-0000-0000-0000-000000006020', '00000000-0000-0000-0000-000000001404', '00000000-0000-0000-0000-000000005001', 'Inteligencia Artificial - Grupo 01', 'class', '2026-08-14 14:00:00', '2026-08-14 16:00:00', 'WEEKLY:WE,FR', 'registro escolar', 'Imparte Dra. Patricia Ruiz'),
  ('00000000-0000-0000-0000-000000006021', '00000000-0000-0000-0000-000000001404', '00000000-0000-0000-0000-000000005001', 'Inteligencia Artificial - Grupo 01', 'class', '2026-08-19 14:00:00', '2026-08-19 16:00:00', 'WEEKLY:WE,FR', 'registro escolar', 'Imparte Dra. Patricia Ruiz'),

-- Microcontroladores - Dr. Fernando Torres - Lab Circuitos - Lun 14:00-17:00
  ('00000000-0000-0000-0000-000000006022', '00000000-0000-0000-0000-000000001452', '00000000-0000-0000-0000-000000005001', 'Microcontroladores - Grupo 01', 'class', '2026-08-10 14:00:00', '2026-08-10 17:00:00', 'WEEKLY:MO', 'registro escolar', 'Practica en Lab Circuitos. Imparte Dr. Fernando Torres'),
  ('00000000-0000-0000-0000-000000006023', '00000000-0000-0000-0000-000000001452', '00000000-0000-0000-0000-000000005001', 'Microcontroladores - Grupo 01', 'class', '2026-08-17 14:00:00', '2026-08-17 17:00:00', 'WEEKLY:MO', 'registro escolar', 'Practica en Lab Circuitos. Imparte Dr. Fernando Torres'),

-- Vision por Computadora - Dr. Javier Navarro - Salon B-101 - Mar y Jue 16:00-18:00
  ('00000000-0000-0000-0000-000000006024', '00000000-0000-0000-0000-000000001404', '00000000-0000-0000-0000-000000005001', 'Vision por Computadora - Grupo 01', 'class', '2026-08-11 16:00:00', '2026-08-11 18:00:00', 'WEEKLY:TU,TH', 'registro escolar', 'Imparte Dr. Javier Navarro'),
  ('00000000-0000-0000-0000-000000006025', '00000000-0000-0000-0000-000000001404', '00000000-0000-0000-0000-000000005001', 'Vision por Computadora - Grupo 01', 'class', '2026-08-13 16:00:00', '2026-08-13 18:00:00', 'WEEKLY:TU,TH', 'registro escolar', 'Imparte Dr. Javier Navarro'),

-- Examen parcial de Control Clasico (evento exam)
  ('00000000-0000-0000-0000-000000006026', '00000000-0000-0000-0000-000000001401', '00000000-0000-0000-0000-000000005001', 'Examen Parcial Control Clasico', 'exam', '2026-09-28 10:00:00', '2026-09-28 12:00:00', null, 'registro escolar', 'Examen parcial. Salon A-201'),
  ('00000000-0000-0000-0000-000000006027', '00000000-0000-0000-0000-000000001402', '00000000-0000-0000-0000-000000005001', 'Examen Parcial Robotica', 'exam', '2026-09-30 16:00:00', '2026-09-30 18:00:00', null, 'registro escolar', 'Examen parcial. Lab Robotica'),

-- Mantenimiento programado del Lab de Control
  ('00000000-0000-0000-0000-000000006028', '00000000-0000-0000-0000-000000001453', '00000000-0000-0000-0000-000000005001', 'Mantenimiento Lab Control', 'maintenance', '2026-08-29 08:00:00', '2026-08-29 14:00:00', null, 'mantenimiento', 'Calibracion de equipos. Cerrado ese dia.');

-- =============================================================
-- 11. Niveles de afluencia (ultimo por restaurante y Giornale)
-- =============================================================
INSERT INTO crowd_levels (place_id, observed_at, level, percentage, source) VALUES
  -- Giornale (existente) - concurrido
  ('00000000-0000-0000-0000-000000001002', NOW() - INTERVAL '2 hours', 'high', 80, 'sensores'),
  ('00000000-0000-0000-0000-000000001002', NOW() - INTERVAL '4 hours', 'medium', 55, 'sensores'),
  -- Tacos Don Julio - lleno
  ('00000000-0000-0000-0000-000000001201', NOW() - INTERVAL '1 hour', 'full', 95, 'observacion manual'),
  -- Sushi Nagoya - tranquilo
  ('00000000-0000-0000-0000-000000001202', NOW() - INTERVAL '30 minutes', 'low', 25, 'sensores'),
  -- Dragon Dorado - medio
  ('00000000-0000-0000-0000-000000001203', NOW() - INTERVAL '45 minutes', 'medium', 50, 'sensores'),
  -- Cafe Borrego - concurrido (es desayuno)
  ('00000000-0000-0000-0000-000000001204', NOW() - INTERVAL '15 minutes', 'high', 75, 'sensores'),
  -- La Bella Italia - vacio
  ('00000000-0000-0000-0000-000000001205', NOW() - INTERVAL '20 minutes', 'low', 20, 'sensores'),
  -- Green Bowl - medio
  ('00000000-0000-0000-0000-000000001206', NOW() - INTERVAL '10 minutes', 'medium', 60, 'sensores'),
  -- El Rincon del Sabor - lleno
  ('00000000-0000-0000-0000-000000001207', NOW() - INTERVAL '5 minutes', 'full', 90, 'observacion manual'),
  -- Subway Campus - bajo
  ('00000000-0000-0000-0000-000000001208', NOW() - INTERVAL '25 minutes', 'low', 30, 'sensores');

-- =============================================================
-- 12. Nodos y aristas de navegacion adicionales
-- Conectan el grafo existente a los nuevos edificios para que
-- un usuario pueda pedir rutas entre cualquier lugar del campus.
-- =============================================================

-- Nodos nuevos
INSERT INTO navigation_nodes (id, campus_id, building_id, name, node_type, floor, orientation_hint, localization_hint) VALUES
  ('00000000-0000-0000-0000-000000007001', '00000000-0000-0000-0000-000000000001', null, 'Interseccion central del campus', 'intersection', 'PB', 'Mirando al norte, hacia el Edificio A', 'Plaza central del campus, conecta todos los edificios'),
  ('00000000-0000-0000-0000-000000007002', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000201', 'Entrada principal Edificio A', 'place_anchor', 'PB', 'Mirando hacia el lobby del Edificio A', 'Puerta principal del Edificio A'),
  ('00000000-0000-0000-0000-000000007003', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000202', 'Entrada principal Edificio B', 'place_anchor', 'PB', 'Mirando hacia el lobby del Edificio B', 'Puerta principal del Edificio B'),
  ('00000000-0000-0000-0000-000000007004', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000203', 'Entrada Biblioteca Central', 'place_anchor', 'PB', 'Mirando hacia el mostrador', 'Puerta principal de la Biblioteca'),
  ('00000000-0000-0000-0000-000000007005', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000204', 'Entrada Centro de Investigacion', 'place_anchor', 'PB', 'Mirando hacia la recepcion', 'Puerta principal del Centro de Investigacion'),
  ('00000000-0000-0000-0000-000000007006', '00000000-0000-0000-0000-000000000001', null, 'Acceso a zona de comida', 'place_anchor', 'PB', 'Mirando hacia la zona de restaurantes', 'Entrada a la zona de comida');

-- Relacionar places con nodos (front_door)
INSERT INTO place_navigation_nodes (place_id, navigation_node_id, role) VALUES
  ('00000000-0000-0000-0000-000000001301', '00000000-0000-0000-0000-000000007002', 'front_door'),
  ('00000000-0000-0000-0000-000000001302', '00000000-0000-0000-0000-000000007002', 'front_door'),
  ('00000000-0000-0000-0000-000000001303', '00000000-0000-0000-0000-000000007002', 'front_door'),
  ('00000000-0000-0000-0000-000000001305', '00000000-0000-0000-0000-000000007002', 'front_door'),
  ('00000000-0000-0000-0000-000000001307', '00000000-0000-0000-0000-000000007002', 'front_door'),
  ('00000000-0000-0000-0000-000000001401', '00000000-0000-0000-0000-000000007002', 'front_door'),
  ('00000000-0000-0000-0000-000000001402', '00000000-0000-0000-0000-000000007002', 'front_door'),
  ('00000000-0000-0000-0000-000000001403', '00000000-0000-0000-0000-000000007002', 'front_door'),
  ('00000000-0000-0000-0000-000000001451', '00000000-0000-0000-0000-000000007002', 'front_door'),
  ('00000000-0000-0000-0000-000000001452', '00000000-0000-0000-0000-000000007002', 'front_door'),
  ('00000000-0000-0000-0000-000000001453', '00000000-0000-0000-0000-000000007002', 'front_door'),

  ('00000000-0000-0000-0000-000000001304', '00000000-0000-0000-0000-000000007003', 'front_door'),
  ('00000000-0000-0000-0000-000000001306', '00000000-0000-0000-0000-000000007003', 'front_door'),
  ('00000000-0000-0000-0000-000000001308', '00000000-0000-0000-0000-000000007003', 'front_door'),
  ('00000000-0000-0000-0000-000000001404', '00000000-0000-0000-0000-000000007003', 'front_door'),

  ('00000000-0000-0000-0000-000000001351', '00000000-0000-0000-0000-000000007004', 'front_door'),
  ('00000000-0000-0000-0000-000000001352', '00000000-0000-0000-0000-000000007004', 'front_door'),
  ('00000000-0000-0000-0000-000000001353', '00000000-0000-0000-0000-000000007004', 'front_door'),
  ('00000000-0000-0000-0000-000000001551', '00000000-0000-0000-0000-000000007004', 'front_door'),
  ('00000000-0000-0000-0000-000000001552', '00000000-0000-0000-0000-000000007004', 'front_door'),

  ('00000000-0000-0000-0000-000000001201', '00000000-0000-0000-0000-000000007006', 'front_door'),
  ('00000000-0000-0000-0000-000000001202', '00000000-0000-0000-0000-000000007006', 'front_door'),
  ('00000000-0000-0000-0000-000000001203', '00000000-0000-0000-0000-000000007006', 'front_door'),
  ('00000000-0000-0000-0000-000000001204', '00000000-0000-0000-0000-000000007006', 'front_door'),
  ('00000000-0000-0000-0000-000000001205', '00000000-0000-0000-0000-000000007006', 'front_door'),
  ('00000000-0000-0000-0000-000000001206', '00000000-0000-0000-0000-000000007006', 'front_door'),
  ('00000000-0000-0000-0000-000000001207', '00000000-0000-0000-0000-000000007006', 'front_door'),
  ('00000000-0000-0000-0000-000000001208', '00000000-0000-0000-0000-000000007006', 'front_door'),
  ('00000000-0000-0000-0000-000000001501', '00000000-0000-0000-0000-000000007006', 'front_door'),
  ('00000000-0000-0000-0000-000000001502', '00000000-0000-0000-0000-000000007006', 'front_door'),

  ('00000000-0000-0000-0000-000000001553', '00000000-0000-0000-0000-000000007001', 'front_door');

-- Aristas nuevas (todas bidireccionales para simplificar ruteo)
INSERT INTO navigation_edges (id, from_node_id, to_node_id, distance_meters, bidirectional, edge_type, status) VALUES
  -- De interseccion central hacia cada edificio
  ('00000000-0000-0000-0000-000000008001', '00000000-0000-0000-0000-000000007001', '00000000-0000-0000-0000-000000007002', 30.00, TRUE, 'outdoor', 'active'),
  ('00000000-0000-0000-0000-000000008002', '00000000-0000-0000-0000-000000007001', '00000000-0000-0000-0000-000000007003', 40.00, TRUE, 'outdoor', 'active'),
  ('00000000-0000-0000-0000-000000008003', '00000000-0000-0000-0000-000000007001', '00000000-0000-0000-0000-000000007004', 25.00, TRUE, 'outdoor', 'active'),
  ('00000000-0000-0000-0000-000000008004', '00000000-0000-0000-0000-000000007001', '00000000-0000-0000-0000-000000007005', 25.00, TRUE, 'outdoor', 'active'),
  ('00000000-0000-0000-0000-000000008005', '00000000-0000-0000-0000-000000007001', '00000000-0000-0000-0000-000000007006', 50.00, TRUE, 'outdoor', 'active'),
  -- Conexion del grafo nuevo al existente: pasillo Lab L -> interseccion central
  ('00000000-0000-0000-0000-000000008006', '00000000-0000-0000-0000-000000003002', '00000000-0000-0000-0000-000000007001', 12.00, TRUE, 'walk', 'active'),
  -- De zona de comida a Giornale (que ya tenia nodo)
  ('00000000-0000-0000-0000-000000008007', '00000000-0000-0000-0000-000000007006', '00000000-0000-0000-0000-000000003003', 10.00, TRUE, 'walk', 'active');

-- Route segments
INSERT INTO route_segments (edge_id, segment_key, route_file_name, instruction_key, expected_duration_seconds, start_orientation_hint, end_orientation_hint, robot_mode, reversible) VALUES
  ('00000000-0000-0000-0000-000000008001', 'centro_to_edificio_a', 'centro_to_edificio_a.csv', 'centro_to_edificio_a', 60, 'Iniciar en la plaza central mirando al Edificio A.', 'Terminar frente a la entrada principal del Edificio A.', 'follow_recorded_route', FALSE),
  ('00000000-0000-0000-0000-000000008002', 'centro_to_edificio_b', 'centro_to_edificio_b.csv', 'centro_to_edificio_b', 75, 'Iniciar en la plaza central mirando al Edificio B.', 'Terminar frente a la entrada principal del Edificio B.', 'follow_recorded_route', FALSE),
  ('00000000-0000-0000-0000-000000008003', 'centro_to_biblioteca', 'centro_to_biblioteca.csv', 'centro_to_biblioteca', 45, 'Iniciar en la plaza central mirando a la Biblioteca.', 'Terminar frente a la entrada de la Biblioteca Central.', 'follow_recorded_route', FALSE),
  ('00000000-0000-0000-0000-000000008004', 'centro_to_investigacion', 'centro_to_investigacion.csv', 'centro_to_investigacion', 50, 'Iniciar en la plaza central mirando al Centro de Investigacion.', 'Terminar frente a la entrada del Centro de Investigacion.', 'follow_recorded_route', FALSE),
  ('00000000-0000-0000-0000-000000008005', 'centro_to_zona_comida', 'centro_to_zona_comida.csv', 'centro_to_zona_comida', 90, 'Iniciar en la plaza central mirando a la zona de comida.', 'Terminar en el acceso a la zona de comida.', 'follow_recorded_route', FALSE),
  ('00000000-0000-0000-0000-000000008006', 'pasillo_l_to_centro', 'pasillo_l_to_centro.csv', 'pasillo_l_to_centro', 30, 'Iniciar en el pasillo del Edificio L mirando a la plaza central.', 'Terminar en la interseccion central del campus.', 'follow_recorded_route', FALSE),
  ('00000000-0000-0000-0000-000000008007', 'zona_comida_to_giornale', 'zona_comida_to_giornale.csv', 'zona_comida_to_giornale', 25, 'Iniciar en el acceso a la zona de comida mirando hacia Giornale.', 'Terminar frente a Giornale.', 'follow_recorded_route', FALSE);

-- =============================================================
-- 13. Documentos semanticos (textos descriptivos)
-- =============================================================
INSERT INTO semantic_documents (entity_type, entity_id, title, content, metadata, embedding_model) VALUES
  ('place', '00000000-0000-0000-0000-000000001201', 'Tacos Don Julio', 'Taqueria mexicana dentro de la zona de comida del campus. Ofrece tacos al pastor, suadero, carnitas, tortas de milanesa, gringas, quesadillas y agua de horchata. Servicio rapido para llevar. Estilo callejero, ambiente casual y ruidoso. Abre de lunes a sabado.', '{"source": "seed", "cuisine": "mexicana"}', NULL),
  ('place', '00000000-0000-0000-0000-000000001202', 'Sushi Nagoya', 'Restaurante japones en la zona de comida. Sushi rolls Philadelphia y Spicy Tuna, nigiri de salmon y atun, ramen tonkotsu, edamame, gyozas de cerdo y mochis de matcha. Ambiente tranquilo, ideal para sentarse a comer o reuniones pequenas. Abre de lunes a sabado al mediodia.', '{"source": "seed", "cuisine": "japonesa"}', NULL),
  ('place', '00000000-0000-0000-0000-000000001203', 'Dragon Dorado', 'Restaurante de comida china en la zona de comida. Chow mein, kung pao chicken, pollo agridulce, pato pekines, arroz cantonés, rollos primavera, dim sum de cerdo, wontons y te de jazmin. Porciones generosas pensadas para compartir en grupo. Ambiente familiar.', '{"source": "seed", "cuisine": "china"}', NULL),
  ('place', '00000000-0000-0000-0000-000000001204', 'Cafe Borrego', 'Cafeteria de especialidad en la zona de comida. Espresso, capuchino, latte, americano, mocha, frappes, smoothies, croissants, muffins, bagels y sandwiches. Tiene wifi gratuito y tomacorrientes. Ambiente acogedor y tranquilo, ideal para estudiar, trabajar o tomar cafe entre clases.', '{"source": "seed", "cuisine": "cafe"}', NULL),
  ('place', '00000000-0000-0000-0000-000000001205', 'La Bella Italia', 'Restaurante italiano en la zona de comida. Pizzas margherita y pepperoni, spaghetti carbonara, fettuccine alfredo, lasagna bolognesa, risotto de hongos, bruschetta, ensalada caprese, tiramisu y cannoli. Ambiente romantico y tranquilo, ideal para cenas y reuniones.', '{"source": "seed", "cuisine": "italiana"}', NULL),
  ('place', '00000000-0000-0000-0000-000000001206', 'Green Bowl', 'Restaurante vegetariano y vegano en la zona de comida. Buddha bowl de quinoa, ensalada cesar vegana, wraps de hummus, bowls de acai, tostadas de aguacate, smoothies verdes, jugos naturales, sopa de lentejas, tamales veganos y brownies veganos. Opciones sin gluten disponibles.', '{"source": "seed", "cuisine": "vegetariana"}', NULL),
  ('place', '00000000-0000-0000-0000-000000001207', 'El Rincon del Sabor', 'Fonda mexicana con comida corrida economica. Sopa, arroz, frijoles, guisado, agua del dia y postre por menos de 100 pesos. Pollo en mole, bistec a la mexicana, sopa azteca, flan napolitano. Solo acepta efectivo. Ideal para alumnos con presupuesto bajo.', '{"source": "seed", "cuisine": "mexicana corrida"}', NULL),
  ('place', '00000000-0000-0000-0000-000000001208', 'Subway Campus', 'Subway dentro de la zona de comida. Subs de 15cm personalizables: veggie, pavo, pollo teriyaki, italiano BMT y atun. Ensaladas, papas horneadas, combos, galletas y bebidas. Servicio rapido, ideal para comer rapido o para llevar.', '{"source": "seed", "cuisine": "sandwiches"}', NULL),

  ('place', '00000000-0000-0000-0000-000000001301', 'Dr. Roberto Sanchez - Control Clasico', 'Profesor del area de Control y Sistemas. Imparte Control Clasico los lunes y miercoles de 10:00 a 12:00 en el Salon A-201. Atiende alumnos en horario de oficina lunes y miercoles de 12:00 a 14:00. Cubiculo A-301 del Edificio A.', '{"source": "seed", "subject": "Control Clasico"}', NULL),
  ('place', '00000000-0000-0000-0000-000000001302', 'Dra. Maria Gonzalez - Control Avanzado', 'Profesora de Control Avanzado y Sistemas No Lineales. Imparte Control Avanzado los martes y jueves de 14:00 a 16:00 en el Salon A-202. Atiende alumnos martes y jueves de 12:00 a 14:00. Cubiculo A-302 del Edificio A.', '{"source": "seed", "subject": "Control Avanzado"}', NULL),
  ('place', '00000000-0000-0000-0000-000000001303', 'Dr. Carlos Mendoza - Robotica', 'Profesor de Robotica, manipuladores y ROS. Imparte Robotica lunes y miercoles de 16:00 a 18:00 en el Laboratorio de Robotica. Atiende proyectos de robotica movil y brazos roboticos. Cubiculo A-303 del Edificio A.', '{"source": "seed", "subject": "Robotica"}', NULL),
  ('place', '00000000-0000-0000-0000-000000001304', 'Dra. Ana Lopez - Circuitos Digitales', 'Profesora de Circuitos Digitales, Diseno Logico, FPGA y VHDL. Imparte clases los viernes de 10:00 a 13:00 en el Laboratorio de Circuitos Digitales. Cubiculo B-201 del Edificio B.', '{"source": "seed", "subject": "Circuitos Digitales"}', NULL),
  ('place', '00000000-0000-0000-0000-000000001305', 'Dr. Luis Ramirez - Sistemas Embebidos', 'Profesor de Sistemas Embebidos y Arquitectura de Computadoras. Imparte Sistemas Embebidos los martes y jueves de 10:00 a 12:00 en el Laboratorio de Control. Atiende sobre RTOS y microcontroladores. Cubiculo A-304 del Edificio A.', '{"source": "seed", "subject": "Sistemas Embebidos"}', NULL),
  ('place', '00000000-0000-0000-0000-000000001306', 'Dra. Patricia Ruiz - Inteligencia Artificial', 'Profesora de Inteligencia Artificial y Machine Learning. Imparte IA los miercoles y viernes de 14:00 a 16:00 en el Salon B-101. Proyectos de redes neuronales y deep learning. Cubiculo B-202 del Edificio B.', '{"source": "seed", "subject": "Inteligencia Artificial"}', NULL),
  ('place', '00000000-0000-0000-0000-000000001307', 'Dr. Fernando Torres - Microcontroladores', 'Profesor de Microcontroladores e Interfaces. Imparte laboratorio los lunes de 14:00 a 17:00 en el Laboratorio de Circuitos Digitales con Arduino, STM32 y ESP32. Cubiculo A-305 del Edificio A.', '{"source": "seed", "subject": "Microcontroladores"}', NULL),
  ('place', '00000000-0000-0000-0000-000000001308', 'Dr. Javier Navarro - Vision por Computadora', 'Profesor de Vision por Computadora y Procesamiento de Imagenes. Imparte los martes y jueves de 16:00 a 18:00 en el Salon B-101. Proyectos con OpenCV y deep learning. Cubiculo B-203 del Edificio B.', '{"source": "seed", "subject": "Vision por Computadora"}', NULL),

  ('place', '00000000-0000-0000-0000-000000001451', 'Laboratorio de Robotica', 'Laboratorio del Edificio A con 6 brazos roboticos, kits de ROS, 10 computadoras, camaras y capacidad para 20 alumnos. Usado para practicas de Robotica y Manipuladores. Reservable para proyectos terminales fuera de horario.', '{"source": "seed"}', NULL),
  ('place', '00000000-0000-0000-0000-000000001452', 'Laboratorio de Circuitos Digitales', 'Laboratorio del Edificio A con 12 osciloscopios, 12 fuentes de poder, 12 generadores de funciones y 12 kits de FPGA. Capacidad 24 alumnos. Usado para Circuitos Digitales y Microcontroladores.', '{"source": "seed"}', NULL),
  ('place', '00000000-0000-0000-0000-000000001453', 'Laboratorio de Control', 'Laboratorio del Edificio A con 8 plantas de control, motores DC, servos y tarjetas de adquisicion. Capacidad 20 alumnos. Usado para practicas de Control y Sistemas Embebidos.', '{"source": "seed"}', NULL),

  ('place', '00000000-0000-0000-0000-000000001501', 'Papeleria Campus', 'Papeleria dentro de la zona de comida. Vende cuadernos, plumas, lapices, calculadoras cientificas y graficadoras, carpetas, hojas blancas y memorias USB. Acepta efectivo y tarjeta. Se llena antes de examenes.', '{"source": "seed"}', NULL),
  ('place', '00000000-0000-0000-0000-000000001502', 'Tienda de Conveniencia El Anexo', 'Tienda dentro de la zona de comida. Vende refrescos, aguas, jugos, cafe soluble, papas fritas, chocolates, galletas, cargadores USB-C, audifonos y cubrebocas. Abierta de lunes a domingo, horario extendido.', '{"source": "seed"}', NULL),

  ('place', '00000000-0000-0000-0000-000000001551', 'Sala de Estudio Silenciosa', 'Sala de estudio en silencio absoluto ubicada en el segundo piso de la Biblioteca Central. Capacidad 30 personas. Ideal para examenes parciales y concentracion profunda.', '{"source": "seed"}', NULL),
  ('place', '00000000-0000-0000-0000-000000001552', 'Sala de Estudio Grupal Atrium', 'Sala de estudio grupal en la Biblioteca. Capacidad 8 personas, cuenta con pizarron, proyector y mesa grande. Reservable para trabajos en equipo.', '{"source": "seed"}', NULL),
  ('place', '00000000-0000-0000-0000-000000001553', 'Jardin Central', 'Espacio al aire libre en la plaza central del campus con bancos y mesas. Util para comer, descansar entre clases o reuniones casuales al exterior.', '{"source": "seed"}', NULL);
