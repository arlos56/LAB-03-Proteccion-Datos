CREATE TABLE clientes_soporte ( 
    id BIGINT PRIMARY KEY,    
    nombre VARCHAR(120) NOT NULL,
    correo VARCHAR(150) NOT NULL,  
    telefono VARCHAR(20) 
);

INSERT INTO clientes_soporte (id, nombre, correo, telefono)
SELECT id, nombre, correo, telefono FROM clientes;

SELECT * FROM clientes_soporte;

SELECT ciudad, COUNT(*) AS cantidad_clientes 
FROM clientes 
GROUP BY ciudad
ORDER BY cantidad_clientes DESC;

SELECT 
    CASE
        WHEN edad < 18 THEN 'Menor de 18'
        WHEN edad BETWEEN 18 AND 29 THEN '18-29'
        WHEN edad BETWEEN 30 AND 44 THEN '30-44'
        WHEN edad BETWEEN 45 AND 59 THEN '45-59'  
        ELSE '60 o más'
    END AS rango_edad,  
    COUNT(*) AS cantidad 
FROM clientes
GROUP BY 
    CASE
        WHEN edad < 18 THEN 'Menor de 18'
        WHEN edad BETWEEN 18 AND 29 THEN '18-29'
        WHEN edad BETWEEN 30 AND 44 THEN '30-44'
        WHEN edad BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60 o más'    
    END 
ORDER BY rango_edad;

-- 1. Crear el rol sin acceso de inicio de sesión
CREATE ROLE analista NOLOGIN;

-- 2. Crear una vista que exponga únicamente la ciudad y el rango de edad
CREATE VIEW v_analitica_clientes AS 
SELECT ciudad, 
    CASE
        WHEN edad < 18 THEN 'Menor de 18'
        WHEN edad BETWEEN 18 AND 29 THEN '18-29'
        WHEN edad BETWEEN 30 AND 44 THEN '30-44'
        WHEN edad BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60 o más' 
    END AS rango_edad 
FROM clientes;

-- 3. Otorgar permisos solo sobre la vista (y el esquema), nunca sobre la tabla base
GRANT USAGE ON SCHEMA public TO analista;
GRANT SELECT ON v_analitica_clientes TO analista;
-- No ejecutar: GRANT SELECT ON clientes TO analista;

-- 4. Comprobar los privilegios otorgados al rol
SELECT grantee, table_name, privilege_type 
FROM information_schema.role_table_grants
WHERE grantee = 'analista';

SELECT id, nombre, correo, telefono, rfc, edad, ciudad, codigo_postal, fecha_alta FROM clientes WHERE correo = 'ana@example.com';

UPDATE clientes SET correo = 'nuevo-correo@example.com' WHERE id = 1;

SELECT id, nombre, correo FROM clientes WHERE id = 1;

