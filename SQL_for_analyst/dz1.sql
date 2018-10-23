SELECT 'ФИО: Калиниченко Павел Олегович';

-- Задача 1. Приведение таблицы ко 2 НФ
-- было
CREATE TABLE IF NOT EXISTS oskar (
  movie       VARCHAR(100) NOT NULL,
  director    VARCHAR(100) NOT NULL,
  oskar       BOOLEAN      NOT NULL DEFAULT FALSE,
  imdb_rating SMALLINT     NOT NULL,
  PRIMARY KEY (movie, director)
);

-- Если мы считаем, что рейтинг IMDB зависит только от режиссера
-- (что очень странно, потому что рейтинг скорее зависит от фильма и может быть два фильма с одинаковым названием,
-- поэтому правильно брать ключ PRIMARY KEY (movie, director) и тогда таблица находится во 2 НФ), но это в общем виде.

-- В этом конкретном кейсе когда у нас только 3 кортежа и мы видим, что рейтинг зависит от режиссера
-- то тогда вычленяем 2 таблицы:

CREATE TABLE IF NOT EXISTS oskar (
  movie    VARCHAR(100)        NOT NULL,
  director VARCHAR(100) UNIQUE NOT NULL,
  oskar    BOOLEAN             NOT NULL DEFAULT FALSE,
  PRIMARY KEY (movie, director)
);


CREATE TABLE IF NOT EXISTS rating (
  director    VARCHAR(100) PRIMARY KEY,
  imdb_rating SMALLINT NOT NULL
);

-- Задача 2. Приведение таблицы к 3 НФ

-- было
CREATE TABLE IF NOT EXISTS oskar (
  movie   VARCHAR(100) PRIMARY KEY,
  oskar   BOOLEAN      NOT NULL DEFAULT FALSE,
  country VARCHAR(100) NOT NULL
);

-- с тем же замечанием что и в предыдущем пункте делаем:

CREATE TABLE IF NOT EXISTS oskar_by_movie (
  movie VARCHAR(100) PRIMARY KEY,
  oskar BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS oskar_by_country (
  country VARCHAR(100) PRIMARY KEY,
  oskar   BOOLEAN NOT NULL DEFAULT FALSE
);

-- Задача 3. Зайти на Кинопоиск, найти 5 любимых фильмов и сделать по ним табличку с данными.

CREATE TABLE IF NOT EXISTS films (
  id           SERIAL PRIMARY KEY,
  title        VARCHAR(100) NOT NULL,
  country      VARCHAR(100) NOT NULL,
  box_office   INTEGER      NOT NULL DEFAULT 0,
  release_year TIMESTAMP    NOT NULL
);

CREATE TABLE IF NOT EXISTS persons (
  id  SERIAL PRIMARY KEY,
  fio VARCHAR(500) NOT NULL
);

CREATE TABLE IF NOT EXISTS persons2content (
  person_id   INTEGER REFERENCES persons (id),
  film_id     INTEGER REFERENCES films (id),
  person_type VARCHAR(100) NOT NULL
);

INSERT INTO films (title, country, box_office, release_year)
VALUES ('Побег из Шоушенка', 'США', 59841469, '1999-09-01');
INSERT INTO persons (fio)
VALUES ('Фрэнк Дарабонт');
INSERT INTO persons (fio)
VALUES ('Тим Роббинс');
INSERT INTO persons2content (person_id, film_id, person_type)
VALUES (1, 1, 'режиссер');
INSERT INTO persons2content (person_id, film_id, person_type)
VALUES (2, 1, 'актер');

INSERT INTO films (title, country, box_office, release_year)
VALUES ('Зеленая миля', 'США', 286801374, '1999-12-06');
INSERT INTO persons (fio)
VALUES ('Том Хэнкс');
INSERT INTO persons2content (person_id, film_id, person_type)
VALUES (1, 2, 'режиссер');
INSERT INTO persons2content (person_id, film_id, person_type)
VALUES (3, 2, 'актер');

INSERT INTO films (title, country, box_office, release_year)
VALUES ('Форрест Гамп', 'США', 677386686, '1994-06-23');
INSERT INTO persons (fio)
VALUES ('Роберт Земекис');
INSERT INTO persons2content (person_id, film_id, person_type)
VALUES (4, 3, 'режиссер');
INSERT INTO persons2content (person_id, film_id, person_type)
VALUES (3, 3, 'актер');

INSERT INTO films (title, country, box_office, release_year)
VALUES ('Список Шиндлера', 'США', 321265768, '1993-11-30');
INSERT INTO persons (fio)
VALUES ('Стивен Спилберг');
INSERT INTO persons (fio)
VALUES ('Лиам Нисон');
INSERT INTO persons2content (person_id, film_id, person_type)
VALUES (5, 4, 'режиссер');
INSERT INTO persons2content (person_id, film_id, person_type)
VALUES (6, 4, 'актер');

INSERT INTO films (title, country, box_office, release_year)
VALUES ('1+1', 'Франция', 426588510, '2011-09-23');
INSERT INTO persons (fio)
VALUES ('Оливье Накаш');
INSERT INTO persons (fio)
VALUES ('Франсуа Клюзе');
INSERT INTO persons2content (person_id, film_id, person_type)
VALUES (7, 5, 'режиссер');
INSERT INTO persons2content (person_id, film_id, person_type)
VALUES (8, 5, 'актер');

SELECT title, country, box_office, release_year, fio, person_type
FROM films
       LEFT JOIN persons2content c2 on films.id = c2.film_id
       LEFT JOIN persons p on c2.person_id = p.id
ORDER BY box_office DESC;

-- Скриншот https://monosnap.com/file/bzHkuH9XkXl0UN2VBhLLZeVZouTfbL