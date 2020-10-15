--1 do 4--
--export ddl z vertabelo, plik dodany do repozytorium

--5--
--zrobione w gui pgAdmin


--6--
INSERT INTO sklep.producenci(id_producenta, nazwa_producenta, mail, telefon)
VALUES
(1, 'Macho', 'macho@m.com', '123123123'),
(2, 'Rossman', 'ross@man.com', '222222222'),
(3, 'NoteStore', 'noted@tore.com', '777444555'),
(4, 'GervasionCorp', 'gervasion@corp.com', '444888999'),
(5, 'Chiqita', 'chiqi@corp.com', '555888999'),
(6, 'DuraLex', 'dura@lex.com', '666888999'),
(7, 'SedLex', 'sed@lex.com', '777888999'),
(8, 'Woody', 'woodys@usaf.com', '888888999'),
(9, 'Bricky', 'brick@corp.com', '999888999'),
(10, 'Glassy', 'glass@city.com', '101888999');


INSERT INTO sklep.produkty(id_produktu, nazwa_produktu, cena, producenci_id_producenta)
VALUES
(1, 'Tupet', 222.00, 1),
(2, 'OldSpice', 10.20, 2),
(3, 'NewWorld', 9.90, 2),
(4, 'AsusNotebook', 3202.50, 3),
(5, 'GervasionCloudApplication', 500000.00, 4),
(6, 'SweetBananas', 11.99, 5),
(7, 'LeftWingEconomicTheory', 40.00, 6),
(8, 'RightWingEconomicTheory', 50.99, 7),
(9, 'PremiumBananas', 19.99, 5),
(10, 'WoodenTable', 3500.00, 8),
(11, 'BrickWall', 2000.00, 9),
(12, 'GlassDoor', 3000.00, 10);


INSERT INTO sklep.zamowienia(id_zamowienia, ilosc, data, produkty_id_produktu)
VALUES
(1,  760,  '2020-01-01',  1),
(2,  420,  '2020-01-02',  2),
(3,  550,  '2020-01-03',  2),
(4,  30,  '2020-01-04',  3),
(5,  5,  '2020-01-05',  12),
(6,  7, '2020-01-06',  4),
(7,  12,  '2020-01-07',  4),
(8,  2,    '2020-01-08',  5),
(9,  50000,    '2020-01-09',  6),
(10, 23, '2020-02-01',  7),
(11, 25,   '2020-02-02',  7),
(12, 33,   '2020-02-03',  7),
(13, 200,  '2020-02-04',  7),
(14, 50,   '2020-02-05',  8),
(15, 30000,   '2020-02-06',  9),
(16, 12000,   '2020-02-07',  9),
(17, 3000, '2020-02-08', 10),
(18, 2550, '2020-02-09', 10),
(19, 1200, '2020-03-01', 10),
(20, 80,   '2020-03-02', 11);


--7 do 10--
--robilem w gui ale wykonaly sie natepujace polecenia: 
C:\Program Files\PostgreSQL\13\bin\pg_dump.exe --file "C:\\Users\\Adrian\\DOCUME~1\\my_backup" --host "localhost" --port "5432" --username "postgres" --no-password --verbose --format=d "s270683"

--potem backup wykonal:

C:\Program Files\PostgreSQL\13\bin\pg_restore.exe --host "localhost" --port "5432" --username "postgres" --no-password --dbname "s270683_backup" --format=d --verbose "C:\\Users\\Adrian\\DOCUME~1\\MY_BAC~1\\"

--przywracanie udalo sie


--11--
SELECT CONCAT('Producent: ', nazwa_producenta, ', liczba zamowien: ', SUM(ilosc), ', wartosc zamowienia: ', SUM(ilosc*cena)) FROM sklep.zamowienia RIGHT JOIN sklep.produkty ON sklep.produkty.id_produktu = sklep.zamowienia.produkty_id_produktu RIGHT JOIN sklep.producenci ON sklep.producenci.id_producenta = sklep.produkty.producenci_id_producenta GROUP BY sklep.producenci.id_producenta;

SELECT CONCAT('Produkt: ', nazwa_produktu, ', liczba zamowien: ', COUNT(id_zamowienia)) FROM sklep.produkty JOIN sklep.zamowienia ON sklep.produkty.id_produktu = sklep.zamowienia.produkty_id_produktu GROUP BY sklep.produkty.nazwa_produktu;

SELECT * FROM sklep.produkty NATURAL JOIN sklep.zamowienia;

SELECT * FROM sklep.zamowienia WHERE DATE_PART('month', data) = 1;

SELECT SUM(ilosc*cena) AS sprzedaz, DATE_PART('dow', data) AS dzien_tygodnia FROM sklep.zamowienia JOIN sklep.produkty ON id_produktu = produkty_id_produktu GROUP BY dzien_tygodnia ORDER BY sprzedaz DESC;

SELECT nazwa_produktu, COUNT(id_zamowienia) AS ilosc_zamowien FROM sklep.zamowienia JOIN sklep.produkty ON id_produktu = produkty_id_produktu GROUP BY nazwa_produktu ORDER BY ilosc_zamowien DESC;
 
 
--12--
SELECT CONCAT('Produkt ', UPPER(nazwa_produktu), ' którego producentem jest ', LOWER(nazwa_producenta), ', zamówiono ', COUNT(ilosc), ' razy') AS opis FROM sklep.produkty JOIN sklep.producenci ON id_producenta = producenci_id_producenta JOIN sklep.zamowienia ON id_produktu = produkty_id_produktu GROUP BY nazwa_produktu, nazwa_producenta ORDER BY COUNT(ilosc) DESC;

