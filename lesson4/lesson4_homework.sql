/*************************************************************************************************************
 * 1 Повторить все действия по доработке БД vk из урока.                                                     * 
 * 		Выполнено! sql файл работы на уроке прилагается                                                      *
 * 2 Используя сервис http://filldb.info , https://www.mockaroo.com/ или другой по вашему желанию,           *
 * 		a) сгенерировать тестовые данные для всех таблиц, используя vk-data.sql, учитывая логику связей.     *
 * 		b) Для всех таблиц, где это имеет смысл, создать не менее 100 строк.                                 *
 * 		c) Для media_types создать ровно 4 строки. Загрузить тестовые данные.                                *
 * 		d) Приложить к отчёту полученный дамп с данными.                                                     *
 * 			Выполнено! дамп прилагается                                                                      *
 * 3 Написать запрос для переименования названий типов медиа (колонка name в media_types),                   *
 * 		которые вы получили в пункте 3 в image, audio, video, document.                                      *
 * 		Написать запрос, удаляющий заявки в друзья самому себе.                                              *
 * 4 Написать название темы курсового проекта                                                                *
 *************************************************************************************************************/

USE social_vk;

-- task 3
SELECT * FROM media_types;

UPDATE media_types 
SET name = 'image'
WHERE id = 1;

UPDATE media_types 
SET name = 'audio'
WHERE id = 2;

UPDATE media_types 
SET name = 'video'
WHERE id = 3;

UPDATE media_types 
SET name = 'document'
WHERE id = 4;

SELECT * FROM friend_request fr
WHERE initiator_user_id = target_user_id;

DELETE FROM friend_request
WHERE initiator_user_id = target_user_id;

-- task 4
/* *****************************************************************************
 * online_cinema_gb                                                            *
 * https://github.com/KazancevVitaly/basics_of_relational_databases/pull/3     *
 * *************************************************************************** */ 

