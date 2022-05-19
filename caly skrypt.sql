
/*
Z2, Mateusz Czarnecki, 2, 319030

1. Pokazaæ dane podstawowe osoby, w jakim mieœcie mieszka i w jakim to jest województwie

2. Pokazaæ wszystkie osoby o nazwisku na literê M i ostatniej literze nazwiska i lub a
(je¿eli nie macie takowych to wybierzcie takie warunki - inn¹ literê pocz¹tkow¹ i inne 2 koñcowe)
które maj¹ pensje pomiêdzy 3000 a 5000 (te¿ mo¿ecie zmieniæ je¿eli macie g³ownie inne zakresy)
mieszkajace w innym mieœcie ni¿ znajduje siê firma, w której maj¹ etat
(wystarcz¹ dane z tabel etaty, firmy, osoby , miasta)

3. Pokazaæ kto ma najd³u¿sze nazwisko w bazie
(najpierw szukamy MAX z LEN(nazwisko) a potem pokazujemy te osoby z tak¹ d³ugoœci¹ nazwiska)

4. Policzyæ liczbê osób w mieœcie o nazwie (tu dajê Wam wybór - w którym mieœcie macie najwiêcej)

*/


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
IF OBJECT_ID(N'WYP') IS NOT NULL
	DROP TABLE WYP
GO
IF OBJECT_ID(N'ZWR') IS NOT NULL
	DROP TABLE ZWR
GO
IF OBJECT_ID(N'KSIAZKI') IS NOT NULL
	DROP TABLE KSIAZKI
GO



/* 
	Commands completed successfully.
	Polecenia s³u¿¹ce do czyszczenia wszystkich tabel przy uruchomieniu skryptu 
*/

CREATE TABLE dbo.WOJ 
( kod_woj nchar(4) NOT NULL CONSTRAINT PK_WOJ PRIMARY KEY 
, nazwa nvarchar(50) NOT NULL 
)

/*
	Commands completed successfully.
	Tworzymy tabele WOJ, zawieraj¹c¹ kod_woj jako klucz g³ówny oraz nazwê 
*/

GO

CREATE TABLE dbo.MIASTA
(	id_miasta	int				not null	IDENTITY CONSTRAINT PK_MIASTA PRIMARY KEY
,	nazwa		nvarchar(50)	not null	
,	kod_woj		nchar(4)		not null	CONSTRAINT FK_MIASTA_WOJ 
											FOREIGN KEY REFERENCES WOJ(kod_woj)
)

/*
	Commands completed successfully.
	Tworzymy tabele MIASTA, zawieraj¹c¹ id_miasta jako klucz g³ówny inkrementuj¹cy wartoœæ, nazwê oraz klucz obcy kod_woj
*/

GO



CREATE TABLE dbo.OSOBY
(
	id_osoby	int				not null	IDENTITY CONSTRAINT PK_OSOBY PRIMARY KEY
,	id_miasta	int				not null	CONSTRAINT FK_OSOBY_MIASTA 
											FOREIGN KEY REFERENCES MIASTA(id_miasta)
,	imie		nvarchar(50)	not null	
,	nazwisko	nvarchar(50)	not null	
)

/*
	Commands completed successfully.
	Tworzymy tabele OSOBY, zawieraj¹c¹ id_osoby jako klucz g³ówny inkrementuj¹cy wartoœæ, klucz obcy id_miasta, imie i nazwisko
*/

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

/*
	Commands completed successfully.
	Tworzymy tabele FIRMY, zawieraj¹c¹ nazwa_skr jako klucz g³ówny, klucz obcy id_miasta, imie i nazwisko, nazwê, kod_pocztowy i ulicê
*/


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

/*
	Commands completed successfully.
	Tworzymy tabele ETATY, zawieraj¹c¹ id_etatu jako klucz g³ówny inkrementuj¹cy wartoœæ, klucz obcy id_osoby, klucz obcy id_firmy, stanowisko, pensje oraz daty od, do
*/


GO

INSERT INTO WOJ (kod_woj, nazwa)	VALUES (N'mazo', N'Mazowieckie')
INSERT INTO WOJ (kod_woj, nazwa)	VALUES (N'wiel', N'Wielkopolskie')
INSERT INTO WOJ (kod_woj, nazwa)	VALUES (N'malo', N'Malopolskie')
INSERT INTO WOJ (kod_woj, nazwa)	VALUES (N'doln', N'Dolnoslaskie')
INSERT INTO WOJ (kod_woj, nazwa)	VALUES (N'swie', N'Swietokrzyskie')
INSERT INTO WOJ (kod_woj, nazwa)	VALUES (N'pomo', N'Pomorskie')

/*
	Dodajemy rekordy do tabeli WOJ - 6 wojewodztw

	kod_woj nazwa
	------- --------------------------------------------------
	doln    Dolnoslaskie
	malo    Malopolskie
	mazo    Mazowieckie
	pomo    Pomorskie
	swie    Swietokrzyskie
	wiel    Wielkopolskie


*/


DECLARE @id_wa int , @id_pr int , @id_wr int , @id_po int , @id_mi int , @id_wl int , 
		@id_le int , @id_ka int , @id_ko int , @id_wo int , @id_kr int , @id_wi int

/* 
	Commands completed successfully.
	Deklarujemy zmienne, które wykorzystamy do przechowywania id miast
*/


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

/* 
	id_miasta   nazwa												kod_woj
	----------- -------------------------------------------------- -------
	1           Warszawa                                           mazo
	2           Pruszkow                                           mazo
	3           Wroclaw                                            doln
	4           Poznan                                             wiel
	5           Milanowek                                          mazo
	6           Walbrzych                                          doln
	7           Legnica                                            doln
	8           Kalisz                                             wiel
	9           Konin                                              wiel
	10          Wolomin                                            mazo
	11          Krakow                                             malo
	12          Wieliczka                                          malo

	Ustawiamy id miasta pod ka¿d¹ zmienn¹ za pomoc¹ polecenia SET - 12 miast, w dwóch województwach brak miast
*/


DECLARE @id_jk int, @id_ak int, @id_fk int, @id_ab int, @id_ks int, @id_kl int, @id_aka int, 
		@id_tk int, @id_jt int, @id_mp int, @id_mm int, @id_ls int, @id_rp int, @id_akaf int

/* 
	Commands completed successfully.
	Deklarujemy zmienne, które wykorzystamy do przechowywania id osób
*/

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_wa , N'Man', N'Kowalski')
SET @id_jk = SCOPE_IDENTITY()

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_po , N'Adam', N'Nowak')
SET @id_ak = SCOPE_IDENTITY()

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_le , N'Ferdynand', N'Kiepski')
SET @id_fk = SCOPE_IDENTITY()

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_wl , N'Mandrzej', N'Bebech')
SET @id_ab = SCOPE_IDENTITY()

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_pr , N'Krystian', N'Szampanski')
SET @id_ks = SCOPE_IDENTITY()

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_kr , N'Minga', N'Lorneta')
SET @id_kl = SCOPE_IDENTITY()

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_pr , N'Malicja', N'Kapuczynska')
SET @id_aka = SCOPE_IDENTITY()

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_ka , N'Tomasz', N'Kafelek')
SET @id_tk = SCOPE_IDENTITY()

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_wr , N'Jan', N'Tangowski')
SET @id_jt = SCOPE_IDENTITY()

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_mi , N'Mateusz', N'Pagowski')
SET @id_mp = SCOPE_IDENTITY()

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_mi , N'Marcin', N'Majkuta')
SET @id_mm = SCOPE_IDENTITY()

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_ko , N'Lukasz', N'Stefanski')
SET @id_ls = SCOPE_IDENTITY()

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_wi , N'Robert', N'Pudzianowski')
SET @id_rp = SCOPE_IDENTITY()

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_pr, N'Anna', N'Kafelek')
SET @id_akaf = SCOPE_IDENTITY()

