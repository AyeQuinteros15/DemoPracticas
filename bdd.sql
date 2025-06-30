-- MySQL dump 10.13  Distrib 8.0.23, for Win64 (x86_64)
--
-- Host: localhost    Database: modulocompras_demo
-- ------------------------------------------------------
-- Server version	8.0.23

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `categorias_productos`
--

LOCK TABLES `categorias_productos` WRITE;
/*!40000 ALTER TABLE `categorias_productos` DISABLE KEYS */;
/*!40000 ALTER TABLE `categorias_productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `entregas`
--

LOCK TABLES `entregas` WRITE;
/*!40000 ALTER TABLE `entregas` DISABLE KEYS */;
INSERT INTO `entregas` VALUES (1,1,'Resmas A4',5,3,'2025-06-16 22:03:52');
/*!40000 ALTER TABLE `entregas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `estados_np`
--

LOCK TABLES `estados_np` WRITE;
/*!40000 ALTER TABLE `estados_np` DISABLE KEYS */;
INSERT INTO `estados_np` VALUES (3,'Aprobada'),(1,'Generada'),(2,'Observada'),(4,'Rechazada');
/*!40000 ALTER TABLE `estados_np` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `estados_oc`
--

LOCK TABLES `estados_oc` WRITE;
/*!40000 ALTER TABLE `estados_oc` DISABLE KEYS */;
INSERT INTO `estados_oc` VALUES (4,'Aprobación por monto 1'),(5,'Aprobación por monto 2'),(6,'Aprobación por monto 3'),(2,'En circuito'),(7,'Enviada al proveedor'),(1,'Generada'),(3,'Observada'),(8,'OC Recibida'),(9,'Rechazada');
/*!40000 ALTER TABLE `estados_oc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `facturas`
--

LOCK TABLES `facturas` WRITE;
/*!40000 ALTER TABLE `facturas` DISABLE KEYS */;
INSERT INTO `facturas` VALUES (1,1,'F001-12345','R001-54321','archivos/facturas/F001-12345.pdf','2025-06-23');
/*!40000 ALTER TABLE `facturas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `historial_np`
--

LOCK TABLES `historial_np` WRITE;
/*!40000 ALTER TABLE `historial_np` DISABLE KEYS */;
INSERT INTO `historial_np` VALUES (1,1,1,1,'2025-06-16 22:02:01','Creada por el usuario'),(2,1,2,2,'2025-06-16 22:02:01','Observada por falta de precio estimado');
/*!40000 ALTER TABLE `historial_np` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `historial_oc`
--

LOCK TABLES `historial_oc` WRITE;
/*!40000 ALTER TABLE `historial_oc` DISABLE KEYS */;
INSERT INTO `historial_oc` VALUES (1,1,1,3,'2025-06-16 22:03:52','Orden generada'),(2,1,2,2,'2025-06-16 22:03:52','Enviada a proveedor');
/*!40000 ALTER TABLE `historial_oc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `items_np`
--

LOCK TABLES `items_np` WRITE;
/*!40000 ALTER TABLE `items_np` DISABLE KEYS */;
/*!40000 ALTER TABLE `items_np` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `items_oc`
--

LOCK TABLES `items_oc` WRITE;
/*!40000 ALTER TABLE `items_oc` DISABLE KEYS */;
INSERT INTO `items_oc` VALUES (1,1,10,1500.00,NULL),(2,1,50,100.00,NULL);
/*!40000 ALTER TABLE `items_oc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `notas_pedido`
--

LOCK TABLES `notas_pedido` WRITE;
/*!40000 ALTER TABLE `notas_pedido` DISABLE KEYS */;
INSERT INTO `notas_pedido` VALUES (1,'NP-TS-0001',1,'Pedido de resmas y artículos de oficina',1,'2025-06-16 22:02:01','2025-06-20','Martín Pérez','Entregar antes del cierre contable','archivos/NP-TS-0001.jpg',1),(2,'NP-TS-0002',2,'Compra de cartuchos e insumos de impresión',0,'2025-06-16 22:02:01','2025-06-21','Sofía Álvarez',NULL,NULL,2);
/*!40000 ALTER TABLE `notas_pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `ordenes_compra`
--

LOCK TABLES `ordenes_compra` WRITE;
/*!40000 ALTER TABLE `ordenes_compra` DISABLE KEYS */;
INSERT INTO `ordenes_compra` VALUES (1,'OC-TS-2025-001',1,'COT-001','2025-06-22 03:00:00','Compra aprobada','Verificar precio en factura','archivos/OC-TS-2025-001.pdf',10.00,21.00,0.00,1);
/*!40000 ALTER TABLE `ordenes_compra` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `perfiles`
--

LOCK TABLES `perfiles` WRITE;
/*!40000 ALTER TABLE `perfiles` DISABLE KEYS */;
INSERT INTO `perfiles` VALUES (4,'Administrador'),(3,'Comprador'),(2,'Encargado de Sector'),(1,'Usuario');
/*!40000 ALTER TABLE `perfiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `proveedores`
--

LOCK TABLES `proveedores` WRITE;
/*!40000 ALTER TABLE `proveedores` DISABLE KEYS */;
INSERT INTO `proveedores` VALUES (1,'Miguel','González','30123456789','3814123456'),(2,'Lucía','Paz','30987654321','3865421234');
/*!40000 ALTER TABLE `proveedores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `sectores`
--

LOCK TABLES `sectores` WRITE;
/*!40000 ALTER TABLE `sectores` DISABLE KEYS */;
INSERT INTO `sectores` VALUES (1,'Administración'),(2,'Compras');
/*!40000 ALTER TABLE `sectores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `stock`
--

LOCK TABLES `stock` WRITE;
/*!40000 ALTER TABLE `stock` DISABLE KEYS */;
/*!40000 ALTER TABLE `stock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `sucursales`
--

LOCK TABLES `sucursales` WRITE;
/*!40000 ALTER TABLE `sucursales` DISABLE KEYS */;
INSERT INTO `sucursales` VALUES (1,'Casa Central','San Martín 863 - San Miguel de Tucumán'),(2,'Sucursal Concepcion',' Padilla 10 local 4 - Concepción');
/*!40000 ALTER TABLE `sucursales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'Juan','García','operador','operador',1,1,NULL),(2,'María','López','mlopez','ML2025',2,2,NULL),(3,'Carlos','Castro','ccastro','CC15',3,1,NULL),(4,'Ana','Ruiz','admin','admin',4,1,NULL);
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-30 19:05:14
