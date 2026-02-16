
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
Business Question 3:
How does horsepower influence vehicle pricing 
across different performance segments?
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