/* 
	id_osoby    id_miasta   imie                                               nazwisko
	----------- ----------- -------------------------------------------------- --------------------------------------------------
	1           1           Jan                                                Kowalski
	2           4           Adam                                               Nowak
	3           7           Ferdynand                                          Kiepski
	4           6           Andrzej                                            Bebech
	5           2           Krystian                                           Szampanski
	6           11          Kinga                                              Lorneta
	7           1           Alicja                                             Kapuczynska
	8           8           Tomasz                                             Kafelek
	9           3           Jan                                                Tangowski
	10          5           Mateusz                                            Pagowski
	11          1           Marcin                                             Majkut
	12          9           Lukasz                                             Stefanski
	13          12          Robert                                             Pudzianowski
	14          2           Anna                                               Kafelek

	Deklarujemy zmienne, które wykorzystamy do przechowywania id osób za pomoc¹ polecenia SET - 14 osób, jedno miasto bez osoby
*/


INSERT INTO FIRMY(nazwa_skr ,id_miasta, nazwa, kod_pocztowy, ulica)	VALUES (N'goog', @id_wa, N'Google', N'00001', N'Mazowiecka')
INSERT INTO FIRMY(nazwa_skr ,id_miasta, nazwa, kod_pocztowy, ulica)	VALUES (N'sams', @id_pr, N'Samsung', N'05800', N'Kierowska')
INSERT INTO FIRMY(nazwa_skr ,id_miasta, nazwa, kod_pocztowy, ulica)	VALUES (N'oran', @id_wl, N'Orange', N'58160', N'Milosza')
INSERT INTO FIRMY(nazwa_skr ,id_miasta, nazwa, kod_pocztowy, ulica)	VALUES (N'xiai', @id_ka, N'Xiaiomi', N'62800', N'Tarasowska')
INSERT INTO FIRMY(nazwa_skr ,id_miasta, nazwa, kod_pocztowy, ulica)	VALUES (N'appl', @id_wr, N'Apple', N'45573', N'Trebicka')
INSERT INTO FIRMY(nazwa_skr ,id_miasta, nazwa, kod_pocztowy, ulica)	VALUES (N'pkob', @id_mi, N'PKO Bank Polski', N'05822', N'Moniuszki')
INSERT INTO FIRMY(nazwa_skr ,id_miasta, nazwa, kod_pocztowy, ulica)	VALUES (N'huaw', @id_po, N'Huawei', N'60001', N'Batorego')
INSERT INTO FIRMY(nazwa_skr ,id_miasta, nazwa, kod_pocztowy, ulica)	VALUES (N'tmob', @id_le, N'Tmobile', N'59200', N'Czeslawska')

/* 
	nazwa_skr id_miasta   nazwa                                              kod_pocztowy ulica
	--------- ----------- -------------------------------------------------- ------------ --------------------------------------------------
	appl      3           Apple                                              45573        Trebicka
	goog      1           Google                                             00001        Mazowiecka
	huaw      4           Huawei                                             60001        Batorego
	oran      6           Orange                                             58160        Milosza
	pkob      5           PKO Bank Polski                                    05822        Moniuszki
	sams      2           Samsung                                            05800        Kierowska
	tmob      7           Tmobile                                            59200        Czeslawska
	xiai      8           Xiaiomi                                            62800        Tarasowska

	Dodajemy rekordy do tabeli FIRMY pos³uguj¹c siê zmiennymi przechowuj¹cymi id miast - 8 firm, 
*/


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

	id_osoby    id_firmy stanowisko                                         pensja                od                      do                      id_etatu
	----------- -------- -------------------------------------------------- --------------------- ----------------------- ----------------------- -----------
	1           sams     Menager                                            27500,00              1991-08-12 00:00:00.000 2015-11-09 00:00:00.000 1
	2           goog     Social Media specialist                            5300,00               1999-06-18 00:00:00.000 2013-09-21 00:00:00.000 2
	3           oran     Junior Developer                                   5700,00               1999-04-27 00:00:00.000 2017-07-11 00:00:00.000 3
	4           xiai     Software Architect                                 9100,00               1999-02-25 00:00:00.000 2012-04-16 00:00:00.000 4
	5           appl     Backend Developer                                  7800,00               1999-12-17 00:00:00.000 2009-02-15 00:00:00.000 5
	6           pkob     Menager                                            11500,00              1999-09-12 00:00:00.000 2020-08-18 00:00:00.000 6
	7           sams     IT Specialist                                      15200,00              1995-08-09 00:00:00.000 2018-11-01 00:00:00.000 7
	8           goog     Project Menager                                    8900,00               1992-10-31 00:00:00.000 2014-12-05 00:00:00.000 8
	9           xiai     Scrum Master                                       13100,00              1999-04-19 00:00:00.000 2011-04-09 00:00:00.000 9
	10          appl     Product Owner                                      6900,00               2001-09-25 00:00:00.000 2012-05-04 00:00:00.000 10
	11          pkob     IT Specialist                                      12300,00              1995-03-20 00:00:00.000 1998-08-04 00:00:00.000 11
	12          oran     Programista                                        11500,00              1999-06-21 00:00:00.000 2008-08-01 00:00:00.000 12
	13          goog     Software Engeener                                  14000,00              2010-10-18 00:00:00.000 2017-07-11 00:00:00.000 13
	14          appl     Backend Developer                                  17000,00              2005-11-17 00:00:00.000 2021-01-18 00:00:00.000 14
	1           xiai     Social Media specialist                            6800,00               2009-07-11 00:00:00.000 2017-03-12 00:00:00.000 15
	4           sams     SYSOP Specialist                                   7200,00               2011-01-06 00:00:00.000 2016-05-17 00:00:00.000 16
	5           pkob     React Developer                                    9200,00               1998-10-14 00:00:00.000 2013-11-08 00:00:00.000 17
	8           goog     Ruby Developer                                     9800,00               2013-12-02 00:00:00.000 2018-12-16 00:00:00.000 18
	2           sams     Java Developer                                     11500,00              2002-09-14 00:00:00.000 2007-10-02 00:00:00.000 19
	14          pkob     Project Menager                                    21000,00              2008-05-21 00:00:00.000 2020-02-13 00:00:00.000 20

	Dodajemy rekordy do tabeli ETATY pos³uguj¹c siê zmiennymi przechowuj¹cymi id osób - 20 etatów, dwie firmy bez ¿adnych etatów
*/

SELECT * FROM WOJ
SELECT * FROM MIASTA
SELECT * FROM OSOBY
SELECT * FROM FIRMY
SELECT * FROM ETATY

/*
	Wyœwietlamy wszystkie rekordy z wszysktich tabel
*/

/* 
	nie mozna wstawic do tabeli etaty rekordu osoby nieistniejacej

	INSERT INTO ETATY(id_osoby, id_firmy, stanowisko, pensja, od, do) VALUES (@id_nieIstnieje, N'sams', N'Menager', 27500, CONVERT(datetime, '12/08/1991', 103), CONVERT(datetime, '09/11/2015', 103) )

	Msg 137, Level 15, State 2, Line 1
	Must declare the scalar variable "@id_nieIstnieje".
*/

/*
	nie mozna usunac miasta w korym sa firmy lub osoby

	DELETE FROM MIASTA WHERE id_miasta =  @id_wa
	
	Msg 547, Level 16, State 0, Line 254
	The DELETE statement conflicted with the REFERENCE constraint "FK_OSOBY_MIASTA". The conflict occurred in database "b_319030", table "dbo.OSOBY", column 'id_miasta'.
*/


/*
	nie mozna usunac tabeli osoby jezeli jest tabela etaty

	DROP TABLE OSOBY

	Msg 3726, Level 16, State 1, Line 264
	Could not drop object 'OSOBY' because it is referenced by a FOREIGN KEY constraint.


*/

