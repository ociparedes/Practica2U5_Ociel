-- ============================================================
-- Centro Deportivo - MySQL 8.x
-- Importar en MySQL Workbench: File > Open SQL Script > Execute
-- ============================================================

CREATE DATABASE IF NOT EXISTS centro_deportivo
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_spanish_ci;

USE centro_deportivo;

CREATE TABLE IF NOT EXISTS socios (
  id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre      VARCHAR(80)  NOT NULL,
  apellido    VARCHAR(80)  NOT NULL,
  email       VARCHAR(120) NOT NULL,
  telefono    VARCHAR(20),
  fecha_alta  DATE         NOT NULL DEFAULT (CURRENT_DATE),
  activo      TINYINT(1)   NOT NULL DEFAULT 1,
  PRIMARY KEY (id),
  UNIQUE KEY uq_socios_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE IF NOT EXISTS entrenadores (
  id           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre       VARCHAR(80)  NOT NULL,
  apellido     VARCHAR(80)  NOT NULL,
  especialidad VARCHAR(80)  NOT NULL,
  email        VARCHAR(120) NOT NULL,
  telefono     VARCHAR(20),
  PRIMARY KEY (id),
  UNIQUE KEY uq_entrenadores_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE IF NOT EXISTS instalaciones (
  id        BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre    VARCHAR(80)  NOT NULL,
  tipo      VARCHAR(50)  NOT NULL,
  capacidad INT          NOT NULL,
  ubicacion VARCHAR(100),
  PRIMARY KEY (id),
  CONSTRAINT chk_instalaciones_capacidad CHECK (capacidad > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE IF NOT EXISTS actividades (
  id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre         VARCHAR(100) NOT NULL,
  entrenador_id  BIGINT UNSIGNED NOT NULL,
  instalacion_id BIGINT UNSIGNED NOT NULL,
  dia_semana     VARCHAR(15)  NOT NULL,
  hora_inicio    TIME         NOT NULL,
  duracion_min   INT          NOT NULL,
  cupo_max       INT          NOT NULL,
  precio_mensual DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id),
  KEY idx_actividades_entrenador (entrenador_id),
  KEY idx_actividades_instalacion (instalacion_id),
  CONSTRAINT fk_actividades_entrenador  FOREIGN KEY (entrenador_id)  REFERENCES entrenadores(id)  ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_actividades_instalacion FOREIGN KEY (instalacion_id) REFERENCES instalaciones(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_actividades_duracion CHECK (duracion_min > 0),
  CONSTRAINT chk_actividades_cupo     CHECK (cupo_max > 0),
  CONSTRAINT chk_actividades_precio   CHECK (precio_mensual >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE IF NOT EXISTS inscripciones (
  id                BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  socio_id          BIGINT UNSIGNED NOT NULL,
  actividad_id      BIGINT UNSIGNED NOT NULL,
  fecha_inscripcion DATE NOT NULL DEFAULT (CURRENT_DATE),
  estado            ENUM('activa','cancelada','finalizada') NOT NULL DEFAULT 'activa',
  PRIMARY KEY (id),
  UNIQUE KEY uq_inscripciones_socio_actividad (socio_id, actividad_id),
  KEY idx_inscripciones_actividad (actividad_id),
  CONSTRAINT fk_inscripciones_socio     FOREIGN KEY (socio_id)     REFERENCES socios(id)     ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_inscripciones_actividad FOREIGN KEY (actividad_id) REFERENCES actividades(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CREATE TABLE IF NOT EXISTS pagos (
  id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  socio_id   BIGINT UNSIGNED NOT NULL,
  concepto   VARCHAR(100) NOT NULL,
  monto      DECIMAL(10,2) NOT NULL,
  fecha_pago DATE NOT NULL DEFAULT (CURRENT_DATE),
  metodo     ENUM('efectivo','tarjeta','transferencia') NOT NULL,
  PRIMARY KEY (id),
  KEY idx_pagos_socio (socio_id),
  CONSTRAINT fk_pagos_socio FOREIGN KEY (socio_id) REFERENCES socios(id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT chk_pagos_monto CHECK (monto > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- =========================
-- Datos de ejemplo (>= 10)
-- =========================

INSERT INTO socios (id, nombre, apellido, email, telefono, fecha_alta, activo) VALUES
  (1,  'Ana',    'Garcia',    'ana.garcia@mail.com',     '600111222', '2025-01-15', 1),
  (2,  'Luis',   'Martinez',  'luis.martinez@mail.com',  '600222333', '2025-02-03', 1),
  (3,  'Carlos', 'Ruiz',      'carlos.ruiz@mail.com',    '600333444', '2025-02-20', 1),
  (4,  'Maria',  'Lopez',     'maria.lopez@mail.com',    '600444555', '2025-03-11', 1),
  (5,  'Elena',  'Torres',    'elena.torres@mail.com',   '600555666', '2025-04-05', 1),
  (6,  'Javier', 'Sanchez',   'javier.sanchez@mail.com', '600666777', '2025-05-19', 1),
  (7,  'Sofia',  'Ramirez',   'sofia.ramirez@mail.com',  '600777888', '2025-06-02', 1),
  (8,  'Pablo',  'Fernandez', 'pablo.fernandez@mail.com','600888999', '2025-07-21', 1),
  (9,  'Lucia',  'Gomez',     'lucia.gomez@mail.com',    '600999000', '2025-08-14', 1),
  (10, 'Diego',  'Navarro',   'diego.navarro@mail.com',  '601010101', '2025-09-09', 1)
ON DUPLICATE KEY UPDATE id = id;

INSERT INTO entrenadores (id, nombre, apellido, especialidad, email, telefono) VALUES
  (1,  'Roberto', 'Diaz',       'Fitness',        'roberto.diaz@centro.com',    '611111111'),
  (2,  'Marta',   'Villanueva', 'Yoga',           'marta.villanueva@centro.com','611222222'),
  (3,  'Sergio',  'Molina',     'Natacion',       'sergio.molina@centro.com',   '611333333'),
  (4,  'Carmen',  'Ortega',     'Pilates',        'carmen.ortega@centro.com',   '611444444'),
  (5,  'Alvaro',  'Castro',     'Baloncesto',     'alvaro.castro@centro.com',   '611555555'),
  (6,  'Nuria',   'Benitez',    'Tenis',          'nuria.benitez@centro.com',   '611666666'),
  (7,  'Ivan',    'Romero',     'Spinning',       'ivan.romero@centro.com',     '611777777'),
  (8,  'Paula',   'Herrera',    'Zumba',          'paula.herrera@centro.com',   '611888888'),
  (9,  'Hector',  'Gil',        'Futbol',         'hector.gil@centro.com',      '611999999'),
  (10, 'Raquel',  'Serrano',    'Crossfit',       'raquel.serrano@centro.com',  '612121212')
ON DUPLICATE KEY UPDATE id = id;

INSERT INTO instalaciones (id, nombre, tipo, capacidad, ubicacion) VALUES
  (1,  'Sala de Pesas',       'Musculacion',      40,  'Planta baja'),
  (2,  'Sala Fitness',        'Fitness',          30,  'Planta baja'),
  (3,  'Piscina Olimpica',    'Natacion',         60,  'Planta -1'),
  (4,  'Pista de Tenis 1',    'Tenis',            4,   'Exterior'),
  (5,  'Pista de Tenis 2',    'Tenis',            4,   'Exterior'),
  (6,  'Pabellon Baloncesto', 'Baloncesto',       200, 'Planta alta'),
  (7,  'Campo de Futbol',     'Futbol',           300, 'Exterior'),
  (8,  'Sala de Yoga',        'Yoga',             25,  'Planta primera'),
  (9,  'Sala de Spinning',    'Ciclismo indoor',  30,  'Planta primera'),
  (10, 'Sala Multiusos',      'Zumba y Pilates',  35,  'Planta primera')
ON DUPLICATE KEY UPDATE id = id;

INSERT INTO actividades (id, nombre, entrenador_id, instalacion_id, dia_semana, hora_inicio, duracion_min, cupo_max, precio_mensual) VALUES
  (1,  'Musculacion guiada', 1,  1,  'Lunes',     '08:00', 60, 20, 35.00),
  (2,  'Yoga matutino',      2,  8,  'Martes',    '09:00', 60, 15, 30.00),
  (3,  'Natacion adultos',   3,  3,  'Lunes',     '07:00', 45, 25, 40.00),
  (4,  'Pilates',            4,  10, 'Miercoles', '18:00', 50, 18, 32.00),
  (5,  'Baloncesto juvenil', 5,  6,  'Jueves',    '17:00', 90, 30, 25.00),
  (6,  'Tenis iniciacion',   6,  4,  'Sabado',    '10:00', 60, 4,  45.00),
  (7,  'Spinning',           7,  9,  'Lunes',     '19:00', 45, 25, 28.00),
  (8,  'Zumba',              8,  10, 'Viernes',   '20:00', 60, 30, 22.00),
  (9,  'Futbol sala',        9,  7,  'Sabado',    '16:00', 90, 40, 20.00),
  (10, 'Crossfit',           10, 2,  'Martes',    '20:00', 60, 20, 38.00),
  (11, 'Natacion infantil',  3,  3,  'Sabado',    '09:00', 45, 20, 35.00),
  (12, 'Yoga nocturno',      2,  8,  'Jueves',    '21:00', 60, 15, 30.00)
ON DUPLICATE KEY UPDATE id = id;

INSERT INTO inscripciones (id, socio_id, actividad_id, fecha_inscripcion, estado) VALUES
  (1,  1,  1,  '2026-01-10', 'activa'),
  (2,  2,  1,  '2026-01-11', 'activa'),
  (3,  3,  2,  '2026-01-12', 'activa'),
  (4,  4,  3,  '2026-01-13', 'activa'),
  (5,  5,  4,  '2026-01-14', 'activa'),
  (6,  6,  5,  '2026-01-15', 'activa'),
  (7,  7,  6,  '2026-01-16', 'activa'),
  (8,  8,  7,  '2026-01-17', 'activa'),
  (9,  9,  8,  '2026-01-18', 'activa'),
  (10, 10, 9,  '2026-01-19', 'activa'),
  (11, 1,  10, '2026-02-01', 'activa'),
  (12, 2,  3,  '2026-02-02', 'cancelada')
ON DUPLICATE KEY UPDATE id = id;

INSERT INTO pagos (id, socio_id, concepto, monto, fecha_pago, metodo) VALUES
  (1,  1,  'Mensualidad enero',      35.00, '2026-01-05', 'tarjeta'),
  (2,  2,  'Mensualidad enero',      35.00, '2026-01-06', 'efectivo'),
  (3,  3,  'Mensualidad enero',      30.00, '2026-01-06', 'transferencia'),
  (4,  4,  'Mensualidad enero',      40.00, '2026-01-07', 'tarjeta'),
  (5,  5,  'Mensualidad enero',      32.00, '2026-01-07', 'tarjeta'),
  (6,  6,  'Mensualidad enero',      25.00, '2026-01-08', 'efectivo'),
  (7,  7,  'Mensualidad enero',      45.00, '2026-01-08', 'transferencia'),
  (8,  8,  'Mensualidad enero',      28.00, '2026-01-09', 'tarjeta'),
  (9,  9,  'Mensualidad enero',      22.00, '2026-01-09', 'efectivo'),
  (10, 10, 'Mensualidad enero',      20.00, '2026-01-10', 'tarjeta'),
  (11, 1,  'Matricula anual',        50.00, '2025-01-15', 'transferencia'),
  (12, 3,  'Clase suelta de tenis',  15.00, '2026-01-12', 'efectivo')
ON DUPLICATE KEY UPDATE id = id;

ALTER TABLE socios        AUTO_INCREMENT = 11;
ALTER TABLE entrenadores  AUTO_INCREMENT = 11;
ALTER TABLE instalaciones AUTO_INCREMENT = 11;
ALTER TABLE actividades   AUTO_INCREMENT = 13;
ALTER TABLE inscripciones AUTO_INCREMENT = 13;
ALTER TABLE pagos         AUTO_INCREMENT = 13;

-- Vista para visualizar actividades con sus relaciones en Workbench
CREATE OR REPLACE VIEW v_actividades_detalle AS
SELECT a.id,
       a.nombre         AS actividad,
       CONCAT(e.nombre, ' ', e.apellido) AS entrenador,
       e.especialidad,
       i.nombre         AS instalacion,
       i.tipo           AS tipo_instalacion,
       a.dia_semana,
       a.hora_inicio,
       a.duracion_min,
       a.cupo_max,
       a.precio_mensual,
       (SELECT COUNT(*) FROM inscripciones ins WHERE ins.actividad_id = a.id AND ins.estado = 'activa') AS inscritos
FROM actividades a
JOIN entrenadores  e ON e.id = a.entrenador_id
JOIN instalaciones i ON i.id = a.instalacion_id;
