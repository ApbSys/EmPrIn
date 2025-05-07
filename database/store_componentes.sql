-- Script SQL para la creación de la base de datos de Store Componentes

-- Tabla de usuarios
CREATE TABLE IF NOT EXISTS usuarios (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    es_admin BOOLEAN DEFAULT 0,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de proveedores
CREATE TABLE IF NOT EXISTS proveedores (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    cif TEXT UNIQUE NOT NULL,
    direccion TEXT,
    telefono TEXT,
    email TEXT,
    porcentaje_descuento REAL DEFAULT 0,
    iva REAL DEFAULT 21,
    notas TEXT
);

-- Tabla de productos
CREATE TABLE IF NOT EXISTS productos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    referencia TEXT UNIQUE NOT NULL,
    descripcion TEXT,
    precio_compra REAL NOT NULL,
    precio_venta REAL NOT NULL,
    stock_actual INTEGER DEFAULT 0,
    stock_minimo INTEGER DEFAULT 0,
    ubicacion_almacen TEXT,
    categoria TEXT,
    imagen TEXT,
    proveedor_id INTEGER,
    FOREIGN KEY (proveedor_id) REFERENCES proveedores (id)
);

-- Tabla de ventas
CREATE TABLE IF NOT EXISTS ventas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    cliente_id INTEGER NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total REAL DEFAULT 0,
    FOREIGN KEY (cliente_id) REFERENCES usuarios (id)
);

-- Tabla de detalle de ventas
CREATE TABLE IF NOT EXISTS ventas_detalle (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    venta_id INTEGER NOT NULL,
    producto_id INTEGER NOT NULL,
    cantidad INTEGER NOT NULL,
    precio_unitario REAL NOT NULL,
    FOREIGN KEY (venta_id) REFERENCES ventas (id),
    FOREIGN KEY (producto_id) REFERENCES productos (id)
);

-- Tabla de compras
CREATE TABLE IF NOT EXISTS compras (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    proveedor_id INTEGER NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total REAL DEFAULT 0,
    FOREIGN KEY (proveedor_id) REFERENCES proveedores (id)
);

-- Tabla de detalle de compras
CREATE TABLE IF NOT EXISTS compras_detalle (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    compra_id INTEGER NOT NULL,
    producto_id INTEGER NOT NULL,
    cantidad INTEGER NOT NULL,
    precio_unitario REAL NOT NULL,
    FOREIGN KEY (compra_id) REFERENCES compras (id),
    FOREIGN KEY (producto_id) REFERENCES productos (id)
);

-- Insertar usuario administrador
INSERT OR IGNORE INTO usuarios (username, email, password, es_admin) 
VALUES ('admin', 'admin@storecomponentes.com', '83ba1c67e4d4f114f8ff1bb2618ad29bd8aeef3e960c0888c8f4b785fb91637a:42974b1f280c8e904c05331c0eb7da87f4e93acc500424b38e93f1fd2c189a7f', 1);

-- Insertar proveedores
INSERT OR IGNORE INTO proveedores (nombre, cif, direccion, telefono, email, porcentaje_descuento, iva) 
VALUES 
('Componentes Tech', 'B54892341', 'C/ Industria, 12, Pol. Ind. Las Palmeras, 08940 Cornellà de Llobregat, Barcelona', '931234567', 'contacto@componentestech.com', 5, 21),
('Electrónica Global', 'B62781004', 'Av. de la Tecnología, 45, Nave 8, 28022 Madrid', '910456789', 'info@electronicaglobal.com', 3, 21);

