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

-- ------------------------------------------------------------------------------------------------------------------------------------

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

-- Revenue generation is heavily concentrated within the Technology sector, which accounts for 51% of total annual earnings. 
-- While Office Supplies and Furniture contribute to volume, they remain the lowest profit generators. 
-- Within the Technology segment, Copiers and Phones emerge as the primary value drivers, demonstrating resilient profit margins 
-- and maintaining bottom-line stability despite fluctuations in transaction volume.

-- ------------------------------------------------------------------------------------------------------------------------------------

-- 3. Who are the most valuable customer?

SELECT Segment, SUM(Sales) AS Sales, SUM(Profit) AS Profit
FROM sales_staging2
GROUP BY Segment
ORDER BY Profit DESC;

SELECT City, SUM(Sales) AS Sales, SUM(Profit) AS Profit
FROM sales_staging2
WHERE Segment = 'Consumer'
GROUP BY City
ORDER BY Profit DESC;


-- The Consumer segment remains our primary profit driver, contributing approximately 46% of total net income. High-performing hubs 
-- in New York City, Seattle, and Los Angeles underpin this success. Conversely, we have identified significant profit leakage in Houston, 
-- San Antonio, and Lancaster. These locations represent critical areas for operational review and strategic turnaround efforts. 


-- ------------------------------------------------------------------------------------------------------------------------------------

-- 4. Which regions perform best?

SELECT Region, SUM(Sales) AS Sales, SUM(Profit) AS Profit
FROM sales_staging2
GROUP BY Region
ORDER BY Profit DESC;

-- From a geographic perspective, the West region emerged as our primary profit center, contributing 37.4% of total net income. 
-- While the East region maintained a competitive second position with a narrow margin of difference, the South and Central regions 
-- underperformed relative to the coast, representing our lowest-yielding markets. This suggests a strong coastal demand base that should 
-- be leveraged for future growth.


-- ------------------------------------------------------------------------------------------------------------------------------------

-- 5. Where is the business losing money?

SELECT SUM(Profit)
FROM sales_staging2;

SELECT `Sub-Category`, SUM(Profit) AS Profit
FROM sales_staging2
GROUP BY `Sub-Category`
HAVING Profit < 0
ORDER BY Profit;

-- While the store maintains overall profitability, we have identified specific categories experiencing negative margins, notably Tables, 
-- Bookcases, and Supplies. The losses in these segments suggest that the current pricing structures or high associated overhead 
-- (such as shipping and assembly costs) are outpacing gross revenue. Addressing these underperforming assets is essential to optimizing 
-- our total portfolio yield.

-- ------------------------------------------------------------------------------------------------------------------------------------
