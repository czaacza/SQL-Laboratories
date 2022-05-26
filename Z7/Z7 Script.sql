/* Z.7	Mateusz Czarnecki	Grupa 2	319030*/

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
	Polecenia u³atwiaj¹ce prace podczas wykonywania zadania s³u¿¹ce do czyszczenia tabel i triggerów.
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
INSERT INTO KSIAZKI (tytul, autor, stan_bibl) VALUES (N'Kordian', N'Juliusz S³owacki', 5)
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
	Tworzê tabele KSIAZKI, WYP, ZWR i skasowane. Do tabeli ksi¹¿ki dodaje kilka przyk³adowych tytu³ów.
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
	Tworzê trigger, który podczas dodawania rekordu ustawia domyœln¹ wartoœæ kolumny stan_dostepny na wartoœæ stan_bibl.
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
	Tworzê procedurê u³atwiaj¹c¹ testowanie zapytañ dotycz¹cych reszty czêœci zadania.
	Procedura pokazuje dane ksi¹¿ki oraz liczbê wypo¿yczonych i zwróconych ksi¹¿ek. 

	Po utworzeniu tabel KSIAZKI, WYP, ZWR bilans dostêpnych, wypo¿yczonych i zwróconych ksi¹¿ek prezentuje siê nastêpuj¹co:

	tytul                autor                id_ksiazki  stan_bibl   stan_dostepny liczba wyp  liczba zwr
	-------------------- -------------------- ----------- ----------- ------------- ----------- -----------
	Pan Tadeusz          Adam Mickiewicz      1           4           4             0           0
	Kordian              Juliusz S³owacki     2           5           5             0           0
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
	RAISERROR(N'Stan dostepny ksiazek osi¹gn¹³ wartoœæ wiêksz¹ ni¿ stan biblioteki', 16, 3)
	ROLLBACK TRAN
	END
GO

/*
	Tworzê trigger wyœwietlaj¹cy b³¹d w przypadku próby aktualizacji wartoœci stan_dostepny na mniejsz¹ od 0.
	Trigger ten zapobiega sytuacji, w której chcemy wypo¿yczyæ wiêcej ksi¹¿ek ni¿ jest dostêpnych w bibliotece.

	Oprócz tego, trigger zapobiega sytuacji w której stan dostêpny ksi¹¿ek osi¹ga wartoœæ wiêksz¹ od stanu bibliotecznego.
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
exec pokaz

/*
	Po wprowadzeniu danych, stan dostêpny ksi¹¿ki "Pan Tadeusz" zmniejszy³ siê o liczbê wypo¿yczonych ksi¹¿ek - o 2.

	tytul                autor                id_ksiazki  stan_bibl   stan_dostepny liczba wyp  liczba zwr
	-------------------- -------------------- ----------- ----------- ------------- ----------- -----------
	Pan Tadeusz          Adam Mickiewicz      1           4           2             2           0
	Kordian              Juliusz S³owacki     2           5           5             0           0
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
	Tworzê trigger reaguj¹cy na wstawianie rekordów to tabeli ZWR.
	Wprowadzaj¹c rekord do tabeli ZWR, trigger dodaje do stanu dostêpnego liczbê zwórconych ksi¹¿ek.
*/

INSERT INTO ZWR(id_osoby, id_ksiazki, liczba, czas) VALUES (1, 1, 2, CONVERT(datetime, '12/01/2022', 103))
exec pokaz

/*
	Po zwróceniu ksi¹¿ki "Pan Tadeusz", stan dostêpny ksi¹¿ek w bibliotece zwiêkszy³ siê o 2, a wiêc wróci³ do pierwotnej wartoœci.

	tytul                autor                id_ksiazki  stan_bibl   stan_dostepny liczba wyp  liczba zwr
	-------------------- -------------------- ----------- ----------- ------------- ----------- -----------
	Pan Tadeusz          Adam Mickiewicz      1           4           4             2           2
	Kordian              Juliusz S³owacki     2           5           5             0           0
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
	Tworzê trigger reaguj¹cy na usuwanie rekordów z tabeli WYP.
	Usuwaj¹c rekord z tabeli WYP, trigger dodaje do stanu dostêpnego liczbê usuniêtych wypo¿yczonych ksi¹¿ek.
*/

DELETE FROM WYP WHERE WYP.id_ksiazki = 1
exec pokaz

/* 
	Po usuniêciu z tabeli WYP dwóch rekordów o id_ksiazki = 1 - "Pan Tadeusz", ka¿da po 2 sztuki, do tabeli KSIAZKI dodane zosta³y 4 takie ksi¹¿ki.
	W tabeli ksiazki znajduje sie zatem obecnie 6 ksiazek "Pan Tadeusz".

	tytul                autor                id_ksiazki  stan_bibl   stan_dostepny liczba wyp  liczba zwr
	-------------------- -------------------- ----------- ----------- ------------- ----------- -----------
	Pan Tadeusz          Adam Mickiewicz      1           4           4             0           0
	Kordian              Juliusz S³owacki     2           5           5             0           0
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
	Tworzê trigger reaguj¹cy na usuwanie rekordów z tabeli ZWR.
	Usuwaj¹c rekord z tabeli ZWR, trigger odejmuje od stanu dostêpnego liczbê usuniêtych zwróconych ksi¹¿ek.
*/

