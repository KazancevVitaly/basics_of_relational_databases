/*********************************************************************************************************************************************
 * 1 Проанализировать запросы, которые выполнялись на занятии, определить возможные корректировки и/или улучшения (JOIN пока не применять).  *
 * 2 Пусть задан некоторый пользователь.                                                                                                     *
 *		Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.                               *
 * 3 Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.                                                    *
 * 4 Определить кто больше поставил лайков (всего) - мужчины или женщины?                                                                    *
 * 5 Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.                                        *
 *********************************************************************************************************************************************/

DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
USE vk;

/* далее в терминале mysql vk < vk-db-data-full\ \(3\).sql */ 

/************
 * Задача 1 *
 ************/
 -- Запрос 1

SELECT 
	first_name,                                             -- выбираем имя пользователя
	last_name,                                              -- выбираем фамилию пользователя
	(SELECT city FROM profiles WHERE user_id = 1) AS city,  -- ищем город пользователя из таблицы профилей
	(SELECT file_name FROM media WHERE id =                
	    (SELECT photo_id FROM profiles WHERE user_id = 1) 
	) AS profile_photo                                      -- аватар из медиа, id которого у нас привязывается к таблице профилей
FROM users 
WHERE id = 1;
 
-- Запрос 6
SELECT CONCAT(first_name, ' ', last_name) AS name                                         -- в одну колнку имя и фамилию
FROM users 
	WHERE id IN (
		SELECT to_user_id FROM friend_requests WHERE from_user_id = 1 AND request_type =  -- кому пользователь отправля запрос на дружбу
				(SELECT id FROM friend_requests_types WHERE name = 'accepted')            -- и запрос подтвержден
			UNION
		SELECT from_user_id FROM friend_requests WHERE to_user_id = 1 AND request_type =  -- кто отправлял нашему пользователю запрос на дружбу
				(SELECT id FROM friend_requests_types WHERE name = 'accepted')            -- и запрос подтвержден
	);

-- Запрос 7
SELECT CONCAT(first_name, ' ', last_name) AS name,                                                  -- в одну колнку имя и фамилию
	(SELECT 
		CASE (gender)                                                                               -- кейс для того, чтобы гендер был словом
			WHEN 'f' THEN 'female'
			WHEN 'm' THEN 'male'
			WHEN 'x' THEN 'not defined'
		END 
		FROM profiles WHERE user_id = users.id) AS gender,
		(SELECT TIMESTAMPDIFF(YEAR, birthday, NOW()) FROM profiles WHERE user_id = users.id) AS age,  -- возраст друзей
		(SELECT file_name FROM media WHERE id = 
			(SELECT photo_id FROM profiles WHERE user_id =users.id) 
		) AS avatar                                                                                   -- select от меня на аватарку друга
FROM users
WHERE id IN (
		SELECT to_user_id FROM friend_requests WHERE from_user_id = 1 AND request_type = 
				(SELECT id FROM friend_requests_types WHERE name = 'accepted')
			UNION
		SELECT from_user_id FROM friend_requests WHERE to_user_id = 1 AND request_type = 
				(SELECT id FROM friend_requests_types WHERE name = 'accepted')
	);

/************
 * Задача 2 *
 ************/
-- пусть некоторым пользователем будет пользователь с id = 1
SELECT COUNT(*) count_messages, from_user_id 
FROM messages 
WHERE (to_user_id = 1
	AND from_user_id IN (
		SELECT to_user_id FROM friend_requests WHERE from_user_id = 1 AND request_type = 
				(SELECT id FROM friend_requests_types WHERE name = 'accepted')
			UNION
		SELECT from_user_id FROM friend_requests WHERE to_user_id = 1 AND request_type = 
				(SELECT id FROM friend_requests_types WHERE name = 'accepted')
	)) GROUP BY from_user_id ORDER BY count_messages DESC LIMIT 1; -- сортируем в обратном порядке и выводим первый максимальный результат

/************
 * Задача 3 *
 ************/
	
SELECT 
	COUNT(pl.like_type),
	pl.user_id,
	(SELECT first_name FROM users WHERE id = pl.user_id) AS name,
	(SELECT TIMESTAMPDIFF(YEAR, birthday, NOW()) FROM profiles p WHERE p.user_id = pl.user_id) AS age
FROM posts_likes pl
WHERE like_type = 1
GROUP BY pl.user_id
ORDER BY age
LIMIT 10; -- Определяю десять самых молодых пользователей, десятку самых молодых пользователей меньше либо равно 43.

SELECT COUNT(*)
FROM posts_likes pl 
WHERE pl.like_type  = 1 AND pl.user_id IN(
	SELECT p.user_id FROM profiles p 
		WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) <= 43
); -- Считаю лайки пользователей не старше 43 лет. Решить в один запрос так и не смог.

-- SELECT p.user_id, TIMESTAMPDIFF(YEAR, birthday, NOW()) AS age FROM profiles p GROUP BY p.user_id ORDER BY age LIMIT 10;

/************
 * Задача 4 *
 ************/

SELECT COUNT(*) FROM posts_likes pl 
	WHERE pl.user_id IN (
	SELECT user_id FROM profiles
	WHERE gender = 'f'
	) -- Подсчитываем сколько лайков поставили женщины
UNION 
SELECT COUNT(*) FROM posts_likes pl2 
	WHERE pl2.user_id IN (
	SELECT user_id FROM profiles
	WHERE gender = 'm' -- Подсчитываем сколько лайков поставили мужчины
	);

/************
 * Задача 5 *
 ************/
-- Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.
-- Будем считать, что самые активные это те, кто пишет больше всех сообщений

SELECT 
	COUNT(*) AS total_messages, 
	(SELECT u.first_name FROM users u WHERE u.id = m.from_user_id) AS name
FROM messages m
GROUP BY m.from_user_id
ORDER BY total_messages
LIMIT 10;


