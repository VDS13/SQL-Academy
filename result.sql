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