/****************************************************************
* ПРАКТИЧЕСКОЕ ЗАДАНИЕ К 7 УРОКУ КУРСА "БАЗЫ ДАННЫХ" GEEKBRAINS *
*****************************************************************/

/*ЗАДАЧА 1. Составьте список пользователей users, 
 которые осуществили хотя бы один заказ orders в интернет магазине.*/

USE shop;

-- ДОБАВИМ НЕКОТОРЫЕ ДАННЫЕ В ТАБЛИЦЫ ЗАКАЗОВ, ПУСТЬ БЫЛО ДВА ЗАКАЗА
INSERT INTO orders
	(id, user_id)
VALUES
	(1,5),
	(2,3),
	(3,5);

INSERT INTO orders_products 
	(id, order_id, product_id, total)
VALUES
	(1, 1, 2, 3),
	(2, 2, 3, 1),
	(3, 3, 3, 1);
	
SELECT 
	users.name name,
	orders.id number_of_orders
FROM 
	users 
-- RIGHT 
JOIN
	orders  
ON
	users.id = orders.user_id
GROUP BY name
ORDER BY number_of_orders;
-- ПОЛУЧАЕМ, ЧТО ЗАКАЗЫ ДЕЛАЛИ ИВАН И АЛЕКСАНДР

/* ЗАДАЧА 2. Выведите список товаров products и разделов catalogs, который соответствует товару.*/

SELECT 
	products.name name,
	catalogs.name `type`,
	catalogs.id number_of_type
FROM
	products 
JOIN
	catalogs 
ON 
	products.catalog_id = catalogs.id; 

/* ЗАДАЧА 3. Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name).
 * Поля from, to и label содержат английские названия городов, поле name — русское. 
 * Выведите список рейсов flights с русскими названиями городов.*/

DROP DATABASE IF EXISTS airport;
CREATE DATABASE airport;
USE airport;

DROP TABLE IF EXISTS flights;
CREATE TABLE flights(
	id SERIAL PRIMARY KEY,
	`from` VARCHAR (50),
	`to` VARCHAR (50)
);

DROP TABLE IF EXISTS cities;
CREATE TABLE cities(
	label VARCHAR(50),
	name VARCHAR(50)
);

INSERT INTO flights 
 	(`from`, `to`)
VALUES
	('moscow', 'omsk'),
	('novgorod', 'kazan'),
	('irkutsk', 'moscow'),
	('omsk', 'irkutsk'),
	('moscow', 'kazan');

INSERT INTO cities 
 	(label, name)
VALUES
	('moscow', 'Москва'),
	('irkutsk', 'Иркутск'),
	('novgorod', 'Новгород'),
	('kazan', 'Казань'),
	('omsk', 'Омск');

SELECT
	id номер_рейса,
	(SELECT name FROM cities WHERE label = `from`) город_отправления,
	(SELECT name FROM cities WHERE label = `to`) город_прибытия
FROM 
    flights
ORDER BY
	номер_рейса;