SELECT * FROM sklep.zamowienia JOIN sklep.produkty ON id_produktu = produkty_id_produktu ORDER BY (cena * ilosc ) DESC LIMIT ( SELECT COUNT(*) FROM sklep.zamowienia ) - 3;

CREATE TABLE sklep.klienci (id_klienta INT PRIMARY KEY, mail TEXT NOT NULL, telefon TEXT NOT NULL);

ALTER TABLE sklep.zamowienia ADD COLUMN klienci_id_klienta INT REFERENCES sklep.klienci(id_klienta);

INSERT INTO sklep.klienci(id_klienta,mail,telefon) VALUES
(1,'klient1@k.pl','111-111-111'),
(2,'klient2@k.pl','222-222-222'),
(3,'klient3@k.pl','333-333-333'),
(4,'klient4@k.pl','444-444-444'),
(5,'klient5@k.pl','555-555-555'),
(6,'klient6@k.pl','666-666-666'),
(7,'klient7@k.pl','777-777-777'),
(8,'klient8@k.pl','888-888-888'),
(9,'klient9@k.pl','999-999-999'),
(10,'klient10@k.pl','101-101-101');

UPDATE sklep.zamowienia SET klienci_id_klienta = id_zamowienia WHERE id_zamowienia < 11;
--niby jest ok ale select zwraca nulle w calej kolumnie, dlaczego? :/


SELECT klienci.*, nazwa_produktu, ilosc, SUM(cena*ilosc) AS wartosc_zamowienia FROM sklep.klienci JOIN sklep.zamowienia ON id_klienta = klienci_id_klienta JOIN sklep.produkty ON produkty_id_produktu = id_produktu GROUP BY id_klienta, nazwa_produktu, ilosc;

SELECT CONCAT('NAJCZESCIEJ ZAMAWIAJACY: ', id_klienta, ', ilosc zamowien: ', COUNT(id_zamowienia), ', wartosc: ', SUM(ilosc*cena)) FROM sklep.zamowienia JOIN sklep.klienci ON id_klienta = klienci_id_klienta JOIN sklep.produkty ON produkty_id_produktu = id_produktu GROUP BY id_klienta ORDER BY COUNT(id_zamowienia) DESC LIMIT 1;

DELETE FROM sklep.produkty WHERE id_produktu IN (SELECT produkty_id_produktu FROM sklep.zamowienia RIGHT JOIN sklep.produkty ON id_produktu = produkty_id_produktu GROUP BY produkty_id_produktu HAVING COUNT(id_zamowienia) = 0);



--13--
CREATE TABLE numer (liczba INT CHECK(liczba BETWEEN 0 AND 9999));

CREATE SEQUENCE liczba_seq START WITH 100 INCREMENT BY 5 MINVALUE 0 MAXVALUE 125 CYCLE;
INSERT INTO numer VALUES(nextval('liczba_seq'));
INSERT INTO numer VALUES(nextval('liczba_seq'));
INSERT INTO numer VALUES(nextval('liczba_seq'));
INSERT INTO numer VALUES(nextval('liczba_seq'));
INSERT INTO numer VALUES(nextval('liczba_seq'));
INSERT INTO numer VALUES(nextval('liczba_seq'));
INSERT INTO numer VALUES(nextval('liczba_seq'));

ALTER SEQUENCE liczba_seq INCREMENT BY 6;
SELECT nextval('liczba_seq');
SELECT nextval('liczba_seq');
DROP SEQUENCE liczba_seq;


--14--
\du
CREATE USER Superuser270683 SUPERUSER;
CREATE USER guest270683;
GRANT SELECT ON ALL TABLES IN SCHEMA firma TO guest298267;
GRANT SELECT ON ALL TABLES IN SCHEMA sklep TO guest298267;
\du
ALTER USER Superuser298267 RENAME TO student;
ALTER USER student WITH NOSUPERUSER;
GRANT SELECT ON ALL TABLES IN SCHEMA firma TO student;
GRANT SELECT ON ALL TABLES IN SCHEMA sklep TO student;
DROP OWNED BY guest298267;
DROP USER guest298267;

 
--15--
BEGIN;
UPDATE produkty SET cena = cena + CAST(10 AS MONEY);
COMMIT;

BEGIN;
UPDATE produkty SET cena = 1.1*cena WHERE id_produktu = 3;
SAVEPOINT S1;
UPDATE zamowienia SET ilosc = 1.25*ilosc;
SAVEPOINT S2;
DELETE FROM klienci WHERE id_klienta IN (SELECT id_klienta FROM klienci JOIN zamowienia ON klienci.id_klienta = zamowienia.klienci_id_klienta JOIN produkty ON produkty.id_produktu = zamowienia.id_produktu GROUP BY klienci.id_klienta ORDER BY SUM(cena*ilosc) DESC LIMIT 1);
ROLLBACK TO S1;
ROLLBACK TO S2;
ROLLBACK;
COMMIT;

CREATE OR REPLACE FUNCTION udzial()
RETURNS TABLE (procent text) AS
$func$
BEGIN
	RETURN QUERY
	SELECT CONCAT(nazwa_producenta, ': ', (COUNT(id_zamowienia) / CAST((SELECT COUNT(*) FROM zamowienia) AS FLOAT))*100, '%') FROM producenci JOIN produkty ON producenci.id_producenta = produkty.id_producenta JOIN zamowienia ON produkty.id_produktu = zamowienia.id_produktu GROUP BY (producenci.id_producenta);
END
$func$ LANGUAGE plpgsql;

SELECT udzial();

 