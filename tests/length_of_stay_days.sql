-- Will fail if there are any rows with length_of_stay_days less than 0

SELECT *
FROM {{ model }}
WHERE length_of_stay_days < 0