CREATE DATABASE IF NOT EXISTS internet;

-- tabla provincias
DROP TABLE IF EXISTS provincias;
CREATE TABLE provincias(
Id_Provincia INT auto_increment PRIMARY KEY,
Provincia VARCHAR(50));

CREATE TEMPORARY TABLE temp_provincias (
    Provincia VARCHAR(255));

LOAD DATA INFILE "C:\\Users\\Fernando\\Desktop\\Analisis-de-data-internet-en-Argentina\\Datasets separados\\velocidad_provincia"
INTO TABLE temp_provincias
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@dummy, @dummy, @dummy, Provincia, @dummy);

INSERT INTO provincias (Provincia)
SELECT DISTINCT Provincia
FROM temp_provincias;

DROP temporary TABLE temp_provincias;
select * FROM provincias;

-- tabla tecnologias
DROP TABLE IF EXISTS tecnologias;
CREATE TABLE IF NOT EXISTS tecnologias(
Id_Tecnologia INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
tecnologia VARCHAR (50));

INSERT INTO tecnologias (Tecnologia)
VALUES ('ADSL'),('Cablemodem'),('Fibra optica'), ('Wireless'),('Otros'),('BAF'),('Dial');

SELECT * FROM tecnologias;


-- tabla partido 
DROP TABLE IF EXISTS partidos;
CREATE TABLE IF NOT EXISTS partidos(
Id_Partido INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
Partido VARCHAR (200),
Provincia VARCHAR (200),
Id_Provincia INT ) ;

DROP TEMPORARY TABLE part_temp;
CREATE TEMPORARY TABLE part_temp(
Partido VARCHAR (200),
Provincia VARCHAR (200));

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/tec_localidad"
INTO TABLE part_temp
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@dummy, Provincia, Partido,@dummy , @dummy, @dummy, @dummy,@dummy, @dummy, @dummy,@dummy, @dummy, @dummy,@dummy);

SELECT * FROM part_temp;

INSERT INTO partidos (Partido, Provincia)
SELECT DISTINCT Partido, Provincia
FROM part_temp;
DROP TEMPORARY TABLE part_temp;

SELECT * FROM partidos; -- falta agregar el Id_Provincia y dropear provincia y modificar CABA a Capital Federal
UPDATE partidos
SET Provincia='Capital Federal' 
WHERE Provincia= 'CABA';

SELECT * FROM provincias;

UPDATE partidos pa
JOIN provincias pr ON pa.Provincia = pr.Provincia
SET pa.Id_Provincia = pr.Id_Provincia;

ALTER TABLE partidos
DROP COLUMN Provincia;

SELECT * FROM partidos; 
SELECT * FROM provincias; -- ambas terminadas


-- tabla localidades
DROP TABLE IF EXISTS localidades;
CREATE TABLE localidades(
Id_Localidad INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
Localidad VARCHAR (200),
Partido  VARCHAR (200),
Id_Partido INT) ;

DROP TEMPORARY TABLE IF EXISTS  loc_temp;
CREATE TEMPORARY TABLE loc_temp(
Localidad VARCHAR (200),
Partido  VARCHAR (200));

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/tec_localidad"
INTO TABLE loc_temp
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@dummy, @dummy, Partido, Localidad , @dummy, @dummy, @dummy,@dummy, @dummy, @dummy,@dummy, @dummy, @dummy,@dummy);
SELECT * FROM loc_temp;

INSERT INTO localidades (Localidad,Partido)
SELECT DISTINCT Localidad,Partido
FROM loc_temp;

DROP temporary TABLE loc_temp;
select * FROM localidades;

UPDATE localidades l
JOIN partidos p USING (Partido)
SET l.Id_Partido=p.Id_Partido;

ALTER TABLE localidades
DROP Partido;

SELECT * FROM localidades; -- localidades terminada

ALTER TABLE partidos -- relaciones 
ADD CONSTRAINT fk_provincia
FOREIGN KEY (Id_Provincia)
REFERENCES provincias(Id_Provincia);

ALTER TABLE localidades -- relaciones 
ADD CONSTRAINT fk_partidos
FOREIGN KEY (Id_Partido)
REFERENCES partidos(Id_Partido);

-- evolucion

DROP TABLE IF EXISTS evolucion_provincia;
CREATE TABLE evolucion_provincia(
Id_Evolucion INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
Anio YEAR,
Trimestre INT,
Provincia VARCHAR (50),
Id_Provincia INT,
Velocidad_Promedio FLOAT,
Tec_Predominante VARCHAR(50),
Id_Tec_Predominante INT,
Penetracion_Poblacion FLOAT,
Penetracion_Hogares FLOAT,
Accesos_Totales FLOAT);

LOAD DATA INFILE "C://ProgramData//MySQL//MySQL Server 8.0//Uploads//velocidad_provincia"
INTO TABLE evolucion_provincia
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@dummy, Anio, Trimestre, Provincia, Velocidad_Promedio);

SELECT * FROM evolucion_provincia;

DROP table aux_carga; -- tabla auxiliar para una carga correcta
CREATE TABLE aux_carga(
Provincia VARCHAR(50),
tec VARCHAR (50));

