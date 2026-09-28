# Northwind Sales Analytics (dbt)

A dbt project that turns the raw Northwind operational tables into clean,
business-ready models for sales analysis.

## The business problem

The analytics team at Northwind Trading had three problems:

1. **Messy raw data.** Column names and data types were inconsistent across
   tables, so every query started with cleaning.
2. **Slow, repeated work.** Every analyst wrote the same long joins between
   orders, order details, products and categories before they could start.
3. **No shared definition of revenue.** Everyone calculated revenue and profit
   differently, so two dashboards could show two different numbers for the same
   month.

This project solves all three by doing the cleaning, the joins and the revenue
calculation once, in one place, so every analyst starts from the same numbers.

## The models

### Staging — clean the raw data

| Model | What it does |
|---|---|
| `staging_customers` | Renames customer columns to snake_case and keeps the relevant fields |
| `staging_orders` | Cleans order data and casts order dates to proper date types |
| `staging_order_details` | Cleans the line items: quantity, unit price and discount, cast to numeric types |
| `staging_products` | Cleans product data and keeps the link to its category |

Staging models only rename, cast and select. No business logic, so it is always
clear where a value comes from.

### Prep — add the business logic

`prep_sales` joins orders, order details and products (and the product category),
and adds the calculated fields:

- `revenue = unit_price * quantity * (1 - discount)`
- `order_year` and `order_month` for time-based analysis

This is the single place where revenue is defined. If the definition ever
changes, it changes here, and every report that uses it changes with it.

### Mart — aggregate for analysis

`mart_sales_performance` aggregates `prep_sales` by `order_year`, `order_month`
and `category_name`, and returns:

- total revenue
- total number of orders
- average revenue per order

## What the mart can tell Northwind

- **How sales develop over time**, month by month, without anyone writing a join.
- **Which product categories drive the revenue**, and which ones are small but
  have a high average order value.
- **Whether growth comes from more orders or from bigger orders**, because
  revenue, order count and average revenue per order sit side by side.
- **Seasonality**, by comparing the same month across years.

Because every dashboard reads from this one table, two analysts asking the same
question now get the same answer.


## How to run

```bash
dbt run
dbt test
```
