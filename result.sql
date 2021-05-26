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