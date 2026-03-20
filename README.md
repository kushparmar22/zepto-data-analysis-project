# zepto-data-analysis-project
🛒 Zepto E-commerce SQL Data Analyst Portfolio Project This is a complete, real-world data analyst portfolio project based on an e-commerce inventory dataset scraped from Zepto — one of India’s fastest-growing quick-commerce startups. This project simulates real analyst workflows, from raw data exploration to business-focused data analysis.
## 📌 Project Overview

The goal is to simulate how actual data analysts in the e-commerce or retail industries work behind the scenes to use SQL to:

✅ Set up a messy, real-world e-commerce inventory **database**

✅ Perform **Exploratory Data Analysis (EDA)** to explore product categories, availability, and pricing inconsistencies

✅ Implement **Data Cleaning** to handle null values, remove invalid entries, and convert pricing from paise to rupees

✅ Write **business-driven SQL queries** to derive insights around **pricing, inventory, stock availability, revenue** and more

## 📁 Dataset Overview
The dataset was sourced from [Kaggle](https://www.kaggle.com/datasets/palvinder2006/zepto-inventory-dataset/data?select=zepto_v2.csv) and was originally scraped from Zepto’s official product listings. It mimics what you’d typically encounter in a real-world e-commerce inventory system.

Each row represents a unique SKU (Stock Keeping Unit) for a product. Duplicate product names exist because the same product may appear multiple times in different package sizes, weights, discounts, or categories to improve visibility – exactly how real catalog data looks.

🧾 Columns:
- **sku_id:** Unique identifier for each product entry (Synthetic Primary Key)

- **name:** Product name as it appears on the app

- **category:** Product category like Fruits, Snacks, Beverages, etc.

- **mrp:** Maximum Retail Price (originally in paise, converted to ₹)

- **discountPercent:** Discount applied on MRP

- **discountedSellingPrice:** Final price after discount (also converted to ₹)

- **availableQuantity:** Units available in inventory

- **weightInGms:** Product weight in grams

- **outOfStock:** Boolean flag indicating stock availability

- **quantity:** Number of units per package (mixed with grams for loose produce)

## 🔧 Project Workflow

Here’s a step-by-step breakdown of what we do in this project:

### 1. Database & Table Creation
We start by creating a SQL table with appropriate data types:

```sql
CREATE TABLE zepto (
    sku_id INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp DECIMAL(8,2),
    discountPercent DECIMAL(5,2),
    availableQuantity INT,
    discountedSellingPrice DECIMAL(8,2),
    weightInGms INT,
    outOfStock TINYINT(1),
    quantity INT
);
```

### 2. Data Import
- Loaded CSV using MYSQL import feature.
```sql
  LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/zepto_v2.csv'
INTO TABLE zepto
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(category, name, mrp, discountPercent, availableQuantity, discountedSellingPrice, weightInGms, @outOfStock, quantity)
SET outOfStock = CASE
    WHEN LOWER(TRIM(@outOfStock)) = 'true' THEN 1
    WHEN LOWER(TRIM(@outOfStock)) = 'false' THEN 0
    ELSE NULL
END;
```
- Faced encoding issues (UTF-8 error), which were fixed by saving the CSV file using CSV UTF-8 format.

### 3. 🔍 Data Exploration
- Counted the total number of records in the dataset

- Viewed a sample of the dataset to understand structure and content

- Checked for null values across all columns

- Identified distinct product categories available in the dataset

- Compared in-stock vs out-of-stock product counts

- Detected products present multiple times, representing different SKUs

### 4. 🧹 Data Cleaning
- Identified and removed rows where MRP or discounted selling price was zero

- Converted mrp and discountedSellingPrice from paise to rupees for consistency and readability
  
### 5. 📊 Business Insights
- Found top 10 best-value products based on discount percentage

- Identified high-MRP products that are currently out of stock

- Estimated potential revenue for each product category

- Filtered expensive products (MRP > ₹500) with minimal discount

- Ranked top 5 categories offering highest average discounts

- Calculated price per gram to identify value-for-money products

- Grouped products based on weight into Low, Medium, and Bulk categories

- Measured total inventory weight per product category

### Key Learnings

Through this project, I learned how to:

Create a MySQL table from scratch

Import CSV files into MySQL

Troubleshoot common MySQL import errors

Handle boolean and numeric conversion issues

Check and validate NULL values

Write SQL queries for basic retail data analysis

Work with real-world structured data


