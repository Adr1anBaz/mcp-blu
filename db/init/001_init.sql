CREATE EXTENSION IF NOT EXISTS vector;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =========================
-- Core
-- =========================

CREATE TABLE campuses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE buildings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    campus_id UUID NOT NULL REFERENCES campuses(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    code TEXT,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE places (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    campus_id UUID NOT NULL REFERENCES campuses(id) ON DELETE CASCADE,
    building_id UUID REFERENCES buildings(id) ON DELETE SET NULL,
    name TEXT NOT NULL,
    type TEXT NOT NULL CHECK (
        type IN (
            'restaurant',
            'classroom',
            'lab',
            'store',
            'office',
            'department',
            'gate',
            'common_area'
        )
    ),
    description TEXT,
    floor TEXT,
    room_code TEXT,
    status TEXT NOT NULL DEFAULT 'active' CHECK (
        status IN ('active', 'inactive', 'temporary_closed')
    ),
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- =========================
-- Categories
-- =========================

CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    parent_id UUID REFERENCES categories(id) ON DELETE SET NULL
);

CREATE TABLE place_categories (
    place_id UUID NOT NULL REFERENCES places(id) ON DELETE CASCADE,
    category_id UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    PRIMARY KEY (place_id, category_id)
);

-- =========================
-- Schedules
-- =========================

CREATE TABLE opening_hours (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    place_id UUID NOT NULL REFERENCES places(id) ON DELETE CASCADE,
    day_of_week INT NOT NULL CHECK (day_of_week BETWEEN 1 AND 7),
    opens_at TIME NOT NULL,
    closes_at TIME NOT NULL,
    valid_from DATE,
    valid_to DATE
);

CREATE TABLE schedule_exceptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    place_id UUID NOT NULL REFERENCES places(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    is_closed BOOLEAN DEFAULT FALSE,
    opens_at TIME,
    closes_at TIME,
    reason TEXT
);

-- =========================
-- Restaurants
-- =========================

CREATE TABLE restaurant_profiles (
    place_id UUID PRIMARY KEY REFERENCES places(id) ON DELETE CASCADE,
    cuisine_type TEXT,
    average_price NUMERIC(10, 2),
    payment_methods JSONB DEFAULT '[]'::jsonb,
    accepts_card BOOLEAN,
    notes TEXT
);

CREATE TABLE menus (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    place_id UUID NOT NULL REFERENCES places(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    active BOOLEAN DEFAULT TRUE
);

CREATE TABLE menu_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    menu_id UUID NOT NULL REFERENCES menus(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    category TEXT,
    price NUMERIC(10, 2),
    currency TEXT DEFAULT 'MXN',
    dietary_tags JSONB DEFAULT '[]'::jsonb,
    available BOOLEAN DEFAULT TRUE,
    metadata JSONB DEFAULT '{}'::jsonb
);

CREATE TABLE crowd_levels (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    place_id UUID NOT NULL REFERENCES places(id) ON DELETE CASCADE,
    observed_at TIMESTAMP NOT NULL DEFAULT NOW(),
    level TEXT NOT NULL CHECK (level IN ('low', 'medium', 'high', 'full')),
    percentage INT CHECK (percentage BETWEEN 0 AND 100),
    source TEXT
);

-- =========================
-- Stores
-- =========================

CREATE TABLE store_profiles (
    place_id UUID PRIMARY KEY REFERENCES places(id) ON DELETE CASCADE,
    store_type TEXT,
    notes TEXT
);

CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    place_id UUID NOT NULL REFERENCES places(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    category TEXT,
    price NUMERIC(10, 2),
    currency TEXT DEFAULT 'MXN',
    available BOOLEAN DEFAULT TRUE,
    metadata JSONB DEFAULT '{}'::jsonb
);

-- =========================
-- Rooms / Labs
-- =========================

CREATE TABLE room_profiles (
    place_id UUID PRIMARY KEY REFERENCES places(id) ON DELETE CASCADE,
    room_type TEXT NOT NULL CHECK (
        room_type IN ('classroom', 'lab', 'auditorium', 'study_room')
    ),
    capacity INT,
    equipment JSONB DEFAULT '{}'::jsonb,
    reservable BOOLEAN DEFAULT FALSE,
    notes TEXT
);

CREATE TABLE academic_terms (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    starts_on DATE NOT NULL,
    ends_on DATE NOT NULL,
    active BOOLEAN DEFAULT FALSE
);

CREATE TABLE room_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    place_id UUID NOT NULL REFERENCES places(id) ON DELETE CASCADE,
    academic_term_id UUID REFERENCES academic_terms(id) ON DELETE SET NULL,
    title TEXT NOT NULL,
    event_type TEXT NOT NULL CHECK (
        event_type IN ('class', 'exam', 'reservation', 'maintenance')
    ),
    starts_at TIMESTAMP NOT NULL,
    ends_at TIMESTAMP NOT NULL,
    recurrence_rule TEXT,
    source TEXT,
    notes TEXT
);

-- =========================
-- Offices / Departments
-- =========================

CREATE TABLE office_profiles (
    place_id UUID PRIMARY KEY REFERENCES places(id) ON DELETE CASCADE,
    department_type TEXT,
    purpose TEXT,
    contact_email TEXT,
    phone TEXT,
    website_url TEXT,
    services JSONB DEFAULT '[]'::jsonb
);

-- =========================
-- Gates
-- =========================

CREATE TABLE gate_profiles (
    place_id UUID PRIMARY KEY REFERENCES places(id) ON DELETE CASCADE,
    gate_type TEXT CHECK (
        gate_type IN ('pedestrian', 'vehicle', 'emergency', 'service')
    ),
    entry_allowed BOOLEAN DEFAULT TRUE,
    exit_allowed BOOLEAN DEFAULT TRUE,
    adjacent_streets TEXT,
    security_notes TEXT
);

-- =========================
-- Semantic search / embeddings
-- =========================

CREATE TABLE semantic_documents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    entity_type TEXT NOT NULL,
    entity_id UUID NOT NULL,
    title TEXT,
    content TEXT NOT NULL,
    metadata JSONB DEFAULT '{}'::jsonb,
    embedding VECTOR(1536),
    embedding_model TEXT,
    source_hash TEXT,
    updated_at TIMESTAMP DEFAULT NOW()
);

