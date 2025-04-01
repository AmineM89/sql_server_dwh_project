# SQL Server DATA WAREHOUSE PROJECT

## 📌 Project Overview
This project involves building a **SQL Server-based Data Warehouse** with an **ETL pipeline** to process and integrate data from ERP and CRM systems. The solution follows the **Medallion Architecture** (Bronze, Silver, Gold layers) and ensures optimized reporting with a **star schema**.

## 📂 Data Sources
- **CRM System:** Provides CSV files with:
  - `sales_details` (transactional data)
  - `customer_info` (customer details)
  - `product_info` (product metadata)
- **ERP System:** Provides three additional CSV files with customer and product information.
- **CSV File Characteristics:**
  - Comma-delimited
  - Includes headers
  - No schema enforcement at the source

## 🏗️ Architecture
The project follows the **Medallion Architecture**, structured as:


### 1️⃣ Bronze Layer (Raw Data)
- Stores into tables the CSV files data from ERP and CRM.
- Ingested via **stored procedures** in SQL Server.
- No transformations applied at this stage.

### 2️⃣ Silver Layer (Cleaned & Processed Data)
- Data is cleansed and validated.
- **Deduplication, type conversions, missing value handling.**
- Stored in structured tables.

### 3️⃣ Gold Layer (Business Intelligence Schema)
- Star schema designed for analytical queries.
- Views are created for BI consumption.
- Indexed and optimized for fast querying.

![My Image](doc/data_architecture.png)

## 🛠️ Technologies Used
- **Database:** Microsoft SQL Server
- **Storage:** CSV files stored locally or in cloud storage
- **Automation:**
  - **SQL Server Agent** for scheduled executions.

## 🔄 Data Transformations
In this project many transformation was made for cleansing the silver layer:
Remove duplicates
Remove NULL values
Data enrichment
Data standardization
Data normalization
1. **Ingestion (Bronze Layer):**
   - Load raw CSV files into staging tables.
   - No transformations applied.
2. **Cleansing (Silver Layer):**
   - Standardize data types.
   - Deduplicate records.
   - Validate referential integrity.
   - Apply business rules.
3. **Aggregation & Integration (Gold Layer):**
   - Create a **star schema** (fact & dimension tables).
   - Implement indexing & optimization.
   - Expose final data via **views** for reporting.

## 📊 Data Model
- **Fact Table:** `fact_sales`
- **Dimension Tables:**
  - `dim_customer`
  - `dim_product`
  - `dim_date`
- **Relationships:**
  - `fact_sales` links to `dim_customer` and `dim_product` via foreign keys.
  - `dim_date` provides time-based aggregations.

## 📝 Documentation & Project Management
The project was managed using an **Agile methodology** with **Notion** to track:
- **Data Architecture Diagrams** 📌
- **Data Flow Diagrams** 🔄
- **Data Catalog** 📚
- **Naming Conventions** (`snake_case` for consistency) 🏷️
- **Conceptual Model & Star Schema Design** 🌟

## 🚀 Execution & Automation
- **Stored Procedures** were used to load and transform data:
  - `usp_load_bronze`
  - `usp_load_silver`
  - Views created for **gold layer** reporting.
- **Triggering ETL Process:**
  - **SQL Server Agent** (if available) for scheduling.
  - **PowerShell + Task Scheduler** as an alternative.

## ⚡ Performance & Error Handling
- **Performance Enhancements:**
  - Bulk inserts for efficiency.
  - Indexed fact & dimension tables.
  - Pre-aggregated data for reporting.
- **Error Handling Strategy:**
  - Invalid records logged in an **error table**.
  - Data failures are tracked with timestamps.

## ✅ Project Deliverables
✔️ Fully operational **ETL pipeline** in SQL Server.
✔️ **Star schema** for analytical reporting.
✔️ Documented **data sources, transformations, and schema**.
✔️ **Optimized performance** for large-scale processing.
✔️ **Error-handling mechanisms** for reliability.


📌 **Author:** Amine Mohabeddine  