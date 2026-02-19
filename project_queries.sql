
/* ============================================================
Project: car-performance-sql-analysis
Author: Volodymyr Tarasyuk
Description:
This file contains all SQL queries used to answer
the business questions described in the README file.
============================================================ */


/* ============================================================
Business Question 1:
Which automotive brands have the widest product range in terms of pricing and performance?
============================================================ */

SELECT 
    car_make
    , MAX(price_in_usd) AS max_price
    , MIN(price_in_usd) AS min_price
    , MAX(price_in_usd) - MIN(price_in_usd) AS price_diff
    , MAX(horsepower) - MIN(horsepower) AS horsepower_diff
    , COUNT(*) AS total_models
FROM cars
WHERE price_in_usd IS NOT NULL
  AND horsepower IS NOT NULL
GROUP BY car_make
HAVING COUNT(*) > 5
ORDER BY price_diff DESC
LIMIT 5;

/* ============================================================
Business Question 2:
Which brands dominate the ultra high-performance segment (700+ HP)?
============================================================ */

Select 
	car_make 
	, ROUND(SUM(CASE When horsepower > 700 THEN 1 ELSE 0 END)::numeric * 100 / COUNT(*),2) as high_tier_percentage 
FROM cars 
WHere horsepower IS NOT NULL 
GROUP BY car_make 
ORDER BY high_tier_percentage DESC

/* ============================================================
Business Question 3:
Which automotive brands demonstrate the highest performance efficiency?
============================================================ */

SELECT 
    car_make,
    ROUND(AVG(horsepower),2) AS avg_hp,
    ROUND(AVG(zero_to_sixty_time),2) AS avg_speed,
    ROUND(
        AVG(horsepower) / AVG(zero_to_sixty_time),
    2) AS performance_index,
    COUNT(*) AS model_count
FROM cars
WHERE engine_type <> 'Electric'
  AND horsepower IS NOT NULL
  AND zero_to_sixty_time IS NOT NULL
GROUP BY car_make
HAVING COUNT(*) >= 3
ORDER BY performance_index DESC
LIMIT 10;

/* ====================================================
Business Question 4:
How does horsepower influence vehicle pricing across different performance segments?
==================================================== */

SELECT 
    CONCAT(
        FLOOR(horsepower/100)*100, 
        '-', 
        FLOOR(horsepower/100)*100 + 99
    ) AS hp_group,
    ROUND(AVG(price_in_usd), 0) AS avg_price,
	COUNT(*) AS car_count
FROM cars
WHERE horsepower IS NOT NULL
  AND price_in_usd IS NOT NULL
  AND engine_type <> 'Electric'
GROUP BY FLOOR(horsepower/100)
Having COUNT(*) > 5
ORDER BY FLOOR(horsepower/100);

/* ====================================================
Business Question 5:
What percentage of each brand’s models are priced above the overall market average?
==================================================== */

WITH ap AS (
    SELECT AVG(price_in_usd) AS avg_price
    FROM cars)
			
, totalcars AS (
    SELECT 
        car_make,
        COUNT(*) AS total_cars,
        SUM(CASE 
                WHEN price_in_usd > (SELECT avg_price FROM ap) 
                THEN 1 
                ELSE 0 
            END) AS luxury_cars
    FROM cars
    GROUP BY car_make)
    
, percentage as (
    SELECT 
	car_make
	, total_cars 
	, luxury_cars
       ,  ROUND((luxury_cars::numeric / total_cars) * 100, 2) AS percentage_above_avg
    FROM totalcars )
   
SELECT
    car_make,
    total_cars,
    luxury_cars,
    percentage_above_avg,
    CASE 
        WHEN percentage_above_avg >= 70 THEN 'Premium'
        WHEN percentage_above_avg BETWEEN 40 AND 70 THEN 'Medium'
        ELSE 'Low'
    END AS segment
FROM persentage
Order BY percentage_above_avg DESC

/* ====================================================
Business Question 6:
Which models are the fastest within each brand, and how do they compare to the brand’s average acceleration?
==================================================== */

With r as 
(
Select
	car_make
	, car_model 
	, year
	, zero_to_sixty_time   
	, ROW_NUMBER() OVER ( Partition by car_make Order BY zero_to_sixty_time) as ranked_model 
	FROM cars 
	Where zero_to_sixty_time IS NOT NULL 
)
, avg_s as 
(
Select 
	COUNT(*) as total_cars
	, car_make 
	, ROUND(avg(zero_to_sixty_time),2) as avg_speed_per_brand 
FROM cars 
Where zero_to_sixty_time IS NOT NULL 
Group by car_make
Having COUNT(*) > 3 
)

Select
	r.car_make 
	, car_model 
	, year
	, zero_to_sixty_time
	, avg_speed_per_brand 
	, avg_speed_per_brand - r.zero_to_sixty_time as speed_diff 
FROM r
JOIN avg_s a 
ON r.car_make = a.car_make
Where ranked_model = 1 

/* ====================================================
Business Question 7:
How do top-performing models evolve over time for each brand?
==================================================== */

WITH tm AS (
    SELECT
        car_make,
        car_model,
        year,
       	horsepower,
		price_in_usd, 
		zero_to_sixty_time, 
        ROW_NUMBER() OVER (PARTITION BY car_make, year ORDER BY horsepower DESC) AS ranked
    FROM cars
	Where engine_type <> 'Electric'
)
, top_cars AS (
    SELECT
        car_make,
        car_model,
        year,
        horsepower,
		price_in_usd, 
		zero_to_sixty_time
    FROM tm
    WHERE ranked = 1
)

SELECT
    car_make,
    car_model,
    year,
    horsepower,
	COALESCE(horsepower - LAG(horsepower) OVER (PARTITION BY car_make ORDER BY year), 0) AS horsepower_diff, 
	price_in_usd, 
	COALESCE(price_in_usd - LAG(price_in_usd) OVER (PARTITION BY car_make ORDER BY year), 0) AS price_diff
	
FROM top_cars
ORDER BY car_make, year
