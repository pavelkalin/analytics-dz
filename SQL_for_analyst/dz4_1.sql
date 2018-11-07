SELECT 'ФИО: Калиниченко Павел Олегович';

-- Используя функцию определения размера таблицы, вывести top-5 самых больших таблиц базы.

SELECT table_name, pg_size_pretty(pg_relation_size(table_name)) as size
FROM (SELECT * FROM information_schema.tables ORDER BY pg_relation_size(table_name) DESC) s
WHERE table_schema NOT IN ('information_schema', 'pg_catalog')
LIMIT 5;

-- Запрос 1

SELECT userid, array_agg(movieid) as user_views
FROM ratings
GROUP BY userid
ORDER BY userid ASC;

-- Создайте таблицу user_movies_agg, в которую сохраните результат запроса

SELECT userID, user_views INTO user_movies_agg
FROM (SELECT userid, array_agg(movieid) as user_views FROM ratings GROUP BY userid ORDER BY userid ASC) s;

-- Используя следующий синтаксис, создайте функцию cross_arr оторая принимает на вход два массива arr1 и arr2.
-- Функция возвращает массив, который представляет собой пересечение контента из обоих списков.

CREATE OR REPLACE FUNCTION cross_arr(a int [], b int [])
  RETURNS int [] language sql as $FUNCTION$
SELECT array_agg(dt) as arr
FROM ((SELECT unnest(a) as dt) INTERSECT (SELECT unnest(b) as dt)) s
ORDER BY arr ASC;
$FUNCTION$;

-- Создайте по аналогии с cross_arr функцию diff_arr, которая вычитает один массив из другого.
CREATE OR REPLACE FUNCTION diff_arr(a int [], b int [])
  RETURNS int [] language sql as $FUNCTION$ SELECT array_agg(dt) as arr
                                            FROM ((SELECT unnest(a) as dt) EXCEPT (SELECT unnest(b) as dt)) s
                                            ORDER BY arr ASC; $FUNCTION$;


SELECT * INTO small_ratings
FROM ratings
LIMIT 10000;

-- Сформируйте запрос следующего вида: достать из таблицы всевозможные наборы u1, r1, u2, r2. u1 и u2 - это id пользователей
-- r1 и r2 - соответствующие массивы  контентов

SELECT DISTINCT u1, r1, u2, r2
FROM (SELECT userid as u1, array_agg(movieid) as r1 FROM small_ratings GROUP BY u1) t1
       CROSS JOIN (SELECT userid as u2, array_agg(movieid) as r2 FROM small_ratings GROUP BY u2) t2
WHERE u1 <> u2;

-- Примените к CTE функцию cross_arr. Результатом запроса будут три поля - u1, u2,
-- crossed_array - id двух пользователей и их общие фильмы. Назовём эту конструкцию (вместе с CTE) ЗАПРОС2
-- Сохраним результат ЗАПРОС2 в таблицу common_user_views, куда сохраните результат запроса.

WITH user_pairs as (SELECT DISTINCT u1, r1, u2, r2
                    FROM (SELECT userid as u1, array_agg(movieid) as r1 FROM small_ratings GROUP BY u1) t1
                           CROSS JOIN (SELECT userid as u2, array_agg(movieid) as r2 FROM small_ratings GROUP BY u2) t2
                    WHERE u1 <> u2)
SELECT u1, u2, cross_arr(r1 :: int [], r2 :: int []) as arr INTO common_user_views
FROM user_pairs;

-- Отсортируйте выборку из common_user_views по длине crossed_array и оставите топ-10 пользователей
-- с самыми большими пересечениями.
SELECT u1, u2, arr, array_length(arr, 1)
FROM common_user_views
WHERE arr IS NOT NULL
ORDER BY array_length(arr, 1) DESC
LIMIT 10;

-- Удаляю из таблицы common_user_views строки где нет пересечений фильмов у u1 и u2

DELETE
FROM common_user_views
WHERE arr IS NULL;

-- Сформируйте рекомендации - для каждой пары посоветуйте для u1 контент, который видел u2,
-- но не видел u1 (в виде массива).

-- читерная функция из https://stackoverflow.com/questions/3994556/eliminate-duplicate-array-values-in-postgres
-- чтобы не писать свою
CREATE OR REPLACE FUNCTION array_sort_unique(ANYARRAY)
  RETURNS ANYARRAY
LANGUAGE SQL
AS $body$
SELECT ARRAY(
         SELECT DISTINCT $1 [ s.i ] FROM generate_series(array_lower($1, 1), array_upper($1, 1)) AS s (i) ORDER BY 1
           );
$body$;

-- Сформируйте рекомендации - для каждой пары посоветуйте для u1 контент, который видел u2,
-- но не видел u1 (в виде массива).

SELECT t1.u1, array_sort_unique(diff_arr(r1 :: int [], r2 :: int []))
FROM (SELECT userid as u1, user_views as r1 FROM user_movies_agg) t1
       CROSS JOIN (SELECT u1, u2, arr as r2 FROM common_user_views) t2
WHERE t1.u1 = t2.u1
GROUP BY t1.u1, r1, r2
LIMIT 10;