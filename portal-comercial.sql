CREATE TABLE IF NOT EXISTS recursos_comerciales (
 id CHAR(36) NOT NULL,
 titulo VARCHAR(160) NOT NULL,
 descripcion VARCHAR(1000) NOT NULL DEFAULT '',
 categoria ENUM('MATRICES','IMAGENES','POLITICAS','VARIOS') NOT NULL,
 nombre_original VARCHAR(240) NOT NULL,
 nombre_interno VARCHAR(80) NOT NULL,
 mime VARCHAR(100) NOT NULL,
 tamano BIGINT UNSIGNED NOT NULL,
 creado_por BIGINT UNSIGNED NOT NULL,
 creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 PRIMARY KEY (id),
 UNIQUE KEY uq_recurso_nombre_interno (nombre_interno),
 KEY idx_recurso_categoria_fecha (categoria,creado_en),
 CONSTRAINT fk_recurso_creador FOREIGN KEY (creado_por) REFERENCES usuarios(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
