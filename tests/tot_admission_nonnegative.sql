-- Ensures that total_admissions is never negative

SELECT *
FROM {{ model }}
WHERE {{ column }} < 0