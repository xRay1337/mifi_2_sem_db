-- Создание и наполнение таблиц

DROP SCHEMA IF EXISTS car_races;

CREATE SCHEMA IF NOT EXISTS car_races;

CREATE TABLE car_races.Classes
(
    class VARCHAR(100) NOT NULL,
    type ENUM('Racing', 'Street') NOT NULL,
    country VARCHAR(100) NOT NULL,
    numDoors INT NOT NULL,
    engineSize DECIMAL(3, 1) NOT NULL, -- размер двигателя в литрах
    weight INT NOT NULL,                -- вес автомобиля в килограммах
    PRIMARY KEY (class)
);

CREATE TABLE car_races.Cars
(
    name VARCHAR(100) NOT NULL,
    class VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    PRIMARY KEY (name),
    FOREIGN KEY (class) REFERENCES Classes(class)
);

CREATE TABLE car_races.Races
(
    name VARCHAR(100) NOT NULL,
    date DATE NOT NULL,
    PRIMARY KEY (name)
);

CREATE TABLE car_races.Results
(
    car VARCHAR(100) NOT NULL,
    race VARCHAR(100) NOT NULL,
    position INT NOT NULL,
    PRIMARY KEY (car, race),
    FOREIGN KEY (car) REFERENCES Cars(name),
    FOREIGN KEY (race) REFERENCES Races(name)
);


INSERT INTO car_races.Classes (class, type, country, numDoors, engineSize, weight) VALUES
('SportsCar', 'Racing', 'USA', 2, 3.5, 1500),
('Sedan', 'Street', 'Germany', 4, 2.0, 1200),
('SUV', 'Street', 'Japan', 4, 2.5, 1800),
('Hatchback', 'Street', 'France', 5, 1.6, 1100),
('Convertible', 'Racing', 'Italy', 2, 3.0, 1300),
('Coupe', 'Street', 'USA', 2, 2.5, 1400),
('Luxury Sedan', 'Street', 'Germany', 4, 3.0, 1600),
('Pickup', 'Street', 'USA', 2, 2.8, 2000);

INSERT INTO car_races.Cars (name, class, year) VALUES
('Ford Mustang', 'SportsCar', 2020),
('BMW 3 Series', 'Sedan', 2019),
('Toyota RAV4', 'SUV', 2021),
('Renault Clio', 'Hatchback', 2020),
('Ferrari 488', 'Convertible', 2019),
('Chevrolet Camaro', 'Coupe', 2021),
('Mercedes-Benz S-Class', 'Luxury Sedan', 2022),
('Ford F-150', 'Pickup', 2021),
('Audi A4', 'Sedan', 2018),
('Nissan Rogue', 'SUV', 2020);

INSERT INTO car_races.Races (name, date) VALUES
('Indy 500', '2023-05-28'),
('Le Mans', '2023-06-10'),
('Monaco Grand Prix', '2023-05-28'),
('Daytona 500', '2023-02-19'),
('Spa 24 Hours', '2023-07-29'),
('Bathurst 1000', '2023-10-08'),
('Nürburgring 24 Hours', '2023-06-17'),
('Pikes Peak International Hill Climb', '2023-06-25');

INSERT INTO car_races.Results (car, race, position) VALUES
('Ford Mustang', 'Indy 500', 1),
('BMW 3 Series', 'Le Mans', 3),
('Toyota RAV4', 'Monaco Grand Prix', 2),
('Renault Clio', 'Daytona 500', 5),
('Ferrari 488', 'Le Mans', 1),
('Chevrolet Camaro', 'Monaco Grand Prix', 4),
('Mercedes-Benz S-Class', 'Spa 24 Hours', 2),
('Ford F-150', 'Bathurst 1000', 6),
('Audi A4', 'Nürburgring 24 Hours', 8),
('Nissan Rogue', 'Pikes Peak International Hill Climb', 3);


/*
Задача 1
Определить, какие автомобили из каждого класса имеют наименьшую среднюю позицию в гонках, 
и вывести информацию о каждом таком автомобиле для данного класса, включая его класс, 
среднюю позицию и количество гонок, в которых он участвовал.
Также отсортировать результаты по средней позиции.
*/
WITH car_results AS
(
    SELECT 	c.class
			,r.car
            ,AVG(r.position) AS average_position
            ,COUNT(r.race) AS race_count
    FROM car_races.Results AS r
    JOIN car_races.Cars AS c ON r.car = c.name
    GROUP BY c.class, r.car
)
,min_average_position AS
(
    SELECT 	class
			,car
            ,average_position
            ,race_count
            ,ROW_NUMBER() OVER(PARTITION BY class ORDER BY average_position) AS rn
    FROM car_results
)
SELECT 	car AS car_name
		,class AS car_class
        ,average_position
        ,race_count
FROM min_average_position
WHERE rn = 1
ORDER BY average_position;

