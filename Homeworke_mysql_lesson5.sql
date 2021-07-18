/*Практическое задание по теме «Операторы, фильтрация, сортировка и ограничение»*/

/* ЗАДАЧА1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. 
   Заполните их текущими датой и временем. */

-- ДЛЯ ВЫПОЛНЕНИЯ ЗАДАЧИ СОЗДАДИМ БД С ЗАДАННЫМИ УСЛОВИЯМИ.
DROP DATABASE IF EXISTS homework_mysql_lesson5;
CREATE DATABASE homework_mysql_lesson5;
USE homework_mysql_lesson5;

-- СОЗДАДИМ ТАБЛИЦУ users.
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) COMMENT 'Имя покупателя',
    birthday_at DATE COMMENT 'Дата рождения',
    created_at DATETIME,
    updated_at DATETIME
);

-- ЗАПОЛНИМ ТАБЛИЦУ users ОСТАВИВ ПОЛЯ created_at и updeted_at незаполненными.
INSERT IGNORE INTO users (name, birthday_at)
VALUES
('Kate', '1980-05-20'),
('Leo', '1981-07-10'),
('Jon', '1990-01-01'),
('Mark', '1995-02-28'),
('Helen', '1987-09-19');

-- ПОЛЯ create_at и updeted_at заполнены значением NULL.
-- ЗАПОЛНИМ ЭТИ ПОЛЯ ТЕКУЩЕЙ ДАТОЙ И ВРЕМЕНЕМ.

UPDATE users
SET
	created_at = NOW(),
	updated_at = NOW(); -- в условии задачи не сказано какие именно данные нужно заменить, поэтому не указываем WHERE.
/*
WHERE
*/
	
	
/* ЗАДАЧА 2. Таблица users была неудачно спроектирована. 
   Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. 
   Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения. */

-- ПЕРЕСОЗДАДИМ ТАБЛИЦУ users, ЗАМЕНИВ created_at и updated_at типом VARCHAR, для соответсвтия условиям задачи

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) COMMENT 'Имя покупателя',
    birthday_at DATE COMMENT 'Дата рождения',
    created_at VARCHAR(100),
    updated_at VARCHAR(100)
);

-- ВНЕСМ В ТАБЛИЦУ НЕОБХОДИМЫЕ ДАННЫЕ
INSERT IGNORE INTO users (name, birthday_at, created_at, updated_at)
VALUES
('Kate', '1980-05-20', '20.10.2017 8:10', '20.10.2017 8:10'),
('Leo', '1981-07-10', '20.10.2017 8:10', '20.10.2017 8:10'),
('Jon', '1990-01-01', '20.10.2017 8:10', '20.10.2017 8:10'),
('Mark', '1995-02-28', '20.10.2017 8:10', '20.10.2017 8:10'),
('Helen', '1987-09-19', '20.10.2017 8:10', '20.10.2017 8:10');

/* По аналогии с созднием промежуточной табицы из видеоурока
   создадим промежуточные столбцы для created_at и updated_at.
 */

ALTER TABLE users ADD created_at_new DATETIME;
ALTER TABLE users ADD updated_at_new DATETIME;

/* теперь добавим в новые столбцы данные из created_at и updeted_at
   преобразовав строковый тип данных в данные даты и времени.
   нужную функцию ищем в табличке по адрессу: https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html
 */
UPDATE users
SET
	created_at_new = STR_TO_DATE (created_at, '%d.%m.%Y %h:%i'),
	updated_at_new = STR_TO_DATE (updated_at, '%d.%m.%Y %h:%i');

-- удаляем created_at и updated_at.
ALTER TABLE users DROP created_at;
ALTER TABLE users DROP updated_at;

-- заменяем названия новых столбцов на created_at и updated_at.
ALTER TABLE users RENAME COLUMN created_at_new TO created_at;
ALTER TABLE users RENAME COLUMN updated_at_new TO updated_at;
 
