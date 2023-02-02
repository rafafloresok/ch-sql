

-- INSERCIÓN DE DATOS


USE sf_stores_flores;

INSERT INTO meas_units (`name`, min_unit)
VALUES
	('mts', 0.01),
    ('kgs', 0.001),
    ('lts', 0.001),
    ('unidades', 1);
    
INSERT INTO suppliers (`name`, email, phone, address)
VALUES
	('Proveedor de hilos S.A.', 'pdhsa@pdhsa.com', 2964111111, 'Avenida Elcano 555, Rio Grande'),
	('Proveedor de etiquetas S.A.', 'pdesa@pdesa.com', 2901222222, 'Avenida Maipu 123, Ushuaia'),
	('Proveedor de bolsas S.A.', 'pdbsa@pdbsa.com', 2964333333, 'Boulevard Laserre 333, Tolhuin'),
	('Proveedor de solapas S.A.', 'pdssa@pdssa.com', 2901444444, 'Calle Khami 987, San Sebastian'),
	('Proveedor de insumos S.A.', 'pdisa@pdisa.com', 2964555555, 'Pasaje Vera 456, Puerto Almanza');

INSERT INTO items (`name`, `description`, id_meas_unit, id_supplier)
VALUES
	('hilo rojo', 'Hilo de algodón color rojo. Bobinas de 500 mts', 4, 1),
    ('hilo azul', 'Hilo de algodón color azul. Bobinas de 500 mts', 4, 1),
    ('hilo blanco', 'Hilo de algodón color blanco. Bobinas de 500 mts', 4, 1),
    ('etiqueta chica', 'Cinta para impresion de etiqueta chica', 1, 2),
    ('etiqueta mediana', 'Cinta para impresion de etiqueta mediana', 1, 2),
    ('etiqueta grande', 'Cinta para impresion de etiqueta grande', 1, 2),
    ('bolsa chica', 'bolsa de empaque chica', 2, 3),
    ('bolsa mediana', 'bolsa de empaque mediana', 2, 3),
    ('bolsa grande', 'bolsa de empaque grande', 2, 3),
    ('aceite tipo 1', 'aceite para maquina tipo 1', 3, 5),
    ('aceite tipo 2', 'aceite para maquina tipo 2', 3, 5),
    ('aceite tipo 3', 'aceite para maquina tipo 3', 3, 5),
    ('solapa chica', 'solapa para empaque chica', 4, 4),
    ('solapa mediana', 'solapa para empaque mediana', 4, 4),
    ('solapa grande', 'solapa para empaque grande', 4, 4);

INSERT INTO stores (`name`, address)
VALUES
	('Belgrano', 'Belgrano 1500, Rio Grande'),
    ('San Martin', 'San Martin 2500, Ushuaia'),
    ('Independencia', 'Independencia 420, Tolhuin'),
    ('Guevara', 'Ernesto Guevara 472, San Sebastian');
    
INSERT INTO place_types (`name`, `description`)
VALUES
	('pasillo', 'ubicación tipo pasillo'),
    ('pared', 'ubicación tipo pared'),
    ('piso', 'ubicación tipo piso'),
    ('techo', 'ubicación tipo techo');
    
