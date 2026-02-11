# 🏢 Data Warehouse – Gold Layer Data Catalog

## 📌 Project Overview

This repository contains the **Data Catalog documentation** for the **Gold layer** of a Data Warehouse project.

The Gold layer represents the **business-ready analytical model** structured using a **Star Schema** design.

It includes:

* 🟡 Dimension Tables
* 🔵 Fact Table
* 📚 Column-level documentation
* 🔑 Primary & Foreign key relationships
* 📊 Analytical-ready structure

---

## 🏗️ Data Model Architecture

The Gold layer follows a **Star Schema** design:

```
           dim_customers
                |
                |
            fact_sales
                |
                |
           dim_products
```

### Tables Included:

| Table Name    | Type      | Description                         |
| ------------- | --------- | ----------------------------------- |
| dim_customers | Dimension | Customer demographic information    |
| dim_products  | Dimension | Product details and classifications |
| fact_sales    | Fact      | Sales transaction data              |

---

# 🟡 Dimension: dim_customers

Contains customer demographic attributes used for business analysis.

### 🔑 Primary Key:

`customer_key`

| Column Name     | Data Type    | Description                            |
| --------------- | ------------ | -------------------------------------- |
| customer_key    | bigint       | Surrogate primary key                  |
| customer_id     | int          | Business customer ID                   |
| customer_number | nvarchar(50) | Unique customer number                 |
| first_name      | nvarchar(50) | Customer first name                    |
| last_name       | nvarchar(50) | Customer last name                     |
| country         | nvarchar(50) | Country of residence                   |
| gender          | nvarchar(50) | Customer gender (Male, Female, N/A)    |
| marital_status  | nvarchar(50) | Marital status (Single, Married)       |
| birth_date      | date         | Date of birth  formatted as YYYY-MM-DD |
| create_date     | date         | Record creation date                   |

---

# 🟡 Dimension: dim_products

Contains product attributes and classification information.

### 🔑 Primary Key:

`product_key`

| Column Name    | Data Type    | Description                                              |
| -------------- | ------------ | -------------------------------------------------------- |
| product_key    | bigint       | Surrogate primary key                                    |
| product_id     | int          | Business product ID                                      |
| product_number | nvarchar(50) | Unique product number                                    |
| product_name   | nvarchar(50) | Product name                                             |
| category_id    | nvarchar(50) | Product category ID                                      |
| category       | nvarchar(50) | Product category name                                    |
| subcategory    | nvarchar(50) | Product subcategory                                      |
| maintenance    | nvarchar(50) | Maintenance classification (Yes, No)                     |
| cost           | int          | Product cost                                             |
| product_line   | nvarchar(50) | Product line                                             |
| start_date     | date         | Product availability start date, formatted as YYYY-MM-DD |

---

# 🔵 Fact: fact_sales

Contains transactional sales data linking customers and products.

### 🔑 Foreign Keys:

* `product_key` → dim_products.product_key
* `customer_key` → dim_customers.customer_key

| Column Name   | Data Type    | Description                                     |
| ------------- | ------------ | ----------------------------------------------- |
| order_number  | nvarchar(50) | Sales order number                              |
| product_key   | bigint       | Product reference key                           |
| customer_key  | bigint       | Customer reference key                          |
| order_date    | date         | Order date, formatted as YYYY-MM-DD             |
| shipping_date | date         | Shipping date, formatted as YYYY-MM-DD          |
| due_date      | date         | Due date, formatted as YYYY-MM-DD               |
| sales_amount  | int          | Total sales amount                              |
| quantity      | int          | Quantity sold                                   |
| price         | int          | Unit price                                      |

---

# 📊 Business Logic Notes

* `sales_amount = quantity × price`
* Surrogate keys are generated during the ETL process
* Gold layer is optimized for reporting & analytics
* All tables are analytics-ready and cleaned

---

# 🧩 Use Cases

This schema supports:

* Customer segmentation analysis
* Product performance analysis
* Revenue reporting
* Sales trend analysis
* BI dashboard development
* Machine learning feature engineering

---

# 🛠️ Technologies Used

* SQL Server
* Data Warehouse Modeling
* Star Schema Design
* ETL Processing
* Dimensional Modeling

---

# ⭐ Why This Repository Matters

This project demonstrates:

* Dimensional modeling knowledge
* Star schema implementation
* Data documentation skills
* Data warehouse best practices
* Professional project structuring

