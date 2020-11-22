270683
Adrian Jakieła


--Najpierw wczytalem dane z plików shp to Postgresa

CREATE DATABASE qgis;
\c qgis
CREATE EXTENSION postgis;
shp2pgsql -I -s 2263 airports.shp | psql -U postgres -d qgis
shp2pgsql -I -s 2263 alaska.shp | psql -U postgres -d qgis
shp2pgsql -I -s 2263 builtups.shp | psql -U postgres -d qgis
shp2pgsql -I -s 2263 grassland.shp | psql -U postgres -d qgis
shp2pgsql -I -s 2263 lakes.shp | psql -U postgres -d qgis
shp2pgsql -I -s 2263 landice.shp | psql -U postgres -d qgis
shp2pgsql -I -s 2263 majrivers.shp | psql -U postgres -d qgis
shp2pgsql -I -s 2263 pipelines.shp | psql -U postgres -d qgis
shp2pgsql -I -s 2263 popp.shp | psql -U postgres -d qgis
shp2pgsql -I -s 2263 railroads.shp | psql -U postgres -d qgis
shp2pgsql -I -s 2263 regions.shp | psql -U postgres -d qgis
shp2pgsql -I -s 2263 rivers.shp | psql -U postgres -d qgis
shp2pgsql -I -s 2263 storagep.shp | psql -U postgres -d qgis
shp2pgsql -I -s 2263 swamp.shp | psql -U postgres -d qgis
shp2pgsql -I -s 2263 trails.shp | psql -U postgres -d qgis
shp2pgsql -I -s 2263 trees.shp | psql -U postgres -d qgis
shp2pgsql -I -s 2263 tundra.shp | psql -U postgres -d qgis

--Później połączyłem się z postgresem z QGIS i wczytałem dane do programu

--1--
--Wykonałem to zadanie wykonujac nastepujace czynnosci:
--Kliknalem PPM na tabelę trees.
--Dodałem warstwę do projektu.
--PPM na warstwę trees -> właściwości -> styl -> (wartość unikalna, wartość: vegdesc) -> klasyfikuj -> potem wybralem inne kolory.

--Obliczanie pola powierzchni:
--Instalacja i uruchomienie Group Stats ->  warstwa trees -> (przesunąć z Fields do Rows vegdesc) -> (sum i area_km^2 do Value) -> calculate

--Wyniki: (screen: ex1)


--2--
--W ustawieniach włączyłem ignorowanie nieprawidłowych geometrii. -- powoduje zawieszenie się programu. (screen: error_ex2)
--Gdyby się dało to zrobiłbym tak:
--Wektor -> Narzędzia zarządzania danymi -> Podziel warstwę wektorową -> (warstwa: "trees", pole z unikalnym ID: vegdesc) -> uruchom


--3--
--Dodałem warstwy regions i railroads
--PPM na regions -> własności warstwy ->  atrybuty -> Matanuska-Susistna(kopiuje) 
--edycja -> wklej obiekty jako -> nowa warstwa wektorowa 
--Wektor -> narzędzia geoprocesingu -> przytnij -> wybieram railroads oraz Matanuska-Susistna -> zapisuję  w nowym pliku.
--Klikam nowopowstałą warstwę -> otwórz tabelę atrybutów -> kalkulator pól -> $length 

--Wynik: (screen: ex3)


--4--
--Dodałem warstwę airports
--Group stats -> Filter -> "use" LIKE 'Military' -> przenoszę "use" do ROWS -> elev i average do values 
--Wynik: (screnn: ex4a)

--Do obliczenia ilości zamieniam average na count
--Wynik: (screnn: ex4b)

--Do określenia ilości lotnisk militarnych powyżej 1400 m n.p.m. piszę warunek
--"use" LIKE 'Military' and "elev" >= 1400
--Wynik: (screnn: ex4c) -- jest tylko jedno

--Usuwam je klikając w Feature -> show selected on map -> włączam tryb edycji -> usuń zaznaczone


--5--
--PPM na regions -> własności warstwy ->  atrybuty -> Bristol Bay(kopiuje) 
--edycja -> wklej obiekty jako -> nowa warstwa wektorowa 
--Dodaje warstwę popp -> potem wektor (jeśli znikły opcję to włączyć wtyczkę processing) -> narzędzie geoprocessingu ->przytnij -> wybieram warstwy popp i Bristol Bay
--uruchom

--Liczba budynków - 11 

--b--
--dodadałem warstwę rivers -> tworzę buffor 
--wektor -> narzędzia geopocessingu -> buffor -> wybieram warstwę, odległość 100 km 
--przyciecie robione w takie sam sposob

--Liczba budynków - 11 


--6--
-dodałem warstwę majrivers
--Wektor -> narzędzia analizy -> przycięcia linii i wybrać railroads i majrivers, stworzyć nową warstwę i na niej PPM i wyświetl liczbę obiektów 

--Liczba miejsc - 4


--7--
--Wektor -> narzędzia geometrii -> wydobądź wierzchołki -> warstwa: railroads -> uruchom 

--Liczba obiektów - 662


--8--
--dla airports -> wektor -> narzędzia geopocessingu -> buffor -> 100km 
--dla railroads -> wektor-> narzędzia geopocessingu -> buffor -> 50km
--wektor -> narzędzia geoprocesingu -> różnica -> wybieram utworzone buffory airports i railroads -> otwrzymana warstwa to rozwiazanie
--nie wiem gdzie jest warstwa z sieciami drog

--9--
--dodałem warstwę swamp 

[Wierzchołki]
--wektor -> narzędzia geometrii -> wydobądź wierzchołki

Wynik: 7469

[Powierzchnia]
--GroupStats -> areakm2 i sum do value

Wynik: 24719,8 km2

[Uproszczenie]
--wektor-> narzędzia geometrii -> uprość geometrię -> swamps i toleracja 100m
--Polę i liczba wierzchołków jest liczona w podobny sposób
-- powierzchnia: 24719.8 - bez zmian
-- wierzchołki: 6175 - (spora różnica)

