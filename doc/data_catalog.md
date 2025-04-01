# Data Catalog

## Overview
This data catalog provides a structured description of the datasets available in the **gold** layer of the data warehouse. The catalog includes detailed metadata for each table, specifying column names, data types, descriptions, and additional constraints.

The data warehouse consists of **dimension tables** (`dim_customers`, `dim_products`) and a **fact table** (`fact_sales`).

- **Dimension Tables**: Store descriptive attributes (e.g., customer and product details).
- **Fact Table**: Stores transactional data related to sales.

## Table Descriptions

### 1. `gold.dim_customers`
This table contains information about customers, including demographic attributes and unique identifiers.

| Column Name      | Type          | Description                                              | Additional Info |
|------------------|--------------|----------------------------------------------------------|----------------|
| customer_key     | INT          | Surrogate key uniquely identifying each customer         | Primary Key, Not NULL |
| customer_id      | INT          | Unique numerical code assigned to each customer         | Unique, Not NULL |
| customer_number  | VARCHAR(50)  | Unique alphabetical code assigned to each customer      | Unique, Not NULL |
| first_name       | VARCHAR(50)  | The first name of the customer                          | Not NULL |
| last_name        | VARCHAR(50)  | The last name of the customer                           | Not NULL |
| gender          | VARCHAR(50)  | The gender of the customer                             | Values: 'Male', 'Female', 'n/a', Not NULL |
| country         | VARCHAR(50)  | The customer's country of residence (e.g., 'United States') | Not NULL |
| marital_status  | VARCHAR(50)  | The marital status of the customer                     | Values: 'Single', 'Married', 'n/a', Not NULL |
| create_date     | DATE         | The date when the customer was created in the system (YYYY-MM-DD) | May be NULL |
| birth_date      | DATE         | The birthdate of the customer (YYYY-MM-DD)             | May be NULL |

### 2. `gold.dim_products`
This table stores product-related attributes, including category, subcategory, and pricing information.

| Column Name     | Type          | Description                                             | Additional Info |
|----------------|--------------|---------------------------------------------------------|----------------|
| product_key    | INT          | Surrogate key uniquely identifying each product        | Primary Key, Not NULL |
| product_id     | INT          | Unique numerical code assigned to each product        | Unique, Not NULL |
| product_number | VARCHAR(50)  | Unique alphabetical code assigned to each product     | Unique, Not NULL |
| category_id    | VARCHAR(50)  | Alphabetical code associated with each category       | Not NULL |
| product_name   | VARCHAR(50)  | The name of the product                               | Not NULL |
| category       | VARCHAR(50)  | The category in which the product belongs            | Not NULL |
| subcategory    | VARCHAR(50)  | The subcategory in which the product belongs         | Not NULL |
| product_line   | VARCHAR(50)  | The product line (e.g., Mountain, Sport, Road)       | Values: 'Mountain', 'Sport', 'Touring', 'Road', 'Other', Not NULL |
| maintenance    | VARCHAR(50)  | Indicates if the product requires maintenance        | Values: 'Yes' or 'No' |
| cost          | INT          | Integer value representing the cost of the product   | Value can be 0 |
| product_start_date | DATE    | The date when the product starts selling            | Not NULL |

### 3. `gold.fact_sales`
This table stores transactional sales data, including order details and sales metrics.

| Column Name     | Type         | Description                                           | Additional Info |
|---------------|-------------|------------------------------------------------------|----------------|
| order_id     | VARCHAR(50) | Alphabetical code assigned to each order            | Not NULL, an order may contain multiple products |
| customer_key | INT         | Numerical code assigned to each customer            | Foreign Key, Not NULL |
| product_key  | INT         | Numerical code assigned to each product             | Foreign Key, Not NULL |
| order_date   | DATE        | The date when the order is placed (YYYY-MM-DD)      | Not NULL |
| ship_date    | DATE        | The date when the order is shipped (YYYY-MM-DD)     | Not NULL |
| due_date     | DATE        | The maximum date when the order must be shipped (YYYY-MM-DD) | Not NULL |
| sales_value  | INT         | The value corresponding to the ordered product quantity | Value >= 0, Not NULL |
| quantity     | INT         | The quantity of the ordered product                 | Value >= 0 |
| unit_price   | INT         | The price per unit of the ordered product          | Value >= 0 |

## Conclusion
This data catalog provides a structured reference for understanding the contents and constraints of the `gold` dataset. Ensuring data consistency and integrity is crucial for analytics and reporting purposes. Future enhancements could include adding data lineage information, update timestamps, and additional business rules.
