USE master;
DROP DATABASE IF EXISTS MoviesInfo;
CREATE DATABASE MoviesInfo;
USE MoviesInfo;

CREATE TABLE Actor
(
id INT NOT NULL PRIMARY KEY,
firstName NVARCHAR(50) NOT NULL,
secondName NVARCHAR(50) NOT NULL
) AS NODE;

INSERT INTO Actor (id, firstName, SecondName)
VALUES (1, N'Вигго', N'Мортенсен'),
	   (2, N'Леонардо', N'ДиКаприо'),
	   (3, N'Руперт', N'Гринт'),
	   (4, N'Сэм', N'Уортингтон'),
	   (5, N'Дэниэл', N'Рэдклифф'),
	   (6, N'Джонни', N'Депп'),
	   (7, N'Киллиан', N'Мерфи'),
	   (8, N'Эмма', N'Уотсон'),
	   (9, N'Кейт', N'Уинслет'),
	   (10, N'Эмили', N'Блант');
GO
SELECT *
FROM Actor;

-------------------------------------------------------

CREATE TABLE Genre
(
id INT NOT NULL PRIMARY KEY,
name NVARCHAR(50) NOT NULL
) AS NODE; 

INSERT INTO Genre (id, name)
VALUES (1, N'Фантастика'),
	   (2, N'Биография'),
	   (3, N'Драма'),
	   (4, N'Боевик');
GO
SELECT *
FROM Genre;

-------------------------------------------------------

CREATE TABLE Movie
(
id INT NOT NULL PRIMARY KEY,
name NVARCHAR(50) NOT NULL,
genre NVARCHAR(30) NOT NULL
) AS NODE; 

INSERT INTO Movie (id, name, genre)
VALUES (1, N'Зелёная книга', N'Биография'),
	   (2, N'Титаник', N'Драма'),
	   (3, N'Пираты карибского моря', N'Боевик'),
	   (4, N'Оппенгеймер', N'Биография'),
	   (5, N'Гарри Поттер', N'Фантастика'),
	   (6, N'Аватар', N'Фантастика');
GO
SELECT *
FROM Movie;

CREATE TABLE BelongsTo AS EDGE;-- Связь фильм снят в жанре
CREATE TABLE ActedIn  AS EDGE;-- Связь актеры снимались в фильме
CREATE TABLE ActedInGenre AS EDGE;--Актер снялся в жанре

ALTER TABLE BelongsTo
ADD CONSTRAINT EC_BelongsTo CONNECTION (Movie TO Genre);
ALTER TABLE ActedIn
ADD CONSTRAINT EC_ActedIn CONNECTION (Actor TO Movie);
ALTER TABLE ActedInGenre
ADD CONSTRAINT EC_ActedInGenre CONNECTION (Actor TO Genre);
GO

------------------------------------------------------

INSERT INTO ActedIn ($from_id, $to_id)
VALUES ((SELECT $node_id FROM Actor WHERE ID = 1),
 (SELECT $node_id FROM Movie WHERE ID = 1)),
 ((SELECT $node_id FROM Actor WHERE ID = 2),
 (SELECT $node_id FROM Movie WHERE ID = 2)),
 ((SELECT $node_id FROM Actor WHERE ID = 9),
 (SELECT $node_id FROM Movie WHERE ID = 2)),
 ((SELECT $node_id FROM Actor WHERE ID = 6),
 (SELECT $node_id FROM Movie WHERE ID = 3)),
 ((SELECT $node_id FROM Actor WHERE ID = 7),
 (SELECT $node_id FROM Movie WHERE ID = 4)),
 ((SELECT $node_id FROM Actor WHERE ID = 10),
 (SELECT $node_id FROM Movie WHERE ID = 4)),
 ((SELECT $node_id FROM Actor WHERE ID = 5),
 (SELECT $node_id FROM Movie WHERE ID = 5)),
 ((SELECT $node_id FROM Actor WHERE ID = 3),
 (SELECT $node_id FROM Movie WHERE ID = 5)),
 ((SELECT $node_id FROM Actor WHERE ID = 8),
 (SELECT $node_id FROM Movie WHERE ID = 5)),
 ((SELECT $node_id FROM Actor WHERE ID = 4),
 (SELECT $node_id FROM Movie WHERE ID = 6));
 
