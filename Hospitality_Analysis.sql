show databases;
select database();
use hospitality_analysis;
select * from dim_date;
select * from dim_hotels;
select * from dim_rooms;
select * from fact_aggregated_bookings;
select* from fact_bookings;
-----------------------------------------------------------------------
-- Here I use LOAD DATA INFILE 
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

-----------------------------------------------------------------------------------------------------------------------------

-- 1. Total Revenue
SELECT SUM(revenue_realized) AS TotalRevenue
FROM fact_bookings;
-- 2. Total Bookings
SELECT COUNT(booking_id) AS TotalBookings
FROM fact_bookings;
-- 3rd KPI card Occupancy Rate
SELECT
   CONCAT( ROUND((SUM(successful_bookings) * 1.0 / SUM(capacity)) * 100, 2),'%') AS OccupancyRatePercentage
FROM fact_aggregated_bookings;
-- 4th kpi card Cancellation Rate
SELECT 
  CONCAT(ROUND(SUM(CASE WHEN booking_status = 'Cancelled' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2),'%') AS cancellation_rate_pct
FROM fact_bookings;

---------------------------------------------------------------------------------------------------------------------------------

