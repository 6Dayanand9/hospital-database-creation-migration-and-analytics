CREATE DATABASE Hospital;
USE Hospital;

SELECT * from hospital_data;

# -----------------------------------------------------BUILDING RDBMS--------------------------------------------------------------

CREATE TABLE department
(
department_id INT PRIMARY KEY AUTO_INCREMENT,
department_name VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE doctors
(
doctor_id INT PRIMARY KEY AUTO_INCREMENT,
doctor_name VARCHAR(60) NOT NULL,
specialization VARCHAR(60) NOT NULL,
role VARCHAR(60) NOT NULL,
department_id INT NOT NULL,
fOREIGN KEY(department_id) 
REFERENCES department(department_id)
);

CREATE TABLE patients
(
patient_id INT AUTO_INCREMENT PRIMARY KEY,
patient_name VARCHAR(60) NOT NULL,
date_of_birth date NOT NULL,
gender CHAR(1) NOT NULL,
phone_no BIGINT NOT NULL
);

ALTER table patients
modify column phone_no BIGINT NOT NULL;

CREATE TABLE appointment
(
	appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_time DATETIME,
    status VARCHAR(60),
    FOREIGN KEY (patient_id)
    REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id)
    REFERENCES doctors(doctor_id),
    CHECK(status in ("cancelled","completed","scheduled"))    
);


CREATE TABLE prescriptions
(
prescription_id INT PRIMARY KEY AUTO_INCREMENT,
appointment_id INT NOT NULL,
medication VARCHAR(60),
Dosage VARCHAR(60),
FOREIGN KEY (appointment_id) 
REFERENCES appointment(appointment_ID)
);

CREATE TABLE bill
( 
bill_id INT PRIMARY KEY AUTO_INCREMENT,
appointment_id INT,
amount DECIMAL(10,2),
bill_paid TINYINT(1),
bill_date datetime,
FOREIGN KEY(appointment_id)
REFERENCES appointment(appointment_id),
CHECK (bill_paid IN (1,0))
);

CREATE TABLE lab_reports
(
report_id INT PRIMARY KEY AUTO_INCREMENT,
appointment_id INT ,
report_data TEXT,
created_at DATETIME,
FOREIGN KEY (appointment_id) 
REFERENCES appointment(appointment_id)
);



SELECT concat('SELECT',group_concat(concat('`',column_name,'`')),'from hospital_data') 
FROM information_schema.columns 
WHERE TABLE_SCHEMA="hospital" 
AND TABLE_NAME="hospital_data"
and COLUMN_NAME like "Departments.%";

INSERT INTO departments (department_id,department_name)
SELECT`Departments.DepartmentID`,`Departments.Name`
FROM hospital_data
WHERE `Departments.DepartmentID`<>'';

SELECT * FROM departments;


SELECT concat('SELECT',group_concat(concat('`',column_name,'`')),'FROM hospital_data') 
FROM information_schema.columns 
WHERE TABLE_SCHEMA="hospital" 
AND TABLE_NAME="hospital_data"
and COLUMN_NAME like "Doctors.%";

INSERT INTO doctors(department_id,doctor_id,doctor_name,role,specialization)
SELECT `Doctors.DepartmentID`,`Doctors.DoctorID`,
`Doctors.Name`,`Doctors.Role`,
`Doctors.Specialization`
FROM hospital_data 
WHERE `Doctors.DepartmentID`<>'';

SELECT * FROM doctors;

SELECT concat('SELECT',group_concat(concat('`',column_name,'`')),'FROM hospital_data') 
FROM information_schema.columns 
WHERE TABLE_SCHEMA="hospital" 
AND TABLE_NAME="hospital_data"
and COLUMN_NAME like "patients.%";

# Date format converted
SELECT 
STR_TO_DATE(`Patients.DateOfBirth`, '%Y-%m-%d')AS formatted_dob
FROM hospital_data
WHERE `Patients.PatientID` <> '';

INSERT INTO patients(date_of_birth,gender,patient_name,patient_id,phone_no)
SELECT
STR_TO_DATE(`Patients.DateOfBirth`, '%d-%m-%Y'),`Patients.Gender`,
`Patients.Name`,`Patients.PatientID`,
`Patients.Phone`
FROM hospital_data WHERE `Patients.PatientID`<>'';

SELECT * FROM patients;


