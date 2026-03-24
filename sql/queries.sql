USE sales_analytics_project;

-- CORE QUESTIONS TO BE ANSWERED
-- 1. How is revenue changing over time?
-- 2. Which product/categories  drive the most revenue and profit?
-- 3. Who are the most valuable customer?
-- 4. Which regions perform best?
-- 5. Where is the business losing money?


SELECT * 
FROM sales_staging2;

-- ANALYSIS

-- 1. How is revenue changing over time?

SELECT MONTH(`Order Date`) AS Month, SUM(Sales) AS Monthly_sales, SUM(Profit) AS Monthly_profit
FROM sales_staging2
GROUP BY Month
ORDER BY Monthly_profit DESC;

-- Profitability exhibits strong positive seasonality in the fourth quarter, with September through December consistently 
-- ranking as the highest-performing months. Conversely, a significant retracement occurs in Q1, indicating a cyclical softening 
-- in demand or potential operational inefficiencies that warrant further investigation.


-- 2. Which product/categories  drive the most revenue and profit?

SELECT Category, SUM(Sales) AS Sales, SUM(Profit) AS Profit
FROM sales_staging2
GROUP BY Category
ORDER BY Profit DESC;

SELECT `Sub-Category`, SUM(Sales) AS Sales, SUM(Profit) AS Profit
FROM sales_staging2
WHERE Category = 'Technology'
GROUP BY `Sub-Category`
ORDER BY Profit DESC; 

-- Revenue generation is heavily concentrated within the Technology vertical, which accounts for 51% of total annual earnings. 
-- While Office Supplies and Furniture contribute to volume, they remain the lowest profit generators. 
-- Within the Technology segment, Copiers and Phones emerge as the primary value drivers, demonstrating resilient profit margins 
-- and maintaining bottom-line stability despite fluctuations in transaction volume.