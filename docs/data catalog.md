# Gold Layer Data Catalog

## 1. Overview

The **Gold Layer** contains business-ready data designed for **analytics, reporting, and dashboards**. It follows a **Star Schema** structure.

## 2. Gold Views

### 2.1 `gold.dim_customers`

Contains cleaned and enriched customer information.

**Used for:** Customer analysis, demographics, country, and gender.

**Key columns:** `Customer_key`, `Customer_number`, `First_name`, `Last_name`, `Country`, `Gender`

---

### 2.2 `gold.dim_products`

Contains information about currently active products.

**Used for:** Product analysis, categories, subcategories, and costs.

**Key columns:** `Product_key`, `Product_number`, `Product_name`, `Category`, `Subcategory`, `Product_cost`

---

### 2.3 `gold.fact_sales`

Contains sales transactions and sales metrics.

**Used for:** Sales, quantities, prices, and time-based analysis.

**Key columns:** `Order_number`, `Customer_key`, `Product_key`, `Order_date`, `Sales_amount`, `Quantity`, `Price`

## 3. Relationships

```text
dim_customers ──┐
                ├──> fact_sales
dim_products  ──┘
```

* `fact_sales.Customer_key` → `dim_customers.Customer_key`
* `fact_sales.Product_key` → `dim_products.Product_key`

## 4. How to Use

* **Customer analysis** → `dim_customers`
* **Product analysis** → `dim_products`
* **Sales analysis** → `fact_sales`
* **Sales + customer information** → Join `fact_sales` with `dim_customers`
* **Sales + product information** → Join `fact_sales` with `dim_products`

> **In short:** Dimensions describe **who and what**, while the fact table records **sales events and measures**.
