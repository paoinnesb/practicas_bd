
/*
Script para la creación de la base de datos
*/

--Creacion de tablas
DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;

CREATE TABLE tarjeta(
	numero_tarjeta INT NOT NULL UNIQUE,
	curp_cliente VARCHAR(18) NOT NULL CHECK(CHAR_LENGTH(curp_cliente)=18),
	vencimiento DATE NOT NULL,
	tipo_tarjeta VARCHAR(20) CHECK(tipo_tarjeta <> '')
);

CREATE TABLE categoria(
	id_categoria VARCHAR(30) CHECK (id_categoria <> '') UNIQUE,
	descripcion VARCHAR(100) CHECK (descripcion <> ''),
	nombre VARCHAR(30) CHECK(nombre <> ''),
	cantidad_de_productos INT NOT NULL
);

CREATE TABLE proveedor(
	rfc VARCHAR(12) NOT NULL CHECK(CHAR_LENGTH (rfc) = 12) unique,
	razon_social VARCHAR(30) CHECK (razon_social <> ''),
	calle VARCHAR (30) CHECK(calle <> ''),
	estado VARCHAR (30) CHECK(estado <> ''),
	municipio VARCHAR (30) CHECK (municipio <> ''),
	numero VARCHAR (13) CHECK (numero <> ''),
	codigo_postal INT CHECK(codigo_postal between 10000 and 99999)
);

CREATE TABLE producto(
	codigo_barras VARCHAR(18) NOT NULL UNIQUE,
	rfc VARCHAR(12) NOT NULL CHECK(CHAR_LENGTH (rfc) = 12),
	id_categoria VARCHAR(30) CHECK (id_categoria <> ''),
	precio DECIMAL(18,2),
	unidades_disponibles INT NOT NULL,
	imagen VARCHAR NOT NULL,
	nombre VARCHAR(30) CHECK(nombre <> '')
);

CREATE TABLE Pedido(
	ID_Pedido INT NOT NULL UNIQUE,
	Fecha DATE NOT NULL,
	Hora TIME NOT NULL,
	metodoPago VARCHAR(50) check(metodoPago <>''),
	curp_cliente VARCHAR(18) NOT NULL CHECK(CHAR_LENGTH(curp_cliente) = 18),
	ID_Envio_Express INT,
	ID_Envio_Normal INT
);

CREATE TABLE Tener(
	ID_Pedido INT NOT NULL,
	codigo_Barras VARCHAR(18) NOT NULL
);

CREATE TABLE envio_express(
	id_envio_express INT NOT NULL UNIQUE,
	curp_repartidor VARCHAR(18) NOT NULL CHECK(CHAR_LENGTH(curp_repartidor) = 18),
	precio decimal(18,2) CHECK(precio > 0),
	estado VARCHAR(30) CHECK(estado <> ''),
	tiempo_de_envio DATE NOT NULL,
	tiempo VARCHAR(30) CHECK(tiempo <>''),
	costo decimal(18,2) CHECK(costo > 0)
);

CREATE TABLE envio_normal(
	id_envio_normal INT NOT NULL UNIQUE,
	curp_repartidor VARCHAR(18) NOT NULL CHECK(CHAR_LENGTH(curp_repartidor) = 18),
	estado VARCHAR(30) CHECK(estado <> ''),
	tiempo_de_envio DATE NOT NULL,
	precio decimal(18,2) CHECK(precio > 0)
);

CREATE TABLE cliente(
	curp_cliente VARCHAR(18) NOT NULL CHECK(CHAR_LENGTH(curp_cliente) = 18) UNIQUE,
	fecha_de_nacimiento date NOT NULL,
	genero CHAR(1) CHECK(CHAR_LENGTH(genero) = 1),
	calle VARCHAR(30) CHECK(calle <> ''),
	estado VARCHAR(30) CHECK(estado <> ''),
	municipio VARCHAR(30) CHECK(municipio <> ''),
	codigo_postal INT CHECK(codigo_postal between 10000 and 99999),
	numero VARCHAR(13) CHECK(numero <> ''),
	nombre VARCHAR(30) CHECK(nombre <> ''),
	apellido_paterno VARCHAR (30) CHECK (apellido_paterno <> ''),
	apellido_materno VARCHAR(30) CHECK (apellido_materno <> ''),
	correo_electronico VARCHAR (30) CHECK (correo_electronico <> ''),
	contraseña VARCHAR (50) CHECK(contraseña <> ''),
	puntos_acumulados INT NOT NULL
);

