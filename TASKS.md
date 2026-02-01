# 📋 Project Tasks: Online Shopping Database

## 📌 Problem Statement
Small to Medium E-commerce businesses often face "Data Anomalies" due to poor database design, leading to:
1.  **Overselling:** Selling products that are out of stock.
2.  **Orphaned Records:** Deleting a user but leaving their orders in the system.
3.  **Lack of Insight:** Inability to track "Customer Lifetime Value" or "Churn Risk."

## 🎯 Project Objectives
* Build a robust **Relational Database Management System (RDBMS)**.
* Implement **ACID Transactions** to ensure financial safety.
* Automate inventory management using **Database Triggers**.
* Visualize sales performance using a **Python Dashboard**.

## ✅ Tasks Completed

### Phase 1: Schema Design
- [x] **ER Modeling:** Designed a schema with Users, Products, Categories, Orders, and Order Items.
- [x] **Normalization:** Achieved 3rd Normal Form (3NF) to reduce data redundancy.
- [x] **Constraints:** Applied `UNIQUE`, `NOT NULL`, and `CHECK` constraints for data validity.

### Phase 2: Backend Logic (SQL)
- [x] **Automated Trigger:** Created `after_order_item_insert` trigger to automatically decrement stock levels.
- [x] **Safe Transactions:** Wrote a Stored Procedure `place_order` using `COMMIT` and `ROLLBACK` to handle payment failures.
- [x] **Complex Queries:** Developed 20 business queries covering Revenue, Customer Segmentation, and Inventory Analysis.

### Phase 3: Data Engineering
- [x] **Synthetic Data:** Used Python (`Faker`) to generate 1,000+ realistic records.
- [x] **Pipeline:** Built a Python-to-MySQL connection pipeline for automated data insertion.

### Phase 4: Business Intelligence
- [x] **KPI Dashboard:** Built a Jupyter Notebook to visualize Monthly Revenue and Category Performance.
- [x] **Customer Analysis:** Identified VIP customers and Churn risks using SQL Aggregation.
- [x] **Technical Report:** Documented the system architecture and performance results in a professional report.