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