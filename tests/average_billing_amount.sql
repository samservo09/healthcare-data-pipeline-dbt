-- Ensures that average_billing_amount is never negative

SELECT *
FROM {{ model }}
WHERE average_billing_amount < 0