/* 1. Pokazaæ dane podstawowe osoby, w jakim mieœcie mieszka i w jakim to jest województwie */

SELECT o.imie, o.nazwisko, m.nazwa AS miasto, w.nazwa AS województwo FROM OSOBY o 
join MIASTA m ON (o.id_miasta = m.id_miasta)
join WOJ w ON (m.kod_woj = w.kod_woj)

/*
	imie                                               nazwisko                                           miasto                                             województwo
	-------------------------------------------------- -------------------------------------------------- -------------------------------------------------- --------------------------------------------------
	Jan                                                Kowalski                                           Warszawa                                           Mazowieckie
	Adam                                               Nowak                                              Poznan                                             Wielkopolskie
	Ferdynand                                          Kiepski                                            Legnica                                            Dolnoslaskie
	Andrzej                                            Bebech                                             Walbrzych                                          Dolnoslaskie
	Krystian                                           Szampanski                                         Pruszkow                                           Mazowieckie
	Kinga                                              Lorneta                                            Krakow                                             Malopolskie
	Malicja                                            Kapuczynska                                        Warszawa                                           Mazowieckie
	Tomasz                                             Kafelek                                            Kalisz                                             Wielkopolskie
	Jan                                                Tangowski                                          Wroclaw                                            Dolnoslaskie
	Mateusz                                            Pagowski                                           Milanowek                                          Mazowieckie
	Marcin                                             Majkuta                                            Warszawa                                           Mazowieckie
	Lukasz                                             Stefanski                                          Konin                                              Wielkopolskie
	Robert                                             Pudzianowski                                       Wieliczka                                          Malopolskie
	Anna                                               Kafelek                                            Pruszkow                                           Mazowieckie
*/

/*
	2. Pokazaæ wszystkie osoby o nazwisku na literê M i ostatniej literze nazwiska i lub a
	(je¿eli nie macie takowych to wybierzcie takie warunki - inn¹ literê pocz¹tkow¹ i inne 2 koñcowe)
	które maj¹ pensje pomiêdzy 3000 a 5000 (te¿ mo¿ecie zmieniæ je¿eli macie g³ownie inne zakresy)
	mieszkajace w innym mieœcie ni¿ znajduje siê firma, w której maj¹ etat
	(wystarcz¹ dane z tabel etaty, firmy, osoby , miasta)
*/

SELECT o.imie, o.nazwisko, e.pensja, mF.nazwa AS adres_firmy, mO.nazwa AS zamieszkanie FROM osoby o		
		join etaty e ON (o.id_osoby = e.id_osoby)
		join FIRMY f ON (e.id_firmy = f.nazwa_skr)
		join miasta mO ON (mO.id_miasta = o.id_miasta) 
		join miasta mF ON (mF.id_miasta = f.id_miasta)
 WHERE (o.imie LIKE N'M%' 
		AND (o.nazwisko LIKE N'%i' OR o.nazwisko LIKE N'%a')
		AND (e.pensja >= 10000 AND e.pensja <= 20000)
		AND (mO.id_miasta = mF.id_miasta))

/*
	imie                                               nazwisko                                           pensja                adres_firmy                                        zamieszkanie
	-------------------------------------------------- -------------------------------------------------- --------------------- -------------------------------------------------- --------------------------------------------------
	Malicja                                            Kapuczynska                                        15200,00              Pruszkow                                           Pruszkow
	Marcin                                             Majkuta                                            12300,00              Milanowek                                          Milanowek
*/


/*
	3. Pokazaæ kto ma najd³u¿sze nazwisko w bazie
	(najpierw szukamy MAX z LEN(nazwisko) a potem pokazujemy te osoby z tak¹ d³ugoœci¹ nazwiska)
*/

IF OBJECT_ID(N'temp.#M') IS NOT NULL
	DROP TABLE #M

select o.id_osoby as id_osoby, LEN(o.nazwisko) as dlugosc
INTO #M
FROM OSOBY o

select * from #M

select o.imie, o.nazwisko, m.dlugosc FROM OSOBY o join #M m ON (m.id_osoby = o.id_osoby)
where m.dlugosc = MAX(LEN(o.nazwisko))


/* 4. Policzyæ liczbê osób w mieœcie o nazwie (tu dajê Wam wybór - w którym mieœcie macie najwiêcej) */

SELECT COUNT(DISTINCT o.id_osoby)  FROM OSOBY o join MIASTA m ON m.id_miasta = o.id_miasta
WHERE m.nazwa= N'Milanowek'




DECLARE CC INSENSITIVE CURSOR FOR
	SELECT f.nazwa_skr, f.nazwa
		FROM FIRMY f
		ORDER BY 1

DECLARE @ns nvarchar(10), @n nvarchar(100)

OPEN CC
FETCH NEXT
FROM CC INTO @ns, @n

WHILE @@FETCH_STATUS = 0 /* UDALO SIE POBRAC */
BEGIN

	SELECT	COUNT(*) AS [ile etatow w firmie],
			COUNT(DISTINCT e.id_osoby) AS [ile osob],
			@ns AS [w jakim id_firmy],
			@n	AS [nazwa firmy]
		
			FROM ETATY e
			WHERE e.id_firmy = @ns

	FETCH NEXT
	FROM CC INTO @ns, @n

END

CLOSE CC
DEALLOCATE CC

SELECT	COUNT(*) AS [ile etatow w firmie],
		COUNT(DISTINCT e.id_osoby) AS [ile osob],
		e.id_firmy AS [id firmy]
		
		FROM ETATY e
		GROUP BY e.id_firmy
		ORDER BY e.id_firmy




/* Z3, Mateusz, Czarnecki, 2 319030

	Z3.1 - policzyæ liczbê osób w ka¿dym mieœcie (zapytanie z grupowaniem)
	Najlepiej wynik zapamiêtaæ w tabeli tymczasowej

*/

SELECT	COUNT(*) AS [liczba osob], 
		m.nazwa AS [nazwa miasta]
		INTO #TT
		FROM MIASTA m
		JOIN OSOBY o ON m.id_miasta = o.id_miasta
		GROUP BY m.nazwa
		
/* Tworzê zapytanie licz¹ce liczbê wystêpuj¹cych rekordów pogrupowanych wed³ug nazwy miasta, wynik wrzucam do tabeli tymczasowej #TT

	liczba osob nazwa miasta
	----------- --------------------------------------------------
	1           Kalisz
	1           Konin
	1           Krakow
	1           Legnica
	2           Milanowek
	1           Poznan
	3           Pruszkow
	1           Walbrzych
	1           Warszawa
	1           Wieliczka
	1           Wroclaw

 */



/*
	Z3.2 - korzystaj¹c z wyniku Z3,1 - pokazaæ, które miasto ma najwiêksz¹ liczbê mieszkañców
	(zapytanie z fa - analogiczne do zadañ z Z2)
*/

/* PIERWSZY SPOSÓB (U¯YWAJ¥C FA) */

/*SELECT MAX(t.[liczba osob]) AS [maksymalna liczba osob]
	INTO #M
	FROM #TT t
*/
/*
	Tworzymy tabelê o postaci:

	maksymalna liczba osob
	----------------------
	3

	zawieraj¹c¹ wy³¹cznie najwiêksz¹ liczbê osób. Przechowujemy j¹ w postaci tabeli tymczasowej #M

*/

/*SELECT t.[nazwa miasta], t.[liczba osob]
		FROM #M m
		JOIN #TT t ON t.[liczba osob] = m.[maksymalna liczba osob]
*/
/* 
	Tworzymy zapytanie ³¹cz¹ce tabelê z zadania 1 z tabel¹ przechowuj¹c¹ najwiêksz¹ liczbê mieszkañców. 
	Otrzymujemy tabelê przechowuj¹c¹ nazwê i liczbe osób w mieœcie z najwiêksz¹ liczb¹ mieszkañców

	nazwa miasta                                       liczba osob
	-------------------------------------------------- -----------
	Pruszkow                                           3
*/



