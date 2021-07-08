/**********************************************************************
 * 1.Проанализировать структуру БД vk, которую мы создали на занятии, *
 * и внести предложения по усовершенствованию (если такие идеи есть). *
 * Напишите пожалуйста, всё-ли понятно по структуре.                  *
 *                                                                    *
 * 2.Добавить необходимую таблицу/таблицы для того,                   *
 * чтобы можно было использовать лайки для медиафайлов,               *
 * постов и пользователей.                                            *
 **********************************************************************/

-- task1
USE vk;

ALTER TABLE users ADD COLUMN status ENUM('is_active', 'is_deleted', 'ban') NOT NULL;

-- создаем первую таблицу 'путешествия'
DROP TABLE IF EXISTS journey;
CREATE TABLE journey(
	user_id BIGINT UNSIGNED NOT NULL COMMENT 'id пользователя совершившего путешестиве',
	companion_id BIGINT UNSIGNED NOT NULL COMMENT 'id компаньона с которым совершил путешествие',
	travel_location VARCHAR(150) COMMENT 'место, куда путешествовал',
	date_of_travel YEAR COMMENT 'год, в котором совершено путешествие',
	PRIMARY KEY (user_id, companion_id), -- создаем индексы по полю user_id и по полю companion_id
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (companion_id) REFERENCES users(id) -- создаем внешние ключи, связь 1-М
);

-- создаем вторую таблицу 'образование'
DROP TABLE IF EXISTS education;
CREATE TABLE education(
	user_id SERIAL PRIMARY KEY, -- индексы
	school_name VARCHAR(100) COMMENT 'название учебного заведение',
	city_of_school VARCHAR(100) COMMENT 'город, в котором расположено учебное заведенеи',
	date_of_begin_school YEAR COMMENT 'год поступления',
	date_of_end_school YEAR COMMENT 'год выпуска',
	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE 
	/* внешний ключ, связь 1-1, каскадное удаление, насколько я понял, чтобы при обновлении/удалении данных
	   в таблице users данные обновлялись/удалялись из нашей таблицы */
);

-- создаем третью таблицу 'карьера'
DROP TABLE IF EXISTS career;
CREATE TABLE career(
	user_id SERIAL PRIMARY KEY,
	profession VARCHAR(100) COMMENT 'специальность',
	place_of_work VARCHAR(100) COMMENT 'место работы, название организации',
	date_start_of_work DATE COMMENT 'дата начала работы',
	date_end_of_work DATE DEFAULT NULL COMMENT 'дата увольнения',
	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- TASK 2
DROP TABLE IF EXISTS likes;
CREATE TABLE likes(
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	media_id BIGINT UNSIGNED NOT NULL,
	creted_at DATETIME DEFAULT NOW(),
	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (media_id) REFERENCES media(id) ON UPDATE CASCADE ON DELETE CASCADE
);
