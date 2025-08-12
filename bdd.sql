CREATE DATABASE IF NOT EXISTS modulo_compras;
USE modulo_compras;

-- Provincias
CREATE TABLE IF NOT EXISTS provincias (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nom_provincia VARCHAR(30) NOT NULL UNIQUE
);

-- Localidades
CREATE TABLE IF NOT EXISTS localidades (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nom_localidad VARCHAR(50) NOT NULL,
  provincia_id INT NOT NULL,
  FOREIGN KEY (provincia_id) REFERENCES provincias(id)
);

-- Direcciones
CREATE TABLE IF NOT EXISTS direcciones (
  id INT AUTO_INCREMENT PRIMARY KEY,
  direccion VARCHAR(60),
  codigo_postal VARCHAR(10),
  localidad_id INT NOT NULL,
  FOREIGN KEY (localidad_id) REFERENCES localidades(id)
);

-- Perfiles
CREATE TABLE IF NOT EXISTS perfiles (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nom_perfil VARCHAR(30) NOT NULL UNIQUE
);

-- Permisos (nuevo)
CREATE TABLE IF NOT EXISTS permisos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nom_permiso VARCHAR(50) NOT NULL UNIQUE
);

-- Asociación perfiles y permisos (nuevo)
CREATE TABLE IF NOT EXISTS perfiles_permisos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  perfil_id INT NOT NULL,
  permiso_id INT NOT NULL,
  FOREIGN KEY (perfil_id) REFERENCES perfiles(id),
  FOREIGN KEY (permiso_id) REFERENCES permisos(id)
);

-- Sucursales
CREATE TABLE IF NOT EXISTS sucursales (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nom_suc VARCHAR(50) NOT NULL UNIQUE,
  direccion_id INT,
  FOREIGN KEY (direccion_id) REFERENCES direcciones(id)
);

-- Sectores
CREATE TABLE IF NOT EXISTS sectores (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nom_sector VARCHAR(50) NOT NULL UNIQUE
);

-- Usuarios
CREATE TABLE IF NOT EXISTS usuarios (
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

-- Estados Notas de Pedido
CREATE TABLE IF NOT EXISTS estados_np (
  id INT AUTO_INCREMENT PRIMARY KEY,
  estados_np VARCHAR(30) NOT NULL UNIQUE
);

-- Estados Órdenes de Compra
CREATE TABLE IF NOT EXISTS estados_oc (
  id INT AUTO_INCREMENT PRIMARY KEY,
  estados_oc VARCHAR(40) NOT NULL UNIQUE
);

-- Categorías Productos
CREATE TABLE IF NOT EXISTS categorias_productos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  categoria_prod VARCHAR(50) NOT NULL UNIQUE,
  descripcion TEXT
);

-- Productos
CREATE TABLE IF NOT EXISTS productos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  codigo_producto VARCHAR(30) UNIQUE NOT NULL,
  nom_producto VARCHAR(50) NOT NULL,
  descripcion_producto TEXT,
  categoria_id INT,
  FOREIGN KEY (categoria_id) REFERENCES categorias_productos(id)
);

-- Proveedores
CREATE TABLE IF NOT EXISTS proveedores (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nom_proveedor VARCHAR(40) NOT NULL,
  razon_social VARCHAR(100),
  direccion_id INT,
  contacto VARCHAR(50),
  celular VARCHAR(30),
  condicion_iibb VARCHAR(50),
  FOREIGN KEY (direccion_id) REFERENCES direcciones(id)
);

-- Stock
CREATE TABLE IF NOT EXISTS stock (
  id INT AUTO_INCREMENT PRIMARY KEY,
  sucursal_id INT NOT NULL,
  producto_id INT,
  cantidad_actual INT DEFAULT 0,
  condicion_iva varchar(30),
  FOREIGN KEY (sucursal_id) REFERENCES sucursales(id),
  FOREIGN KEY (producto_id)  REFERENCES productos(id)
);

-- Notas de Pedido
CREATE TABLE IF NOT EXISTS notas_pedido (
  id INT AUTO_INCREMENT PRIMARY KEY,
  numero VARCHAR(20) UNIQUE NOT NULL,
  usuario_id INT NOT NULL,
  sucursal_id INT NOT NULL,
  sector_id INT NOT NULL,
  descripcion TEXT,
  prioridad BOOLEAN DEFAULT FALSE,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_entrega DATE,
  fecha_observacion TIMESTAMP NULL,
  fecha_aprobacion TIMESTAMP NULL,
  id_observador INT,
  fecha_firma TIMESTAMP,
  firma_usuario_id INT,
  gerente_solicitante_id INT DEFAULT NULL,
  responsable_solicitud_id INT DEFAULT NULL,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
  FOREIGN KEY (sucursal_id) REFERENCES sucursales(id),
  FOREIGN KEY (sector_id) REFERENCES sectores(id),
  FOREIGN KEY (id_observador) REFERENCES usuarios(id),
  FOREIGN KEY (firma_usuario_id) REFERENCES usuarios(id),
  FOREIGN KEY (gerente_solicitante_id) REFERENCES usuarios(id),
  FOREIGN KEY (responsable_solicitud_id) REFERENCES usuarios(id)
);