/* DRUGI SPOSÓB (U¯YWAJ¥C CURSORA) */

DECLARE @mlo int
DECLARE @mna varchar(20)

DECLARE CC INSENSITIVE CURSOR FOR
	SELECT t.[liczba osob], t.[nazwa miasta]
		FROM #TT t
		ORDER BY 1 DESC

OPEN CC
FETCH NEXT
FROM CC INTO @mlo, @mna



SELECT	@mlo AS [maksymalna liczba osob], 
		@mna AS [nazwa miasta]

CLOSE CC
DEALLOCATE CC

/*
	Deklarujê zmienne @mlo, @mla. Tworzê kursor CC, który wrzuci do zmiennych wartoœci maksymalnej liczby osob w danym miescie oraz nazwê miasta z najwiêksz¹ liczb¹ osób
	Dzieje siê tak ze wzglêdu na polecenie ORDER BY 1 DESC, które porz¹dkuje wyniki w tabeli tymczasowej malej¹co wed³ug liczby osób, zatem pierwszy rekord przedstawiaæ bêdzie miasto z najwiêksz¹ liczb¹ osób
	Nastêpnie u¿ywam polecenia SELECT aby pokazaæ zmienne, do których przekazane zosta³y wartoœci.
	Na samym koñcu zamykam i zwalniam pamiêæ po kursorze.

	Sposób ten bêdzie wadliwy dla dwóch rekordów o takiej samej, najwiêkszej liczbie mieszkañców miasta.


	maksymalna liczba osob nazwa miasta
	---------------------- --------------------
	3                      Pruszkow
*/



/*
	Z3.3 Pokazaæ liczbê firm w ka¿dym z województw (czyli grupowanie po kod_woj)
*/

SELECT	w.kod_woj, w.nazwa AS [nazwa wojewodztwa],
		COUNT(*) AS [liczba firm]
		FROM WOJ w
		JOIN MIASTA m ON w.kod_woj = m.kod_woj
		JOIN FIRMY f ON m.id_miasta = f.id_miasta
		GROUP BY w.kod_woj, w.nazwa

/*
	Tworzymy tabelê zawieraj¹c¹ informacjê o liczbie firm w danym województwie o postaci:

	kod_woj nazwa wojewodztwa                                  liczba firm
	------- -------------------------------------------------- -----------
	doln    Dolnoslaskie                                       3
	mazo    Mazowieckie                                        3
	wiel    Wielkopolskie                                      2

	Osi¹gamy to poprzez operator GROUP BY, który grupuje nam dane w tabelii wed³ug klucza g³ównego w.kod_woj oraz nazwy województwa
 */




/*
	Z3.4 Pokazaæ województwa w których nie ma ¿adnej firmy

	(suma z3.3 i z3.4 powinna daæ nam pe³n¹ listê województw - woj gdzie sa firmy i gdzie ich nie ma to razem powinny byc wszystkie
*/

SELECT w.kod_woj, w.nazwa
	FROM WOJ w
	WHERE NOT EXISTS(
		SELECT	1
		FROM FIRMY fW
		JOIN MIASTA mW ON mW.id_miasta = fW.id_miasta
		WHERE w.kod_woj = mW.kod_woj
		)

/*	
	Pos³uguj¹c siê operatorem NOT EXISTS, szukam kod_woj i nazw województw, dla których nie istniej¹ rekordy dla zapytania ³¹cz¹cego firmy z województwami. 
	W ten sposób otrzymujê listê województw, w których nie ma ¿adnej firmy

	kod_woj nazwa
	------- --------------------------------------------------
	malo    Malopolskie
	pomo    Pomorskie
	swie    Swietokrzyskie
*/



/*
Z4 Mateusz, Czarnecki 319030, 2

	Z4.1 - pokazaæ osoby z województwa o kodzie X, które nigdy
	nie pracowa³y / nie pracuja tez obecnie w firmie z woj o tym samym kodzie
	(lub innym - jakie dane lepsze)
*/


SELECT o.id_osoby, LEFT(o.imie, 20) AS [imie], LEFT(o.nazwisko, 20) AS [nazwisko]
		FROM OSOBY o
		JOIN MIASTA m ON m.id_miasta = o.id_miasta
		JOIN WOJ w ON w.kod_woj = m.kod_woj 

		WHERE NOT EXISTS
		( SELECT oW.*, wW.kod_woj AS [kod_woj firmy]
			FROM WOJ wW 
			JOIN MIASTA mW ON mW.kod_woj = wW.kod_woj
			JOIN FIRMY fW ON fW.id_miasta = mW.id_miasta
			JOIN ETATY eW ON eW.id_firmy = fW.nazwa_skr
			JOIN OSOBY oW ON oW.id_osoby = eW.id_osoby
			WHERE o.id_osoby = oW.id_osoby AND w.kod_woj = wW.kod_woj
		 )
/* 
	Tworze zapytanie szukaj¹ce id_osoby, imienia i nazwiska osób mieszkaj¹cych w pewnym województwie.
	W zapytaniu wewn¹trz NOT EXISTS szukam danych osób spe³niaj¹cych warunek, ¿e kod_woj osoby = kod_woj firmy, w której osoba pracuje/pracowa³a.
	Poleceniem WHERE NOT EXISTS, sprawiam, ¿e wyœwietl¹ siê tylko rekordy, które NIE SPE£NIAJ¥ zapytania wewnêtrznego, zatem osoby, których kod_woj zamieszkania jest RÓ¯NY od kod_woj firmy.


	id_osoby    imie                 nazwisko
	----------- -------------------- --------------------
	2           Adam                 Nowak
	4           Mandrzej             Bebech
	6           Minga                Lorneta
	8           Tomasz               Kafelek
	9           Jan                  Tangowski
	10          Mateusz              Pagowski
	12          Lukasz               Stefanski
	13          Robert               Pudzianowski

	(8 row(s) affected)
*/


/*
	Z4.2 - pokazaæ liczbê mieszkañców w województwach
	ale tylko w tych maj¹cych wiecej jak jednego (DWÓCH) mieszkañca
*/


SELECT w.kod_woj, tt.nazwa, tt.[liczba mieszkancow]
	FROM WOJ w
	JOIN (SELECT w.kod_woj, LEFT(w.nazwa, 20) AS [nazwa], COUNT(*) AS [liczba mieszkancow]
			FROM WOJ w
			JOIN MIASTA m ON m.kod_woj = w.kod_woj
			JOIN OSOBY o ON o.id_miasta = m.id_miasta
			GROUP BY w.kod_woj, w.nazwa) tt ON tt.kod_woj = w.kod_woj
	WHERE tt.[liczba mieszkancow] > 2

/*
	Zamiast waurnku liczby mieszkañców wiêkszej od 1, chcê aby pokazano mi dane dla liczby mieszkañców wiêkszej od 2, gdy¿ taki warunek umo¿liwi³ mi odró¿nienie od bezwarunkowego zapytania. 
	(wszystkie miasta w tabeli mia³y wiêcej ni¿ 1 mieszkañca, a nie wszystkie wiêcej ni¿ 2)

	Tworzê zapytanie szukaj¹ce kod_woj, nazwy oraz iloœci wyœwietlanych rekordów osób.
	Tworzê zapytanie wewnêtrzne szukaj¹ce kod_woj, nazwê i liczbê mieszkañców, pogrupowane po kod_woj i nazwie.
	Dajê warunek, w którym liczba mieszkañców z tabeli wewnêtrznej ma byæ wiêksza od 2.

	kod_woj nazwa                liczba mieszkancow
	------- -------------------- ------------------
	doln    Dolnoslaskie         3
	mazo    Mazowieckie          6
	wiel    Wielkopolskie        3

	(3 rows affected)
*/


