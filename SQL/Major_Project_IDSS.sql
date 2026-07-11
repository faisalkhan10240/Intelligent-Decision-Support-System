use Walmart_IDSS

select * from sys.tables

-- Showing all tables
select * from sales;

select * from forecasts;

select * from alerts;

-- to check the count of all tables
select 'sales' as tablename, count(*) as totalrows from sales
union
select 'forecasts', count(*) from forecasts
union
select 'alert', count(*) from alerts;



-- Q1: Total Sales by Store
SELECT Store, Type,
ROUND(SUM(CAST(Weekly_Sales AS FLOAT)), 0) AS Total_Sales,
ROUND(AVG(CAST(Weekly_Sales AS FLOAT)), 0) AS Avg_Weekly_Sales,
COUNT(DISTINCT Dept) AS Dept_Count FROM sales
GROUP BY Store, Type
ORDER BY Total_Sales DESC;

-- Q2: Holiday Impact Analysis
SELECT IsHoliday, ROUND(AVG(CAST(Weekly_Sales AS FLOAT)), 2) AS Avg_Sales,
ROUND(MAX(CAST(Weekly_Sales AS FLOAT)), 2) AS Peak_Sales,
COUNT(*) AS Week_Count FROM sales GROUP BY IsHoliday;

-- Q3: Top 10 Departments by Average Sales
SELECT TOP 10 Dept,
ROUND(AVG(CAST(Weekly_Sales AS FLOAT)), 2) AS Avg_Sales,
ROUND(SUM(CAST(Weekly_Sales AS FLOAT)), 0) AS Total_Sales
FROM sales GROUP BY Dept ORDER BY Avg_Sales DESC;

-- Q4: Monthly Seasonality Pattern
SELECT Month,
ROUND(AVG(CAST(Weekly_Sales AS FLOAT)), 2) AS Avg_Monthly_Sales,
ROUND(MAX(CAST(Weekly_Sales AS FLOAT)), 2) AS Peak_Sales,
ROUND(SUM(CAST(Weekly_Sales AS FLOAT))/1000000, 3) AS Total_Sales_M
FROM sales GROUP BY Month ORDER BY Month;

-- Q5: Store Type Performance Comparison
SELECT Type, COUNT(DISTINCT Store) AS Store_Count,
ROUND(AVG(CAST(Weekly_Sales AS FLOAT)), 0) AS Avg_Weekly_Sales,
ROUND(AVG(CAST(Size AS FLOAT)), 0) AS Avg_Size_SqFt,
ROUND(AVG(CAST(Weekly_Sales AS FLOAT) / NULLIF(CAST(Size AS FLOAT), 0)), 4) AS Sales_Per_SqFt
FROM sales GROUP BY Type ORDER BY Avg_Weekly_Sales DESC;

-- Q6: High Risk Inventory Alerts
SELECT TOP 20 Store, 
Dept, Priority, COUNT(*) AS Alert_Count FROM alerts
WHERE Priority LIKE '%HIGH%' OR Priority LIKE '%CRITICAL%' OR Priority LIKE '%RESTOCK%'
GROUP BY Store, Dept, Priority ORDER BY Alert_Count DESC;

-- Q7: Top 5 Departments by Forecasted Sales
SELECT TOP 5 Dept, 
ROUND(AVG(CAST(Forecast_Sales AS FLOAT)), 0) AS Avg_Forecast 
FROM forecasts 
GROUP BY Dept ORDER BY Avg_Forecast DESC;
    
-- Q8: Year-over-Year Sales Growth
SELECT Year,
ROUND(SUM(CAST(Weekly_Sales AS FLOAT))/1000000, 2) AS Total_Sales_M,
ROUND(AVG(CAST(Weekly_Sales AS FLOAT)), 0) AS Avg_Weekly_Sales,
COUNT(DISTINCT Store) AS Active_Stores
FROM sales
GROUP BY Year ORDER BY Year;

-- Q9: IDSS Executive Action Summary
SELECT Final_DSS_Alert AS Risk_Level,
COUNT(*) AS Total_Alerts,
ROUND(AVG(CAST(Forecast_Sales AS FLOAT)), 0) AS Avg_Forecasted_Sales
FROM forecasts
GROUP BY Final_DSS_Alert
ORDER BY Avg_Forecasted_Sales DESC;


-- Q10: Most Recent 26-Week Sales Trend (all stores)
SELECT CAST(Date AS DATE) AS DATE,
ROUND(SUM(CAST(Weekly_Sales AS FLOAT))/1000000, 3) AS Total_Sales_M
FROM sales
WHERE CAST(Date AS DATE) >= (SELECT DATEADD(DAY, -182, MAX(CAST(Date AS DATE))) 
FROM sales)
GROUP BY CAST(Date AS DATE) ORDER BY CAST(Date AS DATE);






