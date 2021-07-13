DROP DATABASE IF EXISTS online_cinema_gb;
CREATE DATABASE online_cinema_gb;
USE online_cinema_gb;

/*1 СТРАНЫ*/
DROP TABLE IF EXISTS countries;
CREATE TABLE countries(
	id SERIAL PRIMARY KEY,
	country VARCHAR(50) COMMENT 'НАЗВАНИЕ СТАРНЫ'
);

/*2 КИНОКОМПАНИИ*/
DROP TABLE IF EXISTS company;
CREATE TABLE company(
	id SERIAL PRIMARY KEY,
	country_id BIGINT UNSIGNED NOT NULL,
	name VARCHAR(100) NOT NULL COMMENT 'НАЗВАНИЕ КИНОКОМПАНИИ',
	CONSTRAINT fk_country_company FOREIGN KEY (country_id) REFERENCES countries (id)
);

/*3 ЖАНРЫ*/
DROP TABLE IF EXISTS genres;
CREATE TABLE genres(
	id SERIAL PRIMARY KEY,
	genre VARCHAR(20) NOT NULL COMMENT 'ЖАНР'
);

/*4 ФИЛЬМЫ*/
DROP TABLE IF EXISTS films;
CREATE TABLE films(
	id SERIAL PRIMARY KEY,
	film VARCHAR(30) COMMENT 'НАЗВАНИЕ ФИЛЬМА',
	genre_id BIGINT UNSIGNED NOT NULL,
	company_id BIGINT UNSIGNED NOT NULL,
	`release` DATE NOT NULL COMMENT 'ПРЕМЬЕРА В МИРЕ',
	budget BIGINT UNSIGNED NOT NULL COMMENT 'БЮДЖЕТ',
	world_fees BIGINT UNSIGNED DEFAULT NULL COMMENT 'СБОРЫ В МИРЕ',
	russian_fees BIGINT UNSIGNED DEFAULT NULL COMMENT 'СБОРЫ В РФ',
	video_link VARCHAR(50) COMMENT 'ССЫЛКА НА ВИДЕОФАЙЛ',
	description TEXT NOT NULL COMMENT 'КРАТКОЕ ОПИСАНИЕ ФИЛЬМА',
	access ENUM('free', 'plus', 'prepaid') COMMENT 'ДОСТУП К ФИЛЬМУ СВОБОДНЫЙ (free), ПО ПОДПИСКЕ (plus) ПЛАТНЫЙ (prepaid)',
	FOREIGN KEY (genre_id) REFERENCES genres(id),
	FOREIGN KEY (company_id) REFERENCES company(id)
);

/* 5 ЛИЧНОСТИ */
DROP TABLE IF EXISTS persons;
CREATE TABLE persons(
	id SERIAL PRIMARY KEY,
	name VARCHAR(150) COMMENT 'ИМЯ АКТРЕА, РЕЖИССЕРА, ПРОДЮССЕРЕА И Т.Д.',
	film_profession VARCHAR(50) COMMENT 'ПРОФЕССИЯ: АКТЕР, ПРОДЮССЕР, РЕЖИССЕР И Т.Д.',
	birthday DATE NOT NULL COMMENT 'ДАТА РОЖДЕНИЯ',
	deth_day DATE DEFAULT NULL COMMENT 'ДАТА СМЕРТИ, ПО УМОЛЧАНИЮ NULL',
	biography TEXT NOT NULL COMMENT 'БИОГРАФИЯ'
);

/* 6 РАБОТА В КИНО */
DROP TABLE IF EXISTS work_in_film;
CREATE TABLE work_in_film(
	film_id BIGINT UNSIGNED NOT NULL,
	person_id BIGINT UNSIGNED NOT NULL,
	`role` VARCHAR(50) NOT NULL COMMENT 'РОЛЬ В ФИЛЬМЕ',
	FOREIGN KEY (film_id) REFERENCES films(id),
	FOREIGN KEY (person_id) REFERENCES persons(id)
);

/* 7 ПОЛЬЗОВАТЕЛИ */
DROP TABLE IF EXISTS users;
CREATE TABLE users(
	id SERIAL PRIMARY KEY,
	firstname VARCHAR(30) NOT NULL COMMENT 'ИМЯ',
	lastname VARCHAR(30) NOT NULL COMMENT 'ФАМИЛИЯ',
	birthday DATE NOT NULL COMMENT 'ДАТА РОЖДЕНИЯ',
	email VARCHAR(50) COMMENT 'АДРЕС ЭЛЕКТРОННОЙ ПОЧТЫ',
	phon BIGINT UNSIGNED NOT NULL COMMENT 'НОМЕР ТЕЛЕФОНА',
	is_subscription BOOLEAN DEFAULT FALSE COMMENT 'ПОДПИСКА',
	status ENUM('active', 'deleted', 'ban'),
	created_at DATETIME NOT NULL DEFAULT NOW() COMMENT 'ДАТА СОЗДАНИЯ АККАУНТА',
	INDEX user_firstname_lastname (firstname, lastname)
);

/* 8 фильмы пользователя */
DROP TABLE IF EXISTS users_films;
CREATE TABLE users_films(
	user_id BIGINT UNSIGNED NOT NULL,
	film_id BIGINT UNSIGNED NOT NULL,
	is_access BOOLEAN DEFAULT FALSE COMMENT 'ДОСТУП К ПРОСМОТРУ ФИЛЬМА ПО УМОЛЧАНИЮ ЗАКРЫТ',
	viewed INT UNSIGNED DEFAULT 0 COMMENT 'СКОЛЬКО РАЗ ПОСМОТРЕЛ',
	`comment` TEXT DEFAULT NULL COMMENT 'ОТЗЫВ О ФИЛЬМЕ',
	marker TINYINT UNSIGNED DEFAULT 0 COMMENT 'ОЦЕНКА',
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (film_id) REFERENCES films(id)
);

/* 9 рейтиинги фильмов */
DROP TABLE IF EXISTS raiting_films;
CREATE TABLE raiting_films(
	film_id BIGINT UNSIGNED NOT NULL,
	raiting TINYINT UNSIGNED DEFAULT 0 COMMENT 'рейтинг',
	FOREIGN KEY (film_id) REFERENCES films(id)
);

/* 10 */





