--Задание 1
--1.Составьте запрос, который выведет имя вида с наименьшим id. Результат будет соответствовать букве «М».
--1 вариант
Select species_id, species_name
FROM species
ORDER BY species_id
LIMIT 1;
--2 вариант
SELECT species_id, species_name
FROM species
WHERE species_id=(
SELECT MIN(species_id)
FROM species);

--2.Составьте запрос, который выведет имя вида с количеством представителей более 1800. Результат будет соответствовать букве «Б».
SELECT species_name
FROM species
WHERE species_amount>1800;

/*3.Составьте запрос, который выведет имя вида, начинающегося на «п» и относящегося к типу с type_id = 5. 
Результат будет соответствовать букве «О».*/
SELECT species_name
FROM species
WHERE species_name LIKE 'п%' AND type_id=5;

/*4.Составьте запрос, который выведет имя вида, заканчивающегося на «са» или количество представителей которого равно 5. 
Результат будет соответствовать букве В.*/
SELECT species_name
FROM species
WHERE species_name LIKE '%са'
   OR species_amount=5;
   
   
   
--Задание 2
--1.Составьте запрос, который выведет имя вида, появившегося на учете в 2023 году. Результат будет соответствовать букве «Ы».
--1 вариант
SELECT species_name
FROM species
WHERE to_char(date_start, 'YYYY')='2023';

--2 вариант
SELECT species_name, date_start
FROM species
WHERE to_char(date_start, 'YYYY')='2023';


/*2.Составьте запрос, который выведет названия отсутствующего (status = absent) вида, расположенного вместе с place_id = 3. 
Результат будет соответствовать букве «С».*/
--1 вариант
SELECT s.species_name
FROM species AS s
INNER JOIN species_in_places AS sp
ON s.species_id=sp.species_id
WHERE s.species_status='absent' AND sp.place_id=3;

--2 вариант
SELECT s.species_name,
       s.species_status,
	   sp.place_id
FROM species AS s
INNER JOIN species_in_places AS sp
ON s.species_id=sp.species_id
WHERE s.species_status='absent' AND sp.place_id=3;


/*3.Составьте запрос, который выведет название вида, расположенного в доме и появившегося в мае, а также и 
количество представителей вида. Название вида будет соответствовать букве «П».*/
--1 вариант
SELECT s.species_name,
       s.species_amount
FROM species AS s 
JOIN species_in_places AS sp ON s.species_id=sp.species_id
JOIN places AS p ON sp.place_id=p.place_id
WHERE p.place_name='дом' AND to_char (date_start, 'MM')='05';

--2 вариант
SELECT s.species_name,
       p.place_name,
	   s.date_start,
	   s.species_amount
FROM species AS s 
JOIN species_in_places AS sp ON s.species_id=sp.species_id
JOIN places AS p ON sp.place_id=p.place_id
WHERE p.place_name='дом' AND to_char (date_start, 'MM')='05';


/*4.Составьте запрос, который выведет название вида, состоящего из двух слов (содержит пробел). Результат будет 
соответствовать знаку !.*/
SELECT species_name
FROM species
WHERE species_name LIKE '% %';



--Задание 3
--1.Составьте запрос, который выведет имя вида, появившегося с малышом в один день. Результат будет соответствовать букве «Ч».
--1 вариант
SELECT species_name
FROM species
WHERE date_start=(
SELECT date_start
FROM species
WHERE species_name='малыш')
AND species_name NOT LIKE 'малыш';

--2 вариант
SELECT species_name
FROM species
WHERE date_start=(
SELECT date_start
FROM species
WHERE species_name='малыш')
AND species_name!='малыш';

/*2.Составьте запрос, который выведет название вида, расположенного в здании с наибольшей площадью. 
Результат будет соответствовать букве «Ж».*/
SELECT s.species_name,
       p.place_size
FROM species AS s
JOIN species_in_places AS sp ON s.species_id=sp.species_id
JOIN places AS p ON sp.place_id=p.place_id
WHERE place_name IN ('дом', 'сарай')
ORDER BY p.place_size DESC
LIMIT 1;


/*3.Составьте запрос/запросы, которые найдут название вида, относящегося к 5-й по численности группе проживающего дома. 
Результат будет соответствовать букве «Ш».*/
SELECT t.species_name
FROM (
SELECT s.species_name,
       s.species_amount,
	   p.place_name
FROM species AS s
JOIN species_in_places AS sp ON s.species_id=sp.species_id
JOIN places AS p ON sp.place_id=p.place_id
WHERE place_name='дом'
ORDER BY s.species_amount DESC
LIMIT 5) AS t
ORDER BY t.species_amount
LIMIT 1;

/*4.Составьте запрос, который выведет сказочный вид (статус fairy), не расположенный ни в одном месте. 
Результат будет соответствовать букве «Т».*/
--1 вариант
SELECT s.species_name,
       p.place_name
FROM species AS s
FULL OUTER JOIN species_in_places AS sp ON s.species_id=sp.species_id
FULL OUTER JOIN places AS p ON sp.place_id=p.place_id
WHERE p.place_name IS NULL;

--2 вариант(показался слишком простым, использовал те данные, что были даны в условии)
SELECT species_name
FROM species
WHERE species_status='fairy'

/*Шифровка
  А-             В-Лиса      С- Яблоко     Ь-Клубника
  !-Голубая рыба И-          О-Подсолнух   П-Собака
  Ж-Лошадь       М-Малыш     Т-Единорог
  Ц- Жук         Ы-Обезьяна  Я-Смайлик
  Ш-Попугай      Е/Ё-Скунс   Ч-Кошка
  Б-Роза   ?-    К-

/* Расшифровка послания
   T Ы
   В С Ё
   М О Ж Е Ш Ь !
*/