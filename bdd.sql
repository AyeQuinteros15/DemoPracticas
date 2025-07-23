CREATE DATABASE IF NOT EXISTS modulo_compras;
USE modulo_compras;

CREATE TABLE provincias (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nom_provincia VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE localidades (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nom_localidad VARCHAR(50) NOT NULL,
  provincia_id INT NOT NULL,
  FOREIGN KEY (provincia_id) REFERENCES provincias(id)
);

CREATE TABLE direcciones (
  id INT AUTO_INCREMENT PRIMARY KEY,
  direccion VARCHAR(60),
  codigo_postal VARCHAR(10),
  localidad_id INT NOT NULL,
  FOREIGN KEY (localidad_id) REFERENCES localidades(id)
);

CREATE TABLE perfiles (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nom_perfil VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE sucursales (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nom_suc VARCHAR(50) NOT NULL UNIQUE,
  direccion_id INT,
  FOREIGN KEY (direccion_id) REFERENCES direcciones(id)
);

CREATE TABLE sectores (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nom_sector VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nom_usuario VARCHAR(40) NOT NULL,
  apellido_usuario VARCHAR(40) NOT NULL,
  usuario VARCHAR(30) UNIQUE NOT NULL,
  password VARCHAR(50) NOT NULL,
  perfil_id INT NOT NULL,
  sucursal_id INT,
  sector_id INT,
  firma_img VARCHAR(100),
  firma_fecha DATETIME,
  FOREIGN KEY (perfil_id)   REFERENCES perfiles(id),
  FOREIGN KEY (sucursal_id) REFERENCES sucursales(id),
  FOREIGN KEY (sector_id)   REFERENCES sectores(id)
);

CREATE TABLE estados_np (
  id INT AUTO_INCREMENT PRIMARY KEY,
  estados_np VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE estados_oc (
  id INT AUTO_INCREMENT PRIMARY KEY,
  estados_oc VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE categorias_productos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  categoria_prod VARCHAR(50) NOT NULL UNIQUE,
  descripcion TEXT
);

CREATE TABLE productos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  codigo_producto VARCHAR(30) UNIQUE NOT NULL,
  nom_producto VARCHAR(50) NOT NULL,
  descripcion_producto TEXT,
  categoria_id INT,
  FOREIGN KEY (categoria_id) REFERENCES categorias_productos(id)
);

CREATE TABLE proveedores (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nom_proveedor VARCHAR(40) NOT NULL,
  razon_social VARCHAR(100),
  direccion_id INT,
  contacto VARCHAR(50),
  celular VARCHAR(30),
  condicion_iibb VARCHAR(50),
  FOREIGN KEY (direccion_id) REFERENCES direcciones(id)
);

CREATE TABLE stock (
  id INT AUTO_INCREMENT PRIMARY KEY,
  sucursal_id INT NOT NULL,
  producto_id INT,
  cantidad_actual INT DEFAULT 0,
  FOREIGN KEY (sucursal_id) REFERENCES sucursales(id),
  FOREIGN KEY (producto_id)  REFERENCES productos(id)
);

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
  fecha_observacion TIMESTAMP NULL,
  fecha_aprobacion TIMESTAMP NULL,
  id_observador INT,
  responsable_solicitud VARCHAR(100),
  stock_regional INT,
  motivo_rechazo TEXT,
  estado_asignacion BOOLEAN DEFAULT FALSE,
  fecha_firma TIMESTAMP,
  firma_usuario_id INT,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
  FOREIGN KEY (sucursal_id) REFERENCES sucursales(id),
  FOREIGN KEY (sector_id) REFERENCES sectores(id),
  FOREIGN KEY (id_observador) REFERENCES usuarios(id),
  FOREIGN KEY (firma_usuario_id) REFERENCES usuarios(id)
);

CREATE TABLE items_np (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nota_pedido_id INT NOT NULL,
  producto_id INT,
  descripcion TEXT NOT NULL,
  cantidad INT NOT NULL,
  FOREIGN KEY (nota_pedido_id) REFERENCES notas_pedido(id),
  FOREIGN KEY (producto_id)     REFERENCES productos(id)
);

CREATE TABLE historial_np (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nota_pedido_id INT NOT NULL,
  estado_id INT NOT NULL,
  usuario_id INT NOT NULL,
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  observaciones TEXT,
  FOREIGN KEY (nota_pedido_id) REFERENCES notas_pedido(id),
  FOREIGN KEY (estado_id)       REFERENCES estados_np(id),
  FOREIGN KEY (usuario_id)      REFERENCES usuarios(id)
);

CREATE TABLE cotejo_presupuestos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  codigo_cotejo VARCHAR(20) UNIQUE NOT NULL,
  nota_pedido_id INT,
  fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
  observaciones TEXT,
  proveedor_sugerido_id INT,
  cotejo_padre_id INT,
  FOREIGN KEY (nota_pedido_id)          REFERENCES notas_pedido(id),
  FOREIGN KEY (proveedor_sugerido_id)   REFERENCES proveedores(id),
  FOREIGN KEY (cotejo_padre_id)         REFERENCES cotejo_presupuestos(id)
);

