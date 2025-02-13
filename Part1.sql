-- Crear la base de dades si no existeix
CREATE DATABASE IF NOT EXISTS LSG_NBA
CHARACTER SET utf8mb4
COLLATE utf8mb4_spanish_ci;

-- Usar la base de dades
USE LSG_NBA;

-- Crear la taula PERSONA
CREATE TABLE PERSONA (
    DNI CHAR(9) PRIMARY KEY,
    Nom VARCHAR(30) NOT NULL,
    Cognom1 VARCHAR(30) NOT NULL,
    Cognom2 VARCHAR(30) NOT NULL,
    Nacionalitat VARCHAR(30) NOT NULL,
    Sexe ENUM('H', 'D', 'NB', 'ND') NOT NULL,
    DataNaixement DATE NOT NULL
);

-- Crear la taula EQUIP_NACIONAL
CREATE TABLE EQUIP_NACIONAL (
    Any INT(4),
    Pais VARCHAR(30),
    PRIMARY KEY (Any, Pais)
);

-- Crear la taula JUGADOR
CREATE TABLE JUGADOR (
    DNI CHAR(9) PRIMARY KEY,
    AnysPRO INT(4),
    UniversitatOrigen VARCHAR(30),
    NombreAnellsNBA INT,
    Dorsal INT,
    NomFranquicia VARCHAR(30),
    FOREIGN KEY (DNI) REFERENCES PERSONA(DNI) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (NomFranquicia) REFERENCES FRANQUICIA(Nom) ON DELETE RESTRICT ON UPDATE RESTRICT
);

-- Crear la taula FRANQUICIA
CREATE TABLE FRANQUICIA (
    Nom VARCHAR(30) PRIMARY KEY,
    Ciutat VARCHAR(30),
    Pressupost DECIMAL(10,2),
    AnellsNBA INT,
    DNIEntrenadorPrincipal CHAR(9),
    NomPavello VARCHAR(30),
    DNIPropietari CHAR(9),
    NomConferencia VARCHAR(30),
    FOREIGN KEY (DNIEntrenadorPrincipal) REFERENCES ENTRENADOR_PRINCIPAL(DNI) ON DELETE RESTRICT ON UPDATE RESTRICT,
    FOREIGN KEY (NomPavello) REFERENCES PAVELLO(Nom) ON DELETE RESTRICT ON UPDATE RESTRICT,
    FOREIGN KEY (DNIPropietari) REFERENCES PERSONA(DNI) ON DELETE RESTRICT ON UPDATE RESTRICT,
    FOREIGN KEY (NomConferencia) REFERENCES CONFERENCIA(Nom) ON DELETE RESTRICT ON UPDATE RESTRICT
);

-- Crear la taula CONFERENCIA
CREATE TABLE CONFERENCIA (
    Nom VARCHAR(30) PRIMARY KEY,
    ZonaGeografica VARCHAR(30) UNIQUE NOT NULL
);

-- Crear la taula FRANQUICIA_TEMPORADA
CREATE TABLE FRANQUICIA_TEMPORADA (
    NomFranquicia VARCHAR(30),
    AnyTemporada INT(4),
    EsGuanyador BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (NomFranquicia, AnyTemporada),
    FOREIGN KEY (NomFranquicia) REFERENCES FRANQUICIA(Nom) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (AnyTemporada) REFERENCES TEMPORADA_REGULAR(Any) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Crear la taula TEMPORADA_REGULAR
CREATE TABLE TEMPORADA_REGULAR (
    Any INT(4) PRIMARY KEY,
    Inici DATE,
    Fi DATE
);

-- Crear la taula PAVELLO
CREATE TABLE PAVELLO (
    Nom VARCHAR(30) PRIMARY KEY,
    Ciutat VARCHAR(30),
    Capacitat INT
);

-- Crear la taula GRADA
CREATE TABLE GRADA (
    NomPavello VARCHAR(30),
    Codi INT UNSIGNED AUTO_INCREMENT,
    EsCoberta BOOLEAN,
    PRIMARY KEY (NomPavello, Codi),
    FOREIGN KEY (NomPavello) REFERENCES PAVELLO(Nom) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Crear la taula SEIENT
CREATE TABLE SEIENT (
    NomPavello VARCHAR(30),
    Codi INT UNSIGNED,
    Numero INT UNSIGNED AUTO_INCREMENT,
    Color VARCHAR(30),
    PRIMARY KEY (NomPavello, Codi, Numero),
    FOREIGN KEY (NomPavello, Codi) REFERENCES GRADA(NomPavello, Codi) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Crear la taula DRAFT
CREATE TABLE DRAFT (
    Any INT(4) PRIMARY KEY
);

-- Crear la taula DRAFT_JUGADOR_FRANQUICIA
CREATE TABLE DRAFT_JUGADOR_FRANQUICIA (
    AnyDRAFT INT(4),
    DNIJugador CHAR(9),
    NomFranquicia VARCHAR(30),
    Posicio VARCHAR(30),
    PRIMARY KEY (AnyDRAFT, DNIJugador, NomFranquicia),
    FOREIGN KEY (AnyDRAFT) REFERENCES DRAFT(Any) ON DELETE RESTRICT ON UPDATE RESTRICT,
    FOREIGN KEY (DNIJugador) REFERENCES JUGADOR(DNI) ON DELETE RESTRICT ON UPDATE RESTRICT,
    FOREIGN KEY (NomFranquicia) REFERENCES FRANQUICIA(Nom) ON DELETE RESTRICT ON UPDATE RESTRICT
);
