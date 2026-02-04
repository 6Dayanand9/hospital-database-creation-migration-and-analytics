# hospital-database-creation-migration-and-analytics

## 📌 Problem Statement: Hospital Database Migration & Automation

### **Background**

Our hospital was originally managing all its information—patients, doctors, appointments, prescriptions, lab results, and billing—using Excel files. As operations grew, this approach became slow, error-prone, and extremely difficult to maintain. To improve data integrity, scalability, and overall performance, I decided to redesign the entire system using a **relational database model**.

### **Project Overview**

In this project, I built a clean and structured database that can support all major functions of the hospital. Instead of scattered and unconnected Excel sheets, the new system brings everything together with proper relationships, consistent rules, and secure access.

The goal is not only to design the database but also to **migrate the existing Excel data** into the new structure while preserving accuracy and consistency. The database also includes the logic needed for appointment management, controlled access to patient data, and department-wise reporting such as **monthly revenue summaries**.

# 🚨 Problems Addressed in the Database Design

## **1. Lack of Unique Identifiers**

Previously, there were no guaranteed unique IDs for patients, doctors, departments, or appointments.
I introduced **strict unique identifiers** to ensure every entity can be tracked accurately and reliably.


## **2. Disconnected Relationships**

The Excel-based approach had no enforced links between key entities like patients, doctors, and appointments.
In the new design, I created proper **foreign key relationships** to maintain a clear and consistent connection across all hospital operations.


## **3. Invalid or Ambiguous Data Entries**

The old system contained inconsistent gender values, invalid appointment statuses, and mixed date formats.
To prevent this, I implemented **data validation rules** such as:

* Standardized gender values: `M`, `F`, `O`
* Valid appointment statuses: `Scheduled`, `Completed`, `Cancelled`
* Uniform date formats across all tables


## **4. Unregulated Scheduling**

Doctors were often double-booked due to the lack of scheduling checks.
The new database enforces rules that prevent overlapping or conflicting appointments.


## **5. Unrestricted Access to Patient Information**

All doctors could view all patient data regardless of department or relevance.
To fix this, I introduced **role-based access logic**, where:

* Doctors can only access patients assigned to them
* Senior doctors can access the entire department’s patient data


Here’s a **clean, professional, and visually appealing `README.md`** you can directly use for your GitHub / portfolio project.
It’s written like a real-world database project README, not classroom-style 👌

---

# 🏥 Hospital Management System – SQL (RDBMS Project)

A complete **Relational Database Management System (RDBMS)** project designed for a hospital environment.
This project demonstrates **database design, normalization, data migration, constraints, triggers, stored procedures, and audit logging** using **MySQL**.

---

## 📌 Project Overview

The Hospital Management System manages core hospital operations such as:

* Departments & Doctors
* Patients & Appointments
* Prescriptions & Lab Reports
* Billing & Revenue Analysis
* Access-based data visibility
* Audit logging for data changes

The system is built by transforming a **denormalized source table (`hospital_data`)** into a **fully normalized relational database**.

---

## 🧱 Database Schema Design

### 📂 Core Tables

| Table Name      | Description                            |
| --------------- | -------------------------------------- |
| `department`    | Stores hospital departments            |
| `doctors`       | Doctor details with department mapping |
| `patients`      | Patient demographic information        |
| `appointments`  | Doctor–Patient appointment records     |
| `prescriptions` | Medicines prescribed per appointment   |
| `lab_reports`   | Diagnostic reports                     |
| `bill`          | Billing and payment information        |
| `audit_log`     | Tracks updates for critical tables     |

---

## 🔗 Relationships

* One **Department** → Many **Doctors**
* One **Doctor** → Many **Appointments**
* One **Patient** → Many **Appointments**
* One **Appointment** → One/Many **Prescriptions**, **Lab Reports**, **Bills**

All relationships are enforced using **Foreign Keys** for data integrity.

---

## 🔒 Constraints & Validations

* **CHECK Constraints**

  * Appointment status: `scheduled`, `completed`, `cancelled`
  * Bill paid status: `0 / 1`
* **NOT NULL & UNIQUE Constraints**
* **Date validations** using triggers

---

## ⚙️ Triggers Implemented

### ⏰ Appointment Validation Trigger

**Trigger:** `check_new_appointment`
**Before INSERT on `appointments`**

Validations:

* Appointment **cannot be scheduled in the past**
* A doctor **cannot have overlapping appointments**

---

### 🧾 Audit Logging Trigger

**Trigger:** `AFTER_APPOINTMENT_UPDATE`

* Automatically logs appointment status updates
* Stores:

  * Table name
  * Operation type
  * Old & New values
  * User performing the action
  * Timestamp

This ensures **data traceability and compliance**.

---

## 🔐 Role-Based Access Using Stored Procedure

### 📄 `view_doctor_data`

Doctors can view patient data based on **role**:

* **Senior Doctors**

  * Can view **all patients within their department**
* **Junior Doctors**

  * Can view **only their own appointments**

Authentication is validated using `doctor_credentials`.

---

## 📊 Revenue Analysis & Reporting

### 🗓 Monthly Revenue by Department

Stored procedures allow:

* Month-wise revenue analysis
* Year & Month filtering (optional)
* Department-level aggregation

Procedures:

* `MONTHLY_REVENUE`
* `MONTHLY_REVENUEE` (supports NULL filters)

---

## 🔁 Data Migration Strategy

* Source data loaded from **`hospital_data`**
* Used:

  * `INFORMATION_SCHEMA` to dynamically fetch column names
  * `STR_TO_DATE()` for date standardization
* Incremental inserts performed into normalized tables

---

## 🧠 Key SQL Concepts Demonstrated

* Database normalization (1NF → 3NF)
* Foreign keys & referential integrity
* Triggers (BEFORE & AFTER)
* Stored procedures with conditional logic
* Dynamic SQL
* Audit logging
* Date & time handling
* Aggregations & joins

---

## 🛠 Technologies Used

* **Database:** MySQL
* **Concepts:** RDBMS, SQL, Triggers, Procedures
* **Tools:** MySQL Workbench / CLI

---

## 🚀 Future Enhancements

* Indexing for performance optimization
* Role-based user management
* Appointment rescheduling logic
* Views for reporting
* API integration (FastAPI / Flask)

---

## 👨‍⚕️ Ideal Use Case

* Hospital administration systems
* Healthcare analytics projects
* SQL portfolio project for **Data Analyst / Data Engineer / Backend roles**

---

If you want, I can also:

* Add **ER diagram**
* Optimize queries
* Convert this into **GitHub-ready format**
* Write **project explanation for interviews**

Just say the word 👌


## **6. Disconnected Reporting**

The hospital could not generate proper billing or department-level performance reports.
The redesigned database structure now supports **monthly revenue reporting** and department-wise summaries directly from the data.


