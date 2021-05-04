-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 02-05-2021 a las 01:25:30
-- Versión del servidor: 10.4.17-MariaDB
-- Versión de PHP: 7.3.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `weem_db`
--
CREATE DATABASE IF NOT EXISTS `weem_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `weem_db`;

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_entradas_reservadas` (`p_id_envento` VARCHAR(30))  UPDATE tbl_evento 
set entradas_reservadas_evento = (entradas_reservadas_evento+1)
WHERE id_evento = p_id_envento$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_entradas_reservadas_aumentar` (`p_id_envento` VARCHAR(30))  UPDATE tbl_evento 
set entradas_reservadas_evento = (entradas_reservadas_evento-1)
WHERE id_evento = p_id_envento$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_evento` (IN `p_id_evento` VARCHAR(30), IN `p_nombre_evento` VARCHAR(100), IN `p_fecha_evento` DATETIME, IN `p_direccion_evento` VARCHAR(200), IN `p_coordenada_x` FLOAT, IN `p_coordenada_y` FLOAT, IN `p_entradas_totales_evento` INT, IN `p_precio_entradas_evento` INT, IN `p_id_usuario_creador` VARCHAR(100))  UPDATE tbl_evento
set `nombre_evento` = p_nombre_evento,
`fecha_evento` = p_fecha_evento,
`direccion_evento` = p_direccion_evento,
`coordenada_x` = p_coordenada_x,
`coordenada_y` = p_coordenada_y,
`entradas_totales_evento` = p_entradas_totales_evento,
`precio_entradas_evento` = p_precio_entradas_evento,
`id_usuario_creador` = p_id_usuario_creador
where id_evento = p_id_evento$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `buscar_entrada` (IN `p_codigo_entrada` VARCHAR(100))  SELECT
T0.codigo_entrada,
T1.nombre_usuario,
T2.nombre_evento,
T3.nombre_estado_reservacion,
DATE_FORMAT(T2.fecha_evento, "%d-%m-%Y") as 'fecha_evento',
DATE_FORMAT(T2.fecha_evento, "%H:%i %p") as 'hora_evento',
DATE_FORMAT(T2.fecha_evento, "%H") as 'hora'
FROM `tbl_evento_reservado` as T0
INNER JOIN tbl_usuario as T1 on T1.correo_usuario = T0.correo_usuario_reservacion
INNER JOIN tbl_evento as T2 on T2.id_evento = T0.id_evento_reservacion
INNER JOIN tbl_estado_reservacion as T3 on T3.id_estado_reservacion = T0.estado_reservacion
WHERE codigo_entrada = p_codigo_entrada and DATE_FORMAT(T2.fecha_evento, "%d-%m-%Y") = DATE_FORMAT(now(), "%d-%m-%Y")$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cambiar_estado_evento` (`p_id_evento` VARCHAR(30), `p_estado_evento` INT)  UPDATE tbl_evento 
set estado_evento = p_estado_evento
where id_evento = p_id_evento$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cambiar_estado_usuario_local` (`p_estado_usuario` INT)  UPDATE tbl_usuario
SET estado_usuario = p_estado_usuario
WHERE correo_usuario = p_correoUsuario$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cambiar_estado_usuario_local_2` (IN `p_correoUsuario` VARCHAR(100), IN `p_estado_usuario` VARCHAR(12))  UPDATE tbl_usuario
SET estado_usuario = p_estado_usuario
WHERE correo_usuario = p_correoUsuario$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cancelar_entradas` (`p_id_evento` VARCHAR(30))  update `tbl_evento_reservado`
set estado_reservacion = 3
WHERE id_evento_reservacion = p_id_evento$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cancelar_reserva` (IN `p_id_reservacion` INT)  update tbl_evento_reservado
set estado_reservacion = 3
WHERE id_reservacion = p_id_reservacion$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `contar_tipo_evento` (IN `p_tipo_evento` INT)  SELECT SUBSTRING(id_evento,2,30) as 'id', id_evento, fecha_creacion FROM `tbl_evento` WHERE tipo_evento = p_tipo_evento ORDER BY (`fecha_creacion`) DESC LIMIT 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `crear_evento` (IN `p_id_evento` VARCHAR(30), IN `p_nombre_evento` VARCHAR(100), IN `p_fecha_evento` DATETIME, IN `p_direccion_evento` VARCHAR(200), IN `p_coordenada_x` FLOAT, IN `p_coordenada_y` FLOAT, IN `p_entradas_totales_evento` INT, IN `p_entradas_reservadas_evento` INT, IN `p_entradas_procesadas_evento` INT, IN `p_precio_entradas_evento` DOUBLE, IN `p_evento` INT, IN `p_id_usuario_creador` VARCHAR(100))  INSERT INTO `tbl_evento`(`id_evento`, `nombre_evento`, `fecha_evento`, `direccion_evento`, `coordenada_x`, `coordenada_y`, `entradas_totales_evento`, `entradas_reservadas_evento`, `entradas_procesadas_evento`, `precio_entradas_evento`, `tipo_evento`, `id_usuario_creador`, `fecha_creacion`, `estado_evento`) VALUES (p_id_evento,p_nombre_evento,p_fecha_evento,p_direccion_evento,p_coordenada_x,p_coordenada_y,p_entradas_totales_evento,p_entradas_reservadas_evento,p_entradas_procesadas_evento,p_precio_entradas_evento,p_evento,p_id_usuario_creador,now(),1)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `crear_reserva` (IN `p_correo` VARCHAR(100), IN `p_id_evento` VARCHAR(30), IN `p_codigo_entrada` VARCHAR(100))  INSERT INTO tbl_evento_reservado (correo_usuario_reservacion, id_evento_reservacion, estado_reservacion, codigo_entrada, reserva_fecha_creacion) VALUES (p_correo, p_id_evento, 1, p_codigo_entrada, now())$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `detalle_reservacion_cliente` (IN `p_id_reservacion` INT)  SELECT 
T0.codigo_entrada,
T1.id_evento,
DATE_FORMAT(T0.reserva_fecha_creacion, "%d-%m-%Y") as 'reserva_fecha_creacion',
(T1.fecha_evento-INTERVAL 1 WEEK) as 'semana_anterior',
(CURRENT_DATE()) as 'hoy',
T1.nombre_evento,
T1.entradas_totales_evento,
T3.nombre_estado_reservacion,
T0.id_reservacion,
YEAR(T1.fecha_evento) as 'año_evento', 
MONTH(T1.fecha_evento) as 'mes_evento', 
DATE_FORMAT(T1.fecha_evento, "%d-%m-%Y") as 'fecha_evento',
DATE_FORMAT(T1.fecha_creacion, "%d-%m-%Y") as 'fecha_creacion', 
DATE_FORMAT(T1.fecha_evento, "%H:%i %p") as 'hora_evento', 
(T1.entradas_totales_evento - T1.entradas_reservadas_evento) as 'entradas_libres',
T1.direccion_evento,
T1.coordenada_x,
T1.coordenada_y,
T1.precio_entradas_evento
FROM `tbl_evento_reservado` as T0
INNER JOIN tbl_evento as T1 on T0.id_evento_reservacion = T1.id_evento
INNER JOIN tbl_usuario as T2 on T2.correo_usuario = T0.correo_usuario_reservacion
INNER JOIN tbl_estado_reservacion as T3 on T3.id_estado_reservacion = T0.estado_reservacion
WHERE id_reservacion = p_id_reservacion$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `editar_usuario_local` (`p_nombreUsuario` VARCHAR(50), `p_correoUsuario` VARCHAR(100), `p_claveUsuario` VARCHAR(100), `p_tipoUsuario` INT)  UPDATE tbl_usuario
SET nombre_usuario = p_nombreUsuario,
	correo_usuario = p_correoUsuario,
    clave_usuario = p_claveUsuario,
    id_tipo_usuario = P_tipoUsuario
WHERE correo_usuario = p_correoUsuario$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminar_evento` (IN `p_id_evento` VARCHAR(30))  DELETE FROM tbl_evento WHERE id_evento = p_id_evento$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eventos_creados_usuarios` ()  select T1.nombre_usuario, YEAR(T0.fecha_evento) as 'año_evento', MONTH(T0.fecha_evento) as 'mes_evento', COUNT(T0.fecha_evento) as 'eventos', T0.entradas_totales_evento from tbl_evento as T0 INNER JOIN tbl_usuario as T1 on T0.id_usuario_creador = T1.correo_usuario$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eventos_entradas_libres` (IN `p_id_evento` VARCHAR(30))  SELECT (entradas_totales_evento - entradas_reservadas_evento) as "entradas_libres" FROM `tbl_evento` WHERE id_evento = p_id_evento$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eventos_por_admin_lista` (IN `p_correo` VARCHAR(100))  select T1.nombre_usuario,
T2.nombre_estado_evento, 
T0.nombre_evento, 
T0.id_evento, 
YEAR(T0.fecha_evento) as 'año_evento', 
MONTH(T0.fecha_evento) as 'mes_evento', 
DATE_FORMAT(T0.fecha_evento, "%d-%m-%Y") as 'fecha_evento', DATE_FORMAT(T0.fecha_creacion, "%d-%m-%Y") as 'fecha_creacion', DATE_FORMAT(T0.fecha_evento, "%H:%i %p") as 'hora_evento', (T0.entradas_totales_evento - T0.entradas_reservadas_evento) as 'entradas_libres', T0.precio_entradas_evento from tbl_evento as T0 INNER JOIN tbl_usuario as T1 on T0.id_usuario_creador = T1.correo_usuario 
INNER JOIN tbl_estado_evento as T2 on T2.id_estado_evento = T0.estado_evento
WHERE T1.correo_usuario = p_correo ORDER By T0.fecha_creacion DESC LIMIT 7$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eventos_reservados_clientes` ()  SELECT T1.nombre_usuario,
YEAR(T3.fecha_evento) as 'año_evento',
MONTH(T3.fecha_evento) as 'mes_evento',
COUNT(T0.id_reservacion) as 'eventos'
FROM tbl_evento_reservado as T0 
INNER JOIN tbl_usuario as T1 
on T0.correo_usuario_reservacion = T1.correo_usuario
INNER JOIN tbl_evento as T3 on T0.id_evento_reservacion = T3.id_evento$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `evento_por_id` (IN `p_id_evento` VARCHAR(30))  SELECT T0.nombre_evento, T0.direccion_evento, T0.coordenada_x, T0.coordenada_y, T0.precio_entradas_evento, T0.entradas_totales_evento, 
T0.tipo_evento,
T0.estado_evento, 
T1.nombre_estado_evento,
(T0.entradas_totales_evento - T0.entradas_reservadas_evento) as 'entradas_libres', DATE_FORMAT(T0.fecha_evento, "%Y-%m-%d") as 'fecha_evento', DATE_FORMAT(T0.fecha_creacion, "%Y-%m-%d") as 'fecha_creacion', DATE_FORMAT(T0.fecha_evento, "%H:%i %p") as 'hora_evento', DATE_FORMAT(T0.fecha_evento, "%H:%i") as 'hora_evento_2' 
FROM `tbl_evento` as T0 
INNER JOIN tbl_estado_evento as T1 on T1.id_estado_evento = T0.estado_evento
WHERE id_evento = p_id_evento$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertar_telefono` (`p_telefono` VARCHAR(15), `p_correo` VARCHAR(100))  update tbl_usuario 
SET telefono_usuario = p_telefono
WHERE correo_usuario = p_correo$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertar_usuario_local` (IN `p_nombre_usuario` VARCHAR(50), IN `p_correo_usuario` VARCHAR(50), IN `p_clave_usuario` VARCHAR(100), IN `p_tipo_usuario` INT, IN `p_tipo_sesion_usuario` INT, IN `p_telefono_usuario` VARCHAR(15))  INSERT INTO tbl_usuario(nombre_usuario, correo_usuario, clave_usuario, id_tipo_usuario, estado_usuario, tipo_sesion_usuario, telefono_usuario) VALUES (p_nombre_usuario, p_correo_usuario, p_clave_usuario, p_tipo_usuario, 'ACTIVO', p_tipo_sesion_usuario,p_telefono_usuario)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `lista_eventos` ()  select T1.nombre_usuario, T0.nombre_evento, T0.id_evento, YEAR(T0.fecha_evento) as 'año_evento', MONTH(T0.fecha_evento) as 'mes_evento', DATE_FORMAT(T0.fecha_evento, "%d-%M-%Y") as 'fecha_evento', DATE_FORMAT(T0.fecha_creacion, "%d-%M-%Y") as 'fecha_creacion', DATE_FORMAT(T0.fecha_evento, "%H:%i %p") as 'hora_evento', (T0.entradas_totales_evento - T0.entradas_reservadas_evento) as 'entradas_libres', T0.precio_entradas_evento from tbl_evento as T0 INNER JOIN tbl_usuario as T1 on T0.id_usuario_creador = T1.correo_usuario 
where T0.estado_evento != 2 and T0.estado_evento != 3 and T0.fecha_evento > CURDATE()
ORDER By T0.fecha_creacion DESC$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `lista_eventos_totales` (IN `p_correo` VARCHAR(100))  select T1.nombre_usuario, T0.nombre_evento, T0.id_evento, YEAR(T0.fecha_evento) as 'año_evento', MONTH(T0.fecha_evento) as 'mes_evento', DATE_FORMAT(T0.fecha_evento, "%d-%M-%Y") as 'fecha_evento', DATE_FORMAT(T0.fecha_creacion, "%d-%M-%Y") as 'fecha_creacion', DATE_FORMAT(T0.fecha_evento, "%H:%i %p") as 'hora_evento', (T0.entradas_totales_evento - T0.entradas_reservadas_evento) as 'entradas_libres', T0.precio_entradas_evento from tbl_evento as T0 INNER JOIN tbl_usuario as T1 on T0.id_usuario_creador = T1.correo_usuario WHERE T1.correo_usuario = p_correo ORDER By T0.fecha_creacion DESC$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `lista_reservaciones_cliente_admin` (IN `p_correo` VARCHAR(100))  SELECT T3.nombre_evento,
T3.fecha_evento,
T3.entradas_totales_evento,
T3.entradas_reservadas_evento,
(T3.entradas_totales_evento - T3.entradas_reservadas_evento) as 'entradas_disponibles',
T3.entradas_procesadas_evento,
SUM(T3.precio_entradas_evento) as 'ganancias_evento'
FROM tbl_evento_reservado as T0 
INNER JOIN tbl_usuario as T1 
on T0.correo_usuario_reservacion = T1.correo_usuario
INNER JOIN tbl_evento as T3 on T0.id_evento_reservacion = T3.id_evento
where T3.id_usuario_creador = p_correo
GROUP BY T3.id_evento$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `lista_telefonos_con_reservaciones` (IN `p_id_evento` VARCHAR(30))  SELECT 
	T1.nombre_usuario,
    T2.nombre_evento,
