/* BD wykład 2022.04.20
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

/*
Tworzenie procedury 
CREATE PROCEDURE dbo.NazwaProcedury [(@par1 ,[parN])]
AS
	tresc procedury
	w dowolnej ilości polecenia SQL
	Na uczelni zazyczaj to jedno zapytanie w praktyce to wiele
	zapytan wstawiający/modyfiujących/kasujących
	Może być na końcu jakieś zapytanie co coś zwraca
	MS i SYBASE procedura może zwracać wiele wyników
kończymy słowem na G ostatnia litera O (2 znakowe słowo)

Jak procedura stworzona to mozemy:
DROP PROCEDURE dbo.NazwaProcedury
i utworzyc na nowo
CREATE PROCEDURE dbo.NazwaProcedury

Odradzam - Administrator Bazy może przydzielić uprawnienia grupom userów do procedury/procedur
najlepiej utworzyć pustą procedurę

Niestety CREATE PROCEDURE MUSI BYC 1szym poleceniem w pliku lub po słowie G potem O
Dlateg można upakowac polecenie w zmienną tekstową 

Jesli nie ma procedury o takiej nazwie 
BEGIN
	CREATE PROCEDURE dbo.nazwa AS
END
I ją modyfikować 

ALTER PROCEDURE dbo.Nazwa 
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
		SET @sql = N'CREATE PROCEDURE dbo.[' + @nazwa + '] AS SELECT ''' + @nazwa 
					+ N''' AS [jestem pusta procedurą]'
		IF @debug = 1
			SELECT @sql
		EXEC sp_sqlexec @sql
	END
GO


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

EXEC dbo.TWORZ_PUSTA_PROC @nazwa = N'ala ma pięć kotów'
EXEC [ala ma pięć kotów]
/*
jestem_pusta_proc
ala ma pięć kotów
*/
EXEC dbo.TWORZ_PUSTA_PROC @nazwa = N'ala ma sześć kotów'
EXEC [ala ma sześć kotów]
/*
jestem pusta procedurą
ala ma sześć kotów
*/


GO
EXEC dbo.TWORZ_PUSTA_PROC @nazwa = N'Przykl_wielu_wynikow'
GO

USE pwy_db
GO

ALTER PROCEDURE Przykl_wielu_wynikow
AS
	SELECT * FROM woj
	SELECT * FROM miasta
	SELECT * FROM miasta m, woj w
GO

EXEC Przykl_wielu_wynikow

/* procedury nie zwracające danych */

/* np wszystkim akt.  pracującym panstwo dodaje do pensji 10%  
*/
EXEC dbo.TWORZ_PUSTA_PROC @nazwa = N'Pracujacym10'
GO

/* UDATE Tabela SET kol=wart [,kolN=wartN] WHERE WW
*/

ALTER PROCEDURE dbo.Pracujacym10
AS
	UPDATE etaty  SET pensja = ROUND(pensja*1.1,2) WHERE etaty.do is null
GO

SELECT * from etaty e WHERE e.do is null
/*
id_osoby    id_firmy stanowisko                                                   pensja                od                      do                      id_etatu
----------- -------- ------------------------------------------------------------ --------------------- ----------------------- ----------------------- -----------
1           PW       Adjunkt                                                      3200,00               2000-01-02 00:00:00.000 NULL                    3
1           PW       Sprzątacz                                                    2200,00               1999-01-01 00:00:00.000 NULL                    4
1           HP       Konsultant                                                   20000,00              2000-01-01 00:00:00.000 NULL                    5
2           PW       Adjunkt                                                      3200,00               2001-11-10 00:00:00.000 NULL                    6
4           FŁP      Prezes                                                       65200,00              2004-10-23 00:00:00.000 NULL                    10
6           fłp      xx                                                           200000,00             2020-11-29 12:59:28.503 NULL                    11
3           pw       xx                                                           200000,00             2020-11-29 13:00:14.690 NULL                    12

(7 row(s) affected)
*/

EXEC dbo.Pracujacym10
/*
id_osoby    id_firmy stanowisko                                                   pensja                od                      do                      id_etatu
----------- -------- ------------------------------------------------------------ --------------------- ----------------------- ----------------------- -----------
1           PW       Adjunkt                                                      3520,00               2000-01-02 00:00:00.000 NULL                    3
1           PW       Sprzątacz                                                    2420,00               1999-01-01 00:00:00.000 NULL                    4
1           HP       Konsultant                                                   22000,00              2000-01-01 00:00:00.000 NULL                    5
2           PW       Adjunkt                                                      3520,00               2001-11-10 00:00:00.000 NULL                    6
4           FŁP      Prezes                                                       71720,00              2004-10-23 00:00:00.000 NULL                    10
6           fłp      xx                                                           220000,00             2020-11-29 12:59:28.503 NULL                    11
3           pw       xx                                                           220000,00             2020-11-29 13:00:14.690 NULL                    12

(7 row(s) affected)
*/



SELECT * from etaty e WHERE e.do is null


EXEC dbo.TWORZ_PUSTA_PROC @nazwa = N'KlonujOosoby'
GO

/* INSERT INTO Tabela (listaKolumn) VALUES listaWart */
/* INSERT INTO Tabela (listaKolumn) Zapytanie SELECT */

ALTER PROCEDURE dbo.KlonujOosoby (@kod_woj nchar(3) )
AS
	INSERT INTO osoby 
	(	imię, nazwisko, id_miasta
	)  SELECT o.imię, N'KX_' + o.nazwisko, o.id_miasta 
			FROM osoby o
			join miasta m ON (o.id_miasta = m.id_miasta)
			WHERE m.kod_woj = @kod_woj 
