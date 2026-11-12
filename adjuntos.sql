CREATE TABLE IF NOT EXISTS preventa_adjuntos (
 id CHAR(36) NOT NULL,
 preventa_id BIGINT UNSIGNED NULL,
 usuario_id BIGINT UNSIGNED NOT NULL,
 categoria ENUM('DOCUMENTO','CONTRATO','AUTORIZACION','AUDIO') NOT NULL,
 nombre_original VARCHAR(240) NOT NULL,
 nombre_interno VARCHAR(80) NOT NULL,
 mime VARCHAR(80) NOT NULL,
 tamano BIGINT UNSIGNED NOT NULL,
 creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 PRIMARY KEY (id),
 UNIQUE KEY uq_adjunto_nombre_interno (nombre_interno),
 KEY idx_adjuntos_preventa (preventa_id, creado_en),
 KEY idx_adjuntos_temporales (usuario_id, preventa_id, creado_en),
 CONSTRAINT fk_adjunto_preventa FOREIGN KEY (preventa_id) REFERENCES preventas(id),
 CONSTRAINT fk_adjunto_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
