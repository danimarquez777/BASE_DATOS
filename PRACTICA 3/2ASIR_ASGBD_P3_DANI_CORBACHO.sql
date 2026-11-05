

-- Tarea 1: Creación de usuarios y políticas de conexión y caducidad

-- 1.1 Creación de cuentas base: 

CREATE USER 'gestor_tienda'@'localhost' IDENTIFIED BY 'Admin2026!';

CREATE USER 'auditor_externo'@'%' IDENTIFIED BY 'Externo2026?';

-- HE PUESTO ESTAS CONTRASEÑAS PORQUE SIGUEN UN PATRON DE 1 MAYUSCULAS, NUMEROS Y ALGUN SIMBOLO, 
-- ES UNA CONTRASEÑA SEGURA.

-- 1.2 Directiva de caducidad de credenciales: 

ALTER USER 'auditor_externo'@'%' PASSWORD EXPIRE INTERVAL 30 DAY;

/* OBLIGAMOS AL USUARIO A CAMBIAR LA CONTRASEÑA PASADOS 30 DIAS PARA EVITAR VULNERABILIDAD EN SU CUENTA. */

-- 1.3 Directiva de control de sesión:

SET GLOBAL wait_timeout = 3600;

/* Forzamos al usuario volverse a logear al cabo de 1h. */

-- Tarea 2: Creación y asignación de roles


-- Definición de rol operativo: 

CREATE ROLE 'rol_consultor';

/* Creamos rol de consultor */

-- Concesión de privilegios al rol:

GRANT SELECT ON tienda_de_informatica.* TO 'rol_consultor';

/* Damos permisos de lectura en la base de datos de tienda de informatica al rol consultor */

-- Asignación y rol por defecto:

GRANT 'rol_consultor' TO 'auditor_externo'@'%';


/* Asigno rol al usuario y le establezco el rol por defecto a dicho usuario */

-- Tarea 3: Seguridad mediante Vistas y Privilegios Granulares

-- Creación de la vista de enmascaramiento: 

CREATE VIEW v_tecnicos_activos as
SELECT id, nombre, especialidad
FROM tecnicos;

-- Privilegio granular:

GRANT SELECT ON tienda_de_informatica.v_tecnicos_activos TO 'gestor_tienda'@'localhost';

/* Damos permiso de la vista al usuario gestor_tienda. */

-- Prueba de denegación:

SELECT *
FROM tecnicos

/* Probamos si podemos hacer un select a la tabla tecnicos. */


-- Tarea 4: Consistencia y control con WITH CHECK OPTION


-- Vista con restricción de dominio:

CREATE VIEW v_articulos_gama_baja as
SELECT id, nombre, precio
FROM articulos
WHERE precio <= 50.00
WITH CHECK OPTION;


-- Demostración técnica:

INSERT INTO v_articulos_gama_baja (id, nombre, precio) VALUES (101, 'raton', 75.00);

/* Insertamos un articulo a la vista para comprobar si realmente nos deja introducirlo. */