CREATE TABLE cotejo_ofertas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  cotejo_presupuesto_id INT NOT NULL,
  proveedor_id INT NOT NULL,
  descripcion TEXT NOT NULL,
  cantidad DECIMAL(10,2),
  unidad VARCHAR(20),
  precio_unitario DECIMAL(12,2),
  precio_total DECIMAL(12,2),
  condicion_fiscal VARCHAR(100),
  forma_pago VARCHAR(100),
  plazo_entrega VARCHAR(100),
  lugar_entrega VARCHAR(100),
  motivo_seleccion TEXT,
  visible BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (cotejo_presupuesto_id) REFERENCES cotejo_presupuestos(id),
  FOREIGN KEY (proveedor_id)            REFERENCES proveedores(id)
);

CREATE TABLE ordenes_compra (
  id INT AUTO_INCREMENT PRIMARY KEY,
  numero VARCHAR(20) UNIQUE NOT NULL,
  nota_pedido_id INT NOT NULL,
  proveedor_id INT,
  numero_cotizacion VARCHAR(30),
  fecha_emision TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_recepcion DATE,
  observaciones TEXT,
  archivo_pdf VARCHAR(255),
  descuento_porcentaje INT,
  iva_porcentaje DECIMAL(5,2),
  otro_impuesto_porcentaje DECIMAL(5,2),
  fecha_vencimiento DATE,
  creado_por INT,
  total_factura DECIMAL(12,2),
  fecha_observacion TIMESTAMP NULL,
  fecha_aprobacion TIMESTAMP NULL,
  id_observador INT,
  forma_pago VARCHAR(50),
  cbu VARCHAR(30),
  titular_cuenta VARCHAR(100),
  lugar_entrega VARCHAR(150),
  estado_notificado BOOLEAN DEFAULT FALSE,
  observacion_interna TEXT,
  orden_compra_anterior_id INT,
  requiere_entrega_rapida BOOLEAN DEFAULT FALSE,
  orden_compra_clonada_de_id INT,
  FOREIGN KEY (nota_pedido_id)            REFERENCES notas_pedido(id),
  FOREIGN KEY (proveedor_id)              REFERENCES proveedores(id),
  FOREIGN KEY (creado_por)                REFERENCES usuarios(id),
  FOREIGN KEY (id_observador)             REFERENCES usuarios(id),
  FOREIGN KEY (orden_compra_anterior_id)  REFERENCES ordenes_compra(id),
  FOREIGN KEY (orden_compra_clonada_de_id)REFERENCES ordenes_compra(id)
);

CREATE TABLE items_oc (
  id INT AUTO_INCREMENT PRIMARY KEY,
  orden_compra_id INT NOT NULL,
  producto_id INT,
  descripcion TEXT NOT NULL,
  cantidad INT NOT NULL,
  precio_unitario DECIMAL(10,2),
  precio_total DECIMAL(12,2),
  centro_costo VARCHAR(100),
  descuento_porcentaje DECIMAL(5,2),
  iva_porcentaje DECIMAL(5,2),
  FOREIGN KEY (orden_compra_id) REFERENCES ordenes_compra(id),
  FOREIGN KEY (producto_id)       REFERENCES productos(id)
);

