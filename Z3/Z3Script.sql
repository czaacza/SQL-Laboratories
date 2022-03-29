/* Z3, Mateusz, Czarnecki, 2 319030

	Z3.1 - policzy� liczb� os�b w ka�dym mie�cie (zapytanie z grupowaniem)
	Najlepiej wynik zapami�ta� w tabeli tymczasowej

*/

SELECT	COUNT(*) AS [liczba osob], 
		m.nazwa AS [nazwa miasta]
		INTO #TT
		FROM MIASTA m
		JOIN OSOBY o ON m.id_miasta = o.id_miasta
		GROUP BY m.nazwa
		
/* Tworz� zapytanie licz�ce liczb� wyst�puj�cych rekord�w pogrupowanych wed�ug nazwy miasta, wynik wrzucam do tabeli tymczasowej #TT

	liczba osob nazwa miasta
	----------- --------------------------------------------------
	1           Kalisz
	1           Konin
	1           Krakow
	1           Legnica
	2           Milanowek
	1           Poznan
	3           Pruszkow
	1           Walbrzych
	1           Warszawa
	1           Wieliczka
	1           Wroclaw

 */



/*
	Z3.2 - korzystaj�c z wyniku Z3,1 - pokaza�, kt�re miasto ma najwi�ksz� liczb� mieszka�c�w
	(zapytanie z fa - analogiczne do zada� z Z2)
*/

/* PIERWSZY SPOS�B (U�YWAJ�C FA) */

SELECT MAX(t.[liczba osob]) AS [maksymalna liczba osob]
	INTO #M
	FROM #TT t

/*
	Tworzymy tabel� o postaci:

	maksymalna liczba osob
	----------------------
	3

	zawieraj�c� wy��cznie najwi�ksz� liczb� os�b. Przechowujemy j� w postaci tabeli tymczasowej #M

*/

SELECT t.[nazwa miasta], t.[liczba osob]
		FROM #M m
		JOIN #TT t ON t.[liczba osob] = m.[maksymalna liczba osob]

/* 
	Tworzymy zapytanie ��cz�ce tabel� z zadania 1 z tabel� przechowuj�c� najwi�ksz� liczb� mieszka�c�w. 
	Otrzymujemy tabel� przechowuj�c� nazw� i liczbe os�b w mie�cie z najwi�ksz� liczb� mieszka�c�w

	nazwa miasta                                       liczba osob
	-------------------------------------------------- -----------
	Pruszkow                                           3
*/



/* DRUGI SPOS�B (U�YWAJ�C CURSORA) */

DECLARE @mlo int
DECLARE @mna varchar(20)

DECLARE CC INSENSITIVE CURSOR FOR
	SELECT t.[liczba osob], t.[nazwa miasta]
		FROM #TT t
		ORDER BY 1 DESC

OPEN CC
FETCH NEXT
FROM CC INTO @mlo, @mna



SELECT	@mlo AS [maksymalna liczba osob], 
		@mna AS [nazwa miasta]

CLOSE CC
DEALLOCATE CC

/*
	Deklaruj� zmienne @mlo, @mla. Tworz� kursor CC, kt�ry wrzuci do zmiennych warto�ci maksymalnej liczby osob w danym miescie oraz nazw� miasta z najwi�ksz� liczb� os�b
	Dzieje si� tak ze wzgl�du na polecenie ORDER BY 1 DESC, kt�re porz�dkuje wyniki w tabeli tymczasowej malej�co wed�ug liczby os�b, zatem pierwszy rekord przedstawia� b�dzie miasto z najwi�ksz� liczb� os�b
	Nast�pnie u�ywam polecenia SELECT aby pokaza� zmienne, do kt�rych przekazane zosta�y warto�ci.
	Na samym ko�cu zamykam i zwalniam pami�� po kursorze.

	Spos�b ten b�dzie wadliwy dla dw�ch rekord�w o takiej samej, najwi�kszej liczbie mieszka�c�w miasta.


	maksymalna liczba osob nazwa miasta
	---------------------- --------------------
	3                      Pruszkow
*/



/*
	Z3.3 Pokaza� liczb� firm w ka�dym z wojew�dztw (czyli grupowanie po kod_woj)
*/

SELECT	w.kod_woj, w.nazwa AS [nazwa wojewodztwa],
		COUNT(*) AS [liczba firm]
		FROM WOJ w
		JOIN MIASTA m ON w.kod_woj = m.kod_woj
		JOIN FIRMY f ON m.id_miasta = f.id_miasta
		GROUP BY w.kod_woj, w.nazwa

/*
	Tworzymy tabel� zawieraj�c� informacj� o liczbie firm w danym wojew�dztwie o postaci:

	kod_woj nazwa wojewodztwa                                  liczba firm
	------- -------------------------------------------------- -----------
	doln    Dolnoslaskie                                       3
	mazo    Mazowieckie                                        3
	wiel    Wielkopolskie                                      2

	Osi�gamy to poprzez operator GROUP BY, kt�ry grupuje nam dane w tabelii wed�ug klucza g��wnego w.kod_woj oraz nazwy wojew�dztwa
 */




/*
	Z3.4 Pokaza� wojew�dztwa w kt�rych nie ma �adnej firmy

	(suma z3.3 i z3.4 powinna da� nam pe�n� list� wojew�dztw - woj gdzie sa firmy i gdzie ich nie ma to razem powinny byc wszystkie
*/

SELECT w.kod_woj, w.nazwa
	FROM WOJ w
	WHERE NOT EXISTS(
		SELECT	1
		FROM FIRMY fW
		JOIN MIASTA mW ON mW.id_miasta = fW.id_miasta
		WHERE w.kod_woj = mW.kod_woj
		)

/*	
	Pos�uguj�c si� operatorem NOT EXISTS, szukam kod_woj i nazw wojew�dztw, dla kt�rych nie istniej� rekordy dla zapytania ��cz�cego firmy z wojew�dztwami. 
	W ten spos�b otrzymuj� list� wojew�dztw, w kt�rych nie ma �adnej firmy

	kod_woj nazwa
	------- --------------------------------------------------
	malo    Malopolskie
	pomo    Pomorskie
	swie    Swietokrzyskie
*/