/* ЗАДАЧА 3. В таблице складских запасов storehouses_products
   в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. 
   Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. 
   Однако нулевые запасы должны выводиться в конце, после всех */

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
	id SERIAL PRIMARY KEY,
	storehouse_id INT UNSIGNED,
	product_id INT UNSIGNED,
	value INT UNSIGNED COMMENT 'ЗАПАС ТОВАРНОЙ ПОЗИЦИИ НА СКЛАДЕ',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'ЗАПАСЫ НА СКЛАДЕ';

INSERT IGNORE INTO storehouses_products (id, storehouse_id, product_id, value)
VALUES
('1', '1', '1', '0'),
('2', '2', '2', '2500'),
('3', '3', '3', '0'),
('4', '4', '4', '30'),
('5', '5', '5', '500'),
('6', '6', '6', '1');

SELECT value FROM storehouses_products
ORDER BY CASE
	WHEN value = 0 THEN '999999'
	END, value ;

/* ЗАДАЧА 4. Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. 
  Месяцы заданы в виде списка английских названий (may, august).*/

SELECT id, name FROM users
WHERE DATE_FORMAT(birthday_at, '%M') IN ('may', 'august');
	
/* ЗАДАЧА 5. Из таблицы catalogs извлекаются записи при помощи запроса. 
   SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.*/

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) COMMENT 'Название разддела'
) COMMENT = 'Разделы интернет-магазина';

INSERT IGNORE INTO catalogs VALUES
	(DEFAULT, 'Процессоры'),
	(DEFAULT, 'Мат.платы'),
	(DEFAULT, 'Видеокарты'),
	(DEFAULT, 'Жесткие диски'),
	(DEFAULT, 'Оперативная память');

SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY FIELD(id, 5, 1, 2);

/*Практическое задание теме «Агрегация данных»*/

/*ЗАДАЧА 1. Подсчитайте средний возраст пользователей в таблице users.*/
-- агрегатные функции https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html#function_avg
SELECT
  AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) AS age
FROM
  users;

/* ЗАДАЧА 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
   Следует учесть, что необходимы дни недели текущего года, а не года рождения. */ 

-- SELECT DAYOFWEEK(CONCAT(YEAR(NOW()), '-', MONTH(birthday_at), '-', DAYOFMONTH(birthday_at))) AS birthday FROM users;

SELECT COUNT(*) AS sunday FROM 
	(SELECT DAYOFWEEK(CONCAT(YEAR(NOW()), '-', MONTH(birthday_at), '-', DAYOFMONTH(birthday_at))) AS birthday FROM users)
	AS sunday WHERE birthday=1; -- для воскресенья
 
SELECT COUNT(*) AS monday FROM 
	(SELECT DAYOFWEEK(CONCAT(YEAR(NOW()), '-', MONTH(birthday_at), '-', DAYOFMONTH(birthday_at))) AS birthday FROM users)
	AS monday WHERE birthday=2; -- понедельник etc

SELECT COUNT(*) AS wednesday FROM 
	(SELECT DAYOFWEEK(CONCAT(YEAR(NOW()), '-', MONTH(birthday_at), '-', DAYOFMONTH(birthday_at))) AS birthday FROM users)
	AS wednesday WHERE birthday=4;

SELECT COUNT(*) AS friday FROM 
	(SELECT DAYOFWEEK(CONCAT(YEAR(NOW()), '-', MONTH(birthday_at), '-', DAYOFMONTH(birthday_at))) AS birthday FROM users)
	AS friday WHERE birthday=6;

SELECT COUNT(*) AS saturday FROM 
	(SELECT DAYOFWEEK(CONCAT(YEAR(NOW()), '-', MONTH(birthday_at), '-', DAYOFMONTH(birthday_at))) AS birthday FROM users)
	AS saturday WHERE birthday=7;

/*ЗАДАЧА 3. Подсчитайте произведение чисел в столбце таблицы.*/

DROP TABLE IF EXISTS tbl;
CREATE TABLE tbl (value INT UNSIGNED);
INSERT IGNORE INTO tbl (value)
VALUES
('1'),
('2'),
('3'),
('4'),
('5');

SELECT EXP(SUM(LN(value))) FROM tbl;
 