GO

EXEC KlonujOosoby @kod_woj=N'MAZ'

SELECT * FROM osoby
/*
id_osoby    id_miasta   imię                 nazwisko                       imię_i_nazwisko          NIP_OSOBY                      IN
----------- ----------- -------------------- ------------------------------ ------------------------ ------------------------------ ----------------------
1           1           Maciej               Stodolski                      M. Stodolski             NULL                           M/Stodolski
2           2           Jacek                Korytkowski                    J. Korytkowski           NULL                           J/Korytkowski
3           3           Mis                  Nieznany                       M. Nieznany              NULL                           M/Nieznany
4           4           Król                 Neptun                         K. Neptun                NULL                           K/Neptun
5           2           Już                  Niepracujący                   J. Niepracujący          NULL                           J/Niepracujący
6           1           Anna                 Stodolska                      A. Stodolska             NULL                           A/Stodolska
7           1           X                    Stodolsk                       X. Stodolsk              NULL                           X/Stodolsk
8           1           Y                    Stodolskiewicz                 Y. Stodolskiewicz        NULL                           Y/Stodolskiewicz
9           1           Jacek                Testowy                        J. Testowy               NULL                           J/Testowy
10          1           Maciej               Testowy                        M. Testowy               NULL                           M/Testowy
11          1           Maciej               KX_Stodolski                   M. KX_Stodolski          NULL                           M/KX_Stodolski
12          2           Jacek                KX_Korytkowski                 J. KX_Korytkowski        NULL                           J/KX_Korytkowski
13          2           Już                  KX_Niepracujący                J. KX_Niepracujący       NULL                           J/KX_Niepracujący
14          1           Anna                 KX_Stodolska                   A. KX_Stodolska          NULL                           A/KX_Stodolska
15          1           X                    KX_Stodolsk                    X. KX_Stodolsk           NULL                           X/KX_Stodolsk
16          1           Y                    KX_Stodolskiewicz              Y. KX_Stodolskiewicz     NULL                           Y/KX_Stodolskiewicz
17          1           Jacek                KX_Testowy                     J. KX_Testowy            NULL                           J/KX_Testowy
18          1           Maciej               KX_Testowy                     M. KX_Testowy            NULL                           M/KX_Testowy

(18 row(s) affected)
*/

/* 
procedury zwracające wartosci przez parametr

procedura , która datę zamieni na tekst YYYYMM
*/

EXEC dbo.TWORZ_PUSTA_PROC @nazwa = N'D2YYYYMM'
GO

ALTER PROCEDURE D2YYYYMM( @d datetime = null, @ym nchar(6) = null output )
AS
	IF @d IS NULL
		SET @d = GETDATE()

	SET @ym = CONVERT(nchar(6), @d, 112)
GO

/* 
Nie wystarczy zdefiniowac prametru jako OUTPUT
*/
DECLARE @ym_loc nchar(6)
EXEC D2YYYYMM @ym=@ym_loc 
SELECT @ym_loc AS dyyyymm

EXEC D2YYYYMM @ym=@ym_loc output
SELECT @ym_loc AS dyyyymm
/*
dyyyymm
-------
NULL

(1 row(s) affected)

dyyyymm
-------
202204

(1 row(s) affected)
zdefiniowanie parametru procedury jako OUTPUT to tylko sygnał, ze MOŻEMY tam coś podstawić
Jezeli chcemy przenosić przez ten parametr dane/wyniki to przy wywołąniu musimy tez 
napisac OUTPUT
*/

/*
Jezeli procedura ma TYLKO zwrócić jedną wartość to lepszą do tego typu zadań jest FUNKCJA
*/
GO
CREATE FUNCTION dbo.f_D2YYYYMM( @d datetime  )
RETURNS nchar(6) /* zwracany typ danych */
AS
BEGIN
	IF @d IS NULL
		RETURN N'-brakD'

	RETURN CONVERT(nchar(6), @d, 112)
END
GO

SELECT dbo.f_D2YYYYMM(null)

/* funkcje można stosować w zapytaniach 
*/
SELECT e.id_osoby, e.id_firmy, e.pensja, dbo.f_D2YYYYMM(e.od) AS od, dbo.f_D2YYYYMM(e.do) AS do
	FROM etaty e
	WHERE dbo.f_D2YYYYMM(e.do) LIKE N'-%'
/*
id_osoby    id_firmy pensja                od     do
----------- -------- --------------------- ------ ------
1           PW       3520,00               200001 -brakD
1           PW       2420,00               199901 -brakD
1           HP       22000,00              200001 -brakD
2           PW       3520,00               200111 -brakD
4           FŁP      71720,00              200410 -brakD
6           fłp      220000,00             202011 -brakD
3           pw       220000,00             202011 -brakD

(7 row(s) affected)
*/

EXEC dbo.TWORZ_PUSTA_PROC @nazwa = N'sr_w_miescie'
GO

ALTER PROCEDURE dbo.sr_w_miescie
AS /* z miasta gdzie jest mieszka osoba */
	SELECT o.id_miasta, m.nazwa AS [nazwa miasta], AVG(e.pensja) AS [srednia w mieście]   
		FROM ETATY e
		join osoby o on (o.id_osoby = e.id_osoby)
		join miasta m ON (m.id_miasta = o.id_miasta)
		GROUP BY o.id_miasta, m.nazwa
		ORDER BY m.nazwa, o.id_miasta 
GO

EXEC dbo.sr_w_miescie

