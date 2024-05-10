//Camilo Andres Mañosca Burbano
Angie Michel Cardenas Belalcazar// 

--PUNTO 1 
SELECT ubicacion.nombre AS ubicacion, COUNT(extintores.id) AS cantidad_extintores
FROM ubicaciones 
LEFT JOIN ubicacion  ON ubicacion.id = extintores.idubicacion
GROUP BY ubicacion.id;

--PUNTO 2
SELECT tipo.nombre AS tipo_extintor, SUM(extintores.capacidad) AS suma_capacidades
FROM tipos 
LEFT JOIN extintores  ON tipo.id = extintores.idtipo
GROUP BY tipo.id;

--PUNTO 3
SELECT tipo.nombre AS tipo_extintor, MAX(extintor.fechafabricacion) AS fecha_fabricacion_reciente
FROM tipos 
LEFT JOIN extintores ON tipo.id = extintor.idtipo
GROUP BY tipo.id;

--PUNTO 4
SELECT idextintor, COUNT(id) AS numero_inspecciones
FROM inspecciones
GROUP BY idextintor;

--PUNTO 5
SELECT proveedor.nombre AS proveedor, SUM(extintor.capacidad) AS suma_capacidades
FROM proveedores 
LEFT JOIN extintores  ON proveedor.id = extintor.idproveedor
WHERE extintor.fechafabricacion BETWEEN 'fecha_inicio' AND 'fecha_fin'
GROUP BY proveedor.id;

--PUNTO 6
SELECT COUNT(r.id) AS cantidad_recargas
FROM recargas AS r
JOIN extintores AS e ON r.idextintor = e.id
JOIN ubicaciones AS u ON e.idubicacion = u.id
JOIN tipos AS t ON e.idtipo = t.id
WHERE u.nombre LIKE 'sala%' AND t.nombre = 'TipoEspecifico';

--PUNTO 7
SELECT COUNT(r.id) AS cantidad_recargas
FROM recargas AS r
JOIN (
    SELECT idextintor, MAX(fecha) AS ultima_inspeccion
    FROM inspecciones
    GROUP BY idextintor
) AS ultimas_inspecciones ON r.idextintor = ultimas_inspecciones.idextintor
JOIN extintores AS e ON r.idextintor = e.id
WHERE ultimas_inspecciones.ultima_inspeccion <= DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH);

--PUNTO 8
SELECT COUNT(i.id) AS cantidad_inspecciones
FROM inspecciones AS i
JOIN (
    SELECT idextintor
    FROM recargas
    WHERE fecha >= DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR)
    GROUP BY idextintor
    HAVING COUNT(idextintor) >= 2
) AS extintores_con_recargas ON i.idextintor = extintores_con_recargas.idextintor;

-- PUNTO 9
SELECT AVG(e.capacidad) AS promedio_capacidades
FROM extintores AS e
JOIN (
    SELECT idextintor
    FROM recargas
    GROUP BY idextintor
    HAVING COUNT(idextintor) > 3
) AS extintores_con_mas_de_tres_recargas ON e.id = extintores_con_mas_de_tres_recargas.idextintor;

--PUNTO 10
SELECT COUNT(r.id) AS cantidad_recargas
FROM recargas AS r
JOIN (
    SELECT idextintor, MAX(fecha) AS ultima_inspeccion
    FROM inspecciones
    GROUP BY idextintor
) AS ultimas_inspecciones ON r.idextintor = ultimas_inspecciones.idextintor
WHERE ultimas_inspecciones.ultima_inspeccion BETWEEN 'fecha_inicial' AND 'fecha_final';