CREATE TABLE patients (
    patient_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(20),
    date_of_birth DATE,
    contact_number VARCHAR(20),
    address TEXT,
    registration_date DATE,
    insurance_provider VARCHAR(100),
    insurance_number VARCHAR(50),
    email VARCHAR(100)
);

CREATE TABLE doctors (
    doctor_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialization VARCHAR(100),
    phone_number VARCHAR(20),
    years_experience INT,
    hospital_branch VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE appointments (
    appointment_id VARCHAR(10) PRIMARY KEY,
    patient_id VARCHAR(10),
    doctor_id VARCHAR(10),
    appointment_date DATE,
    appointment_time TIME,
    reason_for_visit TEXT,
    status VARCHAR(30),

    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

CREATE TABLE treatments (
    treatment_id VARCHAR(10) PRIMARY KEY,
    appointment_id VARCHAR(10),
    treatment_type VARCHAR(100),
    description TEXT,
    cost NUMERIC(10,2),
    treatment_date DATE,

    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);

CREATE TABLE billing (
    bill_id VARCHAR(10) PRIMARY KEY,
    patient_id VARCHAR(10),
    treatment_id VARCHAR(10),
    bill_date DATE,
    amount NUMERIC(10,2),
    payment_method VARCHAR(50),
    payment_status VARCHAR(30),

    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (treatment_id) REFERENCES treatments(treatment_id)
);

SELECT COUNT(*) AS total_patients
FROM patients;

SELECT * FROM patients; 
-- Number of rows(patients) = 50
SELECT * FROM doctors;
-- Number of rows(doctors) = 10
SELECT * FROM appointments;
-- Number of rrows(appointments) = 200
SELECT * FROM treatments;
-- Number of rows(treatments) = 200
SELECT * FROM billing;
-- Number of rows(billing) = 200

-- Check the different appointment statuses

SELECT status, COUNT(*) AS total
FROM appointments
GROUP BY status
ORDER BY total DESC;


-- 🟢 ***** Level 1 — Easy / Basic SQL *******

-- A. Counts & Aggregations

-- 1. Find the total number of patients.
SELECT COUNT(*) FROM patients;

-- 2. Find the total number of doctors.
SELECT COUNT(*) FROM doctors;

-- 3. Find the total number of appointments.
SELECT COUNT(*) FROM appointments;

-- 4. Find the total number of treatments.
SELECT COUNT(*) FROM treatments;

-- 5. Find the total number of billing records.
SELECT COUNT(*) FROM billing;

-- 6. Calculate the average treatment cost.
SELECT ROUND(AVG(cost),2) AS Avg_treatment_cost 
FROM treatments;

-- 7. Find the minimum treatment cost.
SELECT MIN(cost) AS Min_treatment_cost
FROM treatments;

-- 8. Find the maximum treatment cost.
SELECT MAX(cost) AS Max_treatment_cost
FROM treatments;

-- 9. Calculate the total billing amount.
SELECT SUM(amount) AS total_billing_amount 
FROM billing;

-- 10. Calculate the average billing amount.
SELECT ROUND(AVG(amount),2) AS Avg_billing_amount 
FROM billing;

-- B. Categories

-- 11. Find the most common treatment type.
SELECT treatment_type, COUNT(treatment_type) AS total_treatments
FROM treatments
GROUP BY treatment_type 
ORDER BY COUNT(treatment_type)
DESC LIMIT 1;

-- 12. Find the most common appointment reason.
SELECT reason_for_visit, COUNT(reason_for_visit) AS total_appointment_reason
FROM appointments
GROUP BY reason_for_visit
ORDER BY  COUNT(reason_for_visit)
DESC LIMIT 1;

-- 13. Find the most common appointment status.
SELECT status, COUNT(status) AS status_count
FROM appointments
GROUP BY status
ORDER BY  COUNT(status)
DESC LIMIT 1;

-- 14. Find the most commonly used payment method.
SELECT payment_method, COUNT(payment_method) AS payment_method_count
FROM billing
GROUP BY payment_method
ORDER BY COUNT(payment_method)
DESC LIMIT 1;

-- 15. Find the most common payment status.
SELECT payment_status, COUNT(payment_status) AS payment_status_count
FROM billing
GROUP BY payment_status
ORDER BY COUNT(payment_status)
DESC LIMIT 1;

-- C. Sorting & Filtering

-- 16. Find the 5 most expensive treatments.
SELECT treatment_type, cost AS treatment_expenses
FROM treatments 
ORDER BY cost
DESC LIMIT 5;

-- 17. Find the 5 cheapest treatments.
SELECT treatment_type, cost AS treatment_expenses
FROM treatments 
ORDER BY cost
ASC LIMIT 5;

-- 18. Find doctors with more than 5 years of experience.
SELECT first_name, last_name, years_experience 
FROM doctors
WHERE years_experience > 5
ORDER BY years_experience DESC;

-- 19. Find patients belonging to a particular gender(female).
SELECT first_name, last_name, gender 
FROM patients
WHERE gender = 'F';

-- 20. Find appointments with a particular status.
SELECT appointment_id,patient_id, doctor_id, status 
FROM appointments
WHERE status = 'Cancelled';

-- 🟡 ***** Level 2 — Medium / Business Analysis *****

-- A. GROUP BY Analysis

-- 1. Find the number of appointments for each appointment status.
SELECT status, COUNT(*) AS status_count
FROM appointments
GROUP BY status;

-- 2. Find the number of appointments for each reason for visit
SELECT reason_for_visit, COUNT(*) AS appointment_count
FROM appointments
GROUP BY reason_for_visit
ORDER BY appointment_count DESC;

-- 3.Find the number of appointments handled by each doctor.
SELECT doctor_id, COUNT(*) AS appointment_count
FROM appointments
GROUP BY doctor_id
ORDER BY appointment_count DESC;

-- 4.Find the average treatment cost for each treatment type.
SELECT treatment_type, ROUND(AVG(cost),2) AS avg_cost
FROM treatments
GROUP BY treatment_type
ORDER BY avg_cost DESC;

-- 5.Find the total revenue generated by each treatment type.
SELECT treatment_type, SUM(cost) AS total_revenue
FROM treatments
GROUP BY treatment_type
ORDER BY total_revenue DESC;

-- 6.Find the total billing amount for each payment method.
SELECT payment_method, SUM(amount) AS total_billing_amount
FROM billing
GROUP BY payment_method
ORDER BY total_billing_amount DESC;

-- 7.Find the number of patients treated by each doctor.
SELECT doctor_id, COUNT(DISTINCT(patient_id)) AS patient_Count
FROM appointments
GROUP BY doctor_id
ORDER BY patient_count DESC;

-- 8.Find the treatment type with the highest average cost.
SELECT treatment_type, 
		ROUND(AVG(cost),2) AS Avg_treatment_cost
FROM treatments 
GROUP BY treatment_type
ORDER BY Avg_treatment_cost DESC LIMIT 1;

-- 9.Find payment methods generating more than a specified amount of revenue(200000).
SELECT payment_method,
		SUM(amount) AS revenue
FROM billing
GROUP BY payment_method
HAVING SUM(amount) > 200000
ORDER BY revenue DESC;


-- B .Filtering Groups

-- 1.Find doctors who handled more than 20 appointments.
SELECT doctor_id, COUNT(appointment_id) AS appointment_count
FROM appointments
GROUP BY doctor_id
HAVING COUNT(appointment_id) > 20;

-- 2.Find treatment types performed more than 20 times.
SELECT treatment_type, COUNT(*) AS treatment_count
FROM treatments
GROUP BY treatment_type
HAVING COUNT(*) > 20;

-- C .Date Analysis[EXTRACT() → DATE_TRUNC() → TO_CHAR() → CURRENT_DATE → AGE() → INTERVAL]

-- 1.Find the number of appointments per month.
SELECT EXTRACT('month' FROM appointment_date) AS month,
COUNT(*) AS appointment_count
FROM appointments
GROUP BY EXTRACT('month' FROM appointment_date)
ORDER BY month ASC;

-- 2.Find the number of appointments per year.
SELECT EXTRACT('year' FROM appointment_date) AS year,
COUNT(*) AS appointment_count
FROM appointments
GROUP BY EXTRACT('year' FROM appointment_date)
ORDER BY year ASC;

-- 3.Find the month with the highest number of appointments.
SELECT EXTRACT('month' FROM appointment_date) AS month,
COUNT(*) AS max_appointment_count
FROM appointments
GROUP BY EXTRACT('month' FROM appointment_date)
ORDER BY max_appointment_count DESC LIMIT 1;

-- 4.Find the month with the lowest number of appointments.
SELECT EXTRACT('month' FROM appointment_date) AS month,
COUNT(*) AS min_appointment_count
FROM appointments
GROUP BY EXTRACT('month' FROM appointment_date)
ORDER BY min_appointment_count ASC LIMIT 1;

-- 5.Find the total revenue generated per month.
SELECT EXTRACT('month' FROM bill_date) AS month,
SUM(amount) AS total_revenue
FROM billing
GROUP BY month
ORDER BY total_revenue DESC;
-- D .Business KPIs

-- 1.Calculate the appointment cancellation rate.
SELECT ROUND(COUNT(CASE WHEN status = 'Cancelled' THEN 1 END) * 100.0 / COUNT(*),2)
AS cancellation_rate
FROM appointments;

-- 2.Calculate the appointment completion rate.
SELECT ROUND(COUNT(CASE WHEN status = 'Completed' THEN 1 END) * 100.0 / COUNT(*),2)
AS completed_rate
FROM appointments;
-- ** Note ** : Appointment cancellation rate(25%) is greater than Appointment Completion rate(23%).

-- 3.Calculate the average treatment cost by treatment_type.
SELECT treatment_type, ROUND(AVG(cost),2) AS Avg_treatment_Cost
FROM treatments
GROUP BY treatment_type
ORDER BY Avg_treatment_Cost DESC;

-- 4.Find the doctor generating the highest revenue.
SELECT d.doctor_id, 
		d.first_name, 
		d.last_name, 
		SUM(b.amount) AS total_revenue
FROM doctors d
JOIN appointments a 
		ON d.doctor_id = a.doctor_id
JOIN treatments t
		ON t.appointment_id = a.appointment_id
JOIN billing b
		ON b.treatment_id = t.treatment_id
GROUP BY d.doctor_id, d.first_name, d.last_name
ORDER BY total_revenue DESC LIMIT 1;

-- 🔵 ***** Level 3 — Advanced SQL *****

-- This is where you'll demonstrate JOINs, CTEs, subqueries, CASE and window functions.

-- A.JOINs

-- 1.Display each appointment along with the patient's name and doctor's name.
SELECT a.appointment_id, 
		a.appointment_date,
		a.appointment_time,
		p.first_name AS patients_first_name, 
		p.last_name AS patients_last_name, 
		d.first_name AS doctors_first_name, 
		d.last_name AS doctors_last_name,
		a.reason_for_visit,
		a.status
FROM appointments a
JOIN patients p
	 	ON p.patient_id = a.patient_id
JOIN doctors d
		ON d.doctor_id = a.doctor_id;
		
-- 2.Display patient name, doctor name, appointment date and appointment status.
SELECT a.appointment_date,
		p.first_name AS patients_first_name, 
		p.last_name AS patients_last_name, 
		d.first_name AS doctors_first_name, 
		d.last_name AS doctors_last_name,
		a.status
FROM appointments a
JOIN patients p
	 	ON p.patient_id = a.patient_id
JOIN doctors d
		ON d.doctor_id = a.doctor_id;
		
-- 3.Display doctor name, specialization and total number of appointments.
SELECT d.first_name,
		d.last_name,
		d.specialization, 
		COUNT(a.appointment_id) AS appointment_count
FROM doctors d
JOIN appointments a
		ON d.doctor_id = a.doctor_id
GROUP BY
		d.first_name,
		d.last_name,
		d.specialization
ORDER BY appointment_count DESC;

-- 4.Display patient name, treatment type and treatment cost.
SELECT p.first_name,
		p.last_name,
		t.treatment_type,
		t.cost
FROM patients p 
JOIN appointments a
		ON p.patient_id = a.patient_id
JOIN treatments t
		ON a.appointment_id = t.appointment_id
ORDER BY t.cost DESC;

-- 5.Display patient name, treatment details and billing amount.
SELECT p.first_name AS patients_first_name,
		p.last_name AS patients_last_name,
		t.treatment_id AS treatments_id,
		t.treatment_type AS treatments_type,
		t.description AS treatment_description,
		b.amount
FROM patients p
JOIN billing b
		ON p.patient_id = b.patient_id
JOIN treatments t
		ON t.treatment_id = b.treatment_id
ORDER BY b.amount DESC;

-- 6.Display complete patient → appointment → doctor → treatment → billing information.
SELECT p.first_name AS patients_first_name,
		p.last_name AS patients_last_name,
		a.appointment_date AS appointment_date,
		a.appointment_time AS appointment_time,
		a.status AS appointment_status,
		d.first_name AS doctors_first_name,
		d.last_name AS doctors_last_name,
		t.treatment_type,
		b.bill_id AS billing_id,
		b.amount AS billing_amount,
		b.payment_status
FROM patients p
JOIN appointments a
		ON p.patient_id = a.patient_id
JOIN doctors d
		ON d.doctor_id = a.doctor_id
JOIN treatments t
		ON t.appointment_id = a.appointment_id
JOIN billing b
		ON b.treatment_id = t.treatment_id
ORDER BY billing_amount DESC;
		
-- 7.Find doctors whose average treatment cost is above the overall average.
SELECT d.first_name AS doctors_first_name,
		d.last_name AS doctors_last_name,
		ROUND(AVG(t.cost), 2) AS avg_treatment_cost
FROM doctors d
JOIN appointments a
		ON d.doctor_id = a.doctor_id
JOIN treatments t
		ON t.appointment_id = a.appointment_id
GROUP BY 
    d.doctor_id,
    d.first_name,
    d.last_name
HAVING AVG(t.cost) > 
	(SELECT AVG(t.cost) FROM treatments t)
ORDER BY avg_treatment_cost DESC;

-- 8.Find the doctor who generated the highest total revenue.
SELECT 
    d.doctor_id,
    d.first_name,
    d.last_name,
    SUM(b.amount) AS total_revenue
FROM doctors d
JOIN appointments a
    ON d.doctor_id = a.doctor_id
JOIN treatments t
    ON a.appointment_id = t.appointment_id
JOIN billing b
    ON t.treatment_id = b.treatment_id
GROUP BY 
    d.doctor_id,
    d.first_name,
    d.last_name
ORDER BY total_revenue DESC
LIMIT 1;


-- B. Subqueries

-- 1.Find treatments whose cost is higher than the overall average treatment cost.
SELECT t.treatment_id,
		t.treatment_date,
		t.treatment_type,
		t.cost
FROM treatments t
WHERE t.cost > 
			(SELECT AVG(t.cost) FROM treatments t)
			ORDER BY t.cost DESC;

-- NOTE : To filter individual rows : Use WHERE
-- NOTE : To filter groups : Use HAVING

-- 2.Find doctors whose experience is greater than the average doctor experience.
SELECT doctor_id, 
		first_name,
		last_name, 
		email,
		phone_number
		specialization,
		years_experience
FROM doctors
WHERE years_experience > 
						(SELECT AVG(years_experience) FROM doctors)
ORDER BY years_experience DESC;

-- 3.Find doctors who have handled more appointments than the average doctor appointment count.
SELECT  d.doctor_id, 
		d.first_name,
		d.last_name, 
		d.email,
		d.phone_number,
		d.specialization,
		COUNT(a.appointment_id) AS appointment_count
FROM doctors d
JOIN appointments a
		ON a.doctor_id = d.doctor_id
GROUP BY  d.doctor_id, 
		d.first_name,
		d.last_name
HAVING COUNT(a.appointment_id) > (
    SELECT AVG(appointment_count)
    FROM (
        SELECT COUNT(appointment_id) AS appointment_count
        FROM appointments
        GROUP BY doctor_id
    ) AS doctor_counts
)
ORDER BY appointment_count DESC;

-- 4.Find patients who have more appointments than the average number of appointments per patient.
SELECT p.patient_id, 
		p.first_name,
		p.last_name,
		gender,
		COUNT(a.appointment_id) AS appointment_count
FROM patients p
JOIN appointments a
		ON a.patient_id = p.patient_id
GROUP BY p.patient_id, 
		p.first_name,
		p.last_name,
		p.gender
HAVING COUNT(a.appointment_id) > 
			(SELECT AVG(appointment_count)
			FROM 
			(SELECT COUNT(a.appointment_id) AS appointment_count
			FROM appointments
			GROUP BY patient_id
			) AS patient_count
)
ORDER BY appointment_count DESC;

-- C. CTE — Common Table Expressions

-- 1.Using a CTE, calculate the total appointments handled by each doctor.
WITH doctor_appointments AS (
		SELECT doctor_id,
			COUNT(*) AS appointment_count
		FROM appointments
		GROUP BY doctor_id
)
SELECT * FROM doctor_appointments
ORDER BY appointment_count DESC;

-- 2.Using a CTE, find doctors whose appointment count is above average.
WITH doctor_appointments AS (
    SELECT 
        doctor_id,
        COUNT(*) AS appointment_count
    FROM appointments
    GROUP BY doctor_id
),
average_appointments AS (
    SELECT AVG(appointment_count) AS avg_count
    FROM doctor_appointments
)
SELECT 
    da.doctor_id,
    da.appointment_count
FROM doctor_appointments da
CROSS JOIN average_appointments aa
WHERE da.appointment_count > aa.avg_count
ORDER BY da.appointment_count DESC;
	
-- 3.Using a CTE, calculate monthly appointment counts.
WITH monthly_appointments AS (
    SELECT 
        EXTRACT(MONTH FROM appointment_date) AS month,
        COUNT(*) AS appointment_count
    FROM appointments
    GROUP BY EXTRACT(MONTH FROM appointment_date)
)
SELECT 
    month,
    appointment_count
FROM monthly_appointments
ORDER BY month;
-- 4.Using a CTE, calculate monthly revenue.
WITH monthly_revenue AS (
    SELECT 
        EXTRACT(MONTH FROM bill_date) AS month,
        SUM(amount) AS total_revenue
    FROM billing
    GROUP BY EXTRACT(MONTH FROM bill_date)
)
SELECT 
    month,
    total_revenue
FROM monthly_revenue
ORDER BY month;
-- 5.Using a CTE, calculate revenue generated by each treatment type and identify the highest-revenue treatment.
-- Calculate revenue generated by each treatment type
-- and identify the treatment type with the highest revenue

WITH treatment_revenue AS (
    SELECT 
        t.treatment_type,
        SUM(b.amount) AS total_revenue
    FROM treatments t
    JOIN billing b
        ON t.treatment_id = b.treatment_id
    GROUP BY t.treatment_type
)
SELECT 
    treatment_type,
    total_revenue
FROM treatment_revenue
ORDER BY total_revenue DESC
LIMIT 1;

-- D. Window Functions

-- 1.Rank doctors based on the number of appointments they handled.
SELECT
    d.doctor_id,
    d.first_name,
    d.last_name,
    COUNT(a.appointment_id) AS appointment_count,
    
    RANK() OVER (
        ORDER BY COUNT(a.appointment_id) DESC
    ) AS doctor_rank

FROM doctors d
JOIN appointments a
    ON d.doctor_id = a.doctor_id

GROUP BY
    d.doctor_id,
    d.first_name,
    d.last_name

ORDER BY doctor_rank;

-- 2.Rank doctors based on their total revenue.
SELECT
    d.doctor_id,
    d.first_name,
    d.last_name,
    SUM(b.amount) AS total_revenue,

    RANK() OVER (
        ORDER BY SUM(b.amount) DESC
    ) AS revenue_rank

FROM doctors d
JOIN appointments a
    ON d.doctor_id = a.doctor_id
JOIN treatments t
    ON a.appointment_id = t.appointment_id
JOIN billing b
    ON t.treatment_id = b.treatment_id

GROUP BY
    d.doctor_id,
    d.first_name,
    d.last_name

ORDER BY revenue_rank;

-- 3.Assign a row number to each patient's appointments based on appointment date.
SELECT
    patient_id,
    appointment_id,
    appointment_date,

    ROW_NUMBER() OVER (
        PARTITION BY patient_id
        ORDER BY appointment_date
    ) AS appointment_number

FROM appointments

ORDER BY patient_id, appointment_date;

-- 4.Find each doctor's highest-cost treatment using ROW_NUMBER().
WITH ranked_treatments AS (
    SELECT
        d.doctor_id,
        d.first_name,
        d.last_name,
        t.treatment_id,
        t.treatment_type,
        t.cost,

        ROW_NUMBER() OVER (
            PARTITION BY d.doctor_id
            ORDER BY t.cost DESC
        ) AS treatment_rank

    FROM doctors d
    JOIN appointments a
        ON d.doctor_id = a.doctor_id
    JOIN treatments t
        ON a.appointment_id = t.appointment_id
)

SELECT
    doctor_id,
    first_name,
    last_name,
    treatment_id,
    treatment_type,
    cost
FROM ranked_treatments
WHERE treatment_rank = 1
ORDER BY cost DESC;

-- 5.Rank treatment types based on their average treatment cost.
SELECT
    treatment_type,
    ROUND(AVG(cost), 2) AS avg_treatment_cost,
    RANK() OVER (
        ORDER BY AVG(cost) DESC
    ) AS cost_rank

FROM treatments

GROUP BY treatment_type

ORDER BY cost_rank;

-- E. CASE Statements / Business Logic

-- 1.Categorize patients into age groups:
-- a.Under 18
-- b.18–30
-- c.31–50
-- d.51+
SELECT
    patient_id,
    first_name,
    last_name,
    date_of_birth,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, date_of_birth)) AS age,
    CASE
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, date_of_birth)) < 18
            THEN 'Under 18'
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, date_of_birth)) BETWEEN 18 AND 30
            THEN '18-30'
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, date_of_birth)) BETWEEN 31 AND 50
            THEN '31-50'
        ELSE '51+'
    END AS age_group
