-- Clean the dataset
WITH cleaned_data AS (
    SELECT
        -- Generate a consecutive patient ID
        ROW_NUMBER() OVER () AS patient_id,  -- Generate consecutive numbers
        -- Remove prefixes and standardize capitalization
        INITCAP(REGEXP_REPLACE(TRIM(CAST(Name AS STRING)), r'^(Mr\.|Mrs\.|Ms\.|Dr\.|Prof\.|Rev\.)\s+', '')) AS patient_name,
        -- Extract first and last names from the cleaned name
        TRIM(SPLIT(INITCAP(REGEXP_REPLACE(TRIM(CAST(Name AS STRING)), r'^(Mr\.|Mrs\.|Ms\.|Dr\.|Prof\.|Rev\.)\s+', '')), ' ')[OFFSET(0)]) AS patient_first_name,
        TRIM(SPLIT(INITCAP(REGEXP_REPLACE(TRIM(CAST(Name AS STRING)), r'^(Mr\.|Mrs\.|Ms\.|Dr\.|Prof\.|Rev\.)\s+', '')), ' ')[OFFSET(1)]) AS patient_last_name,
        SAFE_CAST(Age AS INT64) AS patient_age,
        CASE
            WHEN TRIM(CAST(Gender AS STRING)) IN ('Male', 'Male ', 'M') THEN 'Male'
            WHEN TRIM(CAST(Gender AS STRING)) IN ('Female', 'Female ', 'F') THEN 'Female'
            ELSE 'Unknown'
        END AS patient_gender,
        TRIM(CAST(`Blood Type` AS STRING)) AS patient_blood_type,
        TRIM(CAST(`Medical Condition` AS STRING)) AS primary_condition,
        SAFE_CAST(CAST(`Date of Admission` AS STRING) AS DATE) AS admission_date,
        TRIM(CAST(Doctor AS STRING)) AS attending_doctor,
        TRIM(CAST(Hospital AS STRING)) AS healthcare_facility,
        TRIM(CAST(`Insurance Provider` AS STRING)) AS insurance_provider,
        SAFE_CAST(CAST(`Billing Amount` AS STRING) AS FLOAT64) AS billed_amount,
        TRIM(CAST(`Room Number` AS STRING)) AS room_number,
        CASE
            WHEN TRIM(CAST(`Admission Type` AS STRING)) IN ('Emergency', 'Elective', 'Urgent') THEN TRIM(CAST(`Admission Type` AS STRING))
            ELSE 'Other'
        END AS admission_type,
        SAFE_CAST(CAST(`Discharge Date` AS STRING) AS DATE) AS discharge_date,
        TRIM(CAST(Medication AS STRING)) AS prescribed_medication,
        CASE
            WHEN TRIM(CAST(`Test Results` AS STRING)) IN ('Normal', 'Abnormal', 'Inconclusive') THEN TRIM(CAST(`Test Results` AS STRING))
            ELSE 'Unknown'
        END AS medical_test_results
    FROM
        `healthcare-data-pipeline-dbt.healthcare_raw_data.healthcare`
),

-- Assign row numbers to identify duplicates
numbered_data AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY 
                patient_name,
                patient_first_name,
                patient_last_name,
                patient_age,
                patient_gender,
                patient_blood_type,
                primary_condition,
                admission_date,
                attending_doctor,
                healthcare_facility,
                insurance_provider,
                room_number,
                admission_type,
                discharge_date,
                prescribed_medication,
                medical_test_results
            ORDER BY admission_date DESC  -- Or any other criteria to choose which row to keep
        ) AS row_num
    FROM
        cleaned_data
)

-- Select distinct records, keeping only the first occurrence of each duplicate
SELECT
    patient_id,
    patient_name,
    patient_first_name,
    patient_last_name,
    patient_age,
    patient_gender,
    patient_blood_type,
    primary_condition,
    admission_date,
    attending_doctor,
    healthcare_facility,
    insurance_provider,
    billed_amount,
    room_number,
    admission_type,
    discharge_date,
    prescribed_medication,
    medical_test_results
FROM
    numbered_data
WHERE
    row_num = 1
