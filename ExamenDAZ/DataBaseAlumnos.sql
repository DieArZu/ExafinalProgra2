CREATE DATABASE EstudiantesDB;

USE EstudiantesDB;

CREATE TABLE Estudiantes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cedula VARCHAR(15) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    nota FLOAT DEFAULT NULL,
    estado VARCHAR(20) DEFAULT 'Pendiente'
);

-- Insertar 10 registros iniciales con el estado "Pendiente" y nota NULL
INSERT INTO Estudiantes (cedula, nombre) VALUES
('123456789', 'Carlos Perez'),
('987654321', 'Maria Lopez'),
('456789123', 'Juan Martinez'),
('654321987', 'Ana Torres'),
('112233445', 'Luis Gomez'),
('998877665', 'Sofia Diaz'),
('445566778', 'Pedro Ramirez'),
('334455667', 'Laura Moreno'),
('223344556', 'Andres Chavez'),
('556677889', 'Camila Suarez');
