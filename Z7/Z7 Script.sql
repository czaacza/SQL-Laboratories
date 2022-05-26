/* Z.7	Mateusz Czarnecki	Grupa 2	319030*/

/* stworzy� bibliotek� (uproszczon�)
**
** Tabela Ksiazka (tytul, autor, id_ksiazki, stan_bibl, stan_dostepny - dom 0)
** Skorzysta� z tabeli OSOBY kt�r� macie
** Tabela WYP (id_osoby, id_ksiazki, liczba, data)
** Tabela ZWR (id_osoby, id_ksiazki, liczba, data)
** Napisa� triggery aby:
** dodanie rekordow do WYP powodowalo aktualizacj� Ksiazka (stan_dostepny)
** UWAGA zakladamy ze na raz mozna dodawac wiele rekordow
** w tym dla tej samej osoby, z tym samym id_ksiazki


CREATE TABLE #wyp(id_os int not null, id_ks int not null, liczba int not null)
INSERT INTO #wyp (id_os, id_ks, liczba) VALUES (1, 1, 1), (1, 1, 2), (2, 5, 6)

Zwrot zwi�ksza stan_dostepny

** UWAGA
** Zrealizowa� TRIGERY na kasowanie z WYP lub ZWR
**
** Zrealizowa� triggery, ze nastapi�a pomy�ka czyli UPDATE na WYP lub ZWR
** Wydaje mi sie, ze mozna napisac po jednym triggerze na WYP lub ZWR na
** wszystkie akcje INSERT / UPDATE / DELETE
**
** Testowanie: stworzcie procedur�, kt�ra pokaze wszystkie ksi�zki,
** dane ksi�zki, stan_bibl, SUM(liczba) z ZWR - SUM(liczba) z WYP =>
** ISNULL(SUM(Liczba),0)
** te dwie kolumny powiny by� r�wne
** po wielu dzialaniach w bazie
** dzialania typu kasowanie rejestrowac w tabeli skasowane
** (rodzaj (wyp/zwr), id_os, id_ks, liczba)
** osobne triggery na DELETE z WYP i ZWR kt�re b�d� rejestrowa� skasowania\

stan bibl - liczba ksiazek jaka mialaby biblioteka gdyby nikt nic nie wypozyczyl
*/

GO
IF OBJECT_ID(N'SKASOWANE') IS NOT NULL
	DROP TABLE SKASOWANE

IF OBJECT_ID(N'ZWR') IS NOT NULL
	DROP TABLE ZWR

IF OBJECT_ID(N'WYP') IS NOT NULL
	DROP TABLE WYP

IF OBJECT_ID(N'KSIAZKI') IS NOT NULL
	DROP TABLE KSIAZKI

DROP TRIGGER tr_ins_ks
DROP TRIGGER tr_ins_wyp
DROP TRIGGER tr_ins_zwr
DROP TRIGGER tr_del_wyp
DROP TRIGGER tr_del_zwr
DROP TRIGGER tr_upd_wyp
DROP TRIGGER tr_upd_zwr
DROP TRIGGER tr_del_wyp_sk
DROP TRIGGER tr_del_zwr_sk

/*
	Polecenia u�atwiaj�ce prace podczas wykonywania zadania s�u��ce do czyszczenia tabel i trigger�w.
*/



CREATE TABLE dbo.KSIAZKI 
(
	tytul			nvarchar(20)	NOT NULL,
	autor			nvarchar(20)	NOT NULL,
	id_ksiazki		int				NOT NULL	IDENTITY CONSTRAINT PK_KSIAZKI PRIMARY KEY,
	stan_bibl		int				NOT NULL,
	stan_dostepny	int				NULL
)

DECLARE @ks_pt int, @ks_ko int, @ks_dz int, @ks_ro int, @ks_qu int

