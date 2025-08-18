/* ********************** Project using the mimic-III database************************ 

Question- Using the MIMIC-III database, write an SQL query in SSMS to join the Admissions, Patients, 
and Caregivers tables to find each patient’s age, gender, admission details, and the number of caregivers 
involved per admission. Then filter the results for patients over 60 years old and sort them by admission 
date in descending order. 

*/
-- Create project daabase named mimic_III_project

CREATE DATABASE mimic_III_project;

/* Select the MIMIC III clinical database for this project. 
Make sure to upload the three tables following the steps given on the slide */

USE mimic_III_project;

-- Drop tables if they already exist to avoid overlapping
DROP TABLE IF EXISTS Patients;
DROP TABLE IF EXISTS Appointments;
DROP TABLE IF EXISTS Caregivers;

-- view the three tables for the primary keys (PKs). Here row_id seems to be common.  

SELECT * FROM ADMISSIONS 
SELECT * FROM PATIENTS
SELECT * FROM CAREGIVERS

/* You can see the table structure using this command. This step gives 
all the column name and detailed decription of the data stores 

sp_columns admissions;
sp_columns patients;
sp_columns caregivers; */

-- As per the question query the data 

-- Join Admissions, Patients, and Caregivers
SELECT *
FROM Patients p
JOIN Admissions a 
    ON p.subject_id = a.subject_id
LEFT JOIN Caregivers c
    ON a.row_id = c.row_id;

--Next part is to filter the results for patients over 60 years old and sort them by admission date in descending order. 

SELECT 
    p.subject_id,
    p.gender,
    DATEDIFF(YEAR, p.dob, a.admittime) AS age,
    a.hadm_id,
    a.admittime,
    a.dischtime,
    a.admission_type,
    COUNT(c.row_id) AS num_caregivers
FROM Patients p
JOIN Admissions a 
    ON p.subject_id = a.subject_id
LEFT JOIN Caregivers c
    ON a.row_id = c.row_id
WHERE DATEDIFF(YEAR, p.dob, a.admittime) > 60 -- for realistic age use the 'realistic age filter' given, at the end, here. 
GROUP BY 
    p.subject_id, 
    p.gender, 
    p.dob, 
    a.hadm_id, 
    a.admittime, 
    a.dischtime, 
    a.admission_type
ORDER BY a.admittime DESC; -- Ans 102 rows or 93 rows after using the 'realistic age filter'

/* Now there are some weird unrealistic looking ages in the output table where 
age is >300 because of dob and the admission date in the demo dataset */

-- For more realistic looking age you can further put a filter 
WHERE DATEDIFF(YEAR, p.dob, a.admittime) BETWEEN 60 AND 100

