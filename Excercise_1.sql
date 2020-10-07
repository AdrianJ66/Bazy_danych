--1--
 CREATE DATABASE s270683;
--2--
CREATE SCHEMA firma;
--3--
CREATE ROLE ksiegowosc;
GRANT SELECT ON ALL TABLES IN SCHEMA firma TO ksiegowosc;
--4--
--a--
CREATE TABLE firma.pracownicy( id_pracownika INT NOT NULL,  imie TEXT NOT NULL,  nazwisko TEXT NOT NULL,  adres TEXT NOT NULL,  telefon TEXT NOT NULL);

CREATE TABLE firma.godziny( id_godziny INT NOT NULL,  data  DATE NOT NULL,  liczba_godzin INT NOT NULL,  id_pracownika INT NOT NULL);

CREATE TABLE firma.pensja_stanowisko( id_pensji INT NOT NULL,  stanowisko TEXT NOT NULL,  kwota FLOAT(2));

CREATE TABLE firma.premia( id_premii  INT NOT NULL,  rodzaj TEXT,  kwota FLOAT(2));

CREATE TABLE firma.wynagrodzenie( id_wynagrodzenia INT NOT NULL,  data DATE NOT NULL,  id_pracownika INT NOT NULL,  id_godziny INT,  id_pensji INT NOT NULL,  id_premii INT);

--b--
ALTER TABLE firma.pracownicy ADD PRIMARY KEY(id_pracownika);
ALTER TABLE firma.godziny ADD PRIMARY KEY(id_godziny);
ALTER TABLE firma.pensja_stanowisko ADD PRIMARY KEY(id_pensji);
ALTER TABLE firma.premia ADD PRIMARY KEY(id_premii);
ALTER TABLE firma.wynagrodzenie ADD PRIMARY KEY(id_wynagrodzenia);

--c--
ALTER TABLE firma.godziny  ADD CONSTRAINT pracownik  FOREIGN KEY(id_pracownika)  REFERENCES firma.pracownicy(id_pracownika);
ALTER TABLE firma.wynagrodzenie  ADD CONSTRAINT pracownik  FOREIGN KEY(id_pracownika) REFERENCES firma.pracownicy(id_pracownika), ADD CONSTRAINT godziny FOREIGN KEY(id_godziny) REFERENCES firma.godziny(id_godziny), ADD CONSTRAINT pensja FOREIGN KEY( id_pensji) REFERENCES firma.pensja_stanowisko(id_pensji), ADD CONSTRAINT premia FOREIGN KEY (id_premii) REFERENCES firma.premia(id_premii);

--d--
CREATE INDEX indexDataGodziny ON firma.godziny(data);
CREATE INDEX indexDataWynagrodzenie  ON firma.wynagrodzenie(data);


--e--
COMMENT ON TABLE firma.pracownicy IS 'To jest tabela zwierająca informacje o pracownikach';
COMMENT ON TABLE firma.godziny IS 'To jest tabela zwierająca informacje o godzinach';
COMMENT ON TABLE firma.pensja_stanowisko IS 'To jest tabela zwierająca informacje o pensjach i stanowiskach';
COMMENT ON TABLE firma.premia IS 'To jest tabela zwierająca informacje o premiach';
COMMENT ON TABLE firma.wynagrodzenie IS 'To jest tabela zwierająca informacje o wynagrodzeniach';

--f--
ALTER TABLE firma.godziny  DROP CONSTRAINT pracownik;
ALTER TABLE firma.wynagrodzenie  DROP CONSTRAINT pracownik ;
ALTER TABLE firma.wynagrodzenie DROP CONSTRAINT godziny ;
ALTER TABLE firma.wynagrodzenie DROP CONSTRAINT pensja ;
ALTER TABLE firma.wynagrodzenie DROP CONSTRAINT premia;


--5--

