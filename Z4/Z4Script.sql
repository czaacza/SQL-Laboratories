/*
Z4 Mateusz, Czarnecki 319030, 2

	Z4.1 - pokaza� osoby z wojew�dztwa o kodzie X, kt�re nigdy
	nie pracowa�y / nie pracuja tez obecnie w firmie z woj o tym samym kodzie
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
	Tworze zapytanie szukaj�ce id_osoby, imienia i nazwiska os�b mieszkaj�cych w pewnym wojew�dztwie.
	W zapytaniu wewn�trz NOT EXISTS szukam danych os�b spe�niaj�cych warunek, �e kod_woj osoby = kod_woj firmy, w kt�rej osoba pracuje/pracowa�a.
	Poleceniem WHERE NOT EXISTS, sprawiam, �e wy�wietl� si� tylko rekordy, kt�re NIE SPE�NIAJ� zapytania wewn�trznego, zatem osoby, kt�rych kod_woj zamieszkania jest RӯNY od kod_woj firmy.


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
	Z4.2 - pokaza� liczb� mieszka�c�w w wojew�dztwach
	ale tylko w tych maj�cych wiecej jak jednego (DW�CH) mieszka�ca
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
	Zamiast waurnku liczby mieszka�c�w wi�kszej od 1, chc� aby pokazano mi dane dla liczby mieszka�c�w wi�kszej od 2, gdy� taki warunek umo�liwi� mi odr�nienie od bezwarunkowego zapytania. 
	(wszystkie miasta w tabeli mia�y wi�cej ni� 1 mieszka�ca, a nie wszystkie wi�cej ni� 2)

	Tworz� zapytanie szukaj�ce kod_woj, nazwy oraz ilo�ci wy�wietlanych rekord�w os�b.
	Tworz� zapytanie wewn�trzne szukaj�ce kod_woj, nazw� i liczb� mieszka�c�w, pogrupowane po kod_woj i nazwie.
	Daj� warunek, w kt�rym liczba mieszka�c�w z tabeli wewn�trznej ma by� wi�ksza od 2.

	kod_woj nazwa                liczba mieszkancow
	------- -------------------- ------------------
	doln    Dolnoslaskie         3
	mazo    Mazowieckie          6
	wiel    Wielkopolskie        3

	(3 rows affected)
*/


/*
	Z4.3 - pokaza� sredni� pensj� w miastach
	ale tylko tych posiadaj�cych wi�cej jak jednego mieszka�ca
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
	Tworz� zapytanie wewn�trzne pokazuj�ce id_miasta i liczb� mieszka�c�w w danym mie�cie. U�ywam do tego operatora COUNT(*) oraz grupuje rekordy po id_miasta.
	W zapytaniu zewn�trznym szukam id_miasta, nazwy miasta i �redniej pensji w miastach. Dzi�ki do��czeniu tabeli zawieraj�cej liczb� mieszka�c�w, mog� da� warunek m�wi�cy, �e ma by� ona wi�ksza od 1.


	id_miasta   nazwa miasta                                       srednia pensja
	----------- -------------------------------------------------- ---------------------
	2           Pruszkow                                           14040,00
	5           Milanowek                                          9600,00

	(2 rows affected)

*/