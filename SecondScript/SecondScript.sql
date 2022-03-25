
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

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_wa , N'Malicja', N'Kapuczynska')
SET @id_aka = SCOPE_IDENTITY()

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_ka , N'Tomasz', N'Kafelek')
SET @id_tk = SCOPE_IDENTITY()

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_wr , N'Jan', N'Tangowski')
SET @id_jt = SCOPE_IDENTITY()

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_mi , N'Mateusz', N'Pagowski')
SET @id_mp = SCOPE_IDENTITY()

INSERT INTO OSOBY (id_miasta, imie, nazwisko)	VALUES (@id_wr , N'Marcin', N'Majkuta')
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
	które maj¹ pensje pomiêdzy 3000 a 5000 (U mnie: miêdzy 10 000, a  20 000)
	mieszkajace w innym mieœcie ni¿ znajduje siê firma, w której maj¹ etat
	(wystarcz¹ dane z tabel etaty, firmy, osoby , miasta)
*/

SELECT o.imie, o.nazwisko, e.pensja, mF.nazwa AS adres_firmy, mO.nazwa AS adres_zamieszkania FROM osoby o		
		join ETATY e ON (o.id_osoby = e.id_osoby)
		join FIRMY f ON (e.id_firmy = f.nazwa_skr)
		join MIASTA mO ON (mO.id_miasta = o.id_miasta) 
		join MIASTA mF ON (mF.id_miasta = f.id_miasta)
 WHERE (o.imie LIKE N'M%' 
		AND (o.nazwisko LIKE N'%i' OR o.nazwisko LIKE N'%a')
		AND (e.pensja >= 10000 AND e.pensja <= 20000)
		AND (mO.id_miasta != mF.id_miasta))


/*
	imie                                               nazwisko                                           pensja                adres_firmy                                        adres_zamieszkania
	-------------------------------------------------- -------------------------------------------------- --------------------- -------------------------------------------------- --------------------------------------------------
	Minga                                              Lorneta                                            11500,00              Milanowek                                          Krakow
	Malicja                                            Kapuczynska                                        15200,00              Pruszkow                                           Warszawa
	Marcin                                             Majkuta                                            12300,00              Milanowek                                          Wroclaw
*/





/*
	3. Pokazaæ kto ma najd³u¿sze nazwisko w bazie
	(najpierw szukamy MAX z LEN(nazwisko) a potem pokazujemy te osoby z tak¹ d³ugoœci¹ nazwiska)
*/

SELECT MAX(LEN(o.nazwisko))	AS [max dlugosc]
	INTO #W
	FROM osoby o

/* Tworzymy tabelê tymczasow¹ przechowuj¹c¹ maksymaln¹ dlugosc nazwiska */

SELECT o.id_osoby AS id_osoby, o.imie, o.nazwisko ,LEN(o.nazwisko) AS dlugosc
INTO #D
FROM OSOBY o

/* Tworzymy tabelê tymczasow¹ przechowuj¹c¹ id_osoby, imie, nazwisko i dlugosc nazwiska */

SELECT d.imie, d.nazwisko, d.dlugosc 
	FROM #D d join #W w ON (w.[max dlugosc] = d.dlugosc)

/* Wybieramy te rekordy z tabeli tymczasowej, których d³ugoœæ nazwiska równa siê maksymalnej d³ugoœci */


/*
	imie                                               nazwisko                                           dlugosc
	-------------------------------------------------- -------------------------------------------------- -----------
	Robert                                             Pudzianowski                                       12
*/




/* 4. Policzyæ liczbê osób w mieœcie o nazwie (tu dajê Wam wybór - w którym mieœcie macie najwiêcej) */

SELECT COUNT(DISTINCT o.id_osoby) AS [ile osob] 
	FROM OSOBY o join MIASTA m ON (m.id_miasta = o.id_miasta)
	WHERE m.nazwa= N'Milanowek'

/* Poleceniem COUNT szukam liczby wyst¹pienia id_osob gdzie nazwa miasta = "Milanowek" */

/*
	ile osob
	-----------
	2
*/