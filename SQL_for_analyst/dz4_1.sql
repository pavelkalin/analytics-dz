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

CREATE OR REPLACE FUNCTION cross_arr(a int [], b int [])
  RETURNS int [] language sql as $FUNCTION$
SELECT array_agg(dt) as arr FROM ((SELECT unnest(a) as dt) INTERSECT (SELECT unnest(b) as dt)) s ORDER BY arr ;
$FUNCTION$;
