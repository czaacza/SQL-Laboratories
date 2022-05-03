/* BD wykład 2022.04.11
** maciej.stodolski@pw.edu.pl
*/
/* 
Bazy na serwerze prez nazwe 
Tabele w bazie przez nazwę 
Kolumny w tabeli przez nazwę (czyli wszystko w.w. unikalne nazwy
Wiersze przez "nazwę" czyli zawartość danych w wierszu
Zbiór kolumn, który dla tabeli jest unikalny to Klucz Głowny (Primary KEY)

*/
/*
18.04 - święta - brak wykładu
19.04 - ferie - brak laboratorium dla grup wtorkowych
20.04 - ponieziałek - wykład
*/


USE pwy_db
GO

/* szef ma zyczenie listy osob i sumy AKT miesiecznych zarobków 
*/
SELECT o.id_osoby,o.imię, o.nazwisko, X.suma_zarobkow
	FROM osoby o
	join (SELECT eW.id_osoby, SUM(ew.pensja) AS suma_zarobkow 
			FROM etaty eW
			WHERE EW.DO IS NULL
			GROUP BY eW.id_osoby
		) X ON (X.id_osoby = o.id_osoby)
/*id_osoby    imię                 nazwisko                       suma_zarobkow
----------- -------------------- ------------------------------ ---------------------
1           Maciej               Stodolski                      25400,00
2           Jacek                Korytkowski                    3200,00
3           Mis                  Nieznany                       200000,00
4           Król                 Neptun                         65200,00
6           Anna                 Stodolska                      200000,00

(5 row(s) affected)
*/
/* szef sprawdza listę osób w bazie
** SELECT COUNT(*) FROM osoby -- 10
** W BAZIE jest 10 osób a na raporcie tylko 5 - prawdopodonie reszta aktualnie nigdzie nie pracuje
*/
SELECT o.id_osoby,o.imię, o.nazwisko, X.suma_zarobkow
	FROM osoby o
	join (SELECT eW.id_osoby, SUM(ew.pensja) AS suma_zarobkow 
			FROM etaty eW
			WHERE EW.DO IS NULL
			GROUP BY eW.id_osoby
		) X ON (X.id_osoby = o.id_osoby)

SELECT o.id_osoby,o.imię, o.nazwisko, CONVERT(money, null) AS suma_zarobkow
	FROM osoby o
	WHERE NOT EXISTS (SELECT 1 FROM etaty eW WHERE eW.id_osoby = o.id_osoby AND eW.do is null)
/*
id_osoby    imię                 nazwisko                       suma_zarobkow
----------- -------------------- ------------------------------ ---------------------
1           Maciej               Stodolski                      25400,00
2           Jacek                Korytkowski                    3200,00
3           Mis                  Nieznany                       200000,00
4           Król                 Neptun                         65200,00
6           Anna                 Stodolska                      200000,00

(5 row(s) affected)

id_osoby    imię                 nazwisko                       suma_zarobkow
----------- -------------------- ------------------------------ ---------------------
5           Już                  Niepracujący                   NULL
7           X                    Stodolsk                       NULL
8           Y                    Stodolskiewicz                 NULL
9           Jacek                Testowy                        NULL
10          Maciej               Testowy                        NULL

(5 row(s) affected)
*/

/* UNION 
** SELECT z1 UNION [ALL] SELECT z2 [ORDER BY NumerKol]
**
** UNION (bez ALL) klei WSZYSTKO z Z1 a z Z2 tylko to co nie wystąpiło w Z1
** Sprawdzenie jest przeprowadzane (ze nie wystapiło) porównując WSZSTKIE pola w wierszu !!!
** 
** Jezeli jestesmy pewni, że zbiory - wyniki zapytan - są rozłączne to ZAWSZE uzywajmy ALL
**
** SELECT z1 UNION ALL SELECT z2
** bierze wszystko z Z1 i dokleja wszystko z Z2
*/
/* 
Z1 - to ci co aktualnie gdzieś pracują
Z2 - to ci którzy aktualnie NIGDZIE nie pracują
Ewidentnie zbiory rozłaczne
**
** Z1 UNION [ALL] Z2 
** 
** Nazwy kolumn w Z1 i Z2 mogą być kompletnie rózne
** Wynikowe zapytanie będzie miało nazwy z Z1
** Muszą się zgadzać typy kolumn
*/
SELECT o.id_osoby,o.imię, o.nazwisko, X.suma_zarobkow
	FROM osoby o
	join (SELECT eW.id_osoby, SUM(ew.pensja) AS suma_zarobkow 
			FROM etaty eW
			WHERE EW.DO IS NULL
			GROUP BY eW.id_osoby
		) X ON (X.id_osoby = o.id_osoby)