INSERT INTO KSIAZKI (tytul, autor, stan_bibl) VALUES (N'Pan Tadeusz', N'Adam Mickiewicz', 4)
SET @ks_pt = SCOPE_IDENTITY()
INSERT INTO KSIAZKI (tytul, autor, stan_bibl) VALUES (N'Kordian', N'Juliusz S�owacki', 5)
SET @ks_ko = SCOPE_IDENTITY()
INSERT INTO KSIAZKI (tytul, autor, stan_bibl) VALUES (N'Dziady', N'Adam Mickiewicz', 7)
SET @ks_dz = SCOPE_IDENTITY()
INSERT INTO KSIAZKI (tytul, autor, stan_bibl) VALUES (N'Rok 1984', N'George Orwell', 2)
SET @ks_ro = SCOPE_IDENTITY()
INSERT INTO KSIAZKI (tytul, autor, stan_bibl) VALUES (N'Quo Vadis', N'Henryk Sienkiewicz', 4)
SET @ks_qu = SCOPE_IDENTITY()

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

CREATE TABLE dbo.skasowane 
( 
	rodzaj		nchar(3)	NOT NULL,
	id_osoby	int			NOT NULL	CONSTRAINT FK_SK_OSOBY 
										FOREIGN KEY REFERENCES OSOBY(id_osoby),
	id_ksiazki	int			NOT NULL	CONSTRAINT FK_SK_KSIAZKI
										FOREIGN KEY  REFERENCES KSIAZKI(id_ksiazki),
	liczba		int			NOT NULL
)

/*
	Tworz� tabele KSIAZKI, WYP, ZWR i skasowane. Do tabeli ksi��ki dodaje kilka przyk�adowych tytu��w.
*/

GO
CREATE TRIGGER dbo.tr_ins_ks ON KSIAZKI FOR INSERT
AS
	UPDATE KSIAZKI SET stan_dostepny = (SELECT i.stan_bibl FROM inserted i)
	WHERE KSIAZKI.id_ksiazki IN
	(SELECT k.id_ksiazki
			FROM KSIAZKI k JOIN inserted i ON k.id_ksiazki = i.id_ksiazki)
GO

/*
	Tworz� trigger, kt�ry podczas dodawania rekordu ustawia domy�ln� warto�� kolumny stan_dostepny na warto�� stan_bibl.
*/

GO
ALTER PROCEDURE dbo.pokaz
AS
	SELECT k.*, ISNULL(x.[liczba wyp],0) AS [liczba wyp], ISNULL(x.[liczba zwr], 0) AS [liczba zwr]
			FROM KSIAZKI k
			LEFT OUTER
			JOIN (
					SELECT w.id_ksiazki, ISNULL(SUM(w.liczba),0) AS [liczba wyp], ISNULL(SUM(z.liczba),0) AS [liczba zwr]
							FROM WYP w
							LEFT OUTER
							JOIN ZWR z ON z.id_ksiazki = w.id_ksiazki
							GROUP BY w.id_ksiazki
				) x ON x.id_ksiazki = k.id_ksiazki
GO

exec pokaz

/*
	Tworz� procedur� u�atwiaj�c� testowanie zapyta� dotycz�cych reszty cz�ci zadania.
	Procedura pokazuje dane ksi��ki oraz liczb� wypo�yczonych i zwr�conych ksi��ek. 

	Po utworzeniu tabel KSIAZKI, WYP, ZWR bilans dost�pnych, wypo�yczonych i zwr�conych ksi��ek prezentuje si� nast�puj�co:

	tytul                autor                id_ksiazki  stan_bibl   stan_dostepny liczba wyp  liczba zwr
	-------------------- -------------------- ----------- ----------- ------------- ----------- -----------
	Pan Tadeusz          Adam Mickiewicz      1           4           4             0           0
	Kordian              Juliusz S�owacki     2           5           5             0           0
	Dziady               Adam Mickiewicz      3           7           7             0           0
	Rok 1984             George Orwell        4           2           2             0           0
	Quo Vadis            Henryk Sienkiewicz   5           4           4             0           0
*/

GO
CREATE TRIGGER dbo.tr_ks ON KSIAZKI FOR UPDATE
AS
	IF UPDATE(stan_dostepny)
	AND EXISTS
	(
	SELECT *
			FROM inserted i 
			WHERE i.stan_dostepny < 0
	)
	BEGIN
	RAISERROR(N'Stan dostepny ksiazek osiagnal wartosc mniejsza od 0.', 16, 3)
	ROLLBACK TRAN
	END

	IF UPDATE(stan_dostepny)
	AND EXISTS
	(
	SELECT *
			FROM inserted i 
			WHERE i.stan_dostepny > i.stan_bibl
	)
	BEGIN
	RAISERROR(N'Stan dostepny ksiazek osi�gn�� warto�� wi�ksz� ni� stan biblioteki', 16, 3)
	ROLLBACK TRAN
	END