DATE_FORMAT(T2.fecha_evento, "%Y-%m-%d") as 'fecha_evento',
DATE_FORMAT(T2.fecha_evento, "%H:%i %p") as 'hora_evento',
T1.telefono_usuario
FROM tbl_evento_reservado as T0 
INNER JOIN tbl_usuario as T1 on T1.correo_usuario = T0.correo_usuario_reservacion
INNER JOIN tbl_evento as T2 on T2.id_evento = T0.id_evento_reservacion
WHERE T0.id_evento_reservacion = p_id_evento$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `lista_tipos_usuarios` ()  SELECT * FROM tbl_tipo_usuario LIMIT 3$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `lista_usuarios` ()  SELECT T0.nombre_usuario, 
T0.correo_usuario, 
T1.nombre_tipo_usuario,
T0.estado_usuario,
T0.clave_usuario,
T0.id_tipo_usuario
FROM tbl_usuario as T0
INNER JOIN tbl_tipo_usuario as T1 on T0.id_tipo_usuario = T1.id_tipo_usuario
WHERE T0.id_tipo_usuario < 4$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `login_local_users` (`p_correo` VARCHAR(100), `p_clave` VARCHAR(100))  SELECT * FROM `tbl_usuario` WHERE correo_usuario = p_correo and clave_usuario = p_clave$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procesar_reserva` (IN `p_codigo_reserva` VARCHAR(100))  update tbl_evento_reservado
set estado_reservacion = 2
WHERE codigo_entrada = p_codigo_reserva$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `reservaciones_cliente` (IN `p_correo` VARCHAR(100))  SELECT 
T1.nombre_evento,
T1.id_evento,
T0.id_reservacion,
DATE_FORMAT(T0.reserva_fecha_creacion, "%d-%m-%Y") as 'reserva_fecha_creacion',
T3.nombre_estado_reservacion,
YEAR(T1.fecha_evento) as 'año_evento', 
MONTH(T1.fecha_evento) as 'mes_evento', 
DATE_FORMAT(T1.fecha_evento, "%d-%m-%Y") as 'fecha_evento',
DATE_FORMAT(T1.fecha_creacion, "%d-%m-%Y") as 'fecha_creacion', 
DATE_FORMAT(T1.fecha_evento, "%H:%i %p") as 'hora_evento', 
(T1.entradas_totales_evento - T1.entradas_reservadas_evento) as 'entradas_libres', T1.precio_entradas_evento
FROM `tbl_evento_reservado` as T0
INNER JOIN tbl_evento as T1 on T1.id_evento = T0.id_evento_reservacion
INNER JOIN tbl_usuario as T2 on T2.correo_usuario = T0.correo_usuario_reservacion
INNER JOIN tbl_estado_reservacion as T3 on T3.id_estado_reservacion = T0.estado_reservacion
WHERE correo_usuario_reservacion = p_correo ORDER BY T0.id_reservacion DESC$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `reservaciones_cliente_ultima` (IN `p_correo` VARCHAR(100))  SELECT 
T1.nombre_evento,
T1.id_evento,
T0.id_reservacion,
DATE_FORMAT(T0.reserva_fecha_creacion, "%d-%m-%Y") as 'reserva_fecha_creacion',
T3.nombre_estado_reservacion,
YEAR(T1.fecha_evento) as 'año_evento', 
MONTH(T1.fecha_evento) as 'mes_evento', 
DATE_FORMAT(T1.fecha_evento, "%d-%m-%Y") as 'fecha_evento',
DATE_FORMAT(T1.fecha_creacion, "%d-%m-%Y") as 'fecha_creacion', 
DATE_FORMAT(T1.fecha_evento, "%H:%i %p") as 'hora_evento', 
(T1.entradas_totales_evento - T1.entradas_reservadas_evento) as 'entradas_libres', T1.precio_entradas_evento
FROM `tbl_evento_reservado` as T0
INNER JOIN tbl_evento as T1 on T1.id_evento = T0.id_evento_reservacion
INNER JOIN tbl_usuario as T2 on T2.correo_usuario = T0.correo_usuario_reservacion
INNER JOIN tbl_estado_reservacion as T3 on T3.id_estado_reservacion = T0.estado_reservacion
WHERE correo_usuario_reservacion = p_correo
 ORDER BY T0.id_reservacion DESC
limit 7$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `reservacion_cliente_evento` (`p_correo` VARCHAR(100), `p_id_reservacion` VARCHAR(30))  SELECT * FROM tbl_evento_reservado WHERE correo_usuario_reservacion = p_correo and id_evento_reservacion = p_id_reservacion$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `reservas_procesadas` ()  select T1.nombre_usuario,
T0.nombre_evento,
YEAR(T0.fecha_evento) as 'año_evento', 
MONTH(T0.fecha_evento) as 'mes_evento', 
T0.entradas_totales_evento,
T0.entradas_reservadas_evento,
T0.entradas_procesadas_evento,
SUM(T0.precio_entradas_evento) as 'ganancias_evento'
from tbl_evento as T0 
INNER JOIN tbl_usuario as T1 on T0.id_usuario_creador = T1.correo_usuario
INNER JOIN tbl_evento_reservado as T2 on T0.id_evento = T2.id_evento_reservacion
WHERE T2.estado_reservacion = 2$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ultimo_id_reservacion_evento` (IN `p_id_evento` VARCHAR(30))  SELECT COUNT(id_reservacion)+1 as `id_nuevo` FROM `tbl_evento_reservado` WHERE id_evento_reservacion =  p_id_evento$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usuario_por_correo` (`p_correo` VARCHAR(100))  SELECT * FROM tbl_usuario WHERE correo_usuario = P_correo$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_estado_evento`
--

