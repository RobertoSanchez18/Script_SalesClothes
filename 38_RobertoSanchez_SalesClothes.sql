/*Si la base de datos ya existe la eliminamos */
DROP DATABASE IF EXISTS db_SalesClothes
GO

/* Crear base de datos Sales Clothes */
CREATE DATABASE db_SalesClothes
GO

/* Poner en uso la base de datos */
USE db_SalesClothes
GO

/* Crear tabla client */
CREATE TABLE client
(
	id int identity(1,1),
	type_document char(3),
	number_document char(15),
	names varchar(60),
	last_name varchar(90),
	email varchar(80),
	cell_phone char(9),
	birthdate date,
	active bit
	CONSTRAINT client_pk PRIMARY KEY (id)
)
GO


/*  RESTRICCIONES  */



/* El tipo de documento puede ser DNI ó CNE */
ALTER TABLE client
	DROP COLUMN type_document
GO

/* Agregar restricción para tipo documento */
ALTER TABLE client
	ADD type_document char(3)
	CONSTRAINT type_document_client 
	CHECK(type_document ='DNI' OR type_document ='CNE')
GO


/* Eliminar columna number_document de tabla client */
ALTER TABLE client
	DROP COLUMN number_document
GO

/* El número de documento sólo debe permitir dígitos de 0 - 9 */
ALTER TABLE client
	ADD number_document char(9)
	CONSTRAINT number_document_client
	CHECK (number_document like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][^A-Z]')
GO



/* Eliminar columna email de tabla client */
ALTER TABLE client
	DROP COLUMN email
GO

/* Agregar columna email */
ALTER TABLE client
	ADD email varchar(80)
	CONSTRAINT email_client
	CHECK(email LIKE '%@%._%')
GO

/* Eliminar columna celular */
ALTER TABLE client
	DROP COLUMN cell_phone
GO

