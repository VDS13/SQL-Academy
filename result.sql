### 1 ###
###Вывести имена всех когда-либо обслуживаемых пассажиров авиакомпаний.###
SELECT name FROM Passenger

### 2 ###
###Вывести названия всеx авиакомпаний.###
SELECT name FROM Company

### 3 ###
###Вывести все рейсы, совершенные из Москвы.###
SELECT * FROM Trip
    WHERE town_from LIKE 'Moscow'

### 4 ###
###Вывести имена людей, которые заканчиваются на "man".###
SELECT name FROM Passenger
    WHERE name LIKE '%man'

### 5 ###
###Вывести количество рейсов, совершенных на TU-134.###
SELECT COUNT(*) AS count FROM Trip
    WHERE plane LIKE 'TU-154'

### 6 ###
###Какие компании совершали перелеты на Boeing.###
SELECT DISTINCT c.name FROM Company c
    JOIN Trip t ON t.company = c.id
    WHERE t.plane LIKE 'Boeing'

### 7 ###
###Вывести все названия самолётов, на которых можно улететь в Москву (Moscow).###
SELECT DISTINCT plane FROM Trip
    WHERE town_to LIKE 'Moscow'

### 8 ###
###В какие города можно улететь из Парижа (Paris) и сколько времени это займёт?###
SELECT town_to, TIMEDIFF(time_in, time_out) AS flight_time FROM Trip
    WHERE town_from LIKE 'Paris'

### 9 ###
###Какие компании организуют перелеты с Владивостока (Vladivostok)?###
SELECT DISTINCT c.name FROM Company c
    JOIN Trip t ON t.company = c.id
    WHERE t.town_from LIKE 'Vladivostok'

### 10 ###
###Вывести вылеты, совершенные с 10 ч. по 14 ч. 1 января 1900 г.###
SELECT * FROM Trip
    WHERE time_out BETWEEN '1900-01-01T10:00:00.000Z' AND '1900-01-01T14:00:00.000Z'

### 11 ###
###Вывести пассажиров с самым длинным именем.###
SELECT name FROM (
    SELECT name, LENGTH(name) AS col FROM Passenger ORDER BY col DESC LIMIT 1
) tmp

### 12 ###
###Вывести id и количество пассажиров для всех прошедших полётов.###
SELECT t.id AS trip, COUNT(p.id) AS count FROM Trip t 
    LEFT JOIN Pass_in_trip p ON p.trip = t.id
    GROUP BY t.id
    HAVING COUNT(p.id) > 0

### 13 ###
###Вывести id и количество пассажиров для всех прошедших полётов.###
SELECT name FROM Passenger
    GROUP BY name
    HAVING COUNT(name) > 1

### 14 ###
###В какие города летал Bruce Willis.###
SELECT town_to FROM Trip t
    LEFT JOIN Pass_in_trip pit ON pit.trip = t.id
    LEFT JOIN Passenger p ON p.id = pit.passenger
    WHERE p.name LIKE 'Bruce Willis'

### 15 ###
###Во сколько Стив Мартин (Steve Martin) прилетел в Лондон (London).###
SELECT t.time_in FROM Trip t
    LEFT JOIN Pass_in_trip pit ON pit.trip = t.id
    LEFT JOIN Passenger p ON p.id = pit.passenger
    WHERE p.name LIKE 'Steve Martin' AND town_to LIKE 'London'

### 16 ###
###Вывести отсортированный по количеству перелетов (по убыванию) и имени (по возрастанию) список пассажиров, совершивших хотя бы 1 полет.###
SELECT p.name AS name, COUNT(t.id) AS count FROM Trip t
    JOIN Pass_in_trip pit ON pit.trip = t.id
    JOIN Passenger p ON p.id = pit.passenger
    GROUP BY p.name
    HAVING COUNT(t.id) > 0
    ORDER BY count DESC, p.name ASC