LOAD DATA INFILE "C://ProgramData//MySQL//MySQL Server 8.0//Uploads//tecnologias"
INTO TABLE aux_carga 
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@dummy, @dummy, @dummy, Provincia,@dummy, @dummy,@dummy, @dummy,@dummy, @dummy,@dummy, @dummy, tec);
SELECT * FROM aux_carga;

UPDATE evolucion_provincia e
JOIN aux_carga a USING (Provincia) -- insertamos valores de tec predominante
SET e.Tec_Predominante=a.tec;

DROP table aux_carga; -- cambiamos sus valores
CREATE TABLE aux_carga(
Id_Carga INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
Provincia VARCHAR(50),
numero FLOAT);


LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\penetracion_poblacion"
INTO TABLE aux_carga 
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@dummy, @dummy, @dummy, Provincia, numero);
SELECT * FROM aux_carga;

UPDATE evolucion_provincia e -- insertamos valores de penetracion poblacion
JOIN aux_carga a ON e.Id_Evolucion=a.Id_carga
SET e.Penetracion_Poblacion=a.numero;
SELECT * FROM evolucion_provincia;

-- vamos por Penetracion_Hogares
TRUNCATE aux_carga;
SELECT * FROM aux_carga;

LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\penetracion_hogares"
INTO TABLE aux_carga 
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@dummy, @dummy, @dummy, Provincia, numero);
SELECT * FROM aux_carga;

UPDATE evolucion_provincia e -- insertamos valores de penetracion hogares
JOIN aux_carga a ON e.Id_Evolucion=a.Id_carga
SET e.Penetracion_Hogares=a.numero;
SELECT * FROM evolucion_provincia;

-- continuamos con accesos totales 
TRUNCATE aux_carga;
SELECT * FROM aux_carga;

LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\tecnologias"
INTO TABLE aux_carga 
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@dummy, @dummy, @dummy, @dummy, @dummy, @dummy,@dummy, @dummy, @dummy,@dummy, @dummy, numero, @dummy);
SELECT * FROM aux_carga;

UPDATE evolucion_provincia e -- insertamos valores de accesos totales
JOIN aux_carga a ON e.Id_Evolucion=a.Id_carga
SET e.Accesos_Totales=a.numero;
SELECT * FROM evolucion_provincia;

-- falta asignar los Id de provincia y tec para dropear las columnas con varchar
UPDATE evolucion_provincia e
JOIN provincias p ON p.Provincia=e.Provincia
SET e.Id_Provincia=p.Id_Provincia;

UPDATE evolucion_provincia e
JOIN tecnologias t ON e.Tec_Predominante=t.tecnologia
SET e.Id_Tec_Predominante=t.Id_Tecnologia; 
-- no funciona, pero por suerte sabemos que solo es un valor, asi que haremos trampa
-- 0 row(s) affected Rows matched: 0  Changed: 0  Warnings: 0

SELECT * FROM aux_carga;
UPDATE aux_carga
SET numero=6;

UPDATE evolucion_provincia e
JOIN aux_carga a  ON e.Id_Evolucion=a.Id_Carga
SET e.Id_Tec_Predominante=a.numero;

SELECT * FROM evolucion_provincia; -- podemos droppear Provincia y Tec_Predominante
ALTER TABLE  evolucion_provincia 
DROP COLUMN Provincia,
DROP COLUMN Tec_Predominante;

ALTER TABLE evolucion_provincia
ADD CONSTRAINT fk_id_provincia
FOREIGN KEY (Id_Provincia) REFERENCES provincias(Id_Provincia);

ALTER TABLE evolucion_provincia
ADD CONSTRAINT fk_tec
FOREIGN KEY (Id_Tec_Predominante) REFERENCES tecnologias(Id_Tecnologia);

-- tabla evolucion_nacional
DROP TABLE IF EXISTS evolucion_nacional;
CREATE TABLE IF NOT EXISTS evolucion_nacional(
Id_Evolucion_Nacional INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
Anio YEAR,
Trimestre INT,
Penetracion_Poblacion FLOAT,
Penetracion_Hogares FLOAT,
Ingresos FLOAT,
Velocidad_Promedio FLOAT);
SELECT * FROM evolucion_nacional;

LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\penetracion_total" -- comenzamos la carga del dataset con mas datos en sus columnas
INTO TABLE evolucion_nacional
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@dummy, Anio, Trimestre, Penetracion_Poblacion, Penetracion_Hogares, @dummy);
SELECT * FROM evolucion_nacional;

TRUNCATE aux_carga;
LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\ingresos" -- cargamos la columna ingresos
INTO TABLE aux_carga
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@dummy,@dummy, @dummy, numero);
SELECT * FROM aux_carga;

UPDATE evolucion_nacional e
JOIN aux_carga a  ON e.Id_Evolucion_Nacional=a.Id_Carga
SET e.Ingresos=a.numero;
SELECT * FROM evolucion_nacional;


TRUNCATE aux_carga;
LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\velocidad_nacional" -- cargamos la columna Velocidad_Promedio
INTO TABLE aux_carga
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@dummy,@dummy, @dummy, numero);
SELECT * FROM aux_carga;

UPDATE evolucion_nacional e
JOIN aux_carga a  ON e.Id_Evolucion_Nacional=a.Id_Carga
SET e.Velocidad_Promedio=a.numero;
SELECT * FROM evolucion_nacional;
-- carga de la tabla evolucion_nacional terminada

DROP TABLE aux_carga;