-- =========================
-- Navigation graph
-- =========================

CREATE TABLE navigation_nodes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    campus_id UUID NOT NULL REFERENCES campuses(id) ON DELETE CASCADE,
    building_id UUID REFERENCES buildings(id) ON DELETE SET NULL,
    name TEXT NOT NULL,
    node_type TEXT NOT NULL CHECK (
        node_type IN (
            'place_anchor',
            'hallway',
            'intersection',
            'door',
            'stairs',
            'elevator',
            'gate',
            'robot_start',
            'other'
        )
    ),
    floor TEXT,
    orientation_hint TEXT,
    localization_hint TEXT,
    metadata JSONB DEFAULT '{}'::jsonb,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE place_navigation_nodes (
    place_id UUID NOT NULL REFERENCES places(id) ON DELETE CASCADE,
    navigation_node_id UUID NOT NULL REFERENCES navigation_nodes(id) ON DELETE CASCADE,
    role TEXT NOT NULL CHECK (
        role IN (
            'main_entrance',
            'exit',
            'pickup_point',
            'dropoff_point',
            'front_door',
            'anchor'
        )
    ),
    PRIMARY KEY (place_id, navigation_node_id, role)
);

CREATE TABLE navigation_edges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    from_node_id UUID NOT NULL REFERENCES navigation_nodes(id) ON DELETE CASCADE,
    to_node_id UUID NOT NULL REFERENCES navigation_nodes(id) ON DELETE CASCADE,
    distance_meters NUMERIC(6,2) NOT NULL CHECK (distance_meters > 0),
    bidirectional BOOLEAN DEFAULT FALSE,
    edge_type TEXT CHECK (
        edge_type IN (
            'walk',
            'hallway',
            'stairs',
            'elevator',
            'ramp',
            'outdoor',
            'restricted'
        )
    ),
    status TEXT DEFAULT 'active' CHECK (
        status IN ('active', 'closed', 'slow', 'restricted')
    ),
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE route_segments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    edge_id UUID NOT NULL REFERENCES navigation_edges(id) ON DELETE CASCADE,
    segment_key TEXT NOT NULL UNIQUE,
    route_file_name TEXT,
    instruction_key TEXT,
    expected_duration_seconds INT,
    start_orientation_hint TEXT,
    end_orientation_hint TEXT,
    robot_mode TEXT CHECK (
        robot_mode IN (
            'follow_recorded_route',
            'velocity_profile',
            'waypoint_mode'
        )
    ),
    reversible BOOLEAN DEFAULT FALSE,
    reverse_segment_id UUID REFERENCES route_segments(id) ON DELETE SET NULL,
    version INT DEFAULT 1,
    active BOOLEAN DEFAULT TRUE,
    metadata JSONB DEFAULT '{}'::jsonb
);

-- =========================
-- Useful indexes
-- =========================

CREATE INDEX idx_places_type ON places(type);
CREATE INDEX idx_places_status ON places(status);
CREATE INDEX idx_places_metadata_gin ON places USING GIN (metadata);

CREATE INDEX idx_opening_hours_place_day ON opening_hours(place_id, day_of_week);
CREATE INDEX idx_room_events_place_time ON room_events(place_id, starts_at, ends_at);

CREATE INDEX idx_menu_items_name ON menu_items(name);
CREATE INDEX idx_products_name ON products(name);

CREATE INDEX idx_semantic_documents_entity ON semantic_documents(entity_type, entity_id);

CREATE INDEX idx_navigation_edges_from ON navigation_edges(from_node_id);
CREATE INDEX idx_navigation_edges_to ON navigation_edges(to_node_id);
CREATE INDEX idx_route_segments_edge ON route_segments(edge_id);