/*
	Z4.3 - pokazaæ sredni¹ pensjê w miastach
	ale tylko tych posiadaj¹cych wiêcej jak jednego mieszkañca
*/


SELECT  m.id_miasta, m.nazwa AS [nazwa miasta], AVG(e.pensja) AS [srednia pensja]
		FROM MIASTA m
		JOIN OSOBY o ON o.id_miasta = m.id_miasta
		JOIN ETATY e ON e.id_osoby = o.id_osoby
		JOIN (SELECT m.id_miasta, COUNT(*) AS [liczba mieszkancow]
				FROM MIASTA m
				JOIN OSOBY o ON o.id_miasta = m.id_miasta
				GROUP BY m.id_miasta, m.nazwa) tt ON tt.id_miasta = m.id_miasta
		WHERE tt.[liczba mieszkancow] > 1
		GROUP BY m.id_miasta, m.nazwa

/*
	Tworzê zapytanie wewnêtrzne pokazuj¹ce id_miasta i liczbê mieszkañców w danym mieœcie. U¿ywam do tego operatora COUNT(*) oraz grupuje rekordy po id_miasta.
	W zapytaniu zewnêtrznym szukam id_miasta, nazwy miasta i œredniej pensji w miastach. Dziêki do³¹czeniu tabeli zawieraj¹cej liczbê mieszkañców, mogê daæ warunek mówi¹cy, ¿e ma byæ ona wiêksza od 1.


	id_miasta   nazwa miasta                                       srednia pensja
	----------- -------------------------------------------------- ---------------------
	2           Pruszkow                                           14040,00
	5           Milanowek                                          9600,00

	(2 rows affected)

*/




/*
	Z5 Mateusz Czarnecki, 319030, 2 
*/

/*
	Z5.1 - Pokazaæ firmy wraz ze œredni¹ aktualna pensj¹ w nich
	U¿ywaj¹c UNION, rozwa¿yæ opcjê ALL
*/


SELECT f.nazwa_skr AS [id firmy], f.nazwa AS [nazwa firmy], AVG(e.pensja) AS [srednia pensja]
		FROM ETATY e
		JOIN FIRMY f ON f.nazwa_skr = e.id_firmy
		GROUP BY f.nazwa_skr, f.nazwa
UNION ALL
SELECT f.nazwa_skr AS [id firmy], f.nazwa AS [nazwa firmy], CONVERT(money, null) AS [srednia pensja]
		FROM FIRMY f
		WHERE NOT EXISTS (
							SELECT fW.nazwa_skr, fW.nazwa, ew.id_etatu ,eW.pensja
									FROM FIRMY fW
									JOIN ETATY eW ON eW.id_firmy = fW.nazwa_skr
							WHERE f.nazwa_skr = fW.nazwa_skr
						)

/*
	Tworzê zapytanie szukaj¹ce id firmy, nazwê firmy i œredni¹ pensjê w ka¿dej firmie grupuj¹c po id_firmy i nazwie. 
	Zapytanie to wyœwietli wszystkie firmy, dla których istniej¹ etaty i które posiadaj¹ pewn¹ œredni¹ pensjê.

	Tworzê drugie zapytanie szukaj¹ce id firmy, nazwê firmy i NULL dla sredniej pensji, dla których nie istniej¹ ¿adne etaty.

	Za pomoc¹ operatora UNION ³¹czê ze sob¹ oba zapytania, tak aby wyœwietliæ wszystkie rekordy z dwóch tabel.
	Do operatora UNION dodaje ALL, gdy¿ wiem, ¿e oba zapytania s¹ roz³¹czne - w 1 pokazujemy firmy, dla których istniej¹ etaty, a w 2 firmy, dla których nie istniej¹ etaty.

	
	id firmy nazwa firmy                                        srednia pensja
	-------- -------------------------------------------------- ---------------------
	appl     Apple                                              10566,6666
	goog     Google                                             9500,00
	oran     Orange                                             8600,00
	pkob     PKO Bank Polski                                    13500,00
	sams     Samsung                                            15350,00
	xiai     Xiaiomi                                            9666,6666
	huaw     Huawei                                             NULL
	tmob     Tmobile                                            NULL

	(8 row(s) affected)
*/




/*
	Z5.2 - to samo co w Z5.1
	Ale z wykorzystaniem LEFT OUTER
*/

SELECT f.nazwa_skr AS [id firmy], f.nazwa AS [nazwa firmy], AVG(e.pensja) AS [srednia pensja]
		FROM FIRMY f
		LEFT OUTER JOIN ETATY e ON f.nazwa_skr = e.id_firmy
		GROUP BY f.nazwa_skr, f.nazwa

/*
	Tworzê wy³¹cznie jedno zapytanie pokazuj¹ce id firmy, nazwê firmy i sredni¹ pensjê.
	Polecenie LEFT OUTER JOIN ³¹czy z etatami równie¿ takie firmy, dla których nie istniej¹ ¿adne etaty.
	Sredniej pensji w firmach, dla których nie istniej¹ etaty, przypisana zostaje wartoœæ NULL.

	id firmy nazwa firmy                                        srednia pensja
	-------- -------------------------------------------------- ---------------------
	appl     Apple                                              10566,6666
	goog     Google                                             9500,00
	huaw     Huawei                                             NULL
	oran     Orange                                             8600,00
	pkob     PKO Bank Polski                                    13500,00
	sams     Samsung                                            15350,00
	tmob     Tmobile                                            NULL
	xiai     Xiaiomi                                            9666,6666

	(8 row(s) affected)

*/




/*
	Z5.3 Napisaæ procedurê pokazuj¹c¹ œredni¹ pensjê w firmach z miasta - parametr procedure @id_miasta
*/
GO

CREATE PROCEDURE dbo.P1 (@id_miasta int)
AS
	SELECT	m.id_miasta, m.nazwa, AVG(e.pensja) AS [srednia pensja]
			FROM MIASTA m
			JOIN FIRMY f ON m.id_miasta = f.id_miasta
			JOIN ETATY e ON f.nazwa_skr = e.id_firmy
			WHERE m.id_miasta = @id_miasta
			GROUP BY m.id_miasta, m.nazwa
GO

/*
	Tworzê procedure pobieraj¹c¹ argument @id_miasta typu int
	Tworzê zapytanie wyszukuj¹ce id miasta, nazwê miasta i œredni¹ pensjê pogrupowan¹ wed³ug id miasta i nazwy miasta.
	Do zapytania dodaje warunek twierdz¹cy, ¿e id_miasta rekordu ma byæ równe @id_miasta (przekazanemu argumentowi)

	Command(s) completed successfully.
*/

EXEC P1 2

/*
	Wywo³ujê procedurê dla przyk³adowego @id_miasta = 2.
	Procedura pokazuje œredni¹ pensjê dla podanego miasta - Pruszkowa.

	id_miasta   nazwa                                              srednia pensja
	----------- -------------------------------------------------- ---------------------
	2           Pruszkow                                           15350,00

	(1 row(s) affected)
*/



/* Z6 Mateusz, Czarnecki, 2, 319030
**
** 3 regu³y tworzenia TRIGGERA
** R1 - Trigger nie mo¿e aktualizowaæ CALEJ tabeli a co najwy¿ej elementy zmienione
** R2 - Trigger mo¿e wywo³aæ sam siebie - uzysamy nieskoñczon¹ rekurencjê == stack overflow
** R3 - Zawsze zakladamy, ¿e wstawiono / zmodyfikowano / skasowano wiecej jak 1 rekord
**
** Z1: Napisaæ trigger, który bêdzie usuwa³ spacje z pola nazwisko
** Trigger na INSERT, UPDATE
** UWAGA !! Trigger bêdzie robi³ UPDATE na polu NAZWISKO
** To grozi REKURENCJ¥ i przepelnieniem stosu
** Dlatego trzeba bêdzie sprawdzaæ UPDATE(nazwisko) i sprawdzaæ czy we
** wstawionych rekordach by³y spacje i tylko takowe poprawiaæ (ze spacjami w nazwisku)
**
*/

