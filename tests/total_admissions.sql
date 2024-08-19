-- Ensures that total_admissions is never negative

SELECT *
FROM {{ model }}
WHERE total_admissions < 0