### 17 ###
###Определить, сколько потратил в 2005 году каждый из членов семьи.###
SELECT fm.member_name, fm.status, SUM(p.amount * p.unit_price) AS costs FROM FamilyMembers fm
    JOIN Payments p ON p.family_member = fm.member_id
    WHERE YEAR(p.date) = 2005
    GROUP BY fm.member_id

### 18 ###
###Узнать, кто старше всех в семьe.###
SELECT member_name FROM FamilyMembers
    ORDER BY birthday LIMIT 1

### 19 ###
###Определить, кто из членов семьи покупал картошку (potato).###
SELECT DISTINCT fm.status FROM FamilyMembers fm
    JOIN Payments p ON p.family_member = fm.member_id
    JOIN Goods g ON g.good_id = p.good
    WHERE g.good_name LIKE 'potato'

### 20 ###
###Сколько и кто из семьи потратил на развлечения (entertainment). Вывести статус в семье, имя, сумму.###
SELECT fm1.status ,fm1.member_name, tmp.col * p1.unit_price AS costs FROM
    (SELECT fm.member_id, SUM(p.amount) AS col FROM FamilyMembers fm
        JOIN Payments p ON p.family_member = fm.member_id
        JOIN Goods g ON g.good_id = p.good
        JOIN GoodTypes gt ON gt.good_type_id = g.type
        WHERE gt.good_type_name LIKE 'entertainment'
        GROUP BY fm.member_id) tmp
    JOIN FamilyMembers fm1 ON fm1.member_id = tmp.member_id
    JOIN Payments p1 ON p1.family_member = fm1.member_id
    JOIN Goods g1 ON g1.good_id = p1.good
    JOIN GoodTypes gt1 ON gt1.good_type_id = g1.type
    WHERE gt1.good_type_name LIKE 'entertainment'

### 21 ###
###Определить товары, которые покупали более 1 раза.###
SELECT g.good_name FROM Goods g
    JOIN Payments p ON p.good = g.good_id
    GROUP BY g.good_name
    HAVING COUNT(p.payment_id) > 1

### 22 ###
###Найти имена всех матерей (mother).###
SELECT member_name FROM FamilyMembers
    WHERE status LIKE 'mother'

### 23 ###
###Найдите самый дорогой деликатес (delicacies) и выведите его стоимость.###
SELECT g.good_name, p.unit_price FROM Payments p
    JOIN Goods g ON g.good_id = p.good
    JOIN GoodTypes gt ON gt.good_type_id = g.type
    WHERE gt.good_type_name LIKE 'delicacies'
    ORDER BY p.unit_price DESC
    LIMIT 1

### 24 ###
###Определить кто и сколько потратил в июне 2005.###
SELECT fm.member_name, SUM(p.amount * p.unit_price) AS costs FROM FamilyMembers fm
    JOIN Payments p ON p.family_member = fm.member_id
    WHERE YEAR(p.date) = 2005 AND MONTH(p.date) = 6
    GROUP BY fm.member_id

### 25 ###
###Определить, какие товары имеются в таблице Goods, но не покупались в течение 2005 года.###
SELECT good_name FROM Goods
WHERE good_name NOT IN (
    SELECT g.good_name FROM Payments p
        JOIN Goods g ON g.good_id = p.good
        WHERE YEAR(p.date) = 2005
        GROUP BY g.good_name)

### 26 ###
###Определить группы товаров, которые не приобретались в 2005 году.###
SELECT good_type_name FROM GoodTypes
WHERE good_type_name NOT IN (
    SELECT gt.good_type_name FROM Payments p
        JOIN Goods g ON g.good_id = p.good
        JOIN GoodTypes gt ON gt.good_type_id = g.type
        WHERE YEAR(p.date) = 2005
        GROUP BY gt.good_type_id)

### 27 ###
###Узнать, сколько потрачено на каждую из групп товаров в 2005 году. Вывести название группы и сумму.###
SELECT gt.good_type_name, SUM(tmp.col * tmp.unit_price) AS costs FROM
    (SELECT good, unit_price, SUM(amount) AS col FROM Payments
        WHERE YEAR(date) = 2005
        GROUP BY good, unit_price) tmp
    JOIN Goods g ON g.good_id = tmp.good
    JOIN GoodTypes gt ON gt.good_type_id = g.type
    GROUP BY gt.good_type_name