GO
CREATE TRIGGER dbo.tr_nazwisko ON OSOBY FOR INSERT, UPDATE
AS
	IF UPDATE(nazwisko)
	AND EXISTS (
					SELECT * FROM OSOBY o 
					WHERE o.nazwisko LIKE  N'% %'
				)
		UPDATE OSOBY SET nazwisko = REPLACE(nazwisko, N' ', N'-')
		WHERE nazwisko IN 
		(
			SELECT o.nazwisko
			FROM OSOBY o
			WHERE o.nazwisko LIKE N'% %'
		)
GO

/*
	Command(s) completed successfully.

	Tworzê TRIGGER dzia³aj¹cy pod warunkiem wstawienia nowego lub edytowania nazwiska i dla nazwisk, które posiadaj¹ spacjê. 
	Edytuje wykryte rekordy pod warunkiem, ¿e posiadaj¹ spacjê.
*/

UPDATE OSOBY SET OSOBY.nazwisko = N'Nowak Salomon'
		WHERE OSOBY.id_osoby = 2

UPDATE OSOBY SET OSOBY.nazwisko = 'Barbik W¹sacz'
		WHERE OSOBY.id_osoby = 3

/*
	Przy edytowaniu rekordu, osoby, którym próbujemy wstawiæ nazwisko ze spacj¹, spacja zostanie zamieniona na "-".

	id_osoby    id_miasta   imie                                               nazwisko
	----------- ----------- -------------------------------------------------- --------------------------------------------------
	2           4           Adam                                               Nowak-Salomon
	3           7           Ferdynand                                          Barbik-W¹sacz

*/

/*
** Z2: Napisaæ procedurê szukaj¹c¹ osób z paramertrami
** @imie_wzor nvarchar(20) = NULL
** @nazwisko_wzor nvarchar(20) = NULL
** @pokaz_zarobki bit = 0
** Procedura ma mieæ zmienn¹ @sql nvarchar(1000), któr¹ buduje dynamicznie
** @pokaz_zarobki = 0 => (imie, nazwisko, id_osoby, nazwa_miasta)
** @pokaz_zarobki = 1 => (imie, nazwisko, id_osoby, suma_z_akt_etatow)
** Mozliwe wywo³ania: EXEC sz_o @nazwisko_wzor = N'Stodolsk%'
** powinno zbudowaæ zmienn¹ tekstow¹
** @sql = N'SELECT o.*, m.nazwa AS nazwa_miasta FROM osoby o join miasta m "
** + N' ON (m.id_miasta=o.id_miasta) WHERE o.nazwisko LIKE NStodolsk% '
** uruchomienie zapytania to EXEC sp_sqlExec @sql
** rekomendujê aby najpierw procedura zwraca³a zapytanie SELECT @sql
** a dopiero jak bêd¹ poprawne uruachamia³a je
*/

UPDATE OSOBY SET OSOBY.nazwisko = N'Kowalski'

SELECT * FROM OSOBY
/* SELECT * INTO osoby_bk FROM osoby o */

UPDATE OSOBY SET OSOBY.nazwisko = b.nazwisko
		FROM OSOBY JOIN osoby_bk b ON OSOBY.id_osoby = b.id_osoby




/* Z.7 Projekt na 3 zajêcia */

/* stworzyæ bibliotekê (uproszczon¹)
**
** Tabela Ksiazka (tytul, autor, id_ksiazki, stan_bibl, stan_dostepny - dom 0)
** Skorzystaæ z tabeli OSOBY któr¹ macie
** Tabela WYP (id_osoby, id_ksiazki, liczba, data)
** Tabela ZWR (id_osoby, id_ksiazki, liczba, data)
** Napisaæ triggery aby:
** dodanie rekordow do WYP powodowalo aktualizacjê Ksiazka (stan_dostepny)
** UWAGA zakladamy ze na raz mozna dodawac wiele rekordow
** w tym dla tej samej osoby, z tym samym id_ksiazki


CREATE TABLE #wyp(id_os int not null, id_ks int not null, liczba int not null)
INSERT INTO #wyp (id_os, id_ks, liczba) VALUES (1, 1, 1), (1, 1, 2), (2, 5, 6)

Zwrot zwiêksza stan_dostepny

** UWAGA
** Zrealizowaæ TRIGERY na kasowanie z WYP lub ZWR
**
** Zrealizowaæ triggery, ze nastapi³a pomy³ka czyli UPDATE na WYP lub ZWR
** Wydaje mi sie, ze mozna napisac po jednym triggerze na WYP lub ZWR na
** wszystkie akcje INSERT / UPDATE / DELETE
**
** Testowanie: stworzcie procedurê, która pokaze wszystkie ksi¹zki,
** dane ksi¹zki, stan_bibl, SUM(liczba) z ZWR - SUM(liczba) z WYP =>
** ISNULL(SUM(Liczba),0)
** te dwie kolumny powiny byæ równe
** po wielu dzialaniach w bazie
** dzialania typu kasowanie rejestrowac w tabeli skasowane
** (rodzaj (wyp/zwr), id_os, id_ks, liczba)
** osobne triggery na DELETE z WYP i ZWR które bêd¹ rejestrowaæ skasowania\

stan bibl - liczba ksiazek jaka mialaby biblioteka gdyby nikt nic nie wypozyczyl
*/


GO
IF OBJECT_ID(N'ZWR') IS NOT NULL
	DROP TABLE ZWR

IF OBJECT_ID(N'WYP') IS NOT NULL
	DROP TABLE WYP

IF OBJECT_ID(N'KSIAZKI') IS NOT NULL
	DROP TABLE KSIAZKI

DROP TRIGGER tr_ins_wyp
DROP TRIGGER tr_isn_zwr
DROP TRIGGER tr_del_wyp
DROP TRIGGER tr_del_zwr

CREATE TABLE dbo.KSIAZKI 
(
	tytul			nvarchar(20)	NOT NULL,
	autor			nvarchar(20)	NOT NULL,
	id_ksiazki		int				NOT NULL	IDENTITY CONSTRAINT PK_KSIAZKI PRIMARY KEY,
	stan_bibl		int				NOT NULL,
	stan_dostepny	int				NOT NULL	DEFAULT 0
)

CREATE TABLE dbo.WYP
(
	id_osoby		int				NOT NULL	CONSTRAINT FK_WYP_OSOBY
												FOREIGN KEY REFERENCES OSOBY(id_osoby),
	id_ksiazki		int				NOT	NULL	CONSTRAINT FK_WYP_KSIAZKI
												FOREIGN KEY REFERENCES KSIAZKI(id_ksiazki),
	liczba			int				NOT NULL,
	czas			datetime		NOT NULL,
)	

CREATE TABLE dbo.ZWR
(
	id_osoby		int				NOT NULL 	CONSTRAINT FK_ZWR_OSOBY 
												FOREIGN KEY REFERENCES OSOBY(id_osoby),
	id_ksiazki		int				NOT	NULL	CONSTRAINT FK_ZWR_KSIAZKI
												FOREIGN KEY REFERENCES KSIAZKI(id_ksiazki),
	liczba			int				NOT NULL,
	czas			datetime		NOT NULL,
)	

DECLARE @ks_pt int, @ks_ko int, @ks_dz int, @ks_ro int, @ks_qu int