SELECT concat('SELECT',group_concat(concat('`',column_name,'`')),'FROM hospital_data') 
FROM information_schema.columns 
WHERE TABLE_SCHEMA="hospital" 
AND TABLE_NAME="hospital_data"
and COLUMN_NAME like "appointments.%";


INSERT INTO 
appointments(appointment_id,appointment_time,doctor_id,patient_id,status)
SELECT
`Appointments.AppointmentID`,
str_to_date(`Appointments.AppointmentTime`,'%d-%m-%Y %H:%i'),
`Appointments.DoctorID`,`Appointments.PatientID`,
`Appointments.Status`
FROM hospital_data;

SELECT * from appointments;


# ----------------------------------------PRESCRIPTION----------------------------------------------------

SELECT concat('SELECT',group_concat(concat('`',column_name,'`')),'FROM hospital_data') 
FROM information_schema.columns 
WHERE TABLE_SCHEMA="hospital" 
AND TABLE_NAME="hospital_data"
and COLUMN_NAME like "prescriptions.%";


INSERT INTO prescriptions (appointment_id,dosage,medication,prescription_id)
SELECT
`Prescriptions.AppointmentID`,`Prescriptions.Dosage`,
`Prescriptions.Medication`,`Prescriptions.PrescriptionID`
FROM hospital_data WHERE `Prescriptions.AppointmentID`<>'';

SELECT * FROM prescriptions;

SELECT concat('SELECT',group_concat(concat('`',column_name,'`')),'FROM hospital_data') 
FROM information_schema.columns 
WHERE TABLE_SCHEMA="hospital" 
AND TABLE_NAME="hospital_data"
and COLUMN_NAME like "labreports.%";

INSERT INTO  lab_reports(appointment_id,created_at,report_data,report_id)
SELECT
`LabReports.AppointmentID`,`LabReports.CreatedAt`,
`LabReports.ReportData`,`LabReports.ReportID`
FROM hospital_data WHERE `LabReports.AppointmentID`<>'';

SELECT * FROM lab_reports;

SELECT concat('SELECT',group_concat(concat('`',column_name,'`')),'FROM hospital_data') 
FROM information_schema.columns 
WHERE TABLE_SCHEMA="hospital" 
AND TABLE_NAME="hospital_data"
and COLUMN_NAME like "bills.%";

INSERT INTO bill(amount,appointment_id,bill_date,bill_id,bill_paid)
SELECT
`Bills.Amount`,`Bills.AppointmentID`,
`Bills.BillDate`,`Bills.BillID`,`Bills.Paid`
FROM hospital_data 
WHERE `Bills.AppointmentID`<>'';

SELECT * FROM Bill;

# --------------------------------------------POINT NO 4---------------------------------------------------------

DELIMITER $$
CREATE TRIGGER check_new_appointment
BEFORE INSERT ON appointments FOR EACH ROW
BEGIN
	IF NEW.appointment_time<NOW()
		THEN SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'ERROR : appointment cannot be in the past ';
		END IF;
	
    IF EXISTS
		(SELECT * FROM appointments
        WHERE doctor_id = NEW.doctor_id 
        AND appointment_time = NEW.appointment_time 
        AND status IN ('SCHEDULED'))
			THEN SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'ERROR: doctor already has the appointment at that time';
	ENd IF;
END $$
DELIMITER ;

# -------------------------------------------POINT NO 5-------------------------------------------------

SELECT * FROM doctor_credentials;

