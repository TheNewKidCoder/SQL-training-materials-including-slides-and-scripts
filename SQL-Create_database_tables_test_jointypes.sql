/* Create new database, two example tables, and see how the four common join types work.
Also, a few BONUS JOIN types included just for understanding */


-- Create a sample EHR database
CREATE DATABASE EHR_Sample;

-- Select the database to use
USE EHR_Sample;

-- Drop tables if they already exist
DROP TABLE IF EXISTS Patients;
DROP TABLE IF EXISTS Appointments;

-- Create Patients table (we name the table and column names, and define the data type along with that)
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY,
    PatientName VARCHAR(50),
    DateOfBirth DATE
);

-- Insert sample patients
INSERT INTO Patients (PatientID, PatientName, DateOfBirth) VALUES
(1, 'Emma Johnson', '1985-04-12'),
(2, 'Liam Smith', '1990-09-20'),
(3, 'Olivia Brown', '1978-12-05'),
(4, 'Noah Davis', '2000-01-15'),
(5, 'Ava Wilson', '1995-07-03'),
(6, 'Sophia Martinez', '1982-03-22'),
(7, 'Lucas Anderson', '1975-11-11'),
(8, 'Mia Thomas', '1998-06-08'),
(9, 'Elijah Taylor', '1989-05-25'),
(10, 'Isabella Moore', '1992-10-10');

-- Create Appointments table
CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY,
    PatientID INT,
    AppointmentDate DATE,
    VisitReason VARCHAR(100)
);

-- Insert sample appointments
INSERT INTO Appointments (AppointmentID, PatientID, AppointmentDate, VisitReason) VALUES
(101, 1, '2025-07-01', 'Annual Physical'),
(102, 2, '2025-07-03', 'Flu Symptoms'),
(103, 6, '2025-07-05', 'Chronic Back Pain'),
(104, 11, '2025-07-06', 'Headache'),        -- ❌ No matching patient
(105, 12, '2025-07-07', 'Follow-up Visit'), -- ❌ No matching patient
(106, 9, '2025-07-08', 'Skin Rash');

-- View data
SELECT * FROM Patients;
SELECT * FROM Appointments;

-- ====================================================================================
-- 1. INNER JOIN: Only patients who have appointments
-- ====================================================================================

SELECT *
FROM Patients AS p
INNER JOIN Appointments AS a
ON p.PatientID = a.PatientID;
-- # Shows only the matched rows where the PatientID exists in both the Patients table and the Appointments table.

-- ====================================================================================
-- 2. RIGHT JOIN: All appointments, even if no matching patient exists
-- ====================================================================================

SELECT *
FROM Patients AS p
RIGHT JOIN Appointments AS a
ON p.PatientID = a.PatientID;
-- # Keeps all rows from the Appointments table and adds data from the Patients table only when there's a match.

-- ====================================================================================
-- 3. LEFT JOIN: All patients, even if they don’t have any appointments
-- ====================================================================================

SELECT *
FROM Patients AS p
LEFT JOIN Appointments AS a
ON p.PatientID = a.PatientID;
-- # Keeps all rows from the Patients table and includes data from the Appointments table only when a match exists.

-- ====================================================================================
-- 4. FULL OUTER JOIN: All patients and all appointments, matched when possible
-- ====================================================================================

SELECT *
FROM Patients AS p
FULL OUTER JOIN Appointments AS a
ON p.PatientID = a.PatientID;
-- # Combines all rows from both the Patients table and the Appointments table, matching where possible, 
-- and filling nulls where no match is found.


/**********************************************************  
********************  BONUS Join types ******************** 
***********************************************************/

-- ====================================================================================
-- 5. CROSS JOIN: Every patient with every appointment (Cartesian product)
-- ====================================================================================

SELECT *
FROM Patients AS p
CROSS JOIN Appointments AS a;
-- # Pairs every row from the Patients table with every row in the Appointments table, without any condition.

-- ====================================================================================
-- 6. SELF JOIN: Find patients born in the same year (joining Patients with itself)
-- ====================================================================================

SELECT p1.PatientName AS Patient1, p2.PatientName AS Patient2, p1.DateOfBirth
FROM Patients AS p1
JOIN Patients AS p2
ON YEAR(p1.DateOfBirth) = YEAR(p2.DateOfBirth) AND p1.PatientID < p2.PatientID;
-- # Joins the Patients table with itself to find related rows based on a condition—in this case, same birth year.

-- ====================================================================================
-- 7. ANTI JOIN: Patients with no appointments (using LEFT JOIN + WHERE NULL)
-- ====================================================================================

SELECT p.*
FROM Patients AS p
LEFT JOIN Appointments AS a
ON p.PatientID = a.PatientID
WHERE a.AppointmentID IS NULL;
-- # Selects rows from the Patients table that do not have a match in the Appointments table.

-- ====================================================================================
-- 8. SEMI JOIN: Patients who have at least one appointment (using EXISTS)
-- ====================================================================================

SELECT *
FROM Patients AS p
WHERE EXISTS (
    SELECT 1
    FROM Appointments AS a
    WHERE p.PatientID = a.PatientID
);
/* # Returns rows from the Patients table only if at least one match exists 
in the Appointments table, without showing object table columns.*/

-- ====================================================================================
-- 9. NATURAL JOIN (Note: Not supported in SQL Server / SSMS 2021)
-- ====================================================================================

/* SQL Server does not support NATURAL JOIN syntax found in other RDBMS like MySQL or PostgreSQL. 
Instead, you must explicitly define JOIN conditions using ON.

The following is a simulated version of a NATURAL JOIN using an INNER JOIN 
on columns that have the same name in both tables (e.g., PatientID).

-- Example of simulated NATURAL JOIN:
SELECT *
FROM Patients p
JOIN Appointments a
ON p.PatientID = a.PatientID;

-- Avoid using implicit joins (as in NATURAL JOIN) in production, 
as they rely on column name matching and can lead to unexpected results 
if the schema changes.
*/