/* Validar que el celular esté conformado por 9 números */
ALTER TABLE client
	ADD cell_phone char(9)
	CONSTRAINT cellphone_client
	CHECK (cell_phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
GO

/* Eliminar columna fecha de nacimiento */
ALTER TABLE client
	DROP COLUMN birthdate
GO

/* Sólo debe permitir el registro de clientes mayores de edad */
ALTER TABLE client
	ADD  birthdate date
	CONSTRAINT birthdate_client
	CHECK((YEAR(GETDATE())- YEAR(birthdate )) >= 18)
GO

/* Eliminar columna active de tabla client */
ALTER TABLE client
	DROP COLUMN active
GO

/* El valor predeterminado será activo al registrar clientes */
ALTER TABLE client
	ADD active bit DEFAULT (1)
GO


/* Listar las restricciones de la tabla client */
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
WHERE TABLE_NAME = 'client'
GO


/* Crear tabla seller */
CREATE TABLE  seller
(
	id int identity(1,1),
	type_document char(3),
	number_document char(15),
	names varchar(60),
	last_name varchar(90),
	salary decimal(8,2) DEFAULT 1025,
	cell_phone char(9),
	email varchar(80),
	active bit
	CONSTRAINT seller_pk PRIMARY KEY (id)
)
GO

DROP TABLE seller;



/* Eliminar relación sale_seller */
ALTER TABLE sale
	DROP CONSTRAINT sale_seller
GO

/* Quitar Primary Key en tabla seller */
ALTER TABLE seller
	DROP CONSTRAINT seller_pk
GO



/* RESTRICCIONES */

/* El tipo de documento puede ser DNI ó CNE */
ALTER TABLE seller
	DROP COLUMN type_document
GO

/* Agregar restricción para tipo documento */
ALTER TABLE seller
	ADD type_document char(3)
	CONSTRAINT type_document_seller
	CHECK(type_document ='DNI' OR type_document ='CNE')
GO


/* Eliminar columna number_document de tabla seller */
ALTER TABLE seller
	DROP COLUMN number_document
GO

/* El número de documento sólo debe permitir dígitos de 0 - 9 */
ALTER TABLE seller
	ADD number_document char(9)
	CONSTRAINT number_document_seller
	CHECK (number_document like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][^A-Z]')
GO


/* Eliminar columna celular */
ALTER TABLE seller
	DROP COLUMN cell_phone
GO

/* Validar que el celular esté conformado por 9 números */
ALTER TABLE seller
	ADD cell_phone char(9)
	CONSTRAINT cellphone_seller
	CHECK (cell_phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
GO

/* Eliminar columna email de tabla seller */
ALTER TABLE seller
	DROP COLUMN email
GO

/* Agregar columna email */
ALTER TABLE seller
	ADD email varchar(80)
	CONSTRAINT email_seller
	CHECK(email LIKE '%@%._%')
GO

/* Eliminar columna active de tabla seller */
ALTER TABLE seller
	DROP COLUMN active
GO

/* El valor predeterminado será activo seller */
ALTER TABLE seller
	ADD active bit DEFAULT (1)
GO



/* Crear tabla clothes */
CREATE TABLE clothes
(
	id int identity(1,1),
	descriptions varchar(60),
	brand varchar(60),
	amount int,
	size varchar(10),
	price decimal(8,2),
	active bit
	CONSTRAINT clothes_pk PRIMARY KEY (id)
)
GO


/* Eliminar columna active de tabla clothes */
ALTER TABLE clothes
	DROP COLUMN active
GO

/* El valor predeterminado será activo clothes */
ALTER TABLE clothes
	ADD active bit DEFAULT (1)
GO



/* Crear tabla sale */
CREATE TABLE sale
(
	id int identity(1,1),
	date_time datetime DEFAULT GETDATE(),
	seller_id int,
	client_id int,
	active bit
	CONSTRAINT sale_pk PRIMARY KEY (id)
)
GO

/* Tener valor predeterminado la fecha y hora del servidor */
ALTER TABLE sale
	ADD CONSTRAINT date_time_sale
DEFAULT GETDATE() FOR date_time;



/* Eliminar columna active de tabla sale */
ALTER TABLE sale
	DROP COLUMN active
GO

/* El valor predeterminado será activo clothes */
ALTER TABLE sale
	ADD active bit DEFAULT (1)
GO


/* Crear tabla sale_detail */
CREATE TABLE sale_detail
(
	id int identity(1,1),
	sale_id int,
	clothes_id int,
	amount int
)
GO

/* Relacionar tabla sale con tabla client */
ALTER TABLE sale
	ADD CONSTRAINT sale_client FOREIGN KEY (client_id)
	REFERENCES client (id)
	ON UPDATE CASCADE 
	ON DELETE CASCADE
GO

/* Relacionar tabla sale con seller */
ALTER TABLE sale
	ADD CONSTRAINT sale_seller FOREIGN KEY (seller_id)
	REFERENCES seller (id)
	ON UPDATE CASCADE
	ON DELETE CASCADE
GO

/* Relacionar tabla sale_detail con clothes */
ALTER TABLE sale_detail
	ADD CONSTRAINT sale_detail_clothes FOREIGN KEY (clothes_id)
	REFERENCES clothes (id)
	ON UPDATE CASCADE
	ON DELETE CASCADE
GO

/* Relacionar tabla sale con sale_detail */
ALTER TABLE sale_detail
	ADD CONSTRAINT sale_detail_sale FOREIGN KEY (sale_id)
	REFERENCES sale (id)
	ON UPDATE CASCADE
	ON DELETE CASCADE
GO

/* Configurar el idioma a Español */
SET LANGUAGE Español
GO
SELECT @@language AS 'Idioma'
GO

/* Configurar el formato de fecha */
SET DATEFORMAT dmy
GO


/* Probando insercion de registros a client*/
INSERT INTO client 
(type_document, number_document, names, last_name, email, cell_phone, birthdate)
VALUES
('DNI', '78451233', 'Fabiola', 'Perales Campos', 'fabiolaperales@gmail.com', '991692597', '19/01/2005'),
('DNI', '14782536', 'Marcos', 'Dávila Palomino', 'marcosdavila@gmail.com', '982514752', '03/03/1990'),
('DNI', '78451236', 'Luis Alberto', 'Barrios Paredes', 'luisbarrios@outlook.com', '985414752', '03/10/1995'),
('CNE', '352514789', 'Claudia Maria', 'Martinez Rodriguez', 'claudiamartinez@yahoo.com', '995522147', '23/09/1992'),
('CNE', '142536792', 'Mario Tadeo', 'Farfan Castillo', 'mariotadeo@outlook.com', '973125478', '25/11/1997'),
('DNI', '58251433', 'Ana Lucrecia', 'Chumpitaz Prada', 'anachumpitaz@gmail.com', '982514361', '17/10/1992'),
('DNI', '15223369', 'Humberto', 'Cabrera Tadeo', 'humbertocabrera@yahoo.com', '977112234', '27/05/1990'),
('DNI', '442233698', 'Rosario', 'Prada Velasquez', 'rosarioprada@outlook.com', '971144782', '05/11/1990')
GO

SELECT * FROM client;



/* Probando insercion de registros a seller */
INSERT INTO seller
(type_document, number_document, names, last_name, salary, cell_phone, email)
VALUES
('DNI', '11224578', 'Oscar', 'Paredes Flores', '1025', '985566251', 'oparedes@miempresa.com'),
('CNE', '889922365', 'Azucena', 'Valle Alcazar', '1025', '966338874', 'avalle@miempresa.com'),
('DNI', '44771123', 'Rosario', 'Huarca Tarazona', '1025', '933665521', 'rhuaraca@miempresa.com')
GO

SELECT * FROM seller;


/* Probando insercion de registros a clothes */
INSERT INTO clothes
(descriptions, brand, amount, size, price)
VALUES
('Polo camisero', 'Adidas', '20', 'Medium', '40.50'),
('Short playero', 'Nike', '30', 'Medium', '55.50'),
('Camisa sport', 'Adams', '60', 'Large', '60.80'),
('Camisa sport', 'Adams', '70', 'Medium', '58.75'),
('buzo de verano', 'Reebok', '45', 'Small', '62.90'),
('Pantalon Jean', 'Lewis', '35', 'Large', '73.60')
GO

SELECT * FROM clothes;


/*Listar todos los datos de los clientes (client) cuyo tipo de documento sea DNI*/
SELECT * FROM client WHERE type_document = 'DNI';

/*Listar todos los datos de los clientes (client) cuyo servidor de correo electrónico sea outlook.com*/
SELECT * FROM client WHERE email LIKE '%@outlook.com';

/*Listar todos los datos de los vendedores (seller) cuyo tipo de documento sea CNE.*/
SELECT * FROM seller WHERE type_document = 'CNE';

/*Listar todas las prendas de ropa (clothes) cuyo costo sea menor e igual que S/. 55.00*/
SELECT * FROM clothes WHERE price <= 55.00;

/*Listar todas las prendas de ropa (clothes) cuya marca sea Adams.*/
SELECT * FROM clothes WHERE brand = 'Adams';

/*Eliminar lógicamente los datos de un cliente client de acuerdo a un determinado id.*/
UPDATE client SET deleted = 1 WHERE id = <id>;

/*Eliminar lógicamente los datos de un cliente seller de acuerdo a un determinado id.*/
UPDATE seller SET deleted = 1 WHERE id = <id>;

/*Eliminar lógicamente los datos de un cliente clothes de acuerdo a un determinado id */
UPDATE clothes SET deleted = 1 WHERE id = <id>;