CREATE TABLE Repartidor(
	curp_repartidor VARCHAR(18) NOT NULL CHECK(CHAR_LENGTH(curp_repartidor) = 18) UNIQUE,
	curp_supervisor VARCHAR(18) NOT NULL CHECK(CHAR_LENGTH(curp_supervisor) = 18),
	fecha_de_nacimiento date NOT NULL,
	genero CHAR(1) CHECK(CHAR_LENGTH(genero) = 1),
	calle VARCHAR(30) CHECK(calle <> ''),
	estado VARCHAR(30) CHECK(estado <> ''),
	municipio VARCHAR(30) CHECK(municipio <> ''),
	codigo_postal INT CHECK(codigo_postal between 10000 and 99999),
	numero VARCHAR(13) CHECK(numero <> ''),
	nombre VARCHAR(30) CHECK(nombre <> ''),
	apellido_paterno VARCHAR (30) CHECK (apellido_paterno <> ''),
	apellido_materno VARCHAR(30) CHECK (apellido_materno <> ''),
	salario VARCHAR (10) CHECK (salario <> ''),
	horario VARCHAR (11) CHECK(CHAR_LENGTH(horario) = 11),
	calificacion INT CHECK(calificacion between 0 and 10)
);

CREATE TABLE telefono(
	telefono VARCHAR (13) NOT NULL CHECK (telefono <> ''),
	rfc VARCHAR(12) NOT NULL CHECK(CHAR_LENGTH (rfc) = 12)
);

/*
LLAVES PRIMARIAS, FORANEAS Y COMPUESTAS
*/
ALTER TABLE cliente ADD CONSTRAINT cliente_pk PRIMARY KEY (curp_cliente);

ALTER TABLE tarjeta ADD CONSTRAINT tarjeta_pk PRIMARY KEY (numero_tarjeta);
ALTER TABLE tarjeta ADD CONSTRAINT cliente_fk FOREIGN KEY (curp_cliente) REFERENCES cliente(curp_cliente);

ALTER TABLE telefono ADD CONSTRAINT telefono_pk PRIMARY KEY (rfc, telefono);
ALTER TABLE telefono ADD CONSTRAINT proveedor_fk FOREIGN KEY (rfc) REFERENCES proveedor(rfc);

ALTER TABLE proveedor ADD CONSTRAINT proveedor_pk PRIMARY KEY (rfc);

ALTER TABLE categoria ADD CONSTRAINT categoria_pk PRIMARY KEY (id_categoria);

ALTER TABLE producto ADD CONSTRAINT producto_pk PRIMARY KEY (codigo_Barras);
ALTER TABLE producto ADD CONSTRAINT proveedor_fk FOREIGN KEY (rfc) REFERENCES proveedor(rfc);

ALTER TABLE Repartidor ADD CONSTRAINT repartidor_pk PRIMARY KEY (curp_repartidor);
ALTER TABLE Repartidor ADD CONSTRAINT supervisor_fk FOREIGN KEY (curp_supervisor) REFERENCES Repartidor(curp_supervisor);

ALTER TABLE envio_normal ADD CONSTRAINT envio_normal_pk PRIMARY KEY (id_envio_normal);
ALTER TABLE envio_normal ADD CONSTRAINT repartidor_fk FOREIGN KEY (curp_repartidor) REFERENCES Repartidor(curp_repartidor);

ALTER TABLE envio_express ADD CONSTRAINT envio_express_pk PRIMARY KEY (id_envio_express);
ALTER TABLE envio_express ADD CONSTRAINT repartidor_fk FOREIGN KEY (curp_repartidor) REFERENCES Repartidor(curp_repartidor);

ALTER TABLE Pedido ADD CONSTRAINT pedido_pk PRIMARY KEY (ID_Pedido);
ALTER TABLE Pedido ADD CONSTRAINT cliente_fk FOREIGN KEY (curp_cliente) REFERENCES cliente(curp_cliente);
ALTER TABLE Pedido ADD CONSTRAINT envio_normal_fk FOREIGN KEY (id_envio_normal) REFERENCES envio_normal(id_envio_normal);
ALTER TABLE Pedido ADD CONSTRAINT envio_express_fk FOREIGN KEY (id_envio_express) REFERENCES envio_express(id_envio_express);

ALTER TABLE Tener ADD CONSTRAINT pedido_fk FOREIGN KEY (ID_Pedido) REFERENCES Pedido(ID_Pedido);
ALTER TABLE Tener ADD CONSTRAINT producto_fk FOREIGN KEY (codigo_Barras) REFERENCES producto(codigo_Barras);

ALTER TABLE producto ADD CONSTRAINT categoria_fk FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria);