/*
Задача 2
Определить автомобиль, который имеет наименьшую среднюю позицию в гонках среди всех автомобилей, 
и вывести информацию об этом автомобиле, включая его класс, среднюю позицию, количество гонок, 
в которых он участвовал, и страну производства класса автомобиля. 
Если несколько автомобилей имеют одинаковую наименьшую среднюю позицию, выбрать один из них по алфавиту (по имени автомобиля).
*/
SELECT 	r.car
		,c.class
        ,AVG(r.position) AS average_position
        ,COUNT(r.race) AS race_count
        ,cl.country AS car_country
FROM car_races.Results AS r
JOIN car_races.Cars AS c ON r.car = c.name
JOIN car_races.Classes AS cl ON c.class = cl.class
GROUP BY r.car
ORDER BY average_position, c.name
LIMIT 1;

/*
Задача 3
Определить классы автомобилей, которые имеют наименьшую среднюю позицию в гонках, 
и вывести информацию о каждом автомобиле из этих классов, включая его имя, среднюю позицию, количество гонок, в которых он участвовал, 
страну производства класса автомобиля, а также общее количество гонок, в которых участвовали автомобили этих классов. 
Если несколько классов имеют одинаковую среднюю позицию, выбрать все из них.
*/
WITH class_results AS
(
    SELECT 	c.class
			,AVG(r.position) AS average_position
            ,COUNT(r.race) AS total_races
    FROM car_races.Results AS r
    JOIN car_races.Cars AS c ON r.car = c.name
    GROUP BY c.class
)
,class_with_min_average_position AS
(
	SELECT class
	FROM class_results
	WHERE average_position = (SELECT MIN(average_position) FROM class_results)
)
,car_results AS
(
	SELECT 	c.name AS car_name
			,c.class AS car_class
            ,AVG(r.position) AS average_position
			,COUNT(r.race) AS race_count
            ,cl.country AS car_country
	FROM car_races.Results AS r
	JOIN car_races.Cars AS c ON r.car = c.name
	JOIN car_races.Classes AS cl ON c.class = cl.class
    JOIN class_with_min_average_position AS cwmap ON c.class = cwmap.class
	GROUP BY c.name, c.class, cl.country
)
SELECT 	cr.*
        ,cls.total_races
FROM car_results AS cr
JOIN class_results AS cls ON cr.car_class = cls.class;

/*
Задача 4
Определить классы автомобилей, которые имеют наименьшую среднюю позицию в гонках, 
и вывести информацию о каждом автомобиле из этих классов, включая его имя, среднюю позицию, количество гонок, в которых он участвовал, 
страну производства класса автомобиля, а также общее количество гонок, в которых участвовали автомобили этих классов. 
Если несколько классов имеют одинаковую среднюю позицию, выбрать все из них.
*/
WITH class_results AS
(
    SELECT 	c.class
			,AVG(r.position) AS average_position
            ,COUNT(c.name) AS car_count
    FROM car_races.Results AS r
    JOIN car_races.Cars AS c ON r.car = c.name
    GROUP BY c.class
    HAVING COUNT(c.name) >= 2
)
,car_results AS
(
	SELECT 	c.name AS car_name
			,c.class AS car_class
            ,AVG(r.position) AS average_position
            ,COUNT(r.race) AS race_count
            ,cl.country AS car_country
    FROM car_races.Results AS r
    JOIN car_races.Cars AS c ON r.car = c.name
    JOIN car_races.Classes AS cl on cl.class = c.class
    JOIN class_results AS cr ON c.class = cr.class
    GROUP BY c.name, c.class, cl.country
)
SELECT cr.*
FROM car_results AS cr
JOIN class_results AS cls ON cls.class = cr.car_class
WHERE cr.average_position < cls.average_position
ORDER BY car_class, average_position;

/*
Задача 5
Определить, какие классы автомобилей имеют наибольшее количество автомобилей с низкой средней позицией (больше 3.0) 
и вывести информацию о каждом автомобиле из этих классов, включая его имя, класс, среднюю позицию, количество гонок, 
в которых он участвовал, страну производства класса автомобиля, а также общее количество гонок для каждого класса. 
Отсортировать результаты по количеству автомобилей с низкой средней позицией.
*/
WITH car_results AS
(
	SELECT	c.name AS car_name
			,c.class AS car_class
            ,AVG(r.position) AS average_position
            ,COUNT(r.race) AS race_count
    FROM car_races.Cars AS c
    JOIN car_races.Results AS r ON c.name = r.car
    GROUP BY c.name, c.class
    HAVING AVG(r.position) > 3.0
)
,class_race_counts AS
(
    SELECT	c.class AS car_class
			,COUNT(r.race) AS total_race_count
    FROM car_races.Cars AS c
    JOIN car_races.Results AS r ON c.name = r.car
    GROUP BY c.class
)
,class_low_position_count AS
(
    SELECT	car_class
			,COUNT(car_name) AS low_position_count
    FROM car_results
    GROUP BY car_class
)
SELECT 	cr.*
		,cl.country
        ,crc.total_race_count
        ,clpc.low_position_count
FROM car_results AS cr
JOIN class_low_position_count AS clpc ON cr.car_class = clpc.car_class
JOIN car_races.Classes AS cl ON cr.car_class = cl.class
JOIN class_race_counts AS crc ON cr.car_class = crc.car_class
ORDER BY clpc.low_position_count DESC, cr.average_position DESC;

