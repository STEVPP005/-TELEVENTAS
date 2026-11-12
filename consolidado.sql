CREATE TABLE IF NOT EXISTS preventa_control (
 preventa_id BIGINT UNSIGNED NOT NULL,
 estado_servicio VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
 aprobacion VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
 datos_backoffice JSON NOT NULL,
 version INT UNSIGNED NOT NULL DEFAULT 0,
 actualizado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 PRIMARY KEY (preventa_id),
 CONSTRAINT fk_control_preventa FOREIGN KEY (preventa_id) REFERENCES preventas(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE IF NOT EXISTS preventa_eventos (
 id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
 preventa_id BIGINT UNSIGNED NOT NULL,
 actor_id BIGINT UNSIGNED NOT NULL,
 accion VARCHAR(40) NOT NULL,
 estado_anterior VARCHAR(20) NOT NULL,
 estado_nuevo VARCHAR(20) NOT NULL,
 aprobacion_anterior VARCHAR(20) NOT NULL,
 aprobacion_nueva VARCHAR(20) NOT NULL,
 comentario TEXT NULL,
 cambios JSON NOT NULL,
 creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 PRIMARY KEY (id),
 KEY idx_evento_preventa (preventa_id, id),
 CONSTRAINT fk_evento_preventa FOREIGN KEY (preventa_id) REFERENCES preventas(id) ON DELETE CASCADE,
 CONSTRAINT fk_evento_actor FOREIGN KEY (actor_id) REFERENCES usuarios(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