GO

/*
	Tworz� trigger wy�wietlaj�cy b��d w przypadku pr�by aktualizacji warto�ci stan_dostepny na mniejsz� od 0.
	Trigger ten zapobiega sytuacji, w kt�rej chcemy wypo�yczy� wi�cej ksi��ek ni� jest dost�pnych w bibliotece.

	Opr�cz tego, trigger zapobiega sytuacji w kt�rej stan dost�pny ksi��ek osi�ga warto�� wi�ksz� od stanu bibliotecznego.
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
	Tworz� trigger reaguj�cy na wstawianie rekord�w to tabeli WYP.
	Wprowadzaj�c rekord do tabeli WYP, trigger odejmuje od stanu dost�pnego liczb� wypo�yczonych ksi��ek.
*/

INSERT INTO WYP(id_osoby, id_ksiazki, liczba, czas) VALUES (1, 1, 2, CONVERT(datetime, '12/01/2022', 103))
exec pokaz

/*
	Po wprowadzeniu danych, stan dost�pny ksi��ki "Pan Tadeusz" zmniejszy� si� o liczb� wypo�yczonych ksi��ek - o 2.

	tytul                autor                id_ksiazki  stan_bibl   stan_dostepny liczba wyp  liczba zwr
	-------------------- -------------------- ----------- ----------- ------------- ----------- -----------
	Pan Tadeusz          Adam Mickiewicz      1           4           2             2           0
	Kordian              Juliusz S�owacki     2           5           5             0           0
	Dziady               Adam Mickiewicz      3           7           7             0           0
	Rok 1984             George Orwell        4           2           2             0           0
	Quo Vadis            Henryk Sienkiewicz   5           4           4             0           0
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
	Tworz� trigger reaguj�cy na wstawianie rekord�w to tabeli ZWR.
	Wprowadzaj�c rekord do tabeli ZWR, trigger dodaje do stanu dost�pnego liczb� zw�rconych ksi��ek.
*/

INSERT INTO ZWR(id_osoby, id_ksiazki, liczba, czas) VALUES (1, 1, 2, CONVERT(datetime, '12/01/2022', 103))
exec pokaz

/*
	Po zwr�ceniu ksi��ki "Pan Tadeusz", stan dost�pny ksi��ek w bibliotece zwi�kszy� si� o 2, a wi�c wr�ci� do pierwotnej warto�ci.

	tytul                autor                id_ksiazki  stan_bibl   stan_dostepny liczba wyp  liczba zwr
	-------------------- -------------------- ----------- ----------- ------------- ----------- -----------
	Pan Tadeusz          Adam Mickiewicz      1           4           4             2           2
	Kordian              Juliusz S�owacki     2           5           5             0           0
	Dziady               Adam Mickiewicz      3           7           7             0           0
	Rok 1984             George Orwell        4           2           2             0           0
	Quo Vadis            Henryk Sienkiewicz   5           4           4             0           0
*/


GO
CREATE TRIGGER dbo.tr_del_wyp ON WYP FOR DELETE
AS
	UPDATE KSIAZKI SET stan_dostepny = stan_dostepny + d.liczba
	FROM KSIAZKI k 
	JOIN deleted d ON k.id_ksiazki = d.id_ksiazki
	JOIN ZWR z ON k.id_ksiazki = z.id_ksiazki
	WHERE k.id_ksiazki IN (
		SELECT d.id_ksiazki
			FROM deleted d JOIN KSIAZKI k ON d.id_ksiazki = k.id_ksiazki
	)
GO

/*	
	Tworz� trigger reaguj�cy na usuwanie rekord�w z tabeli WYP.
	Usuwaj�c rekord z tabeli WYP, trigger dodaje do stanu dost�pnego liczb� usuni�tych wypo�yczonych ksi��ek.
*/

