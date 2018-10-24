SELECT 'ФИО: Калиниченко Павел Олегович';

-- 1.1.  SELECT , LIMIT - выбрать 10 записей из таблицы ratings

SELECT *
FROM ratings
LIMIT 10;

-- 1.2 WHERE, LIKE - выбрать из таблицы links всё записи, у которых imdbid оканчивается на "42",
-- а поле movieid между 100 и 1000
SELECT *
FROM links
WHERE movieid BETWEEN 100 AND 1000
  AND imdbid LIKE '%42'
LIMIT 10;

-- 2.1 INNER JOIN выбрать из таблицы links все imdb_id, которым ставили рейтинг 5
SELECT l.imdbid as imdb_id
FROM links l
       INNER JOIN ratings r ON l.movieid = r.movieid
WHERE r.rating = 5
LIMIT 10;

-- 3.1 COUNT() Посчитать число фильмов без оценок
SELECT COUNT(*)
FROM links l
       LEFT JOIN ratings r ON l.movieid = r.movieid
WHERE r.rating IS NULL
LIMIT 1;

-- 3.2 GROUP BY, HAVING вывести top-10 пользователей, у который средний рейтинг выше 3.5
SELECT userid, AVG(rating)
FROM ratings
GROUP BY userid
HAVING AVG(rating) > 3.5
ORDER BY AVG(rating) DESC, userid ASC
LIMIT 10;

-- 4.1. Подзапросы: достать 10 imbdId из links у которых средний рейтинг больше 3.5.
SELECT l.imdbid, r.rating
FROM links l
       INNER JOIN (SELECT movieid, AVG(rating) as rating FROM ratings GROUP BY 1 HAVING AVG(rating) > 3.5) r
         ON l.movieid = r.movieid
LIMIT 10;

-- 4.2 Common Table Expressions: посчитать средний рейтинг по пользователям, у которых более 10 оценок. Нужно подсчитать
--  средний рейтинг по все пользователям, которые попали под условие - то есть в ответе должно быть одно число.

WITH tmp_people
    AS (SELECT userid, COUNT(rating) FROM ratings GROUP BY 1 HAVING COUNT(rating) > 10)
SELECT AVG(rating) as average_rating
FROM ratings r
       INNER JOIN tmp_people t ON t.userid = r.userid;

-- скриншот https://monosnap.com/file/OwpeWOQRBf180oS88VFocy8Dc3Bhla