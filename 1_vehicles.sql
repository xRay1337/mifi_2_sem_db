-- Создание и наполнение таблиц

DROP SCHEMA IF EXISTS vehicles;

CREATE SCHEMA IF NOT EXISTS vehicles;

CREATE TABLE IF NOT EXISTS vehicles.Vehicle
(
    maker VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    type ENUM('Car', 'Motorcycle', 'Bicycle') NOT NULL,
    PRIMARY KEY (model)
);

CREATE TABLE IF NOT EXISTS vehicles.Car
(
    vin VARCHAR(17) NOT NULL,
    model VARCHAR(100) NOT NULL,
    engine_capacity DECIMAL(4, 2) NOT NULL, -- объем двигателя в литрах
    horsepower INT NOT NULL,                 -- мощность в лошадиных силах
    price DECIMAL(10, 2) NOT NULL,           -- цена в долларах
    transmission ENUM('Automatic', 'Manual') NOT NULL, -- тип трансмиссии
    PRIMARY KEY (vin),
    FOREIGN KEY (model) REFERENCES Vehicle(model)
);

CREATE TABLE IF NOT EXISTS vehicles.Motorcycle
(
    vin VARCHAR(17) NOT NULL,
    model VARCHAR(100) NOT NULL,
    engine_capacity DECIMAL(4, 2) NOT NULL, -- объем двигателя в литрах
    horsepower INT NOT NULL,                 -- мощность в лошадиных силах
    price DECIMAL(10, 2) NOT NULL,           -- цена в долларах
    type ENUM('Sport', 'Cruiser', 'Touring') NOT NULL, -- тип мотоцикла
    PRIMARY KEY (vin),
    FOREIGN KEY (model) REFERENCES Vehicle(model)
);

CREATE TABLE IF NOT EXISTS vehicles.Bicycle
(
    serial_number VARCHAR(20) NOT NULL,
    model VARCHAR(100) NOT NULL,
    gear_count INT NOT NULL,                 -- количество передач
    price DECIMAL(10, 2) NOT NULL,           -- цена в долларах
    type ENUM('Mountain', 'Road', 'Hybrid') NOT NULL, -- тип велосипеда
    PRIMARY KEY (serial_number),
    FOREIGN KEY (model) REFERENCES Vehicle(model)
);


INSERT INTO vehicles.Vehicle (maker, model, type) VALUES
('Toyota', 'Camry', 'Car'),
('Honda', 'Civic', 'Car'),
('Ford', 'Mustang', 'Car'),
('Yamaha', 'YZF-R1', 'Motorcycle'),
('Harley-Davidson', 'Sportster', 'Motorcycle'),
('Kawasaki', 'Ninja', 'Motorcycle'),
('Trek', 'Domane', 'Bicycle'),
('Giant', 'Defy', 'Bicycle'),
('Specialized', 'Stumpjumper', 'Bicycle');

INSERT INTO vehicles.Car (vin, model, engine_capacity, horsepower, price, transmission) VALUES
('1HGCM82633A123456', 'Camry', 2.5, 203, 24000.00, 'Automatic'),
('2HGFG3B53GH123456', 'Civic', 2.0, 158, 22000.00, 'Manual'),
('1FA6P8CF0J1234567', 'Mustang', 5.0, 450, 55000.00, 'Automatic');

INSERT INTO vehicles.Motorcycle (vin, model, engine_capacity, horsepower, price, type) VALUES
('JYARN28E9FA123456', 'YZF-R1', 1.0, 200, 17000.00, 'Sport'),
('1HD1ZK3158K123456', 'Sportster', 1.2, 70, 12000.00, 'Cruiser'),
('JKBVNAF156A123456', 'Ninja', 0.9, 150, 14000.00, 'Sport');

INSERT INTO vehicles.Bicycle (serial_number, model, gear_count, price, type) VALUES
('SN123456789', 'Domane', 22, 3500.00, 'Road'),
('SN987654321', 'Defy', 20, 3000.00, 'Road'),
('SN456789123', 'Stumpjumper', 30, 4000.00, 'Mountain');

/*
Задача 1
Найдите производителей (maker) и модели всех мотоциклов, которые имеют мощность более 150 лошадиных сил, 
стоят менее 20 тысяч долларов и являются спортивными (тип Sport). 
Также отсортируйте результаты по мощности в порядке убывания.
*/
SELECT 	v.maker
		,m.model
FROM vehicles.Motorcycle AS m
JOIN vehicles.Vehicle AS v ON m.model = v.model
WHERE m.horsepower > 150
  AND m.price < 20000
  AND m.type = 'Sport'
ORDER BY m.horsepower DESC;

/*
Задача 2
Найти информацию о производителях и моделях различных типов транспортных средств (автомобили, мотоциклы и велосипеды), 
которые соответствуют заданным критериям.
*/
WITH all_vehicles AS
(
	SELECT 	model
			,horsepower
			,engine_capacity
	FROM vehicles.Car
	WHERE horsepower > 150
		AND engine_capacity < 3
		AND price < 35000
		
	UNION ALL

	SELECT 	model
			,horsepower
			,engine_capacity
	FROM vehicles.Motorcycle
	WHERE horsepower > 150
		AND engine_capacity < 1.5
		AND price < 20000
		
	UNION ALL

	SELECT 	model
			,NULL AS horsepower
			,NULL AS engine_capacity
	FROM vehicles.Bicycle
	WHERE gear_count > 18
		AND price < 4000
)
SELECT 	v.maker
		,av.*
        ,v.type AS vehicle_type
FROM all_vehicles AS av
JOIN vehicles.Vehicle AS v ON av.model = v.model
ORDER BY (av.horsepower IS NULL), av.horsepower DESC;














