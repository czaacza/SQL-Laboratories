DROP TABLE FIRMY
DROP TABLE OSOBY
DROP TABLE MIASTA
DROP TABLE WOJ



CREATE TABLE dbo.WOJ 
( kod_woj nchar(4) NOT NULL CONSTRAINT PK_WOJ PRIMARY KEY 
, nazwa nvarchar(50) NOT NULL 
)

CREATE TABLE dbo.MIASTA
(	id_miasta	int				not null	IDENTITY CONSTRAINT PK_MIASTA PRIMARY KEY
,	nazwa		nvarchar(50)	not null	
,	kod_woj		nchar(4)		not null	CONSTRAINT FK_MIASTA_WOJ 
											FOREIGN KEY REFERENCES WOJ(kod_woj)
)

CREATE TABLE dbo.OSOBY
(
	id_osoby	int				not null	IDENTITY CONSTRAINT PK_OSOBY PRIMARY KEY
,	id_miasta	int				not null	CONSTRAINT FK_OSOBY_MIASTA 
											FOREIGN KEY REFERENCES MIASTA(id_miasta)
,	imie		nvarchar(50)	not null	
,	nazwisko	nvarchar(50)	not null	
)

GO

CREATE TABLE FIRMY
(
	nazwa_skr		nchar(4)		not null	CONSTRAINT PK_FIRMY PRIMARY KEY
,	id_miasta		int				not null	CONSTRAINT FK_FIRMY_MIASTA
												FOREIGN KEY REFERENCES MIASTA(id_miasta)
,	nazwa			nvarchar(50)	not null	
,	kod_pocztowy	nchar(5)		not null
,	ulica			nvarchar(50)	not null	
)



GO

INSERT INTO WOJ (kod_woj, nazwa)	VALUES (N'mazo', N'Mazowieckie')
INSERT INTO WOJ (kod_woj, nazwa)	VALUES (N'wiel', N'Wielkopolskie')
INSERT INTO WOJ (kod_woj, nazwa)	VALUES (N'malo', N'Malopolskie')
INSERT INTO WOJ (kod_woj, nazwa)	VALUES (N'doln', N'Dolnoslaskie')
INSERT INTO WOJ (kod_woj, nazwa)	VALUES (N'swie', N'Swietokrzyskie')
INSERT INTO WOJ (kod_woj, nazwa)	VALUES (N'pomo', N'Pomorskie')


INSERT INTO MIASTA (nazwa, kod_woj)	VALUES (N'Warszawa' , N'mazo')
INSERT INTO MIASTA (nazwa, kod_woj)	VALUES (N'Pruszkow' , N'mazo')
INSERT INTO MIASTA (nazwa, kod_woj)	VALUES (N'Wroclaw' , N'doln')
INSERT INTO MIASTA (nazwa, kod_woj)	VALUES (N'Poznan' , N'wiel')
INSERT INTO MIASTA (nazwa, kod_woj)	VALUES (N'Milanowek' , N'mazo')
INSERT INTO MIASTA (nazwa, kod_woj)	VALUES (N'Walbrzych' , N'doln')
INSERT INTO MIASTA (nazwa, kod_woj)	VALUES (N'Legnica' , N'doln')
INSERT INTO MIASTA (nazwa, kod_woj)	VALUES (N'Kalisz' , N'wiel')
INSERT INTO MIASTA (nazwa, kod_woj)	VALUES (N'Konin' , N'wiel')
INSERT INTO MIASTA (nazwa, kod_woj)	VALUES (N'Wolomin' , N'mazo')
INSERT INTO MIASTA (nazwa, kod_woj)	VALUES (N'Krakow' , N'malo')
INSERT INTO MIASTA (nazwa, kod_woj)	VALUES (N'Wieliczka' , N'malo')


INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (1 , N'Jan', N'Kowalski')
INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (4 , N'Adam', N'Nowak')
INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (7 , N'Ferdynand', N'Kiepski')
INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (6 , N'Andrzej', N'Bebech')
INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (2 , N'Krystian', N'Szampanski')
INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (11 , N'Kinga', N'Lorneta')
INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (1 , N'Alicja', N'Kapuczynska')
INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (8 , N'Tomasz', N'Kafelek')
INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (3 , N'Jan', N'Tangowski')
INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (5 , N'Mateusz', N'Pagowski')
INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (1 , N'Marcin', N'Majkut')
INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (9 , N'Lukasz', N'Stefanski')
INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (12 , N'Robert', N'Pudzianowski')
INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (2, N'Anna', N'Kafelek')


INSERT INTO FIRMY(nazwa_skr ,id_miasta, nazwa, kod_pocztowy, ulica)	VALUES (N'goog', 1, N'Google', N'00001', N'Mazowiecka')
INSERT INTO FIRMY(nazwa_skr ,id_miasta, nazwa, kod_pocztowy, ulica)	VALUES (N'sams', 1, N'Samsung', N'05800', N'Kierowska')
INSERT INTO FIRMY(nazwa_skr ,id_miasta, nazwa, kod_pocztowy, ulica)	VALUES (N'appl', 1, N'Apple', N'45573', N'Trebicka')
INSERT INTO FIRMY(nazwa_skr ,id_miasta, nazwa, kod_pocztowy, ulica)	VALUES (N'goog', 1, N'Google', N'00001', N'Mazowiecka')
INSERT INTO FIRMY(nazwa_skr ,id_miasta, nazwa, kod_pocztowy, ulica)	VALUES (N'goog', 1, N'Google', N'00001', N'Mazowiecka')
INSERT INTO FIRMY(nazwa_skr ,id_miasta, nazwa, kod_pocztowy, ulica)	VALUES (N'goog', 1, N'Google', N'00001', N'Mazowiecka')
INSERT INTO FIRMY(nazwa_skr ,id_miasta, nazwa, kod_pocztowy, ulica)	VALUES (N'goog', 1, N'Google', N'00001', N'Mazowiecka')
INSERT INTO FIRMY(nazwa_skr ,id_miasta, nazwa, kod_pocztowy, ulica)	VALUES (N'goog', 1, N'Google', N'00001', N'Mazowiecka')



SELECT * FROM WOJ
SELECT * FROM MIASTA
SELECT * FROM OSOBY