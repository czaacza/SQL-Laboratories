/* Z2, Mateusz Czarnecki, 2, 319030 */




/* 1. Pokaza� dane podstawowe osoby, w jakim mie�cie mieszka i w jakim to jest wojew�dztwie */

SELECT o.imie, o.nazwisko, m.nazwa AS miasto, w.nazwa AS wojew�dztwo FROM OSOBY o 
	join MIASTA m ON (o.id_miasta = m.id_miasta)
	join WOJ w ON (m.kod_woj = w.kod_woj)

/* Wybieramy imie, nazwisko, nazw� miasta i nazw� wojew�dztwa. Do tabeli OSOBY do��czamy tabele MIASTA oraz WOJ z warunkiem, �e odpowiednie klucze g��wne i obce s� sobie r�wne */


/*
	imie                                               nazwisko                                           miasto                                             wojew�dztwo
	-------------------------------------------------- -------------------------------------------------- -------------------------------------------------- --------------------------------------------------
	Jan                                                Kowalski                                           Warszawa                                           Mazowieckie
	Adam                                               Nowak                                              Poznan                                             Wielkopolskie
	Ferdynand                                          Kiepski                                            Legnica                                            Dolnoslaskie
	Andrzej                                            Bebech                                             Walbrzych                                          Dolnoslaskie
	Krystian                                           Szampanski                                         Pruszkow                                           Mazowieckie
	Kinga                                              Lorneta                                            Krakow                                             Malopolskie
	Malicja                                            Kapuczynska                                        Warszawa                                           Mazowieckie
	Tomasz                                             Kafelek                                            Kalisz                                             Wielkopolskie
	Jan                                                Tangowski                                          Wroclaw                                            Dolnoslaskie
	Mateusz                                            Pagowski                                           Milanowek                                          Mazowieckie
	Marcin                                             Majkuta                                            Warszawa                                           Mazowieckie
	Lukasz                                             Stefanski                                          Konin                                              Wielkopolskie
	Robert                                             Pudzianowski                                       Wieliczka                                          Malopolskie
	Anna                                               Kafelek                                            Pruszkow                                           Mazowieckie
*/




/*
	2. Pokaza� wszystkie osoby o nazwisku na liter� M i ostatniej literze nazwiska i lub a
	(je�eli nie macie takowych to wybierzcie takie warunki - inn� liter� pocz�tkow� i inne 2 ko�cowe)
	kt�re maj� pensje pomi�dzy 3000 a 5000 (U mnie: mi�dzy 10 000, a  20 000)
	mieszkajace w innym mie�cie ni� znajduje si� firma, w kt�rej maj� etat
	(wystarcz� dane z tabel etaty, firmy, osoby , miasta)
*/

/* 
	Wybieramy imie, nazwisko, pensje, adres firmy oraz adres zamieszkania. Tabele OSOBY, ETATY, FIRMY i MIASTA ��czymy ze sob� za pomoc� kluczy g��wnych jak w poprzednim zadaniu. 
	Formu�ujemy warunki z polecenia pos�uguj�c si� operatorami LIKE AND i OR
*/

SELECT o.imie, o.nazwisko, e.pensja, mF.nazwa AS adres_firmy, mO.nazwa AS adres_zamieszkania FROM OSOBY o		
		join ETATY e ON (o.id_osoby = e.id_osoby)
		join FIRMY f ON (e.id_firmy = f.nazwa_skr)
		join MIASTA mO ON (mO.id_miasta = o.id_miasta) 
		join MIASTA mF ON (mF.id_miasta = f.id_miasta)
 WHERE (o.imie LIKE N'M%' 
		AND (o.nazwisko LIKE N'%i' OR o.nazwisko LIKE N'%a')
		AND (e.pensja >= 10000 AND e.pensja <= 20000)
		AND (mO.id_miasta != mF.id_miasta))


/*
	imie                                               nazwisko                                           pensja                adres_firmy                                        adres_zamieszkania
	-------------------------------------------------- -------------------------------------------------- --------------------- -------------------------------------------------- --------------------------------------------------
	Minga                                              Lorneta                                            11500,00              Milanowek                                          Krakow
	Malicja                                            Kapuczynska                                        15200,00              Pruszkow                                           Warszawa
	Marcin                                             Majkuta                                            12300,00              Milanowek                                          Wroclaw
*/




/*
	3. Pokaza� kto ma najd�u�sze nazwisko w bazie
	(najpierw szukamy MAX z LEN(nazwisko) a potem pokazujemy te osoby z tak� d�ugo�ci� nazwiska)
*/

SELECT MAX(LEN(o.nazwisko))	AS [max dlugosc]
	INTO #W
	FROM osoby o

/* Tworzymy tabel� tymczasow� przechowuj�c� maksymaln� dlugosc nazwiska */

SELECT o.id_osoby AS id_osoby, o.imie, o.nazwisko ,LEN(o.nazwisko) AS dlugosc
INTO #D
FROM OSOBY o

/* Tworzymy tabel� tymczasow� przechowuj�c� id_osoby, imie, nazwisko i dlugosc nazwiska */

SELECT d.imie, d.nazwisko, d.dlugosc 
	FROM #D d join #W w ON (w.[max dlugosc] = d.dlugosc)

/* Wybieramy te rekordy z tabeli tymczasowej, kt�rych d�ugo�� nazwiska r�wna si� maksymalnej d�ugo�ci */


/*
	imie                                               nazwisko                                           dlugosc
	-------------------------------------------------- -------------------------------------------------- -----------
	Robert                                             Pudzianowski                                       12
*/




/* 4. Policzy� liczb� os�b w mie�cie o nazwie (tu daj� Wam wyb�r - w kt�rym mie�cie macie najwi�cej) */

SELECT COUNT(DISTINCT o.id_osoby) AS [ile osob] 
	FROM OSOBY o join MIASTA m ON (m.id_miasta = o.id_miasta)
	WHERE m.nazwa= N'Milanowek'

/* Poleceniem COUNT szukam liczby wyst�pienia id_osob gdzie nazwa miasta = "Milanowek" */

/*
	ile osob
	-----------
	2
*/