INSERT INTO firma.pracownicy VALUES (1,'Marek', 'Jakimowicz', 'Końskie', '111 222 333'),
(2,'Gabriel','Marcyn','Włoszczowa','121 121 211'), (3,'Adrianna', 'Kokoszka', 'Kraków', '333 222 111'), (4,'Justyna', 'Szpyrka','Starachowice','313 113 323'),(5,'Mariola', 'Łapacz', 'Krosno','414 414 414'), (6,'Zbigniew', 'Misky','Jasienica','551 551 525'), (7,'Piotr', 'Passlack','Toruń','616 616 166'), (8,'Adrian', 'Jakiela', 'Iwonicz','777 777 777'), (9,'Rafał', 'Penar', 'Rakowice', '888 888 888'), (10,'Karolina', 'Gaduła', 'Czosnek', '999 999 999');
INSERT INTO firma.godziny VALUES (1,'2020-05-10',170,1), (2,'2020-05-10',175,2), (3,'2020-05-10',164,3), (4,'2020-05-10',162,4), (5,'2020-05-10',161,5), (6,'2020-05-10',160,6), (7,'2020-05-10',175,7), (8,'2020-05-10',150,8), (9,'2020-05-10',164,9), (10,'2020-05-10',161,10) ;
INSERT INTO firma.pensja_stanowisko VALUES (1,'ScrumMaster',150), (2,'Sekretarka', 80),(3,'Tester',80),(4,'Kucharz',22),(5,'Sprzątacz',17),(6,'Stażysta',17),(7,'Kierownik',120),(8,'Kierowca',20),(9,'Junior Developer',40),(10,'Senior Developer',100);
INSERT INTO firma.premia VALUES (1,'Uznaniowa',1000),(2,'Okolicznościowa',2000),(3,'Przy awansie',3000),(4,'Za zasługi',2500),(5,'Za dobre wyniki',1500),(6,'Za poświecenie dla pracy',500),(7,'Za wybitne osiągnięcia',5000),(8,'Za skończenie projektu',800),(9,'Za skuteczność',700),(10,'Co roczna',200);
INSERT INTO firma.wynagrodzenie VALUES (1,'2020-05-10',1,1,1,NULL),(2,'2020-05-10',2,2,2,1),(3,'2020-05-10',3,3,3,2),(4,'2020-05-10',4,4,4,1),(5,'2020-05-10',5,5,5,NULL),(6,'2020-05-10',6,6,6,NULL),(7,'2020-05-10',7,7,7,NULL),(8,'2020-05-10',8,8,8,5), (9,'2020-05-10',9,9,9,9),(10,'2020-05-10',10,10,10,NULL);

--a--
ALTER TABLE firma.godziny ADD COLUMN miesiac DATE;
ALTER TABLE firma.godziny ADD COLUMN tydzien DATE;

--b--
ALTER TABLE firma.wynagrodzenie ALTER COLUMN data TYPE TEXT;