INSERT INTO KSIAZKI (tytul, autor, stan_bibl, stan_dostepny) VALUES (N'Pan Tadeusz', N'Adam Mickiewicz', 4, 4)
SET @ks_pt = SCOPE_IDENTITY()
INSERT INTO KSIAZKI (tytul, autor, stan_bibl, stan_dostepny) VALUES (N'Kordian', N'Juliusz S³owacki', 5, 5)
SET @ks_ko = SCOPE_IDENTITY()
INSERT INTO KSIAZKI (tytul, autor, stan_bibl, stan_dostepny) VALUES (N'Dziady', N'Adam Mickiewicz', 7, 7)
SET @ks_dz = SCOPE_IDENTITY()
INSERT INTO KSIAZKI (tytul, autor, stan_bibl, stan_dostepny) VALUES (N'Rok 1984', N'George Orwell', 2, 2)
SET @ks_ro = SCOPE_IDENTITY()
INSERT INTO KSIAZKI (tytul, autor, stan_bibl, stan_dostepny) VALUES (N'Quo Vadis', N'Henryk Sienkiewicz', 4, 4)
SET @ks_qu = SCOPE_IDENTITY()

INSERT INTO WYP (id_osoby, id_ksiazki, liczba, czas) VALUES (1, @ks_pt, 2, CONVERT(datetime, '12/01/2022', 103))
INSERT INTO WYP (id_osoby, id_ksiazki, liczba, czas) VALUES (2, @ks_ko, 1, CONVERT(datetime, '02/03/2022', 103))
INSERT INTO WYP (id_osoby, id_ksiazki, liczba, czas) VALUES (3, @ks_dz, 2, CONVERT(datetime, '18/01/2022', 103))
INSERT INTO WYP (id_osoby, id_ksiazki, liczba, czas) VALUES (4, @ks_ro, 2, CONVERT(datetime, '21/04/2022', 103))
INSERT INTO WYP (id_osoby, id_ksiazki, liczba, czas) VALUES (5, @ks_qu, 2, CONVERT(datetime, '06/05/2022', 103))

INSERT INTO ZWR (id_osoby, id_ksiazki, liczba, czas) VALUES (2, @ks_qu, 1, CONVERT(datetime, '06/01/2022', 103))
INSERT INTO ZWR (id_osoby, id_ksiazki, liczba, czas) VALUES (4, @ks_pt, 2, CONVERT(datetime, '01/09/2021', 103))
INSERT INTO ZWR (id_osoby, id_ksiazki, liczba, czas) VALUES (3, @ks_dz, 1, CONVERT(datetime, '26/11/2020', 103))

SELECT * FROM KSIAZKI
SELECT * FROM WYP
SELECT * FROM ZWR

/* 
	Po utworzeniu tabel KSIAZKI, WYP, ZWR zawieraj¹ one nastêpuj¹ce dane:

	KSIAZKI:
	tytul                autor                id_ksiazki  stan_bibl   stan_dostepny
	-------------------- -------------------- ----------- ----------- -------------
	Pan Tadeusz          Adam Mickiewicz      1           4           4
	Kordian              Juliusz S³owacki     2           5           5
	Dziady               Adam Mickiewicz      3           7           7
	Rok 1984             George Orwell        4           2           2
	Quo Vadis            Henryk Sienkiewicz   5           4           4

	WYP:
	id_osoby    id_ksiazki  liczba      czas
	----------- ----------- ----------- -----------------------
	1           1           2           2022-01-12 00:00:00.000
	2           2           1           2022-03-02 00:00:00.000
	3           3           2           2022-01-18 00:00:00.000
	4           4           2           2022-04-21 00:00:00.000
	5           5           2           2022-05-06 00:00:00.000


	ZWR:
	id_osoby    id_ksiazki  liczba      czas
	----------- ----------- ----------- -----------------------
	2           5           1           2022-01-06 00:00:00.000
	4           1           2           2021-09-01 00:00:00.000
	3           3           1           2020-11-26 00:00:00.000
*/

GO
CREATE TRIGGER dbo.tr_ins_wyp ON WYP FOR INSERT
AS
	UPDATE KSIAZKI SET stan_dostepny = stan_dostepny - i.liczba
	FROM KSIAZKI k JOIN inserted i ON k.id_ksiazki = i.id_ksiazki
	WHERE k.id_ksiazki IN (
	SELECT i.id_ksiazki
			FROM inserted i join KSIAZKI k ON k.id_ksiazki = i.id_ksiazki 
	)
GO

/*	
	Tworzê trigger reaguj¹cy na wstawianie rekordów to tabeli WYP.
	Wprowadzaj¹c rekord do tabeli WYP, trigger odejmuje od stanu dostêpnego liczbê wypo¿yczonych ksi¹¿ek.
*/

INSERT INTO WYP(id_osoby, id_ksiazki, liczba, czas) VALUES (1, 1, 2, CONVERT(datetime, '12/01/2022', 103))

/*
	Po wprowadzeniu danych, stan dostêpny ksi¹¿ki "Pan Tadeusz" zmniejszy³ siê o liczbê wypo¿yczonych ksi¹¿ek - o 2.

	KSIAZKI:
	tytul                autor                id_ksiazki  stan_bibl   stan_dostepny
	-------------------- -------------------- ----------- ----------- -------------
	Pan Tadeusz          Adam Mickiewicz      1           4           2
	Kordian              Juliusz S³owacki     2           5           5
	Dziady               Adam Mickiewicz      3           7           7
	Rok 1984             George Orwell        4           2           2
	Quo Vadis            Henryk Sienkiewicz   5           4           4

	WYP:
	id_osoby    id_ksiazki  liczba      czas
	----------- ----------- ----------- -----------------------
	1           1           2           2022-01-12 00:00:00.000
	2           2           1           2022-03-02 00:00:00.000
	3           3           2           2022-01-18 00:00:00.000
	4           4           2           2022-04-21 00:00:00.000
	5           5           2           2022-05-06 00:00:00.000
	1           1           2           2022-01-12 00:00:00.000
*/

GO
CREATE TRIGGER dbo.tr_ins_zwr ON ZWR FOR INSERT
AS
	UPDATE KSIAZKI SET stan_dostepny = stan_dostepny + i.liczba
	FROM KSIAZKI k JOIN inserted i ON k.id_ksiazki = i.id_ksiazki
	WHERE k.id_ksiazki IN (
	SELECT i.id_ksiazki
			FROM inserted i join KSIAZKI k ON k.id_ksiazki = i.id_ksiazki 
	)
GO

/*	
	Tworzê trigger reaguj¹cy na wstawianie rekordów to tabeli ZWR.
	Wprowadzaj¹c rekord do tabeli ZWR, trigger dodaje do stanu dostêpnego liczbê zwórconych ksi¹¿ek.
*/

INSERT INTO ZWR(id_osoby, id_ksiazki, liczba, czas) VALUES (1, 1, 2, CONVERT(datetime, '12/01/2022', 103))

/*
	Po zwróceniu ksi¹¿ki "Pan Tadeusz", stan dostêpny ksi¹¿ek w bibliotece zwiêkszy³ siê o 2, a wiêc wróci³ do pierwotnej wartoœci.

	KSIAZKI:
	tytul                autor                id_ksiazki  stan_bibl   stan_dostepny
	-------------------- -------------------- ----------- ----------- -------------
	Pan Tadeusz          Adam Mickiewicz      1           4           4
	Kordian              Juliusz S³owacki     2           5           5
	Dziady               Adam Mickiewicz      3           7           7
	Rok 1984             George Orwell        4           2           2
	Quo Vadis            Henryk Sienkiewicz   5           4           4

	ZWR:
	id_osoby    id_ksiazki  liczba      czas
	----------- ----------- ----------- -----------------------
	2           5           1           2022-01-06 00:00:00.000
	4           1           2           2021-09-01 00:00:00.000
	3           3           1           2020-11-26 00:00:00.000
	1           1           2           2022-01-12 00:00:00.000
*/

