/* Z2, Mateusz Czarnecki, 2, 319030 */




/* 1. Pokazaæ dane podstawowe osoby, w jakim mieœcie mieszka i w jakim to jest województwie */

SELECT o.imie, o.nazwisko, m.nazwa AS miasto, w.nazwa AS województwo FROM OSOBY o 
	join MIASTA m ON (o.id_miasta = m.id_miasta)
	join WOJ w ON (m.kod_woj = w.kod_woj)

/* Wybieramy imie, nazwisko, nazwê miasta i nazwê województwa. Do tabeli OSOBY do³¹czamy tabele MIASTA oraz WOJ z warunkiem, ¿e odpowiednie klucze g³ówne i obce s¹ sobie równe */


/*
	imie                                               nazwisko                                           miasto                                             województwo
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
	2. Pokazaæ wszystkie osoby o nazwisku na literê M i ostatniej literze nazwiska i lub a
	(je¿eli nie macie takowych to wybierzcie takie warunki - inn¹ literê pocz¹tkow¹ i inne 2 koñcowe)
	które maj¹ pensje pomiêdzy 3000 a 5000 (U mnie: miêdzy 10 000, a  20 000)
	mieszkajace w innym mieœcie ni¿ znajduje siê firma, w której maj¹ etat
	(wystarcz¹ dane z tabel etaty, firmy, osoby , miasta)
*/

/* 
	Wybieramy imie, nazwisko, pensje, adres firmy oraz adres zamieszkania. Tabele OSOBY, ETATY, FIRMY i MIASTA ³¹czymy ze sob¹ za pomoc¹ kluczy g³ównych jak w poprzednim zadaniu. 
	Formu³ujemy warunki z polecenia pos³uguj¹c siê operatorami LIKE AND i OR
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
	3. Pokazaæ kto ma najd³u¿sze nazwisko w bazie
	(najpierw szukamy MAX z LEN(nazwisko) a potem pokazujemy te osoby z tak¹ d³ugoœci¹ nazwiska)
*/

SELECT MAX(LEN(o.nazwisko))	AS [max dlugosc]
	INTO #W
	FROM osoby o

/* Tworzymy tabelê tymczasow¹ przechowuj¹c¹ maksymaln¹ dlugosc nazwiska */

SELECT o.id_osoby AS id_osoby, o.imie, o.nazwisko ,LEN(o.nazwisko) AS dlugosc
INTO #D
FROM OSOBY o

/* Tworzymy tabelê tymczasow¹ przechowuj¹c¹ id_osoby, imie, nazwisko i dlugosc nazwiska */

SELECT d.imie, d.nazwisko, d.dlugosc 
	FROM #D d join #W w ON (w.[max dlugosc] = d.dlugosc)

/* Wybieramy te rekordy z tabeli tymczasowej, których d³ugoœæ nazwiska równa siê maksymalnej d³ugoœci */


/*
	imie                                               nazwisko                                           dlugosc
	-------------------------------------------------- -------------------------------------------------- -----------
	Robert                                             Pudzianowski                                       12
*/




/* 4. Policzyæ liczbê osób w mieœcie o nazwie (tu dajê Wam wybór - w którym mieœcie macie najwiêcej) */

SELECT COUNT(DISTINCT o.id_osoby) AS [ile osob] 
	FROM OSOBY o join MIASTA m ON (m.id_miasta = o.id_miasta)
	WHERE m.nazwa= N'Milanowek'

/* Poleceniem COUNT szukam liczby wyst¹pienia id_osob gdzie nazwa miasta = "Milanowek" */

/*
	ile osob
	-----------
	2
*/