
IF OBJECT_ID(N'ETATY') IS NOT NULL
	DROP TABLE ETATY
GO
IF OBJECT_ID(N'OSOBY') IS NOT NULL
	DROP TABLE OSOBY
GO
IF OBJECT_ID(N'FIRMY') IS NOT NULL
	DROP TABLE FIRMY
GO
IF OBJECT_ID(N'MIASTA') IS NOT NULL
	DROP TABLE MIASTA
GO
IF OBJECT_ID(N'WOJ') IS NOT NULL
	DROP TABLE WOJ
GO


CREATE TABLE dbo.WOJ 
( kod_woj nchar(4) NOT NULL CONSTRAINT PK_WOJ PRIMARY KEY 
, nazwa nvarchar(50) NOT NULL 
)

GO

CREATE TABLE dbo.MIASTA
(	id_miasta	int				not null	IDENTITY CONSTRAINT PK_MIASTA PRIMARY KEY
,	nazwa		nvarchar(50)	not null	
,	kod_woj		nchar(4)		not null	CONSTRAINT FK_MIASTA_WOJ 
											FOREIGN KEY REFERENCES WOJ(kod_woj)
)

GO

CREATE TABLE dbo.OSOBY
(
	id_osoby	int				not null	IDENTITY CONSTRAINT PK_OSOBY PRIMARY KEY
,	id_miasta	int				not null	CONSTRAINT FK_OSOBY_MIASTA 
											FOREIGN KEY REFERENCES MIASTA(id_miasta)
,	imie		nvarchar(50)	not null	
,	nazwisko	nvarchar(50)	not null	
)

GO

CREATE TABLE dbo.FIRMY
(
	nazwa_skr		nchar(4)		not null	CONSTRAINT PK_FIRMY PRIMARY KEY
,	id_miasta		int				not null	CONSTRAINT FK_FIRMY_MIASTA
												FOREIGN KEY REFERENCES MIASTA(id_miasta)
,	nazwa			nvarchar(50)	not null	
,	kod_pocztowy	nchar(5)		not null
,	ulica			nvarchar(50)	not null	
)

go

CREATE TABLE dbo.ETATY
(
	id_osoby	int				not null	CONSTRAINT FK_ETATY_OSOBY	FOREIGN KEY REFERENCES OSOBY(id_osoby)
,	id_firmy	nchar(4)		not null	CONSTRAINT FK_FIRMY			FOREIGN KEY REFERENCES FIRMY(nazwa_skr)
,	stanowisko	nvarchar(50)	not null	
,	pensja		MONEY			not null
,	od			DATETIME		not null
,	do			DATETIME		not null
,	id_etatu	int				not null	IDENTITY CONSTRAINT PK_ETATY	PRIMARY KEY
)

GO

INSERT INTO WOJ (kod_woj, nazwa)	VALUES (N'mazo', N'Mazowieckie')
INSERT INTO WOJ (kod_woj, nazwa)	VALUES (N'wiel', N'Wielkopolskie')
INSERT INTO WOJ (kod_woj, nazwa)	VALUES (N'malo', N'Malopolskie')
INSERT INTO WOJ (kod_woj, nazwa)	VALUES (N'doln', N'Dolnoslaskie')
INSERT INTO WOJ (kod_woj, nazwa)	VALUES (N'swie', N'Swietokrzyskie')
INSERT INTO WOJ (kod_woj, nazwa)	VALUES (N'pomo', N'Pomorskie')

DECLARE @id_wa int , @id_pr int , @id_wr int , @id_po int , @id_mi int , @id_wl int , 
		@id_le int , @id_ka int , @id_ko int , @id_wo int , @id_kr int , @id_wi int

INSERT INTO MIASTA (nazwa, kod_woj)	VALUES (N'Warszawa' , N'mazo')
SET @id_wa = SCOPE_IDENTITY()

INSERT INTO MIASTA (nazwa, kod_woj)	VALUES (N'Pruszkow' , N'mazo')
SET @id_pr = SCOPE_IDENTITY()

INSERT INTO MIASTA (nazwa, kod_woj)	VALUES (N'Wroclaw' , N'doln')
SET @id_wr = SCOPE_IDENTITY()

INSERT INTO MIASTA (nazwa, kod_woj)	VALUES (N'Poznan' , N'wiel')
SET @id_po = SCOPE_IDENTITY()

INSERT INTO MIASTA (nazwa, kod_woj)	VALUES (N'Milanowek' , N'mazo')
SET @id_mi = SCOPE_IDENTITY()

INSERT INTO MIASTA (nazwa, kod_woj)	VALUES (N'Walbrzych' , N'doln')
SET @id_wl = SCOPE_IDENTITY()

INSERT INTO MIASTA (nazwa, kod_woj)	VALUES (N'Legnica' , N'doln')
SET @id_le = SCOPE_IDENTITY()

