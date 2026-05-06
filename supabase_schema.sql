-- ==========================================
-- SCHEMA: Portfolio de Diseñador Gráfico
-- ==========================================

-- 1. Tabla de Clientes (clients)
CREATE TABLE public.clients (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    logo_url TEXT,
    address TEXT,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Tabla de Tipos de Proyecto (project_types)
CREATE TABLE public.project_types (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. Tabla de Proyectos (projects)
CREATE TABLE public.projects (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    image_url TEXT,
    year INTEGER NOT NULL,
    client_id UUID REFERENCES public.clients(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. Tabla de Relación Proyectos <-> Tipos de Proyecto (project_types_mapping)
CREATE TABLE public.project_types_mapping (
    project_id UUID REFERENCES public.projects(id) ON DELETE CASCADE,
    project_type_id UUID REFERENCES public.project_types(id) ON DELETE CASCADE,
    PRIMARY KEY (project_id, project_type_id)
);

-- Habilitar RLS (Row Level Security) para permitir la lectura pública
ALTER TABLE public.clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.project_types ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.project_types_mapping ENABLE ROW LEVEL SECURITY;

-- Políticas de lectura pública
CREATE POLICY "Allow public read access on clients" ON public.clients FOR SELECT USING (true);
CREATE POLICY "Allow public read access on project_types" ON public.project_types FOR SELECT USING (true);
CREATE POLICY "Allow public read access on projects" ON public.projects FOR SELECT USING (true);
CREATE POLICY "Allow public read access on project_types_mapping" ON public.project_types_mapping FOR SELECT USING (true);

-- ==========================================
-- DATOS DE PRUEBA (Mock Data)
-- ==========================================

-- Insertar Clientes
INSERT INTO public.clients (id, name, logo_url, address, description) VALUES
('c1a2e312-d421-4f68-9812-7bc01b7a6345', 'TechNova Solutions', 'https://ui-avatars.com/api/?name=TechNova&background=0D8ABC&color=fff', 'Calle Falsa 123, Madrid', 'Empresa líder en tecnología e innovación.'),
('c2b3f423-e532-5079-0923-8cd12c8b7456', 'EcoGreen Foods', 'https://ui-avatars.com/api/?name=EcoGreen&background=22c55e&color=fff', 'Avenida Central 45, Barcelona', 'Marca de alimentos sostenibles y orgánicos.'),
('c3c40534-f643-6180-1034-9de23d9c8567', 'Urban Wear', 'https://ui-avatars.com/api/?name=Urban+Wear&background=000&color=fff', 'Polígono Norte 99, Valencia', 'Marca de moda urbana internacional.');

-- Insertar Tipos de Proyectos
INSERT INTO public.project_types (id, name) VALUES
('11d51645-0754-7291-2145-aef34ead9678', 'Branding'),
('22e62756-1865-8302-3256-bf045fbe0789', 'Maquetación Editorial'),
('33f73867-2976-9413-4367-c01560cf1890', 'UI/UX'),
('44084978-3087-0524-5478-d12671d02901', 'Ilustración'),
('55195a89-4198-1635-6589-e23782e13a12', 'Infografía');

-- Insertar Proyectos
INSERT INTO public.projects (id, title, description, image_url, year, client_id) VALUES
('f1a1b1c1-1111-1111-1111-111111111111', 'Rediseño de Marca TechNova', 'Evolución de la identidad visual para adaptarse al mercado SaaS.', 'https://picsum.photos/seed/technova/800/600', 2023, 'c1a2e312-d421-4f68-9812-7bc01b7a6345'),
('f2a2b2c2-2222-2222-2222-222222222222', 'App Móvil TechNova', 'Diseño de interfaz y experiencia de usuario para la nueva app.', 'https://picsum.photos/seed/technovaapp/800/600', 2024, 'c1a2e312-d421-4f68-9812-7bc01b7a6345'),
('f3a3b3c3-3333-3333-3333-333333333333', 'Packaging EcoGreen', 'Diseño de envases reciclables y campaña de concienciación.', 'https://picsum.photos/seed/ecogreen/800/600', 2023, 'c2b3f423-e532-5079-0923-8cd12c8b7456'),
('f4a4b4c4-4444-4444-4444-444444444444', 'Catálogo Editorial Urban Wear', 'Maquetación de la colección Primavera/Verano con estilo brutalista.', 'https://picsum.photos/seed/urbanwear/800/600', 2022, 'c3c40534-f643-6180-1034-9de23d9c8567'),
('f5a5b5c5-5555-5555-5555-555555555555', 'Ilustraciones para Blog', 'Serie de ilustraciones conceptuales sobre innovación.', 'https://picsum.photos/seed/ilustraciones/800/600', 2024, 'c1a2e312-d421-4f68-9812-7bc01b7a6345');

-- Mapeo de Proyectos con Tipos
-- Rediseño Marca TechNova -> Branding, UI/UX
INSERT INTO public.project_types_mapping (project_id, project_type_id) VALUES
('f1a1b1c1-1111-1111-1111-111111111111', '11d51645-0754-7291-2145-aef34ead9678'),
('f1a1b1c1-1111-1111-1111-111111111111', '33f73867-2976-9413-4367-c01560cf1890');

-- App Móvil TechNova -> UI/UX
INSERT INTO public.project_types_mapping (project_id, project_type_id) VALUES
('f2a2b2c2-2222-2222-2222-222222222222', '33f73867-2976-9413-4367-c01560cf1890');

-- Packaging EcoGreen -> Branding, Ilustración
INSERT INTO public.project_types_mapping (project_id, project_type_id) VALUES
('f3a3b3c3-3333-3333-3333-333333333333', '11d51645-0754-7291-2145-aef34ead9678'),
('f3a3b3c3-3333-3333-3333-333333333333', '44084978-3087-0524-5478-d12671d02901');

-- Catálogo Urban Wear -> Maquetación Editorial, Infografía
INSERT INTO public.project_types_mapping (project_id, project_type_id) VALUES
('f4a4b4c4-4444-4444-4444-444444444444', '22e62756-1865-8302-3256-bf045fbe0789'),
('f4a4b4c4-4444-4444-4444-444444444444', '55195a89-4198-1635-6589-e23782e13a12');

-- Ilustraciones Blog -> Ilustración
INSERT INTO public.project_types_mapping (project_id, project_type_id) VALUES
('f5a5b5c5-5555-5555-5555-555555555555', '44084978-3087-0524-5478-d12671d02901');
