# E-Commerce Sales & Customer Analysis

> **SQL analysis of 100,000+ Brazilian e-commerce transactions to identify 
> revenue drivers, customer retention gaps, and growth opportunities**

![MySQL](https://img.shields.io/badge/MySQL-8.0-blue?logo=mysql)
![Status](https://img.shields.io/badge/Status-Complete-success)
![Dataset](https://img.shields.io/badge/Dataset-Olist-orange)

---

## Project Overview

Analysed Olist's e-commerce platform data (2016-2018) to answer critical 
business questions about revenue performance, customer retention, and 
market opportunities.

**The business problem:** Despite rapid growth (14,800% order increase 
2016→2017), only 6% of customers make repeat purchases — far below 
industry benchmarks. This analysis identifies where revenue is concentrated 
and how to improve customer lifetime value.

---

## Key Findings

- **R$ 16M total revenue** across 100k+ orders (2016-2018)
- **6% repeat customer rate** — significant retention opportunity
- **Top 5 categories drive 40% of revenue** (Pareto principle confirmed)
- **São Paulo generates 42% of orders** — heavy geographic concentration
- **Direct traffic converts at 11%+** vs Social Media at 5%

[Read Full Analysis →](insights/E-Commerce_Business_Insights.pdf)

---

## Business Questions Answered

| # | Question | Section |
|---|----------|---------|
| 1 | What is overall revenue, orders, and AOV? | Core Performance |
| 2 | Which categories generate the most revenue? | Product Analysis |
| 3 | Is revenue concentrated among a small number of products or brands? | Product Analysis |
| 4 | How do new vs returning customers contribute to total revenue? | Customer Behaviour |
| 5 | What proportion of orders comes from repeat customers? | Customer Behaviour |
| 6 | Which traffic sources drive most conversions? | Marketing Funnel |
| 7 | Where do users drop off in the funnel? | Marketing Funnel |
| 8 | Which states generate most orders/revenue? | Geography |

---

## Technical Skills Demonstrated

**SQL Techniques:**
- Multi-table JOINs across 5+ tables
- Common Table Expressions (CTEs)
- Window Functions (ROW_NUMBER, RANK, LAG)
- Aggregate functions with GROUP BY / HAVING
- CASE statements for customer segmentation
- Date manipulation for year-over-year analysis
- Subqueries for nested calculations

**Sample Query - Customer Segmentation:**
```sql
WITH CustomerStats AS (
	SELECT 
		c.customer_unique_id,
		count(o.order_id) as total_orders
    FROM customers c
    LEFT JOIN orders o on c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
),
CustomerLabels AS(
	SELECT 
		customer_unique_id,
        CASE WHEN total_orders = 1 THEN 'New' ELSE 'Returning' END as customer_type
	FROM CustomerStats
)

SELECT 
	CustomerLabels.customer_type,
		COUNT(o.order_id) as total_orders,
		-- Using Window Function SUM(...) OVER() to calculate percentage of the grand total
		ROUND(COUNT(o.order_id) * 100.0 / SUM(COUNT(o.order_id)) OVER (), 2) as proportion_percentage
FROM customers c
LEFT JOIN CustomerLabels on c.customer_unique_id = CustomerLabels.customer_unique_id
LEFT JOIN orders o on c.customer_id = o.customer_id
GROUP BY CustomerLabels.customer_type;
```

---

## Repository Structure
```
├── sql/                          # SQL queries by analysis section
│   ├── 01_schema_setup.sql      # Database schema and data loading
│   ├── 02_core_performance.sql  # Revenue, orders, AOV analysis
│   ├── 03_product_category.sql  # Product & category performance
│   ├── 04_customer_behavior.sql # New vs returning customer analysis
│   ├── 05_traffic_funnel.sql    # Traffic source & funnel analysis
│   └── 06_geography.sql         # Geographic revenue distribution
├── insights/
   └── E-Commerce_Business_Insights.pdf  # Full analysis report
```

---

## Datasets

**Sources:** 
  - [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
  - [Marketing Funnel by Olist](https://www.kaggle.com/datasets/olistbr/marketing-funnel-olist)

| Detail | Info |
|--------|------|
| Orders | ~100,000 |
| Time Period | 2016 - 2018 |
| Tables | 11 relational tables |
| Origin | Brazilian marketplace |

---

## How to Replicate This Analysis

1. Download the datasets:
  - [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
  - [Marketing Funnel by Olist](https://www.kaggle.com/datasets/olistbr/marketing-funnel-olist)
3. Install MySQL 8.0+
4. Run `sql/01_schema_setup.sql` to create and populate the database
5. Run remaining SQL files in numbered order
6. Review findings in `insights/E-Commerce_Business_Insights.pdf`

---

## Business Impact Summary

| Priority | Recommendation | Expected Impact |
|----------|---------------|-----------------|
| High | Post-purchase re-engagement loop | +R$ 595k revenue |
| Medium | Reallocate 15% social budget to paid search | -15% CAC |
| Medium | Category hero strategy for top 5 categories | +AOV stability |
| Low | CRM tracking for unknown traffic sources | Better ROI data |
