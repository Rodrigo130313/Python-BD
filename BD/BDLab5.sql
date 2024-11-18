-- Crear la base de datos y usarla


-- Crear el esquema
CREATE SCHEMA IF NOT EXISTS BIBLIOTECA;
USE BIBLIOTECA;
-- Crear tabla AUTOR
CREATE TABLE BIBLIOTECA.AUTOR (
    CODIGO INT PRIMARY KEY NOT NULL,
    NOMBRE VARCHAR(30) NOT NULL
);

-- Crear tabla LIBRO
CREATE TABLE BIBLIOTECA.LIBRO (
    CODIGO_LIBRO INT PRIMARY KEY NOT NULL,
    TITULO VARCHAR(50) NOT NULL,
    ISBN VARCHAR(15) NOT NULL,
    PAGINAS INT NOT NULL,
    EDITORIAL VARCHAR(60) NOT NULL -- Ya se define con longitud ajustada
);

-- Crear tabla AUTOR_LIBRO
CREATE TABLE BIBLIOTECA.AUTOR_LIBRO (
    CODIGO_AUTOR INT NOT NULL,
    CODIGO_LIBRO INT NOT NULL,
    PRIMARY KEY (CODIGO_AUTOR, CODIGO_LIBRO),
    FOREIGN KEY (CODIGO_AUTOR) REFERENCES BIBLIOTECA.AUTOR(CODIGO),
    FOREIGN KEY (CODIGO_LIBRO) REFERENCES BIBLIOTECA.LIBRO(CODIGO_LIBRO)
);

-- Insertar datos en AUTOR_LIBRO
INSERT INTO BIBLIOTECA.AUTOR_LIBRO (CODIGO_AUTOR, CODIGO_LIBRO) 
VALUES (1, 1), 
       (2, 2), 
       (3, 3);

-- Crear tabla LOCALIZACION
CREATE TABLE BIBLIOTECA.LOCALIZACION (
    ID_LOCALIZACION INT PRIMARY KEY NOT NULL,
    RECINTO VARCHAR(25) NOT NULL
);

-- Crear tabla USUARIO
CREATE TABLE BIBLIOTECA.USUARIO (
    CODIGO INT PRIMARY KEY NOT NULL,
    NOMBRE VARCHAR(30) NOT NULL,
    TELEFONO VARCHAR(30) NOT NULL,
    DIRECCION VARCHAR(30) NOT NULL,
    LOCALIZACION INT NOT NULL,
    FOREIGN KEY (LOCALIZACION) REFERENCES BIBLIOTECA.LOCALIZACION(ID_LOCALIZACION)
);

-- Crear tabla EJEMPLAR
CREATE TABLE BIBLIOTECA.EJEMPLAR (
    CODIGO INT PRIMARY KEY NOT NULL,
    LOCALIZACION INT,
    CODIGO_LIBRO INT NOT NULL,
    FOREIGN KEY (LOCALIZACION) REFERENCES BIBLIOTECA.LOCALIZACION(ID_LOCALIZACION),
    FOREIGN KEY (CODIGO_LIBRO) REFERENCES BIBLIOTECA.LIBRO(CODIGO_LIBRO)
);


CREATE TABLE BIBLIOTECA.PRESTAMO (
    ID_PRESTAMO INT AUTO_INCREMENT PRIMARY KEY,
    CODIGO_USUARIO INT NOT NULL,
    CODIGO_EJEMPLAR INT NOT NULL,
    FECHA_PRESTAMO DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CODIGO_USUARIO) REFERENCES BIBLIOTECA.USUARIO(CODIGO),
    FOREIGN KEY (CODIGO_EJEMPLAR) REFERENCES BIBLIOTECA.EJEMPLAR(CODIGO)
);
-- Consultas
SELECT * FROM BIBLIOTECA.AUTOR;
SELECT * FROM BIBLIOTECA.LIBRO;
SELECT * FROM BIBLIOTECA.EJEMPLAR;
SELECT * FROM BIBLIOTECA.LOCALIZACION;
SELECT * FROM BIBLIOTECA.USUARIO;
SELECT * FROM BIBLIOTECA.USUARIO_EJEMPLAR;
SELECT * FROM BIBLIOTECA.PRESTAMO;

-- Consultas de joins
SELECT al.CODIGO_AUTOR, al.CODIGO_LIBRO 
FROM BIBLIOTECA.AUTOR_LIBRO al;

SELECT 
    al.CODIGO_AUTOR, 
    a.NOMBRE AS NOMBRE_AUTOR, 
    al.CODIGO_LIBRO, 
    l.TITULO AS TITULO_LIBRO
FROM BIBLIOTECA.AUTOR_LIBRO al
INNER JOIN BIBLIOTECA.AUTOR a ON al.CODIGO_AUTOR = a.CODIGO
INNER JOIN BIBLIOTECA.LIBRO l ON al.CODIGO_LIBRO = l.CODIGO_LIBRO;

-- Crear procedimientos almacenados
DELIMITER $$

CREATE PROCEDURE ConsultarLibros(
    IN p_id_libro INT,
    IN p_nombre VARCHAR(50),
    IN p_isbn VARCHAR(15),
    IN p_paginas INT,
    IN p_editorial VARCHAR(60)
)
BEGIN
    SELECT * 
    FROM BIBLIOTECA.LIBRO
    WHERE 
        (p_id_libro IS NULL OR CODIGO_LIBRO = p_id_libro) AND
        (p_nombre IS NULL OR TITULO LIKE CONCAT('%', p_nombre, '%')) AND
        (p_isbn IS NULL OR ISBN = p_isbn) AND
        (p_paginas IS NULL OR PAGINAS = p_paginas) AND
        (p_editorial IS NULL OR EDITORIAL LIKE CONCAT('%', p_editorial, '%'));