INSERT INTO places
VALUES
	(1, 1, 1, 1, 1),
    (1, 1, 1, 1, 2),
    (1, 1, 1, 2, 1),
    (1, 1, 1, 2, 2),
    (1, 1, 2, 1, 1),
    (1, 1, 2, 1, 2),
    (1, 1, 2, 2, 1),
    (1, 1, 2, 2, 2),
    (1, 2, 1, 1, 1),
    (1, 2, 1, 1, 2),
    (1, 2, 1, 2, 1),
    (1, 2, 1, 2, 2),
    (1, 2, 2, 1, 1),
    (1, 2, 2, 1, 2),
    (1, 2, 2, 2, 1),
    (1, 2, 2, 2, 2),
    (1, 3, 1, 1, 1),
    (1, 3, 1, 1, 2),
    (1, 3, 1, 2, 1),
    (1, 3, 1, 2, 2),
    (1, 3, 2, 1, 1),
    (1, 3, 2, 1, 2),
    (1, 3, 2, 2, 1),
    (1, 3, 2, 2, 2),
    (2, 1, 1, 1, 1),
    (2, 1, 1, 1, 2),
    (2, 1, 1, 2, 1),
    (2, 1, 1, 2, 2),
    (2, 1, 2, 1, 1),
    (2, 1, 2, 1, 2),
    (2, 1, 2, 2, 1),
    (2, 1, 2, 2, 2),
    (2, 2, 1, 1, 1),
    (2, 2, 1, 1, 2),
    (2, 2, 1, 2, 1),
    (2, 2, 1, 2, 2),
    (2, 2, 2, 1, 1),
    (2, 2, 2, 1, 2),
    (2, 2, 2, 2, 1),
    (2, 2, 2, 2, 2),
    (3, 1, 1, 1, 1),
    (3, 1, 1, 1, 2),
    (3, 1, 1, 2, 1),
    (3, 1, 1, 2, 2),
    (3, 1, 2, 1, 1),
    (3, 1, 2, 1, 2),
    (3, 1, 2, 2, 1),
    (3, 1, 2, 2, 2),
    (3, 3, 1, 1, 1),
    (3, 3, 1, 1, 2),
    (3, 3, 1, 2, 1),
    (3, 3, 1, 2, 2),
    (3, 3, 2, 1, 1),
    (3, 3, 2, 1, 2),
    (3, 3, 2, 2, 1),
    (3, 3, 2, 2, 2),
    (4, 1, 1, 1, 1),
    (4, 1, 1, 1, 2),
    (4, 1, 1, 2, 1),
    (4, 1, 1, 2, 2),
    (4, 1, 2, 1, 1),
    (4, 1, 2, 1, 2),
    (4, 1, 2, 2, 1),
    (4, 1, 2, 2, 2);

INSERT INTO user_types (`name`, `description`)
VALUES
	('administrador', 'realiza cualquier operación sobre la base de datos'),
    ('supervisor', 'realiza movimientos y ajustes de inventarios'),
    ('operario', 'solo realiza movimientos de insumos');

INSERT INTO users (first_name, last_name, address, email, phone)
VALUES
	('Rafael', 'Flores', 'Ernesto Guevara 472, Río Grande', 'rafafloresok@gmail.com', 2964600830),
    ('Carolina', 'Ferrandi', 'Isla de los Estados 684, Ushuaia', 'caroferrandi@gmail.com', 2964594220),
    ('Giovanna', 'Cabrera', 'Kayen 111, Tolhuin', 'gioc@gmail.com', 2901999999),
    ('Lorenzo', 'Flores', 'Rosso 222, San Sebastián', 'lorf@gmail.com', 2901000000),
    ('Sofia', 'Flores', 'Elcano 333, Puerto Almanza', 'sf@gmail.com', 2901555555),
    ('Juan', 'Pérez', 'Laserre 444, Lago Escondido', 'jp@gmail.com', 2901666666);

INSERT INTO user_type_grants (id_user, id_user_type)
VALUES
	(1, 1),
    (2, 2),
    (3, 3),
    (4, 3),
    (5, 3),
    (6, 3);

INSERT INTO move_types (`name`,`description`)
VALUES
	('ingreso externo','ingreso desde otro deposito'),
    ('egreso externo','egreso hacia otro deposito'),
    ('ingreso interno','ingreso desde otra ubicación en el mismo depósito'),
    ('egreso interno','egreso hacia otra ubicación en el mismo depósito'),
    ('ingreso ajuste','ingreso por ajuste de inventario'),
    ('egreso ajuste','egreso por ajuste de inventario');
    
INSERT INTO move_type_grants (id_user_type , id_move_type)
VALUES
	(1, 1),
    (1, 2),
    (1, 3),
    (1, 4),
    (1, 5),
    (1, 6),
    (2, 1),
    (2, 2),
    (2, 3),
    (2, 4),
    (2, 5),
    (2, 6),
    (3, 1),
    (3, 2),
    (3, 3),
    (3, 4);

