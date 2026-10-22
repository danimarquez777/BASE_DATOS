
-- CREO LA BASE DE DATOS

CREATE DATABASE Tienda_Informatica_y_reparaciones

-- CREO TABLA DE FABRICANTES
CREATE TABLE fabricantes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    pais VARCHAR(100) NOT NULL
);

-- 2. Tabla: articulos
CREATE TABLE articulos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    fabricante_id INT NOT NULL,
    FOREIGN KEY (fabricante_id) REFERENCES fabricantes(id)
);

-- 3. Tabla: tecnicos
CREATE TABLE tecnicos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    especialidad VARCHAR(100) NOT NULL,
    salario DECIMAL(10, 2) NOT NULL
);

-- 4. Tabla: reparaciones
CREATE TABLE reparaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    descripcion_averia VARCHAR(255) NOT NULL,
    coste_reparacion DECIMAL(10, 2) NOT NULL,
    tecnico_id INT NOT NULL,
    FOREIGN KEY (tecnico_id) REFERENCES tecnicos(id)
);


--INSERCCION DE DATOS A CADA TABLA

INSERT INTO fabricantes (id, nombre, pais) VALUES
(1, 'Kingston', 'Estados Unidos'),
(2, 'Asus', 'Taiwán'),
(3, 'Samsung', 'Corea del Sur'),
(4, 'Logitech', 'Suiza'),
(5, 'Intel', 'Estados Unidos');

INSERT INTO articulos (id, nombre, precio, fabricante_id) VALUES
(1, 'Memoria RAM 16GB DDR4', 45.50, 1),
(2, 'SSD NVMe 1TB', 79.99, 1),
(3, 'Placa Base ROG Strix', 185.00, 2),
(4, 'Monitor 27" IPS 144Hz', 249.00, 2),
(5, 'Monitor 32" Curved', 320.00, 3),
(6, 'Ratón Óptico Inalámbrico', 29.99, 4),
(7, 'Teclado Mecánico RGB', 89.90, 4),
(8, 'Procesador Core i7', 310.00, 5);

INSERT INTO tecnicos (id, nombre, especialidad, salario) VALUES
(1, 'Carlos Pérez', 'Hardware', 1800.00),
(2, 'Ana Gómez', 'Redes y Servidores', 2100.00),
(3, 'Luis Martínez', 'Portátiles', 1650.00),
(4, 'Marta Ruiz', 'Movilidad y Tablets', 1750.00);


INSERT INTO reparaciones (id, descripcion_averia, coste_reparacion, tecnico_id) VALUES
(1, 'Sustitución de pantalla rota', 120.50, 3),
(2, 'Cambio de fuente de alimentación', 65.00, 1),
(3, 'Recuperación de datos en disco dañado', 150.00, 2),
(4, 'Limpieza interna y cambio de pasta térmica', 45.00, 1),
(5, 'Sustitución de conector de carga', 50.00, 3),
(6, 'Ampliación de RAM y formateo', 80.00, 4);


-- PARTE 2: BATERÍA DE CONSULTAS


-- Consulta 1: Nombre y precio de todos los artículos ordenados descendentemente por precio.
SELECT nombre, precio 
FROM articulos 
ORDER BY precio DESC;

-- Consulta 2: Nombres de los fabricantes cuyo país sea "Estados Unidos".
SELECT nombre 
FROM fabricantes 
WHERE pais = 'Estados Unidos';

-- Consulta 3: Todos los datos de aquellos artículos cuyo precio esté entre 100 y 300 (incluidos).
SELECT * 
FROM articulos 
WHERE precio BETWEEN 100 AND 300;

-- Consulta 4: Precio medio de todos los artículos.
SELECT AVG(precio) AS precio_medio 
FROM articulos;

-- Consulta 5: Identificador del fabricante y número de artículos que tiene cada uno.
SELECT fabricante_id, COUNT(*) AS num_articulos 
FROM articulos 
GROUP BY fabricante_id;

-- Consulta 6: tecnico_id que han realizado más de una reparación.
SELECT tecnico_id 
FROM reparaciones 
GROUP BY tecnico_id 
HAVING COUNT(*) > 1;

-- Consulta 7: Nombre y precio de los artículos fabricados por empresas de 'Taiwán'.
SELECT nombre, precio 
FROM articulos 
WHERE fabricante_id IN (
    SELECT id 
    FROM fabricantes 
    WHERE pais = 'Taiwán'
);

-- Consulta 8: Descripción y coste de la reparación más cara registrada.
SELECT descripcion_averia, coste_reparacion 
FROM reparaciones 
WHERE coste_reparacion = (
    SELECT MAX(coste_reparacion) 
    FROM reparaciones
);

-- Consulta 9: Nombre de los técnicos e importe resultante de aplicar un 10% de subida a su salario.
SELECT nombre, ROUND(salario * 1.10, 2) AS salario_con_aumento 
FROM tecnicos;

-- Consulta 10: Nombre de los técnicos que no han realizado ninguna reparación.
SELECT nombre 
FROM tecnicos 
WHERE id NOT IN (
    SELECT tecnico_id 
    FROM reparaciones
);