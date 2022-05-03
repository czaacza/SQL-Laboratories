/* BD wykład 2022.04.25
** maciej.stodolski@pw.edu.pl
*/
/* 
Bazy na serwerze prez nazwe 
Tabele w bazie przez nazwę 
Kolumny w tabeli przez nazwę (czyli wszystko w.w. unikalne nazwy
Wiersze przez "nazwę" czyli zawartość danych w wierszu
Zbiór kolumn, który dla tabeli jest unikalny to Klucz Głowny (Primary KEY)

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


/* 
	UPDATE Tabela SET kol=wart [,kolN=wartN] WHERE WW

*/

/*

UPDATE Tabela SET kol=T2.kolumna
	FROM Tabela join T2 ON (..)
	WHERE WW
*/

SELECT * INTO osoby_bk FROM osoby o

SELECT * FROM osoby_bk

/* pod spodem częsty bład - brak WHERE */

UPDATE osoby SET nazwisko = N'Smith' 

/* niechcacy zmieniliśmy wszystkim nazwiska na jedno wspólne */

SELECT * FROM osoby 
/*
id_osoby    id_miasta   imię                 nazwisko                       imię_i_nazwisko          NIP_OSOBY                      IN
----------- ----------- -------------------- ------------------------------ ------------------------ ------------------------------ ----------------------
1           1           Maciej               Smith                          M. Smith                 NULL                           M/Smith
2           2           Jacek                Smith                          J. Smith                 NULL                           J/Smith
3           3           Mis                  Smith                          M. Smith                 NULL                           M/Smith
4           4           Król                 Smith                          K. Smith                 NULL                           K/Smith
5           2           Już                  Smith                          J. Smith                 NULL                           J/Smith
6           1           Anna                 Smith                          A. Smith                 NULL                           A/Smith
7           1           X                    Smith                          X. Smith                 NULL                           X/Smith
8           1           Y                    Smith                          Y. Smith                 NULL                           Y/Smith
9           1           Jacek                Smith                          J. Smith                 NULL                           J/Smith
10          1           Maciej               Smith                          M. Smith                 NULL                           M/Smith
11          1           Maciej               Smith                          M. Smith                 NULL                           M/Smith
12          2           Jacek                Smith                          J. Smith                 NULL                           J/Smith
13          2           Już                  Smith                          J. Smith                 NULL                           J/Smith
14          1           Anna                 Smith                          A. Smith                 NULL                           A/Smith
15          1           X                    Smith                          X. Smith                 NULL                           X/Smith
16          1           Y                    Smith                          Y. Smith                 NULL                           Y/Smith
17          1           Jacek                Smith                          J. Smith                 NULL                           J/Smith
18          1           Maciej               Smith                          M. Smith                 NULL                           M/Smith

(18 row(s) affected)
*/

UPDATE osoby SET nazwisko = b.nazwisko  
	FROM osoby join osoby_bk b ON (osoby.id_osoby = b.id_osoby)

SELECT o.id_osoby, o.imię, o.nazwisko, o.id_osoby  FROM osoby o
/*
id_osoby    imię                 nazwisko                       id_osoby
----------- -------------------- ------------------------------ -----------
1           Maciej               Stodolski                      1
2           Jacek                Korytkowski                    2
3           Mis                  Nieznany                       3
4           Król                 Neptun                         4
5           Już                  Niepracujący                   5
6           Anna                 Stodolska                      6
7           X                    Stodolsk                       7
8           Y                    Stodolskiewicz                 8
9           Jacek                Testowy                        9
10          Maciej               Testowy                        10
11          Maciej               KX_Stodolski                   11
12          Jacek                KX_Korytkowski                 12
13          Już                  KX_Niepracujący                13
14          Anna                 KX_Stodolska                   14
15          X                    KX_Stodolsk                    15
16          Y                    KX_Stodolskiewicz              16
17          Jacek                KX_Testowy                     17
18          Maciej               KX_Testowy                     18

(18 row(s) affected)
*/

/*

przechowujmy przy miescie liczbę mieszkaańców
nie jest polecane gdyz przy INSERT / UPDATE / DELETE dla OSOBY trzeba by niestety tez modyfikować ten liczni

*/
IF NOT EXISTS 
( SELECT c.[name] AS nazwa_kol 
	FROM sysobjects o 
	join syscolumns c ON (c.[id] = o.[id])
	WHERE	(o.[name] = N'miasta')
	AND		(c.[name] = N'ILE_OS')
)
BEGIN
	ALTER TABLE MIASTA ADD ILE_OS INT NOT NULL DEFAULT 0
END
GO