-- REGISTRAR MOVIMIENTOS DE INSUMOS Y ACTUALIZAR STOCKS USANDO STORED PROCEDURES
-- SIMULAR INGRESOS EN DEPÓSITO 1
CALL record_move('2022-11-01 06:30:00', 'A-001', 1, 110, 1, 1, 1, 1, 1, 1, 3);
CALL record_move('2022-11-01 06:30:00', 'A-001', 1, 120, 2, 1, 1, 1, 1, 2, 3);
CALL record_move('2022-11-01 06:30:00', 'A-001', 1, 130, 3, 1, 1, 1, 2, 1, 3);
CALL record_move('2022-11-01 06:30:00', 'A-001', 1, 1100, 4, 1, 1, 1, 2, 2, 3);
CALL record_move('2022-11-01 06:30:00', 'A-001', 1, 1200, 5, 1, 1, 2, 1, 1, 3);
CALL record_move('2022-11-01 06:30:00', 'A-001', 1, 1300, 6, 1, 1, 2, 1, 2, 3);
-- SIMULAR MOVIMIENTOS INTERNOS EN DEPÓSITO 1
CALL record_internal_move('2022-11-02 9:30:00', 110, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 3);
CALL record_internal_move('2022-11-02 9:30:00', 120, 2, 1, 1, 1, 1, 2, 2, 1, 1, 2, 3);
CALL record_internal_move('2022-11-02 9:30:00', 130, 3, 1, 1, 1, 2, 1, 2, 1, 2, 1, 3);
-- SIMULAR AJUSTES DE INVENTARIO EN DEPÓSITO 1
CALL record_move('2022-11-03 12:30:00', NULL, 5, 10, 4, 1, 1, 1, 2, 2, 2);
CALL record_move('2022-11-03 12:30:00', NULL, 6, 20, 5, 1, 1, 2, 1, 1, 2);
CALL record_move('2022-11-03 12:30:00', NULL, 5, 30, 6, 1, 1, 2, 1, 2, 2);
-- SIMULAR EGRESOS EN DEPÓSITO 1
CALL record_move('2022-11-04 15:30:00', 'A-002', 2, 55, 1, 1, 2, 1, 1, 1, 3);
CALL record_move('2022-11-04 15:30:00', 'A-002', 2, 60, 2, 1, 2, 1, 1, 2, 3);
CALL record_move('2022-11-04 15:30:00', 'A-002', 2, 65, 3, 1, 2, 1, 2, 1, 3);
CALL record_move('2022-11-04 15:30:00', 'A-002', 2, 550, 4, 1, 1, 1, 2, 2, 3);
CALL record_move('2022-11-04 15:30:00', 'A-002', 2, 600, 5, 1, 1, 2, 1, 1, 3);
CALL record_move('2022-11-04 15:30:00', 'A-002', 2, 650, 6, 1, 1, 2, 1, 2, 3);

-- SIMULAR INGRESOS EN DEPÓSITO 2
CALL record_move('2022-11-01 06:30:00', 'A-003', 1, 210, 7, 2, 1, 1, 1, 1, 4);
CALL record_move('2022-11-01 06:30:00', 'A-003', 1, 220, 8, 2, 1, 1, 1, 2, 4);
CALL record_move('2022-11-01 06:30:00', 'A-003', 1, 230, 9, 2, 1, 1, 2, 1, 4);
-- SIMULAR MOVIMIENTOS INTERNOS EN DEPÓSITO 2
CALL record_internal_move('2022-11-02 9:30:00', 210, 7, 2, 1, 1, 1, 1, 2, 1, 1, 1, 4);
CALL record_internal_move('2022-11-02 9:30:00', 220, 8, 2, 1, 1, 1, 2, 2, 1, 1, 2, 4);
CALL record_internal_move('2022-11-02 9:30:00', 230, 9, 2, 1, 1, 2, 1, 2, 1, 2, 1, 4);
-- SIMULAR AJUSTES DE INVENTARIO EN DEPÓSITO 2
CALL record_move('2022-11-03 12:30:00', NULL, 5, 5, 7, 2, 2, 1, 1, 1, 2);
CALL record_move('2022-11-03 12:30:00', NULL, 6, 10, 8, 2, 2, 1, 1, 2, 2);
CALL record_move('2022-11-03 12:30:00', NULL, 5, 15, 9, 2, 2, 1, 2, 1, 2);
-- SIMULAR EGRESOS EN DEPÓSITO 2
CALL record_move('2022-11-04 15:30:00', 'A-004', 2, 105, 7, 2, 2, 1, 1, 1, 4);
CALL record_move('2022-11-04 15:30:00', 'A-004', 2, 110, 8, 2, 2, 1, 1, 2, 4);
CALL record_move('2022-11-04 15:30:00', 'A-004', 2, 115, 9, 2, 2, 1, 2, 1, 4);

