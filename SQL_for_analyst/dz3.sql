SELECT 'ФИО: Калиниченко Павел Олегович';

-- Вывести список пользователей в формате userId, movieId, normed_rating, avg_rating где
-- userId, movieId - без изменения
-- для каждого пользователя преобразовать рейтинг r в нормированный - normed_rating=(r - r_min)/(r_max - r_min),
-- где r_min и r_max соответственно минимально и максимальное значение рейтинга у данного пользователя
-- avg_rating - среднее значение рейтинга у данного пользователя
-- Вывести первые 30 таких записей

SELECT userid,
       movieid,
       case (MAX(rating) OVER (PARTITION BY userid) - MIN(rating) OVER (PARTITION BY userid))
         WHEN 0
                 THEN AVG(rating) OVER (PARTITION BY userid)
         ELSE (rating - MIN(rating) OVER (PARTITION BY userid)) /
              (MAX(rating) OVER (PARTITION BY userid) - MIN(rating) OVER (PARTITION BY userid)) END as normed_rating,
       AVG(rating) OVER (PARTITION BY userid)                                                       as avg_rating
FROM ratings
ORDER BY userid, normed_rating DESC
LIMIT 30;

-- "ВАША КОМАНДА СОЗДАНИЯ ТАБЛИЦЫ";

CREATE TABLE IF NOT EXISTS keywords (
  id   INTEGER NOT NULL,
  tags TEXT    NOT NULL
);

-- "ВАША КОМАНДА ЗАЛИВКИ ДАННЫХ В ТАБЛИЦу";
\copy keywords FROM '/data/keywords.csv' DELIMITER ',' CSV HEADER;

--Сформируйте запрос (назовём его ЗАПРОС1) к таблице ratings, в котором будут 2 поля -- movieId -- avg_rating -
-- средний рейтинг, который ставят этому контенту пользователи В выборку должны попасть те фильмы,
-- которым поставили оценки более чем 50 пользователей Список должен быть отсортирован по убыванию по полю avg_rating и
-- по возрастанию по полю movieId Из этой выборки оставить первое 150 элементов

SELECT movieid, AVG(rating) as avg_rating
FROM ratings
GROUP BY movieid
HAVING COUNT(userid) > 50
ORDER BY avg_rating DESC, movieid ASC
LIMIT 150;

-- Теперь мы хотим добавить к выборке хороших фильмов с высоким рейтингов информацию о тегах.
-- Воспользуемся Common Table Expressions. Для этого нужно написать ЗАПРОС2, который присоединяет к выборке
-- таблицу keywords
--  WITH top_rated as ( ЗАПРОС1 ) ЗАПРОС2;

WITH top_rated as (SELECT movieid, AVG(rating) as avg_rating
                   FROM ratings
                   GROUP BY movieid
                   HAVING COUNT(userid) > 50
                   ORDER BY avg_rating DESC, movieid ASC
                   LIMIT 150)
SELECT top_rated.movieid, top_rated.avg_rating, k.tags
FROM top_rated
       LEFT JOIN keywords k ON top_rated.movieid = k.id;

CREATE TABLE IF NOT EXISTS top_rated_tags (
  id   INTEGER NOT NULL,
  tags TEXT    NOT NULL
);

--Сохраним нашу выборку в новую таблицу top_rated_tags. Для этого мы модифицируем ЗАПРОС2 -
-- вместо простого SELECT сделаем SELECT INTO.

WITH top_rated as (SELECT movieid, AVG(rating) as avg_rating
                   FROM ratings
                   GROUP BY movieid
                   HAVING COUNT(userid) > 50
                   ORDER BY avg_rating DESC, movieid ASC
                   LIMIT 150)
SELECT top_rated.movieid, k.tags INTO top_rated_tags
FROM top_rated
       LEFT JOIN keywords k ON top_rated.movieid = k.id
ORDER BY top_rated.movieid ASC;

-- Теперь можно выгрузить таблицу в текстовый файл - пример см. в лекции. Внимание:
-- Поля в текстовом файле нужно разделить при помощи табуляции ( символ E\t).

\copy (SELECT * FROM top_rated_tags) TO '/top_rated_tags.csv' WITH CSV HEADER DELIMITER as E'\t';