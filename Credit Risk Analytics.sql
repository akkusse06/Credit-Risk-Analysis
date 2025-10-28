USE SYSTEM;

CREATE TABLE customer_loan_data (
    client_ID VARCHAR(255) PRIMARY KEY,
    person_age INT,
    person_income INT,
    person_home_ownership VARCHAR(50),
    person_emp_length INT,
    loan_intent VARCHAR(255),
    loan_grade CHAR(1),
    loan_amnt INT,
    loan_int_rate DECIMAL(5, 2),
    loan_status INT,
    loan_percent_income DECIMAL(5, 2),
    cb_person_default_on_file CHAR(1),
    cb_person_cred_hist_length INT,
    gender VARCHAR(10),
    marital_status VARCHAR(50),
    education_level VARCHAR(255),
    country VARCHAR(255),
    state VARCHAR(255),
    city VARCHAR(255),
    city_latitude DECIMAL(10, 6),
    city_longitude DECIMAL(10, 6),
    employment_type VARCHAR(255),
    loan_term_months INT,
    loan_to_income_ratio DECIMAL(20, 18),
    other_debt DECIMAL(20, 14),
    debt_to_income_ratio DECIMAL(20, 18),
    open_accounts INT,
    credit_utilization_ratio DECIMAL(20, 18),
    past_delinquencies INT
);

SELECT * FROM CUSTOMER_LOAN_DATA;

-- Total number of loans

SELECT COUNT(client_ID)
FROM customer_loan_data;

-- What is the overall loan default rate in the dataset (loan_status = 1)

SELECT COUNT(loan_status) 
FROM customer_loan_data
WHERE loan_status = 1;

-- What is the default rate