--6--
--a--
SELECT id_pracownika, nazwisko FROM firma.pracownicy;
--b--
SELECT pr.id_pracownika FROM firma.pracownicy AS pr JOIN firma.wynagrodzenie AS w ON w.id_pracownika=pr.id_pracownika  JOIN firma.pensja_stanowisko AS ps ON w.id_pensji=ps.id_pensji JOIN firma.godziny AS g ON g.id_pracownika=w.id_pracownika  WHERE liczba_godzin*kwota>1000;
--c--
SELECT pr.id_pracownika FROM firma.pracownicy AS pr JOIN firma.wynagrodzenie AS w ON w.id_pracownika=pr.id_pracownika  
JOIN firma.pensja_stanowisko AS ps ON w.id_pensji=ps.id_pensji 
JOIN firma.godziny AS g ON g.id_pracownika=w.id_pracownika 
FULL JOIN firma.premia ON premia.id_premii=w.id_premii 
WHERE liczba_godzin*ps.kwota>2000 AND w.id_premii is null AND pr.id_pracownika is not null;
--d--
SELECT imie,nazwisko FROM firma.pracownicy WHERE imie LIKE 'J%';
--e--
SELECT imie, nazwisko FROM firma.pracownicy WHERE imie LIKE '%a' AND  nazwisko LIKE '%n%';
--f--
SELECT pr.id_pracownika,imie,nazwisko,liczba_godzin FROM firma.pracownicy AS pr JOIN firma.godziny  AS g ON pr.id_pracownika=g.id_pracownika  WHERE liczba_godzin>160;
--g--
SELECT pr.id_pracownika FROM firma.pracownicy AS pr JOIN firma.wynagrodzenie AS w ON w.id_pracownika=pr.id_pracownika  JOIN firma.pensja_stanowisko AS ps ON w.id_pensji=ps.id_pensji JOIN firma.godziny AS g ON g.id_pracownika=w.id_pracownika  WHERE liczba_godzin*kwota BETWEEN 1500 AND 3000;
--h--
SELECT pr.id_pracownika,imie,nazwisko,liczba_godzin FROM firma.pracownicy AS pr JOIN firma.wynagrodzenie AS w ON w.id_pracownika=pr.id_pracownika  JOIN firma.pensja_stanowisko AS ps ON w.id_pensji=ps.id_pensji JOIN firma.godziny AS g ON g.id_pracownika=w.id_pracownika WHERE liczba_godzin>160 AND id_premii IS NULL;

--7--
--a--
SELECT pr.id_pracownika FROM firma.pracownicy AS pr JOIN firma.wynagrodzenie AS w ON w.id_pracownika=pr.id_pracownika  JOIN firma.pensja_stanowisko AS ps ON w.id_pensji=ps.id_pensji JOIN firma.godziny AS g ON g.id_pracownika=w.id_pracownika ORDER BY liczba_godzin*kwota;

--b--
SELECT  pr.id_pracownika,liczba_godzin*ps.kwota AS pensja,premia.kwota FROM firma.pracownicy AS pr JOIN firma.wynagrodzenie AS w ON w.id_pracownika=pr.id_pracownika  
JOIN firma.pensja_stanowisko AS ps ON w.id_pensji=ps.id_pensji 
JOIN firma.godziny AS g ON g.id_pracownika=w.id_pracownika 
FULL JOIN firma.premia ON premia.id_premii=w.id_premii WHERE  pr.id_pracownika is not null
ORDER BY liczba_godzin*ps.kwota DESC, premia.kwota DESC ;

--c--
SELECT COUNT(pr.id_pracownika),stanowisko FROM firma.pracownicy AS pr JOIN firma.wynagrodzenie AS w ON w.id_pracownika=pr.id_pracownika  JOIN firma.pensja_stanowisko AS ps ON w.id_pensji=ps.id_pensji JOIN firma.godziny AS g ON g.id_pracownika=w.id_pracownika GROUP BY stanowisko;

--d--
SELECT MIN(liczba_godzin*kwota),  AVG(liczba_godzin*kwota) ,  MAX(liczba_godzin*kwota) ,stanowisko FROM firma.pracownicy AS pr JOIN firma.wynagrodzenie AS w ON w.id_pracownika=pr.id_pracownika  JOIN firma.pensja_stanowisko AS ps ON w.id_pensji=ps.id_pensji JOIN firma.godziny AS g ON g.id_pracownika=w.id_pracownika GROUP BY stanowisko HAVING stanowisko='Kierownik';

--e--
SELECT SUM(liczba_godzin*kwota) FROM firma.pracownicy AS pr JOIN firma.wynagrodzenie AS w ON w.id_pracownika=pr.id_pracownika  JOIN firma.pensja_stanowisko AS ps ON w.id_pensji=ps.id_pensji JOIN firma.godziny AS g ON g.id_pracownika=w.id_pracownika;

--f--	
SELECT SUM(liczba_godzin*kwota),stanowisko FROM firma.pracownicy AS pr JOIN firma.wynagrodzenie AS w ON w.id_pracownika=pr.id_pracownika  JOIN firma.pensja_stanowisko AS ps ON w.id_pensji=ps.id_pensji JOIN firma.godziny AS g ON g.id_pracownika=w.id_pracownika GROUP BY stanowisko;


