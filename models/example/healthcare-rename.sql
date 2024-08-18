-- transform the dataset by selecting and renaming columns from the source table

WITH raw_data AS (
    SELECT
        Name AS patient_name,
        Age AS patient_age,
        Gender AS patient_gender,
        `Blood Type` AS patient_blood_type,
        `Medical Condition` AS primary_condition,
        `Date of Admission` AS admission_date,
        Doctor AS attending_doctor,
        Hospital AS healthcare_facility,
        `Insurance Provider` AS insurance_provider,
        `Billing Amount` AS billed_amount,
        `Room Number` AS room_number,
        `Admission Type` AS admission_type,
        `Discharge Date` AS discharge_date,
        Medication AS prescribed_medication,
        `Test Results` AS medical_test_results
    FROM
        `healthcare-data-pipeline-dbt.healthcare_raw_data.healthcare`
)

SELECT
    patient_name,
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
    raw_data