-- SIMULAR INGRESOS EN DEPÓSITO 3
CALL record_move('2022-11-01 06:30:00', 'A-005', 1, 21, 10, 3, 1, 1, 1, 1, 5);
CALL record_move('2022-11-01 06:30:00', 'A-005', 1, 22, 11, 3, 1, 1, 1, 2, 5);
CALL record_move('2022-11-01 06:30:00', 'A-005', 1, 23, 12, 3, 1, 1, 2, 1, 5);
-- SIMULAR MOVIMIENTOS INTERNOS EN DEPÓSITO 3
CALL record_internal_move('2022-11-02 9:30:00', 21, 10, 3, 1, 1, 1, 1, 3, 1, 1, 1, 5);
CALL record_internal_move('2022-11-02 9:30:00', 22, 11, 3, 1, 1, 1, 2, 3, 1, 1, 2, 5);
CALL record_internal_move('2022-11-02 9:30:00', 23, 12, 3, 1, 1, 2, 1, 3, 1, 2, 1, 5);
-- SIMULAR AJUSTES DE INVENTARIO EN DEPÓSITO 3
CALL record_move('2022-11-03 12:30:00', NULL, 5, 1, 10, 3, 3, 1, 1, 1, 2);
CALL record_move('2022-11-03 12:30:00', NULL, 6, 2, 11, 3, 3, 1, 1, 2, 2);
CALL record_move('2022-11-03 12:30:00', NULL, 5, 3, 12, 3, 3, 1, 2, 1, 2);
-- SIMULAR EGRESOS EN DEPÓSITO 3
CALL record_move('2022-11-04 15:30:00', 'A-006', 2, 10.5, 10, 3, 3, 1, 1, 1, 5);
CALL record_move('2022-11-04 15:30:00', 'A-006', 2, 11, 11, 3, 3, 1, 1, 2, 5);
CALL record_move('2022-11-04 15:30:00', 'A-006', 2, 11.5, 12, 3, 3, 1, 2, 1, 5);

-- SIMULAR INGRESOS EN DEPÓSITO 4
CALL record_move('2022-11-01 06:30:00', 'A-007', 1, 510, 13, 4, 1, 1, 1, 1, 6);
CALL record_move('2022-11-01 06:30:00', 'A-007', 1, 520, 14, 4, 1, 1, 1, 2, 6);
CALL record_move('2022-11-01 06:30:00', 'A-007', 1, 530, 15, 4, 1, 1, 2, 1, 6);
-- SIMULAR MOVIMIENTOS INTERNOS EN DEPÓSITO 4
CALL record_internal_move('2022-11-02 9:30:00', 510, 13, 4, 1, 1, 1, 1, 1, 2, 1, 1, 6);
CALL record_internal_move('2022-11-02 9:30:00', 520, 14, 4, 1, 1, 1, 2, 1, 2, 1, 2, 6);
CALL record_internal_move('2022-11-02 9:30:00', 530, 15, 4, 1, 1, 2, 1, 1, 2, 2, 1, 6);
-- SIMULAR AJUSTES DE INVENTARIO EN DEPÓSITO 4
CALL record_move('2022-11-03 12:30:00', NULL, 5, 110, 13, 4, 1, 2, 1, 1, 2);
CALL record_move('2022-11-03 12:30:00', NULL, 6, 120, 14, 4, 1, 2, 1, 2, 2);
CALL record_move('2022-11-03 12:30:00', NULL, 5, 130, 15, 4, 1, 2, 2, 1, 2);
-- SIMULAR EGRESOS EN DEPÓSITO 4
CALL record_move('2022-11-04 15:30:00', 'A-008', 2, 255, 13, 4, 1, 2, 1, 1, 6);
CALL record_move('2022-11-04 15:30:00', 'A-008', 2, 260, 14, 4, 1, 2, 1, 2, 6);
CALL record_move('2022-11-04 15:30:00', 'A-008', 2, 265, 15, 4, 1, 2, 2, 1, 6);