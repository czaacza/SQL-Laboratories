/*
	Z5 Mateusz Czarnecki, 319030, 2 
*/

/*
	Z5.1 - Pokaza� firmy wraz ze �redni� aktualna pensj� w nich
	U�ywaj�c UNION, rozwa�y� opcj� ALL
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
	Tworz� zapytanie szukaj�ce id firmy, nazw� firmy i �redni� pensj� w ka�dej firmie grupuj�c po id_firmy i nazwie. 
	Zapytanie to wy�wietli wszystkie firmy, dla kt�rych istniej� etaty i kt�re posiadaj� pewn� �redni� pensj�.

	Tworz� drugie zapytanie szukaj�ce id firmy, nazw� firmy i NULL dla sredniej pensji, dla kt�rych nie istniej� �adne etaty.

	Za pomoc� operatora UNION ��cz� ze sob� oba zapytania, tak aby wy�wietli� wszystkie rekordy z dw�ch tabel.
	Do operatora UNION dodaje ALL, gdy� wiem, �e oba zapytania s� roz��czne - w 1 pokazujemy firmy, dla kt�rych istniej� etaty, a w 2 firmy, dla kt�rych nie istniej� etaty.

	
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
	Tworz� wy��cznie jedno zapytanie pokazuj�ce id firmy, nazw� firmy i sredni� pensj�.
	Polecenie LEFT OUTER JOIN ��czy z etatami r�wnie� takie firmy, dla kt�rych nie istniej� �adne etaty.
	Sredniej pensji w firmach, dla kt�rych nie istniej� etaty, przypisana zostaje warto�� NULL.

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
	Z5.3 Napisa� procedur� pokazuj�c� �redni� pensj� w firmach z miasta - parametr procedure @id_miasta
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
	Tworz� procedure pobieraj�c� argument @id_miasta typu int
	Tworz� zapytanie wyszukuj�ce id miasta, nazw� miasta i �redni� pensj� pogrupowan� wed�ug id miasta i nazwy miasta.
	Do zapytania dodaje warunek twierdz�cy, �e id_miasta rekordu ma by� r�wne @id_miasta (przekazanemu argumentowi)

	Command(s) completed successfully.
*/

EXEC P1 2

/*
	Wywo�uj� procedur� dla przyk�adowego @id_miasta = 2.
	Procedura pokazuje �redni� pensj� dla podanego miasta - Pruszkowa.

	id_miasta   nazwa                                              srednia pensja
	----------- -------------------------------------------------- ---------------------
	2           Pruszkow                                           15350,00

	(1 row(s) affected)
*/