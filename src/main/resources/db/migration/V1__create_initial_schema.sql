CREATE TABLE customers (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(150),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE devices (
    id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    type VARCHAR(50) NOT NULL,
    brand VARCHAR(60) NOT NULL,
    model VARCHAR(100) NOT NULL,
    serial_number VARCHAR(100),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_devices_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(id)
        ON DELETE RESTRICT
);

CREATE TABLE service_orders (
    id BIGSERIAL PRIMARY KEY,
    device_id BIGINT NOT NULL,
    reported_issue TEXT NOT NULL,
    diagnosis TEXT,
    estimated_price NUMERIC(10, 2),
    status VARCHAR(30) NOT NULL DEFAULT 'RECEIVED',
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    finished_at TIMESTAMPTZ,

    CONSTRAINT fk_service_orders_device
        FOREIGN KEY (device_id)
        REFERENCES devices(id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_service_order_status
        CHECK (
            status IN (
                'RECEIVED',
                'IN_ANALYSIS',
                'AWAITING_APPROVAL',
                'IN_REPAIR',
                'COMPLETED',
                'CANCELLED'
            )
        ),

    CONSTRAINT chk_estimated_price
        CHECK (estimated_price IS NULL OR estimated_price >= 0)
);

CREATE TABLE status_history (
    id BIGSERIAL PRIMARY KEY,
    service_order_id BIGINT NOT NULL,
    previous_status VARCHAR(30),
    new_status VARCHAR(30) NOT NULL,
    changed_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_status_history_service_order
        FOREIGN KEY (service_order_id)
        REFERENCES service_orders(id)
        ON DELETE CASCADE
);

CREATE INDEX idx_devices_customer_id
    ON devices(customer_id);

CREATE INDEX idx_service_orders_device_id
    ON service_orders(device_id);

CREATE INDEX idx_service_orders_status
    ON service_orders(status);

CREATE INDEX idx_status_history_service_order_id
    ON status_history(service_order_id);