DELETE FROM WYP WHERE WYP.id_ksiazki = 1
exec pokaz

/* 
	Po usuni�ciu z tabeli WYP dw�ch rekord�w o id_ksiazki = 1 - "Pan Tadeusz", ka�da po 2 sztuki, do tabeli KSIAZKI dodane zosta�y 4 takie ksi��ki.
	W tabeli ksiazki znajduje sie zatem obecnie 6 ksiazek "Pan Tadeusz".

	tytul                autor                id_ksiazki  stan_bibl   stan_dostepny liczba wyp  liczba zwr
	-------------------- -------------------- ----------- ----------- ------------- ----------- -----------
	Pan Tadeusz          Adam Mickiewicz      1           4           4             0           0
	Kordian              Juliusz S�owacki     2           5           5             0           0
	Dziady               Adam Mickiewicz      3           7           7             0           0
	Rok 1984             George Orwell        4           2           2             0           0
	Quo Vadis            Henryk Sienkiewicz   5           4           4             0           0
*/


GO
CREATE TRIGGER dbo.tr_del_zwr ON ZWR FOR DELETE
AS
	UPDATE KSIAZKI SET stan_dostepny = stan_dostepny - d.liczba
	FROM KSIAZKI k JOIN deleted d ON k.id_ksiazki = d.id_ksiazki
	JOIN WYP w ON k.id_ksiazki = w.id_ksiazki
	WHERE k.id_ksiazki IN (
		SELECT d.id_ksiazki
			FROM deleted d JOIN KSIAZKI k ON d.id_ksiazki = k.id_ksiazki
	)
GO

/*	
	Tworz� trigger reaguj�cy na usuwanie rekord�w z tabeli ZWR.
	Usuwaj�c rekord z tabeli ZWR, trigger odejmuje od stanu dost�pnego liczb� usuni�tych zwr�conych ksi��ek.
*/

DELETE FROM ZWR WHERE ZWR.id_ksiazki = 1
exec pokaz

/* 
	Po usuni�ciu z tabeli ZWR rekordU o id_ksiazki = 1 - "Pan Tadeusz" (2 sztuki), stan obecny ksi��ek i liczba zwrot�w zmieni�y si�.
	Stan dost�pny biblioteki wynnosi zatem obecnie 2 ksi��ki.

	tytul                autor                id_ksiazki  stan_bibl   stan_dostepny liczba wyp  liczba zwr
	-------------------- -------------------- ----------- ----------- ------------- ----------- -----------
	Pan Tadeusz          Adam Mickiewicz      1           4           2             2           2
	Kordian              Juliusz S�owacki     2           5           5             0           0
	Dziady               Adam Mickiewicz      3           7           7             0           0
	Rok 1984             George Orwell        4           2           2             0           0
	Quo Vadis            Henryk Sienkiewicz   5           4           4             0           0

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
	Tworz� trigger reaguj�cy na UPDATE rekord�w z tabeli WYP.
	Edytuj�c WYP, trigger odejmuje od stanu dost�pnego r�nic� liczby ksi��ek, jaka zosta�a zmieniona.
*/

UPDATE WYP SET liczba = 3
WHERE id_ksiazki = 1
exec pokaz

/*
	Po edytowaniu liczby (z wartosci 2 do 3) wypo�yczonych ksi�zek o id_ksiazki = 1, stan tabeli ksiazki zmienia si� o r�nic� zedytowanej i poprzedniej warto�ci. 
	Stan dostepny ksiazki "Pan Tadeusz" zmniejszy� si� wi�c z 2 do 1.

	Stan przed UPDATE:
	tytul                autor                id_ksiazki  stan_bibl   stan_dostepny liczba wyp  liczba zwr
	-------------------- -------------------- ----------- ----------- ------------- ----------- -----------
	Pan Tadeusz          Adam Mickiewicz      1           4           2             2           0
	Kordian              Juliusz S�owacki     2           5           5             0           0
	Dziady               Adam Mickiewicz      3           7           7             0           0
	Rok 1984             George Orwell        4           2           2             0           0
	Quo Vadis            Henryk Sienkiewicz   5           4           4             0           0

	Stan po UPDATE:
	tytul                autor                id_ksiazki  stan_bibl   stan_dostepny liczba wyp  liczba zwr
	-------------------- -------------------- ----------- ----------- ------------- ----------- -----------
	Pan Tadeusz          Adam Mickiewicz      1           4           1             3           0
	Kordian              Juliusz S�owacki     2           5           5             0           0
	Dziady               Adam Mickiewicz      3           7           7             0           0
	Rok 1984             George Orwell        4           2           2             0           0
	Quo Vadis            Henryk Sienkiewicz   5           4           4             0           0
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
	Tworz� trigger reaguj�cy na UPDATE rekord�w z tabeli ZWR.
	Edytuj�c ZWR, trigger doda do stanu dost�pnego r�nic� liczby ksi��ek, jaka zosta�a zmieniona.
*/

