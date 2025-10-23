-- Script de inicialización para la base de datos ventas
-- Este script se ejecuta automáticamente cuando se crea el contenedor

-- Crear tabla de usuarios (ejemplo basado en el sistema de login)
CREATE TABLE IF NOT EXISTS usuarios (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    nombre VARCHAR(100),
    email VARCHAR(100),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT true
);

-- Crear tabla de productos
CREATE TABLE IF NOT EXISTS productos (
    id SERIAL PRIMARY KEY,
    codigo VARCHAR(50) UNIQUE NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    stock INTEGER DEFAULT 0,
    categoria VARCHAR(100),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear tabla de ventas
CREATE TABLE IF NOT EXISTS ventas (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(id),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10, 2) NOT NULL,
    estado VARCHAR(20) DEFAULT 'completada'
);

-- Crear tabla de detalle de ventas
CREATE TABLE IF NOT EXISTS detalle_ventas (
    id SERIAL PRIMARY KEY,
    venta_id INTEGER REFERENCES ventas(id) ON DELETE CASCADE,
    producto_id INTEGER REFERENCES productos(id),
    cantidad INTEGER NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL
);

-- Insertar un usuario de prueba (password: admin123)
INSERT INTO usuarios (username, password, nombre, email) 
VALUES ('admin', 'admin123', 'Administrador', 'admin@ventas.com')
ON CONFLICT (username) DO NOTHING;

-- Insertar productos de prueba
INSERT INTO productos (codigo, nombre, descripcion, precio, stock, categoria) VALUES
('PROD001', 'Laptop HP', 'Laptop HP 15.6 pulgadas, 8GB RAM, 256GB SSD', 599.99, 10, 'Electrónica'),
('PROD002', 'Mouse Logitech', 'Mouse inalámbrico Logitech M185', 15.99, 50, 'Accesorios'),
('PROD003', 'Teclado Mecánico', 'Teclado mecánico RGB', 79.99, 25, 'Accesorios'),
('PROD004', 'Monitor Samsung 24"', 'Monitor Full HD 24 pulgadas', 189.99, 15, 'Electrónica'),
('PROD005', 'Webcam HD', 'Webcam 1080p con micrófono', 49.99, 30, 'Accesorios')
ON CONFLICT (codigo) DO NOTHING;

-- Crear índices para mejorar el rendimiento
CREATE INDEX IF NOT EXISTS idx_productos_codigo ON productos(codigo);
CREATE INDEX IF NOT EXISTS idx_productos_nombre ON productos(nombre);
CREATE INDEX IF NOT EXISTS idx_ventas_fecha ON ventas(fecha);
CREATE INDEX IF NOT EXISTS idx_ventas_usuario ON ventas(usuario_id);

-- Mensaje de confirmación
SELECT 'Base de datos inicializada correctamente' AS status;
