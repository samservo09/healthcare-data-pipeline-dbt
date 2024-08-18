-- perform aggregations on the dataset

WITH length_of_stay AS (
    SELECT
        patient_name,
        TIMESTAMP_DIFF(discharge_date, admission_date, DAY) AS length_of_stay_days,
        primary_condition,
        healthcare_facility,
        admission_type
    FROM
        {{ ref('stg_healthcare_rename') }}
),

-- Count of patients by gender
patient_count_by_gender AS (
    SELECT
        patient_gender,
        COUNT(*) AS patient_count
    FROM
        {{ ref('stg_healthcare_rename') }}
    GROUP BY
        patient_gender
),

-- Average billing amount by medical condition
average_billing_by_condition AS (
    SELECT
        primary_condition,
        AVG(billed_amount) AS average_billing_amount
    FROM
        {{ ref('stg_healthcare_rename') }}
    GROUP BY
        primary_condition
),

-- Total number of admissions by hospital
total_admissions_by_hospital AS (
    SELECT
        healthcare_facility,
        COUNT(*) AS total_admissions
    FROM
        {{ ref('stg_healthcare_rename') }}
    GROUP BY
        healthcare_facility
),

-- Average length of stay by admission type
average_length_of_stay_by_admission_type AS (
    SELECT
        admission_type,
        AVG(length_of_stay_days) AS average_length_of_stay
    FROM
        length_of_stay
    GROUP BY
        admission_type
)

-- Combine all results into a single result set
SELECT
    'Patient Count by Gender' AS metric,
    patient_gender AS category,
    patient_count AS value
FROM
    patient_count_by_gender

UNION ALL

SELECT
    'Average Billing by Medical Condition' AS metric,
    primary_condition AS category,
    average_billing_amount AS value
FROM
    average_billing_by_condition

UNION ALL

SELECT
    'Total Admissions by Hospital' AS metric,
    healthcare_facility AS category,
    total_admissions AS value
FROM
    total_admissions_by_hospital

UNION ALL

SELECT
    'Average Length of Stay by Admission Type' AS metric,
    admission_type AS category,
    average_length_of_stay AS value
FROM
    average_length_of_stay_by_admission_type