END$$


DELIMITER $$

CREATE PROCEDURE RegistrarPrestamo(IN id_usuario INT, IN id_ejemplar INT)
BEGIN
    -- Verificar si el usuario existe
    IF NOT EXISTS (SELECT 1 FROM BIBLIOTECA.USUARIO WHERE CODIGO = id_usuario) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario no existe';
    END IF;

    -- Verificar si el ejemplar existe
    IF NOT EXISTS (SELECT 1 FROM BIBLIOTECA.EJEMPLAR WHERE CODIGO = id_ejemplar) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ejemplar no existe';
    END IF;

    -- Insertar el préstamo
    INSERT INTO BIBLIOTECA.PRESTAMO (CODIGO_USUARIO, CODIGO_EJEMPLAR, FECHA_PRESTAMO)
    VALUES (id_usuario, id_ejemplar, NOW());
END$$

DELIMITER ;

END$$
DELIMITER $$
CREATE PROCEDURE ActualizarAutor(
    IN p_codigo INT,
    IN p_nombre VARCHAR(30)
)
BEGIN
    UPDATE BIBLIOTECA.AUTOR
    SET NOMBRE = COALESCE(p_nombre, NOMBRE)
    WHERE CODIGO = p_codigo;
END$$

DELIMITER $$
CREATE PROCEDURE EliminarUsuario(
    IN p_codigo_usuario INT
)
BEGIN
    DELETE FROM BIBLIOTECA.USUARIO
    WHERE CODIGO = p_codigo_usuario;
END$$

DELIMITER ;
-- Insertar datos en AUTOR
INSERT INTO BIBLIOTECA.AUTOR (CODIGO, NOMBRE) VALUES
(1, 'Gabriel García Márquez'),
(2, 'Isabel Allende'),
(3, 'J.K. Rowling'),
(4, 'George Orwell'),
(5, 'Miguel de Cervantes'),
(6, 'Jane Austen'),
(7, 'Ernest Hemingway'),
(8, 'Mark Twain'),
(9, 'Fiódor Dostoyevski'),
(10, 'J.R.R. Tolkien');

-- Insertar datos en LIBRO
INSERT INTO BIBLIOTECA.LIBRO (CODIGO_LIBRO, TITULO, ISBN, PAGINAS, EDITORIAL) VALUES
(1, 'Cien años de soledad', '9780060883287', 417, 'HarperCollins'),
(2, 'La casa de los espíritus', '9780553383805', 481, 'Plaza & Janes'),
(3, 'Harry Potter y la piedra filosofal', '9780747532743', 309, 'Bloomsbury'),
(4, '1984', '9780451524935', 328, 'Penguin'),
(5, 'Don Quijote', '9780060934347', 992, 'Vintage'),
(6, 'Orgullo y prejuicio', '9780141040349', 432, 'Penguin Classics'),
(7, 'El viejo y el mar', '9780684830490', 127, 'Scribner'),
(8, 'Las aventuras de Tom Sawyer', '9780143039563', 274, 'Penguin Classics'),
(9, 'Crimen y castigo', '9780140449136', 671, 'Penguin Classics'),
(10, 'El señor de los anillos', '9780261103252', 1178, 'Allen & Unwin');

-- Insertar datos en AUTOR_LIBRO
INSERT INTO BIBLIOTECA.AUTOR_LIBRO (CODIGO_AUTOR, CODIGO_LIBRO) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5),
(6, 6), (7, 7), (8, 8), (9, 9), (10, 10);

-- Insertar datos en LOCALIZACION
INSERT INTO BIBLIOTECA.LOCALIZACION (ID_LOCALIZACION, RECINTO) VALUES
(1, 'Biblioteca Central'),
(2, 'Biblioteca de Ciencias'),
(3, 'Biblioteca de Humanidades'),
(4, 'Biblioteca de Ingeniería'),
(5, 'Biblioteca de Medicina'),
(6, 'Biblioteca Regional Norte'),
(7, 'Biblioteca Regional Sur'),
(8, 'Biblioteca Digital'),
(9, 'Biblioteca Infantil'),
(10, 'Archivo Histórico');

-- Insertar datos en USUARIO
INSERT INTO BIBLIOTECA.USUARIO (CODIGO, NOMBRE, TELEFONO, DIRECCION, LOCALIZACION) VALUES
(1, 'Juan Pérez', '123456789', 'Calle 1', 1),
(2, 'María López', '987654321', 'Calle 2', 2),
(3, 'Pedro Ramírez', '456789123', 'Calle 3', 3),
(4, 'Ana Gómez', '789123456', 'Calle 4', 4),
(5, 'Luis Torres', '321654987', 'Calle 5', 5),
(6, 'Sofía Rodríguez', '654987321', 'Calle 6', 6),
(7, 'Carlos Martínez', '963852741', 'Calle 7', 7),
(8, 'Laura Castillo', '741852963', 'Calle 8', 8),
(9, 'Diego Sánchez', '852963741', 'Calle 9', 9),
(10, 'Valeria Fernández', '147258369', 'Calle 10', 10);



-- Insertar datos en EJEMPLAR
INSERT INTO BIBLIOTECA.EJEMPLAR (CODIGO, LOCALIZACION, CODIGO_LIBRO) VALUES
(1, 1, 1), (2, 2, 2), (3, 3, 3), (4, 4, 4), (5, 5, 5),
(6, 6, 6), (7, 7, 7), (8, 8, 8), (9, 9, 9), (10, 10, 10);



-- Consulta con grupo y condición
SELECT ID_USUARIO, COUNT(*) AS RESULTADOS 
FROM BIBLIOTECA.USUARIO_EJEMPLAR
GROUP BY ID_USUARIO 
HAVING COUNT(*) < 6;