DELETE FROM ZWR WHERE ZWR.id_ksiazki = 1
exec pokaz

/* 
	Po usuniêciu z tabeli ZWR rekordU o id_ksiazki = 1 - "Pan Tadeusz" (2 sztuki), stan obecny ksi¹¿ek i liczba zwrotów zmieni³y siê.
	Stan dostêpny biblioteki wynnosi zatem obecnie 2 ksi¹¿ki.

	tytul                autor                id_ksiazki  stan_bibl   stan_dostepny liczba wyp  liczba zwr
	-------------------- -------------------- ----------- ----------- ------------- ----------- -----------
	Pan Tadeusz          Adam Mickiewicz      1           4           2             2           2
	Kordian              Juliusz S³owacki     2           5           5             0           0
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
	Tworzê trigger reaguj¹cy na UPDATE rekordów z tabeli WYP.
	Edytuj¹c WYP, trigger odejmuje od stanu dostêpnego ró¿nicê liczby ksi¹¿ek, jaka zosta³a zmieniona.
*/

UPDATE WYP SET liczba = 3
WHERE id_ksiazki = 1
exec pokaz

/*
	Po edytowaniu liczby (z wartosci 2 do 3) wypo¿yczonych ksi¹zek o id_ksiazki = 1, stan tabeli ksiazki zmienia siê o ró¿nicê zedytowanej i poprzedniej wartoœci. 
	Stan dostepny ksiazki "Pan Tadeusz" zmniejszy³ siê wiêc z 2 do 1.

	Stan przed UPDATE:
	tytul                autor                id_ksiazki  stan_bibl   stan_dostepny liczba wyp  liczba zwr
	-------------------- -------------------- ----------- ----------- ------------- ----------- -----------
	Pan Tadeusz          Adam Mickiewicz      1           4           2             2           0
	Kordian              Juliusz S³owacki     2           5           5             0           0
	Dziady               Adam Mickiewicz      3           7           7             0           0
	Rok 1984             George Orwell        4           2           2             0           0
	Quo Vadis            Henryk Sienkiewicz   5           4           4             0           0

	Stan po UPDATE:
	tytul                autor                id_ksiazki  stan_bibl   stan_dostepny liczba wyp  liczba zwr
	-------------------- -------------------- ----------- ----------- ------------- ----------- -----------
	Pan Tadeusz          Adam Mickiewicz      1           4           1             3           0
	Kordian              Juliusz S³owacki     2           5           5             0           0
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
	Tworzê trigger reaguj¹cy na UPDATE rekordów z tabeli ZWR.
	Edytuj¹c ZWR, trigger doda do stanu dostêpnego ró¿nicê liczby ksi¹¿ek, jaka zosta³a zmieniona.
*/

UPDATE ZWR SET liczba = 2
WHERE id_ksiazki = 1

INSERT INTO ZWR (id_osoby, id_ksiazki, liczba, czas) VALUES (2, 1, 1, CONVERT(datetime, '06/01/2022', 103))

exec pokaz

/*
	Po edytowaniu liczby (z wartosci 1 do 2) zwróconych ksi¹zek o id_ksiazki = 1, stan tabeli ksiazki powiêksza siê o ró¿nicê zedytowanej i poprzedniej wartoœci. 
	Stan dostepny ksiazki "Pan Tadeusz" zwiêkszy³ siê wiêc z 3 do 4.

	Stan przed UPDATE:
	tytul                autor                id_ksiazki  stan_bibl   stan_dostepny liczba wyp  liczba zwr
	-------------------- -------------------- ----------- ----------- ------------- ----------- -----------
	Pan Tadeusz          Adam Mickiewicz      1           4           3             2           1
	Kordian              Juliusz S³owacki     2           5           5             0           0
	Dziady               Adam Mickiewicz      3           7           7             0           0
	Rok 1984             George Orwell        4           2           2             0           0
	Quo Vadis            Henryk Sienkiewicz   5           4           4             0           0

	Stan po UPDATE:
	tytul                autor                id_ksiazki  stan_bibl   stan_dostepny liczba wyp  liczba zwr
	-------------------- -------------------- ----------- ----------- ------------- ----------- -----------
	Pan Tadeusz          Adam Mickiewicz      1           4           4             2           2
	Kordian              Juliusz S³owacki     2           5           5             0           0
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
	Tworzê osobne triggery dla WYP i ZWR reaguj¹ce na usuwanie rekordów z tabel.
	rodzaj (wyp/zwr), id_osoby, id_ksiazki i liczba usuniêtych ksi¹¿ek zapisana zostanie do osobnej tabeli skasowane.
*/

DELETE FROM ZWR WHERE ZWR.id_ksiazki = 1
DELETE FROM WYP WHERE WYP.id_ksiazki = 1
SELECT * FROM skasowane

/* 
	Po przyk³adowym usuniêciu rekordów z tabel ZWR i WYP, tabela skasowane prezentuje siê nastêpuj¹co:
	
	rodzaj id_osoby    id_ksiazki  liczba
	------ ----------- ----------- -----------
	zwr    2           1           2
	wyp    1           1           2
*/
