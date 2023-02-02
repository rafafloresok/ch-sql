

-- CREAR BBDD Y TABLAS


DROP SCHEMA IF EXISTS sf_stores_flores;

CREATE SCHEMA sf_stores_flores;

USE sf_stores_flores;

CREATE TABLE IF NOT EXISTS meas_units (
    id_meas_unit TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(40) NOT NULL UNIQUE,
    min_unit DECIMAL(6 , 3 ) NOT NULL
);

CREATE TABLE IF NOT EXISTS suppliers (
    id_supplier SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(40) NOT NULL UNIQUE,
    email VARCHAR(80),
    phone BIGINT UNSIGNED,
    address VARCHAR(80)
);

CREATE TABLE IF NOT EXISTS items (
    id_item SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(40) NOT NULL UNIQUE,
    `description` VARCHAR(100),
    id_meas_unit TINYINT UNSIGNED NOT NULL,
    id_supplier SMALLINT UNSIGNED
);

CREATE TABLE IF NOT EXISTS stores (
    id_store TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(40) NOT NULL UNIQUE,
    address VARCHAR(80)
);

CREATE TABLE IF NOT EXISTS place_types (
    id_place_type TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(20) NOT NULL UNIQUE,
    `description` VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS places (
    id_store TINYINT UNSIGNED NOT NULL,
    id_place_type TINYINT UNSIGNED NOT NULL,
    place_number TINYINT UNSIGNED NOT NULL,
    place_h TINYINT UNSIGNED NOT NULL,
    place_v TINYINT UNSIGNED NOT NULL,
	PRIMARY KEY (id_store, id_place_type , place_number , place_h , place_v)
);

CREATE TABLE IF NOT EXISTS users (
    id_user SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    address VARCHAR(80),
    email VARCHAR(80),
    phone BIGINT UNSIGNED
);

CREATE TABLE IF NOT EXISTS user_types (
    id_user_type TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(40) NOT NULL UNIQUE,
    `description` VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS user_type_grants (
    id_user SMALLINT UNSIGNED NOT NULL,
    id_user_type TINYINT UNSIGNED NOT NULL,
    PRIMARY KEY (id_user , id_user_type)
);

CREATE TABLE IF NOT EXISTS move_types (
    id_move_type TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(40) NOT NULL UNIQUE,
    `description` VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS move_type_grants (
	id_user_type TINYINT UNSIGNED NOT NULL,
    id_move_type TINYINT UNSIGNED NOT NULL,
    PRIMARY KEY (id_user_type , id_move_type)
);

CREATE TABLE IF NOT EXISTS moves (
    id MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_time DATETIME NOT NULL,
    receipt VARCHAR(40) DEFAULT NULL,
    id_move_type TINYINT UNSIGNED NOT NULL,
    quantity DECIMAL(12, 3) NOT NULL,
    id_item SMALLINT UNSIGNED NOT NULL,
    id_store TINYINT UNSIGNED NOT NULL,
    id_place_type TINYINT UNSIGNED NOT NULL,
    place_number TINYINT UNSIGNED NOT NULL,
    place_h TINYINT UNSIGNED NOT NULL,
    place_v TINYINT UNSIGNED NOT NULL,
    id_user SMALLINT UNSIGNED NOT NULL
);

CREATE TABLE IF NOT EXISTS stock (
    id_item SMALLINT UNSIGNED NOT NULL,
    id_store TINYINT UNSIGNED NOT NULL,
    id_place_type TINYINT UNSIGNED NOT NULL,
    place_number TINYINT UNSIGNED NOT NULL,
    place_h TINYINT UNSIGNED NOT NULL,
    place_v TINYINT UNSIGNED NOT NULL,
    quantity DECIMAL(12, 3) NOT NULL,
    PRIMARY KEY (id_item, id_store, id_place_type , place_number , place_h , place_v)
);

CREATE TABLE IF NOT EXISTS log_stock_adjustments (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	id_move MEDIUMINT UNSIGNED NOT NULL, 
    user_full_name VARCHAR(81) NOT NULL, 
    issue_date_time DATETIME NOT NULL, 
    issue_sys_user VARCHAR(60) NOT NULL
);

CREATE TABLE IF NOT EXISTS log_user_type_grants (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_full_name VARCHAR(81) NOT NULL,
    user_type VARCHAR(40) NOT NULL,
    issue_action VARCHAR(10) NOT NULL,
    issue_date_time DATETIME NOT NULL,
    issue_sys_user VARCHAR(60) NOT NULL
);

CREATE TABLE IF NOT EXISTS log_del_alter_moves (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_move MEDIUMINT UNSIGNED NOT NULL,
    date_time DATETIME NOT NULL,
    receipt VARCHAR(40) DEFAULT NULL,
    id_move_type TINYINT UNSIGNED NOT NULL,
    quantity DECIMAL(12, 3) NOT NULL,
    id_item SMALLINT UNSIGNED NOT NULL,
    id_store TINYINT UNSIGNED NOT NULL,
    id_place_type TINYINT UNSIGNED NOT NULL,
    place_number TINYINT UNSIGNED NOT NULL,
    place_h TINYINT UNSIGNED NOT NULL,
    place_v TINYINT UNSIGNED NOT NULL,
    id_user SMALLINT UNSIGNED NOT NULL,
    issue_action VARCHAR(10) NOT NULL,
    issue_date_time DATETIME NOT NULL,
    issue_sys_user VARCHAR(60) NOT NULL
);


-- CREAR RELACIONES


ALTER TABLE items ADD FOREIGN KEY (id_meas_unit) REFERENCES meas_units (id_meas_unit);
ALTER TABLE items ADD FOREIGN KEY (id_supplier) REFERENCES suppliers (id_supplier);

ALTER TABLE places ADD FOREIGN KEY (id_store) REFERENCES stores (id_store);
ALTER TABLE places ADD FOREIGN KEY (id_place_type) REFERENCES place_types (id_place_type);

ALTER TABLE user_type_grants ADD FOREIGN KEY (id_user) REFERENCES users (id_user);
ALTER TABLE user_type_grants ADD FOREIGN KEY (id_user_type) REFERENCES user_types (id_user_type);

ALTER TABLE move_type_grants ADD FOREIGN KEY (id_user_type) REFERENCES user_types (id_user_type);
ALTER TABLE move_type_grants ADD FOREIGN KEY (id_move_type) REFERENCES move_types (id_move_type);

ALTER TABLE moves ADD FOREIGN KEY (id_move_type) REFERENCES move_types (id_move_type);
ALTER TABLE moves ADD FOREIGN KEY (id_item) REFERENCES items (id_item);
ALTER TABLE moves ADD FOREIGN KEY (id_store, id_place_type, place_number, place_h, place_v) REFERENCES places (id_store, id_place_type, place_number, place_h, place_v);
ALTER TABLE moves ADD FOREIGN KEY (id_user) REFERENCES users (id_user);

ALTER TABLE stock ADD FOREIGN KEY (id_item) REFERENCES items (id_item);
ALTER TABLE stock ADD FOREIGN KEY (id_store, id_place_type, place_number, place_h, place_v) REFERENCES places (id_store, id_place_type, place_number, place_h, place_v);


-- CREAR FUNCIONES


DELIMITER $$
-- Función para saber si el usuario está autorizado a hacer determinado tipo de movimiento
DROP FUNCTION IF EXISTS `user_can_do_move`$$
CREATE FUNCTION `user_can_do_move` (idUser SMALLINT UNSIGNED, idMoveType TINYINT UNSIGNED)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
	RETURN ((SELECT count(*) FROM user_type_grants JOIN move_type_grants ON (user_type_grants.id_user_type = move_type_grants.id_user_type) WHERE id_user = idUser AND id_move_type = idMoveType) > 0);
END$$

-- Función para saber si el usuario tiene asignado determinado tipo de usuario
DROP FUNCTION IF EXISTS `user_has_user_type`$$
CREATE FUNCTION `user_has_user_type` (idUser SMALLINT UNSIGNED, idUserType TINYINT UNSIGNED)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    RETURN (SELECT count(*) FROM user_type_grants WHERE id_user = idUser AND id_user_type = idUserType);
END$$

-- Función para devolver nombre completo de usuario
DROP FUNCTION IF EXISTS `full_user_name`$$ 
CREATE FUNCTION `full_user_name` (idUser SMALLINT UNSIGNED)
RETURNS VARCHAR(81)
READS SQL DATA
BEGIN
	DECLARE firstName VARCHAR(40);
    DECLARE lastName VARCHAR(40);
    
    SET firstName = (SELECT first_name FROM users WHERE id_user = idUser);
    SET lastName = (SELECT last_name FROM users WHERE id_user = idUser);
    
    RETURN (concat(firstName, ' ', lastName));
END$$

-- función para verificar cantidad en stock de un item en una ubicación
DROP FUNCTION IF EXISTS `qty_in_place`$$
CREATE FUNCTION `qty_in_place` (idItem SMALLINT UNSIGNED, idStore TINYINT UNSIGNED, idPlaceType TINYINT UNSIGNED, placeNumber TINYINT UNSIGNED, placeH TINYINT UNSIGNED, placeV TINYINT UNSIGNED)
RETURNS DECIMAL(12, 3)
READS SQL DATA
BEGIN
	DECLARE qty DECIMAL(12, 3);
    
    SET qty = (SELECT quantity FROM stock WHERE id_item = idItem AND id_store = idStore AND id_place_type = idPlaceType AND place_number = placeNumber AND place_h = placeH AND place_v = placeV);
    
    IF (qty IS NULL) THEN
		SET qty = 0;
	END IF;
    
    RETURN qty;
END$$

-- función para devolver signo de tipo de movimiento. Si es ingreso devolverá 1, si es egreso devolverá -1, en otro caso devolverá 0
-- Se usará para determinar el signo de la cantidad movida
DROP FUNCTION IF EXISTS `move_sign`$$
CREATE FUNCTION `move_sign` (idMoveType TINYINT UNSIGNED)
RETURNS INT
READS SQL DATA
BEGIN
	DECLARE sign TINYINT;
    DECLARE isInput BOOLEAN;
    DECLARE isOutput BOOLEAN;
    
    SET isInput = (idMoveType IN (SELECT id_move_type FROM move_types WHERE `name` LIKE 'ingreso%'));
    SET isOutput = (idMoveType IN (SELECT id_move_type FROM move_types WHERE `name` LIKE 'egreso%'));
    
    IF (isInput) THEN
		SET sign = 1;
	ELSEIF (isOutput) THEN
		SET sign = -1;
	ELSE
		SET sign = 0;
	END IF;
    
    RETURN sign;
END$$
DELIMITER ;


-- CREAR STORED PROCEDURES


DELIMITER $$
-- SP para actualizar stock
-- Se pasa por parámetro el id del movimiento correspondiente y un booleano que indicará si es un movimiento para deshacer.
-- Se utilizará en los SP record_move, record internal move, modify_move y delete_move
DROP PROCEDURE IF EXISTS `update_stock`$$
CREATE PROCEDURE `update_stock` (IN idMove MEDIUMINT UNSIGNED,IN goBack BOOLEAN)
READS SQL DATA
BEGIN
	DECLARE idMoveType TINYINT UNSIGNED;
    DECLARE qty DECIMAL(12,3);
	DECLARE idItem SMALLINT UNSIGNED;
    DECLARE idStore TINYINT UNSIGNED;
    DECLARE idPlaceType TINYINT UNSIGNED;
    DECLARE placeNumber TINYINT UNSIGNED;
    DECLARE placeH TINYINT UNSIGNED;
    DECLARE placeV TINYINT UNSIGNED;
    DECLARE qtyInPlace DECIMAL(12, 3);
    DECLARE newQtyInPlace DECIMAL(12, 3);
    DECLARE goBackSign TINYINT DEFAULT 1;
    DECLARE stockRecordExists BOOLEAN;
    
	SET idMoveType = (SELECT id_move_type FROM moves WHERE id = idMove);
	SET qty = (SELECT quantity FROM moves WHERE id = idMove);
	SET idItem = (SELECT id_item FROM moves WHERE id = idMove);
	SET idStore = (SELECT id_store FROM moves WHERE id = idMove);
	SET idPlaceType = (SELECT id_place_type FROM moves WHERE id = idMove);
	SET placeNumber = (SELECT place_number FROM moves WHERE id = idMove);
	SET placeH = (SELECT place_h FROM moves WHERE id = idMove);
	SET placeV = (SELECT place_v FROM moves WHERE id = idMove);
    
	-- verificar cantidad del item en la ubicación correspondiente al movimiento
	SET qtyInPlace = qty_in_place(idItem, idStore, idPlaceType, placeNumber, placeH, placeV);
    
    -- cambiar el signo de la cantidad movida en caso de ser un movimiento para deshacer
    IF (goBack) THEN
		SET goBackSign = -1;
	END IF;
    
	-- setear la nueva cantidad, pasando a negativo la cantidad movida en caso de ser egreso
    SET newQtyInPlace = qtyInPlace + (qty * move_sign(idMoveType) * goBackSign);
    
	-- si el registro ya existe lo modifica, si no lo inserta
    SET stockRecordExists = (SELECT count(*) from stock where id_item = idItem and id_store = idStore and id_place_type = idPlaceType and place_number = placeNumber and place_h = placeH and place_v = placeV);
    IF stockRecordExists THEN
		UPDATE stock
		SET quantity = newQtyInPlace
		WHERE id_item = idItem AND id_store = idStore AND id_place_type = idPlaceType AND place_number = placeNumber AND place_h = placeH AND place_v = placeV;
    ELSE
		INSERT INTO stock (id_item, id_store, id_place_type, place_number, place_h, place_v, quantity)
		VALUE (idItem, idStore, idPlaceType, placeNumber, placeH, placeV, newQtyInPlace);
	END IF;
END$$

-- SP para registrar movimientos y actualizar stock
DROP PROCEDURE IF EXISTS `record_move`$$
CREATE PROCEDURE `record_move`
	(IN dateAndTime DATETIME,
	IN receiptNum VARCHAR(40),
	IN idMoveType TINYINT UNSIGNED,
    IN qty DECIMAL(12,3),
	IN idItem SMALLINT UNSIGNED,
    IN idStore TINYINT UNSIGNED,
    IN idPlaceType TINYINT UNSIGNED,
    IN placeNumber TINYINT UNSIGNED,
    IN placeH TINYINT UNSIGNED,
    IN placeV TINYINT UNSIGNED,
    IN idUser SMALLINT UNSIGNED)
READS SQL DATA
BEGIN
    DECLARE moveTypeError VARCHAR(100) DEFAULT NULL;
    DECLARE finalQtyInPlace DECIMAL(12, 3);
    DECLARE stockError VARCHAR(100) DEFAULT NULL;
	
	START TRANSACTION;
		-- verificar si el usuario está autorizado a realizar el movimiento
        IF (NOT user_can_do_move(idUser, idMoveType)) THEN
			SET moveTypeError = 'el usuario no está autorizado a realizar este tipo de movimiento';
        END IF;
        
		-- insertar datos en la tabla moves
		INSERT INTO moves (date_time, receipt, id_move_type, quantity, id_item, id_store, id_place_type, place_number, place_h, place_v, id_user)
		VALUE (dateAndTime, receiptNum, idMoveType, qty, idItem, idStore, idPlaceType, placeNumber, placeH, placeV, idUser);
		
		-- actualizar stock, pasando por parámetro el id del movimiento insertado previamente
        CALL `update_stock` (LAST_INSERT_ID(), 0);
		
		-- si la cantidad final es menor a cero setear error de stock
		SET finalQtyInPlace = qty_in_place(idItem, idStore, idPlaceType, placeNumber, placeH, placeV);
		IF (finalQtyInPlace < 0) THEN
			SET stockError = 'sin stock suficiente para realizar el movimiento';
		END IF;
        
        -- si la cantidad final quedó en cero, elimina el registro en stock (para no guardar un dato innecesario y evitar errores)
        IF (finalQtyInPlace = 0) THEN
			DELETE FROM stock
			WHERE (id_item = idItem AND id_store = idStore AND id_place_type = idPlaceType AND place_number = placeNumber AND place_h = placeH AND place_v = placeV);
		END IF;
        
	-- si no hay errores comitea. si hay errores vuelve todo para atrás y muestra los errores
	IF ((moveTypeError IS NULL) AND (stockError IS NULL)) THEN
		COMMIT;
	ELSE
		ROLLBACK;
		SELECT moveTypeError AS move_type_error, stockError AS stock_error;
	END IF;
END$$

-- SP para registrar movimientos internos (egreso interno + ingreso interno) y actualizar stock
DROP PROCEDURE IF EXISTS `record_internal_move`$$
CREATE PROCEDURE `record_internal_move`
	(IN dateAndTime DATETIME,
    IN qty DECIMAL(12,3),
	IN idItem SMALLINT UNSIGNED,
    IN idStore TINYINT UNSIGNED,
    IN fromIdPlaceType TINYINT UNSIGNED,
    IN fromPlaceNumber TINYINT UNSIGNED,
    IN fromPlaceH TINYINT UNSIGNED,
    IN fromPlaceV TINYINT UNSIGNED,
    IN toIdPlaceType TINYINT UNSIGNED,
    IN toPlaceNumber TINYINT UNSIGNED,
    IN toPlaceH TINYINT UNSIGNED,
    IN toPlaceV TINYINT UNSIGNED,
    IN idUser SMALLINT UNSIGNED)
READS SQL DATA
BEGIN
	DECLARE moveTypeError VARCHAR(100) DEFAULT NULL;
    DECLARE idMove MEDIUMINT UNSIGNED;
    DECLARE finalQtyInPlace DECIMAL(12, 3);
    DECLARE stockError VARCHAR(100) DEFAULT NULL;
    
	START TRANSACTION;
        -- verificar si el usuario está autorizado a realizar el movimiento "egreso interno"
        IF (NOT user_can_do_move(idUser, 4)) THEN
			SET moveTypeError = 'el usuario no está autorizado a realizar este tipo de movimiento';
        END IF;
    
		-- insertar egreso en la tabla moves
		INSERT INTO moves (date_time, id_move_type, quantity, id_item, id_store, id_place_type, place_number, place_h, place_v, id_user)
		VALUE (dateAndTime, 4, qty, idItem, idStore, fromIdPlaceType, fromPlaceNumber, fromPlaceH, fromPlaceV, idUser);
    
		-- actualizar stock, pasando por parámetro el id del movimiento insertado previamente
		CALL `update_stock` (LAST_INSERT_ID(), 0);
        
		-- si la cantidad final en origen es menor a cero setear error de stock	
        SET finalQtyInPlace = qty_in_place(idItem, idStore, fromIdPlaceType, fromPlaceNumber, fromPlaceH, fromPlaceV);
		IF (finalQtyInPlace < 0) THEN
			SET stockError = 'sin stock suficiente en origen para realizar el movimiento';
		END IF;
        
        -- si la cantidad final en origen quedó en cero, elimina el registro en stock (para no guardar un dato innecesario y evitar errores)
        IF (finalQtyInPlace = 0) THEN
			DELETE FROM stock
			WHERE (id_item = idItem AND id_store = idStore AND id_place_type = fromIdPlaceType AND place_number = fromPlaceNumber AND place_h = fromPlaceH AND place_v = fromPlaceV);
		END IF;
        
        -- verificar si el usuario está autorizado a realizar el movimiento "ingreso interno"
        IF (NOT user_can_do_move(idUser, 3)) THEN
			SET moveTypeError = 'el usuario no está autorizado a realizar este tipo de movimiento';
        END IF;
    
		-- insertar ingreso en la tabla moves
		INSERT INTO moves (date_time, id_move_type, quantity, id_item, id_store, id_place_type, place_number, place_h, place_v, id_user)
		VALUE (dateAndTime, 3, qty, idItem, idStore, toIdPlaceType, toPlaceNumber, toPlaceH, toPlaceV, idUser);
        
		-- actualizar stock, pasando por parámetro el id del movimiento insertado previamente
		CALL `update_stock` (LAST_INSERT_ID(), 0);
	
    -- si no hay errores comitea. si hay errores vuelve todo para atrás y muestra los errores
	IF ((moveTypeError IS NULL) AND (stockError IS NULL)) THEN
		COMMIT;
	ELSE
		ROLLBACK;
		SELECT moveTypeError AS move_type_error, stockError AS stock_error;
	END IF;
END$$

-- SP para eliminar movimientos y actualizar stock
DROP PROCEDURE IF EXISTS `delete_move`$$
CREATE PROCEDURE `delete_move` (
	IN idMove MEDIUMINT UNSIGNED,
    IN idUser SMALLINT UNSIGNED)
READS SQL DATA
BEGIN
    DECLARE moveTypeError VARCHAR(100) DEFAULT NULL;
    DECLARE finalQtyInPlace DECIMAL(12, 3);
    DECLARE stockError VARCHAR(100) DEFAULT NULL;
    DECLARE idItem SMALLINT UNSIGNED;
    DECLARE idStore TINYINT UNSIGNED;
    DECLARE idPlaceType TINYINT UNSIGNED;
    DECLARE placeNumber TINYINT UNSIGNED;
    DECLARE placeH TINYINT UNSIGNED;
    DECLARE placeV TINYINT UNSIGNED;
	
	START TRANSACTION;
		SET idItem = (SELECT id_item FROM moves WHERE id = idMove);
        SET idStore = (SELECT id_store FROM moves WHERE id = idMove);
        SET idPlaceType = (SELECT id_place_type FROM moves WHERE id = idMove);
        SET placeNumber = (SELECT place_number FROM moves WHERE id = idMove);
        SET placeH = (SELECT place_h FROM moves WHERE id = idMove);
        SET placeV = (SELECT place_v FROM moves WHERE id = idMove);
    
		-- verificar si el usuario es administrador
		IF NOT(user_has_user_type(idUser, 1)) THEN
			SET moveTypeError = 'el usuario no está autorizado a realizar este tipo de operación';
		END IF;
        
        -- deshacer cambios en tabla stock, hechos con valores del movimiento a eliminar
		CALL `update_stock` (idMove, 1);
        
        -- si la cantidad final es menor a cero setear error de stock
		SET finalQtyInPlace = qty_in_place(idItem, idStore, idPlaceType, placeNumber, placeH, placeV);
		IF (finalQtyInPlace < 0) THEN
			SET stockError = 'sin stock suficiente para realizar el borrado';
		END IF;
        
        -- si la cantidad final quedó en cero, elimina el registro en stock (para no guardar un dato innecesario y evitar errores)
        IF (finalQtyInPlace = 0) THEN
			DELETE FROM stock
			WHERE (id_item = idItem AND id_store = idStore AND id_place_type = idPlaceType AND place_number = placeNumber AND place_h = placeH AND place_v = placeV);
		END IF;
        
		-- eliminar datos en la tabla moves
		DELETE FROM moves
        WHERE id = idMove;
        
	-- si no hay errores comitea. si hay errores vuelve todo para atrás y muestra los errores
	IF ((moveTypeError IS NULL) AND (stockError IS NULL)) THEN
		COMMIT;
	ELSE
		ROLLBACK;
		SELECT moveTypeError AS move_type_error, stockError AS stock_error;
	END IF;
END$$

-- SP para modificar movimientos y actualizar stock
DROP PROCEDURE IF EXISTS `modify_move`$$
CREATE PROCEDURE `modify_move`
	(IN idMove MEDIUMINT UNSIGNED, IN field VARCHAR(20), IN newValue VARCHAR(20), IN idUser SMALLINT UNSIGNED)
READS SQL DATA
BEGIN
    DECLARE stockError VARCHAR(100) DEFAULT NULL;
    DECLARE moveTypeError VARCHAR(100) DEFAULT NULL;
	DECLARE fieldIsNumberType BOOLEAN;
    DECLARE sentence VARCHAR(100);
    DECLARE finalQtyInPlace DECIMAL(12, 3);
    DECLARE idItem SMALLINT UNSIGNED;
    DECLARE idStore TINYINT UNSIGNED;
    DECLARE idPlaceType TINYINT UNSIGNED;
    DECLARE placeNumber TINYINT UNSIGNED;
    DECLARE placeH TINYINT UNSIGNED;
    DECLARE placeV TINYINT UNSIGNED;
    
    START TRANSACTION;
		SET idItem = (SELECT id_item FROM moves WHERE id = idMove);
        SET idStore = (SELECT id_store FROM moves WHERE id = idMove);
        SET idPlaceType = (SELECT id_place_type FROM moves WHERE id = idMove);
        SET placeNumber = (SELECT place_number FROM moves WHERE id = idMove);
        SET placeH = (SELECT place_h FROM moves WHERE id = idMove);
        SET placeV = (SELECT place_v FROM moves WHERE id = idMove);
        
		-- verificar si el usuario es administrador
		IF NOT(user_has_user_type(idUser, 1)) THEN
			SET moveTypeError = 'el usuario no está autorizado a realizar este tipo de operación';
		END IF;
    
		-- deshacer cambios en tabla stock, hechos con valores previos del movimiento a modificar
		CALL `update_stock` (idMove, 1);
    
		-- hacer cambios en el movimiento correspondiente
        -- determinar si el campo a modificar es de tipo número (o string), para construir la clausula de forma correcta según el caso
		SET fieldIsNumberType = (field <> 'date_time' AND field <> 'receipt');
		IF fieldIsNumberType THEN
			SET @sentence = concat('UPDATE moves SET ', field, ' = ', newValue, ' WHERE id = ', idMove, ';');
		ELSE
			SET @sentence = concat('UPDATE moves SET ', field, ' = \'', newValue, '\' WHERE id = ', idMove, ';');
		END IF;
		PREPARE SQLsentence FROM @sentence;
		EXECUTE SQLsentence;
		DEALLOCATE PREPARE SQLsentence;
    
		-- hacer cambios en tabla stock, con valores nuevos del movimiento modificado
		CALL `update_stock` (idMove, 0);
        
        -- si la cantidad final es menor a cero setear error de stock
		SET finalQtyInPlace = qty_in_place(idItem, idStore, idPlaceType, placeNumber, placeH, placeV);
		IF (finalQtyInPlace < 0) THEN
			SET stockError = 'sin stock suficiente para realizar el cambio';
		END IF;
    
		-- si la cantidad final quedó en cero, elimina el registro en stock (para no guardar un dato innecesario y evitar errores)
        IF (finalQtyInPlace = 0) THEN
			DELETE FROM stock
			WHERE (id_item = idItem AND id_store = idStore AND id_place_type = idPlaceType AND place_number = placeNumber AND place_h = placeH AND place_v = placeV);
		END IF;
    
	-- si no hay errores comitea. si hay errores vuelve todo para atrás y muestra los errores
	IF ((moveTypeError IS NULL) AND (stockError IS NULL)) THEN
		COMMIT;
	ELSE
		ROLLBACK;
		SELECT moveTypeError AS move_type_error, stockError AS stock_error;
	END IF;
END$$
DELIMITER ;


-- CREAR VISTAS


-- Detalle de movimientos
CREATE OR REPLACE VIEW v_moves_detail AS
	(SELECT
		m.id AS id_movimiento,
        m.date_time AS fecha_hora,
        m.receipt AS remito,
        mt.`name` AS tipo_movimiento,
        m.quantity AS cantidad,
        mu.`name` AS unidad,
		i.`name` AS insumo,
        s.`name` AS deposito,
        concat_ws(' - ', pt.`name`, m.place_number, m.place_h, m.place_v) AS ubicacion
	FROM
		moves AS m
			JOIN
		items AS i ON (m.id_item = i.id_item)
			JOIN
		move_types AS mt ON (m.id_move_type = mt.id_move_type)
			JOIN
		stores AS s ON (m.id_store = s.id_store)
			JOIN
		meas_units AS mu ON (i.id_meas_unit = mu.id_meas_unit)
			JOIN
		place_types AS pt ON (m.id_place_type = pt.id_place_type)
	ORDER BY m.id DESC
    );

-- Detalle de stock
CREATE OR REPLACE VIEW v_stock_detail AS
	(SELECT
		i.`name` AS nombre_insumo,
        sr.`name` AS depósito,
        concat_ws(' - ', pt.`name`, s.place_number, s.place_h, s.place_v) AS ubicacion,
        s.quantity AS cantidad,
        mu.`name` AS unidad
	FROM
		stock AS s
			JOIN
		items AS i ON (s.id_item = i.id_item)
			JOIN
		stores AS sr ON (s.id_store = sr.id_store)
			JOIN
		place_types AS pt ON (s.id_place_type = pt.id_place_type)
			JOIN
		meas_units AS mu ON (i.id_meas_unit = mu.id_meas_unit)
	ORDER BY nombre_insumo
    );

-- Cantidad de ubicaciones por depósito y ubicaciones utilizadas
CREATE OR REPLACE VIEW v_places_count AS
    (SELECT
        s.`name` AS deposito,
        count(distinct concat(p.id_store, p.id_place_type, p.place_number, p.place_h, p.place_v)) AS cantidad_ubicaciones,
        count(distinct concat(sk.id_store, sk.id_place_type, sk.place_number, sk.place_h, sk.place_v)) AS ubicaciones_utilizadas
    FROM
        stores AS s
            LEFT JOIN
        places AS p ON (s.id_store = p.id_store)
			LEFT JOIN
		stock AS sk ON (s.id_store = sk.id_store)
    GROUP BY s.`name`
    ORDER BY cantidad_ubicaciones DESC);

-- Proveedor de cada insumo
CREATE OR REPLACE VIEW v_items_suppliers AS
    (SELECT 
        i.`name` AS item, s.`name` AS proveedor
    FROM
        items AS i
            JOIN
        suppliers AS s ON (i.id_supplier = s.id_supplier)
    ORDER BY i.`name`);

-- Información de remitos
CREATE OR REPLACE VIEW v_receipt_info AS
    (SELECT DISTINCT
        m.receipt AS remito,
        m.date_time AS fecha_hora,
        s.`name` AS deposito,
        mt.`name` AS tipo_movimiento,
        full_user_name(u.id_user) AS operador
    FROM
        moves AS m
            JOIN
        stores AS s ON (m.id_store = s.id_store)
            JOIN
        move_types AS mt ON (m.id_move_type = mt.id_move_type)
            JOIN
        users AS u ON (m.id_user = u.id_user)
    WHERE
        m.receipt IS NOT NULL
    ORDER BY m.receipt DESC);


-- CREAR TRIGGERS


-- Trigger para registrar cada vez que se hace un movimiento del tipo "ajuste"
-- Útil para realizar un seguimiento de los ajustes de stock
DELIMITER $$
DROP TRIGGER IF EXISTS `ai_record_stock_adjustment`$$
CREATE TRIGGER `ai_record_stock_adjustment`
AFTER INSERT ON moves
FOR EACH ROW
BEGIN
	DECLARE is_adjustment BOOLEAN;
    SET is_adjustment = (NEW.id_move_type IN (SELECT id_move_type FROM move_types WHERE `name` LIKE '%ajuste%'));
	IF is_adjustment THEN
		INSERT INTO log_stock_adjustments (id_move, user_full_name, issue_date_time, issue_sys_user)
        VALUE (NEW.id, full_user_name(NEW.id_user), now(), system_user());
    END IF;
END$$

-- Trigger para registrar cada vez que se asigna un tipo de usuario a un usuario
DROP TRIGGER IF EXISTS `ai_record_allowed_user_type`$$
CREATE TRIGGER `ai_record_allowed_user_type`
AFTER INSERT ON user_type_grants
FOR EACH ROW
BEGIN
	INSERT INTO log_user_type_grants (user_full_name, user_type, issue_action, issue_date_time, issue_sys_user)
    VALUE (full_user_name(NEW.id_user), (SELECT `name` FROM user_types WHERE id_user_type = NEW.id_user_type), 'insert', now(), system_user());
END$$

-- Trigger para registrar cada vez que se denega un tipo de usuario a un usuario
DROP TRIGGER IF EXISTS `ad_record_disallowed_user_type`$$
CREATE TRIGGER `ad_record_disallowed_user_type`
AFTER DELETE ON user_type_grants
FOR EACH ROW
BEGIN
	INSERT INTO log_user_type_grants (user_full_name, user_type, issue_action, issue_date_time, issue_sys_user)
    VALUE (full_user_name(OLD.id_user), (SELECT `name` FROM user_types WHERE id_user_type = OLD.id_user_type), 'delete', now(), system_user());
END$$

-- Trigger para registrar datos anteriores cada vez que se sobreescribe un registro de la tabla moves
-- Útil para no perder los datos sobreescritos
DROP TRIGGER IF EXISTS `bu_record_modified_move`$$
CREATE TRIGGER `bu_record_modified_move`
BEFORE UPDATE ON moves
FOR EACH ROW
BEGIN
	INSERT INTO log_del_alter_moves (id_move, date_time, receipt, id_move_type, quantity, id_item, id_store, id_place_type, place_number, place_h, place_v, id_user, issue_action, issue_date_time, issue_sys_user)
	VALUE (OLD.id, OLD.date_time, OLD.receipt, OLD.id_move_type, OLD.quantity, OLD.id_item, OLD.id_store, OLD.id_place_type, OLD.place_number, OLD.place_h, OLD.place_v, OLD.id_user, 'update', now(), system_user());
END$$

-- Trigger para registrar datos anteriores cada vez que se elimina un registro de la tabla moves
-- Útil para no perder los datos borrados
DROP TRIGGER IF EXISTS `bd_record_deleted_move`$$
CREATE TRIGGER `bd_record_deleted_move`
BEFORE DELETE ON moves
FOR EACH ROW
BEGIN
	INSERT INTO log_del_alter_moves (id_move, date_time, receipt, id_move_type, quantity, id_item, id_store, id_place_type, place_number, place_h, place_v, id_user, issue_action, issue_date_time, issue_sys_user)
	VALUE (OLD.id, OLD.date_time, OLD.receipt, OLD.id_move_type, OLD.quantity, OLD.id_item, OLD.id_store, OLD.id_place_type, OLD.place_number, OLD.place_h, OLD.place_v, OLD.id_user, 'delete', now(), system_user());
END$$
DELIMITER ;
