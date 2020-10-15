-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-10-14 23:24:22.992

CREATE SCHEMA firma;
CREATE SCHEMA sklep;;

-- tables
-- Table: godziny
CREATE TABLE firma.godziny (
    id_godziny int  NOT NULL,
    data date  NOT NULL,
    liczba_godzin int  NOT NULL,
    pracownicy_id_pracownika int  NOT NULL,
    CONSTRAINT godziny_pk PRIMARY KEY (id_godziny)
);

-- Table: pensja_stanowisko
CREATE TABLE firma.pensja_stanowisko (
    id_pensji int  NOT NULL,
    stanowisko Text  NOT NULL,
    kwota Float  NULL,
    CONSTRAINT pensja_stanowisko_pk PRIMARY KEY (id_pensji)
);

-- Table: pracownicy
CREATE TABLE firma.pracownicy (
    id_pracownika int  NOT NULL,
    imie Text  NOT NULL,
    nazwisko Text  NOT NULL,
    adres Text  NOT NULL,
    telefon Text  NOT NULL,
    CONSTRAINT pracownicy_pk PRIMARY KEY (id_pracownika)
);

-- Table: premia
CREATE TABLE firma.premia (
    id_premii int  NOT NULL,
    rodzaj Text  NULL,
    kwota Float  NULL,
    CONSTRAINT premia_pk PRIMARY KEY (id_premii)
);

-- Table: producenci
CREATE TABLE sklep.producenci (
    id_producenta int  NOT NULL,
    nazwa_producenta Text  NOT NULL,
    mail Text  NOT NULL,
    telefon Text  NOT NULL,
    CONSTRAINT producenci_pk PRIMARY KEY (id_producenta)
);

-- Table: produkty
CREATE TABLE sklep.produkty (
    id_produktu int  NOT NULL,
    nazwa_produktu Text  NOT NULL,
    cena Float  NOT NULL,
    producenci_id_producenta int  NOT NULL,
    CONSTRAINT produkty_pk PRIMARY KEY (id_produktu)
);

-- Table: wynagrodzenie
CREATE TABLE firma.wynagrodzenie (
    id_wynagordzenia int  NOT NULL,
    data date  NOT NULL,
    pracownicy_id_pracownika int  NOT NULL,
    premia_id_premii int  NOT NULL,
    pensja_stanowisko_id_pensji int  NOT NULL,
    godziny_id_godziny int  NOT NULL,
    CONSTRAINT wynagrodzenie_pk PRIMARY KEY (id_wynagordzenia)
);

-- Table: zamowienia
CREATE TABLE sklep.zamowienia (
    id_zamowienia int  NOT NULL,
    ilosc Float  NOT NULL,
    data date  NOT NULL,
    produkty_id_produktu int  NOT NULL,
    CONSTRAINT zamowienia_pk PRIMARY KEY (id_zamowienia)
);

-- foreign keys
-- Reference: godziny_pracownicy (table: godziny)
ALTER TABLE firma.godziny ADD CONSTRAINT godziny_pracownicy
    FOREIGN KEY (pracownicy_id_pracownika)
    REFERENCES firma.pracownicy (id_pracownika)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: produkty_producenci (table: produkty)
ALTER TABLE sklep.produkty ADD CONSTRAINT produkty_producenci
    FOREIGN KEY (producenci_id_producenta)
    REFERENCES sklep.producenci (id_producenta)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: wynagrodzenie_godziny (table: wynagrodzenie)
ALTER TABLE firma.wynagrodzenie ADD CONSTRAINT wynagrodzenie_godziny
    FOREIGN KEY (godziny_id_godziny)
    REFERENCES firma.godziny (id_godziny)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: wynagrodzenie_pensja_stanowisko (table: wynagrodzenie)
ALTER TABLE firma.wynagrodzenie ADD CONSTRAINT wynagrodzenie_pensja_stanowisko
    FOREIGN KEY (pensja_stanowisko_id_pensji)
    REFERENCES firma.pensja_stanowisko (id_pensji)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: wynagrodzenie_pracownicy (table: wynagrodzenie)
ALTER TABLE firma.wynagrodzenie ADD CONSTRAINT wynagrodzenie_pracownicy
    FOREIGN KEY (pracownicy_id_pracownika)
    REFERENCES firma.pracownicy (id_pracownika)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: wynagrodzenie_premia (table: wynagrodzenie)
ALTER TABLE firma.wynagrodzenie ADD CONSTRAINT wynagrodzenie_premia
    FOREIGN KEY (premia_id_premii)
    REFERENCES firma.premia (id_premii)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: zamowienia_produkty (table: zamowienia)
ALTER TABLE sklep.zamowienia ADD CONSTRAINT zamowienia_produkty
    FOREIGN KEY (produkty_id_produktu)
    REFERENCES sklep.produkty (id_produktu)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- sequences
-- Sequence: godziny_seq
CREATE SEQUENCE godziny_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: pensja_stanowisko_seq
CREATE SEQUENCE pensja_stanowisko_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: pracownicy_seq
CREATE SEQUENCE pracownicy_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: premia_seq
CREATE SEQUENCE premia_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: producenci_seq
CREATE SEQUENCE producenci_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: produkty_seq
CREATE SEQUENCE produkty_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: wynagrodzenie_seq
CREATE SEQUENCE wynagrodzenie_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: zamowienia_seq
CREATE SEQUENCE zamowienia_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- End of file.