-- Items Notas de Pedido
CREATE TABLE IF NOT EXISTS items_np (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nota_pedido_id INT NOT NULL,
  producto_id INT,
  descripcion TEXT NOT NULL,
  cantidad INT NOT NULL,
  FOREIGN KEY (nota_pedido_id) REFERENCES notas_pedido(id),
  FOREIGN KEY (producto_id)     REFERENCES productos(id)
);

-- Historial Notas de Pedido
CREATE TABLE IF NOT EXISTS historial_np (
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

-- Flujos estados Notas de Pedido (nuevo)
CREATE TABLE IF NOT EXISTS flujos_estados_np (
  id INT AUTO_INCREMENT PRIMARY KEY,
  estado_origen_id INT NOT NULL COMMENT 'Estado desde el cual se puede avanzar o retroceder', 
  estado_destino_id INT NOT NULL COMMENT 'Estado al que se puede pasar desde el estado origen' ,
  requiere_firma BOOLEAN DEFAULT FALSE COMMENT 'Indica si para el paso se necesita que el usuario firme',
  FOREIGN KEY (estado_origen_id) REFERENCES estados_np(id),
  FOREIGN KEY (estado_destino_id) REFERENCES estados_np(id),
  UNIQUE (estado_origen_id, estado_destino_id) COMMENT 'Para evitar duplicados, no puede haber 2 filas origen -> destino iguales'
);

-- Asignaciones Notas de Pedido (nuevo)
CREATE TABLE IF NOT EXISTS asignaciones_np (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nota_pedido_id INT NOT NULL,
  usuario_asignado_id INT NOT NULL,
  usuario_asignador_id INT NOT NULL,
  fecha_asignacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (nota_pedido_id) REFERENCES notas_pedido(id),
  FOREIGN KEY (usuario_asignado_id) REFERENCES usuarios(id),
  FOREIGN KEY (usuario_asignador_id) REFERENCES usuarios(id)
);

-- Aprobaciones Notas de Pedido (nuevo)
CREATE TABLE IF NOT EXISTS aprobaciones_np (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nota_pedido_id INT NOT NULL,
  usuario_id INT NOT NULL COMMENT 'usuario que aprobo o rechazo',
  aprobado_np BOOLEAN NOT NULL COMMENT 'Para saber si se aprobo o rechazo',
  motivo_rechazo_np TEXT,
  fecha_aprobacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  firma_usuario_id INT DEFAULT NULL COMMENT 'sirve en caso que se delegue',
  FOREIGN KEY (nota_pedido_id) REFERENCES notas_pedido(id),
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
  FOREIGN KEY (firma_usuario_id) REFERENCES usuarios(id)
);

-- Cotejo Presupuestos
CREATE TABLE IF NOT EXISTS cotejo_presupuestos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  codigo_cotejo VARCHAR(20) UNIQUE NOT NULL,
  nota_pedido_id INT,
  sector_id int,
  nombre_opcional varchar(40),
  fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
  observaciones TEXT,
  proveedor_sugerido_id INT,
  cotejo_padre_id INT,
  prioridad_MC BOOLEAN DEFAULT FALSE,
  mc_creado_por int,
  foreign key (mc_creado_por) references usuarios (id),
  FOREIGN KEY (nota_pedido_id)          REFERENCES notas_pedido(id),
  FOREIGN KEY (proveedor_sugerido_id)   REFERENCES proveedores(id),
  FOREIGN KEY (cotejo_padre_id)         REFERENCES cotejo_presupuestos(id),
  foreign key (sector_id) references sectores (id)
);

-- Cotejo Items
CREATE TABLE IF NOT EXISTS cotejo_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  cotejo_presupuesto_id INT NOT NULL,
  producto_id INT DEFAULT NULL,
  nombre_item varchar(40) not null,
  Descripcion_item TEXT NOT NULL,
  cantidad_solicitada DECIMAL(10,2) NOT NULL,
  Unidad_solicitada VARCHAR(20),
  FOREIGN KEY (cotejo_presupuesto_id) REFERENCES cotejo_presupuestos(id),
  FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- Cotejo Ofertas Items