SELECT * FROM miasta
/*
id_miasta   kod_woj nazwa                          ILE_OS
----------- ------- ------------------------------ -----------
1           MAZ     WESOŁA                         0
2           MAZ     WARSZAWA                       0
3           POM     GDAŃSK                         0
4           POM     SOPOT                          0
*/
/* 
zakladam, ze UPDATE działa jak petla 

Wwa ma 3 mieszkancow wiec zakaldam ze zadziala tak
czyli jeden wiersz MIASTA ma 3 odpowiadające wiersze OSOBY dla Warszawy
czyli po złaczenu będą 3 updaty tabeli MIASTA

1 = 0 /* tyl było*/ + 1
2 = 1 + 1
3 = 2 + 1

*/

UPDATE miasta  SET ILE_OS = ILE_OS + 1
	FROM miasta 
	join osoby o ON (miasta.id_miasta = o.id_miasta)

SELECT * FROM miasta
/*
id_miasta   kod_woj nazwa                          ILE_OS
----------- ------- ------------------------------ -----------
1           MAZ     WESOŁA                         1
2           MAZ     WARSZAWA                       1
3           POM     GDAŃSK                         1
4           POM     SOPOT                          1

(4 row(s) affected)
WNIOSEK w UPDATE nie wolno brać początkowych wartości i je zwiększać 
tzn początowe wartości so pobierane TYLKO RAZ

*/

/* 
WNIOSE ZAWSZE robimy UPDATE po kluczach glownych aby jeden wiersz w UPDATE był aktualizowany
TYLKO jeden raz
*/
INSERT INTO miasta (kod_woj, nazwa) VALUES (N'MAZ', N'Łomianki')


UPDATE miasta SET ILE_OS = ISNULL(X.l_os,0) 
	FROM miasta
	left outer
	JOIN ( SELECT o.id_miasta, COUNT(*) AS l_os 
			FROM osoby o
			GROUP BY o.id_miasta 
		) X ON (miasta.id_miasta = X.id_miasta )

SELECT * FROM miasta
/*
id_miasta   kod_woj nazwa                          ILE_OS
----------- ------- ------------------------------ -----------
1           MAZ     WESOŁA                         12
2           MAZ     WARSZAWA                       4
3           POM     GDAŃSK                         1
4           POM     SOPOT                          1
5           MAZ     Łomianki                       0

(5 row(s) affected)
*/
 
 /* 
 Kazde polecenie SQL to pojedyncza transakcja
 TRANSAKCJA to zbiór kroków który 
 - albo się uda i wszystkie zmainy zobaczymy
 - albo zostanie przerwany/odwołany i ZADNEJ ZMIANY NIE ZOACZYMY

 DELETE FROM Tabela 
 - albo usunie wszystie rekordy albo zadnego
 */

 /*
 BEGIN TRAN Nazwa

 polecenia SQL
 commit tran nazwa
 albo ROLLBACK TRAN Nazwa

 */

/* załóżmy, że podwyżka to jest zbiór dwu operacji
1. Dezaktualizacji aktualnego etatu
2. Wstawienie nowego z nową pensją
*/
BEGIN TRAN podw

UPDATE etaty SET do = GETDATE() WHERE id_etatu = 1
INSERT INTO etaty (pensja, lista poz kol) 
	SELECT ROUND(e.pensja*1.1,2), ... FROM etaty e WHERE e.id_etatu = 1

COMMIT TRAN podw

/* albo uda się zrealizowac obydwa kroki albo nie będzie efektu
*/

BEGIN TRAN Test

DELETE FROM etaty WHERE id_osoby = 1
DELETE from osoby WHERE id_osoby = 1

SELECT * FROM osoby WHERE id_osoby = 1

ROLLBACK TRAN Test
 
SELECT * FROM osoby WHERE id_osoby = 1
SELECT * FROM etaty WHERE id_osoby = 1


/* 
TRIGGER  - to jest  procedura bazodanowa, która 
1) nie ma parametrów
2) jest związana TYLKO z 1 tabelą
3) może być uruchomiana TYLKO w powiązaniu z akcjami na tej tabeli typu INSERT / UPDATE / DELETE

UWAGA - wewnątrz Triggera mamy dostęp do transakcji rozpoczętj przez SQL
np.
INSERT INTO woj (kod_woj, nazwa) VALUES ('x', 'x')
jezeli jest trigger na wstawienie do tabeli WOJ to 

a) SQL rozpocznie transakcję
b) SQL wstawi daną do tabeli WOJ
c) Wywola trigger
d) zakończy transakcje
*/ 
/*
	CREATE TRIGGER dbo.Nazwa ON Tabela FOR [insert / update / delate]
*/
GO
CREATE TRIGGER dbo.TR_woj_ins ON WOJ FOR INSERT
AS
	RAISERROR(N'WETO !!! nie pozwalam', 16, 3)
	ROLLBACK TRAN
GO

INSERT INTO woj (kod_woj, nazwa) VALUES ('x', 'x')
/*
Msg 50000, Level 16, State 3, Procedure TR_woj_ins, Line 3
WETO !!! nie pozwalam
Msg 3609, Level 16, State 1, Line 1
The transaction ended in the trigger. The batch has been aborted.
*/

