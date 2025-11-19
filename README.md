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

## **6. Disconnected Reporting**

The hospital could not generate proper billing or department-level performance reports.
The redesigned database structure now supports **monthly revenue reporting** and department-wise summaries directly from the data.