CREATE TABLE IF NOT EXISTS cotejo_ofertas_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  cotejo_item_id INT NOT NULL,
  proveedor_id INT NOT NULL,
  precio_unitario DECIMAL(12,2),
  precio_total DECIMAL(12,2),
  unidad_ofrecida VARCHAR(20),
  cantidad_ofrecida DECIMAL(10,2),
  condicion_fiscal VARCHAR(100),
  condicion_pago VARCHAR(100),
  forma_cotizacion varchar(100),
  plazo_entrega VARCHAR(100),
  lugar_entrega VARCHAR(100),
  motivo_seleccion TEXT,
  visible BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (cotejo_item_id) REFERENCES cotejo_items(id),
  FOREIGN KEY (proveedor_id) REFERENCES proveedores(id)
);

-- Ordenes de Compra
CREATE TABLE IF NOT EXISTS ordenes_compra (
  id INT AUTO_INCREMENT PRIMARY KEY,
  numero VARCHAR(20) UNIQUE NOT NULL,
  nota_pedido_id INT NOT NULL,
  proveedor_id INT,
  numero_cotizacion VARCHAR(30),
  nombre_opcional_oc varchar(40),
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
  moneda varchar(30),
  cbu VARCHAR(30),
  titular_cuenta VARCHAR(100),
  lugar_entrega VARCHAR(150),
  estado_notificado BOOLEAN DEFAULT FALSE,
  orden_compra_anterior_id INT,
  requiere_entrega_rapida BOOLEAN DEFAULT FALSE,
  orden_compra_clonada_de_id INT,
  modelo_cotejo_id int,
  foreign key (modelo_cotejo_id) references cotejo_presupuestos (id),
  FOREIGN KEY (nota_pedido_id)            REFERENCES notas_pedido(id),
  FOREIGN KEY (proveedor_id)              REFERENCES proveedores(id),
  FOREIGN KEY (creado_por)                REFERENCES usuarios(id),
  FOREIGN KEY (id_observador)             REFERENCES usuarios(id),
  FOREIGN KEY (orden_compra_anterior_id)  REFERENCES ordenes_compra(id),
  FOREIGN KEY (orden_compra_clonada_de_id)REFERENCES ordenes_compra(id)
);

-- Items OC
CREATE TABLE IF NOT EXISTS items_oc (
  id INT AUTO_INCREMENT PRIMARY KEY,
  orden_compra_id INT NOT NULL,
  producto_id INT,
  descripcion TEXT NOT NULL,
  cantidad INT NOT NULL,
  precio_unitario DECIMAL(10,2),
  precio_total DECIMAL(12,2),
  centro_costo VARCHAR(100),
  descuento_porcentaje DECIMAL(5,2),
  iva_porcentaje VARCHAR(5),
  FOREIGN KEY (orden_compra_id) REFERENCES ordenes_compra(id),
  FOREIGN KEY (producto_id)       REFERENCES productos(id)
);

-- Historial OC
CREATE TABLE IF NOT EXISTS historial_oc (
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

-- Flujos estados OC (nuevo)
CREATE TABLE IF NOT EXISTS flujos_estados_oc (
  id INT AUTO_INCREMENT PRIMARY KEY,
  estado_origen_id INT NOT NULL,
  estado_destino_id INT NOT NULL,
  requiere_firma BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (estado_origen_id) REFERENCES estados_oc(id),
  FOREIGN KEY (estado_destino_id) REFERENCES estados_oc(id),
  UNIQUE (estado_origen_id, estado_destino_id)
);

-- Asignaciones OC (nuevo)
CREATE TABLE IF NOT EXISTS asignaciones_oc (
  id INT AUTO_INCREMENT PRIMARY KEY,
  orden_compra_id INT NOT NULL,
  usuario_asignado_id INT NOT NULL,
  usuario_asignador_id INT NOT NULL,
  fecha_asignacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (orden_compra_id) REFERENCES ordenes_compra(id),
  FOREIGN KEY (usuario_asignado_id) REFERENCES usuarios(id),
  FOREIGN KEY (usuario_asignador_id) REFERENCES usuarios(id)
);

-- Aprobaciones OC (nuevo)
CREATE TABLE IF NOT EXISTS aprobaciones_oc (
  id INT AUTO_INCREMENT PRIMARY KEY,
  orden_compra_id INT NOT NULL,
  usuario_id INT NOT NULL,
  aprobado_oc BOOLEAN NOT NULL,
  fecha_aprobacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  firma_usuario_id INT DEFAULT NULL COMMENT 'sirve en cas que se delegue',
  FOREIGN KEY (orden_compra_id) REFERENCES ordenes_compra(id),
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
  FOREIGN KEY (firma_usuario_id) REFERENCES usuarios(id)
);

-- Entregas
CREATE TABLE IF NOT EXISTS entregas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  orden_compra_id INT NOT NULL,
  item_oc_id INT,
  cantidad INT NOT NULL,
  usuario_id INT NOT NULL,
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (orden_compra_id) REFERENCES ordenes_compra(id),
  FOREIGN KEY (item_oc_id)       REFERENCES items_oc(id),
  FOREIGN KEY (usuario_id)      REFERENCES usuarios(id)
);