DROP TRIGGER TR_woj_ins
INSERT INTO woj (kod_woj, nazwa) VALUES ('x', 'x')


/* 
** wewnątrz TRIGGER-a mamy dostępne 2 tabele
** INSERTED i DELETED o strukturze takiej samej ja tabela związana z TRIGGEREM
**
** INSERT: DELETED - pusto, INSERTED - nowe dane
** DELETE: DELETED - skaosowane dane, INSERTED - pusto
** UPDATE: DELETED - stare dane, INSERTED - nowe dane
**
** Wewnątrz triggera mamy funcje UPDATE(kolumna) - TRUE jeśli polecenie UDATE
** podstawiało coś pod kolumnę
**
** 3 reguły tworzenia TRIGGERA
** R1 - Trigger nie może aktualizować CALEJ tabeli a co najwyżej elementy zmienione
** R2 - Trigger może wywołać sam siebie - uzysamy niesończoną rekurencję == stack overflow
** R3 - Zawsze zakladamy, że wstawiono / zmodyfikowano / skasowano wiecej jak 1 rekord
*/ 

/* poprawiamy kod pocztowy na tai z - ja jej nie ma */
GO
CREATE TRIGGER dbo.TR_firmy_ins_upd ON firmy for INSERT, UPDATE
AS
	IF UPDATE(kod_pocztowy) /* czy polecenie update lub insert dotyczylo tej kolumny */
	AND EXISTS (SELECT 1 FROM inserted i WHERE i.kod_pocztowy NOT LIKE N'%-%')
		UPDATE firmy SET kod_pocztowy = LEFT(kod_pocztowy,2) + N'-' + SUBSTRING(kod_pocztowy,3,3)
		/* niedopuszczalne modyfikowanie calej tabeli poprzez modyfikowanie 1 wiersza */
		WHERE nazwa_skr IN 
		(	SELECT i.nazwa_skr 
				FROM inserted i 
				WHERE i.kod_pocztowy NOT LIKE N'%-%') /* spełnienie R1 */
GO

UPDATE firmy SET kod_pocztowy = REPLACE(kod_pocztowy, N'-', N'') WHERE nazwa_skr = N'HP'

select * from firmy

UPDATE firmy SET kod_pocztowy = REPLACE(kod_pocztowy, N'-', N'')

GO
--drop trigger TR_osoby_ins

CREATE TRIGGER dbo.TR_osoby_ins ON osoby for INSERT
AS

	UPDATE miasta SET ILE_OS = ILE_OS + X.nowi
		FROM miasta 
		join (SELECT i.id_miasta, COUNT(*) AS nowi
				FROM inserted i 
				GROUP BY i.id_miasta
			) X ON (X.id_miasta = miasta.id_miasta)

GO
GO
CREATE TRIGGER dbo.TR_osoby_del ON osoby for DELETE
AS

	UPDATE miasta SET ILE_OS = ILE_OS - X.nowi
		FROM miasta 
		join (SELECT d.id_miasta, COUNT(*) AS nowi
				FROM deleted  d 
				GROUP BY d.id_miasta
			) X ON (X.id_miasta = miasta.id_miasta)

GO

insert into osoby (imię, nazwisko, id_miasta) 
	SELECT N'X' + STR(o.id_osoby, 5, 0), o.nazwisko, o.id_miasta 
		FROM osoby o
		WHERE o.id_miasta in (1,2)

select * from osoby WHERE imię LIKE N'X%[0-9]'

DELETE from osoby WHERE imię LIKE N'X%[0-9]'

select * from miasta 

GO

CREATE TRIGGER dbo.TR_osoby ON osoby for INSERT, UPDATE, DELETE
AS

	UPDATE miasta SET ILE_OS = ILE_OS - X.nowi
		FROM miasta 
		join (SELECT d.id_miasta, COUNT(*) AS nowi
				FROM deleted  d 
				GROUP BY d.id_miasta
			) X ON (X.id_miasta = miasta.id_miasta)

	UPDATE miasta SET ILE_OS = ILE_OS + X.nowi
		FROM miasta 
		join (SELECT i.id_miasta, COUNT(*) AS nowi
				FROM inserted i 
				GROUP BY i.id_miasta
			) X ON (X.id_miasta = miasta.id_miasta)

GO

insert into osoby (imię, nazwisko, id_miasta) 
	SELECT N'X' + STR(o.id_osoby, 5, 0), o.nazwisko, o.id_miasta 
		FROM osoby o
		WHERE o.id_miasta in (1,2)

select * from miasta 

UPDATE osoby SET id_miasta = 1 WHERE imię LIKE N'X%[0-9]' AND id_miasta = 2
select * from miasta 
DELETE from osoby WHERE imię LIKE N'X%[0-9]'

select * from miasta 