SELECT 
    ROUND(
        (SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 
        2
    ) AS default_ratio_percent
FROM customer_loan_data;

-- What is the average loan amount (loan_amnt) and average interest rate 
(loan_int_rate) across all loans?

SELECT 
    ROUND(AVG(loan_amnt),2) AS avg_loan_amt,
    ROUND(AVG(loan_int_rate),2) AS avg_loan_int_rate
FROM customer_loan_data;

-- How many clients are there per home ownership status (person_home_ownership), 
--and what is the average income (person_income) for each group?

SELECT person_home_ownership,COUNT(*) AS number_clients, ROUND(AVG(person_income),2) AS average_income
FROM customer_loan_data
GROUP BY person_home_ownership;

-- What is the minimum, maximum, and average age (person_age) of clients,
-- broken down by gender?

SELECT gender, MIN(person_age), MAX(person_age), ROUND(AVG(person_age),2)
FROM customer_loan_data
GROUP BY gender;

-- Loan Performance and Risk Analysis

-- What is the default rate (percentage of loans with loan_status = 1) for each 
-- loan grade (loan_grade)?

SELECT loan_grade ,  ROUND(
        (SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 
        2
    ) AS default_ratio_percent
FROM customer_loan_data
GROUP BY loan_grade
ORDER BY loan_grade;

-- How does the average loan-to-income ratio (loan_to_income_ratio) differ between 
--clients who defaulted and those who did not?

SELECT 
    loan_status,
    ROUND(AVG(loan_to_income_ratio), 2) AS avg_loan_to_income_ratio,
    COUNT(*) AS client_count
FROM customer_loan_data
GROUP BY loan_status
ORDER BY loan_status;

-- What is the total loan amount disbursed for each loan intent (loan_intent), 
--and what percentage of those loans defaulted?

SELECT 
    loan_intent,
    SUM(loan_amnt) AS loan_amount,
    ROUND(
        (SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 
        2
    ) AS percent_defaulted
FROM customer_loan_data
GROUP BY loan_intent
ORDER BY loan_intent;

-- For clients with a previous default on file (cb_person_default_on_file = 'Y'),
--what is the average credit history length (cb_person_cred_hist_length) and 
--default rate compared to those without?

SELECT 
    cb_person_default_on_file,
    ROUND(AVG(cb_person_cred_hist_length), 2) AS avg_credit_hist_length,
    ROUND(
        (SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 
        2
    ) AS percent_defaulted
FROM customer_loan_data
GROUP BY cb_person_default_on_file
ORDER BY cb_person_default_on_file;

SELECT 
    cb_person_default_on_file,
    ROUND(AVG(cb_person_cred_hist_length), 2) AS avg_credit_hist_length,
    ROUND(
        (SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 
        2
    ) AS percent_defaulted
FROM customer_loan_data
WHERE cb_person_default_on_file = 'Y'
GROUP BY cb_person_default_on_file;

-- Demographic Insights

-- What is the distribution of loan statuses (default vs. non-default) by marital
--status and education level?

SELECT loan_status,marital_status, education_level
FROM customer_loan_data
GROUP BY marital_status, education_level,loan_status
ORDER BY marital_status, education_level, loan_status;

-- How does the average debt-to-income ratio (debt_to_income_ratio) vary by 
--gender and employment type?

SELECT gender, employment_type,
    ROUND(AVG(debt_to_income_ratio),2) AS avg_debt_to_income_ratio
FROM customer_loan_data
GROUP BY gender, employment_type
ORDER BY gender, employment_type;

-- What is the average number of past delinquencies (past_delinquencies) for 
--clients grouped by age brackets (e.g., 20-30, 31-40, 41-50, 51+)?

SELECT 
    CASE 
        WHEN person_age BETWEEN 20 AND 30 THEN '20-30'
        WHEN person_age BETWEEN 31 AND 40 THEN '31-40'
        WHEN person_age BETWEEN 41 AND 50 THEN '41-50'
        WHEN person_age >= 51 THEN '51+'
        ELSE 'Other'
    END AS age_bracket,
    ROUND(AVG(past_delinquencies), 2) AS avg_past_delinquencies
FROM customer_loan_data
GROUP BY 
    CASE 
        WHEN person_age BETWEEN 20 AND 30 THEN '20-30'
        WHEN person_age BETWEEN 31 AND 40 THEN '31-40'
        WHEN person_age BETWEEN 41 AND 50 THEN '41-50'
        WHEN person_age >= 51 THEN '51+'
        ELSE 'Other'
    END
ORDER BY age_bracket;

SELECT 
    age_bracket,
    ROUND(AVG(past_delinquencies), 2) AS avg_past_delinquencies
FROM (
    SELECT 
        CASE 
            WHEN person_age BETWEEN 20 AND 30 THEN '20-30'
            WHEN person_age BETWEEN 31 AND 40 THEN '31-40'
            WHEN person_age BETWEEN 41 AND 50 THEN '41-50'
            WHEN person_age >= 51 THEN '51+'
            ELSE 'Other'
        END AS age_bracket,
        past_delinquencies
    FROM customer_loan_data
) subquery
GROUP BY age_bracket
ORDER BY age_bracket;


WITH age_brackets AS (
    SELECT 
        CASE 
            WHEN person_age BETWEEN 20 AND 30 THEN '20-30'
            WHEN person_age BETWEEN 31 AND 40 THEN '31-40'
            WHEN person_age BETWEEN 41 AND 50 THEN '41-50'
            WHEN person_age >= 51 THEN '51+'
            ELSE 'Other'
        END AS age_bracket,
        past_delinquencies
    FROM customer_loan_data
)
SELECT 
    age_bracket,
    ROUND(AVG(past_delinquencies), 2) AS avg_past_delinquencies
FROM age_brackets
GROUP BY age_bracket
ORDER BY age_bracket;

-- For each education level, what is the median income and the count of clients
--who are self-employed?

SELECT 
    education_level,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY person_income), 2) AS median_income,
    COUNT(CASE WHEN employment_type = 'Self-employed' THEN 1 END) AS self_employed_count
FROM customer_loan_data
GROUP BY education_level
ORDER BY education_level;

-- Geographic Analysis

-- Which country has the highest average loan amount, and what is the default 
--rate in that country?

WITH country_cte AS(
SELECT country, 
    ROUND(AVG(loan_amnt),2) AS avg_loan_amnt,
    ROUND((SUM(CASE WHEN loan_status =1 THEN 1 ELSE 0 END)*100)/COUNT(*),2)
        AS default_ratiO,
RANK() OVER(ORDER BY AVG(loan_amnt) DESC) AS rnk         
FROM 
    customer_loan_data
GROUP BY 
    country
)
SELECT 
    country, avg_loan_amnt, default_ratiO
FROM 
    country_cte
WHERE 
    rnk =1;

-- What is the total number of clients and average credit utilization ratio 
--(credit_utilization_ratio) per state?

SELECT state, COUNT(*),
    ROUND(AVG(credit_utilization_ratio),2) AS avg_credit_utilization_ratio
FROM customer_loan_data
GROUP BY state
ORDER BY state;

-- For cities with more than 100 clients, what is the average loan term 
--(loan_term_months) and default rate, sorted by latitude descending?

WITH city_stats AS (
SELECT city, COUNT(*) AS number_of_clients,
    ROUND(AVG(loan_term_months),2) AS avg_loan_term_months,
    ROUND((SUM(CASE WHEN loan_status =1 THEN 1 ELSE 0 END)*100)/COUNT(*),2)
        AS default_ratiO, city_latitude
FROM customer_loan_data        
GROUP BY city, city_latitude
ORDER BY city_latitude DESC
)
SELECT city, avg_loan_term_months,
        default_ratiO
FROM city_stats
WHERE number_of_clients >100;

-- How does the average other debt (other_debt) differ between clients in urban
--areas (e.g., major cities like Toronto,New York City,Los Angeles,Chicago,
--Houston,London) versus others?

SELECT 
    CASE
        WHEN city IN ('Toronto','New York City','Los Angeles','Chicago',
        'Houston','London') 
        THEN 'Urban'
        ELSE 'Non urban'
    END AS area_type,
    ROUND(AVG(other_debt),2) AS avg_other_debt
FROM customer_loan_data
GROUP BY CASE
        WHEN city IN ('Toronto','New York City','Los Angeles','Chicago',
        'Houston','London') 
        THEN 'Urban' 
        ELSE 'Non urban' 
        END;
        
-- What is the correlation between employment length (person_emp_length) and 
--default status, grouped by loan grade (e.g., average employment length for
--defaulters vs. non-defaulters per grade)?

SELECT 
    loan_grade,
    loan_status, 
    ROUND(AVG(person_emp_length),2) AS avg_person_emp_length
FROM customer_loan_data
GROUP BY loan_grade,loan_status
ORDER BY loan_grade, loan_status;  

-- For loans with interest rates above 15%, what is the count of defaults by 
--loan intent and gender?

SELECT 
    loan_intent, 
    gender,
    COUNT(CASE WHEN loan_status =1 THEN 1 END) AS count_default
FROM customer_loan_data
WHERE loan_int_rate >15
GROUP BY loan_intent, gender
ORDER BY loan_intent, gender;

-- Which combination of home ownership and marital status has the highest 
--average credit utilization ratio, and how many such clients have more than 
--2 past delinquencies?

WITH home_marital_cte AS (
SELECT
    person_home_ownership,
    marital_status,
    ROUND(AVG(credit_utilization_ratio),2) AS avg_credit_utilization_ratio,
    COUNT(*) AS total_clients,
    SUM(CASE WHEN past_delinquencies > 2 THEN 1 ELSE 0 END)
        AS clients_with_over_2_delinquencies,
RANK() OVER(ORDER BY AVG(credit_utilization_ratio) DESC) AS rnk
FROM customer_loan_data
GROUP BY  person_home_ownership,marital_status
)
SELECT 
    person_home_ownership,
    marital_status,
    avg_credit_utilization_ratio,
    clients_with_over_2_delinquencies
FROM home_marital_cte
WHERE rnk =1;

-- What is the year-over-year trend in average loan percent income
--(loan_percent_income) if we assume credit history length as a proxy for time 
--(group by cb_person_cred_hist_length)?

SELECT 
    ROUND(AVG(loan_percent_income),2) AS avg_loan_percent_income,
    cb_person_cred_hist_length AS credit_history_years
FROM
    customer_loan_data
GROUP BY cb_person_cred_hist_length
ORDER BY cb_person_cred_hist_length;

# Advanced Descriptive Statistics

-- What is the total loan amount (loan_amnt) disbursed per gender, and how does 
--it compare to the average income (person_income) for each gender?

SELECT 
    gender, 
    ROUND(AVG(person_income),2) AS avg_person_income,
    SUM(loan_amnt) as total_loan_amt
FROM
    customer_loan_data
GROUP BY gender;  

-- How many clients have a credit utilization ratio (credit_utilization_ratio) 
--above 0.5, grouped by education level (education_level), and what is their 
--average loan interest rate (loan_int_rate)?

SELECT 
    education_level,
    ROUND(AVG(loan_int_rate),2) AS avg_loan_int_rate,
    COUNT(*) AS high_utilization_count
FROM 
     customer_loan_data
WHERE credit_utilization_ratio >0.5
GROUP BY education_level
ORDER BY education_level;

-- What is the minimum, maximum, and average number of open accounts 
--(open_accounts) per employment type (employment_type)?

SELECT employment_type,
    MIN(open_accounts) AS min_open_accounts,
    MAX(open_accounts) AS max_open_accounts,
    ROUND(AVG(open_accounts),2) AS avg_open_accounts
FROM 
     customer_loan_data   
GROUP BY employment_type;  

-- For clients with more than 5 years of credit history 
--(cb_person_cred_hist_length > 5), what is the distribution of loan grades 
--(loan_grade)?
  
SELECT   
    loan_grade,
    COUNT(*) AS client_number
FROM 
     customer_loan_data
WHERE cb_person_cred_hist_length > 5
GROUP BY loan_grade;
    
--   What is the default rate for loans with a debt-to-income ratio 
--(debt_to_income_ratio) above 0.6, grouped by home ownership status 
--(person_home_ownership)?
 
SELECT
    person_home_ownership,
    ROUND(
        (SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 
        2
    ) AS default_rate_percent
FROM customer_loan_data
WHERE debt_to_income_ratio >0.6
GROUP BY person_home_ownership;

-- How does the average recovery days (assuming loan_term_months as a proxy) 
--vary for defaulted loans (loan_status = 1) by loan intent (loan_intent)?
 
 SELECT 
    loan_intent,
    ROUND(AVG(loan_term_months),2) AS avg_recovery_days
FROM customer_loan_data
WHERE loan_status = 1
GROUP BY  loan_intent
ORDER BY loan_intent;

-- What is the percentage of clients with past delinquencies 
--(past_delinquencies > 0) who have a previous default on file 
--(cb_person_default_on_file = 'Y')?

SELECT
    ROUND(
        (SUM
            (CASE WHEN cb_person_default_on_file ='Y' THEN 1 ELSE 0 END)*100)/COUNT(*),2
        ) 
        AS percent_with_previous_default
FROM customer_loan_data
WHERE past_delinquencies > 0;

-- For high-interest loans (loan_int_rate > 12), what is the count of defaults 
--grouped by marital status (marital_status) and gender (gender)?

SELECT marital_status, gender,
    COUNT(CASE WHEN loan_status = 1 THEN 1 END) 
        AS default_count
FROM customer_loan_data
WHERE loan_int_rate > 12
GROUP BY marital_status,gender
ORDER BY marital_status,gender;        

-- What is the average loan-to-income ratio (loan_to_income_ratio) for clients 
--in the top 5 states by client count?

SELECT state, 
        ROUND(AVG(loan_to_income_ratio),2) AS avg_loan_to_income_ratio,
    COUNT(*) AS total_client
FROM customer_loan_data
GROUP BY state
ORDER BY total_client DESC
FETCH FIRST 5 ROWS ONLY;
 
-- How does the average credit history length (cb_person_cred_hist_length) 
--differ by country (country) and age groups (e.g., <30, 30-50, >50)?

SELECT country,
    CASE
        WHEN person_age <30 THEN '>30'
        WHEN person_age BETWEEN 30 AND 50 THEN '30-50'
        WHEN person_age >50 THEN '>50'
        ELSE 'other'
    END AS age_group,
    ROUND(AVG(cb_person_cred_hist_length),2) AS avg_cb_cred_hist_length
FROM customer_loan_data
GROUP BY country,
    CASE
        WHEN person_age <30 THEN '>30'
        WHEN person_age BETWEEN 30 AND 50 THEN '30-50'
        WHEN person_age >50 THEN '>50'
        ELSE 'other' END;

WITH country_cte AS(
    SELECT country,
    CASE
        WHEN person_age <30 THEN '>30'
        WHEN person_age BETWEEN 30 AND 50 THEN '30-50'
        WHEN person_age >50 THEN '>50'
        ELSE 'other'
    END AS age_group,
    cb_person_cred_hist_length
    FROM customer_loan_data
)
SELECT country,age_group,
    ROUND(AVG(cb_person_cred_hist_length),2) AS avg_cb_cred_hist_length
FROM country_cte
GROUP BY country,age_group
ORDER BY country,age_group;  

-- What is the total other debt (other_debt) and average credit utilization 
--ratio (credit_utilization_ratio) for clients in cities with latitude above 
--40 degrees (city_latitude > 40)?

SELECT city,
    ROUND(SUM(other_debt),2) AS sum_other_debt,
    ROUND(AVG(credit_utilization_ratio),2) AS avg_credit_utilization_ratio
FROM customer_loan_data
WHERE city_latitude > 40
GROUP BY city
ORDER BY city;

-- For self-employed clients (employment_type = 'Self-employed'), what is the 
--default rate grouped by education level (education_level)?

SELECT education_level,
    ROUND(
    SUM(CASE WHEN loan_status =1 THEN 1 ELSE 0 END)*100/COUNT(*),2) 
        AS default_rate
FROM customer_loan_data
WHERE employment_type = 'Self-employed'
GROUP BY education_level
ORDER BY education_level;

-- What is the correlation trend between employment length (person_emp_length) 
--and interest rate (loan_int_rate), grouped by loan grade (loan_grade) 
--(e.g., average interest rate per employment length bracket)?

WITH employment_cte AS(
SELECT loan_grade,loan_int_rate,
    CASE 
        WHEN person_emp_length <= 2 THEN '0-2'
        WHEN person_emp_length <= 5 THEN '3-5'
        WHEN person_emp_length <= 10 THEN '6-10'
        ELSE '>10'
    END AS emp_length_bracket
FROM customer_loan_data
)
SELECT loan_grade,
    emp_length_bracket,
    ROUND(AVG(loan_int_rate),2) AS avg_loan_interest_rate
FROM employment_cte
GROUP BY loan_grade, emp_length_bracket
ORDER BY loan_grade, emp_length_bracket;

-- How many clients have a loan percent income (loan_percent_income) above 0.4,
--and what is their average number of past delinquencies (past_delinquencies), 
--grouped by home ownership (person_home_ownership)?

SELECT person_home_ownership,
    COUNT(*) AS high_loan_percent_count,
    ROUND(AVG(past_delinquencies),2) AS avg_past_delinquencies
FROM customer_loan_data
WHERE loan_percent_income >0.4
GROUP BY person_home_ownership
ORDER BY person_home_ownership;

-- What is the year-over-year trend in default rates if we group by credit 
--history length (cb_person_cred_hist_length) as a proxy for years?

SELECT cb_person_cred_hist_length AS proxy_year,
    ROUND(
    SUM(CASE WHEN loan_status =1 THEN 1 ELSE 0 END)*100/COUNT(*),2) 
        AS default_rate
FROM customer_loan_data
WHERE cb_person_cred_hist_length IS NOT NULL
GROUP BY cb_person_cred_hist_length
ORDER BY cb_person_cred_hist_length;

-- For loans with terms longer than 36 months (loan_term_months > 36), what is 
--the count of defaults by intent (loan_intent) and country (country)?

SELECT country,
    loan_intent,
    COUNT(CASE WHEN loan_status =1 THEN 1 END) AS count_of_default
FROM customer_loan_data
WHERE loan_term_months > 36
    AND country IS NOT NULL
        AND loan_intent IS NOT NULL
GROUP BY country,loan_intent
ORDER BY country,loan_intent;

-- What is the average debt-to-income ratio (debt_to_income_ratio) for clients 
--in the USA, grouped by state (state) and sorted by descending average?

SELECT state,
    ROUND(
        AVG(debt_to_income_ratio),2) AS avg_debt_to_income_ratio
FROM customer_loan_data
WHERE country = 'USA'
    AND country IS NOT NULL
        AND state IS NOT NULL
GROUP BY state
ORDER BY avg_debt_to_income_ratio DESC;

-- How does the default rate vary for female clients (gender = 'Female') with 
--a Master's or PhD (education_level IN ('Master', 'PhD')), compared to males?

SELECT gender,
     ROUND(
    SUM(CASE WHEN loan_status =1 THEN 1 ELSE 0 END)*100/COUNT(*),2) 
        AS default_rate
FROM customer_loan_data
WHERE education_level IN ('Master', 'PhD') 
    AND education_level IS NOT NULL
GROUP BY gender
ORDER BY gender;

-- What is the total number of clients and average loan amount for cities with 
--longitude less than -100 (city_longitude < -100), grouped by city?

SELECT city,
    COUNT(*) AS total_clients,
    ROUND(AVG(loan_amnt),2) AS avg_loan_amnt
FROM customer_loan_data
WHERE city_longitude < -100
    AND city IS NOT NULL
GROUP BY city
ORDER BY city;

-- For clients with no past delinquencies (past_delinquencies = 0), what is the
--percentage who have open accounts greater than 10 (open_accounts > 10), 
--grouped by marital status (marital_status)?

SELECT marital_status,
    COUNT(open_accounts)/COUNT(*)
FROM customer_loan_data
WHERE past_delinquencies = 0
    AND open_accounts > 10
GROUP BY marital_status
ORDER BY marital_status;

SELECT 
    marital_status,
    ROUND(
        (SUM(CASE WHEN open_accounts > 10 THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 
        2
    ) AS percent_high_open_accounts
FROM customer_loan_data
WHERE past_delinquencies = 0 AND marital_status IS NOT NULL
GROUP BY marital_status
ORDER BY marital_status;
   
SELECT * FROM customer_loan_data;