--g--
SELECT COUNT(id_premii) FROM firma.pracownicy AS pr JOIN firma.wynagrodzenie AS w ON w.id_pracownika=pr.id_pracownika  JOIN firma.pensja_stanowisko AS ps ON w.id_pensji=ps.id_pensji JOIN firma.godziny AS g ON g.id_pracownika=w.id_pracownika GROUP BY stanowisko;

--h--
DELETE FROM firma.pracownicy WHERE id_pracownika NOT IN ( SELECT pr.id_pracownika FROM firma.pracownicy AS pr JOIN firma.wynagrodzenie AS w ON w.id_pracownika=pr.id_pracownika  
JOIN firma.pensja_stanowisko AS ps ON w.id_pensji=ps.id_pensji 
JOIN firma.godziny AS g ON g.id_pracownika=w.id_pracownika 
FULL JOIN firma.premia ON premia.id_premii=w.id_premii 
WHERE liczba_godzin*ps.kwota > 2800 AND w.id_premii is null AND pr.id_pracownika is not null );

--Zmienilem wartosc bo u mnie nikt nie zarabia mniej niz 2700--

DELETE FROM firma.godziny WHERE id_pracownika NOT IN ( SELECT id_pracownika FROM firma.pracownicy );

DELETE FROM firma.wynagrodzenie WHERE id_pracownika NOT IN ( SELECT id_pracownika FROM firma.pracownicy );

DELETE FROM firma.pensja_stanowisko WHERE id_pensji NOT IN ( SELECT id_pensji FROM firma.wynagrodzenie );

DELETE FROM firma.premia WHERE id_premii NOT IN ( SELECT id_premii FROM firma.wynagrodzenie );



--8--
--a--
SELECT '(+48)'||telefon FROM firma.pracownicy;
--b--
SELECT id_pracownika,nazwisko,SUBSTRING(telefon,0,4)||'-'||SUBSTRING(telefon,4,4)||'-'||SUBSTRING(telefon,5,4) FROM firma.pracownicy;
--c--
SELECT UPPER(imie), UPPER(nazwisko) FROM firma.pracownicy WHERE (LENGTH(pracownicy.nazwisko))=(SELECT MAX(LENGTH(pracownicy.nazwisko)) FROM firma.pracownicy);
--d--
SELECT MD5(imie||nazwisko||adres||telefon||liczba_godzin*ps.kwota) FROM firma.pracownicy AS pr JOIN firma.wynagrodzenie AS w ON w.id_pracownika=pr.id_pracownika  
JOIN firma.pensja_stanowisko AS ps ON w.id_pensji=ps.id_pensji 
JOIN firma.godziny AS g ON g.id_pracownika=w.id_pracownika 
FULL JOIN firma.premia ON premia.id_premii=w.id_premii WHERE pr.id_pracownika is not null;

--9--
SELECT 'Pracownik ' || imie || ' ' || nazwisko || ', w dniu '|| EXTRACT(DAY from g.data)||'.'
||EXTRACT(MONTH FROM g.data)||'.'||EXTRACT(YEAR FROM g.data)||' otrzymał pensję całkowitą na kwotę ' 
||g.liczba_godzin*ps.kwota+firma.premia.kwota|| ' zł, gdzie wynagrodzenie zasadnicze wynosiło: '||160*ps.kwota ||' zł, premia: '
||firma.premia.kwota||' zł, nadgodziny: '||(liczba_godzin-160)*ps.kwota||' zł. '	
FROM firma.pracownicy AS pr JOIN firma.wynagrodzenie AS w ON w.id_pracownika=pr.id_pracownika  
JOIN firma.pensja_stanowisko AS ps ON w.id_pensji=ps.id_pensji 
JOIN firma.godziny AS g ON g.id_pracownika=w.id_pracownika 
FULL JOIN firma.premia ON premia.id_premii=w.id_premii WHERE pr.id_pracownika is not null;