INSERT INTO MIASTA (nazwa, kod_woj)	VALUES (N'Kalisz' , N'wiel')
SET @id_ka = SCOPE_IDENTITY()

INSERT INTO MIASTA (nazwa, kod_woj)	VALUES (N'Konin' , N'wiel')
SET @id_ko = SCOPE_IDENTITY()

INSERT INTO MIASTA (nazwa, kod_woj)	VALUES (N'Wolomin' , N'mazo')
SET @id_wo = SCOPE_IDENTITY()

INSERT INTO MIASTA (nazwa, kod_woj)	VALUES (N'Krakow' , N'malo')
SET @id_kr = SCOPE_IDENTITY()

INSERT INTO MIASTA (nazwa, kod_woj)	VALUES (N'Wieliczka' , N'malo')
SET @id_wi = SCOPE_IDENTITY()



DECLARE @id_jk int, @id_ak int, @id_fk int, @id_ab int, @id_ks int, @id_kl int, @id_aka int, 
		@id_tk int, @id_jt int, @id_mp int, @id_mm int, @id_ls int, @id_rp int, @id_akaf int

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_wa , N'Jan', N'Kowalski')
SET @id_jk = SCOPE_IDENTITY()

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_po , N'Adam', N'Nowak')
SET @id_ak = SCOPE_IDENTITY()

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_le , N'Ferdynand', N'Kiepski')
SET @id_fk = SCOPE_IDENTITY()

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_wl , N'Andrzej', N'Bebech')
SET @id_ab = SCOPE_IDENTITY()

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_pr , N'Krystian', N'Szampanski')
SET @id_ks = SCOPE_IDENTITY()

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_kr , N'Kinga', N'Lorneta')
SET @id_kl = SCOPE_IDENTITY()

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_wa , N'Alicja', N'Kapuczynska')
SET @id_aka = SCOPE_IDENTITY()

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_ka , N'Tomasz', N'Kafelek')
SET @id_tk = SCOPE_IDENTITY()

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_wr , N'Jan', N'Tangowski')
SET @id_jt = SCOPE_IDENTITY()

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_mi , N'Mateusz', N'Pagowski')
SET @id_mp = SCOPE_IDENTITY()

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_wa , N'Marcin', N'Majkut')
SET @id_mm = SCOPE_IDENTITY()

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_ko , N'Lukasz', N'Stefanski')
SET @id_ls = SCOPE_IDENTITY()

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_wi , N'Robert', N'Pudzianowski')
SET @id_rp = SCOPE_IDENTITY()

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_pr, N'Anna', N'Kafelek')
SET @id_akaf = SCOPE_IDENTITY()

INSERT INTO FIRMY(nazwa_skr ,id_miasta, nazwa, kod_pocztowy, ulica)	VALUES (N'goog', @id_wa, N'Google', N'00001', N'Mazowiecka')
INSERT INTO FIRMY(nazwa_skr ,id_miasta, nazwa, kod_pocztowy, ulica)	VALUES (N'sams', @id_pr, N'Samsung', N'05800', N'Kierowska')
INSERT INTO FIRMY(nazwa_skr ,id_miasta, nazwa, kod_pocztowy, ulica)	VALUES (N'oran', @id_wl, N'Orange', N'58160', N'Milosza')
INSERT INTO FIRMY(nazwa_skr ,id_miasta, nazwa, kod_pocztowy, ulica)	VALUES (N'xiai', @id_ka, N'Xiaiomi', N'62800', N'Tarasowska')
INSERT INTO FIRMY(nazwa_skr ,id_miasta, nazwa, kod_pocztowy, ulica)	VALUES (N'appl', @id_wr, N'Apple', N'45573', N'Trebicka')
INSERT INTO FIRMY(nazwa_skr ,id_miasta, nazwa, kod_pocztowy, ulica)	VALUES (N'pkob', @id_mi, N'PKO Bank Polski', N'05822', N'Moniuszki')
INSERT INTO FIRMY(nazwa_skr ,id_miasta, nazwa, kod_pocztowy, ulica)	VALUES (N'huaw', @id_po, N'Huawei', N'60001', N'Batorego')
INSERT INTO FIRMY(nazwa_skr ,id_miasta, nazwa, kod_pocztowy, ulica)	VALUES (N'tmob', @id_le, N'Tmobile', N'59200', N'Czeslawska')


