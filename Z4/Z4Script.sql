/*
Z4 Mateusz, Czarnecki 319030, 2

	Z4.1 - pokazaæ osoby z województwa o kodzie X, które nigdy
	nie pracowa³y / nie pracuja tez obecnie w firmie z woj o tym samym kodzie
	(lub innym - jakie dane lepsze)
*/


SELECT o.id_osoby, LEFT(o.imie, 20) AS [imie], LEFT(o.nazwisko, 20) AS [nazwisko]
		FROM OSOBY o
		JOIN MIASTA m ON m.id_miasta = o.id_miasta
		JOIN WOJ w ON w.kod_woj = m.kod_woj 

		WHERE NOT EXISTS
		( SELECT oW.*, wW.kod_woj AS [kod_woj firmy]
			FROM WOJ wW 
			JOIN MIASTA mW ON mW.kod_woj = wW.kod_woj
			JOIN FIRMY fW ON fW.id_miasta = mW.id_miasta
			JOIN ETATY eW ON eW.id_firmy = fW.nazwa_skr
			JOIN OSOBY oW ON oW.id_osoby = eW.id_osoby
			WHERE o.id_osoby = oW.id_osoby AND w.kod_woj = wW.kod_woj
		 )
/* 
	Tworze zapytanie szukaj¹ce id_osoby, imienia i nazwiska osób mieszkaj¹cych w pewnym województwie.
	W zapytaniu wewn¹trz NOT EXISTS szukam danych osób spe³niaj¹cych warunek, ¿e kod_woj osoby = kod_woj firmy, w której osoba pracuje/pracowa³a.
	Poleceniem WHERE NOT EXISTS, sprawiam, ¿e wyœwietl¹ siê tylko rekordy, które NIE SPE£NIAJ¥ zapytania wewnêtrznego, zatem osoby, których kod_woj zamieszkania jest RÓ¯NY od kod_woj firmy.


	id_osoby    imie                 nazwisko
	----------- -------------------- --------------------
	2           Adam                 Nowak
	4           Mandrzej             Bebech
	6           Minga                Lorneta
	8           Tomasz               Kafelek
	9           Jan                  Tangowski
	10          Mateusz              Pagowski
	12          Lukasz               Stefanski
	13          Robert               Pudzianowski

	(8 row(s) affected)
*/


/*
	Z4.2 - pokazaæ liczbê mieszkañców w województwach
	ale tylko w tych maj¹cych wiecej jak jednego (DWÓCH) mieszkañca
*/


SELECT w.kod_woj, tt.nazwa, tt.[liczba mieszkancow]
	FROM WOJ w
	JOIN (SELECT w.kod_woj, LEFT(w.nazwa, 20) AS [nazwa], COUNT(*) AS [liczba mieszkancow]
			FROM WOJ w
			JOIN MIASTA m ON m.kod_woj = w.kod_woj
			JOIN OSOBY o ON o.id_miasta = m.id_miasta
			GROUP BY w.kod_woj, w.nazwa) tt ON tt.kod_woj = w.kod_woj
	WHERE tt.[liczba mieszkancow] > 2

/*
	Zamiast waurnku liczby mieszkañców wiêkszej od 1, chcê aby pokazano mi dane dla liczby mieszkañców wiêkszej od 2, gdy¿ taki warunek umo¿liwi³ mi odró¿nienie od bezwarunkowego zapytania. 
	(wszystkie miasta w tabeli mia³y wiêcej ni¿ 1 mieszkañca, a nie wszystkie wiêcej ni¿ 2)

	Tworzê zapytanie szukaj¹ce kod_woj, nazwy oraz iloœci wyœwietlanych rekordów osób.
	Tworzê zapytanie wewnêtrzne szukaj¹ce kod_woj, nazwê i liczbê mieszkañców, pogrupowane po kod_woj i nazwie.
	Dajê warunek, w którym liczba mieszkañców z tabeli wewnêtrznej ma byæ wiêksza od 2.

	kod_woj nazwa                liczba mieszkancow
	------- -------------------- ------------------
	doln    Dolnoslaskie         3
	mazo    Mazowieckie          6
	wiel    Wielkopolskie        3

	(3 rows affected)
*/


/*
	Z4.3 - pokazaæ sredni¹ pensjê w miastach
	ale tylko tych posiadaj¹cych wiêcej jak jednego mieszkañca
*/


SELECT  m.id_miasta, m.nazwa AS [nazwa miasta], AVG(e.pensja) AS [srednia pensja]
		FROM MIASTA m
		JOIN OSOBY o ON o.id_miasta = m.id_miasta
		JOIN ETATY e ON e.id_osoby = o.id_osoby
		JOIN (SELECT m.id_miasta, COUNT(*) AS [liczba mieszkancow]
				FROM MIASTA m
				JOIN OSOBY o ON o.id_miasta = m.id_miasta
				GROUP BY m.id_miasta, m.nazwa) tt ON tt.id_miasta = m.id_miasta
		WHERE tt.[liczba mieszkancow] > 1
		GROUP BY m.id_miasta, m.nazwa

/*
	Tworzê zapytanie wewnêtrzne pokazuj¹ce id_miasta i liczbê mieszkañców w danym mieœcie. U¿ywam do tego operatora COUNT(*) oraz grupuje rekordy po id_miasta.
	W zapytaniu zewnêtrznym szukam id_miasta, nazwy miasta i œredniej pensji w miastach. Dziêki do³¹czeniu tabeli zawieraj¹cej liczbê mieszkañców, mogê daæ warunek mówi¹cy, ¿e ma byæ ona wiêksza od 1.


	id_miasta   nazwa miasta                                       srednia pensja
	----------- -------------------------------------------------- ---------------------
	2           Pruszkow                                           14040,00
	5           Milanowek                                          9600,00

	(2 rows affected)

*/