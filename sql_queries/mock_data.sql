CREATE DATABASE edutech_data;
USE edutech_data;

CREATE TABLE mock_data (
    LeadID VARCHAR(50) PRIMARY KEY,
    Lead_Source VARCHAR(100),
    Lead_Status VARCHAR(100),
    Date_of_Lead_Generation DATE,
    Date_of_Last_Contact DATE,
    Sales_Amount DECIMAL(10,2),
    Region VARCHAR(100),
    Salesperson VARCHAR(100),
    Conversion_Date DATE,
    Lead_Qualification VARCHAR(100),
    Course_Type VARCHAR(100),
    Follow_up_Status VARCHAR(100),
    Marketing_Campaign VARCHAR(100),
    Lead_Score INT,
    Student_Type VARCHAR(100),
    Yaswanth_Chukka VARCHAR(100)
);

LOAD DATA LOCAL INFILE 'C:/Users/chinm/EduTech Data Analysis/data/Mock_Data_Cleaned.csv'
INTO TABLE mock_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(LeadID, Lead_Source, Lead_Status, Date_of_Lead_Generation, Date_of_Last_Contact,
 Sales_Amount, Region, Salesperson, Conversion_Date, Lead_Qualification,
 Course_Type, Follow_up_Status, Marketing_Campaign, Lead_Score,
 Student_Type);
 
ALTER TABLE mock_data
DROP COLUMN Yaswanth_Chukka;


SELECT * FROM mock_data;

SELECT COUNT(*) FROM mock_data;

SELECT 
    SUM(CASE WHEN LeadID IS NULL OR LeadID = '' THEN 1 ELSE 0 END) AS null_LeadID,
    SUM(CASE WHEN Lead_Source IS NULL OR Lead_Source = '' THEN 1 ELSE 0 END) AS null_Lead_Source,
    SUM(CASE WHEN Lead_Status IS NULL OR Lead_Status = '' THEN 1 ELSE 0 END) AS null_Lead_Status,
    SUM(CASE WHEN Date_of_Lead_Generation IS NULL OR Date_of_Lead_Generation = '' THEN 1 ELSE 0 END) AS null_Date_of_Lead_Generation,
    SUM(CASE WHEN Date_of_Last_Contact IS NULL OR Date_of_Last_Contact = '' THEN 1 ELSE 0 END) AS null_Date_of_Last_Contact,
    SUM(CASE WHEN Sales_Amount IS NULL OR Sales_Amount = '' THEN 1 ELSE 0 END) AS null_Sales_Amount,
    SUM(CASE WHEN Region IS NULL OR Region = '' THEN 1 ELSE 0 END) AS null_Region,
    SUM(CASE WHEN Salesperson IS NULL OR Salesperson = '' THEN 1 ELSE 0 END) AS null_Salesperson,
    SUM(CASE WHEN Conversion_Date IS NULL OR Conversion_Date = '' THEN 1 ELSE 0 END) AS null_Conversion_Date,
    SUM(CASE WHEN Lead_Qualification IS NULL OR Lead_Qualification = '' THEN 1 ELSE 0 END) AS null_Lead_Qualification,
    SUM(CASE WHEN Course_Type IS NULL OR Course_Type = '' THEN 1 ELSE 0 END) AS null_Course_Type,
    SUM(CASE WHEN Follow_up_Status IS NULL OR Follow_up_Status = '' THEN 1 ELSE 0 END) AS null_Follow_up_Status,
    SUM(CASE WHEN Marketing_Campaign IS NULL OR Marketing_Campaign = '' THEN 1 ELSE 0 END) AS null_Marketing_Campaign,
    SUM(CASE WHEN Lead_Score IS NULL OR Lead_Score = '' THEN 1 ELSE 0 END) AS null_Lead_Score,
    SUM(CASE WHEN Student_Type IS NULL OR Student_Type = '' THEN 1 ELSE 0 END) AS null_Student_Type
FROM mock_data;

SET SQL_SAFE_UPDATES = 0;

UPDATE mock_data
SET Sales_Amount = NULL
WHERE Sales_Amount = 0
   OR Sales_Amount IS NULL;

UPDATE mock_data
SET Sales_Amount = NULL
WHERE Sales_Amount IS NULL
   OR TRIM(CAST(Sales_Amount AS CHAR)) = ''
   OR Sales_Amount NOT REGEXP '^[0-9.]+$'
   OR Sales_Amount = 0;

SET SQL_SAFE_UPDATES = 1;

SELECT COUNT(*) 
FROM mock_data
WHERE Sales_Amount IS NULL;

SELECT DISTINCT Sales_Amount
FROM mock_data
WHERE Sales_Amount IS NULL 
   OR Sales_Amount = 0
   OR TRIM(Sales_Amount) = ''
   OR Sales_Amount NOT REGEXP '^[0-9.]+$';



SELECT *
FROM mock_data
WHERE Sales_Amount IS NULL
   OR Sales_Amount = 0
   OR TRIM(Sales_Amount) = ''
   OR Sales_Amount NOT REGEXP '^[0-9.]+$';
   
DESCRIBE mock_data;

-- Total Leads, Converted Leads, and Conversion Rate
SELECT 
    COUNT(*) AS Total_Leads,
    COUNT(CASE WHEN Lead_Status='Converted' THEN 1 END) AS Converted_Leads,
    (COUNT(CASE WHEN Lead_Status='Converted' THEN 1 END) / COUNT(*)) * 100 AS Conversion_Rate
FROM mock_data;


-- Conversion Rate by Region
SELECT 
    Region,
    COUNT(LeadID) AS Total_Leads,
    SUM(CASE WHEN Lead_Status = 'Converted' THEN 1 ELSE 0 END) AS Converted_Leads,
    ROUND(SUM(CASE WHEN Lead_Status = 'Converted' THEN 1 ELSE 0 END) * 100.0 / COUNT(LeadID), 2) AS Conversion_Rate
FROM mock_data
GROUP BY Region
ORDER BY Conversion_Rate DESC;

-- Sales Performance by Salesperson
SELECT 
    Salesperson,
    SUM(Sales_Amount) AS Total_Sales,
    COUNT(LeadID) AS Total_Leads,
    ROUND(SUM(Sales_Amount) / COUNT(LeadID), 2) AS Avg_Sale_Per_Lead
FROM mock_data
GROUP BY Salesperson
ORDER BY Total_Sales DESC;

-- Lead Source vs Conversion Rate
SELECT 
    Lead_Source,
    COUNT(LeadID) AS Total_Leads,
    SUM(CASE WHEN Lead_Status = 'Converted' THEN 1 ELSE 0 END) AS Converted_Leads,
    ROUND(SUM(CASE WHEN Lead_Status = 'Converted' THEN 1 ELSE 0 END) * 100.0 / COUNT(LeadID), 2) AS Conversion_Rate
FROM mock_data
GROUP BY Lead_Source
ORDER BY Conversion_Rate DESC;

-- Monthly Conversion Trend
SELECT 
    MONTHNAME(Conversion_Date) AS Month,
    COUNT(*) AS Conversions
FROM mock_data
WHERE Lead_Status='Converted'
GROUP BY MONTH(Conversion_Date), MONTHNAME(Conversion_Date)
ORDER BY MONTH(Conversion_Date);

-- Average Conversion Time (Days)
SELECT 
    AVG(DATEDIFF(Conversion_Date, Date_of_Lead_Generation)) AS Avg_Conversion_Time_Days
FROM mock_data
WHERE Lead_Status='Converted';

select * from mock_data;

SELECT SUM(sales_amount) AS total_sales
FROM mock_data;


