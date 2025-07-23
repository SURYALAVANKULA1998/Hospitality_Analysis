CREATE TABLE dim_date (
    date DATE,
    mmm_yy VARCHAR(10),
    week_no VARCHAR(10),
    day_type VARCHAR(10)
);
SHOW VARIABLES LIKE 'secure_file_priv';
-- LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/dim_date.csv'
-- INTO TABLE dim_date
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\r\n'
-- IGNORE 1 LINES;
select * from dim_date;
select * from dim_hotels;
CREATE TABLE dim_hotels (
    property_id INT PRIMARY KEY,
    property_name VARCHAR(100),
    category VARCHAR(50),
    city VARCHAR(50)
);
CREATE TABLE dim_rooms (
    room_id VARCHAR(10),
    room_type VARCHAR(50),
    price DECIMAL(10,2),
    availability VARCHAR(20)
);
CREATE TABLE fact_bookings (
    booking_id VARCHAR(30) PRIMARY KEY,
    property_id INT,
    booking_date DATE,
    check_in_date DATE,
    checkout_date DATE,
    no_guests INT,
    room_category VARCHAR(20),
    booking_platform VARCHAR(50),
    ratings_given FLOAT,
    booking_status VARCHAR(20),
    revenue_generated INT,
    revenue_realized INT
);
 select* from fact_bookings;
-- LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/fact_bookings.csv'
-- INTO TABLE fact_bookings
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\r\n'
-- IGNORE 1 LINES
-- (booking_id, property_id, booking_date, check_in_date, checkout_date,
--  no_guests, room_category, booking_platform, ratings_given,
--  booking_status, revenue_generated, revenue_realized);
-- LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/fact_bookings.csv'
-- INTO TABLE fact_bookings
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\r\n'
-- IGNORE 1 LINES
-- (booking_id, property_id, booking_date, check_in_date, checkout_date,
--  no_guests, room_category, booking_platform, ratings_given,
--  booking_status, revenue_generated, revenue_realized);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/fact_bookings.csv'
INTO TABLE fact_bookings
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(booking_id, property_id, booking_date, check_in_date, checkout_date,
 no_guests, room_category, booking_platform, @ratings_given,
 booking_status, revenue_generated, revenue_realized)
SET ratings_given = NULLIF(@ratings_given, '');


-- CREATE TABLE fact_aggregated_bookings (
--     booking_id INT AUTO_INCREMENT PRIMARY KEY,
--     customer_id VARCHAR(20),
--     room_id VARCHAR(20),
--     total_amount DECIMAL(10,2),
--     booking_date DATE
-- );
select * from fact_aggregated_bookings;
drop table dim_rooms;
select * from dim_rooms;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/dim_date.csv'
INTO TABLE dim_date
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/dim_hotels.csv'
INTO TABLE dim_hotels
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/dim_rooms.csv'
INTO TABLE dim_rooms
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(room_id, room_type, price, availability);

-- LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/fact_aggregated_bookings.csv'
-- INTO TABLE fact_aggregated_bookings
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\r\n'
-- IGNORE 1 LINES
-- (booking_id, customer_id, room_id, total_amount, @booking_date)
-- SET booking_date = STR_TO_DATE(@booking_date, '%d-%m-%Y');


-- Total Revenue
SELECT SUM(revenue_generated) AS total_revenue
FROM fact_bookings;

SELECT SUM(no_guests) AS total_guests
FROM fact_bookings
WHERE booking_status = 'Checked Out';


-- 2 kpi card  Total Bookings
SELECT COUNT(*) AS total_bookings
FROM fact_bookings;


-- 3. Occupancy Rate
-- SELECT
--     SUM(successful_bookings) / SUM(capacity) AS OccupancyRate
-- FROM fact_aggregated_bookings;
-- 4. Cancellation Rate
-- SELECT
--     (SUM(CASE WHEN booking_status = 'Cancelled' THEN 1 ELSE 0 END) * 1.0 / COUNT(booking_id)) AS CancellationRate
-- FROM fact_bookings;



-- 1. Total Revenue
SELECT SUM(revenue_realized) AS TotalRevenue
FROM fact_bookings;
-- 2. Total Bookings
SELECT COUNT(booking_id) AS TotalBookings
FROM fact_bookings;
-- 3rd KPI card
SELECT
   CONCAT( ROUND((SUM(successful_bookings) * 1.0 / SUM(capacity)) * 100, 2),'%') AS OccupancyRatePercentage
FROM fact_aggregated_bookings;
-- 4th kpi card Cancellation Rate
SELECT 
  CONCAT(ROUND(SUM(CASE WHEN booking_status = 'Cancelled' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2),'%') AS cancellation_rate_pct
FROM fact_bookings;
ALTER DATABASE crm MODIFY NAME = 'Hospitality';


SELECT
    ROUND((SUM(successful_bookings) * 1.0 / SUM(capacity)) * 100, 2) AS OccupancyRatePercentage
FROM fact_aggregated_bookings;

SELECT
    CONCAT(ROUND((SUM(successful_bookings) * 1.0 / SUM(capacity)) * 100, 2), '%') AS OccupancyRate
FROM fact_aggregated_bookings;

CREATE DATABASE Hospitality;
RENAME TABLE crm.table1 TO Hospitality.table1;
RENAME TABLE crm.dim_date TO Hospitality.dim_date;
RENAME TABLE crm.dim_rooms TO Hospitality.dim_rooms;
RENAME TABLE crm.fact_aggregated_bookings TO Hospitality.fact_aggregated_bookings;
RENAME TABLE crm.fact_bookings TO Hospitality.fact_bookings;
RENAME TABLE crm.dim_hotels TO Hospitality.dim_hotels;

drop database crm;