UNION ALL
SELECT o.id_osoby,o.imię, o.nazwisko, CONVERT(money, null) AS XX
	FROM osoby o
	WHERE NOT EXISTS (SELECT 1 FROM etaty eW WHERE eW.id_osoby = o.id_osoby AND eW.do is null)
	ORDER BY 3 ,2
/*
id_osoby    imię                 nazwisko                       suma_zarobkow
----------- -------------------- ------------------------------ ---------------------
2           Jacek                Korytkowski                    3200,00
4           Król                 Neptun                         65200,00
5           Już                  Niepracujący                   NULL
3           Mis                  Nieznany                       200000,00
7           X                    Stodolsk                       NULL
6           Anna                 Stodolska                      200000,00
1           Maciej               Stodolski                      25400,00
8           Y                    Stodolskiewicz                 NULL
9           Jacek                Testowy                        NULL
10          Maciej               Testowy                        NULL

(10 row(s) affected)
*/

/*
** Zapytania lewostronnie otwarte
**
** SELECT WK FROM T1 left outer join T2 ON (war_łączący) [ WHERE WW ] [ORDER BY  NazwaKol | numerKOl]
**
** samo słowo JOIN w wielu SQL == INNER JOIN 
** INNER JOIN ==> dane z tabel T1 i T2 ktore spełniają warunek łączenia
**
** LEFT OUTER -> wybiera wszystko z T1 a z T2 ew odpowiedniki => jak brak odpowiednika to NULL
*/
SELECT o.id_osoby,o.imię, o.nazwisko, X.suma_zarobkow
	FROM osoby o
	left outer
	join (SELECT eW.id_osoby, SUM(ew.pensja) AS suma_zarobkow 
			FROM etaty eW
			WHERE EW.DO IS NULL
			GROUP BY eW.id_osoby
		) X ON (X.id_osoby = o.id_osoby)
	ORDER BY o.nazwisko, o.imię 
/*
id_osoby    imię                 nazwisko                       suma_zarobkow
----------- -------------------- ------------------------------ ---------------------
2           Jacek                Korytkowski                    3200,00
4           Król                 Neptun                         65200,00
5           Już                  Niepracujący                   NULL
3           Mis                  Nieznany                       200000,00
7           X                    Stodolsk                       NULL
6           Anna                 Stodolska                      200000,00
1           Maciej               Stodolski                      25400,00
8           Y                    Stodolskiewicz                 NULL
9           Jacek                Testowy                        NULL
10          Maciej               Testowy                        NULL

(10 row(s) affected)
*/

/* dlaczego nie lubię zapytań twartych 
** Są bardzo niebezpieczne
** 1) Pola o których wiemy, że są NOT NULL nagle mogą być NULL-em
*/
/* przykład- POLE PENSJA jest NOT NULL
** ale przez zapytanie otwarte może przyjmować wartości NULL
** chcąc znaleźć sumę pensji pomiędzy 2000 a 30000 
** musimy pamiętać, że nie wolno wartości porównywać z NULL bo według ANSI daje wynik nieokreślony
** X.suma_zarobkow = Y 
** X.suma_zarobkow IS NOT NULL AND X.suma_zarobkow = Y 
*/

SELECT o.id_osoby,o.imię, o.nazwisko, X.suma_zarobkow
	FROM osoby o
	left outer
	join (SELECT eW.id_osoby, SUM(ew.pensja) AS suma_zarobkow 
			FROM etaty eW
			WHERE EW.DO IS NULL
			GROUP BY eW.id_osoby
		) X ON (X.id_osoby = o.id_osoby)
	WHERE 	(X.suma_zarobkow IS NOT NULL)
	AND		(X.suma_zarobkow BETWEEN 2000 and 30000)
	ORDER BY o.nazwisko, o.imię 
/*
id_osoby    imię                 nazwisko                       suma_zarobkow
----------- -------------------- ------------------------------ ---------------------
1           Maciej               Stodolski                      25400,00
2           Jacek                Korytkowski                    3200,00

(2 row(s) affected)
*/

/* w poniższym zapytaniu nie kazda osoba może pracować dlatego jest LEFT OUTER 
*/