CREATE TABLE historial_oc (
  id INT AUTO_INCREMENT PRIMARY KEY,
  orden_compra_id INT NOT NULL,
  estado_id INT NOT NULL,
  usuario_id INT NOT NULL,
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  observaciones TEXT,
  FOREIGN KEY (orden_compra_id) REFERENCES ordenes_compra(id),
  FOREIGN KEY (estado_id)       REFERENCES estados_oc(id),
  FOREIGN KEY (usuario_id)      REFERENCES usuarios(id)
);

CREATE TABLE entregas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  orden_compra_id INT NOT NULL,
  item_oc_id INT,
  producto VARCHAR(60) NOT NULL,
  cantidad INT NOT NULL,
  usuario_id INT NOT NULL,
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (orden_compra_id) REFERENCES ordenes_compra(id),
  FOREIGN KEY (item_oc_id)       REFERENCES items_oc(id),
  FOREIGN KEY (usuario_id)      REFERENCES usuarios(id)
);

CREATE TABLE facturas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  orden_compra_id INT NOT NULL,
  numero_factura VARCHAR(30),
  archivo_pdf VARCHAR(255) NOT NULL,
  fecha DATE,
  FOREIGN KEY (orden_compra_id) REFERENCES ordenes_compra(id)
);

CREATE TABLE remitos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  orden_compra_id INT NOT NULL,
  numero_remito VARCHAR(30),
  archivo_pdf VARCHAR(255),
  fecha DATE,
  FOREIGN KEY (orden_compra_id) REFERENCES ordenes_compra(id)
);

CREATE TABLE historico_compras (
  id INT AUTO_INCREMENT PRIMARY KEY,
  fecha_compra DATE NOT NULL,
  producto_id INT NOT NULL,
  cantidad INT NOT NULL,
  precio_unitario DECIMAL(10,2),
  precio_total DECIMAL(10,2),
  proveedor_id INT NOT NULL,
  sucursal_id INT NOT NULL,
  items_oc_id INT NOT NULL,
  categoria_producto_id INT,
  usuario_id INT NOT NULL,
  medio_pago VARCHAR(30),
  FOREIGN KEY (producto_id)            REFERENCES productos(id),
  FOREIGN KEY (proveedor_id)           REFERENCES proveedores(id),
  FOREIGN KEY (sucursal_id)            REFERENCES sucursales(id),
  FOREIGN KEY (categoria_producto_id)  REFERENCES categorias_productos(id),
  FOREIGN KEY (usuario_id)             REFERENCES usuarios(id),
  FOREIGN KEY (items_oc_id)            REFERENCES items_oc(id)
);

CREATE TABLE observaciones_np (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nota_pedido_id INT NOT NULL,
  usuario_id INT NOT NULL,
  estado_id INT,
  comentario TEXT NOT NULL,
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (nota_pedido_id) REFERENCES notas_pedido(id),
  FOREIGN KEY (usuario_id)      REFERENCES usuarios(id),
  FOREIGN KEY (estado_id)       REFERENCES estados_np(id)
);

CREATE TABLE observaciones_oc (
  id INT AUTO_INCREMENT PRIMARY KEY,
  orden_compra_id INT NOT NULL,
  usuario_id INT NOT NULL,
  estado_id INT,
  comentario TEXT NOT NULL,
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (orden_compra_id) REFERENCES ordenes_compra(id),
  FOREIGN KEY (usuario_id)      REFERENCES usuarios(id),
  FOREIGN KEY (estado_id)       REFERENCES estados_oc(id)
);

CREATE TABLE datos_bancarios_proveedor (
  id INT AUTO_INCREMENT PRIMARY KEY,
  proveedor_id INT NOT NULL,
  cbu_alias VARCHAR(30),
  archivo_cbu VARCHAR(50),
  FOREIGN KEY (proveedor_id) REFERENCES proveedores(id)
);

CREATE TABLE notificaciones_estados (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tipo_documento VARCHAR(10),
  documento_id INT NOT NULL,
  estado_noti VARCHAR(50),
  mensaje_noti TEXT,
  fecha_envio DATETIME DEFAULT CURRENT_TIMESTAMP,
  enviado BOOLEAN DEFAULT FALSE
);

