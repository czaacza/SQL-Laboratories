/* Z6 Mateusz, Czarnecki, 2, 319030
**
** Z1: Napisa� trigger, kt�ry b�dzie usuwa� spacje z pola nazwisko
** Trigger na INSERT, UPDATE
**
*/

GO
CREATE TRIGGER dbo.tr_nazwisko ON OSOBY FOR INSERT, UPDATE
AS
	IF UPDATE(nazwisko)
	AND EXISTS (
					SELECT * FROM inserted i 
					WHERE i.nazwisko LIKE  N'% %'
				)
		UPDATE OSOBY SET nazwisko = REPLACE(nazwisko, N' ', N'-')
		WHERE nazwisko IN 
		(
			SELECT o.nazwisko
			FROM OSOBY o
			WHERE o.nazwisko LIKE N'% %'
		)
GO
DROP TRIGGER tr_nazwisko
/*
	Command(s) completed successfully.

	Tworz� TRIGGER dzia�aj�cy pod warunkiem wstawienia nowego lub edytowania nazwiska i dla nazwisk, kt�re posiadaj� spacj�. 
	Edytuje wykryte rekordy pod warunkiem, �e posiadaj� spacj�.
*/

UPDATE OSOBY SET OSOBY.nazwisko = N'Nowak Salamon'
		WHERE OSOBY.id_osoby = 2

UPDATE OSOBY SET OSOBY.nazwisko = 'Barbik W�sacz'
		WHERE OSOBY.id_osoby = 3

/*
	Przy edytowaniu rekordu, osoby, kt�rym pr�bujemy wstawi� nazwisko ze spacj�, spacja zostanie zamieniona na "-".

	id_osoby    id_miasta   imie                                               nazwisko
	----------- ----------- -------------------------------------------------- --------------------------------------------------
	2           4           Adam                                               Nowak-Salomon
	3           7           Ferdynand                                          Barbik-W�sacz

*/



/*
** Z2: Napisa� procedur� szukaj�c� os�b z paramertrami
** @imie_wzor nvarchar(20) = NULL
** @nazwisko_wzor nvarchar(20) = NULL
** @pokaz_zarobki bit = 0
** Procedura ma mie� zmienn� @sql nvarchar(1000), kt�r� buduje dynamicznie
** @pokaz_zarobki = 0 => (imie, nazwisko, id_osoby, nazwa_miasta)
** @pokaz_zarobki = 1 => (imie, nazwisko, id_osoby, suma_z_akt_etatow)
** Mozliwe wywo�ania: EXEC sz_o @nazwisko_wzor = N'Stodolsk%'
** powinno zbudowa� zmienn� tekstow�
** @sql = N'SELECT o.*, m.nazwa AS nazwa_miasta FROM osoby o join miasta m "
** + N' ON (m.id_miasta=o.id_miasta) WHERE o.nazwisko LIKE NStodolsk% '
** uruchomienie zapytania to EXEC sp_sqlExec @sql
** rekomenduj� aby najpierw procedura zwraca�a zapytanie SELECT @sql
** a dopiero jak b�d� poprawne uruachamia�a je
*/

