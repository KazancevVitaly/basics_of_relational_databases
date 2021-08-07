/* Практическое задание к уроку 9 курса Базы Данных*/
/* Транзакции, переменные, представления*/
/* Задача 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных.
 * Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции. */

DROP DATABASE IF EXISTS sample;
CREATE DATABASE sample;
USE sample;

DROP TABLE IF EXISTS users;
CREATE TABLE users(
	id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(45) NOT NULL,
	birthday_at DATE DEFAULT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT id, name, birthday_at, created_at, updated_at 
FROM users;

START TRANSACTION;
INSERT INTO sample.users 
SELECT id, name, birthday_at, created_at, updated_at 
FROM shop.users WHERE id = 1;
COMMIT;

SELECT id, name, birthday_at, created_at, updated_at 
FROM users;

/* ЗАДАЧА 2. Создайте представление, которое выводит название name товарной позиции из таблицы products
 * и соответствующее название каталога name из таблицы catalogs.*/

USE shop;
CREATE OR REPLACE VIEW prods_desc(prod_id, prod_name, cat_name) AS
SELECT p.id prod_id, p.name, cat.name
FROM products p
LEFT JOIN catalogs cat 
ON p.catalog_id = cat.id;

SELECT prod_id, prod_name, cat_name FROM prods_desc;

/* Хранимые процедуры и функции, триггеры. */
/* Задача 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток.
 * С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
 * с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
 * с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи". */

DROP PROCEDURE IF EXISTS hello;
DELIMITER //
CREATE PROCEDURE hello()
BEGIN
	CASE 
		WHEN CURRENT_TIME() BETWEEN '06:00:00' AND '12:00:00' THEN
			SELECT 'Доброе утро';
		WHEN CURRENT_TIME() BETWEEN '12:00:00' AND '18:00:00' THEN
			SELECT 'Добрый день';
		WHEN CURRENT_TIME() BETWEEN '18:00:00' AND '00:00:00' THEN
			SELECT 'Добрый вечер';
		ELSE
			SELECT 'Доброй ночи';
	END CASE;
END //
DELIMITER ;

CALL hello(); -- Все время возвращает доброй ночи вне зависимости от того сколько времени  на моем компьютере
-- Не знаю, принципиально ли сделать именно функцию

DROP FUNCTION IF EXISTS hello;
DELIMITER $$
CREATE FUNCTION hello()
	RETURNS VARCHAR(100) DETERMINISTIC
BEGIN
	IF (CURRENT_TIME BETWEEN'06:00:00' AND'12:00:00') THEN
	RETURN ('доброе утро');
	ELSEIF (CURRENT_TIME BETWEEN '12:00:00' AND '18:00:00') THEN
	RETURN ('добрый день');
	ELSEIF (CURRENT_TIME BETWEEN '18:00:00' AND '00:00:00') THEN 
	RETURN ('добрый вечер');
	ELSE
	RETURN ('доброй ночи');
	END IF;
END$$
DELIMITER ;

SELECT hello(); 
-- THEN после IF !!!!! 
-- select current_time();

/*Задача 2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
 * Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
 * Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
 * При попытке присвоить полям NULL-значение необходимо отменить операцию. */

DROP TRIGGER IF EXISTS not_null_trigger;
DELIMITER $$
CREATE TRIGGER not_null_trigger BEFORE INSERT ON products
FOR EACH ROW
BEGIN
	IF(ISNULL(NEW.name) AND ISNULL(NEW.description)) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Полe name и поле description не могут быть одновременно NULL';
	END IF;
END $$
DELIMITER ;

INSERT INTO products 
	(name, description, price, catalog_id)
VALUES
	(NULL, NULL, 11500, 2);





