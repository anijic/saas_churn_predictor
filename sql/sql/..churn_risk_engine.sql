/*
  Project: SaaS Revenue Protection System
  Author: Charles Aniji (Chemical Engineer & Data Consultant)
  Objective: Identify High-Risk Customers via Heuristic Scoring Engine (Logic Loop)
  
  Engineering Principle: "Safety Factors"
  Instead of a black-box AI prediction, we apply a transparent "Risk Score" (0-100) 
  based on known failure modes (Contract Type, Payment Friction, Service Gaps).
*/

-- STEP 1: MASS BALANCE (Simulating the Join of 3 Source Tables)
-- In a real warehouse, these would be separate tables. We demonstrate the join logic here.
WITH raw_data_assembly AS (
    SELECT 
        c.customerID,
        -- Demographics (The "Material Properties")
        c.SeniorCitizen,
        c.Partner,
        c.Dependents,
        
        -- Service Configuration (The "Unit Ops")
        c.tenure,
        c.InternetService,
        c.OnlineSecurity,
        c.TechSupport,
        c.Contract,
        
        -- Billing Variables (The "Flow Rate")
        c.PaperlessBilling,
        c.PaymentMethod,
        c.MonthlyCharges,
        c.TotalCharges,
        c.Churn
    FROM `raw_telco_data` c  -- Assumes raw CSV is loaded here
),

-- STEP 2: RISK FACTOR CALCULATION (The "Control Logic")
-- We assign weighted penalty points for known churn drivers.
risk_factors AS (
    SELECT 
        customerID,
        MonthlyCharges,
        Contract,
        
        -- Risk 1: Contract Flexibility (High Volatility)
        CASE 
            WHEN Contract = 'Month-to-month' THEN 40 
            WHEN Contract = 'One year' THEN 10 
            ELSE 0 
        END AS risk_contract,

        -- Risk 2: Service Quality / Friction (Fiber Optic has higher churn in this dataset)
        CASE 
            WHEN InternetService = 'Fiber optic' THEN 25 
            ELSE 0 
        END AS risk_service_type,

        -- Risk 3: Lack of Support (Safety Net Missing)
        CASE 
            WHEN TechSupport = 'No' THEN 20 
            ELSE 0 
        END AS risk_no_support,

        -- Risk 4: Payment Friction
        CASE 
            WHEN PaymentMethod = 'Electronic check' THEN 15 
            ELSE 0 
        END AS risk_payment_type

    FROM raw_data_assembly
),

-- STEP 3: FINAL SCORING & CATEGORIZATION (The "Output Stream")
scored_customers AS (
    SELECT 
        customerID,
        MonthlyCharges,
        Contract,
        
        -- Total Risk Score (0 to 100)
        (risk_contract + risk_service_type + risk_no_support + risk_payment_type) as churn_risk_score,
        
        -- Priority Tiers for Action
        CASE 
            WHEN (risk_contract + risk_service_type + risk_no_support + risk_payment_type) >= 75 THEN 'CRITICAL'
            WHEN (risk_contract + risk_service_type + risk_no_support + risk_payment_type) >= 50 THEN 'High'
            WHEN (risk_contract + risk_service_type + risk_no_support + risk_payment_type) >= 25 THEN 'Medium'
            ELSE 'Low'
        END as risk_category
    FROM risk_factors
)

-- FINAL REPORT: REVENUE AT RISK ANALYSIS
SELECT 
    risk_category,
    COUNT(customerID) as customer_count,
    ROUND(SUM(MonthlyCharges), 2) as monthly_revenue_at_risk,
    ROUND(AVG(churn_risk_score), 1) as avg_risk_score
FROM scored_customers
GROUP BY risk_category
ORDER BY monthly_revenue_at_risk DESC;
