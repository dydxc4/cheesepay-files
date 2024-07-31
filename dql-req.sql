-- CONSULTAS REQUERIDAS EN EL DOCUMENTO PUBLICADO POR LA PROFESORA

USE SistemaEscolar

-- 5. Mensualidades pagadas de un alumno en un periodo escolar
-- Datos:
--   a. Matricula del alumno
--   b. Nombre del alumno
--   c. Fecha de inicio del periodo escolar
--   d. Fecha final del periodo escolar
--   e. Grado
--   f. Nivel
--   g. Mes pagado
--   h. Fecha de pago

SELECT
    a.matricula AS matricula,
    CONCAT(a.nombre, ' ', a.primerApellido, ' ', IFNULL(a.segundoApellido, '')) AS nombre,
    m.mes AS mesPagado,
    ga.grado AS grado,
    p.fecha AS fechaPago,
    ga.nivel AS nivel,
    ga.fechaInicio AS fechaInicio,
    ga.fechaFin AS fechaFin
FROM alumnos AS a
INNER JOIN pagos AS p ON a.matricula = p.alumno
INNER JOIN detalles_pago AS dp ON p.folio = dp.folioPago
INNER JOIN cobros AS c ON dp.codigoCobro = c.codigo
INNER JOIN mensualidades AS m ON m.codigo = c.mensualidad
INNER JOIN (
    SELECT
        _a.matricula AS matricula,
        _g.grado AS grado,
        _ne.descripcion AS nivel,
        _ce.fechaInicio AS fechaInicio,
        _ce.fechaFin AS fechaFin
    FROM alumnos AS _a
    INNER JOIN grupos_alumnos AS _ga ON _a.matricula = _ga.alumno
    INNER JOIN grupos AS _g ON _ga.grupo = _g.numero
    INNER JOIN niveles_educativos AS _ne ON _g.nivel = _ne.codigo
    INNER JOIN ciclos_escolares AS _ce ON _g.ciclo = _ce.codigo
    WHERE _g.ciclo = '02122'
) AS ga ON a.matricula = ga.matricula
WHERE a.matricula = '00080' AND c.ciclo = '02122'

-- 10. Total de pagos realizados para un nivel educativo en un periodo escolar
-- Datos:
--   a. Fecha de inicio del periodo escolar
--   b. Fecha final del periodo escolar
--   c. Nivel escolar
--   d. Total de pagos
-- NOTA: 4437 pagos esperados

SELECT
    n.descripcion AS nivelEscolar,
    SUM(t.cantidad) AS totalDePagos,
    cse.fechaInicio AS fechaInicio,
    cse.fechaFin AS fechaFin
FROM niveles_educativos AS n
INNER JOIN (
    SELECT
        ne.codigo AS nivel,
        ce.codigo AS ciclo,
        COUNT(dp.folioPago) AS cantidad
    FROM detalles_pago AS dp
    INNER JOIN cobros AS c ON dp.codigoCobro = c.codigo
    INNER JOIN inscripciones AS i ON c.inscripcion = i.codigo
    INNER JOIN niveles_educativos AS ne ON i.nivel = ne.codigo
    INNER JOIN ciclos_escolares AS ce ON ce.codigo = c.ciclo
    GROUP BY ne.codigo, ce.codigo
    UNION ALL
    SELECT
        ne.codigo AS nivel,
        ce.codigo AS ciclo,
        COUNT(dp.folioPago) AS cantidad
    FROM detalles_pago AS dp
    INNER JOIN cobros AS c ON dp.codigoCobro = c.codigo
    INNER JOIN mensualidades AS m ON c.mensualidad = m.codigo
    INNER JOIN niveles_educativos AS ne ON m.nivel = ne.codigo
    INNER JOIN ciclos_escolares AS ce ON ce.codigo = c.ciclo
    GROUP BY ne.codigo, ce.codigo
    UNION ALL
    SELECT
        ne.codigo AS nivel,
        ce.codigo AS ciclo,
        COUNT(dp.folioPago) AS cantidad
    FROM detalles_pago AS dp
    INNER JOIN cobros AS c ON dp.codigoCobro = c.codigo
    INNER JOIN uniformes AS u ON c.uniforme = u.codigo
    INNER JOIN niveles_educativos AS ne ON u.nivel = ne.codigo
    INNER JOIN ciclos_escolares AS ce ON ce.codigo = c.ciclo
    GROUP BY ne.codigo, ce.codigo
    UNION ALL
    SELECT
        ne.codigo AS nivel,
        ce.codigo AS ciclo,
        COUNT(dp.folioPago) AS cantidad
    FROM detalles_pago AS dp
    INNER JOIN cobros AS c ON dp.codigoCobro = c.codigo
    INNER JOIN papeleria AS pa ON c.papeleria = pa.codigo
    INNER JOIN niveles_educativos AS ne ON pa.nivel = ne.codigo
    INNER JOIN ciclos_escolares AS ce ON ce.codigo = c.ciclo
    GROUP BY ne.codigo, ce.codigo
) AS t ON n.codigo = t.nivel
INNER JOIN ciclos_escolares AS cse ON t.ciclo = cse.codigo
GROUP BY n.codigo, cse.codigo
