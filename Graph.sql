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
VALUES (1, N'�����', N'���������'),
	   (2, N'��������', N'��������'),
	   (3, N'������', N'�����'),
	   (4, N'���', N'����������'),
	   (5, N'������', N'��������'),
	   (6, N'������', N'����'),
	   (7, N'�������', N'�����'),
	   (8, N'����', N'������'),
	   (9, N'����', N'�������'),
	   (10, N'�����', N'�����');
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
VALUES (1, N'����������'),
	   (2, N'���������'),
	   (3, N'�����'),
	   (4, N'������');
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
VALUES (1, N'������ �����', N'���������'),
	   (2, N'�������', N'�����'),
	   (3, N'������ ���������� ����', N'������'),
	   (4, N'�����������', N'���������'),
	   (5, N'����� ������', N'����������'),
	   (6, N'������', N'����������');
GO
SELECT *
FROM Movie;

CREATE TABLE BelongsTo AS EDGE;-- ����� ����� ���� � �����
CREATE TABLE ActedIn  AS EDGE;-- ����� ������ ��������� � ������
CREATE TABLE ActedInGenre AS EDGE;--����� ������ � �����

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
  AND Movie.name = '����� ������';

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
  AND Genre.name = '����������';

  SELECT Movie.name AS movie
 , Genre.name AS Genre
FROM Movie
, BelongsTo 
, Genre 
WHERE MATCH (Movie-(BelongsTo)->Genre)
  AND Genre.name = '���������';

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
  AND Genre.name = '����������'
GROUP BY Genre.name;

SELECT Movie.name AS movie, STRING_AGG(Genre.name, ', ') AS Genres
FROM Movie
JOIN BelongsTo ON Movie.$node_id = BelongsTo.$from_id
JOIN Genre ON Genre.$node_id = BelongsTo.$to_id
WHERE Movie.name = '������ �����'
GROUP BY Movie.name;