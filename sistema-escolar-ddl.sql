-- Active: 1721859007655@@192.168.1.1@3306@phpmyadmin

-- DDL -> Creación de la estructura de la BD

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

CREATE TABLE niveles_educativos(
    codigo VARCHAR(5) PRIMARY KEY,
    descripcion VARCHAR(15) NOT NULL UNIQUE
)

CREATE TABLE eventos_especiales(
    numero INT PRIMARY KEY AUTO_INCREMENT,
    concepto VARCHAR(30) NOT NULL,
    fechaProgramada DATE NOT NULL,
    costo FLOAT NOT NULL CHECK (costo >= 0)
)

CREATE TABLE mantenimiento(
    numero INT PRIMARY KEY AUTO_INCREMENT,
    concepto VARCHAR(30) NOT NULL,
    costo FLOAT NOT NULL CHECK (costo > 0)
)

CREATE TABLE ciclos_escolares(
    codigo VARCHAR(5) PRIMARY KEY,
    fechaInicio DATE NOT NULL,
    fechaFin DATE NOT NULL,
    cobroMantenimiento INT NOT NULL,
    FOREIGN KEY (cobroMantenimiento) REFERENCES mantenimiento(numero)
)

CREATE TABLE papeleria(
    numero INT PRIMARY KEY AUTO_INCREMENT,
    concepto VARCHAR(40) NOT NULL,
    costo FLOAT NOT NULL CHECK (costo >= 0),
    ciclo VARCHAR(5) NOT NULL,
    nivel VARCHAR(5) NOT NULL,
    FOREIGN KEY (ciclo) REFERENCES ciclos_escolares(codigo),
    FOREIGN KEY (nivel) REFERENCES niveles_educativos(codigo)
)

CREATE TABLE inscripciones(
    numero INT PRIMARY KEY AUTO_INCREMENT,
    costo FLOAT NOT NULL CHECK (costo >= 0),
    fechaLimite	DATE NOT NULL,
    ciclo VARCHAR(5) NOT NULL,
    nivel VARCHAR(5) NOT NULL,
    FOREIGN KEY (ciclo) REFERENCES ciclos_escolares(codigo),
    FOREIGN KEY (nivel) REFERENCES niveles_educativos(codigo)
)

CREATE TABLE mensualidades(
    numero INT PRIMARY KEY AUTO_INCREMENT,
    costo FLOAT NOT NULL CHECK (costo >= 0),
    ciclo VARCHAR(5) NOT NULL,
    nivel VARCHAR(5) NOT NULL,
    FOREIGN KEY (ciclo) REFERENCES ciclos_escolares(codigo),
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

CREATE TABLE alumnos_inscritos(
    alumno VARCHAR(5),
    nivel VARCHAR(5),
    PRIMARY KEY (alumno, nivel),
    FOREIGN KEY (alumno) REFERENCES alumnos(matricula),
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
    FOREIGN KEY (grupo) REFERENCES grupos(codigo),
    FOREIGN KEY (alumno) REFERENCES alumnos(matricula)
)

CREATE TABLE tutor_telefonos(
    numero INT PRIMARY KEY AUTO_INCREMENT,
    numeroTelefono VARCHAR(15) NOT NULL,
    tutor INT NOT NULL,
    FOREIGN KEY (tutor) REFERENCES tutores(numero)
)

CREATE TABLE empleados(
    numero INT PRIMARY KEY AUTO_INCREMENT,
    nombreUsuario VARCHAR(30) NOT NULL UNIQUE,
    contraseña VARCHAR(16) NOT NULL,
    nombreEmpleado VARCHAR(30) NOT NULL,
    primerApellido VARCHAR(30) NOT NULL,
    segundoApellido VARCHAR(30) NULL,
    supervisor INT NULL
)

ALTER TABLE empleados
    ADD CONSTRAINT FK_empleados_supervisor
    FOREIGN KEY (supervisor) REFERENCES empleados(numero)

CREATE TABLE pagos(
    folio INT PRIMARY KEY AUTO_INCREMENT,
    fecha DATE NOT NULL,
    montoTotal FLOAT NOT NULL,
    alumno VARCHAR(5) NOT NULL,
    tutor INT NOT NULL,
    autoriza INT NOT NULL,
    FOREIGN KEY (alumno) REFERENCES alumnos(matricula),
    FOREIGN KEY (tutor) REFERENCES tutores(numero),
    FOREIGN KEY (autoriza) REFERENCES empleados(numero)
)

CREATE TABLE cobros(
    codigo VARCHAR(7) PRIMARY KEY,
    mensualidad INT NULL,
    mantenimiento INT NULL,
    inscripcion INT NULL,
    papeleria INT NULL,
    uniforme INT NULL,
    eventoEspecial INT NULL,
    FOREIGN KEY (mensualidad) REFERENCES mensualidades(numero),
    FOREIGN KEY (mantenimiento) REFERENCES mantenimiento(numero),
    FOREIGN KEY (inscripcion) REFERENCES inscripciones(numero),
    FOREIGN KEY (papeleria) REFERENCES papeleria(numero),
    FOREIGN KEY (uniforme) REFERENCES uniformes(numero),
    FOREIGN KEY (eventoEspecial) REFERENCES eventos_especiales(numero)
)

CREATE TABLE detalles_pago(
    folio INT AUTO_INCREMENT,
    pago INT,
    cobro VARCHAR(7),
    PRIMARY KEY (folio, pago, cobro),
    FOREIGN KEY (pago) REFERENCES pagos(folio),
    FOREIGN KEY (cobro) REFERENCES cobros(codigo)
)

---
