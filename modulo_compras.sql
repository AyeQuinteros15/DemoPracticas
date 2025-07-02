drop database if exists modulo_compras;
CREATE DATABASE IF NOT EXISTS modulo_compras;
USE modulo_compras;

-- Perfiles de usuario
CREATE TABLE perfiles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom_perfil VARCHAR(30) NOT NULL UNIQUE
);

-- Sucursales
CREATE TABLE sucursales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom_suc VARCHAR(50) NOT NULL UNIQUE,
    direccion_suc VARCHAR(150)
);

-- Usuarios
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom_usuario VARCHAR(40) NOT NULL,
    apellido_usuario VARCHAR(40) NOT NULL,
    usuario VARCHAR(30) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    perfil_id INT NOT NULL,
    sucursal_id INT,
    FOREIGN KEY (perfil_id) REFERENCES perfiles(id),
    FOREIGN KEY (sucursal_id) REFERENCES sucursales(id)
);

-- Sectores
CREATE TABLE sectores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

-- Estados de Notas de Pedido
CREATE TABLE estados_np (
    id INT AUTO_INCREMENT PRIMARY KEY,
    estados_np VARCHAR(30) NOT NULL UNIQUE
);

-- Estados de Órdenes de Compra
CREATE TABLE estados_oc (
    id INT AUTO_INCREMENT PRIMARY KEY,
    estados_oc VARCHAR(40) NOT NULL UNIQUE
);

-- Proveedores
CREATE TABLE proveedores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom_proveedor VARCHAR(40) NOT NULL,
    apellido_proveedor VARCHAR(40) NOT NULL,
    dni_prov VARCHAR(20) UNIQUE,
    telefono VARCHAR(20)
);

-- Notas de Pedido
CREATE TABLE notas_pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero VARCHAR(20) UNIQUE NOT NULL,
    usuario_id INT NOT NULL,
    sucursal_id INT NOT NULL,
    sector_id INT NOT NULL,
    descripcion TEXT,
    prioridad BOOLEAN DEFAULT FALSE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_entrega DATE,
    gerente_solicitante VARCHAR(50),
    observaciones TEXT,
    archivo_adjunto VARCHAR(255),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (sucursal_id) REFERENCES sucursales(id),
    FOREIGN KEY (sector_id) REFERENCES sectores(id)
);

-- Ítems de Notas de Pedido
CREATE TABLE items_np (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nota_pedido_id INT NOT NULL,
    descripcion TEXT NOT NULL,
    cantidad INT NOT NULL,
    FOREIGN KEY (nota_pedido_id) REFERENCES notas_pedido(id)
);

