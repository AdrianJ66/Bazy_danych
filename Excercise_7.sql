270683
Adrian Jakieła

--1--
CREATE DATABASE cw7;

--Wczytałem backup w PgAdminie.

CREATE EXTENSION postgis_raster;
ALTER SCHEMA "schema_name" RENAME TO "jakiela";

--2-- Wczytywanie rastrów
raster2pgsql -s 3763 -N -32767 -t 100x100 -I -C -M -d srtm_1arc_v3.tif rasters.dem | psql -d cw7 -U postgres
raster2pgsql -s 3763 -N -32767 -t 128x128 -I -C -M -d Landsat8_L1TP_RGBN.TIF rasters.landsat8 | psql -d cw7 -U postgres


--3-- ST_Intersects
CREATE TABLE jakiela.intersects AS
SELECT a.rast, b.municipality
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE ST_Intersects(a.rast, b.geom) AND lower(b.municipality) like 'porto';

alter table jakiela.intersects
add column rid SERIAL PRIMARY KEY;

CREATE INDEX idx_intersects_rast_gist ON jakiela.intersects
USING gist (ST_ConvexHull(rast));

SELECT AddRasterConstraints('jakiela'::name,
'intersects'::name,'rast'::name);

--4-- ST_Clip
CREATE TABLE jakiela.clip AS
SELECT ST_Clip(a.rast, b.geom, true), b.municipality
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE ST_Intersects(a.rast, b.geom) AND lower(b.municipality) like 'porto';


--5-- ST_Union
CREATE TABLE jakiela.union AS
SELECT ST_Union(ST_Clip(a.rast, b.geom, true))
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE lower(b.municipality) like 'porto' and ST_Intersects(b.geom,a.rast);


--6-- ST_AsRaster
CREATE TABLE jakiela.porto_parishes AS
WITH r AS (
SELECT rast FROM rasters.dem
LIMIT 1
)
SELECT ST_AsRaster(a.geom,r.rast,'8BUI',a.id,-32767) AS rast
FROM vectors.porto_parishes AS a, r
WHERE lower(a.municipality) like 'porto';


--7-- 
create table jakiela.intersection as
SELECT
a.rid,(ST_Intersection(b.geom,a.rast)).geom,(ST_Intersection(b.geom,a.rast)
).val
FROM rasters.landsat8 AS a, vectors.porto_parishes AS b
WHERE lower(b.parish) like 'paranhos' and ST_Intersects(b.geom,a.rast);


--8-- Dump Polygons
CREATE TABLE jakiela.dumppolygons AS
SELECT
a.rid,(ST_DumpAsPolygons(ST_Clip(a.rast,b.geom))).geom,(ST_DumpAsPolygons(ST_Clip(a.rast,b.geom))).val
FROM rasters.landsat8 AS a, vectors.porto_parishes AS b
WHERE lower(b.parish) like 'paranhos' and ST_Intersects(b.geom,a.rast);


--9-- Analiza rastrów
CREATE TABLE jakiela.landsat_nir AS
SELECT rid, ST_Band(rast,4) AS rast
FROM rasters.landsat8;

CREATE TABLE jakiela.paranhos_dem AS
SELECT a.rid,ST_Clip(a.rast, b.geom,true) as rast
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE lower(b.parish) like 'paranhos' and ST_Intersects(b.geom,a.rast);

CREATE TABLE jakiela.paranhos_slope AS
SELECT a.rid,ST_Slope(a.rast,1,'32BF','PERCENTAGE') as rast
FROM jakiela.paranhos_dem AS a;

CREATE TABLE jakiela.paranhos_slope_reclass AS
SELECT a.rid,ST_Reclass(a.rast,1,']0-15]:1, (15-30]:2, (30-9999:3',
'32BF',0)
FROM jakiela.paranhos_slope AS a;


--10-- TPI
create table jakiela.tpi30 as
select ST_TPI(a.rast,1) as rast
from rasters.dem a;

CREATE INDEX idx_tpi30_rast_gist ON jakiela.tpi30
USING gist (ST_ConvexHull(rast));

SELECT AddRasterConstraints('jakiela'::name,
'tpi30'::name,'rast'::name);


--Problem do samodzielnego rozwazenia:
create table jakiela.tpi30_porto as
SELECT ST_TPI(a.rast,1) as rast
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE ST_Intersects(a.rast, b.geom) AND lower(b.municipality) like 'porto';

CREATE INDEX idx_tpi30_porto_rast_gist ON jakiela.tpi30_porto
USING gist (ST_ConvexHull(rast));

SELECT AddRasterConstraints('jakiela'::name,
'tpi30_porto'::name,'rast'::name);

--Algebra map
CREATE TABLE jakiela.porto_ndvi AS
WITH r AS (
SELECT a.rid,ST_Clip(a.rast, b.geom,true) AS rast
FROM rasters.landsat8 AS a, vectors.porto_parishes AS b
WHERE lower(b.municipality) like 'porto' and
ST_Intersects(b.geom,a.rast)
)
SELECT
r.rid,ST_MapAlgebra(
r.rast, 1,
r.rast, 4,
'([rast2.val] - [rast1.val]) / ([rast2.val] +
[rast1.val])::float','32BF'
) AS rast
FROM r;

CREATE INDEX idx_porto_ndvi_rast_gist ON jakiela.porto_ndvi
USING gist (ST_ConvexHull(rast));

SELECT AddRasterConstraints('jakiela'::name,
'porto_ndvi'::name,'rast'::name);

--Funkcja zwrotna
create or replace function jakiela.ndvi(
value double precision [] [] [],
pos integer [][],
VARIADIC userargs text []
)
RETURNS double precision AS
$$
BEGIN
--RAISE NOTICE 'Pixel Value: %', value [1][1][1];-->For debug purposes
RETURN (value [2][1][1] - value [1][1][1])/(value [2][1][1]+value
[1][1][1]); --> NDVI calculation!
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE COST 1000;


CREATE TABLE jakiela.porto_ndvi2 AS
WITH r AS (
SELECT a.rid,ST_Clip(a.rast, b.geom,true) AS rast
FROM rasters.landsat8 AS a, vectors.porto_parishes AS b
WHERE lower(b.municipality) like 'porto' and
ST_Intersects(b.geom,a.rast)
)
SELECT
r.rid,ST_MapAlgebra(
r.rast, ARRAY[1,4],
'jakiela.ndvi(double precision[],
integer[],text[])'::regprocedure, --> This is the function!
'32BF'::text
) AS rast
FROM r;


CREATE INDEX idx_porto_ndvi2_rast_gist ON jakiela.porto_ndvi2
USING gist (ST_ConvexHull(rast));

SELECT AddRasterConstraints('jakiela'::name,
'porto_ndvi2'::name,'rast'::name);

--Zebranie wyników widoczne na screenie


