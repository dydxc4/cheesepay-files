USE SistemaEscolar

SELECT 
    a.matricula,
    g.grado,
    g.nivel,
    g.ciclo,
    c.`fechaInicio`,
    c.`fechaFin`
FROM alumnos AS a
INNER JOIN grupos_alumnos AS ga ON a.matricula = ga.alumno
INNER JOIN grupos AS g ON ga.grupo = g.numero
INNER JOIN ciclos_escolares AS c ON g.ciclo = c.codigo
WHERE a.matricula = '00001'