UPDATE ZWR SET liczba = 2
WHERE id_ksiazki = 1

INSERT INTO ZWR (id_osoby, id_ksiazki, liczba, czas) VALUES (2, 1, 1, CONVERT(datetime, '06/01/2022', 103))

exec pokaz

/*
	Po edytowaniu liczby (z wartosci 1 do 2) zwr�conych ksi�zek o id_ksiazki = 1, stan tabeli ksiazki powi�ksza si� o r�nic� zedytowanej i poprzedniej warto�ci. 
	Stan dostepny ksiazki "Pan Tadeusz" zwi�kszy� si� wi�c z 3 do 4.

	Stan przed UPDATE:
	tytul                autor                id_ksiazki  stan_bibl   stan_dostepny liczba wyp  liczba zwr
	-------------------- -------------------- ----------- ----------- ------------- ----------- -----------
	Pan Tadeusz          Adam Mickiewicz      1           4           3             2           1
	Kordian              Juliusz S�owacki     2           5           5             0           0
	Dziady               Adam Mickiewicz      3           7           7             0           0
	Rok 1984             George Orwell        4           2           2             0           0
	Quo Vadis            Henryk Sienkiewicz   5           4           4             0           0

	Stan po UPDATE:
	tytul                autor                id_ksiazki  stan_bibl   stan_dostepny liczba wyp  liczba zwr
	-------------------- -------------------- ----------- ----------- ------------- ----------- -----------
	Pan Tadeusz          Adam Mickiewicz      1           4           4             2           2
	Kordian              Juliusz S�owacki     2           5           5             0           0
	Dziady               Adam Mickiewicz      3           7           7             0           0
	Rok 1984             George Orwell        4           2           2             0           0
	Quo Vadis            Henryk Sienkiewicz   5           4           4             0           0
*/


GO
CREATE TRIGGER dbo.tr_del_wyp_sk ON WYP FOR DELETE
AS
	DECLARE @wyp nchar(3)
	SET @wyp = N'wyp'
	INSERT INTO skasowane SELECT @wyp, d.id_osoby, d.id_ksiazki, d.liczba FROM deleted d
GO

CREATE TRIGGER dbo.tr_del_zwr_sk ON ZWR FOR DELETE
AS
	DECLARE @zwr nchar(3)
	SET @zwr = N'zwr'
	INSERT INTO skasowane SELECT @zwr, d.id_osoby, d.id_ksiazki, d.liczba FROM deleted d
GO

/*
	Tworz� osobne triggery dla WYP i ZWR reaguj�ce na usuwanie rekord�w z tabel.
	rodzaj (wyp/zwr), id_osoby, id_ksiazki i liczba usuni�tych ksi��ek zapisana zostanie do osobnej tabeli skasowane.
*/

DELETE FROM ZWR WHERE ZWR.id_ksiazki = 1
DELETE FROM WYP WHERE WYP.id_ksiazki = 1
SELECT * FROM skasowane

/* 
	Po przyk�adowym usuni�ciu rekord�w z tabel ZWR i WYP, tabela skasowane prezentuje si� nast�puj�co:
	
	rodzaj id_osoby    id_ksiazki  liczba
	------ ----------- ----------- -----------
	zwr    2           1           2
	wyp    1           1           2
*/