INSERT INTO BelongsTo ($from_id, $to_id)
VALUES ((SELECT $node_id FROM Movie WHERE ID = 5),
 (SELECT $node_id FROM Genre WHERE ID = 1)),
 ((SELECT $node_id FROM Movie WHERE ID = 6),
 (SELECT $node_id FROM Genre WHERE ID = 1)),
 ((SELECT $node_id FROM Movie WHERE ID = 1),
 (SELECT $node_id FROM Genre WHERE ID = 2)),
 ((SELECT $node_id FROM Movie WHERE ID = 4),
 (SELECT $node_id FROM Genre WHERE ID = 2)),
 ((SELECT $node_id FROM Movie WHERE ID = 3),
 (SELECT $node_id FROM Genre WHERE ID = 4)),
 ((SELECT $node_id FROM Movie WHERE ID = 2),
 (SELECT $node_id FROM Genre WHERE ID = 3));

 INSERT INTO ActedInGenre ($from_id, $to_id)
VALUES ((SELECT $node_id FROM Actor WHERE ID = 1),
 (SELECT $node_id FROM Genre WHERE ID = 1)),
 ((SELECT $node_id FROM Actor WHERE ID = 7),
 (SELECT $node_id FROM Genre WHERE ID = 1)),
 ((SELECT $node_id FROM Actor WHERE ID = 10),
 (SELECT $node_id FROM Genre WHERE ID = 1)),
 ((SELECT $node_id FROM Actor WHERE ID = 5),
 (SELECT $node_id FROM Genre WHERE ID = 2)),
 ((SELECT $node_id FROM Actor WHERE ID = 3),
 (SELECT $node_id FROM Genre WHERE ID = 2)),
 ((SELECT $node_id FROM Actor WHERE ID = 8),
 (SELECT $node_id FROM Genre WHERE ID = 2)),
 ((SELECT $node_id FROM Actor WHERE ID = 4),
 (SELECT $node_id FROM Genre WHERE ID = 2)),
 ((SELECT $node_id FROM Actor WHERE ID = 2),
 (SELECT $node_id FROM Genre WHERE ID = 3)),
 ((SELECT $node_id FROM Actor WHERE ID = 9),
 (SELECT $node_id FROM Genre WHERE ID = 3)),
 ((SELECT $node_id FROM Actor WHERE ID = 6),
 (SELECT $node_id FROM Genre WHERE ID = 4));
 
 SELECT * FROM ActedIn
 SELECT * FROM BelongsTo
 SELECT * FROM ActedInGenre

 -------------------------------------------

SELECT Movie.name AS movie
 , Actor.firstName AS ActorFirstName
 , Actor.SecondName AS ActorLastName
 , Movie.genre AS Genre
FROM Movie
, ActedIn 
, Actor 
WHERE MATCH (Actor-(ActedIn)->Movie)
  AND Movie.name = 'Гарри Поттер';

 SELECT Movie.name AS movie
 , Genre.name AS Genre
FROM Movie
  , BelongsTo
  , Genre
WHERE MATCH (Movie-(BelongsTo)->Genre)

SELECT Genre.name AS Genre
 , Actor.firstName AS ActorFirstName
 , Actor.SecondName AS ActorLastName
FROM Genre
, ActedInGenre 
, Actor 
WHERE MATCH (Actor-(ActedInGenre)->Genre)
  AND Genre.name = 'Фантастика';

  SELECT Movie.name AS movie
 , Genre.name AS Genre
FROM Movie
, BelongsTo 
, Genre 
WHERE MATCH (Movie-(BelongsTo)->Genre)
  AND Genre.name = 'Биография';

  SELECT Movie.name AS movie
 , Actor.firstName AS ActorFirstName
 , Actor.SecondName AS ActorLastName
FROM Movie
, ActedIn 
, Actor 
WHERE MATCH (Actor-(ActedIn)->Movie)

SELECT Genre.name AS genre, STRING_AGG(Movie.name, ', ') AS movies
FROM Genre, BelongsTo, Movie
WHERE Genre.$node_id = BelongsTo.$to_id
  AND Movie.$node_id = BelongsTo.$from_id
  AND Genre.name = 'Фантастика'
GROUP BY Genre.name;

SELECT Movie.name AS movie, STRING_AGG(Genre.name, ', ') AS Genres
FROM Movie
JOIN BelongsTo ON Movie.$node_id = BelongsTo.$from_id
JOIN Genre ON Genre.$node_id = BelongsTo.$to_id
WHERE Movie.name = 'Зелёная книга'
GROUP BY Movie.name;