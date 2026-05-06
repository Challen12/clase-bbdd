-- ==========================================
-- SCRIPT DE INSERCIÓN DE DATOS DE PRUEBA
-- ==========================================

-- Insertar Clientes (ignora si ya existen)
INSERT INTO public.clients (id, name, logo_url, address, description) VALUES
('c1a2e312-d421-4f68-9812-7bc01b7a6345', 'TechNova Solutions', 'https://ui-avatars.com/api/?name=TechNova&background=0D8ABC&color=fff', 'Calle Falsa 123, Madrid', 'Empresa líder en tecnología e innovación.'),
('c2b3f423-e532-5079-0923-8cd12c8b7456', 'EcoGreen Foods', 'https://ui-avatars.com/api/?name=EcoGreen&background=22c55e&color=fff', 'Avenida Central 45, Barcelona', 'Marca de alimentos sostenibles y orgánicos.'),
('c3c40534-f643-6180-1034-9de23d9c8567', 'Urban Wear', 'https://ui-avatars.com/api/?name=Urban+Wear&background=000&color=fff', 'Polígono Norte 99, Valencia', 'Marca de moda urbana internacional.')
ON CONFLICT (id) DO NOTHING;

-- Insertar Tipos de Proyectos
INSERT INTO public.project_types (id, name) VALUES
('11d51645-0754-7291-2145-aef34ead9678', 'Branding'),
('22e62756-1865-8302-3256-bf045fbe0789', 'Maquetación Editorial'),
('33f73867-2976-9413-4367-c01560cf1890', 'UI/UX'),
('44084978-3087-0524-5478-d12671d02901', 'Ilustración'),
('55195a89-4198-1635-6589-e23782e13a12', 'Infografía')
ON CONFLICT (id) DO NOTHING;

-- Insertar Proyectos
INSERT INTO public.projects (id, title, description, image_url, year, client_id) VALUES
('f1a1b1c1-1111-1111-1111-111111111111', 'Rediseño de Marca TechNova', 'Evolución de la identidad visual para adaptarse al mercado SaaS. Se diseñaron nuevos logotipos, paleta de colores y un manual de marca completo.', 'https://picsum.photos/seed/technova/800/600', 2023, 'c1a2e312-d421-4f68-9812-7bc01b7a6345'),
('f2a2b2c2-2222-2222-2222-222222222222', 'App Móvil TechNova', 'Diseño de interfaz y experiencia de usuario para la nueva app móvil, enfocada en la usabilidad y la retención de usuarios.', 'https://picsum.photos/seed/technovaapp/800/600', 2024, 'c1a2e312-d421-4f68-9812-7bc01b7a6345'),
('f3a3b3c3-3333-3333-3333-333333333333', 'Packaging EcoGreen', 'Diseño de envases reciclables y campaña de concienciación. Ilustraciones naturales y texturas orgánicas.', 'https://picsum.photos/seed/ecogreen/800/600', 2023, 'c2b3f423-e532-5079-0923-8cd12c8b7456'),
('f4a4b4c4-4444-4444-4444-444444444444', 'Catálogo Editorial Urban Wear', 'Maquetación de la colección Primavera/Verano con estilo brutalista y un enfoque muy tipográfico.', 'https://picsum.photos/seed/urbanwear/800/600', 2022, 'c3c40534-f643-6180-1034-9de23d9c8567'),
('f5a5b5c5-5555-5555-5555-555555555555', 'Ilustraciones para Blog', 'Serie de ilustraciones conceptuales sobre innovación y futuro para artículos editoriales del cliente.', 'https://picsum.photos/seed/ilustraciones/800/600', 2024, 'c1a2e312-d421-4f68-9812-7bc01b7a6345'),
('f6a6b6c6-6666-6666-6666-666666666666', 'Dashboard Analítico', 'Creación de un dashboard en modo oscuro para visualizar métricas en tiempo real con componentes glassmorphism.', 'https://picsum.photos/seed/dashboard/800/600', 2025, 'c1a2e312-d421-4f68-9812-7bc01b7a6345')
ON CONFLICT (id) DO NOTHING;

-- Mapeo de Proyectos con Tipos
INSERT INTO public.project_types_mapping (project_id, project_type_id) VALUES
('f1a1b1c1-1111-1111-1111-111111111111', '11d51645-0754-7291-2145-aef34ead9678'),
('f1a1b1c1-1111-1111-1111-111111111111', '33f73867-2976-9413-4367-c01560cf1890'),
('f2a2b2c2-2222-2222-2222-222222222222', '33f73867-2976-9413-4367-c01560cf1890'),
('f3a3b3c3-3333-3333-3333-333333333333', '11d51645-0754-7291-2145-aef34ead9678'),
('f3a3b3c3-3333-3333-3333-333333333333', '44084978-3087-0524-5478-d12671d02901'),
('f4a4b4c4-4444-4444-4444-444444444444', '22e62756-1865-8302-3256-bf045fbe0789'),
('f4a4b4c4-4444-4444-4444-444444444444', '55195a89-4198-1635-6589-e23782e13a12'),
('f5a5b5c5-5555-5555-5555-555555555555', '44084978-3087-0524-5478-d12671d02901'),
('f6a6b6c6-6666-6666-6666-666666666666', '33f73867-2976-9413-4367-c01560cf1890'),
('f6a6b6c6-6666-6666-6666-666666666666', '55195a89-4198-1635-6589-e23782e13a12')
ON CONFLICT (project_id, project_type_id) DO NOTHING;
