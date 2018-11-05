SELECT 'ФИО: Калиниченко Павел Олегович';

-- Партиционировать таблицу links на 2 партиции: чётные movieId в одной партиции, нечётные в другой.

CREATE TABLE links_sharded (like links including all
);

CREATE TABLE links_sharded_1 (
  CHECK (movieid % 2 != 0)
)
  INHERITS (links_sharded);

CREATE TABLE links_sharded_2 (
  CHECK (movieid % 2 = 0)
)
  INHERITS (links_sharded);


CREATE RULE links_insert_1 AS ON INSERT
  TO links_sharded
  WHERE (movieid % 2 != 0)
DO INSTEAD INSERT INTO links_sharded_1
           VALUES (NEW.*);

CREATE RULE links_insert_2 AS ON INSERT
  TO links_sharded
  WHERE (movieid % 2 = 0)
DO INSTEAD INSERT INTO links_sharded_2
           VALUES (NEW.*);


INSERT INTO links_sharded (SELECT *
                           FROM links
                           ORDER BY movieid ASC
                           LIMIT 10000);