-- Historial de Estados de NP
CREATE TABLE historial_np (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nota_pedido_id INT NOT NULL,
    estado_id INT NOT NULL,
    usuario_id INT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    observaciones TEXT,
    FOREIGN KEY (nota_pedido_id) REFERENCES notas_pedido(id),
    FOREIGN KEY (estado_id) REFERENCES estados_np(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Órdenes de Compra
CREATE TABLE ordenes_compra (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero VARCHAR(20) UNIQUE NOT NULL,
    nota_pedido_id INT NOT NULL,
    proveedor_id INT,
    numero_cotizacion VARCHAR(30),
    fecha_emision TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_recepcion DATE,
    observaciones TEXT,
    observaciones_internas TEXT,
    archivo_pdf VARCHAR(255),
    descuento_porcentaje DECIMAL(5,2),
    iva_porcentaje DECIMAL(5,2),
    otro_impuesto_porcentaje DECIMAL(5,2),
    fecha_vencimiento DATE,
    creado_por INT,
    total_factura float,
    FOREIGN KEY (nota_pedido_id) REFERENCES notas_pedido(id),
    FOREIGN KEY (proveedor_id) REFERENCES proveedores(id),
    FOREIGN KEY (creado_por) REFERENCES usuarios(id)
);

-- Ítems de Órdenes de Compra
CREATE TABLE items_oc (
    id INT AUTO_INCREMENT PRIMARY KEY,
    orden_compra_id INT NOT NULL,
    descripcion TEXT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2),
    centro_costo varchar(100),
    precio_total DECIMAL(10,2),
    FOREIGN KEY (orden_compra_id) REFERENCES ordenes_compra(id)
);

-- Historial de Estados de OC
CREATE TABLE historial_oc (
    id INT AUTO_INCREMENT PRIMARY KEY,
    orden_compra_id INT NOT NULL,
    estado_id INT NOT NULL,
    usuario_id INT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    observaciones TEXT,
    FOREIGN KEY (orden_compra_id) REFERENCES ordenes_compra(id),
    FOREIGN KEY (estado_id) REFERENCES estados_oc(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);



-- Entregas parciales de OC
CREATE TABLE entregas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    orden_compra_id INT NOT NULL,
    item_oc_id INT,
    producto VARCHAR(60) NOT NULL,
    cantidad INT NOT NULL,
    usuario_id INT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (orden_compra_id) REFERENCES ordenes_compra(id),
    FOREIGN KEY (item_oc_id) REFERENCES items_oc(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Facturas y Remitosproductos
CREATE TABLE facturas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    orden_compra_id INT NOT NULL,
    numero_factura VARCHAR(30),
    numero_remito VARCHAR(30),
    archivo_pdf VARCHAR(255) NOT NULL,
    fecha DATE,
    FOREIGN KEY (orden_compra_id) REFERENCES ordenes_compra(id)
);

-- Control de Stock
CREATE TABLE stock (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sucursal_id INT NOT NULL,
    producto VARCHAR(60),
    cantidad INT DEFAULT 0,
    minimo INT DEFAULT 0,
    maximo INT DEFAULT 0, #actual
    FOREIGN KEY (sucursal_id) REFERENCES sucursales(id)
);

CREATE TABLE categorias_productos (
    id int auto_increment primary key,
    categoria_prod varchar(50) not null unique,
    descripcion text
);
CREATE TABLE productos (
    id int auto_increment primary key,
    codigo_producto varchar(30) unique not null,
    nom_producto varchar(50) not null,
    descripcion_producto TEXT,
    categoria_id int,
    foreign key (categoria_id) references categorias_productos(id)
);

ALTER TABLE items_np
ADD COLUMN producto_id INT AFTER nota_pedido_id,
ADD CONSTRAINT fk_producto_items_np FOREIGN KEY (producto_id) REFERENCES productos(id);

ALTER TABLE items_oc ADD COLUMN producto_id INT;
ALTER TABLE items_oc ADD CONSTRAINT fk_producto_id FOREIGN KEY (producto_id) REFERENCES productos(id);
ALTER TABLE items_oc DROP COLUMN descripcion;

ALTER TABLE usuarios
ADD COLUMN firma_img VARCHAR(255);

ALTER TABLE stock
ADD COLUMN producto_id INT AFTER sucursal_id,
ADD CONSTRAINT fk_producto_stock FOREIGN KEY (producto_id) REFERENCES productos(id);

ALTER TABLE ordenes_compra ADD COLUMN archivo_adjunto VARCHAR(255);

ALTER TABLE ordenes_compra ADD fecha_observacion TIMESTAMP NULL;
ALTER TABLE ordenes_compra ADD fecha_apobacion TIMESTAMP NULL;
ALTER TABLE notas_pedido ADD fecha_observacion TIMESTAMP NULL;
ALTER TABLE notas_pedido ADD fecha_aprobacion TIMESTAMP NULL;

alter table notas_pedido add id_observador int,
add constraint fk_id_observador foreign key (id_observador) references usuarios (id);

alter table ordenes_compra add id_observador int,
add constraint fk_id_observador1 foreign key (id_observador) references usuarios (id);

alter table stock
drop column maximo;

insert into perfiles(nom_perfil) values
("Administrador"),
("Operador");

insert into sucursales (nom_suc) values
("Tarjeta Sucredito"),
("Banco Sucredito Regional"),
("Edificio Pje Bertres"),
("Edificio Santa Fe");

insert into usuarios (nom_usuario,apellido_usuario,usuario,password,perfil_id,sucursal_id) values
("Paola", "Paez", "admin", "admin", 1,1),
("Juan", "Lopez", "operador", "operador", 2,2);

insert into sectores (nombre) values
("Compras"),
("Logistica"),
("Ventas");

INSERT INTO estados_np (estados_np) VALUES
('Generada'),
('Observada'),
('Aprobada'),
('Rechazada');


INSERT INTO estados_oc (estados_oc) VALUES
('Generada'),
#('En circuito'),
('Observada'),
#('Aprobada por monto 1'),
#('Aprobada por monto 2'),
#('Aprobada por monto 3'),
#('Enviada al proveedor'),
#('OC recibida'),
('Rechazada'),
("Aprobada");

insert into estados_oc (estados_oc) values ("Aprobada");

INSERT INTO proveedores (nom_proveedor, apellido_proveedor, dni_prov, telefono) VALUES
('Carlos', 'Mendez', '12345678', '099123456'),
('Ana', 'Rodriguez', '87654321', '098654321'),
('Tecnologia', 'S.A.', '13579246', '21234567'),
('Suministros', 'Industriales', '24680135', '22345678');

-- Sucursal: Tarjeta Sucredito (id=1)
INSERT INTO stock (sucursal_id, producto, cantidad, minimo, maximo) VALUES
(1, 'Impresora', 10, 5, 20),
(1, 'Cartucho de Tinta', 25, 10, 50),
(1, 'Teclado USB', 15, 5, 30);

-- Sucursal: Edificio Santa Fe (id=4)
INSERT INTO stock (sucursal_id, producto, cantidad, minimo, maximo) VALUES
(4, 'Monitor LCD 24"', 8, 3, 15),
(4, 'Mouse Inalámbrico', 12, 5, 20);

select * from sucursales;

select * from productos;

select * from notas_pedido;

select * from ordenes_compra;

select * from stock;

select * from categorias_productos;

update usuarios set firma_img = 'firmas/user1.jpg' where usuario = 'admin';
update usuarios set firma_img = 'firmas/user2.jpeg' where usuario = 'operador';
