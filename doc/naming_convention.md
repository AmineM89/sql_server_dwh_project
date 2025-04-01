# NAMING CONVENTION

## General Principle
- **Naming Convention**: `snake_case` with lower case letters and underscore (`_`) separator.
- **Language**: English for all namings.
- **Reserved words**: Avoid using SQL reserved words.

## Table Naming Convention

### Bronze Rules
- All tables must begin with the source system followed by the unchanged CSV file name.
- Format: `<source_system>_<entity>`
  - `<source_system>`: The name of the source system (e.g., `crm` or `erp`).
  - `<entity>`: The name of the CSV file without the extension (e.g., `cust_info`).
  - **Example**: `crm_cust_info` → customer information from CRM system.

### Silver Rules
- All tables must begin with the source system, and the table names must match the original table name.
- Format: `<source_system>_<entity>`
  - `<source_system>`: The name of the source system (e.g., `crm` or `erp`).
  - `<entity>`: Same name as the original source system table (e.g., `cust_info`).
  - **Example**: `crm_cust_info` → customer information from CRM system.

### Gold Rules
- All namings must be meaningful and business-aligned, starting with the category prefix.
- Format: `<category>_<entity>`
  - `<category>`: Describes the role of the table (e.g., `dim` (dimension table) or `fact` (fact table)).
  - `<entity>`: Descriptive name of the table aligned with business domain (e.g., `product`, `customer`, `sales`).
  - **Example**: `dim_customer` or `fact_sales`.

## Glossary of Table Categories

| Category | Meaning           | Example             |
|----------|------------------|---------------------|
| `dim_`   | Dimension table   | `dim_customer`, `dim_product` |
| `fact_`  | Fact table        | `fact_sales` |
| `agg_`   | Aggregated table  | `agg_sales_monthly` |

## Columns Naming Convention

### Surrogate Key
- Use the `_key` suffix for surrogate keys in dimension tables.
- Format: `<table>_key`
  - `<table>`: Name of the dimension table.
  - **Example**: `customer_key` → Name of the surrogate key in the `dim_customer` table.

### Metadata Columns
- All metadata columns must start with the prefix `_dwh`.
- Format: `_dwh_<column_name>`
- **Example**: `_dwh_load_date`

## Stored Procedure Naming Convention
- Add prefix `load_` for each layer.
- Format: `load_<layer>` where `<layer>` corresponds to `bronze`, `silver`, and `gold`.
- **Example**: `load_bronze` and `load_silver`.
