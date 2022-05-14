/* BD wykład 2022.05.09
** maciej.stodolski@pw.edu.pl
*/
/* 
** CD transakcji
** Blokowanie transakcjami
** Transakcje w procedurach 
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

/* 
** Transakcja - zbór operacji które mogą się albo udać całowicie 
** a) wszystkie zmiany widoczne na raz po COMMIT
** b) ROLLBACK - odwołana i żanych zmian nie będzie
* Kazde pojedyncze polecenie SQL jest osobną transakcją
** TZN DELETE from OSOBY albo skasuje wszystko albo NIC
*/

SELECT @@TRANCOUNT  AS przed_tzew
BEGIN TRAN TZEW
SELECT @@TRANCOUNT  AS po_tzew

DELETE FROM ETATY WHERE id_osoby = 1

BEGIN TRAN TWEW
SELECT @@TRANCOUNT  AS po_twew


DELETE FROM osoby WHERE id_osoby = 1
SELECT * FROM osoby WHERE id_osoby = 1

ROLLBACK 

/* ROLLBACK odwołuje WSZYSTIE otwarte transacje
*/

SELECT @@TRANCOUNT  AS po_rollback

SELECT @@TRANCOUNT  AS st_przed
BEGIN TRAN T1
ROLLBACK TRAN T1
SELECT @@TRANCOUNT  AS st_po

SELECT @@TRANCOUNT  AS st_przed
BEGIN TRAN T1
BEGIN TRAN T1W
SELECT @@TRANCOUNT  AS st_przed
ROLLBACK TRAN T1W
SELECT @@TRANCOUNT  AS st_po


SELECT * FROM osoby WHERE id_osoby = 1
SELECT * FROM etaty WHERE id_osoby = 1


/*
** Staramy się unikać zagnieżdzania transakcji
** Jeżeli jest już jakaś otwarta to nie używamy nowej 
** a używamy SAVEPOINT - punkt w bieżącej transkcji do którego chemy wrócić
*/

SELECT @@TRANCOUNT  AS przed_tzew
BEGIN TRAN TZEW
SELECT @@TRANCOUNT  AS po_tzew
DELETE FROM ETATY WHERE id_osoby = 1

IF @@TRANCOUNT = 0
	BEGIN TRAN TWEW
ELSE
	SAVE TRAN TWEW 
SELECT @@TRANCOUNT  AS po_twew
DELETE FROM osoby WHERE id_osoby = 1
ROLLBACK TRAN TWEW

select * from osoby where id_osoby =1
select * from etaty where id_osoby =1
ROLLBACK TRAN TZEW

/* 
* Transakcje można zagnieżdzać ale nie ma to sensu
* 1) ROLLBACK odwołuje wszystkie
* 2) Jeżeli procedura rozpoczyna swoją transakcję i na wejsciu poziomTr jest inny jak na koniec
**** to poważny błąd
****

BEGIN TRAN T1 -- poziom 1
EXEC P1 -- ona tworzy swoją a ja się nie uda to rollback, poziom 2, po rollback 0
we - 1 wyj - 0 (nierówy poziom transakcji)

*/

/*
** Zmiana pensji MUSI powodować zacowanie starego rekordu w ETATY
** czyli zmiana to:
** a) dezaktualizacja starego rekordu - DO ma być GETDATE()
** b) stworzenie nowego bazującego na starym ale z nową pensją
*/
ALTER TABLE ETATY ADD z_et int NULL CONSTRAINT FK_et__et FOREIGN KEY REFERENCES ETATY(id_etatu)

EXEC TWORZ_PUSTA_PROC @nazwa = N'zm_pensji'
GO
ALTER PROCEDURE dbo.zm_pensji (@id_et int, @nowa_p money, @st nvarchar(20), @err int = 0 output)
AS
	IF NOT EXISTS ( SELECT 1 FROM etaty e where e.id_etatu = @id_et )
	BEGIN
		SET @err = -1
		RAISERROR(N'brak takiego rekordu w bazie id_etatu=%d', 16, 3, @id_et)
		RETURN
	END 
	
	IF EXISTS ( SELECT 1 FROM etaty e where e.id_etatu = @id_et AND e.do is not null )
	BEGIN
		SET @err = -1
		RAISERROR(N'Etat nieaktualny id_etatu=%d', 16, 3, @id_et)
		RETURN
	END

	IF EXISTS ( SELECT 1 FROM etaty e where e.id_etatu = @id_et AND e.pensja = @nowa_p  )
	BEGIN
		SET @err = -1
		RAISERROR(N'Zmiana na tę samą pensję id_etatu=%d', 16, 3, @id_et)
		RETURN
	END

	DECLARE @tr int
	SET @tr = @@TRANCOUNT

	IF @tr = 0 
		BEGIN TRAN TXX1
	ELSE
		SAVE TRAN TXX1

