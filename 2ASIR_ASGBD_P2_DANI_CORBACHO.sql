-- Batería de Consultas 1:

-- 1. Muestra el nombre y el precio de aquellos artículos que sean, exactamente, el
-- artículo más caro de su respectivo fabricante.

SELECT a.nombre, a.precio
FROM articulos a
WHERE a.precio = (
    SELECT MAX(precio)
    FROM articulos
    WHERE fabricante_id = a.fabricante_id
);

-- 2. Muestra el nombre de los fabricantes que no tienen ningún artículo con un precio
-- inferior o igual a la media general de precios de toda la tienda.

SELECT nombre
FROM fabricantes
WHERE id NOT IN (
    SELECT fabricante_id
    FROM articulos
    WHERE precio <= (SELECT AVG(precio) FROM articulos)
);


-- 3. Muestra la descripción y el coste de aquellas reparaciones cuyo coste sea
-- estrictamente superior a la media de las reparaciones realizadas por su propio
-- técnico.

SELECT r.descripcion_averia, r.coste_reparacion
FROM reparaciones r
WHERE r.coste_reparacion > (
    SELECT AVG(coste_reparacion)
    FROM reparaciones
    WHERE tecnico_id = r.tecnico_id
);


-- 4. Muestra el identificador y la especialidad de los técnicos cuya suma total del coste de
-- las reparaciones que han realizado supere el doble de su propio salario.

SELECT t.id, t.especialidad
FROM tecnicos t
WHERE (
    SELECT SUM(coste_reparacion)
    FROM reparaciones
    WHERE tecnico_id = t.id
) > (2 * t.salario);


-- 5. Muestra el nombre del fabricante (o fabricantes) que posee el mayor número de
-- artículos registrados en la base de datos.

SELECT nombre
FROM fabricantes
WHERE id IN (
    SELECT fabricante_id
    FROM articulos
    GROUP BY fabricante_id
    HAVING COUNT(*) = (
        SELECT MAX(total_articulos)
        FROM (
            SELECT COUNT(*)
            FROM articulos
            GROUP BY fabricante_id
        )
    )
);


-- 6. Muestra el nombre de los técnicos que han realizado alguna reparación, pero que
-- nunca han realizado ninguna reparación cuyo coste haya superado los 100.00 euros.

SELECT nombre
FROM tecnicos
WHERE id IN (SELECT tecnico_id FROM reparaciones)
  AND id NOT IN (
      SELECT tecnico_id
      FROM reparaciones
      WHERE coste_reparacion > 100.00
  );


-- 7. Muestra el nombre y el salario de los técnicos cuyo salario sea inferior a la media
-- salarial de su propia especialidad.

SELECT t.nombre, t.salario
FROM tecnicos t
WHERE t.salario < (
    SELECT AVG(salario)
    FROM tecnicos
    WHERE especialidad = t.especialidad
);


-- 8. Muestra el nombre de los fabricantes cuyo país coincide con el país del fabricante
-- que produce el artículo más caro de toda la tienda.




-- 9. Muestra el nombre y el precio del artículo más barato de entre todos los fabricantes
-- que son originarios de 'Estados Unidos'.




-- 10. Muestra el identificador del técnico (tecnico_id) que ha acumulado el mayor
-- coste total en reparaciones.



-- Batería de Consultas 2:


-- 1. Muestra el nombre de cada artículo junto con el nombre de su fabricante, pero
-- únicamente para aquellos artículos cuyo precio sea superior a 100.00 euros.

SELECT a.nombre as articulos, f.nombre as fabricante
FROM articulos a
JOIN fabricantes f ON a.fabricante_id = f.id
WHERE a.precio > 100.00 ;



-- 2. Muestra el nombre de todos los fabricantes de la base de datos y, al lado, el nombre
-- de sus artículos. Asegúrate de que aparezcan los fabricantes que no tienen ningún
-- artículo registrado.

SELECT f.nombre as fabricante, a.nombre as articulos
FROM fabricantes f 
JOIN articulos a ON f.id = a.fabricante_id;



-- 3. Muestra el nombre del fabricante y la media de los precios de sus artículos, pero solo
-- para aquellos fabricantes cuya media de precios supere los 150.00 euros.

SELECT f.nombre, AVG(a.precio) as precio_medio
FROM fabricantes f
JOIN articulos a ON f.id = a.fabricante_id
GROUP BY f.nombre, f.id 
HAVING AVG(precio) > 150.00;



-- 4. Muestra la descripción de la avería, el coste de la reparación y el nombre del técnico
-- que la ha llevado a cabo, ordenado por el coste de mayor a menor.

SELECT r.descripcion_averia, r.coste_reparacion, t.nombre
FROM reparaciones r 
JOIN tecnicos t ON r.tecnico_id = t.id
ORDER BY coste_reparacion ASC;



-- 5. Muestra el nombre de aquellos técnicos que no han realizado ninguna reparación,
-- utilizando obligatoriamente un cruce externo de tablas.

SELECT t.nombre
FROM tecnicos t
LEFT JOIN reparaciones r ON t.id = r.tecnico_id
WHERE r.id;


-- 6. Muestra el nombre del técnico y la suma total del dinero recaudado con sus
-- reparaciones, filtrando únicamente aquellos técnicos cuya recaudación total supere
-- los 100.00 euros.

SELECT t.nombre AS tecnico, SUM(r.coste_reparacion)
FROM tecnicos t
JOIN reparaciones r ON t.id = r.tecnico_id
GROUP BY t.id, t.nombre
HAVING SUM(r.coste_reparacion) > 100.00;


-- 7. Muestra el nombre de los artículos y el nombre de su respectivo fabricante, pero
-- filtrando exclusivamente aquellos artículos cuyos fabricantes sean originarios de
-- 'Estados Unidos' o 'Taiwán' .

SELECT a.nombre AS articulo, f.nombre
FROM articulos a
JOIN fabricantes f ON a.fabricante_id = f.id
WHERE f.pais IN ('Estados Unidos', 'Taiwán');


-- 8. Muestra el nombre de todos los técnicos y, al lado, el número total de reparaciones
-- que ha realizado cada uno de ellos.

SELECT t.nombre AS tecnico, COUNT(r.id)
FROM tecnicos t
LEFT JOIN reparaciones r ON t.id = r.tecnico_id
GROUP BY t.id, t.nombre;


-- 9. Muestra el nombre del fabricante y el número total de artículos que produce, pero
-- solo de aquellos fabricantes que tengan un número de artículos mayor o igual a 2.

SELECT f.nombre AS fabricante, COUNT(a.id)
FROM fabricantes f
JOIN articulos a ON f.id = a.fabricante_id
GROUP BY f.id, f.nombre
HAVING COUNT(a.id) >= 2;


-- 10. Muestra el nombre del técnico, su especialidad y la descripción de la reparación más
-- costosa que ha realizado cada uno de ellos.

SELECT t.nombre, t.especialidad, r.descripcion_averia
FROM tecnicos t
JOIN reparaciones r ON t.id = r.tecnico_id
WHERE r.coste_reparacion = (
    SELECT MAX(coste_reparacion)
    FROM reparaciones
    WHERE tecnico_id = t.id
);