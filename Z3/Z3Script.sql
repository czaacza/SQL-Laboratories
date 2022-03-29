/* Z3, Mateusz, Czarnecki, 2 319030

	Z3.1 - policzyæ liczbê osób w ka¿dym mieœcie (zapytanie z grupowaniem)
	Najlepiej wynik zapamiêtaæ w tabeli tymczasowej

*/

SELECT	COUNT(*) AS [liczba osob], 
		m.nazwa AS [nazwa miasta]
		INTO #TT
		FROM MIASTA m
		JOIN OSOBY o ON m.id_miasta = o.id_miasta
		GROUP BY m.nazwa
		
/* Tworzê zapytanie licz¹ce liczbê wystêpuj¹cych rekordów pogrupowanych wed³ug nazwy miasta, wynik wrzucam do tabeli tymczasowej #TT

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
	Z3.2 - korzystaj¹c z wyniku Z3,1 - pokazaæ, które miasto ma najwiêksz¹ liczbê mieszkañców
	(zapytanie z fa - analogiczne do zadañ z Z2)
*/

/* PIERWSZY SPOSÓB (U¯YWAJ¥C FA) */

SELECT MAX(t.[liczba osob]) AS [maksymalna liczba osob]
	INTO #M
	FROM #TT t

/*
	Tworzymy tabelê o postaci:

	maksymalna liczba osob
	----------------------
	3

	zawieraj¹c¹ wy³¹cznie najwiêksz¹ liczbê osób. Przechowujemy j¹ w postaci tabeli tymczasowej #M

*/

SELECT t.[nazwa miasta], t.[liczba osob]
		FROM #M m
		JOIN #TT t ON t.[liczba osob] = m.[maksymalna liczba osob]

/* 
	Tworzymy zapytanie ³¹cz¹ce tabelê z zadania 1 z tabel¹ przechowuj¹c¹ najwiêksz¹ liczbê mieszkañców. 
	Otrzymujemy tabelê przechowuj¹c¹ nazwê i liczbe osób w mieœcie z najwiêksz¹ liczb¹ mieszkañców

	nazwa miasta                                       liczba osob
	-------------------------------------------------- -----------
	Pruszkow                                           3
*/



/* DRUGI SPOSÓB (U¯YWAJ¥C CURSORA) */

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
	Deklarujê zmienne @mlo, @mla. Tworzê kursor CC, który wrzuci do zmiennych wartoœci maksymalnej liczby osob w danym miescie oraz nazwê miasta z najwiêksz¹ liczb¹ osób
	Dzieje siê tak ze wzglêdu na polecenie ORDER BY 1 DESC, które porz¹dkuje wyniki w tabeli tymczasowej malej¹co wed³ug liczby osób, zatem pierwszy rekord przedstawiaæ bêdzie miasto z najwiêksz¹ liczb¹ osób
	Nastêpnie u¿ywam polecenia SELECT aby pokazaæ zmienne, do których przekazane zosta³y wartoœci.
	Na samym koñcu zamykam i zwalniam pamiêæ po kursorze.

	Sposób ten bêdzie wadliwy dla dwóch rekordów o takiej samej, najwiêkszej liczbie mieszkañców miasta.


	maksymalna liczba osob nazwa miasta
	---------------------- --------------------
	3                      Pruszkow
*/



/*
	Z3.3 Pokazaæ liczbê firm w ka¿dym z województw (czyli grupowanie po kod_woj)
*/

SELECT	w.kod_woj, w.nazwa AS [nazwa wojewodztwa],
		COUNT(*) AS [liczba firm]
		FROM WOJ w
		JOIN MIASTA m ON w.kod_woj = m.kod_woj
		JOIN FIRMY f ON m.id_miasta = f.id_miasta
		GROUP BY w.kod_woj, w.nazwa

/*
	Tworzymy tabelê zawieraj¹c¹ informacjê o liczbie firm w danym województwie o postaci:

	kod_woj nazwa wojewodztwa                                  liczba firm
	------- -------------------------------------------------- -----------
	doln    Dolnoslaskie                                       3
	mazo    Mazowieckie                                        3
	wiel    Wielkopolskie                                      2

	Osi¹gamy to poprzez operator GROUP BY, który grupuje nam dane w tabelii wed³ug klucza g³ównego w.kod_woj oraz nazwy województwa
 */




/*
	Z3.4 Pokazaæ województwa w których nie ma ¿adnej firmy

	(suma z3.3 i z3.4 powinna daæ nam pe³n¹ listê województw - woj gdzie sa firmy i gdzie ich nie ma to razem powinny byc wszystkie
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
	Pos³uguj¹c siê operatorem NOT EXISTS, szukam kod_woj i nazw województw, dla których nie istniej¹ rekordy dla zapytania ³¹cz¹cego firmy z województwami. 
	W ten sposób otrzymujê listê województw, w których nie ma ¿adnej firmy

	kod_woj nazwa
	------- --------------------------------------------------
	malo    Malopolskie
	pomo    Pomorskie
	swie    Swietokrzyskie
*/