-- Facturas
CREATE TABLE IF NOT EXISTS facturas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  orden_compra_id INT NOT NULL,
  numero_factura VARCHAR(30),
  archivo_pdf VARCHAR(255) NOT NULL,
  fecha DATE,
  FOREIGN KEY (orden_compra_id) REFERENCES ordenes_compra(id)
);

-- Remitos
CREATE TABLE IF NOT EXISTS remitos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  orden_compra_id INT NOT NULL,
  numero_remito VARCHAR(30),
  archivo_pdf VARCHAR(255),
  fecha DATE,
  FOREIGN KEY (orden_compra_id) REFERENCES ordenes_compra(id)
);

-- Histórico Compras
CREATE TABLE IF NOT EXISTS historico_compras (
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

-- Observaciones NP
CREATE TABLE IF NOT EXISTS observaciones_np (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nota_pedido_id INT NOT NULL,
  usuario_id INT NOT NULL,
  estado_id INT,
  comentario_observacion_np TEXT NOT NULL,
  fecha_observacion_np TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  respuesta_observacion_id INT DEFAULT NULL,
  FOREIGN KEY (nota_pedido_id) REFERENCES notas_pedido(id),
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
  FOREIGN KEY (estado_id) REFERENCES estados_np(id),
  FOREIGN KEY (respuesta_observacion_id) REFERENCES observaciones_np(id) ON DELETE SET NULL
); 

-- Observaciones OC
CREATE TABLE IF NOT EXISTS observaciones_oc (
  id INT AUTO_INCREMENT PRIMARY KEY,
  orden_compra_id INT NOT NULL,
  usuario_id INT NOT NULL,
  estado_id INT,
  comentario_observacion_oc TEXT NOT NULL,
  fecha_observacion_oc TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  respuesta_observacion_id INT DEFAULT NULL,
  FOREIGN KEY (orden_compra_id) REFERENCES ordenes_compra(id),
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
  FOREIGN KEY (estado_id) REFERENCES estados_oc(id),
  FOREIGN KEY (respuesta_observacion_id) REFERENCES observaciones_oc(id) ON DELETE SET NULL
);

-- Observaciones internas OC
CREATE TABLE IF NOT EXISTS observaciones_internas_oc (
  id INT AUTO_INCREMENT PRIMARY KEY,
  orden_compra_id INT NOT NULL,
  usuario_id INT NOT NULL,
  estado_id INT,
  observacion_interna_oc TEXT NOT NULL,
  fecha_observacion_interna_oc TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  respuesta_observacion_interna_oc_id INT DEFAULT NULL,
  FOREIGN KEY (orden_compra_id) REFERENCES ordenes_compra(id),
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
  FOREIGN KEY (estado_id) REFERENCES estados_oc(id),
  FOREIGN KEY (respuesta_observacion_interna_oc_id) REFERENCES observaciones_internas_oc(id) ON DELETE SET NULL
);

-- Datos bancarios proveedor
CREATE TABLE IF NOT EXISTS datos_bancarios_proveedor (
  id INT AUTO_INCREMENT PRIMARY KEY,
  proveedor_id INT NOT NULL,
  cbu_alias VARCHAR(30),
  archivo_cbu VARCHAR(50),
  FOREIGN KEY (proveedor_id) REFERENCES proveedores(id)
);

-- Notificaciones estados
CREATE TABLE IF NOT EXISTS notificaciones_estados (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nota_pedido_id INT DEFAULT NULL,
  orden_compra_id INT DEFAULT NULL,
  estado_noti VARCHAR(50),
  mensaje_noti TEXT,
  fecha_envio DATETIME DEFAULT CURRENT_TIMESTAMP,
  enviado BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (nota_pedido_id) REFERENCES notas_pedido(id),
  FOREIGN KEY (orden_compra_id) REFERENCES ordenes_compra(id)
);

-- Adjuntos Documentos
CREATE TABLE IF NOT EXISTS adjuntos_documentos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nota_pedido_id INT DEFAULT NULL,
    orden_compra_id INT DEFAULT NULL,
    factura_id INT DEFAULT NULL,
    remito_id INT DEFAULT NULL,
    ruta_archivo VARCHAR(100) NOT NULL,
    descripcion TEXT,
    usuario_id INT,
    fecha_subida TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (nota_pedido_id)     REFERENCES notas_pedido(id),
    FOREIGN KEY (orden_compra_id)    REFERENCES ordenes_compra(id),
    FOREIGN KEY (factura_id)         REFERENCES facturas(id),
    FOREIGN KEY (remito_id)          REFERENCES remitos(id),
    FOREIGN KEY (usuario_id)         REFERENCES usuarios(id)
);
