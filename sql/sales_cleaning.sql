CREATE DATABASE sales_analytics_project;

USE sales_analytics_project;

SELECT * 
FROM new_sales_data;

-- CREATING A DUPLICATE STAGING TABLE SO THE REAL DATA REMAINS UNAFFECTED
CREATE TABLE sales_staging
LIKE new_sales_data;

INSERT sales_staging
SELECT *
FROM new_sales_data;

SELECT COUNT(*) 
FROM sales_staging;

DESCRIBE sales_staging;

-- Never executed
UPDATE sales_staging 
SET 
  `Order Date` = STR_TO_DATE(`Order Date`, '%m/%d/%Y'),
  `Ship Date` = STR_TO_DATE(`Ship Date`, '%m/%d/%Y');

ALTER TABLE sales_staging
  MODIFY COLUMN `Order Date` DATE,
  MODIFY COLUMN `Ship Date` DATE,
  MODIFY COLUMN `Postal Code` INT,
  MODIFY COLUMN Sales DECIMAL(10,2),
  MODIFY COLUMN Quantity INT,
  MODIFY COLUMN Discount DECIMAL(5,2),
  MODIFY COLUMN Profit DECIMAL(10,2);
-- Till here 





-- 1. REMOVE DUPLICATES
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY `Order ID`, `Product ID`, `Customer ID`, `Order Date`, `Ship Date`, `Customer Name`, `Segment`, Country, City, State, `Postal Code`, Region, Category, `Product Name`, Sales, Quantity, Discount, Profit) AS row_num 
FROM sales_staging;


WITH duplicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY `Order ID`, `Product ID`, `Customer ID`, `Order Date`, `Ship Date`, `Customer Name`, `Segment`, Country, City, State, `Postal Code`, Region, Category, `Product Name`, Sales, Quantity, Discount, Profit) AS row_num 
FROM sales_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

-- double checking the duplicates
SELECT * 
FROM sales_staging
WHERE `Order ID` = 'US-2014-150119';

-- found the duplicate record, will now delete the duplicate record

CREATE TABLE sales_staging2
LIKE sales_staging;

ALTER TABLE sales_staging2
ADD row_num int; 

INSERT sales_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY `Order ID`, `Product ID`, `Customer ID`, `Order Date`, `Ship Date`, `Customer Name`, `Segment`, Country, City, State, `Postal Code`, Region, Category, `Product Name`, Sales, Quantity, Discount, Profit) AS row_num 
FROM sales_staging;

SELECT * 
FROM sales_staging2;

SELECT * 
FROM sales_staging2
WHERE row_num > 1;

DELETE 
FROM sales_staging2
WHERE row_num > 1;




-- 2. Standardize the data 
SELECT * 
FROM sales_staging2;

-- checking for abnormalities using distinct
SELECT DISTINCT(`Sub-Category`)
FROM sales_staging2;

-- Handling white spaces with trim function
UPDATE sales_staging2
SET State = TRIM(State);

-- changing the date format from text to date
SELECT `Order Date`, STR_TO_DATE(`Order Date`, '%m/%d/%Y')
FROM sales_staging2;

UPDATE sales_staging2
SET `Order Date` = STR_TO_DATE(`Order Date`, '%m/%d/%Y');

UPDATE sales_staging2
SET `Ship Date` = STR_TO_DATE(`Ship Date`, '%m/%d/%Y');

ALTER TABLE sales_staging2
MODIFY COLUMN `Order Date` DATE;

ALTER TABLE sales_staging2
MODIFY COLUMN `Ship Date` DATE;






-- 3. Handling null or blank values

-- Checking for null values
SELECT * 
FROM sales_staging2
WHERE `Postal Code` IS NULL;

-- no null records found.. willmove on to next step



-- 4. Remove any columns