SELECT o.id_osoby,o.imię, o.nazwisko, CONVERT(nchar(6), e.od, 112) AS od, e.pensja 
	FROM osoby o
	left outer
	join etaty e ON (o.id_osoby = e.id_osoby) 
	ORDER BY o.nazwisko, o.imię, e.od 
/*
** id_osoby    imię                 nazwisko                       od     pensja
----------- -------------------- ------------------------------ ------ ---------------------
2           Jacek                Korytkowski                    200111 3200,00
4           Król                 Neptun                         200410 65200,00
5           Już                  Niepracujący                   200001 50000,00
3           Mis                  Nieznany                       202011 200000,00
7           X                    Stodolsk                       NULL   NULL
6           Anna                 Stodolska                      200409 6200,00
6           Anna                 Stodolska                      202011 200000,00
1           Maciej               Stodolski                      199401 600,00
1           Maciej               Stodolski                      199801 1600,00
1           Maciej               Stodolski                      199901 2200,00
1           Maciej               Stodolski                      200001 20000,00
1           Maciej               Stodolski                      200001 3200,00
1           Maciej               Stodolski                      200409 4200,00
8           Y                    Stodolskiewicz                 NULL   NULL
9           Jacek                Testowy                        NULL   NULL
10          Maciej               Testowy                        NULL   NULL

(16 row(s) affected)
*/

/* JOIN dołącza kolejną tabelę do którejś z wcześniej wymienionych
** na logikę chcąc pokazać nazwę firmy przy etacie to
** KAZDY ETAT MA POWIAZANIE Z FIRMĄ
** Na logikę OSOBY z ETATY left outer JOIN  (bo nie kazda osoba musi miec etat)
** ale ETATY z FIRMY czemu nie JOIN (bo azdy ETAT MUSI MIEC POWIAZANIE z FIRMA)
*/

SELECT o.id_osoby,o.imię, o.nazwisko, CONVERT(nchar(6), e.od, 112) AS od, e.pensja, f.nazwa AS FIRMA
	FROM osoby o
	left outer
	join etaty e ON (o.id_osoby = e.id_osoby)  /* left outer bo nie kazda osoba musi miec etat  */
	join firmy f ON (e.id_firmy = f.nazwa_skr) /* inner JOIN bo azdy ETAT musi mieć link do FIRMA */
	ORDER BY o.nazwisko, o.imię, e.od 
/*
id_osoby    imię                 nazwisko                       od     pensja                FIRMA
----------- -------------------- ------------------------------ ------ --------------------- ------------------------------------------------------------
2           Jacek                Korytkowski                    200111 3200,00               Politechnika Warszawska
4           Król                 Neptun                         200410 65200,00              Fabryka Łodzi Podwodnych
5           Już                  Niepracujący                   200001 50000,00              Hewlett Packard
3           Mis                  Nieznany                       202011 200000,00             Politechnika Warszawska
6           Anna                 Stodolska                      200409 6200,00               Fabryka Łodzi Podwodnych
6           Anna                 Stodolska                      202011 200000,00             Fabryka Łodzi Podwodnych
1           Maciej               Stodolski                      199401 600,00                Politechnika Warszawska
1           Maciej               Stodolski                      199801 1600,00               Politechnika Warszawska
1           Maciej               Stodolski                      199901 2200,00               Politechnika Warszawska
1           Maciej               Stodolski                      200001 20000,00              Hewlett Packard
1           Maciej               Stodolski                      200001 3200,00               Politechnika Warszawska
1           Maciej               Stodolski                      200409 4200,00               Politechnika Warszawska

(12 row(s) affected)
*/
/* od momentu użycia w zapytaniu LEFT OUTER wszystkie kolejne też muszą być LEFT OUTER
*/
SELECT o.id_osoby,LEFT(o.imię,10), LEFT(o.nazwisko,12) AS nazwisko
	,	LEFT(mO.nazwa,10) AS [miasto o], LEFT(wo.nazwa,10) AS [woj o]
	, CONVERT(nchar(6), e.od, 112) AS od, e.pensja, f.nazwa AS FIRMA
	FROM osoby o
	join miasta mO ON (o.id_miasta = mO.id_miasta)
	join woj wO ON (wO.kod_woj = mO.kod_woj)
	left outer
	join etaty e ON (o.id_osoby = e.id_osoby)  /* left outer bo nie kazda osoba musi miec etat  */
	left outer
	join firmy f ON (e.id_firmy = f.nazwa_skr) /* inner JOIN bo azdy ETAT musi mieć link do FIRMA */
	ORDER BY o.nazwisko, o.imię, e.od 
