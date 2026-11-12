CREATE TABLE IF NOT EXISTS equipos (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  canal ENUM('TELEVENTAS', 'MASIVO', 'PYME') NOT NULL DEFAULT 'TELEVENTAS',
  activo BOOLEAN NOT NULL DEFAULT TRUE,
  creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  actualizado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_equipo_canal_nombre (canal, nombre)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS usuarios (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(120) NOT NULL,
  correo VARCHAR(190) NOT NULL,
  usuario VARCHAR(70) NOT NULL,
  contrasena_hash VARCHAR(255) NOT NULL,
  rol ENUM(
    'SUPERUSUARIO',
    'IT',
    'GERENTE_OPERACIONES',
    'SUPERVISOR_VENTAS',
    'EJECUTIVO_TELEVENTAS',
    'BACKOFFICE'
  ) NOT NULL,
  canal ENUM('TELEVENTAS', 'MASIVO', 'PYME') NOT NULL DEFAULT 'TELEVENTAS',
  equipo_id BIGINT UNSIGNED NULL,
  activo BOOLEAN NOT NULL DEFAULT TRUE,
  creado_por BIGINT UNSIGNED NULL,
  creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  actualizado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_usuarios_correo (correo),
  UNIQUE KEY uq_usuarios_usuario (usuario),
  KEY idx_usuarios_rol_equipo (rol, equipo_id),
  CONSTRAINT fk_usuarios_equipo
    FOREIGN KEY (equipo_id) REFERENCES equipos(id)
    ON DELETE SET NULL,
  CONSTRAINT fk_usuarios_creado_por
    FOREIGN KEY (creado_por) REFERENCES usuarios(id)
    ON DELETE SET NULL
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE IF NOT EXISTS preventas (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  codigo VARCHAR(30) NOT NULL,
  tipo ENUM('MULTIMEDIA', 'POSPAGO') NOT NULL,
  canal ENUM('TELEVENTAS', 'MASIVO', 'PYME') NOT NULL DEFAULT 'TELEVENTAS',
  equipo_id BIGINT UNSIGNED NULL,
  ejecutivo_id BIGINT UNSIGNED NOT NULL,
  cliente_nombre VARCHAR(160) NOT NULL,
  cliente_cedula VARCHAR(30) NULL,
  cliente_telefono VARCHAR(30) NULL,
  cliente_correo VARCHAR(190) NULL,
  estado ENUM(
    'PENDIENTE_SUPERVISOR',
    'DEVUELTA_EJECUTIVO',
    'APROBADA_SUPERVISOR',
    'EN_BACKOFFICE',
    'FINALIZADA'
  ) NOT NULL DEFAULT 'PENDIENTE_SUPERVISOR',
  datos_formulario JSON NOT NULL,
  supervisor_id BIGINT UNSIGNED NULL,
  aprobada_en DATETIME NULL,
  creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  actualizado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_preventas_codigo (codigo),
  KEY idx_preventas_estado_fecha (estado, creado_en),
  KEY idx_preventas_ejecutivo_fecha (ejecutivo_id, creado_en),
  CONSTRAINT fk_preventas_equipo
    FOREIGN KEY (equipo_id) REFERENCES equipos(id)
    ON DELETE SET NULL,
  CONSTRAINT fk_preventas_ejecutivo
    FOREIGN KEY (ejecutivo_id) REFERENCES usuarios(id),
  CONSTRAINT fk_preventas_supervisor
    FOREIGN KEY (supervisor_id) REFERENCES usuarios(id)
    ON DELETE SET NULL
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS preventa_historial (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  preventa_id BIGINT UNSIGNED NOT NULL,
  actor_id BIGINT UNSIGNED NOT NULL,
  accion ENUM(
    'CREADA',
    'ENVIADA_SUPERVISOR',
    'DEVUELTA_EJECUTIVO',
    'APROBADA_SUPERVISOR',
    'ENVIADA_BACKOFFICE',
    'ACTUALIZADA_BACKOFFICE',
    'FINALIZADA'
  ) NOT NULL,
  comentario TEXT NULL,
  creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_preventa_historial_fecha (preventa_id, creado_en),
  CONSTRAINT fk_historial_preventa
    FOREIGN KEY (preventa_id) REFERENCES preventas(id)
    ON DELETE CASCADE,
  CONSTRAINT fk_historial_actor
    FOREIGN KEY (actor_id) REFERENCES usuarios(id)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS catalogo_tecnologias (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  equipo_id BIGINT UNSIGNED NOT NULL,
  producto ENUM('MULTIMEDIA', 'POSPAGO') NOT NULL,
  tipo_gestion ENUM(
    'ALTA_NUEVA',
    'SVA',
    'MIGRACION',
    'UPSELL',
    'MIGRACION_PRE_A_POS'
  ) NOT NULL,
  nombre VARCHAR(120) NOT NULL,
  activo BOOLEAN NOT NULL DEFAULT TRUE,
  creado_por BIGINT UNSIGNED NOT NULL,
  creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  actualizado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_tecnologia_equipo (equipo_id, producto, tipo_gestion, nombre),
  CONSTRAINT fk_tecnologia_equipo
    FOREIGN KEY (equipo_id) REFERENCES equipos(id),
  CONSTRAINT fk_tecnologia_creador
    FOREIGN KEY (creado_por) REFERENCES usuarios(id)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS catalogo_segmentaciones (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  equipo_id BIGINT UNSIGNED NOT NULL,
  producto ENUM('MULTIMEDIA', 'POSPAGO') NOT NULL,
  tipo_gestion ENUM(
    'ALTA_NUEVA',
    'SVA',
    'MIGRACION',
    'UPSELL',
    'MIGRACION_PRE_A_POS'
  ) NOT NULL,
  nombre VARCHAR(120) NOT NULL,
  activo BOOLEAN NOT NULL DEFAULT TRUE,
  creado_por BIGINT UNSIGNED NOT NULL,
  creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  actualizado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_segmentacion_equipo (equipo_id, producto, tipo_gestion, nombre),
  CONSTRAINT fk_segmentacion_equipo
    FOREIGN KEY (equipo_id) REFERENCES equipos(id),
  CONSTRAINT fk_segmentacion_creador
    FOREIGN KEY (creado_por) REFERENCES usuarios(id)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS ofertas_comerciales (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  equipo_id BIGINT UNSIGNED NOT NULL,
  producto ENUM('MULTIMEDIA', 'POSPAGO') NOT NULL,
  tipo_gestion ENUM(
    'ALTA_NUEVA',
    'SVA',
    'MIGRACION',
    'UPSELL',
    'MIGRACION_PRE_A_POS'
  ) NOT NULL,
  nombre VARCHAR(150) NOT NULL,
  campana VARCHAR(120) NULL,
  tecnologia_id BIGINT UNSIGNED NULL,
  segmentacion_id BIGINT UNSIGNED NULL,
  detalles JSON NOT NULL,
  vigente_desde DATE NULL,
  vigente_hasta DATE NULL,
  activo BOOLEAN NOT NULL DEFAULT TRUE,
  creado_por BIGINT UNSIGNED NOT NULL,
  actualizado_por BIGINT UNSIGNED NULL,
  creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  actualizado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_ofertas_filtro (equipo_id, producto, tipo_gestion, activo),
  CONSTRAINT fk_oferta_equipo
    FOREIGN KEY (equipo_id) REFERENCES equipos(id),
  CONSTRAINT fk_oferta_tecnologia
    FOREIGN KEY (tecnologia_id) REFERENCES catalogo_tecnologias(id)
    ON DELETE SET NULL,
  CONSTRAINT fk_oferta_segmentacion
    FOREIGN KEY (segmentacion_id) REFERENCES catalogo_segmentaciones(id)
    ON DELETE SET NULL,
  CONSTRAINT fk_oferta_creador
    FOREIGN KEY (creado_por) REFERENCES usuarios(id),
  CONSTRAINT fk_oferta_actualizador
    FOREIGN KEY (actualizado_por) REFERENCES usuarios(id)
    ON DELETE SET NULL
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS catalogo_origenes (
 id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
 equipo_id BIGINT UNSIGNED NOT NULL,
 nombre VARCHAR(120) NOT NULL,
 activo BOOLEAN NOT NULL DEFAULT TRUE,
 creado_por BIGINT UNSIGNED NOT NULL,
 creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 actualizado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 PRIMARY KEY (id),
 UNIQUE KEY uq_origen_equipo_nombre (equipo_id, nombre),
 CONSTRAINT fk_origen_equipo FOREIGN KEY (equipo_id) REFERENCES equipos(id),
 CONSTRAINT fk_origen_creador FOREIGN KEY (creado_por) REFERENCES usuarios(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
