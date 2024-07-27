-- Active: 1721859007655@@192.168.1.1@3306@SistemaEscolar
CREATE DATABASE SistemaEscolar

USE SistemaEscolar

CREATE TABLE alumnos(
    matricula VARCHAR(5) PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL,
    primerApellido VARCHAR(30) NOT NULL,
    segundoApellido VARCHAR(30) NULL,
    genero VARCHAR(10) NULL,
    edad INT NOT NULL,
    fechaNacimiento DATE NOT NULL,
    domicilioCalle VARCHAR(30) NOT NULL,
    domicilioNumero VARCHAR(20) NOT NULL,
    domicilioColonia VARCHAR(30) NOT NULL,
    domicilioCP VARCHAR(5) NOT NULL,
    curp VARCHAR(20) NOT NULL UNIQUE,
    nss VARCHAR(12) NULL
)

CREATE TABLE tutores(
    numero INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(30) NOT NULL,
    primerApellido VARCHAR(30) NOT NULL,
    segundoApellido VARCHAR(30) NULL,
    correoElectronico VARCHAR(40) NOT NULL,
    rfc VARCHAR(14) NOT NULL UNIQUE,
    parentesco VARCHAR(10) NOT NULL
)

CREATE TABLE ciclos_escolares(
    codigo VARCHAR(5) PRIMARY KEY,
    fechaInicio DATE NOT NULL,
    fechaFin DATE NOT NULL
)

CREATE TABLE niveles_educativos(
    codigo VARCHAR(5) PRIMARY KEY,
    descripcion VARCHAR(15) NOT NULL UNIQUE
)

CREATE TABLE eventos_especiales(
    codigo VARCHAR(5) PRIMARY KEY,
    concepto VARCHAR(30) NOT NULL,
    fechaProgramada DATE NOT NULL,
    costo FLOAT NOT NULL CHECK (costo > 0)
)

CREATE TABLE mantenimiento(
    numero INT PRIMARY KEY AUTO_INCREMENT,
    concepto VARCHAR(30) NOT NULL,
    costo FLOAT NOT NULL CHECK (costo > 0)
)

CREATE TABLE papeleria(
    codigo VARCHAR(8) PRIMARY KEY,
    concepto VARCHAR(40) NOT NULL,
    costo FLOAT NOT NULL CHECK (costo >= 0),
    nivel VARCHAR(5) NOT NULL,
    FOREIGN KEY (nivel) REFERENCES niveles_educativos(codigo)
)

CREATE TABLE inscripciones(
    codigo VARCHAR(5) PRIMARY KEY,
    costo FLOAT NOT NULL CHECK (costo >= 0),
    nivel VARCHAR(5) NOT NULL,
    FOREIGN KEY (nivel) REFERENCES niveles_educativos(codigo)
)

CREATE TABLE mensualidades(
    codigo VARCHAR(5) PRIMARY KEY,
    costo FLOAT NOT NULL CHECK (costo >= 0),
    nivel VARCHAR(5) NOT NULL,
    FOREIGN KEY (nivel) REFERENCES niveles_educativos(codigo)
)

CREATE TABLE tipos_uniforme(
    numero INT PRIMARY KEY AUTO_INCREMENT,
    descripcion VARCHAR(25) NOT NULL
)

CREATE TABLE uniformes(
    numero INT PRIMARY KEY AUTO_INCREMENT,
    concepto VARCHAR(40) NOT NULL,
    talla VARCHAR(5) NOT NULL,
    costo FLOAT NOT NULL CHECK (costo >= 0),
    tipo INT NOT NULL,
    nivel VARCHAR(5) NOT NULL,
    FOREIGN KEY (tipo) REFERENCES tipos_uniforme(numero),
    FOREIGN KEY (nivel) REFERENCES niveles_educativos(codigo)
)

CREATE TABLE tutores_alumnos(
    tutor INT,
    alumno VARCHAR(5),
    PRIMARY KEY (tutor, alumno),
    FOREIGN KEY (alumno) REFERENCES alumnos(matricula),
    FOREIGN KEY (tutor) REFERENCES tutores(numero)
)

CREATE TABLE grupos(
    numero INT PRIMARY KEY AUTO_INCREMENT,
    grado INT NOT NULL,
    letra CHAR(1) NOT NULL,
    nivel VARCHAR(5) NOT NULL,
    ciclo VARCHAR(5) NOT NULL,
    FOREIGN KEY (ciclo) REFERENCES ciclos_escolares(codigo),
    FOREIGN KEY (nivel) REFERENCES niveles_educativos(codigo)
)

CREATE TABLE grupos_alumnos(
    grupo INT,
    alumno VARCHAR(5),
    PRIMARY KEY (grupo, alumno),
    FOREIGN KEY (grupo) REFERENCES grupos(numero),
    FOREIGN KEY (alumno) REFERENCES alumnos(matricula)
)

CREATE TABLE tutor_telefonos(
    numero INT PRIMARY KEY AUTO_INCREMENT,
    numeroTelefono VARCHAR(15) NOT NULL,
    tutor INT NOT NULL,
    FOREIGN KEY (tutor) REFERENCES tutores(numero)
)

CREATE TABLE pagos(
    folio INT PRIMARY KEY AUTO_INCREMENT,
    fecha DATE NOT NULL,
    montoTotal FLOAT NOT NULL,
    alumno VARCHAR(5) NOT NULL,
    tutor INT NOT NULL,
    FOREIGN KEY (alumno) REFERENCES alumnos(matricula),
    FOREIGN KEY (tutor) REFERENCES tutores(numero)
)

CREATE TABLE cobros(
    codigo VARCHAR(11) PRIMARY KEY,
    ciclo VARCHAR(5) NOT NULL,
    mensualidad VARCHAR(5) NULL,
    mantenimiento INT NULL,
    inscripcion VARCHAR(5) NULL,
    papeleria VARCHAR(8) NULL,
    uniforme INT NULL,
    eventoEspecial VARCHAR(5) NULL,
    FOREIGN KEY (ciclo) REFERENCES ciclos_escolares(codigo),
    FOREIGN KEY (mensualidad) REFERENCES mensualidades(codigo),
    FOREIGN KEY (mantenimiento) REFERENCES mantenimiento(numero),
    FOREIGN KEY (inscripcion) REFERENCES inscripciones(codigo),
    FOREIGN KEY (papeleria) REFERENCES papeleria(codigo),
    FOREIGN KEY (uniforme) REFERENCES uniformes(numero),
    FOREIGN KEY (eventoEspecial) REFERENCES eventos_especiales(codigo)
)

CREATE TABLE detalles_pago(
    folioPago INT,
    codigoCobro VARCHAR(11),
    PRIMARY KEY (folioPago, codigoCobro),
    FOREIGN KEY (folioPago) REFERENCES pagos(folio),
    FOREIGN KEY (codigoCobro) REFERENCES cobros(codigo)
)

---
