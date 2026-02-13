
/* ============================================================
Project: car-performance-sql-analysis
Author: Volodymyr Tarasyuk
Description:
This file contains all SQL queries used to answer
the business questions described in the README file.
============================================================ */

/* ============================================================
Business Question 1:
Performance Efficiency Ranking
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