/*
id_osoby               nazwisko     miasto o   woj o      od     pensja                FIRMA
----------- ---------- ------------ ---------- ---------- ------ --------------------- ------------------------------------------------------------
2           Jacek      Korytkowski  WARSZAWA   Mazowiecki 200111 3200,00               Politechnika Warszawska
4           Król       Neptun       SOPOT      Pomorskie  200410 65200,00              Fabryka Łodzi Podwodnych
5           Już        Niepracujący WARSZAWA   Mazowiecki 200001 50000,00              Hewlett Packard
3           Mis        Nieznany     GDAŃSK     Pomorskie  202011 200000,00             Politechnika Warszawska
7           X          Stodolsk     WESOŁA     Mazowiecki NULL   NULL                  NULL
6           Anna       Stodolska    WESOŁA     Mazowiecki 200409 6200,00               Fabryka Łodzi Podwodnych
6           Anna       Stodolska    WESOŁA     Mazowiecki 202011 200000,00             Fabryka Łodzi Podwodnych
1           Maciej     Stodolski    WESOŁA     Mazowiecki 199401 600,00                Politechnika Warszawska
1           Maciej     Stodolski    WESOŁA     Mazowiecki 199801 1600,00               Politechnika Warszawska
1           Maciej     Stodolski    WESOŁA     Mazowiecki 199901 2200,00               Politechnika Warszawska
1           Maciej     Stodolski    WESOŁA     Mazowiecki 200001 20000,00              Hewlett Packard
1           Maciej     Stodolski    WESOŁA     Mazowiecki 200001 3200,00               Politechnika Warszawska
1           Maciej     Stodolski    WESOŁA     Mazowiecki 200409 4200,00               Politechnika Warszawska
8           Y          Stodolskiewi WESOŁA     Mazowiecki NULL   NULL                  NULL
9           Jacek      Testowy      WESOŁA     Mazowiecki NULL   NULL                  NULL
10          Maciej     Testowy      WESOŁA     Mazowiecki NULL   NULL                  NULL

(16 row(s) affected)
*/

SELECT o.id_osoby,o.imię, o.nazwisko, ISNULL(X.suma_zarobkow, 0)
	FROM osoby o
	left outer
	join (SELECT eW.id_osoby, SUM(ew.pensja) AS suma_zarobkow 
			FROM etaty eW
			WHERE EW.DO IS NULL
			GROUP BY eW.id_osoby
		) X ON (X.id_osoby = o.id_osoby)
	ORDER BY o.nazwisko, o.imię 
/*
id_osoby    imię                 nazwisko                       
----------- -------------------- ------------------------------ ---------------------
2           Jacek                Korytkowski                    3200,00
4           Król                 Neptun                         65200,00
5           Już                  Niepracujący                   0,00
3           Mis                  Nieznany                       200000,00
7           X                    Stodolsk                       0,00
6           Anna                 Stodolska                      200000,00
1           Maciej               Stodolski                      25400,00
8           Y                    Stodolskiewicz                 0,00
9           Jacek                Testowy                        0,00
10          Maciej               Testowy                        0,00

(10 row(s) affected)
*/

/*
** Jak działa SQL
** 1. Wysyłamy tekst do SQL
** 2. Analiza poprawności
** 3. Obmyśla strategię najlepszego wykonania zapytania (użycie indeksów lub nie i kilka innych metod)
** 4. Generacja pseudokodu
** 5. Wykonanie
**
** jesli na 1-5 zużywa 100 % czasu to przy wynikach rzędu mnie < 100 wierszy to 3% to będzie wykonanie
*/

select * from etaty where etaty.id_osoby = 1
select * from etaty where etaty.id_osoby = 5

/* 
** 2-4 przechowywać w bazie -> skompilowany kod czekający na uruchomienie
** Nazwany jakoś
** 
** wtedy uruchomienie zapyyania / kodu to EXEC NazwaProc ListaPar
*/
/* stwórzmy procedurę zwracającą zarobki w woj o kodzie PARAMETR */
GO

CREATE PROCEDURE dbo.P1 (@kod_woj nchar(4) )
AS
	SELECT o.id_osoby,LEFT(o.imię,10), LEFT(o.nazwisko,12) AS nazwisko
		,	LEFT(mO.nazwa,10) AS [miasto o], LEFT(wo.nazwa,10) AS [woj o]
		, ISNULL(X.suma_zarobkow, 0) AS suma_zarobkow
		FROM osoby o
		join miasta mO ON (o.id_miasta = mO.id_miasta)
		join woj wO ON (wO.kod_woj = mO.kod_woj)
		join (SELECT eW.id_osoby, SUM(ew.pensja) AS suma_zarobkow 
			FROM etaty eW
			WHERE EW.DO IS NULL
			GROUP BY eW.id_osoby
			) X ON (X.id_osoby = o.id_osoby)
		WHERE wO.kod_woj = @kod_woj 
		ORDER BY o.nazwisko, o.imię 