GO
CREATE TRIGGER dbo.tr_del_wyp ON WYP FOR DELETE
AS
	UPDATE KSIAZKI SET stan_dostepny = stan_dostepny + d.liczba
	FROM KSIAZKI k JOIN deleted d ON k.id_ksiazki = d.id_ksiazki
	WHERE k.id_ksiazki IN (
		SELECT d.id_ksiazki
			FROM deleted d JOIN KSIAZKI k ON d.id_ksiazki = k.id_ksiazki
	)
GO
/*	
	Tworzê trigger reaguj¹cy na usuwanie rekordów z tabeli WYP.
	Usuwaj¹c rekord z tabeli WYP, trigger dodaje do stanu dostêpnego liczbê usuniêtych wypo¿yczonych ksi¹¿ek.
*/

DELETE FROM WYP WHERE WYP.id_ksiazki = 1

/* 
	Po usuniêciu z tabeli WYP dwóch rekordów o id_ksiazki = 1 - "Pan Tadeusz", ka¿da po 2 sztuki, do tabeli KSIAZKI dodane zosta³y 4 takie ksi¹¿ki.
	W tabeli ksiazki znajduje sie zatem obecnie 6 ksiazek "Pan Tadeusz".

	KSIAZKI:
	tytul                autor                id_ksiazki  stan_bibl   stan_dostepny
	-------------------- -------------------- ----------- ----------- -------------
	Pan Tadeusz          Adam Mickiewicz      1           4           6
	Kordian              Juliusz S³owacki     2           5           5
	Dziady               Adam Mickiewicz      3           7           7
	Rok 1984             George Orwell        4           2           2
	Quo Vadis            Henryk Sienkiewicz   5           4           4

	WYP:
	id_osoby    id_ksiazki  liczba      czas
	----------- ----------- ----------- -----------------------
	2           2           1           2022-03-02 00:00:00.000
	3           3           2           2022-01-18 00:00:00.000
	4           4           2           2022-04-21 00:00:00.000
	5           5           2           2022-05-06 00:00:00.000
*/


GO
CREATE TRIGGER dbo.tr_del_zwr ON ZWR FOR DELETE
AS
	UPDATE KSIAZKI SET stan_dostepny = stan_dostepny - d.liczba
	FROM KSIAZKI k JOIN deleted d ON k.id_ksiazki = d.id_ksiazki
	WHERE k.id_ksiazki IN (
		SELECT d.id_ksiazki
			FROM deleted d JOIN KSIAZKI k ON d.id_ksiazki = k.id_ksiazki
	)
GO


/*	
	Tworzê trigger reaguj¹cy na usuwanie rekordów z tabeli ZWR.
	Usuwaj¹c rekord z tabeli ZWR, trigger odejmuje od stanu dostêpnego liczbê usuniêtych zwróconych ksi¹¿ek.
*/

DELETE FROM ZWR WHERE ZWR.id_ksiazki = 1

/* 
	Po usuniêciu z tabeli ZWR rekordU o id_ksiazki = 1 - "Pan Tadeusz" (2 sztuki) , z tabeli KSIAZKI zosta³y usuniête 2 takie ksi¹¿ki.
	W tabeli ksiazki znajduj¹ sie zatem obecnie 4 ksia¿ki "Pan Tadeusz".

	KSIAZKI:
	tytul                autor                id_ksiazki  stan_bibl   stan_dostepny
	-------------------- -------------------- ----------- ----------- -------------
	Pan Tadeusz          Adam Mickiewicz      1           4           4
	Kordian              Juliusz S³owacki     2           5           5
	Dziady               Adam Mickiewicz      3           7           7
	Rok 1984             George Orwell        4           2           2
	Quo Vadis            Henryk Sienkiewicz   5           4           4

	ZWR:
	id_osoby    id_ksiazki  liczba      czas
	----------- ----------- ----------- -----------------------
	2           5           1           2022-01-06 00:00:00.000
	3           3           1           2020-11-26 00:00:00.000
*/
GO
CREATE TRIGGER dbo.tr_upd_wyp ON WYP FOR UPDATE
AS
	UPDATE KSIAZKI SET stan_dostepny = stan_dostepny - (i.liczba - d.liczba )
		FROM KSIAZKI k 
		JOIN inserted i ON k.id_ksiazki = i.id_ksiazki
		JOIN deleted d ON k.id_ksiazki = d.id_ksiazki
		WHERE k.id_ksiazki IN (
			SELECT d.id_ksiazki
				FROM deleted d JOIN KSIAZKI k ON d.id_ksiazki = k.id_ksiazki
		)
GO

/*
	Tworzê trigger reaguj¹cy na UPDATE rekordów z tabeli WYP.
	Edytuj¹c WYP, trigger odejmuje od stanu dostêpnego ró¿nicê liczby ksi¹¿ek, jaka zosta³a zmieniona.
*/

SELECT * FROM KSIAZKI
SELECT * FROM WYP
SELECT * FROM ZWR

UPDATE WYP SET liczba = 3
WHERE id_ksiazki = 2

/*
	Po edytowaniu liczby (z wartosci 1 do 3) wypo¿yczonych ksi¹zek o id_ksiazki = 2, stan tabeli ksiazki zmienia siê o ró¿nicê zedytowanej i poprzedniej wartoœci. 
	Stan dostepny ksiazki "Kordian" zmniejszy³ siê wiêc z 5 do 3.

	KSIAZKI:
	tytul                autor                id_ksiazki  stan_bibl   stan_dostepny
	-------------------- -------------------- ----------- ----------- -------------
	Pan Tadeusz          Adam Mickiewicz      1           4           4
	Kordian              Juliusz S³owacki     2           5           3
	Dziady               Adam Mickiewicz      3           7           7
	Rok 1984             George Orwell        4           2           2
	Quo Vadis            Henryk Sienkiewicz   5           4           4

	WYP:
	id_osoby    id_ksiazki  liczba      czas
	----------- ----------- ----------- -----------------------
	2           2           3           2022-03-02 00:00:00.000
	3           3           2           2022-01-18 00:00:00.000
	4           4           2           2022-04-21 00:00:00.000
	5           5           2           2022-05-06 00:00:00.000
*/

GO
CREATE TRIGGER dbo.tr_upd_zwr ON ZWR FOR UPDATE
AS
	UPDATE KSIAZKI SET stan_dostepny = stan_dostepny + (i.liczba - d.liczba )
		FROM KSIAZKI k 
		JOIN inserted i ON k.id_ksiazki = i.id_ksiazki
		JOIN deleted d ON k.id_ksiazki = d.id_ksiazki
		WHERE k.id_ksiazki IN (
			SELECT d.id_ksiazki
				FROM deleted d JOIN KSIAZKI k ON d.id_ksiazki = k.id_ksiazki
		)
GO

/*
	Tworzê trigger reaguj¹cy na UPDATE rekordów z tabeli ZWR.
	Edytuj¹c ZWR, trigger doda do stanu dostêpnego ró¿nicê liczby ksi¹¿ek, jaka zosta³a zmieniona.
*/

UPDATE ZWR SET liczba = 3
WHERE id_ksiazki = 3

/*
	Po edytowaniu liczby (z wartosci 1 do 3) zwróconych ksi¹zek o id_ksiazki = 3, stan tabeli ksiazki powiêksza siê o ró¿nicê zedytowanej i poprzedniej wartoœci. 
	Stan dostepny ksiazki "Dziady" zwiêkszy³ siê wiêc z 7 do 9.

	KSIAZKI:
	tytul                autor                id_ksiazki  stan_bibl   stan_dostepny
	-------------------- -------------------- ----------- ----------- -------------
	Pan Tadeusz          Adam Mickiewicz      1           4           4
	Kordian              Juliusz S³owacki     2           5           3
	Dziady               Adam Mickiewicz      3           7           9
	Rok 1984             George Orwell        4           2           2
	Quo Vadis            Henryk Sienkiewicz   5           4           4
*/