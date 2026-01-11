SET COLSEP ,
SET LINESIZE 200
SET PAGESIZE 0
SET TRIMSPOOL ON
SET FEEDBACK OFF
SET HEADING ON

SPOOL analysis.csv

-- analysis.sql
SET LINESIZE 200
SET PAGESIZE 200
SET FEEDBACK OFF
SET HEADING ON

-- Total customers, churned vs retained
SELECT 
  COUNT(*) AS total_customers,
  SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
  SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END) AS retained,
  ROUND( (SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2 ) AS churn_rate_pct
FROM telco_churn;

-- Churn by contract type
SELECT 
  Contract,
  COUNT(*) AS customers,
  SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
  ROUND( (SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2 ) AS churn_rate_pct
FROM telco_churn
GROUP BY Contract
ORDER BY churn_rate_pct DESC;

-- Churn by tenure group
SELECT 
  TenureGroup,
  COUNT(*) AS customers,
  SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
  ROUND( (SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2 ) AS churn_rate_pct
FROM telco_churn
GROUP BY TenureGroup
ORDER BY TO_NUMBER(REGEXP_SUBSTR(TenureGroup, '^\d+'));

-- Average charges by churn
SELECT 
  Churn,
  ROUND(AVG(MonthlyCharges),2) AS avg_monthly,
  ROUND(AVG(TotalCharges),2) AS avg_total
FROM telco_churn
GROUP BY Churn;

-- Risk signals: internet service and support
SELECT 
  InternetService,
  TechSupport,
  COUNT(*) AS customers,
  SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS churned,
  ROUND( (SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2 ) AS churn_rate_pct
FROM telco_churn
GROUP BY InternetService, TechSupport
ORDER BY churn_rate_pct DESC;

-- Revenue impact estimate (simple)
SELECT 
  ROUND(SUM(CASE WHEN Churn='Yes' THEN MonthlyCharges ELSE 0 END),2) AS est_monthly_revenue_lost
FROM telco_churn;

SPOOL OFF
EXIT