GO

EXEC P1 N'MAZ'
/*
id_osoby               nazwisko     miasto o   woj o      suma_zarobkow
----------- ---------- ------------ ---------- ---------- ---------------------
2           Jacek      Korytkowski  WARSZAWA   Mazowiecki 3200,00
6           Anna       Stodolska    WESOŁA     Mazowiecki 200000,00
1           Maciej     Stodolski    WESOŁA     Mazowiecki 25400,00

(3 row(s) affected)
*/
GO

CREATE PROCEDURE dbo.P2 (@kod_woj nchar(4), @nie_prac bit = 0 )
AS
	SELECT o.id_osoby,LEFT(o.imię,10), LEFT(o.nazwisko,12) AS nazwisko
		,	LEFT(mO.nazwa,10) AS [miasto o], LEFT(wo.nazwa,10) AS [woj o]
		, ISNULL(X.suma_zarobkow, 0) AS suma_zarobkow
		FROM osoby o
		join miasta mO ON (o.id_miasta = mO.id_miasta)
		join woj wO ON (wO.kod_woj = mO.kod_woj)
		join (SELECT eW.id_osoby, SUM(ew.pensja) AS suma_zarobkow 
			FROM etaty eW
			WHERE EW.DO IS NULL
			GROUP BY eW.id_osoby
			) X ON (X.id_osoby = o.id_osoby)
		WHERE wO.kod_woj = @kod_woj 
		ORDER BY o.nazwisko, o.imię 
GO

EXEC P2 N'MAZ'
/*
id_osoby               nazwisko     miasto o   woj o      suma_zarobkow
----------- ---------- ------------ ---------- ---------- ---------------------
2           Jacek      Korytkowski  WARSZAWA   Mazowiecki 3200,00
6           Anna       Stodolska    WESOŁA     Mazowiecki 200000,00
1           Maciej     Stodolski    WESOŁA     Mazowiecki 25400,00

(3 row(s) affected)
*/
GO

ALTER PROCEDURE dbo.P2 (@kod_woj nchar(4), @nie_prac bit = 0 )
AS
	IF @nie_prac = 1
	SELECT o.id_osoby,LEFT(o.imię,10), LEFT(o.nazwisko,12) AS nazwisko
		,	LEFT(mO.nazwa,10) AS [miasto o], LEFT(wo.nazwa,10) AS [woj o]
		, 0 AS suma_zarobkow
		FROM osoby o
		join miasta mO ON (o.id_miasta = mO.id_miasta)
		join woj wO ON (wO.kod_woj = mO.kod_woj)
		WHERE wO.kod_woj = @kod_woj 
		AND NOT EXISTS ( SELECT 1 FROM etaty eW WHERE eW.do is null 
			and eW.id_osoby = o.id_osoby /* war łaczący */ 
		)
		ORDER BY o.nazwisko, o.imię 
	ELSE
	SELECT o.id_osoby,LEFT(o.imię,10), LEFT(o.nazwisko,12) AS nazwisko
		,	LEFT(mO.nazwa,10) AS [miasto o], LEFT(wo.nazwa,10) AS [woj o]
		, ISNULL(X.suma_zarobkow, 0) AS suma_zarobkow
		FROM osoby o
		join miasta mO ON (o.id_miasta = mO.id_miasta)
		join woj wO ON (wO.kod_woj = mO.kod_woj)
		join (SELECT eW.id_osoby, SUM(ew.pensja) AS suma_zarobkow 
			FROM etaty eW
			WHERE EW.DO IS NULL
			GROUP BY eW.id_osoby
			) X ON (X.id_osoby = o.id_osoby)
		WHERE wO.kod_woj = @kod_woj 
		ORDER BY o.nazwisko, o.imię 
GO


EXEC P2 @kod_woj=N'MAZ', @nie_prac=1
/*
id_osoby               nazwisko     miasto o   woj o      suma_zarobkow
----------- ---------- ------------ ---------- ---------- -------------
5           Już        Niepracujący WARSZAWA   Mazowiecki 0
7           X          Stodolsk     WESOŁA     Mazowiecki 0
8           Y          Stodolskiewi WESOŁA     Mazowiecki 0
9           Jacek      Testowy      WESOŁA     Mazowiecki 0
10          Maciej     Testowy      WESOŁA     Mazowiecki 0

(5 row(s) affected)
*/