CREATE TABLE `tbl_estado_evento` (
  `id_estado_evento` int(11) NOT NULL,
  `nombre_estado_evento` varchar(25) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `tbl_estado_evento`
--

INSERT INTO `tbl_estado_evento` (`id_estado_evento`, `nombre_estado_evento`) VALUES
(1, 'Visible'),
(2, 'Oculto'),
(3, 'Cancelado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_estado_reservacion`
--

CREATE TABLE `tbl_estado_reservacion` (
  `id_estado_reservacion` int(11) NOT NULL,
  `nombre_estado_reservacion` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `tbl_estado_reservacion`
--

INSERT INTO `tbl_estado_reservacion` (`id_estado_reservacion`, `nombre_estado_reservacion`) VALUES
(1, 'Activa'),
(2, 'Procesada'),
(3, 'Cancelada');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_evento`
--

CREATE TABLE `tbl_evento` (
  `id_evento` varchar(30) NOT NULL,
  `nombre_evento` varchar(100) DEFAULT NULL,
  `fecha_evento` datetime DEFAULT NULL,
  `direccion_evento` varchar(200) DEFAULT NULL,
  `coordenada_x` float DEFAULT NULL,
  `coordenada_y` float DEFAULT NULL,
  `entradas_totales_evento` int(11) DEFAULT NULL,
  `entradas_reservadas_evento` int(11) DEFAULT NULL,
  `entradas_procesadas_evento` int(11) DEFAULT NULL,
  `precio_entradas_evento` double DEFAULT NULL,
  `tipo_evento` int(11) DEFAULT NULL,
  `id_usuario_creador` varchar(100) DEFAULT NULL,
  `fecha_creacion` datetime DEFAULT NULL,
  `estado_evento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `tbl_evento`
--

INSERT INTO `tbl_evento` (`id_evento`, `nombre_evento`, `fecha_evento`, `direccion_evento`, `coordenada_x`, `coordenada_y`, `entradas_totales_evento`, `entradas_reservadas_evento`, `entradas_procesadas_evento`, `precio_entradas_evento`, `tipo_evento`, `id_usuario_creador`, `fecha_creacion`, `estado_evento`) VALUES
('P10', '13va convencion de informaticos', '2021-09-12 22:00:00', 'Hotel Real InterContinental San Salvador, Y Avenue Sisimiles, San Salvador, El Salvador', 13.7075, -89.2131, 50, 2, 0, 12, 1, 'marlene@gmail.com', '2021-04-19 21:47:12', 1),
('P11', '14va convencion de informaticos', '2022-02-16 23:00:00', 'Torre Futura, San Salvador, El Salvador', 13.7085, -89.241, 50, 5, 0, 30, 1, 'marlene@gmail.com', '2021-04-19 22:09:54', 3),
('P12', '19va convencion de informaticos', '2021-04-24 10:00:00', 'Metrocentro San Salvador, Calle Los Sisimiles, San Salvador, El Salvador', 13.706, -89.2117, 50, 1, 0, 15, 1, 'marlene@gmail.com', '2021-04-24 14:43:08', 1),
('P13', '20va convención de TI', '2021-04-24 19:01:00', 'Metrocentro San Salvador, Calle Los Sisimiles, San Salvador, El Salvador', 13.706, -89.2117, 50, 1, 0, 1, 1, 'marlene@gmail.com', '2021-04-24 19:03:02', 3),
('P14', '21va convención de TI', '2022-02-26 17:50:00', 'Ilopango, El Salvador', 13.6993, -89.1057, 50, 1, 0, 20, 1, 'marlene@gmail.com', '2021-04-26 17:50:25', 3),
('P15', '1era Feria de empleo Tech', '2021-05-28 11:00:00', 'Torre Futura, San Salvador, El Salvador', 13.7085, -89.241, 50, 3, 0, 20, 1, 'cronaldo@mail.com', '2021-04-30 21:00:52', 1),
('P16', '3ra Feria de empleo Tech', '2021-07-28 10:00:00', 'Salvador Del Mundo, San Salvador, El Salvador', 13.7013, -89.2244, 50, 2, 0, 20, 1, 'cronaldo@mail.com', '2021-05-01 16:41:48', 3),
('P17', '4ta Feria de empleo Tech', '2021-08-28 10:00:00', 'Plaza Mundo Apopa, Carretera Troncal Del Norte, Apopa, El Salvador', 13.7903, -89.1757, 3, 3, 0, 20, 1, 'cronaldo@mail.com', '2021-05-01 16:59:46', 1),
('P2', 'Hola mundo 2', '2021-03-19 11:32:00', 'El Salvador', 13.6588, -89.2006, 1, 1, 0, 0, 1, 'marlene@gmail.com', '2021-03-03 00:00:00', 1),
('P3', '4ta convencion de informaticos', '2021-04-07 12:00:00', 'Ilopango, El Salvador', 13.6993, -89.1057, 100, 2, 0, 20, 1, 'marlene@gmail.com', '2021-03-24 07:56:12', 1),
('P4', '5ta convención de TI 2.0', '2021-04-26 19:00:00', 'Metrocentro San Salvador, Calle Los Sisimiles, San Salvador, El Salvador', 13.706, -89.2117, 40, 4, 0, 10, 1, 'marlene@gmail.com', '2021-03-25 09:55:50', 3),
('P5', '6ta convención de TI', '2021-04-30 12:00:00', 'Chernobyl, Óblast de Kiev, Ucrania', 51.2763, 30.2219, 40, 3, 0, 20, 1, 'marlene@gmail.com', '2021-04-11 21:08:15', 1),
('P6', '8va convención de TI', '2021-06-11 10:00:00', 'Ilopango International Airport, Ilopango, El Salvador', 13.6958, -89.1147, 100, 5, 0, 20, 1, 'marlene@gmail.com', '2021-04-11 21:11:31', 3),
('P7', '9na convención de TI', '2021-07-11 14:00:00', 'Ilopango, El Salvador', 13.6993, -89.1057, 15, 0, 0, 30, 1, 'marlene@gmail.com', '2021-04-11 21:12:50', 3),
('P8', '10ma convencion de informaticos', '2021-10-15 15:00:00', 'San Francisco, California, EE. UU.', 37.7749, -122.419, 1, 1, 0, 1000, 1, 'marlene@gmail.com', '2021-04-15 17:25:13', 3),
('P9', '12va convencion de informaticos', '2021-04-19 18:49:00', 'Ilopango, El Salvador', 13.6993, -89.1057, 30, 2, 0, 10, 1, 'marlene@gmail.com', '2021-04-18 15:50:24', 3),
('V1', '7ma convención de TI', '2021-05-11 13:00:00', 'Ilopango, El Salvador', 13.6993, -89.1057, 40, 0, 0, 10, 2, 'marlene@gmail.com', '2021-04-11 21:10:12', 3),
('V2', '17va convención de TI', '2021-04-23 22:04:00', 'Ilopango, El Salvador', 13.6993, -89.1057, 21, 1, 0, 21, 2, 'marlene@gmail.com', '2021-04-23 22:04:50', 1),
('V3', '18va convención de TI', '2021-04-29 22:17:00', 'Ilopango, El Salvador', 13.6993, -89.1057, 20, 3, 0, 20, 2, 'marlene@gmail.com', '2021-04-23 22:20:01', 3),
('V4', '2da Feria de empleo Tech', '2021-06-28 10:00:00', 'Torre Futura, San Salvador, El Salvador', 13.7085, -89.241, 100, 3, 0, 10, 2, 'cronaldo@mail.com', '2021-05-01 16:06:10', 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_evento_reservado`
--

CREATE TABLE `tbl_evento_reservado` (
  `id_reservacion` int(11) NOT NULL,
  `id_evento_reservacion` varchar(30) DEFAULT NULL,
  `correo_usuario_reservacion` varchar(100) DEFAULT NULL,
  `estado_reservacion` int(11) DEFAULT NULL,
  `codigo_entrada` varchar(100) NOT NULL,
  `reserva_fecha_creacion` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `tbl_evento_reservado`
--

INSERT INTO `tbl_evento_reservado` (`id_reservacion`, `id_evento_reservacion`, `correo_usuario_reservacion`, `estado_reservacion`, `codigo_entrada`, `reserva_fecha_creacion`) VALUES
(15, 'P4', 'diaz21@gmail.com', 3, 'P41835', NULL),
(16, 'P3', 'diaz21@gmail.com', 1, 'P31984', NULL),
(17, 'P4', 'castillowilliamed@gmail.com', 3, 'P41917', NULL),
(18, 'P4', '1740682015@mail.utec.edu.sv', 3, 'P45414', NULL),
(19, 'P4', 'weemapp.sv@gmail.com', 3, 'P46932', NULL),
(20, 'P5', 'castillowilliamed@gmail.com', 1, 'P5782', '2021-04-13 00:00:00'),
(21, 'P6', 'castillowilliamed@gmail.com', 3, 'P68310', '2021-04-13 16:02:22'),
(22, 'P8', 'castillowilliamed@gmail.com', 3, 'P89881', '2021-04-15 17:40:36'),
(23, 'P6', 'diazwilliam698@gmail.com', 3, 'P610954', '2021-04-18 15:18:21'),
(24, 'P5', 'diazwilliam698@gmail.com', 3, 'P511414', '2021-04-18 15:30:16'),
(25, 'P9', 'diazwilliam698@gmail.com', 3, 'P912925', '2021-04-18 15:51:43'),
(26, 'P9', 'test12@gmail.com', 3, 'P913727', '2021-04-19 15:39:34'),
(27, 'P6', 'test12@gmail.com', 3, 'P614240', '2021-04-19 16:16:38'),
(28, 'P6', 'cesiacliente@gmail.com', 3, 'P615601', '2021-04-19 16:22:03'),
(29, 'P5', 'test12@gmail.com', 1, 'P516493', '2021-04-19 18:24:51'),
(30, 'P6', 'admin11000@gmail.com', 3, 'P617413', '2021-04-19 21:11:29'),
(31, 'P5', 'admin11000@gmail.com', 2, 'P518371', '2021-04-19 21:20:08'),
(32, 'P10', 'admin11000@gmail.com', 1, 'P1019599', '2021-04-19 21:50:54'),
(33, 'P11', 'admin11000@gmail.com', 3, 'P1120363', '2021-04-19 22:10:21'),
(34, 'V2', 'diaz21@gmail.com', 1, 'V221308', '2021-04-23 22:08:07'),
(35, 'V3', 'diaz21@gmail.com', 3, 'V322728', '2021-04-23 22:26:59'),
(36, 'P12', 'test12@gmail.com', 1, 'P1223524', '2021-04-24 14:48:24'),
(37, 'P13', 'test12@gmail.com', 3, 'P1324709', '2021-04-24 19:06:24'),
(38, 'V3', 'test12@gmail.com', 3, 'V325991', '2021-04-24 19:10:48'),
(39, 'V3', 'weemapp.sv@gmail.com', 3, 'V326264', '2021-04-24 19:12:35'),
(40, 'P14', 'test12@gmail.com', 3, 'P1427496', '2021-04-26 17:51:01'),
(41, 'P11', 'test12@gmail.com', 3, 'P1128262', '2021-04-26 17:54:21'),
(42, 'P11', 'cesiacliente@gmail.com', 3, 'P1129414', '2021-04-26 18:01:06'),
(43, 'P11', 'norma12@gmail.com', 3, 'P113097', '2021-04-26 18:06:28'),
(44, 'P11', 'castillowilliamed@gmail.com', 3, 'P1131154', '2021-04-26 18:08:27'),
(45, 'P15', 'admin11000@gmail.com', 1, 'P1532913', '2021-05-01 15:45:13'),
(46, 'P15', 'test12@gmail.com', 1, 'P153740', '2021-05-01 15:56:50'),
(47, 'P15', 'castillowilliamed@gmail.com', 1, 'P153552', '2021-05-01 16:02:19'),
(48, 'P10', 'castillowilliamed@gmail.com', 1, 'P102491', '2021-05-01 16:03:46'),
(49, 'V4', 'castillowilliamed@gmail.com', 3, 'V4undefined516', '2021-05-01 16:33:02'),
(50, 'V4', 'admin11000@gmail.com', 3, 'V42873', '2021-05-01 16:34:37'),
(51, 'V4', 'test12@gmail.com', 3, 'V43116', '2021-05-01 16:35:47'),
(52, 'P16', 'castillowilliamed@gmail.com', 3, 'P161272', '2021-05-01 16:42:05'),
(53, 'P16', 'admin11000@gmail.com', 3, 'P162872', '2021-05-01 16:44:15'),
(54, 'P17', 'castillowilliamed@gmail.com', 1, 'P171175', '2021-05-01 17:00:13'),
(55, 'P17', 'admin11000@gmail.com', 1, 'P172524', '2021-05-01 17:07:42'),
(56, 'P17', 'test12@gmail.com', 1, 'P173239', '2021-05-01 17:10:51');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_tipo_evento`
--

CREATE TABLE `tbl_tipo_evento` (
  `id_tipo_evento` int(11) NOT NULL,
  `nombre_tipo_evento` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `tbl_tipo_evento`
--

INSERT INTO `tbl_tipo_evento` (`id_tipo_evento`, `nombre_tipo_evento`) VALUES
(1, 'Presencial'),
(2, 'Virtual');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_tipo_sesion`
--

CREATE TABLE `tbl_tipo_sesion` (
  `id_tipo_sesion` int(11) NOT NULL,
  `nombre_tipo_sesion` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `tbl_tipo_sesion`
--

INSERT INTO `tbl_tipo_sesion` (`id_tipo_sesion`, `nombre_tipo_sesion`) VALUES
(1, 'Local'),
(2, 'Google');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_tipo_usuario`
--

CREATE TABLE `tbl_tipo_usuario` (
  `id_tipo_usuario` int(11) NOT NULL,
  `nombre_tipo_usuario` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `tbl_tipo_usuario`
--

INSERT INTO `tbl_tipo_usuario` (`id_tipo_usuario`, `nombre_tipo_usuario`) VALUES
(1, 'SuperAdmin'),
(2, 'Administrador de eventos'),
(3, 'Validador ventanilla'),
(4, 'Cliente');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_usuario`
--

CREATE TABLE `tbl_usuario` (
  `correo_usuario` varchar(100) NOT NULL,
  `nombre_usuario` varchar(50) DEFAULT NULL,
  `clave_usuario` varchar(100) DEFAULT NULL,
  `id_tipo_usuario` int(11) DEFAULT NULL,
  `estado_usuario` varchar(12) DEFAULT NULL,
  `tipo_sesion_usuario` int(11) DEFAULT NULL,
  `telefono_usuario` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `tbl_usuario`
--

INSERT INTO `tbl_usuario` (`correo_usuario`, `nombre_usuario`, `clave_usuario`, `id_tipo_usuario`, `estado_usuario`, `tipo_sesion_usuario`, `telefono_usuario`) VALUES
('1740682015@mail.utec.edu.sv', 'WILLIAM ERNESTO CASTILLO DIAZ', '', 4, '1', 2, ''),
('abraham@gmail.com', 'Abraham', '1234', 4, '1', 1, ''),
('admin11000@gmail.com', 'Emerson Rivera', 'sMpDy3dMnhh+/nASJ8ShngrHkP3WRqdkUsaeEwcSS30=', 4, 'ACTIVO', 1, '+50362005743'),
('admin1@gmail.com', 'Ernesto Castillo', 'b4JaCVbKnlLl6aIEZJUtp1gHrgX/+vHR0qd6/nJF9+Y=', 1, 'ACTIVO', 1, ''),
('admin500@gmail.com', 'Norma Diaz de Bolaños', '1qaz.algo', 3, 'ACTIVO', 1, ''),
('admin@gmail.com', 'William Castillo Díaz', 'btbmSvMJsMH6h3S0dXXF6oofAMTopdYZ9lvx1Ad4Qbg=', 1, 'ACTIVO', 1, ''),
('castillo788@gmail.com', 'Ernesto Castillo', '12345', 1, 'ACTIVO', 1, ''),
('castillo798@gmail.com', 'Ernesto Castillo', '12345', 2, 'ACTIVO', 1, ''),
('castillowilliamed@gmail.com', 'William Castillo', '', 4, '1', 2, '+50374369067'),
('cesia@gmail.com', 'Cesia Bolaños', 'lxDqmimtf6Fnip37IQ1+qTB3ALEhvsek2N50d1pqk5Y=', 2, 'INHABILITADO', 1, ''),
('cesiacliente@gmail.com', 'Cesia Noemi', 'btbmSvMJsMH6h3S0dXXF6oofAMTopdYZ9lvx1Ad4Qbg=', 4, 'ACTIVO', 1, '+50379164612'),
('cronaldo@mail.com', 'Cristiano Ronaldo', 'btbmSvMJsMH6h3S0dXXF6oofAMTopdYZ9lvx1Ad4Qbg=', 2, 'ACTIVO', 1, 'undefined'),
('diaz1@gmail.com', 'Norma Diaz de Bolaños', 'lxDqmimtf6Fnip37IQ1+qTB3ALEhvsek2N50d1pqk5Y=', 2, 'ACTIVO', 1, ''),
('diaz21@gmail.com', 'William Castillo', 'btbmSvMJsMH6h3S0dXXF6oofAMTopdYZ9lvx1Ad4Qbg=', 4, 'ACTIVO', 1, ''),
('diaz@gmail.com', 'Norma Diaz de Bolaños', '29a/P6lGwldxUngYYwpUbABXUrr2zvBN3AsJM5uQN6s=', 1, 'ACTIVO', 1, ''),
('diazwilliam698@gmail.com', 'WillDiaz798', '', 4, 'ACTIVO', 2, ''),
('ernesto@gmail.com', 'Ernesto Diaz', 'lxDqmimtf6Fnip37IQ1+qTB3ALEhvsek2N50d1pqk5Y=', 1, 'ACTIVO', 1, ''),
('eventos2021@gmail.com', 'William', '12345', 2, 'ACTIVO', 1, ''),
('imartinez@mail.com', 'Iker Martinez', 'AV3AQAEIheAjngUZ+KydfUBoHRUD5aSgblXa25ONwMU=', 2, 'ACTIVO', 1, 'undefined'),
('isa@gmail.com', 'Isai el completo', 'lxDqmimtf6Fnip37IQ1+qTB3ALEhvsek2N50d1pqk5Y=', 3, 'ACTIVO', 1, ''),
('jgonzales@gmail.com', 'Jorge Gonzales', '797mdDM2VveY8MVN4+76qTZ+OtuHCw56PE2PkfIDZyw=', 3, 'ACTIVO', 1, 'undefined'),
('josue@gmail.com', 'Josue Bolaños Diaz', 'btbmSvMJsMH6h3S0dXXF6oofAMTopdYZ9lvx1Ad4Qbg=', 3, 'ACTIVO', 1, ''),
('juan@gmail.com', 'Juan Diaz', 'lxDqmimtf6Fnip37IQ1+qTB3ALEhvsek2N50d1pqk5Y=', 3, 'ACTIVO', 1, ''),
('marlene@gmail.com', 'Marlene', 'sMpDy3dMnhh+/nASJ8ShngrHkP3WRqdkUsaeEwcSS30=', 2, 'ACTIVO', 1, ''),
('mauricio@gmail.com', 'Mauricio', '1234', 1, 'ACTIVO', 1, ''),
('mgaldamez12@mail.com', 'Maria Galdamez', 'b4JaCVbKnlLl6aIEZJUtp1gHrgX/+vHR0qd6/nJF9+Y=', 2, 'ACTIVO', 1, 'undefined'),
('mgaldamez@mail.com', 'Maria Galdamez', 'b4JaCVbKnlLl6aIEZJUtp1gHrgX/+vHR0qd6/nJF9+Y=', 1, 'ACTIVO', 1, 'undefined'),
('mhernandez@mail.com', 'Maricruz Hernandez', 'btbmSvMJsMH6h3S0dXXF6oofAMTopdYZ9lvx1Ad4Qbg=', 2, 'ACTIVO', 1, ''),
('norma12@gmail.com', 'Norma', 'btbmSvMJsMH6h3S0dXXF6oofAMTopdYZ9lvx1Ad4Qbg=', 4, 'ACTIVO', 1, '+50379133528'),
('nrosales@mail.com', 'Neymar Rosales', 'AV3AQAEIheAjngUZ+KydfUBoHRUD5aSgblXa25ONwMU=', 3, 'ACTIVO', 1, 'undefined'),
('obama@gmail.com', 'Obama', 'lxDqmimtf6Fnip37IQ1+qTB3ALEhvsek2N50d1pqk5Y=', 1, 'ACTIVO', 2, ''),
('rivera100@gmail.com', 'Emerson Rivera', 'b4JaCVbKnlLl6aIEZJUtp1gHrgX/+vHR0qd6/nJF9+Y=', 1, 'ACTIVO', 1, ''),
('rivera1010@gmail.com', 'Emerson Rivera', 'b4JaCVbKnlLl6aIEZJUtp1gHrgX/+vHR0qd6/nJF9+Y=', 4, '1', 1, ''),
('rivera101@gmail.com', 'Emerson Rivera', 'b4JaCVbKnlLl6aIEZJUtp1gHrgX/+vHR0qd6/nJF9+Y=', 1, 'ACTIVO', 1, ''),
('rivera102@gmail.com', 'Emerson Rivera', 'b4JaCVbKnlLl6aIEZJUtp1gHrgX/+vHR0qd6/nJF9+Y=', 1, 'ACTIVO', 1, ''),
('rivera103@gmail.com', 'Emerson Rivera', 'b4JaCVbKnlLl6aIEZJUtp1gHrgX/+vHR0qd6/nJF9+Y=', 1, 'ACTIVO', 1, ''),
('rivera121@gmail.com', 'Emerson Rivera', '1', 1, 'ACTIVO', 1, ''),
('rivera12@gmail.com', 'Emerson Rivera', '1234', 1, 'ACTIVO', 1, ''),
('rivera13@gmail.com', 'Emerson Rivera', '123', 1, 'ACTIVO', 1, ''),
('rivera14@gmail.com', 'Emerson Rivera', '123', 1, 'ACTIVO', 1, ''),
('rivera15@gmail.com', 'Emerson Rivera', '123', 1, 'ACTIVO', 1, ''),
('rivera16@gmail.com', 'Emerson Rivera', '123', 1, 'ACTIVO', 1, ''),
('rivera17@gmail.com', 'Emerson Rivera', '123', 1, 'ACTIVO', 1, ''),
('rivera19@gmail.com', 'Emerson Rivera', 'lxDqmimtf6Fnip37IQ1+qTB3ALEhvsek2N50d1pqk5Y=', 2, 'ACTIVO', 1, ''),
('rivera1@gmail.com', 'Emerson Rivera', '1234', 1, 'ACTIVO', 1, ''),
('rivera200@gmail.com', 'Emerson Rivera', 'lxDqmimtf6Fnip37IQ1+qTB3ALEhvsek2N50d1pqk5Y=', 1, 'ACTIVO', 1, ''),
('rivera20@gmail.com', 'Emerson Rivera', '1', 2, 'ACTIVO', 1, ''),
('rivera21@gmail.com', 'Emerson Rivera', '12', 2, 'ACTIVO', 1, ''),
('rivera2330@gmail.com', 'Emerson Rivera', '1', 1, 'ACTIVO', 1, ''),
('rivera23@gmail.com', 'Emerson Rivera', '123', 1, 'ACTIVO', 1, ''),
('rivera24@gmail.com', 'Emerson Rivera', '123', 1, 'ACTIVO', 1, ''),
('rivera25@gmail.com', 'Emerson Rivera', '123', 1, 'ACTIVO', 1, ''),
('rivera27@gmail.com', 'Emerson Rivera', '1', 1, 'ACTIVO', 1, ''),
('rivera300@gmail.com', 'Emerson Rivera', 'lxDqmimtf6Fnip37IQ1+qTB3ALEhvsek2N50d1pqk5Y=', 1, 'ACTIVO', 1, ''),
('rivera35@gmail.com', 'Emerson Rivera', 'b4JaCVbKnlLl6aIEZJUtp1gHrgX/+vHR0qd6/nJF9+Y=', 1, 'ACTIVO', 1, ''),
('rivera99@gmail.com', 'Emerson Rivera', 'b4JaCVbKnlLl6aIEZJUtp1gHrgX/+vHR0qd6/nJF9+Y=', 1, 'ACTIVO', 1, ''),
('rivera@gmail.com', 'Emerson Rivera', '8r/syiAlEtDDcy2aHDc3YvIw12BT2GHrCXsQ7g3mReI=', 1, 'ACTIVO', 1, ''),
('tesla@gmail.com', 'Tesla', 'btbmSvMJsMH6h3S0dXXF6oofAMTopdYZ9lvx1Ad4Qbg=', 1, 'ACTIVO', 1, 'undefined'),
('test12@gmail.com', 'Test', 'btbmSvMJsMH6h3S0dXXF6oofAMTopdYZ9lvx1Ad4Qbg=', 4, 'ACTIVO', 1, '+50375173872'),
('tmelgar@mail.com', 'Tulio Melgar', 'AV3AQAEIheAjngUZ+KydfUBoHRUD5aSgblXa25ONwMU=', 2, 'ACTIVO', 1, 'undefined'),
('tomii11@gmail.com', 'tomii', 'H+oMkUjLmXulI5wuTzfoZQK1wvRuQmo0VmtpcU3iBaY=', 2, 'ACTIVO', 1, 'undefined'),
('weemapp.sv@gmail.com', 'WEEM APP', '', 4, 'ACTIVO', 2, '+50374369067'),
('willdiazije@gmail.com', 'will diaz', '', 4, 'ACTIVO', 2, ''),
('william503@gmail.com', 'William', 'btbmSvMJsMH6h3S0dXXF6oofAMTopdYZ9lvx1Ad4Qbg=', 2, 'ACTIVO', 1, 'undefined'),
('william504@gmail.com', 'William', '12345', 2, 'ACTIVO', 1, ''),
('william@gmail.com', 'William', '1234', 4, 'ACTIVO', 1, ''),
('williams@gmail.com', 'William', 'AV3AQAEIheAjngUZ+KydfUBoHRUD5aSgblXa25ONwMU=', 2, 'ACTIVO', 1, ''),
('xgrvzcfdh@cbvxzf', 'cnbvg', '1', 2, 'INHABILITADO', 1, ''),
('zcfsdvrx@cnbvxfg', 'bvxzcf dn', 'D1J4Wadej9lKOLpwyBEa1aTZwg0qfNmLzZgqKErz8ec=', 1, 'ACTIVO', 1, '');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `tbl_estado_evento`
--
ALTER TABLE `tbl_estado_evento`
  ADD PRIMARY KEY (`id_estado_evento`);

--
-- Indices de la tabla `tbl_estado_reservacion`
--
ALTER TABLE `tbl_estado_reservacion`
  ADD PRIMARY KEY (`id_estado_reservacion`);

--
-- Indices de la tabla `tbl_evento`
--
ALTER TABLE `tbl_evento`
  ADD PRIMARY KEY (`id_evento`),
  ADD KEY `tipo_evento` (`tipo_evento`),
  ADD KEY `id_usuario_creador` (`id_usuario_creador`),
  ADD KEY `estado_evento` (`estado_evento`);

--
-- Indices de la tabla `tbl_evento_reservado`
--
ALTER TABLE `tbl_evento_reservado`
  ADD PRIMARY KEY (`id_reservacion`),
  ADD KEY `id_evento_reservacion` (`id_evento_reservacion`),
  ADD KEY `correo_usuario_reservacion` (`correo_usuario_reservacion`),
  ADD KEY `estado_reservacion` (`estado_reservacion`);

--
-- Indices de la tabla `tbl_tipo_evento`
--
ALTER TABLE `tbl_tipo_evento`
  ADD PRIMARY KEY (`id_tipo_evento`);

--
-- Indices de la tabla `tbl_tipo_sesion`
--
ALTER TABLE `tbl_tipo_sesion`
  ADD PRIMARY KEY (`id_tipo_sesion`);

--
-- Indices de la tabla `tbl_tipo_usuario`
--
ALTER TABLE `tbl_tipo_usuario`
  ADD PRIMARY KEY (`id_tipo_usuario`);

--
-- Indices de la tabla `tbl_usuario`
--
ALTER TABLE `tbl_usuario`
  ADD PRIMARY KEY (`correo_usuario`),
  ADD KEY `id_tipo_usuario` (`id_tipo_usuario`),
  ADD KEY `tipo_sesion_usuario` (`tipo_sesion_usuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `tbl_evento_reservado`
--
ALTER TABLE `tbl_evento_reservado`
  MODIFY `id_reservacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `tbl_evento`
--
ALTER TABLE `tbl_evento`
  ADD CONSTRAINT `tbl_evento_ibfk_1` FOREIGN KEY (`tipo_evento`) REFERENCES `tbl_tipo_evento` (`id_tipo_evento`),
  ADD CONSTRAINT `tbl_evento_ibfk_2` FOREIGN KEY (`id_usuario_creador`) REFERENCES `tbl_usuario` (`correo_usuario`),
  ADD CONSTRAINT `tbl_evento_ibfk_3` FOREIGN KEY (`estado_evento`) REFERENCES `tbl_estado_evento` (`id_estado_evento`);

--
-- Filtros para la tabla `tbl_evento_reservado`
--
ALTER TABLE `tbl_evento_reservado`
  ADD CONSTRAINT `tbl_evento_reservado_ibfk_1` FOREIGN KEY (`id_evento_reservacion`) REFERENCES `tbl_evento` (`id_evento`),
  ADD CONSTRAINT `tbl_evento_reservado_ibfk_2` FOREIGN KEY (`correo_usuario_reservacion`) REFERENCES `tbl_usuario` (`correo_usuario`),
  ADD CONSTRAINT `tbl_evento_reservado_ibfk_3` FOREIGN KEY (`estado_reservacion`) REFERENCES `tbl_estado_reservacion` (`id_estado_reservacion`);

--
-- Filtros para la tabla `tbl_usuario`
--
ALTER TABLE `tbl_usuario`
  ADD CONSTRAINT `tbl_usuario_ibfk_1` FOREIGN KEY (`id_tipo_usuario`) REFERENCES `tbl_tipo_usuario` (`id_tipo_usuario`),
  ADD CONSTRAINT `tbl_usuario_ibfk_2` FOREIGN KEY (`tipo_sesion_usuario`) REFERENCES `tbl_tipo_sesion` (`id_tipo_sesion`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