-- Insertar productos reales con URLs de imágenes
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Intel Core i9-13900K', 'PRO-001', 'Intel Core i9-13900K de alto rendimiento', 419.64, 534.58, 84, 3, 'Estantería C-4', 'Procesadores', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Intel Core i7-13700K', 'PRO-002', 'Intel Core i7-13700K de alto rendimiento', 293.18, 407.84, 82, 4, 'Estantería C-4', 'Procesadores', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Intel Core i5-13600K', 'PRO-003', 'Intel Core i5-13600K de alto rendimiento', 453.73, 639.98, 40, 10, 'Estantería B-1', 'Procesadores', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Intel Core i9-12900K', 'PRO-004', 'Intel Core i9-12900K de alto rendimiento', 582.86, 820.46, 61, 3, 'Estantería A-4', 'Procesadores', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Intel Core i7-12700K', 'PRO-005', 'Intel Core i7-12700K de alto rendimiento', 409.66, 539.87, 63, 9, 'Estantería B-1', 'Procesadores', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Intel Core i5-12600K', 'PRO-006', 'Intel Core i5-12600K de alto rendimiento', 273.44, 377.25, 86, 4, 'Estantería B-4', 'Procesadores', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Intel Core i9-11900K', 'PRO-007', 'Intel Core i9-11900K de alto rendimiento', 590.07, 816.87, 72, 4, 'Estantería C-4', 'Procesadores', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Intel Core i7-11700K', 'PRO-008', 'Intel Core i7-11700K de alto rendimiento', 369.98, 583.82, 46, 4, 'Estantería A-3', 'Procesadores', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Intel Core i5-11600K', 'PRO-009', 'Intel Core i5-11600K de alto rendimiento', 150.25, 225.0, 57, 5, 'Estantería A-3', 'Procesadores', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Intel Core i9-10900K', 'PRO-010', 'Intel Core i9-10900K de alto rendimiento', 598.14, 921.91, 16, 4, 'Estantería B-5', 'Procesadores', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Intel Core i7-10700K', 'PRO-011', 'Intel Core i7-10700K de alto rendimiento', 326.17, 480.65, 74, 10, 'Estantería C-1', 'Procesadores', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Intel Core i5-10600K', 'PRO-012', 'Intel Core i5-10600K de alto rendimiento', 445.92, 578.38, 87, 6, 'Estantería A-1', 'Procesadores', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('AMD Ryzen 9 7950X', 'PRO-013', 'AMD Ryzen 9 7950X de alto rendimiento', 582.78, 817.21, 37, 9, 'Estantería A-3', 'Procesadores', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('AMD Ryzen 9 7900X', 'PRO-014', 'AMD Ryzen 9 7900X de alto rendimiento', 228.0, 341.08, 99, 2, 'Estantería B-4', 'Procesadores', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('AMD Ryzen 7 7700X', 'PRO-015', 'AMD Ryzen 7 7700X de alto rendimiento', 551.53, 790.57, 33, 2, 'Estantería A-3', 'Procesadores', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('AMD Ryzen 5 7600X', 'PRO-016', 'AMD Ryzen 5 7600X de alto rendimiento', 534.26, 680.44, 34, 6, 'Estantería C-5', 'Procesadores', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('AMD Ryzen 9 5950X', 'PRO-017', 'AMD Ryzen 9 5950X de alto rendimiento', 440.84, 594.34, 27, 7, 'Estantería B-3', 'Procesadores', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('AMD Ryzen 9 5900X', 'PRO-018', 'AMD Ryzen 9 5900X de alto rendimiento', 419.19, 566.84, 73, 4, 'Estantería B-4', 'Procesadores', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('AMD Ryzen 7 5800X', 'PRO-019', 'AMD Ryzen 7 5800X de alto rendimiento', 222.19, 272.59, 15, 4, 'Estantería A-4', 'Procesadores', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('AMD Ryzen 5 5600X', 'PRO-020', 'AMD Ryzen 5 5600X de alto rendimiento', 114.52, 148.57, 19, 10, 'Estantería A-5', 'Procesadores', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('AMD Ryzen 9 3950X', 'PRO-021', 'AMD Ryzen 9 3950X de alto rendimiento', 386.08, 467.61, 61, 6, 'Estantería C-4', 'Procesadores', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('AMD Ryzen 9 3900X', 'PRO-022', 'AMD Ryzen 9 3900X de alto rendimiento', 285.77, 352.74, 77, 8, 'Estantería C-5', 'Procesadores', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('AMD Ryzen 7 3700X', 'PRO-023', 'AMD Ryzen 7 3700X de alto rendimiento', 468.63, 706.43, 20, 2, 'Estantería A-5', 'Procesadores', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('AMD Ryzen 5 3600X', 'PRO-024', 'AMD Ryzen 5 3600X de alto rendimiento', 109.66, 147.13, 21, 10, 'Estantería A-2', 'Procesadores', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('AMD Ryzen 5 3600', 'PRO-025', 'AMD Ryzen 5 3600 de alto rendimiento', 330.23, 433.66, 49, 2, 'Estantería B-3', 'Procesadores', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Corsair Vengeance LPX 16GB DDR4-3200', 'MEM-001', 'Corsair Vengeance LPX 16GB DDR4-3200 de alto rendimiento', 596.9, 757.8, 76, 9, 'Estantería B-5', 'Memoria RAM', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Corsair Vengeance RGB Pro 32GB DDR4-3600', 'MEM-002', 'Corsair Vengeance RGB Pro 32GB DDR4-3600 de alto rendimiento', 591.5, 760.19, 78, 6, 'Estantería A-1', 'Memoria RAM', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('G.Skill Trident Z RGB 16GB DDR4-3200', 'MEM-003', 'G.Skill Trident Z RGB 16GB DDR4-3200 de alto rendimiento', 272.6, 433.24, 56, 4, 'Estantería C-2', 'Memoria RAM', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('G.Skill Ripjaws V 16GB DDR4-3600', 'MEM-004', 'G.Skill Ripjaws V 16GB DDR4-3600 de alto rendimiento', 459.24, 621.03, 59, 6, 'Estantería B-1', 'Memoria RAM', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Kingston HyperX Fury 16GB DDR4-3200', 'MEM-005', 'Kingston HyperX Fury 16GB DDR4-3200 de alto rendimiento', 209.43, 266.24, 40, 7, 'Estantería C-2', 'Memoria RAM', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Crucial Ballistix 16GB DDR4-3200', 'MEM-006', 'Crucial Ballistix 16GB DDR4-3200 de alto rendimiento', 596.64, 772.93, 29, 10, 'Estantería A-3', 'Memoria RAM', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('TeamGroup T-Force Delta RGB 16GB DDR4-3200', 'MEM-007', 'TeamGroup T-Force Delta RGB 16GB DDR4-3200 de alto rendimiento', 545.06, 741.47, 34, 7, 'Estantería B-2', 'Memoria RAM', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Patriot Viper Steel 16GB DDR4-4400', 'MEM-008', 'Patriot Viper Steel 16GB DDR4-4400 de alto rendimiento', 499.65, 629.64, 92, 6, 'Estantería C-4', 'Memoria RAM', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('ADATA XPG Spectrix D60G 16GB DDR4-3200', 'MEM-009', 'ADATA XPG Spectrix D60G 16GB DDR4-3200 de alto rendimiento', 599.49, 914.0, 29, 7, 'Estantería C-3', 'Memoria RAM', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Mushkin Redline 16GB DDR4-3600', 'MEM-010', 'Mushkin Redline 16GB DDR4-3600 de alto rendimiento', 259.83, 362.46, 21, 5, 'Estantería B-2', 'Memoria RAM', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Corsair Dominator Platinum RGB 32GB DDR4-3200', 'MEM-011', 'Corsair Dominator Platinum RGB 32GB DDR4-3200 de alto rendimiento', 462.19, 696.64, 25, 10, 'Estantería B-5', 'Memoria RAM', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('G.Skill Trident Z5 RGB 32GB DDR5-6000', 'MEM-012', 'G.Skill Trident Z5 RGB 32GB DDR5-6000 de alto rendimiento', 298.0, 458.36, 11, 8, 'Estantería C-2', 'Memoria RAM', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Kingston Fury Beast 32GB DDR5-5200', 'MEM-013', 'Kingston Fury Beast 32GB DDR5-5200 de alto rendimiento', 469.03, 674.39, 36, 2, 'Estantería C-2', 'Memoria RAM', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Crucial DDR5-4800 16GB', 'MEM-014', 'Crucial DDR5-4800 16GB de alto rendimiento', 542.2, 862.63, 93, 10, 'Estantería C-5', 'Memoria RAM', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('TeamGroup T-Force Delta RGB 32GB DDR5-5600', 'MEM-015', 'TeamGroup T-Force Delta RGB 32GB DDR5-5600 de alto rendimiento', 430.23, 564.06, 53, 10, 'Estantería B-1', 'Memoria RAM', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Corsair Vengeance DDR5 32GB DDR5-5600', 'MEM-016', 'Corsair Vengeance DDR5 32GB DDR5-5600 de alto rendimiento', 244.45, 294.72, 34, 2, 'Estantería C-2', 'Memoria RAM', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('G.Skill Ripjaws S5 32GB DDR5-5200', 'MEM-017', 'G.Skill Ripjaws S5 32GB DDR5-5200 de alto rendimiento', 438.23, 694.18, 23, 5, 'Estantería B-5', 'Memoria RAM', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('ADATA XPG Lancer RGB 32GB DDR5-6000', 'MEM-018', 'ADATA XPG Lancer RGB 32GB DDR5-6000 de alto rendimiento', 430.53, 614.12, 58, 2, 'Estantería A-5', 'Memoria RAM', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Patriot Viper Venom RGB 32GB DDR5-6200', 'MEM-019', 'Patriot Viper Venom RGB 32GB DDR5-6200 de alto rendimiento', 228.65, 289.05, 88, 3, 'Estantería A-5', 'Memoria RAM', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Mushkin Redline 32GB DDR5-5600', 'MEM-020', 'Mushkin Redline 32GB DDR5-5600 de alto rendimiento', 424.29, 587.85, 72, 10, 'Estantería C-5', 'Memoria RAM', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Corsair Dominator Platinum RGB 64GB DDR5-5600', 'MEM-021', 'Corsair Dominator Platinum RGB 64GB DDR5-5600 de alto rendimiento', 292.13, 466.65, 95, 10, 'Estantería B-2', 'Memoria RAM', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('G.Skill Trident Z5 RGB 64GB DDR5-6400', 'MEM-022', 'G.Skill Trident Z5 RGB 64GB DDR5-6400 de alto rendimiento', 280.01, 445.95, 70, 5, 'Estantería C-1', 'Memoria RAM', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Kingston Fury Beast 64GB DDR5-6000', 'MEM-023', 'Kingston Fury Beast 64GB DDR5-6000 de alto rendimiento', 394.34, 548.67, 98, 9, 'Estantería A-3', 'Memoria RAM', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Crucial DDR5-5600 64GB', 'MEM-024', 'Crucial DDR5-5600 64GB de alto rendimiento', 566.1, 767.06, 71, 9, 'Estantería A-5', 'Memoria RAM', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('TeamGroup T-Force Delta RGB 64GB DDR5-6400', 'MEM-025', 'TeamGroup T-Force Delta RGB 64GB DDR5-6400 de alto rendimiento', 524.85, 775.73, 88, 10, 'Estantería B-2', 'Memoria RAM', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('NVIDIA GeForce RTX 4090', 'TAR-001', 'NVIDIA GeForce RTX 4090 de alto rendimiento', 594.76, 812.13, 40, 5, 'Estantería A-1', 'Tarjetas Gráficas', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('NVIDIA GeForce RTX 4080', 'TAR-002', 'NVIDIA GeForce RTX 4080 de alto rendimiento', 387.62, 595.66, 72, 7, 'Estantería A-5', 'Tarjetas Gráficas', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('NVIDIA GeForce RTX 4070 Ti', 'TAR-003', 'NVIDIA GeForce RTX 4070 Ti de alto rendimiento', 270.88, 377.22, 14, 6, 'Estantería A-5', 'Tarjetas Gráficas', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('NVIDIA GeForce RTX 4070', 'TAR-004', 'NVIDIA GeForce RTX 4070 de alto rendimiento', 534.42, 644.6, 79, 2, 'Estantería C-5', 'Tarjetas Gráficas', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('NVIDIA GeForce RTX 4060 Ti', 'TAR-005', 'NVIDIA GeForce RTX 4060 Ti de alto rendimiento', 371.88, 589.4, 59, 8, 'Estantería C-4', 'Tarjetas Gráficas', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('NVIDIA GeForce RTX 4060', 'TAR-006', 'NVIDIA GeForce RTX 4060 de alto rendimiento', 482.63, 677.79, 79, 5, 'Estantería B-1', 'Tarjetas Gráficas', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('NVIDIA GeForce RTX 3090 Ti', 'TAR-007', 'NVIDIA GeForce RTX 3090 Ti de alto rendimiento', 438.89, 591.37, 23, 4, 'Estantería B-5', 'Tarjetas Gráficas', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('NVIDIA GeForce RTX 3090', 'TAR-008', 'NVIDIA GeForce RTX 3090 de alto rendimiento', 267.44, 337.28, 80, 4, 'Estantería A-3', 'Tarjetas Gráficas', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('NVIDIA GeForce RTX 3080 Ti', 'TAR-009', 'NVIDIA GeForce RTX 3080 Ti de alto rendimiento', 162.58, 212.07, 61, 10, 'Estantería A-1', 'Tarjetas Gráficas', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('NVIDIA GeForce RTX 3080', 'TAR-010', 'NVIDIA GeForce RTX 3080 de alto rendimiento', 110.54, 150.73, 40, 10, 'Estantería C-1', 'Tarjetas Gráficas', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('NVIDIA GeForce RTX 3070 Ti', 'TAR-011', 'NVIDIA GeForce RTX 3070 Ti de alto rendimiento', 494.44, 691.73, 40, 7, 'Estantería A-3', 'Tarjetas Gráficas', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('NVIDIA GeForce RTX 3070', 'TAR-012', 'NVIDIA GeForce RTX 3070 de alto rendimiento', 542.58, 860.85, 65, 9, 'Estantería C-4', 'Tarjetas Gráficas', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('NVIDIA GeForce RTX 3060 Ti', 'TAR-013', 'NVIDIA GeForce RTX 3060 Ti de alto rendimiento', 132.39, 209.17, 37, 3, 'Estantería B-4', 'Tarjetas Gráficas', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('NVIDIA GeForce RTX 3060', 'TAR-014', 'NVIDIA GeForce RTX 3060 de alto rendimiento', 109.51, 143.45, 26, 8, 'Estantería A-5', 'Tarjetas Gráficas', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('NVIDIA GeForce RTX 3050', 'TAR-015', 'NVIDIA GeForce RTX 3050 de alto rendimiento', 374.28, 506.23, 29, 3, 'Estantería B-4', 'Tarjetas Gráficas', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('AMD Radeon RX 7900 XTX', 'TAR-016', 'AMD Radeon RX 7900 XTX de alto rendimiento', 224.85, 304.24, 87, 2, 'Estantería B-1', 'Tarjetas Gráficas', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('AMD Radeon RX 7900 XT', 'TAR-017', 'AMD Radeon RX 7900 XT de alto rendimiento', 593.73, 884.67, 83, 5, 'Estantería A-3', 'Tarjetas Gráficas', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('AMD Radeon RX 7800 XT', 'TAR-018', 'AMD Radeon RX 7800 XT de alto rendimiento', 570.71, 832.81, 74, 5, 'Estantería C-4', 'Tarjetas Gráficas', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('AMD Radeon RX 7700 XT', 'TAR-019', 'AMD Radeon RX 7700 XT de alto rendimiento', 316.63, 501.11, 34, 4, 'Estantería B-3', 'Tarjetas Gráficas', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('AMD Radeon RX 7600', 'TAR-020', 'AMD Radeon RX 7600 de alto rendimiento', 506.07, 669.38, 39, 10, 'Estantería A-5', 'Tarjetas Gráficas', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('AMD Radeon RX 6950 XT', 'TAR-021', 'AMD Radeon RX 6950 XT de alto rendimiento', 542.95, 853.92, 71, 9, 'Estantería A-3', 'Tarjetas Gráficas', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('AMD Radeon RX 6900 XT', 'TAR-022', 'AMD Radeon RX 6900 XT de alto rendimiento', 437.3, 574.5, 35, 5, 'Estantería C-2', 'Tarjetas Gráficas', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('AMD Radeon RX 6800 XT', 'TAR-023', 'AMD Radeon RX 6800 XT de alto rendimiento', 248.68, 386.77, 44, 9, 'Estantería A-4', 'Tarjetas Gráficas', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('AMD Radeon RX 6700 XT', 'TAR-024', 'AMD Radeon RX 6700 XT de alto rendimiento', 143.34, 183.01, 67, 6, 'Estantería C-2', 'Tarjetas Gráficas', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('AMD Radeon RX 6600 XT', 'TAR-025', 'AMD Radeon RX 6600 XT de alto rendimiento', 208.39, 290.08, 24, 9, 'Estantería C-2', 'Tarjetas Gráficas', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Samsung 980 PRO 1TB NVMe SSD', 'ALM-001', 'Samsung 980 PRO 1TB NVMe SSD de alto rendimiento', 270.78, 369.1, 68, 10, 'Estantería B-1', 'Almacenamiento', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Samsung 970 EVO Plus 1TB NVMe SSD', 'ALM-002', 'Samsung 970 EVO Plus 1TB NVMe SSD de alto rendimiento', 590.38, 940.47, 77, 8, 'Estantería C-4', 'Almacenamiento', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('WD Black SN850X 1TB NVMe SSD', 'ALM-003', 'WD Black SN850X 1TB NVMe SSD de alto rendimiento', 150.31, 216.95, 26, 9, 'Estantería B-4', 'Almacenamiento', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('WD Blue SN570 1TB NVMe SSD', 'ALM-004', 'WD Blue SN570 1TB NVMe SSD de alto rendimiento', 150.33, 183.85, 19, 7, 'Estantería B-2', 'Almacenamiento', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Crucial MX500 1TB SATA SSD', 'ALM-005', 'Crucial MX500 1TB SATA SSD de alto rendimiento', 522.43, 741.23, 62, 8, 'Estantería C-2', 'Almacenamiento', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Crucial P5 Plus 1TB NVMe SSD', 'ALM-006', 'Crucial P5 Plus 1TB NVMe SSD de alto rendimiento', 394.81, 610.1, 90, 2, 'Estantería C-5', 'Almacenamiento', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Kingston KC3000 1TB NVMe SSD', 'ALM-007', 'Kingston KC3000 1TB NVMe SSD de alto rendimiento', 505.04, 659.48, 49, 10, 'Estantería A-1', 'Almacenamiento', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Kingston A2000 1TB NVMe SSD', 'ALM-008', 'Kingston A2000 1TB NVMe SSD de alto rendimiento', 597.26, 942.67, 65, 5, 'Estantería A-4', 'Almacenamiento', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Seagate FireCuda 530 1TB NVMe SSD', 'ALM-009', 'Seagate FireCuda 530 1TB NVMe SSD de alto rendimiento', 119.06, 182.73, 62, 8, 'Estantería A-3', 'Almacenamiento', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Seagate Barracuda 2TB HDD', 'ALM-010', 'Seagate Barracuda 2TB HDD de alto rendimiento', 175.75, 219.3, 44, 4, 'Estantería A-1', 'Almacenamiento', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Toshiba X300 4TB HDD', 'ALM-011', 'Toshiba X300 4TB HDD de alto rendimiento', 477.36, 575.08, 52, 10, 'Estantería B-2', 'Almacenamiento', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('WD Blue 1TB HDD', 'ALM-012', 'WD Blue 1TB HDD de alto rendimiento', 476.79, 624.97, 40, 9, 'Estantería C-2', 'Almacenamiento', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('WD Black 2TB HDD', 'ALM-013', 'WD Black 2TB HDD de alto rendimiento', 210.17, 264.63, 40, 9, 'Estantería B-5', 'Almacenamiento', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Samsung 870 EVO 1TB SATA SSD', 'ALM-014', 'Samsung 870 EVO 1TB SATA SSD de alto rendimiento', 406.53, 525.89, 44, 5, 'Estantería C-1', 'Almacenamiento', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('SanDisk Extreme Portable SSD 1TB', 'ALM-015', 'SanDisk Extreme Portable SSD 1TB de alto rendimiento', 173.16, 228.79, 14, 10, 'Estantería C-4', 'Almacenamiento', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Corsair MP600 Pro XT 1TB NVMe SSD', 'ALM-016', 'Corsair MP600 Pro XT 1TB NVMe SSD de alto rendimiento', 454.72, 681.98, 89, 2, 'Estantería B-4', 'Almacenamiento', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Sabrent Rocket 4 Plus 1TB NVMe SSD', 'ALM-017', 'Sabrent Rocket 4 Plus 1TB NVMe SSD de alto rendimiento', 574.48, 763.68, 32, 2, 'Estantería C-3', 'Almacenamiento', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Intel 670p 1TB NVMe SSD', 'ALM-018', 'Intel 670p 1TB NVMe SSD de alto rendimiento', 205.27, 306.98, 57, 7, 'Estantería C-2', 'Almacenamiento', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('ADATA XPG GAMMIX S70 Blade 1TB NVMe SSD', 'ALM-019', 'ADATA XPG GAMMIX S70 Blade 1TB NVMe SSD de alto rendimiento', 150.49, 235.26, 64, 4, 'Estantería A-1', 'Almacenamiento', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('TeamGroup T-Force Cardea Zero Z440 1TB NVMe SSD', 'ALM-020', 'TeamGroup T-Force Cardea Zero Z440 1TB NVMe SSD de alto rendimiento', 239.48, 304.33, 64, 4, 'Estantería B-2', 'Almacenamiento', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Mushkin Enhanced Pilot-E 1TB NVMe SSD', 'ALM-021', 'Mushkin Enhanced Pilot-E 1TB NVMe SSD de alto rendimiento', 438.52, 608.49, 71, 4, 'Estantería B-3', 'Almacenamiento', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Patriot Viper VP4300 1TB NVMe SSD', 'ALM-022', 'Patriot Viper VP4300 1TB NVMe SSD de alto rendimiento', 139.67, 221.86, 93, 8, 'Estantería C-5', 'Almacenamiento', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('PNY XLR8 CS3040 1TB NVMe SSD', 'ALM-023', 'PNY XLR8 CS3040 1TB NVMe SSD de alto rendimiento', 283.48, 404.63, 20, 2, 'Estantería B-1', 'Almacenamiento', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Silicon Power US70 1TB NVMe SSD', 'ALM-024', 'Silicon Power US70 1TB NVMe SSD de alto rendimiento', 170.3, 267.39, 39, 5, 'Estantería B-3', 'Almacenamiento', '', 1);
INSERT OR IGNORE INTO productos (nombre, referencia, descripcion, precio_compra, precio_venta, stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id) VALUES ('Lexar NM790 1TB NVMe SSD', 'ALM-025', 'Lexar NM790 1TB NVMe SSD de alto rendimiento', 360.67, 441.48, 68, 6, 'Estantería C-4', 'Almacenamiento', '', 1);

-- INSERTS DE PRODUCTOS CON IMÁGENES

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Intel Core i9-13900K',
    'PRO-001',
    'Intel Core i9-13900K de alto rendimiento',
    419.64,
    534.58,
    84,
    3,
    'Estantería C-4',
    'Procesadores',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Intel Core i7-13700K',
    'PRO-002',
    'Intel Core i7-13700K de alto rendimiento',
    293.18,
    407.84,
    82,
    4,
    'Estantería C-4',
    'Procesadores',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Intel Core i5-13600K',
    'PRO-003',
    'Intel Core i5-13600K de alto rendimiento',
    453.73,
    639.98,
    40,
    10,
    'Estantería B-1',
    'Procesadores',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Intel Core i9-12900K',
    'PRO-004',
    'Intel Core i9-12900K de alto rendimiento',
    582.86,
    820.46,
    61,
    3,
    'Estantería A-4',
    'Procesadores',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Intel Core i7-12700K',
    'PRO-005',
    'Intel Core i7-12700K de alto rendimiento',
    409.66,
    539.87,
    63,
    9,
    'Estantería B-1',
    'Procesadores',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Intel Core i5-12600K',
    'PRO-006',
    'Intel Core i5-12600K de alto rendimiento',
    273.44,
    377.25,
    86,
    4,
    'Estantería B-4',
    'Procesadores',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Intel Core i9-11900K',
    'PRO-007',
    'Intel Core i9-11900K de alto rendimiento',
    590.07,
    816.87,
    72,
    4,
    'Estantería C-4',
    'Procesadores',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Intel Core i7-11700K',
    'PRO-008',
    'Intel Core i7-11700K de alto rendimiento',
    369.98,
    583.82,
    46,
    4,
    'Estantería A-3',
    'Procesadores',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Intel Core i5-11600K',
    'PRO-009',
    'Intel Core i5-11600K de alto rendimiento',
    150.25,
    225.0,
    57,
    5,
    'Estantería A-3',
    'Procesadores',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Intel Core i9-10900K',
    'PRO-010',
    'Intel Core i9-10900K de alto rendimiento',
    598.14,
    921.91,
    16,
    4,
    'Estantería B-5',
    'Procesadores',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Intel Core i7-10700K',
    'PRO-011',
    'Intel Core i7-10700K de alto rendimiento',
    326.17,
    480.65,
    74,
    10,
    'Estantería C-1',
    'Procesadores',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Intel Core i5-10600K',
    'PRO-012',
    'Intel Core i5-10600K de alto rendimiento',
    445.92,
    578.38,
    87,
    6,
    'Estantería A-1',
    'Procesadores',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'AMD Ryzen 9 7950X',
    'PRO-013',
    'AMD Ryzen 9 7950X de alto rendimiento',
    582.78,
    817.21,
    37,
    9,
    'Estantería A-3',
    'Procesadores',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'AMD Ryzen 9 7900X',
    'PRO-014',
    'AMD Ryzen 9 7900X de alto rendimiento',
    228.0,
    341.08,
    99,
    2,
    'Estantería B-4',
    'Procesadores',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'AMD Ryzen 7 7700X',
    'PRO-015',
    'AMD Ryzen 7 7700X de alto rendimiento',
    551.53,
    790.57,
    33,
    2,
    'Estantería A-3',
    'Procesadores',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'AMD Ryzen 5 7600X',
    'PRO-016',
    'AMD Ryzen 5 7600X de alto rendimiento',
    534.26,
    680.44,
    34,
    6,
    'Estantería C-5',
    'Procesadores',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'AMD Ryzen 9 5950X',
    'PRO-017',
    'AMD Ryzen 9 5950X de alto rendimiento',
    440.84,
    594.34,
    27,
    7,
    'Estantería B-3',
    'Procesadores',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'AMD Ryzen 9 5900X',
    'PRO-018',
    'AMD Ryzen 9 5900X de alto rendimiento',
    419.19,
    566.84,
    73,
    4,
    'Estantería B-4',
    'Procesadores',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'AMD Ryzen 7 5800X',
    'PRO-019',
    'AMD Ryzen 7 5800X de alto rendimiento',
    222.19,
    272.59,
    15,
    4,
    'Estantería A-4',
    'Procesadores',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'AMD Ryzen 5 5600X',
    'PRO-020',
    'AMD Ryzen 5 5600X de alto rendimiento',
    114.52,
    148.57,
    19,
    10,
    'Estantería A-5',
    'Procesadores',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'AMD Ryzen 9 3950X',
    'PRO-021',
    'AMD Ryzen 9 3950X de alto rendimiento',
    386.08,
    467.61,
    61,
    6,
    'Estantería C-4',
    'Procesadores',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'AMD Ryzen 9 3900X',
    'PRO-022',
    'AMD Ryzen 9 3900X de alto rendimiento',
    285.77,
    352.74,
    77,
    8,
    'Estantería C-5',
    'Procesadores',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'AMD Ryzen 7 3700X',
    'PRO-023',
    'AMD Ryzen 7 3700X de alto rendimiento',
    468.63,
    706.43,
    20,
    2,
    'Estantería A-5',
    'Procesadores',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'AMD Ryzen 5 3600X',
    'PRO-024',
    'AMD Ryzen 5 3600X de alto rendimiento',
    109.66,
    147.13,
    21,
    10,
    'Estantería A-2',
    'Procesadores',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'AMD Ryzen 5 3600',
    'PRO-025',
    'AMD Ryzen 5 3600 de alto rendimiento',
    330.23,
    433.66,
    49,
    2,
    'Estantería B-3',
    'Procesadores',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Corsair Vengeance LPX 16GB DDR4-3200',
    'MEM-001',
    'Corsair Vengeance LPX 16GB DDR4-3200 de alto rendimiento',
    596.9,
    757.8,
    76,
    9,
    'Estantería B-5',
    'Memoria RAM',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Corsair Vengeance RGB Pro 32GB DDR4-3600',
    'MEM-002',
    'Corsair Vengeance RGB Pro 32GB DDR4-3600 de alto rendimiento',
    591.5,
    760.19,
    78,
    6,
    'Estantería A-1',
    'Memoria RAM',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'G.Skill Trident Z RGB 16GB DDR4-3200',
    'MEM-003',
    'G.Skill Trident Z RGB 16GB DDR4-3200 de alto rendimiento',
    272.6,
    433.24,
    56,
    4,
    'Estantería C-2',
    'Memoria RAM',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'G.Skill Ripjaws V 16GB DDR4-3600',
    'MEM-004',
    'G.Skill Ripjaws V 16GB DDR4-3600 de alto rendimiento',
    459.24,
    621.03,
    59,
    6,
    'Estantería B-1',
    'Memoria RAM',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Kingston HyperX Fury 16GB DDR4-3200',
    'MEM-005',
    'Kingston HyperX Fury 16GB DDR4-3200 de alto rendimiento',
    209.43,
    266.24,
    40,
    7,
    'Estantería C-2',
    'Memoria RAM',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Crucial Ballistix 16GB DDR4-3200',
    'MEM-006',
    'Crucial Ballistix 16GB DDR4-3200 de alto rendimiento',
    596.64,
    772.93,
    29,
    10,
    'Estantería A-3',
    'Memoria RAM',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'TeamGroup T-Force Delta RGB 16GB DDR4-3200',
    'MEM-007',
    'TeamGroup T-Force Delta RGB 16GB DDR4-3200 de alto rendimiento',
    545.06,
    741.47,
    34,
    7,
    'Estantería B-2',
    'Memoria RAM',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Patriot Viper Steel 16GB DDR4-4400',
    'MEM-008',
    'Patriot Viper Steel 16GB DDR4-4400 de alto rendimiento',
    499.65,
    629.64,
    92,
    6,
    'Estantería C-4',
    'Memoria RAM',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'ADATA XPG Spectrix D60G 16GB DDR4-3200',
    'MEM-009',
    'ADATA XPG Spectrix D60G 16GB DDR4-3200 de alto rendimiento',
    599.49,
    914.0,
    29,
    7,
    'Estantería C-3',
    'Memoria RAM',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Mushkin Redline 16GB DDR4-3600',
    'MEM-010',
    'Mushkin Redline 16GB DDR4-3600 de alto rendimiento',
    259.83,
    362.46,
    21,
    5,
    'Estantería B-2',
    'Memoria RAM',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Corsair Dominator Platinum RGB 32GB DDR4-3200',
    'MEM-011',
    'Corsair Dominator Platinum RGB 32GB DDR4-3200 de alto rendimiento',
    462.19,
    696.64,
    25,
    10,
    'Estantería B-5',
    'Memoria RAM',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'G.Skill Trident Z5 RGB 32GB DDR5-6000',
    'MEM-012',
    'G.Skill Trident Z5 RGB 32GB DDR5-6000 de alto rendimiento',
    298.0,
    458.36,
    11,
    8,
    'Estantería C-2',
    'Memoria RAM',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Kingston Fury Beast 32GB DDR5-5200',
    'MEM-013',
    'Kingston Fury Beast 32GB DDR5-5200 de alto rendimiento',
    469.03,
    674.39,
    36,
    2,
    'Estantería C-2',
    'Memoria RAM',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Crucial DDR5-4800 16GB',
    'MEM-014',
    'Crucial DDR5-4800 16GB de alto rendimiento',
    542.2,
    862.63,
    93,
    10,
    'Estantería C-5',
    'Memoria RAM',
    'uploads/Crucial_DDR5-4800_16GB_20250422150957.png',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'TeamGroup T-Force Delta RGB 32GB DDR5-5600',
    'MEM-015',
    'TeamGroup T-Force Delta RGB 32GB DDR5-5600 de alto rendimiento',
    430.23,
    564.06,
    53,
    10,
    'Estantería B-1',
    'Memoria RAM',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Corsair Vengeance DDR5 32GB DDR5-5600',
    'MEM-016',
    'Corsair Vengeance DDR5 32GB DDR5-5600 de alto rendimiento',
    244.45,
    294.72,
    34,
    2,
    'Estantería C-2',
    'Memoria RAM',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'G.Skill Ripjaws S5 32GB DDR5-5200',
    'MEM-017',
    'G.Skill Ripjaws S5 32GB DDR5-5200 de alto rendimiento',
    438.23,
    694.18,
    23,
    5,
    'Estantería B-5',
    'Memoria RAM',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'ADATA XPG Lancer RGB 32GB DDR5-6000',
    'MEM-018',
    'ADATA XPG Lancer RGB 32GB DDR5-6000 de alto rendimiento',
    430.53,
    614.12,
    58,
    2,
    'Estantería A-5',
    'Memoria RAM',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Patriot Viper Venom RGB 32GB DDR5-6200',
    'MEM-019',
    'Patriot Viper Venom RGB 32GB DDR5-6200 de alto rendimiento',
    228.65,
    289.05,
    88,
    3,
    'Estantería A-5',
    'Memoria RAM',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Mushkin Redline 32GB DDR5-5600',
    'MEM-020',
    'Mushkin Redline 32GB DDR5-5600 de alto rendimiento',
    424.29,
    587.85,
    72,
    10,
    'Estantería C-5',
    'Memoria RAM',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Corsair Dominator Platinum RGB 64GB DDR5-5600',
    'MEM-021',
    'Corsair Dominator Platinum RGB 64GB DDR5-5600 de alto rendimiento',
    292.13,
    466.65,
    95,
    10,
    'Estantería B-2',
    'Memoria RAM',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'G.Skill Trident Z5 RGB 64GB DDR5-6400',
    'MEM-022',
    'G.Skill Trident Z5 RGB 64GB DDR5-6400 de alto rendimiento',
    280.01,
    445.95,
    70,
    5,
    'Estantería C-1',
    'Memoria RAM',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Kingston Fury Beast 64GB DDR5-6000',
    'MEM-023',
    'Kingston Fury Beast 64GB DDR5-6000 de alto rendimiento',
    394.34,
    548.67,
    98,
    9,
    'Estantería A-3',
    'Memoria RAM',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Crucial DDR5-5600 64GB',
    'MEM-024',
    'Crucial DDR5-5600 64GB de alto rendimiento',
    566.1,
    767.06,
    71,
    9,
    'Estantería A-5',
    'Memoria RAM',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'TeamGroup T-Force Delta RGB 64GB DDR5-6400',
    'MEM-025',
    'TeamGroup T-Force Delta RGB 64GB DDR5-6400 de alto rendimiento',
    524.85,
    775.73,
    88,
    10,
    'Estantería B-2',
    'Memoria RAM',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'NVIDIA GeForce RTX 4090',
    'TAR-001',
    'NVIDIA GeForce RTX 4090 de alto rendimiento',
    594.76,
    812.13,
    40,
    5,
    'Estantería A-1',
    'Tarjetas Gráficas',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'NVIDIA GeForce RTX 4080',
    'TAR-002',
    'NVIDIA GeForce RTX 4080 de alto rendimiento',
    387.62,
    595.66,
    72,
    7,
    'Estantería A-5',
    'Tarjetas Gráficas',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'NVIDIA GeForce RTX 4070 Ti',
    'TAR-003',
    'NVIDIA GeForce RTX 4070 Ti de alto rendimiento',
    270.88,
    377.22,
    14,
    6,
    'Estantería A-5',
    'Tarjetas Gráficas',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'NVIDIA GeForce RTX 4070',
    'TAR-004',
    'NVIDIA GeForce RTX 4070 de alto rendimiento',
    534.42,
    644.6,
    79,
    2,
    'Estantería C-5',
    'Tarjetas Gráficas',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'NVIDIA GeForce RTX 4060 Ti',
    'TAR-005',
    'NVIDIA GeForce RTX 4060 Ti de alto rendimiento',
    371.88,
    589.4,
    59,
    8,
    'Estantería C-4',
    'Tarjetas Gráficas',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'NVIDIA GeForce RTX 4060',
    'TAR-006',
    'NVIDIA GeForce RTX 4060 de alto rendimiento',
    482.63,
    677.79,
    79,
    5,
    'Estantería B-1',
    'Tarjetas Gráficas',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'NVIDIA GeForce RTX 3090 Ti',
    'TAR-007',
    'NVIDIA GeForce RTX 3090 Ti de alto rendimiento',
    438.89,
    591.37,
    23,
    4,
    'Estantería B-5',
    'Tarjetas Gráficas',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'NVIDIA GeForce RTX 3090',
    'TAR-008',
    'NVIDIA GeForce RTX 3090 de alto rendimiento',
    267.44,
    337.28,
    80,
    4,
    'Estantería A-3',
    'Tarjetas Gráficas',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'NVIDIA GeForce RTX 3080 Ti',
    'TAR-009',
    'NVIDIA GeForce RTX 3080 Ti de alto rendimiento',
    162.58,
    212.07,
    61,
    10,
    'Estantería A-1',
    'Tarjetas Gráficas',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'NVIDIA GeForce RTX 3080',
    'TAR-010',
    'NVIDIA GeForce RTX 3080 de alto rendimiento',
    110.54,
    150.73,
    40,
    10,
    'Estantería C-1',
    'Tarjetas Gráficas',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'NVIDIA GeForce RTX 3070 Ti',
    'TAR-011',
    'NVIDIA GeForce RTX 3070 Ti de alto rendimiento',
    494.44,
    691.73,
    40,
    7,
    'Estantería A-3',
    'Tarjetas Gráficas',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'NVIDIA GeForce RTX 3070',
    'TAR-012',
    'NVIDIA GeForce RTX 3070 de alto rendimiento',
    542.58,
    860.85,
    65,
    9,
    'Estantería C-4',
    'Tarjetas Gráficas',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'NVIDIA GeForce RTX 3060 Ti',
    'TAR-013',
    'NVIDIA GeForce RTX 3060 Ti de alto rendimiento',
    132.39,
    209.17,
    37,
    3,
    'Estantería B-4',
    'Tarjetas Gráficas',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'NVIDIA GeForce RTX 3060',
    'TAR-014',
    'NVIDIA GeForce RTX 3060 de alto rendimiento',
    109.51,
    143.45,
    26,
    8,
    'Estantería A-5',
    'Tarjetas Gráficas',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'NVIDIA GeForce RTX 3050',
    'TAR-015',
    'NVIDIA GeForce RTX 3050 de alto rendimiento',
    374.28,
    506.23,
    29,
    3,
    'Estantería B-4',
    'Tarjetas Gráficas',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'AMD Radeon RX 7900 XTX',
    'TAR-016',
    'AMD Radeon RX 7900 XTX de alto rendimiento',
    224.85,
    304.24,
    87,
    2,
    'Estantería B-1',
    'Tarjetas Gráficas',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'AMD Radeon RX 7900 XT',
    'TAR-017',
    'AMD Radeon RX 7900 XT de alto rendimiento',
    593.73,
    884.67,
    83,
    5,
    'Estantería A-3',
    'Tarjetas Gráficas',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'AMD Radeon RX 7800 XT',
    'TAR-018',
    'AMD Radeon RX 7800 XT de alto rendimiento',
    570.71,
    832.81,
    74,
    5,
    'Estantería C-4',
    'Tarjetas Gráficas',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'AMD Radeon RX 7700 XT',
    'TAR-019',
    'AMD Radeon RX 7700 XT de alto rendimiento',
    316.63,
    501.11,
    34,
    4,
    'Estantería B-3',
    'Tarjetas Gráficas',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'AMD Radeon RX 7600',
    'TAR-020',
    'AMD Radeon RX 7600 de alto rendimiento',
    506.07,
    669.38,
    39,
    10,
    'Estantería A-5',
    'Tarjetas Gráficas',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'AMD Radeon RX 6950 XT',
    'TAR-021',
    'AMD Radeon RX 6950 XT de alto rendimiento',
    542.95,
    853.92,
    71,
    9,
    'Estantería A-3',
    'Tarjetas Gráficas',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'AMD Radeon RX 6900 XT',
    'TAR-022',
    'AMD Radeon RX 6900 XT de alto rendimiento',
    437.3,
    574.5,
    35,
    5,
    'Estantería C-2',
    'Tarjetas Gráficas',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'AMD Radeon RX 6800 XT',
    'TAR-023',
    'AMD Radeon RX 6800 XT de alto rendimiento',
    248.68,
    386.77,
    44,
    9,
    'Estantería A-4',
    'Tarjetas Gráficas',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'AMD Radeon RX 6700 XT',
    'TAR-024',
    'AMD Radeon RX 6700 XT de alto rendimiento',
    143.34,
    183.01,
    67,
    6,
    'Estantería C-2',
    'Tarjetas Gráficas',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'AMD Radeon RX 6600 XT',
    'TAR-025',
    'AMD Radeon RX 6600 XT de alto rendimiento',
    208.39,
    290.08,
    24,
    9,
    'Estantería C-2',
    'Tarjetas Gráficas',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Samsung 980 PRO 1TB NVMe SSD',
    'ALM-001',
    'Samsung 980 PRO 1TB NVMe SSD de alto rendimiento',
    270.78,
    369.1,
    68,
    10,
    'Estantería B-1',
    'Almacenamiento',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Samsung 970 EVO Plus 1TB NVMe SSD',
    'ALM-002',
    'Samsung 970 EVO Plus 1TB NVMe SSD de alto rendimiento',
    590.38,
    940.47,
    77,
    8,
    'Estantería C-4',
    'Almacenamiento',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'WD Black SN850X 1TB NVMe SSD',
    'ALM-003',
    'WD Black SN850X 1TB NVMe SSD de alto rendimiento',
    150.31,
    216.95,
    26,
    9,
    'Estantería B-4',
    'Almacenamiento',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'WD Blue SN570 1TB NVMe SSD',
    'ALM-004',
    'WD Blue SN570 1TB NVMe SSD de alto rendimiento',
    150.33,
    183.85,
    19,
    7,
    'Estantería B-2',
    'Almacenamiento',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Crucial MX500 1TB SATA SSD',
    'ALM-005',
    'Crucial MX500 1TB SATA SSD de alto rendimiento',
    522.43,
    741.23,
    62,
    8,
    'Estantería C-2',
    'Almacenamiento',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Crucial P5 Plus 1TB NVMe SSD',
    'ALM-006',
    'Crucial P5 Plus 1TB NVMe SSD de alto rendimiento',
    394.81,
    610.1,
    90,
    2,
    'Estantería C-5',
    'Almacenamiento',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Kingston KC3000 1TB NVMe SSD',
    'ALM-007',
    'Kingston KC3000 1TB NVMe SSD de alto rendimiento',
    505.04,
    659.48,
    49,
    10,
    'Estantería A-1',
    'Almacenamiento',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Kingston A2000 1TB NVMe SSD',
    'ALM-008',
    'Kingston A2000 1TB NVMe SSD de alto rendimiento',
    597.26,
    942.67,
    65,
    5,
    'Estantería A-4',
    'Almacenamiento',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Seagate FireCuda 530 1TB NVMe SSD',
    'ALM-009',
    'Seagate FireCuda 530 1TB NVMe SSD de alto rendimiento',
    119.06,
    182.73,
    62,
    8,
    'Estantería A-3',
    'Almacenamiento',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Seagate Barracuda 2TB HDD',
    'ALM-010',
    'Seagate Barracuda 2TB HDD de alto rendimiento',
    175.75,
    219.3,
    44,
    4,
    'Estantería A-1',
    'Almacenamiento',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Toshiba X300 4TB HDD',
    'ALM-011',
    'Toshiba X300 4TB HDD de alto rendimiento',
    477.36,
    575.08,
    52,
    10,
    'Estantería B-2',
    'Almacenamiento',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'WD Blue 1TB HDD',
    'ALM-012',
    'WD Blue 1TB HDD de alto rendimiento',
    476.79,
    624.97,
    40,
    9,
    'Estantería C-2',
    'Almacenamiento',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'WD Black 2TB HDD',
    'ALM-013',
    'WD Black 2TB HDD de alto rendimiento',
    210.17,
    264.63,
    40,
    9,
    'Estantería B-5',
    'Almacenamiento',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Samsung 870 EVO 1TB SATA SSD',
    'ALM-014',
    'Samsung 870 EVO 1TB SATA SSD de alto rendimiento',
    406.53,
    525.89,
    44,
    5,
    'Estantería C-1',
    'Almacenamiento',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'SanDisk Extreme Portable SSD 1TB',
    'ALM-015',
    'SanDisk Extreme Portable SSD 1TB de alto rendimiento',
    173.16,
    228.79,
    14,
    10,
    'Estantería C-4',
    'Almacenamiento',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Corsair MP600 Pro XT 1TB NVMe SSD',
    'ALM-016',
    'Corsair MP600 Pro XT 1TB NVMe SSD de alto rendimiento',
    454.72,
    681.98,
    89,
    2,
    'Estantería B-4',
    'Almacenamiento',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Sabrent Rocket 4 Plus 1TB NVMe SSD',
    'ALM-017',
    'Sabrent Rocket 4 Plus 1TB NVMe SSD de alto rendimiento',
    574.48,
    763.68,
    32,
    2,
    'Estantería C-3',
    'Almacenamiento',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Intel 670p 1TB NVMe SSD',
    'ALM-018',
    'Intel 670p 1TB NVMe SSD de alto rendimiento',
    205.27,
    306.98,
    57,
    7,
    'Estantería C-2',
    'Almacenamiento',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'ADATA XPG GAMMIX S70 Blade 1TB NVMe SSD',
    'ALM-019',
    'ADATA XPG GAMMIX S70 Blade 1TB NVMe SSD de alto rendimiento',
    150.49,
    235.26,
    64,
    4,
    'Estantería A-1',
    'Almacenamiento',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'TeamGroup T-Force Cardea Zero Z440 1TB NVMe SSD',
    'ALM-020',
    'TeamGroup T-Force Cardea Zero Z440 1TB NVMe SSD de alto rendimiento',
    239.48,
    304.33,
    64,
    4,
    'Estantería B-2',
    'Almacenamiento',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Mushkin Enhanced Pilot-E 1TB NVMe SSD',
    'ALM-021',
    'Mushkin Enhanced Pilot-E 1TB NVMe SSD de alto rendimiento',
    438.52,
    608.49,
    71,
    4,
    'Estantería B-3',
    'Almacenamiento',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Patriot Viper VP4300 1TB NVMe SSD',
    'ALM-022',
    'Patriot Viper VP4300 1TB NVMe SSD de alto rendimiento',
    139.67,
    221.86,
    93,
    8,
    'Estantería C-5',
    'Almacenamiento',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'PNY XLR8 CS3040 1TB NVMe SSD',
    'ALM-023',
    'PNY XLR8 CS3040 1TB NVMe SSD de alto rendimiento',
    283.48,
    404.63,
    20,
    2,
    'Estantería B-1',
    'Almacenamiento',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Silicon Power US70 1TB NVMe SSD',
    'ALM-024',
    'Silicon Power US70 1TB NVMe SSD de alto rendimiento',
    170.3,
    267.39,
    39,
    5,
    'Estantería B-3',
    'Almacenamiento',
    '',
    1
);

INSERT OR IGNORE INTO productos (
    nombre, referencia, descripcion, precio_compra, precio_venta,
    stock_actual, stock_minimo, ubicacion_almacen, categoria, imagen, proveedor_id
) VALUES (
    'Lexar NM790 1TB NVMe SSD',
    'ALM-025',
    'Lexar NM790 1TB NVMe SSD de alto rendimiento',
    360.67,
    441.48,
    68,
    6,
    'Estantería C-4',
    'Almacenamiento',
    '',
    1
);