select @@TRANCOUNT AS po_tr

	UPDATE etaty SET do = GETDATE() WHERE id_etatu = @id_et
	SET @err = @@ERROR

	IF @err = 0
	BEGIN
		INSERT INTO etaty (id_osoby, id_firmy, stanowisko, pensja, od, z_et)
			SELECT e.id_osoby, e.id_firmy, @st , @nowa_p , GETDATE(), @id_et 
			FROM etaty e
			WHERE e.id_etatu = @id_et
		SET @err = @@ERROR
	END

	IF @err = 0
	BEGIN
		IF @tr = 0 -- utworzyismy wewwnątrz procedury tr 
		BEGIN
			COMMIT TRAN TXX1
		END
select @@TRANCOUNT AS koniec
		RETURN
	END

	ROLLBACK TRAN TXX1
GO

select * from etaty 


EXEC dbo.zm_pensji @id_et=1, @nowa_p = 3520, @st = N'nowe st'
/*
Msg 50000, Level 16, State 3, Procedure zm_pensji, Line 13
Etat nieaktualny id_etatu=1
*/

EXEC dbo.zm_pensji @id_et=3, @nowa_p = 3520, @st = N'nowe st'
/*
Msg 50000, Level 16, State 3, Procedure zm_pensji, Line 20
Zmiana na tę samą pensję id_etatu=3
*/

EXEC dbo.zm_pensji @id_et=3, @nowa_p = 4000, @st = N'nowe st'

select * from etaty


EXEC dbo.zm_pensji @id_et=4, @nowa_p = 4000, @st = N'nowe st'
/*
id_osoby	id_firmy	stanowisko	pensja	od	do	id_etatu	z_et

1	PW 	Sprzątacz	2420,00	1999-01-01 00:00:00.000	2022-05-09 16:12:16.773	4	NULL

1	PW 	nowe st	4000,00	2022-05-09 16:12:16.773	NULL	14	4
*/


BEGIN TRAN T1 -- 1
SELECT @@TRANCOUNT AS zew
EXEC dbo.zm_pensji @id_et=10, @nowa_p = 100000, @st = N'nowe st' -- procedura nie zmienia poz
COMMIT TRAN T1 -- 0 
SELECT @@TRANCOUNT AS po

/*
od wczoraj wszystie systemy muszą śledzić zmianę nazwiska
*/
CREATE TABLE dbo.zm_n (id_zm int not null IDENTITY CONSTRAINT PK_zm PRIMARY KEY
	, host_n nvarchar(40) NOT NULL DEFAULT HOST_NAME()
	, u_n nvarchar(40) NOT NULL DEFAULT USER_NAME()
	, dt datetime not null DEFAULT GETDATE()
	, opis nvarchar(100) NOT NULL
	)
-- drop table zm_d
CREATE TABLE dbo.zm_d (id_zmd int not null IDENTITY CONSTRAINT PK_zmd PRIMARY KEY
	, id_zm int NOT NULL CONSTRAINT FK_zmd_zmn FOREIGN KEY REFERENCES zm_n(id_zm)
	, z_nazwiska nvarchar(40) NOT NULL
	, na_nazwisko nvarchar(40) NOT NULL
	, id_osoby int not null
	)
GO

CREATE TRIGGER dbo.os_upd_naz ON OSOBY FOR UPDATE
AS
	IF UPDATE(nazwisko)
	AND EXISTS (SELECT 1 FROM inserted i join deleted d ON (d.id_osoby = i.id_osoby)
					WHERE NOT (d.nazwisko = i.nazwisko)
				)
	BEGIN
		DECLARE @id_z int
		INSERT INTO zm_n (opis) VALUES (N'trigger')
		SET @id_z = SCOPE_IDENTITY()

		INSERT INTO zm_d (id_zm, z_nazwiska, na_nazwisko, id_osoby )
			SELECT @id_z, d.nazwisko, i.nazwisko, i.id_osoby 
				FROM inserted i join deleted d ON (d.id_osoby = i.id_osoby)
				WHERE NOT (d.nazwisko = i.nazwisko)
	END
GO

update osoby set nazwisko = 'Stodolski1' where id_osoby = 1

select * from zm_n 
/*
id_zm	host_n	u_n	dt	opis
1	MS-SOFT-TOSH	dbo	2022-05-09 16:27:05.627	trigger
*/
select * from zm_d

/*
id_zmd	id_zm	z_nazwiska	na_nazwisko
1	1	Stodolski	Stodolski1
*/

UPDATE osoby set nazwisko = N'Smith'

select * from osoby

select * from zm_n 
/*
id_zm	host_n	u_n	dt	opis
1	MS-SOFT-TOSH	dbo	2022-05-09 16:27:05.627	trigger
2	MS-SOFT-TOSH	dbo	2022-05-09 16:28:21.703	trigger
4	MS-SOFT-TOSH	dbo	2022-05-09 16:34:59.437	trigger
*/
select * from zm_d
/*
id_zmd	id_zm	z_nazwiska	na_nazwisko	id_osoby
1	4	Niepracujący	Smith	5
2	4	Neptun	Smith	4
3	4	Nieznany	Smith	3
4	4	Korytkowski	Smith	2
5	4	Stodolski	Smith	1
*/
UPDATE osoby SET nazwisko = zm_d.z_nazwiska 
	FROM osoby join zm_d ON (osoby.id_osoby = zm_d.id_osoby AND id_zm = 4)

SELECT * FROM osoby
select * FROM zm_d