FROM patients
ORDER BY age;

-- e.Categorize doctors based on experience:
-- f.Junior
-- g.Mid-level
-- h.Senior
SELECT
    doctor_id,
    first_name,
    last_name,
    years_experience,
    CASE
        WHEN years_experience < 5
            THEN 'Junior'
        WHEN years_experience BETWEEN 5 AND 10
            THEN 'Mid-level'
        ELSE 'Senior'
    END AS experience_level
FROM doctors
ORDER BY years_experience;

-- 2.Categorize treatment costs:
-- a.Low
-- b.Medium
-- c.High
SELECT
    treatment_id,
    treatment_type,
    cost,
    CASE
        WHEN cost < 500 THEN 'Low'
        WHEN cost BETWEEN 500 AND 1000 THEN 'Medium'
        ELSE 'High'
    END AS cost_category
FROM treatments
ORDER BY cost;

-- 3.Create an appointment status category such as:
-- a.Completed
-- b.Cancelled
-- c.Pending
-- d.Other
SELECT
    appointment_id,
    patient_id,
    doctor_id,
    status,
    CASE
        WHEN status = 'Completed' THEN 'Completed'
        WHEN status = 'Cancelled' THEN 'Cancelled'
        WHEN status = 'Pending' THEN 'Pending'
        ELSE 'Other'
    END AS status_category
FROM appointments;

-- 4.Identify high-value billing records based on a threshold.
SELECT
    bill_id,
    patient_id,
    amount,
    payment_method,
    payment_status,
    CASE
        WHEN amount >= 5000 THEN 'High Value'
        ELSE 'Normal Value'
    END AS billing_category
FROM billing
ORDER BY amount DESC;
