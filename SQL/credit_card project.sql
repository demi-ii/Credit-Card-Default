CREATE DATABASE loan_project;
USE loan_project;
SELECT * FROM credit_card;

## to identify those who defaulted
SELECT id, 
CASE
WHEN `default.payment.next.month`=1 THEN 'Yes'  
ELSE 'No'
END as Defaulted 
 from credit_card;

## default rate of entire dataset 
SELECT ROUND(SUM(`default.payment.next.month`)*100.0/COUNT(*), 2) AS Default_Rate
FROM credit_card;

## default rate by gender 
SELECT ROUND((SUM(`default.payment.next.month`)/COUNT(*) )*100,2) AS default_rate,
CASE
	WHEN SEX=1 THEN 'Male'
	WHEN SEX=2 THEN 'Female' 
	ELSE 'unknown'
END as gender 
 FROM credit_card
GROUP BY gender
ORDER BY default_rate DESC;

## How does education level correlate with default probability?
SELECT ROUND((SUM(`default.payment.next.month`)/COUNT(*) )*100,2) AS default_rate,
CASE
WHEN EDUCATION=1 THEN 'graduate_school'
WHEN EDUCATION=2 THEN 'university' 
WHEN EDUCATION=3 THEN 'high_school'
WHEN EDUCATION=4 THEN 'others'
ELSE 'unknown'
END as education_status 
 FROM credit_card
 GROUP BY education_status
 ORDER BY default_rate DESC;
 
## Does marital status impact repayment behavior?
SELECT ROUND((SUM(`default.payment.next.month`)/COUNT(*) )*100,2) AS default_rate,
	CASE
WHEN MARRIAGE=1 THEN 'Married'
WHEN MARRIAGE=2 THEN 'Single' 
ELSE 'others'
	END as relationship_status 
FROM credit_card
 GROUP BY relationship_status
 ORDER BY default_rate DESC;

##What is the most risky age group , higher severity?
SELECT 
CASE
	WHEN age BETWEEN 18 AND 29 THEN '18-29'
	WHEN age BETWEEN 30 AND 39 THEN '30-39'
	ELSE '40+'
END AS age_group,
SUM(PAY_0 + PAY_2 + PAY_3 + PAY_4 + PAY_5 + PAY_6) AS Total_Risk_Score,
AVG(PAY_0 + PAY_2 + PAY_3 + PAY_4 + PAY_5 + PAY_6) AS avg_severity,
COUNT(*) AS num_clients
FROM credit_card
GROUP BY age_group
ORDER BY Total_Risk_Score;

## Which credit limit ranges have higher default rates?
 SELECT ROUND((SUM(`default.payment.next.month`)/COUNT(*) )*100,2) AS default_rate,
CASE 
	WHEN LIMIT_BAL < 50000 THEN '<50K'
	WHEN LIMIT_BAL < 100000 THEN '50K-100K'
	WHEN LIMIT_BAL < 200000 THEN '100K-200K'
	WHEN LIMIT_BAL < 500000 THEN '200K-500K'
	ELSE '500K+' 
END AS limit_range
FROM  credit_card
GROUP BY limit_range
oRDER BY default_rate DESC;

# Number of clients in each limit range group to explain severity further
SELECT 
 CASE
 WHEN age BETWEEN 18 AND 29 THEN '18-29'
 WHEN age BETWEEN 30 AND 39 THEN '30-39'
 ELSE '40+'
    END AS age_group,
CASE 
WHEN LIMIT_BAL < 50000 THEN '<50K'
WHEN LIMIT_BAL < 100000 THEN '50K-100K'
WHEN LIMIT_BAL < 200000 THEN '100K-200K'
WHEN LIMIT_BAL < 500000 THEN '200K-500K'
ELSE '500K+' 
    END AS limit_range,
COUNT(*) AS 'num_client'
FROM credit_card
GROUP BY age_group,limit_range
ORDER BY num_client DESC;

## segmentation of clients risk level
SELECT 
ROUND((SUM(`default.payment.next.month`)/COUNT(*) )*100,2) AS default_rate,
CASE
WHEN (PAY_0 + PAY_2 + PAY_3 + PAY_4 + PAY_5 + PAY_6) < '0' THEN 'low risk'
WHEN (PAY_0 + PAY_2 + PAY_3 + PAY_4 + PAY_5 + PAY_6)  BETWEEN 1 AND 5 THEN 'medium risk'
ELSE 'high risk'
END AS Risk_status,
COUNT(*) AS num_clients
FROM credit_card
GROUP BY Risk_status
ORDER BY default_rate DESC;

###. Which groups contribute the most to overall risk? age_group, gender, education_status and relationship_status?
 SELECT ROUND((SUM(`default.payment.next.month`)/COUNT(*) )*100,2) AS default_rate,
 CASE
	WHEN age BETWEEN 18 AND 29 THEN '18-29'
	WHEN age BETWEEN 30 AND 39 THEN '30-39'
	ELSE '40+'
END AS age_group,
CASE
	WHEN SEX=1 THEN 'Male'
	WHEN SEX=2 THEN 'Female' 
	ELSE 'unknown'
END as gender,
CASE
	WHEN EDUCATION=1 THEN 'graduate_school'
	WHEN EDUCATION=2 THEN 'university' 
	WHEN EDUCATION=3 THEN 'high_school'
	WHEN EDUCATION=4 THEN 'others'
	ELSE 'unknown'
END as education_status,
CASE
WHEN MARRIAGE=1 THEN 'Married'
WHEN MARRIAGE=2 THEN 'Single' 
ELSE 'others'
	END as relationship_status 
FROM credit_card
GROUP BY age_group,gender,education_status,relationship_status
ORDER BY default_rate DESC;

