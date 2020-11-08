270683
Adrian Jakieła


--1--
 CREATE DATABASE ewkt;
\c ewkt
CREATE EXTENSION postgis;

CREATE TABLE obiekty (id INT, nazwa VARCHAR(30), geom GEOMETRY);

--a, b, c, d, e, f
INSERT INTO obiekty(id, nazwa, geom) VALUES 
(1, 'obiekt1', 'GEOMETRYCOLLECTION(LINESTRING(0 1, 1 1), CIRCULARSTRING(1 1, 2 0, 3 1, 4 2, 5 1), LINESTRING(5 1, 6 1))'),
(2, 'obiekt2', ST_Collect(ARRAY['LINESTRING(10 6, 14 6)', 'CIRCULARSTRING(14 6, 16 4, 14 2)', 'CIRCULARSTRING(14 2, 12 0, 10 2)', 'LINESTRING(10 2, 10 6)', ST_Buffer(ST_MakePoint(12, 2), 1)])),
(3, 'obiekt3', 'POLYGON((7 15, 10 17, 12 13, 7 15))'),
(4, 'obiekt4', 'LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)'),
(5, 'obiekt5', 'MULTIPOINT(30 30 59, 38 32 234)'),
(6, 'obiekt6', 'GEOMETRYCOLLECTION(LINESTRING(1 1, 3 2), POINT(4 2))');


--2--
SELECT ST_Area(ST_Buffer(ST_ShortestLine((SELECT geom FROM obiekty WHERE id = 3), (SELECT geom FROM obiekty WHERE id = 4)), 5)) as "Powierzchnia";

--3--
-- Zeby sie udalo obiekt musi byc fugura zamknieta. Musze dodac jeden punkt do obiektu. --
UPDATE obiekty SET GEOM = ST_MakePolygon(ST_AddPoint(geom, 'POINT(20 20)')) WHERE id = 4;


--4--
INSERT INTO obiekty(id, nazwa, geom) VALUES (7, 'obiekt7', ST_Collect((SELECT geom FROM obiekty WHERE id = 3), (SELECT geom FROM obiekty WHERE id = 4)));


--5--
SELECT SUM(ST_Area(ST_Buffer(geom, 5))) as "Powierzchnia" FROM obiekty WHERE ST_HasArc(geom) = FALSE;
