--  Ensures that average_length_of_stay is never negative

SELECT *
FROM {{ model }}
WHERE average_length_of_stay < 0