GO
ALTER PROCEDURE dbo.sz_o (@imie_wzor nvarchar(20) = NULL, @nazwisko_wzor nvarchar(20) = NULL, @pokaz_zarobki bit = 0, @sql nvarchar(1000) output)
AS
	IF @pokaz_zarobki = 0
	BEGIN
		IF @imie_wzor IS NOT NULL AND @nazwisko_wzor IS NOT NULL
			BEGIN
				SET @sql =	N'SELECT o.*, m.nazwa AS nazwa_miasta ' + 
							N'FROM osoby o join miasta m ' + 
							N'ON (m.id_miasta=o.id_miasta) ' + 
							N'WHERE o.imie LIKE ''' + @imie_wzor + N''' AND o.nazwisko LIKE ''' +  @nazwisko_wzor + ''''
			END

		ELSE IF @imie_wzor IS NOT NULL AND @nazwisko_wzor IS NULL
			BEGIN
			SET @sql =	N'SELECT o.*, m.nazwa AS nazwa_miasta ' + 
							N'FROM osoby o join miasta m ' + 
							N'ON (m.id_miasta=o.id_miasta) ' + 
							N'WHERE o.imie LIKE ''' + @imie_wzor + N'''' 
			END

		ELSE IF @imie_wzor IS NULL AND @nazwisko_wzor IS NOT NULL
		BEGIN
		SET @sql =	N'SELECT o.*, m.nazwa AS nazwa_miasta ' + 
							N'FROM osoby o join miasta m ' + 
							N'ON (m.id_miasta=o.id_miasta) ' + 
							N'WHERE o.nazwisko LIKE ''' + @nazwisko_wzor + N'''' 
			END

	END
	ELSE IF @pokaz_zarobki = 1
	BEGIN
		IF @imie_wzor IS NOT NULL AND @nazwisko_wzor IS NOT NULL
			BEGIN
				SET @sql =	N'SELECT o.id_osoby, o.imie, o.nazwisko, SUM(e.pensja) AS [suma pensji] ' +
								N'FROM OSOBY o ' +
								N'JOIN ETATY e ON e.id_osoby = o.id_osoby ' +
								N'WHERE o.imie = ''' + @imie_wzor + N''' AND o.nazwisko = ''' + @nazwisko_wzor +
								N''' GROUP BY o.id_osoby, o.imie, o.nazwisko'		
			END

		ELSE IF @imie_wzor IS NOT NULL AND @nazwisko_wzor IS NULL
			BEGIN
				SET @sql =	N'SELECT o.id_osoby, o.imie, o.nazwisko, SUM(e.pensja) AS [suma pensji] ' +
								N'FROM OSOBY o ' +
								N'JOIN ETATY e ON e.id_osoby = o.id_osoby ' +
								N'WHERE o.imie = ''' + @imie_wzor +
								N''' GROUP BY o.id_osoby, o.imie, o.nazwisko'	
			END

		IF @imie_wzor IS NULL AND @nazwisko_wzor IS NOT NULL
			BEGIN
				SET @sql =	N'SELECT o.id_osoby, o.imie, o.nazwisko, SUM(e.pensja) AS [suma pensji] ' +
								N'FROM OSOBY o ' +
								N'JOIN ETATY e ON e.id_osoby = o.id_osoby ' +
								N'WHERE o.nazwisko = ''' + @nazwisko_wzor +
								N''' GROUP BY o.id_osoby, o.imie, o.nazwisko'	
			END
	END

GO

DECLARE @sql_loc nvarchar(1000)
EXEC sz_o @pokaz_zarobki = 1, @nazwisko_wzor = 'Kafelek', @sql = @sql_loc output
SELECT @sql_loc AS zapytanie
EXEC sp_sqlExec @sql_loc

/*
	Napisana przeze mnie procedura posiada wymagane w poleceniu argumenty a tak�e argument wyj�ciowy @sql, kt�remu przypisane zostan� odpowiednie zapytania SQL.
	Procedura posiada instrukcj� warunkow� sprawdzaj�c�, czy u�ytkownik poda� argument @pokaz_zarobki z warto�ci� 1.
	Je�eli tak, procedura wypisze polecenie nie uwzgl�dniaj�ce sumy zarobk�w os�b, w przeciwnym wypadku polecenie wyj�ciowe uwzgl�dnia sum� zarobk�w.
	Po okre�leniu warto�ci argumentu @pokaz_zarobki, funkcja sprawdza, czy podano same imie, nazwisko, czy obie warto�ci.
	Je�eli dana warto�� nie jest podana (r�wna si� warto�ci domy�lnej NULL), to procedura zwr�ci zapytanie nie uwzgl�dniaj�ce tego argumentu.\
	Procedura zatem pozwala nam szuka� po imieniu, nazwisku lub kombinacji imienia i nazwiska.
	
	-----------------------------------------------
	Po wywo�aniu procedury w nast�puj�cy spos�b:

	DECLARE @sql_loc nvarchar(1000)
	EXEC sz_o @nazwisko_wzor = N'Stodolsk%', @sql = @sql_loc output


	Otrzymamy nast�puj�ce zapytanie przekazane do zmiennej @sql_loc:

	SELECT o.*, m.nazwa AS nazwa_miasta FROM osoby o join miasta m ON (m.id_miasta=o.id_miasta) WHERE o.nazwisko LIKE 'Stodolsk%'


	-----------------------------------------------
	Inne przyk�adowe wywo�ania i wyniki zwr�conych zapyta� (wszystkie mo�liwo�ci):
	
	
	EXEC sz_o @pokaz_zarobki = 0, @imie_wzor = 'Man', @nazwisko_wzor = 'Kowalski', @sql = @sql_loc output

	id_osoby    id_miasta   imie                                               nazwisko                                           nazwa_miasta
	----------- ----------- -------------------------------------------------- -------------------------------------------------- --------------------------------------------------
	1           1           Man                                                Kowalski                                           Warszawa


	EXEC sz_o @pokaz_zarobki = 0, @imie_wzor = 'Mateusz', @sql = @sql_loc output
	Wynik:
	SELECT o.*, m.nazwa AS nazwa_miasta FROM osoby o join miasta m ON (m.id_miasta=o.id_miasta) WHERE o.imie LIKE 'Mateusz'

	id_osoby    id_miasta   imie                                               nazwisko                                           nazwa_miasta
	----------- ----------- -------------------------------------------------- -------------------------------------------------- --------------------------------------------------
	10          5           Mateusz                                            Pagowski                                           Milanowek


	EXEC sz_o @pokaz_zarobki = 0, @nazwisko_wzor = 'Pudzianowski', @sql = @sql_loc output

	Wynik:
	id_osoby    id_miasta   imie                                               nazwisko                                           nazwa_miasta
	----------- ----------- -------------------------------------------------- -------------------------------------------------- --------------------------------------------------
	13          12          Robert                                             Pudzianowski                                       Wieliczka



	EXEC sz_o @pokaz_zarobki = 1, @imie_wzor = 'Jan', @nazwisko_wzor = 'Tangowski', @sql = @sql_loc output

	id_osoby    imie                                               nazwisko                                           suma pensji
	----------- -------------------------------------------------- -------------------------------------------------- ---------------------
	9           Jan                                                Tangowski                                          13100,00


	EXEC sz_o @pokaz_zarobki = 1, @imie_wzor = 'Adam', @sql = @sql_loc output

	id_osoby    imie                                               nazwisko                                           suma pensji
	----------- -------------------------------------------------- -------------------------------------------------- ---------------------
	2           Adam                                               Nowak-Salomon                                      16800,00


	EXEC sz_o @pokaz_zarobki = 1, @nazwisko_wzor = 'Kafelek', @sql = @sql_loc output

	id_osoby    imie                                               nazwisko                                           suma pensji
	----------- -------------------------------------------------- -------------------------------------------------- ---------------------
	8           Tomasz                                             Kafelek                                            18700,00
	14          Anna                                               Kafelek                                            38000,00


*/