INSERT INTO ETATY(id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES (@id_jk, N'sams', N'Menager',					27500, CONVERT(datetime, '12/08/1991', 103), CONVERT(datetime, '09/11/2015', 103) )
INSERT INTO ETATY(id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES (@id_ak, N'goog', N'Social Media specialist',	5300, CONVERT(datetime, '18/06/1999', 103), CONVERT(datetime, '21/09/2013', 103) )
INSERT INTO ETATY(id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES (@id_fk, N'oran', N'Junior Developer',			5700, CONVERT(datetime, '27/04/1999', 103), CONVERT(datetime, '11/07/2017', 103) )
INSERT INTO ETATY(id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES (@id_ab, N'xiai', N'Software Architect',		9100, CONVERT(datetime, '25/02/1999', 103), CONVERT(datetime, '16/04/2012', 103) )
INSERT INTO ETATY(id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES (@id_ks, N'appl', N'Backend Developer',		7800, CONVERT(datetime, '17/12/1999', 103), CONVERT(datetime, '15/02/2009', 103) )
INSERT INTO ETATY(id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES (@id_kl, N'pkob', N'Menager',					11500, CONVERT(datetime, '12/09/1999', 103), CONVERT(datetime, '18/08/2020', 103) )

INSERT INTO ETATY(id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES (@id_aka, N'sams', N'IT Specialist',			15200, CONVERT(datetime, '09/08/1995', 103), CONVERT(datetime, '01/11/2018', 103) )
INSERT INTO ETATY(id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES (@id_tk, N'goog', N'Project Menager',			8900, CONVERT(datetime, '31/10/1992', 103), CONVERT(datetime, '05/12/2014', 103) )
INSERT INTO ETATY(id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES (@id_jt, N'xiai', N'Scrum Master',				13100, CONVERT(datetime, '19/04/1999', 103), CONVERT(datetime, '09/04/2011', 103) )
INSERT INTO ETATY(id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES (@id_mp, N'appl', N'Product Owner',			6900, CONVERT(datetime, '25/09/2001', 103), CONVERT(datetime, '04/05/2012', 103) )
INSERT INTO ETATY(id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES (@id_mm, N'pkob', N'IT Specialist',			12300, CONVERT(datetime, '20/03/1995', 103), CONVERT(datetime, '04/08/1998', 103) )
INSERT INTO ETATY(id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES (@id_ls, N'oran', N'Programista',				11500, CONVERT(datetime, '21/06/1999', 103), CONVERT(datetime, '01/08/2008', 103) )
INSERT INTO ETATY(id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES (@id_rp, N'goog', N'Software Engeener',		14000, CONVERT(datetime, '18/10/2010', 103), CONVERT(datetime, '11/07/2017', 103) )
INSERT INTO ETATY(id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES (@id_akaf, N'appl', N'Backend Developer',		17000, CONVERT(datetime, '17/11/2005', 103), CONVERT(datetime, '18/01/2021', 103) )
INSERT INTO ETATY(id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES (@id_jk, N'xiai', N'Social Media specialist',	6800, CONVERT(datetime, '11/07/2009', 103), CONVERT(datetime, '12/03/2017', 103) )
INSERT INTO ETATY(id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES (@id_ab, N'sams', N'SYSOP Specialist',			7200, CONVERT(datetime, '06/01/2011', 103), CONVERT(datetime, '17/05/2016', 103) )
INSERT INTO ETATY(id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES (@id_ks, N'pkob', N'React Developer',			9200, CONVERT(datetime, '14/10/1998', 103), CONVERT(datetime, '08/11/2013', 103) )
INSERT INTO ETATY(id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES (@id_tk, N'goog', N'Ruby Developer',			9800, CONVERT(datetime, '02/12/2013', 103), CONVERT(datetime, '16/12/2018', 103) )
INSERT INTO ETATY(id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES (@id_ak, N'sams', N'Java Developer',			11500, CONVERT(datetime, '14/09/2002', 103), CONVERT(datetime, '02/10/2007', 103) )
INSERT INTO ETATY(id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES (@id_akaf, N'pkob', N'Project Menager',			21000, CONVERT(datetime, '21/05/2008', 103), CONVERT(datetime, '13/02/2020', 103) )

/*
DECLARE @id_jk int, @id_ak int, @id_fk int, @id_ab int, @id_ks int, @id_kl int, @id_aka int, 
		@id_tk int, @id_jt int, @id_mp int, @id_mm int, @id_ls int, @id_rp int, @id_akaf int


id_osoby	int				not null	CONSTRAINT FK_ETATY_OSOBY	FOREIGN KEY REFERENCES OSOBY(id_osoby)
,	id_firmy	nchar(4)		not null	CONSTRAINT FK_FIRMY			FOREIGN KEY REFERENCES FIRMY(nazwa_skr)
,	stanowisko	nvarchar(50)	not null	
,	pensja		MONEY			not null
,	od			DATETIME		not null
,	do			DATETIME		not null
,	id_etatu	int				not null	IDENTITY CONSTRAINT PK_ETATY	PRIMARY KEY */






SELECT * FROM WOJ
SELECT * FROM MIASTA
SELECT * FROM OSOBY
SELECT * FROM FIRMY
SELECT * FROM ETATY