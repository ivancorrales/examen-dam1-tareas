DROP TABLE IF EXISTS tareas;
DROP TABLE IF EXISTS empleados;

CREATE TABLE empleados (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE tareas (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descripcion VARCHAR(500) NOT NULL,
    estado VARCHAR(30) NOT NULL,
    prioridad VARCHAR(20) NOT NULL,
    fecha_limite DATE NOT NULL,
    completada BOOLEAN NOT NULL,
    empleado_id BIGINT,

    CONSTRAINT fk_tareas_empleados
        FOREIGN KEY (empleado_id)
        REFERENCES empleados(id)
);

INSERT INTO empleados (nombre, email) VALUES
('Laura Sánchez', 'laura.sanchez@empresa.com'),
('Carlos Martín', 'carlos.martin@empresa.com'),
('Marta López', 'marta.lopez@empresa.com'),
('David García', 'david.garcia@empresa.com'),
('Nerea Torres', 'nerea.torres@empresa.com');

INSERT INTO tareas
(titulo, descripcion, estado, prioridad, fecha_limite, completada, empleado_id)
VALUES
('Preparar presentación del proyecto',
 'Crear una presentación inicial para explicar el estado del proyecto al equipo.',
 'PENDIENTE',
 'ALTA',
 '2026-06-10',
 FALSE,
 1),

('Revisar documentación técnica',
 'Comprobar que la documentación del proyecto está actualizada y es comprensible.',
 'EN_PROCESO',
 'MEDIA',
 '2026-06-14',
 FALSE,
 2),

('Actualizar repositorio',
 'Subir los últimos cambios al repositorio y revisar que el README está completo.',
 'PENDIENTE',
 'MEDIA',
 '2026-06-08',
 FALSE,
 3),

('Corregir errores de la interfaz',
 'Revisar pequeños errores visuales en las pantallas principales de la aplicación.',
 'EN_PROCESO',
 'ALTA',
 '2026-06-05',
 FALSE,
 1),

('Cerrar tareas finalizadas',
 'Revisar qué tareas ya están terminadas y marcarlas como completadas.',
 'COMPLETADA',
 'BAJA',
 '2026-05-30',
 TRUE,
 4),

('Planificar reunión semanal',
 'Preparar los puntos principales que se tratarán en la próxima reunión del equipo.',
 'PENDIENTE',
 'BAJA',
 '2026-06-12',
 FALSE,
 5);