EXEC P2 @kod_woj=N'POM', @nie_prac=0
/*
id_osoby               nazwisko     miasto o   woj o      suma_zarobkow
----------- ---------- ------------ ---------- ---------- ---------------------
4           Król       Neptun       SOPOT      Pomorskie  65200,00
3           Mis        Nieznany     GDAŃSK     Pomorskie  200000,00

(2 row(s) affected)
*/
GO
/* prowadzący twierdzi, ze prawdziwa generacja kodu i sprawdzenie 
** bedzie przy pierwszym uruchomieniu
*/

CREATE PROCEDURE dbo.P3 
AS
	SELECT o.id_osoby,LEFT(o.imię,10), LEFT(o.nazwisko,12) AS nazwisko
		,	LEFT(mO.nazwa,10) AS [miasto o], LEFT(wo.nazwa,10) AS [woj o]
		, ISNULL(X.suma_zarobkow, 0) AS suma_zarobkow
		FROM osoby o
		join miasta mO ON (o.id_miasta = mO.id_miasta)
		join woj wO ON (wO.kod_woj = mO.kod_woj)
		join #tWOJ Y ON (Y.kod_woj = wO.kod_woj) 
		join (SELECT eW.id_osoby, SUM(ew.pensja) AS suma_zarobkow 
			FROM etaty eW
			WHERE EW.DO IS NULL
			GROUP BY eW.id_osoby
			) X ON (X.id_osoby = o.id_osoby)
		ORDER BY o.nazwisko, o.imię 
GO
/*Command(s) completed successfully.
*/
EXEC P3
/*
Msg 208, Level 16, State 0, Procedure P3, Line 4
Invalid object name '#tWOJ'.

Mozna stworzyć procedurę korzystającą z obiektów nie istniejących podczas jej 
tworzenia.
Warunek - przy pierwszym uruchominiu te obiekty muszą istnieć
*/

CREATE TABLE #tWOJ (kod_woj nchar(3) NOT NULL)
INSERT INTO #tWOJ (kod_woj) VALUES (N'MAZ')
EXEC P3
/*

(1 row(s) affected)
id_osoby               nazwisko     miasto o   woj o      suma_zarobkow
----------- ---------- ------------ ---------- ---------- ---------------------
2           Jacek      Korytkowski  WARSZAWA   Mazowiecki 3200,00
6           Anna       Stodolska    WESOŁA     Mazowiecki 200000,00
1           Maciej     Stodolski    WESOŁA     Mazowiecki 25400,00

(3 row(s) affected)
*/

/* będziemy tworzyli procedurę pustą ja nie ma takowej o takiej nazwie */

GO
ALTER PROCEDURE dbo.TWORZ_PUSTA_PROC (@nazwa nvarchar(100), @debug bit = 0 )
AS
	SET @nazwa = LTRIM(RTRIM(@nazwa))

	IF NOT EXISTS 
	( SELECT 1 
		FROM sysobjects o
		WHERE	(o.[name] = @nazwa)
		AND		(OBJECTPROPERTY(o.[ID], N'IsProcedure')=1)
	)
	BEGIN
		/* skorzystamy z SP_sqlExec który wykonuje dowolne zapytanie SQL ze zmiennej */
		DECLARE @sql nvarchar(200)
		/* w napisie chcąc uzyc ' nale podac ''  => ' '' ' */
		SET @sql = N'CREATE PROCEDURE dbo.' + @nazwa + ' AS SELECT ''' + @nazwa 
					+ N''' AS jestem_pusta_proc'
		IF @debug = 1
			SELECT @sql
		EXEC sp_sqlexec @sql
	END
GO

EXEC dbo.TWORZ_PUSTA_PROC @nazwa = N'ala_ma_kota3'
EXEC dbo.TWORZ_PUSTA_PROC @nazwa = N'ala_ma_kota4', @debug=1



GO 
exec ala_ma_kota


EXEC dbo.TWORZ_PUSTA_PROC @nazwa = N'P6'
GO
/* mam pewnosc, ze istnieje wiec moge ALTER */

ALTER PROCEDURE dbo.P6 
AS
	SELECT N'Hello' AS komunikat
GO

EXEC P6
/*
komunikat
Hello
*/