### 28 ###
###Сколько рейсов совершили авиакомпании с Ростова (Rostov) в Москву (Moscow) ?.###
SELECT COUNT(*) AS count FROM Trip
    WHERE town_from LIKE 'Rostov' AND town_to LIKE 'Moscow'

### 29 ###
###Выведите имена пассажиров улетевших в Москву (Moscow) на самолете TU-134.###
SELECT DISTINCT p.name FROM Passenger p 
    JOIN Pass_in_trip pit ON pit.passenger = p.id
    JOIN Trip t ON t.id = pit.trip
    WHERE t.plane LIKE 'TU-134' AND t.town_to LIKE 'Moscow'

### 30 ###
###Выведите нагруженность (число пассажиров) каждого рейса (trip). Результат вывести в отсортированном виде по убыванию нагруженности.###
SELECT trip, COUNT(*) AS count FROM Pass_in_trip
    GROUP BY trip
    ORDER BY COUNT(*) DESC

### 31 ###
###Вывести всех членов семьи с фамилией Quincey.###
SELECT * FROM FamilyMembers
    WHERE member_name LIKE '%Quincey'

### 32 ###
###Вывести средний возраст людей (в годах), хранящихся в базе данных. Результат округлите до целого в меньшую сторону.###
SELECT FLOOR(AVG(DATEDIFF(NOW(),birthday))/365) - 1 AS age FROM FamilyMembers

### 33 ###
###Найдите среднюю стоимость икры. В базе данных хранятся данные о покупках красной (red caviar) и черной икры (black caviar).###
SELECT AVG(tmp.unit_price) AS cost FROM     
    (SELECT DISTINCT p.unit_price FROM Payments p
        JOIN Goods g ON g.good_id = p.good
        WHERE g.good_name LIKE 'black caviar' OR g.good_name LIKE 'red caviar') tmp

### 34 ###
###Сколько всего 10-ых классов.###
SELECT COUNT(*) AS count FROM Class
    WHERE name LIKE '10%'

### 35 ###
###Сколько различных кабинетов школы использовались 2.09.2019 в образовательных целях ?###
SELECT COUNT(class) AS count FROM Schedule
    WHERE date = '2019-09-02T00:00:00.000Z'

### 36 ###
###Выведите информацию об обучающихся живущих на улице Пушкина (ul. Pushkina)?###
SELECT * FROM Student
    WHERE address LIKE '%ul. Pushkina%'

### 37 ###
###Сколько лет самому молодому обучающемуся ?###
SELECT MIN(FLOOR(DATEDIFF(NOW(),birthday)/365)) AS year FROM Student

### 38 ###
###Сколько Анн (Anna) учится в школе ?###
SELECT COUNT(*) AS count FROM Student
    WHERE first_name LIKE 'Anna'

### 39 ###
###Сколько обучающихся в 10 B классе ?###
SELECT COUNT(c.name) AS count FROM Student_in_class sic
    JOIN Class c ON c.id = sic.class
    WHERE c.name LIKE '10 B'

### 40 ###
###Выведите название предметов, которые преподает Ромашкин П.П. (Romashkin P.P.) ?###
SELECT s.name AS subjects FROM Subject s
    JOIN Schedule sch ON sch.subject = s.id 
    JOIN Teacher t ON t.id = sch.teacher
    WHERE t.last_name LIKE 'Romashkin' AND t.first_name LIKE 'P%' AND t.middle_name LIKE 'P%'

### 41 ###
###Во сколько начинается 4-ый учебный предмет по расписанию ?###
SELECT start_pair FROM Timepair
    WHERE id = 4

### 42 ###
###Сколько времени обучающийся будет находиться в школе, учась со 2-го по 4-ый уч. предмет ?###
SELECT start_pair FROM Timepair
    WHERE id = 4