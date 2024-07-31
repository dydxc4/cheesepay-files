-- CONSULTAS REQUERIDAS POR EL PROGRAMA

-- Obtiene una lista de alumnos cuyos datos contienen una cadena de texto
SELECT *
FROM alumnos
WHERE 
    nombre LIKE '%Helena%' or 
    primerApellido LIKE '%Helena%' or 
    curp LIKE '%Helena%'

-- Obtiene una lista de tutores cuyos datos contiene una cadena de texto
select 
    t.numero as numero,
    t.nombre AS nombre,
    t.primerApellido AS primerApellido,
    t.segundoApellido AS segundoApellido,
    t.parentesco AS parentesco,
    t.correoElectronico AS correoElectronico,
    t.rfc AS rfc
FROM tutores AS t
INNER JOIN tutor_telefonos AS tt ON t.numero = tt.tutor
WHERE 
    t.rfc LIKE '%MOAD890519FBN%' OR
    t.nombre LIKE '%MOAD890519FBN%' OR
    t.primerApellido LIKE '%MOAD890519FBN%' OR
    t.correoElectronico LIKE '%MOAD890519FBN%' OR
    tt.numeroTelefono LIKE '%MOAD890519FBN%'
GROUP BY t.numero

-- Obtiene una lista de los tutores responsables de un alumno
SELECT 
    t.numero AS numero,
    t.nombre AS nombre,
    t.primerApellido AS primerApellido,
    t.segundoApellido AS segundoApellido,
    t.parentesco AS parentesco,
    t.correoElectronico AS correoElectronico,
    t.rfc AS rfc
FROM tutores AS t
INNER JOIN tutores_alumnos AS ta ON ta.tutor = t.numero
INNER JOIN alumnos AS a ON ta.alumno = a.matricula
where a.matricula = '00025'

-- Obtiene una lista de los números de telefono que un tutor tiene registrados
SELECT 
    t.numero AS tutor,
    tt.numeroTelefono AS numeroTelefono
FROM tutores AS t
INNER JOIN tutor_telefonos AS tt ON tt.tutor = t.numero
WHERE t.numero = 1

-- Obtener una lista de los grupos en los que un alumno ha estado inscrito
SELECT 
    g.numero AS numero,
    g.grado AS grado,
    g.letra AS grupo,
    ce.codigo AS ciclo,
    ce.fechaInicio AS fechaInicio,
    ce.fechaFin AS fechaFin,
    ne.codigo AS nivel,
    ne.descripcion AS descripcion
FROM grupos AS g
INNER JOIN ciclos_escolares AS ce ON g.ciclo = ce.codigo
INNER JOIN grupos_alumnos AS ga ON g.numero = ga.grupo
INNER JOIN alumnos AS a ON ga.alumno = a.matricula
INNER JOIN niveles_educativos AS ne ON g.nivel = ne.codigo
WHERE a.matricula = 00127

-- Consultar los pagos que un alumno ha realizado por ciclo escolar
-- Datos: 
-- folio, 
-- fecha, 
-- numero de tutor,
-- nombre del tutor,
-- periodo escolar, 
-- monto total
-- cantidad de cobros en el pago.
SELECT
p.folio AS folio,
p.fecha AS fecha,
p.montoTotal AS montoTotal,
ce.codigo AS ciclo,
ce.fechaInicio AS fechaInicio,
ce.fechaFin AS fechaFin,
t.numero AS numeroTutor,
t.nombre AS nombreTutor,
t.primerApellido AS primerApellido,
t.segundoApellido AS segundoApellido
FROM pagos AS p
INNER JOIN alumnos AS a ON p.alumno = a.matricula
INNER JOIN detalles_pago AS dp ON p.folio = dp.folioPago
INNER JOIN cobros AS c ON dp.codigoCobro = c.codigo
INNER JOIN ciclos_escolares AS ce ON c.ciclo = ce.codigo
INNER JOIN tutores AS t ON p.tutor = t.numero
WHERE a.matricula = '00127'
GROUP BY p.folio
