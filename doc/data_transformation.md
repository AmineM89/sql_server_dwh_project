# DATA TRANSFORMATIONS

## CRM Source

### cust_info Table

#### Handeling duplicates in `cst_id` column

| cst_id | cst_firstname | cst_lastname | cst_marital_status | cst_gndr | cst_create_date |
|--------|--------------|-------------|--------------------|---------|----------------|
| 29433  | NULL         | NULL        | M                  | M       | 25/01/2026     |
| 29433  | Thomas      | King        | M                  | M       | 27/01/2026     |
| 29449  | NULL        | Chen        | S                  | NULL    | 25/01/2026     |
| 29449  | Laura       | Chen        | S                  | F       | 26/01/2026     |
| 29466  | NULL        | NULL        | NULL               | NULL    | 25/01/2026     |
| 29466  | Lance       | Jimenez     | M                  | NULL    | 26/01/2026     |
| 29466  | Lance       | Jimenez     | M                  | M       | 27/01/2026     |
| 29473  | Carmen      | NULL        | NULL               | NULL    | 25/01/2026     |
| 29473  | Carmen      | Subram      | S                  | NULL    | 26/01/2026     |
| 29483  | NULL        | Navarro     | NULL               | NULL    | 25/01/2026     |
| 29483  | Marc        | Navarro     | M                  | NULL    | 27/01/2026     |

- Last created record is the most complete → Keep the `cst_id` with the latest `cst_create_date`.

#### Handeling missiong values & filtering in `cst_id` column

| cst_id | cst_key  | cst_firstname | cst_lastname | cst_marital_status | cst_gndr | cst_create_date |
|--------|---------|--------------|-------------|--------------------|---------|----------------|
| NULL   | SF566   | NULL         | NULL        | NULL               | NULL    | NULL          |
| NULL   | PO25    | NULL         | NULL        | NULL               | NULL    | NULL          |
| NULL   | 13451235| NULL         | NULL        | NULL               | NULL    | NULL          |
| NULL   | A01Ass  | NULL         | NULL        | NULL               | NULL    | NULL          |

- `cst_key` not present in the remaining sources
- No data enrichment possible.
→ Drop NULL values.

### Date data type casting for `cst_create_date` column
- Cast `cst_create_date` column into date format.

### Handeling unwanted spaces in `cst_firstname` & `cst_lastname`
- Remove misplaced spaces in both columns.

### Standardization of `cst_marital_status` & `cst_gndr` columns

Distint values of `cst_gndr` & `cst_marital_status` columns:

| cst_gndr | cst_marital_status |
|----------|--------------------|
| NULL     | S                  |
| F        | NULL               |
| M        | M                  |


- `cst_gndr` standardization:
  - M → Male
  - F → Female
  - NULL → n/a
- `cst_marital_status` standardization:
  - S → Single
  - M → Married
  - NULL → n/a

## prd_info Table

### Column splitting in `prd_key`

| prd_key           | cat_id  | prd_key        |
|------------------|--------|--------------|
| CO-RF-FR-R92B-58 | CO-RF  | FR-R92B-58   |
| AC-HE-HL-U509-R  | AC-HE  | HL-U509-R    |

- Split `prd_key` into `cat_id` (first 5 characters) and `prd_key` (remaining characters).

### Handling missing values in `prd_cost`
- Replace NULL values with 0.

### Standardization of `prd_line`

Distinct values of `prd_line`:
| prd_line |
|----------|
| NULL     |
| M        |
| R        |
| S        |
| T        |

- NULL → ‘Other’
- M → ‘Mountain’
- R → ‘Road’
- S → ‘Sport’
- T → ‘Touring’

### Handeling unvalid values (when `prd_end_dt` < `prd_start_dt`)
The historical data of the products are kept in the table `prd_info`, for handeling these unvalid value we procede as follows:
- If `prd_key` is the last product update → `prd_end_dt` should be NULL.
- If multiple records exist → `prd_end_dt` should be set to day before the next period starts.

**Example of correct `prd_end_dt` values:**

| prd_key  | prd_cost | prd_line | prd_start_dt | prd_end_dt |
|----------|---------|---------|-------------|------------|
| HL-U509-B | 12      | Sport   | 01/07/2011  | 06/01/2012 |
| HL-U509-B | 14      | Sport   | 01/07/2012  | 06/01/2013 |
| HL-U509-B | 13      | Sport   | 01/07/2013  | NULL       |

## sales_details Table

### Casting date data type
- `sls_order_dt` contains invalid date formats (<8 characters) → Replace these values with NULL.
- Apply the same transformation to other date columns for precaussion.

### Handeling unvalid values & derived columns in sales metrics 
- `sls_sales` & `sls_price` contain NULLs and negative values.
- Some `sls_sales` values do not match the formula:
  ```
  sls_sales = sls_quantity * sls_price
  ```
  
  → Replace incorrect `sls_sales` with `abs(sls_quantity * sls_price)`.
  → Replace NULL and negative values of `sls_price` with `abs(sls_sales/sls_quantity)`.

## ERP Source

### LOC_A101 Table

#### CID Standardization
- Remove the dash (`-`) in CID to match customer IDs in other tables.

#### County Standardization
- `DE` or `Germany` → `Germany`
- `US`, `USA`, or `United States` → `United States`
- NULL or empty values → `n/a`

### PX_CAT_G1V2 Table

#### ID Standardization
- Replace underscores (`_`) in ID with dashes (`-`) to match IDs in other tables.

### CUST_AZ12 Table

#### CID Standardization
- Remove `NAS` prefix in `CID` to match other customer IDs.

**Example:**
- `NASAW00011000` → `AW00011000`

### Handeling unvalid values (Birthdate Out of Range)
- Birthdates in 2025 or later are incorrect → Replace with NULL.

### GEN Standardization
- `F` → `Female`
- `M` → `Male`
- NULL or empty values → `n/a

## Integration of ERP source into CRM data

When integrating ERP data into CRM data, we noticed some conflict between `cst_gndr` column from `crm_cust_info` and `GEN` columns from `erp_CUST_AZ12` as shown in the table below:

|cst_gndr  |GEN      |
|----------|---------|
|Male      |Male     |
|❌Male    |❌Female|
|Male      |n/a      |
|❌Female  |❌Male  |
|Female     |Female  |
|Female     |n/a     |
|n/a        |Male    |
|n/a        |Female  |
|n/a        |n/a     |

The master is the CRM system, so if there is a conflict between the two columns we select the `cst_gndr` value. The only integration from `GEN` column are when the value of `cst_gndr` is 'n/a'