DELIMITER $$
CREATE PROCEDURE view_doctor_data (IN input_username VARCHAR(100),IN input_password VARCHAR(100))
BEGIN 
	DECLARE doc_id INT;
    DECLARE doc_role VARCHAR(60);
    DECLARE dept_id VARCHAR(60);
    
    # CHECK DOCTOR CRENDENTIAL
    SELECT doctor_id INTO doc_id FROM doctor_credentials 
    WHERE user_name = input_username and password = input_password;
    
    # GET  ROLE AND DEPARTMENT OF DOCTOR
    SELECT role,department_id 
    INTO doc_role,dept_id
    FROM doctors WHERE doctor_id = doc_id;
    
    # SHOWING DOCTOR AND PATIENT INFO
    IF doc_role="Senior" 
    THEN
    SELECT t1.patient_name,t1.gender,t1.phone_no,
    t2.appointment_time,t2.status,t4.medication,t4.dosage,t5.report_data,t3.department_id,t3.doctor_id
    FROM patients t1
    JOIN appointments t2 ON t1.patient_id = t2.patient_id
	JOIN doctors t3 on t2.doctor_id = t3.doctor_id
    LEFT JOIN prescriptions t4 on t2.appointment_id = t4.appointment_id
    LEFT JOIN lab_reports t5 ON t5.appointment_id = t2.appointment_id
    WHERE department_id = dept_id;
    
    ELSE
		SELECT t1.patient_name,t1.gender,t1.phone_no,
		t2.appointment_time,t2.status,t4.medication,t4.dosage,t5.report_data,t3.department_id,t3.doctor_id
		FROM patients t1
		JOIN appointments t2 ON t1.patient_id = t2.patient_id
		JOIN doctors t3 on t2.doctor_id = t3.doctor_id
		LEFT JOIN prescriptions t4 on t2.appointment_id = t4.appointment_id
		LEFT JOIN lab_reports t5 ON t5.appointment_id = t2.appointment_id
		WHERE t2.doctor_id = doc_id 
        ORDER BY appointment_time DESC;
	END IF ;
    
    
END$$
DELIMITER ;


CALL view_doctor_data('doctor15','luZ1Rxvc');


# -------------------------------------------POINT NO 6-------------------------------------------------

## MONTH WISE amount by department

SELECT t4.department_id,MONTHNAME(bill_date) as MNAME,sum(amount) as total_amount FROM bill t1
JOIN appointments t2
on t1.appointment_id = t2.appointment_id
join doctors t3 on t3.doctor_id = t2.doctor_id
JOin departments t4 ON t3.department_id = t4.department_id
GROUP BY department_id,MONTHNAME(bill_date);

DELIMITER $$
CREATE PROCEDURE MONTHLY_REVENUE(IN input_year INT,IN input_month INT)
BEGIN
	SELECT t4.department_id,MONTH(bill_date) as MNAME,sum(amount) as total_amount FROM bill t1
	JOIN appointments t2
	ON t1.appointment_id = t2.appointment_id
	JOIN doctors t3 ON t3.doctor_id = t2.doctor_id
	JOIN departments t4 ON t3.department_id = t4.department_id
    WHERE month(bill_date)=input_month AND YEAR(bill_date)=input_year
	GROUP BY department_id,MONTH(bill_date);
END $$
DELIMITER ;

CALL MONTHLY_REVENUE(2024,6)
    
    
DELIMITER $$

CREATE PROCEDURE MONTHLY_REVENUEE(
    IN input_year INT,
    IN input_month INT
)
BEGIN
    SELECT 
        t4.department_id,
        MONTH(bill_date) AS month_no,
        SUM(amount) AS total_amount
    FROM bill t1
    JOIN appointments t2 ON t1.appointment_id = t2.appointment_id
    JOIN doctors t3 ON t3.doctor_id = t2.doctor_id
    JOIN departments t4 ON t3.department_id = t4.department_id
    WHERE 
        -- MONTH filter only if input_month is not NULL
        (input_month IS NULL OR MONTH(bill_date) = input_month)
        
        AND
        
        -- YEAR filter only if input_year is not NULL
        (input_year IS NULL OR YEAR(bill_date) = input_year)
    GROUP BY 
        t4.department_id, MONTH(bill_date)
    ORDER BY 
        t4.department_id, MONTH(bill_date);
END$$

DELIMITER ;

# -------------------------------7 AUDIT LOG----------------------------------------

CREATE TABLE AUDIT_LOG (
  LOG_ID INT AUTO_INCREMENT PRIMARY KEY,
  TABLE_NAME VARCHAR(50),
  OPERATION VARCHAR(10),
  RECORD_ID INT,
  USER_NAME VARCHAR(50),
  OLD_VALUE TEXT,
  NEW_VALUE TEXT,
  TIMESTAMP DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$
CREATE TRIGGER AFTER_APPOINTMENT_UPDATE
AFTER UPDATE ON APPOINTMENTS
FOR EACH ROW
BEGIN
  INSERT INTO AUDIT_LOG (TABLE_NAME, OPERATION, RECORD_ID, USER_NAME,OLD_VALUE, NEW_VALUE)
  VALUES ('APPOINTMENTS', 'UPDATE', NEW.APPOINTMENT_ID, USER(),OLD.Status, NEW.Status);
END$$
DELIMITER ;



UPDATE appointments
set status="completed" where appointment_id=12;



SELECT * from audit_log;