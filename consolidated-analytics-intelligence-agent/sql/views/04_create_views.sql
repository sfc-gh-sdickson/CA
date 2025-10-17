-- ============================================================================
-- Consolidated Analytics Intelligence Agent - Analytical Views
-- ============================================================================
-- Purpose: Create curated analytical views for common business queries
-- ============================================================================

USE DATABASE CONSOLIDATED_ANALYTICS_DB;
USE SCHEMA ANALYTICS;
USE WAREHOUSE CA_ANALYTICS_WH;

-- ============================================================================
-- View 1: Loan Portfolio Complete View
-- ============================================================================
CREATE OR REPLACE VIEW V_LOAN_PORTFOLIO AS
SELECT
    l.loan_id,
    l.loan_type,
    l.loan_status,
    l.risk_rating,
    l.loan_amount,
    l.interest_rate,
    l.loan_term,
    l.origination_date,
    l.maturity_date,
    l.current_balance,
    l.monthly_payment,
    l.ltv_ratio,
    l.dti_ratio,
    l.payment_count,
    l.delinquent_payments,
    -- Borrower information
    b.borrower_id,
    CONCAT(b.first_name, ' ', b.last_name) AS borrower_name,
    b.email AS borrower_email,
    b.credit_score,
    b.employment_status,
    b.annual_income,
    b.borrower_type,
    b.borrower_status,
    b.state AS borrower_state,
    b.city AS borrower_city,
    -- Property information
    p.property_id,
    p.property_address,
    p.property_type,
    p.property_value,
    p.square_footage,
    p.year_built,
    p.condition_rating,
    p.occupancy_status,
    p.state AS property_state,
    p.city AS property_city,
    -- Calculated fields
    l.loan_amount / NULLIF(b.annual_income, 0) AS loan_to_income_ratio,
    DATEDIFF('month', l.origination_date, CURRENT_DATE()) AS months_since_origination,
    DATEDIFF('month', CURRENT_DATE(), l.maturity_date) AS months_to_maturity,
    CASE 
        WHEN l.delinquent_payments = 0 THEN 'CURRENT'
        WHEN l.delinquent_payments BETWEEN 1 AND 2 THEN 'EARLY_DELINQUENCY'
        WHEN l.delinquent_payments >= 3 THEN 'SERIOUS_DELINQUENCY'
    END AS delinquency_category
FROM RAW.LOANS l
JOIN RAW.BORROWERS b ON l.borrower_id = b.borrower_id
JOIN RAW.PROPERTIES p ON l.property_id = p.property_id;

-- ============================================================================
-- View 2: Property Valuations Over Time
-- ============================================================================
CREATE OR REPLACE VIEW V_PROPERTY_VALUATIONS AS
SELECT
    v.valuation_id,
    v.property_id,
    p.property_address,
    p.property_type,
    p.state AS property_state,
    p.city AS property_city,
    p.property_value AS current_value,
    v.valuation_type,
    v.valuation_date,
    v.valuation_amount,
    v.valuation_method,
    v.confidence_level,
    v.market_conditions,
    v.comparable_count,
    -- Appraiser information
    a.analyst_id AS appraiser_id,
    a.analyst_name AS appraiser_name,
    a.specialization AS appraiser_specialization,
    a.certification_level,
    -- Calculated variance
    (v.valuation_amount - p.property_value) AS valuation_variance,
    ((v.valuation_amount - p.property_value) / NULLIF(p.property_value, 0) * 100) AS valuation_variance_pct,
    DATEDIFF('day', v.valuation_date, CURRENT_DATE()) AS days_since_valuation
FROM RAW.VALUATIONS v
JOIN RAW.PROPERTIES p ON v.property_id = p.property_id
LEFT JOIN RAW.ANALYSTS a ON v.appraiser_id = a.analyst_id;

-- ============================================================================
-- View 3: Due Diligence Review Metrics
-- ============================================================================
CREATE OR REPLACE VIEW V_DUE_DILIGENCE_METRICS AS
SELECT
    r.review_id,
    r.review_type,
    r.review_status,
    r.review_date,
    r.review_completion_date,
    r.compliance_score,
    r.risk_findings,
    r.exceptions_count,
    r.critical_findings,
    -- Loan information
    l.loan_id,
    l.loan_type,
    l.loan_amount,
    l.risk_rating AS loan_risk_rating,
    -- Reviewer information
    a.analyst_id AS reviewer_id,
    a.analyst_name AS reviewer_name,
    a.department AS reviewer_department,
    a.specialization AS reviewer_specialization,
    a.avg_review_score AS reviewer_avg_score,
    -- Calculated metrics
    DATEDIFF('day', r.review_date, r.review_completion_date) AS review_days,
    CASE 
        WHEN r.compliance_score >= 95 THEN 'EXCELLENT'
        WHEN r.compliance_score >= 85 THEN 'GOOD'
        WHEN r.compliance_score >= 75 THEN 'ACCEPTABLE'
        ELSE 'NEEDS_IMPROVEMENT'
    END AS compliance_rating,
    CASE 
        WHEN r.critical_findings > 0 THEN 'CRITICAL'
        WHEN r.exceptions_count > 5 THEN 'HIGH'
        WHEN r.exceptions_count > 2 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS exception_severity
FROM RAW.DUE_DILIGENCE_REVIEWS r
JOIN RAW.LOANS l ON r.loan_id = l.loan_id
LEFT JOIN RAW.ANALYSTS a ON r.reviewer_id = a.analyst_id;

-- ============================================================================
-- View 4: Portfolio Risk Analysis
-- ============================================================================
CREATE OR REPLACE VIEW V_PORTFOLIO_RISK AS
SELECT
    l.loan_id,
    l.loan_type,
    l.risk_rating,
    l.loan_status,
    l.loan_amount,
    l.current_balance,
    l.ltv_ratio,
    l.dti_ratio,
    b.credit_score,
    l.delinquent_payments,
    p.property_type,
    p.state AS property_state,
    -- Risk scoring
    CASE 
        WHEN l.risk_rating = 'A' THEN 1
        WHEN l.risk_rating = 'B' THEN 2
        WHEN l.risk_rating = 'C' THEN 3
        WHEN l.risk_rating = 'D' THEN 4
        ELSE 5
    END AS risk_score,
    CASE 
        WHEN l.ltv_ratio > 90 THEN 3
        WHEN l.ltv_ratio > 80 THEN 2
        ELSE 1
    END AS ltv_risk_score,
    CASE 
        WHEN b.credit_score < 620 THEN 3
        WHEN b.credit_score < 680 THEN 2
        ELSE 1
    END AS credit_risk_score,
    CASE 
        WHEN l.delinquent_payments >= 3 THEN 5
        WHEN l.delinquent_payments >= 1 THEN 3
        ELSE 1
    END AS delinquency_risk_score,
    -- Overall risk composite
    (
        CASE WHEN l.risk_rating = 'A' THEN 1 WHEN l.risk_rating = 'B' THEN 2 WHEN l.risk_rating = 'C' THEN 3 ELSE 4 END +
        CASE WHEN l.ltv_ratio > 90 THEN 3 WHEN l.ltv_ratio > 80 THEN 2 ELSE 1 END +
        CASE WHEN b.credit_score < 620 THEN 3 WHEN b.credit_score < 680 THEN 2 ELSE 1 END +
        CASE WHEN l.delinquent_payments >= 3 THEN 5 WHEN l.delinquent_payments >= 1 THEN 3 ELSE 1 END
    ) AS composite_risk_score
FROM RAW.LOANS l
JOIN RAW.BORROWERS b ON l.borrower_id = b.borrower_id
JOIN RAW.PROPERTIES p ON l.property_id = p.property_id;

-- ============================================================================
-- View 5: Transaction Analytics
-- ============================================================================
CREATE OR REPLACE VIEW V_TRANSACTION_ANALYTICS AS
SELECT
    t.transaction_id,
    t.transaction_date,
    t.transaction_type,
    t.amount,
    t.principal_amount,
    t.interest_amount,
    t.escrow_amount,
    t.payment_status,
    t.payment_method,
    -- Loan information
    l.loan_id,
    l.loan_type,
    l.loan_status,
    l.monthly_payment,
    l.current_balance,
    -- Borrower information
    b.borrower_id,
    CONCAT(b.first_name, ' ', b.last_name) AS borrower_name,
    -- Payment analysis
    (t.amount / NULLIF(l.monthly_payment, 0)) AS payment_to_scheduled_ratio,
    CASE 
        WHEN t.payment_status = 'COMPLETED' AND t.amount >= l.monthly_payment THEN 'ON_TIME_FULL'
        WHEN t.payment_status = 'COMPLETED' AND t.amount < l.monthly_payment THEN 'PARTIAL'
        WHEN t.payment_status = 'PENDING' THEN 'PENDING'
        ELSE 'MISSED'
    END AS payment_category,
    DATE_TRUNC('month', t.transaction_date) AS transaction_month
FROM RAW.TRANSACTIONS t
JOIN RAW.LOANS l ON t.loan_id = l.loan_id
JOIN RAW.BORROWERS b ON l.borrower_id = b.borrower_id;

-- ============================================================================
-- View 6: Analyst Performance Metrics
-- ============================================================================
CREATE OR REPLACE VIEW V_ANALYST_PERFORMANCE AS
SELECT
    a.analyst_id,
    a.analyst_name,
    a.department,
    a.specialization,
    a.certification_level,
    a.hire_date,
    a.avg_review_score,
    a.total_reviews_completed,
    -- Review metrics
    COUNT(DISTINCT r.review_id) AS total_reviews,
    AVG(r.compliance_score) AS avg_compliance_score,
    AVG(r.exceptions_count) AS avg_exceptions_per_review,
    AVG(DATEDIFF('day', r.review_date, r.review_completion_date)) AS avg_days_to_complete,
    SUM(r.critical_findings) AS total_critical_findings,
    -- Case metrics
    COUNT(DISTINCT c.case_id) AS total_cases_handled,
    AVG(c.resolution_time_hours) AS avg_case_resolution_hours,
    AVG(c.satisfaction_rating) AS avg_satisfaction_rating,
    -- Tenure
    DATEDIFF('day', a.hire_date, CURRENT_DATE()) AS days_tenure,
    DATEDIFF('month', a.hire_date, CURRENT_DATE()) AS months_tenure
FROM RAW.ANALYSTS a
LEFT JOIN RAW.DUE_DILIGENCE_REVIEWS r ON a.analyst_id = r.reviewer_id
LEFT JOIN RAW.SUPPORT_CASES c ON a.analyst_id = c.assigned_analyst_id
GROUP BY 
    a.analyst_id, a.analyst_name, a.department, a.specialization, 
    a.certification_level, a.hire_date, a.avg_review_score, a.total_reviews_completed;

-- ============================================================================
-- View 7: Client 360 View
-- ============================================================================
CREATE OR REPLACE VIEW V_CLIENT_360 AS
SELECT
    b.borrower_id,
    CONCAT(b.first_name, ' ', b.last_name) AS borrower_name,
    b.email,
    b.phone,
    b.credit_score,
    b.employment_status,
    b.annual_income,
    b.debt_to_income_ratio,
    b.borrower_type,
    b.borrower_status,
    b.state AS borrower_state,
    -- Loan metrics
    COUNT(DISTINCT l.loan_id) AS total_loans,
    SUM(l.loan_amount) AS total_loan_amount,
    SUM(l.current_balance) AS total_current_balance,
    AVG(l.interest_rate) AS avg_interest_rate,
    SUM(CASE WHEN l.loan_status = 'ACTIVE' THEN 1 ELSE 0 END) AS active_loans,
    SUM(CASE WHEN l.delinquent_payments > 0 THEN 1 ELSE 0 END) AS delinquent_loans,
    -- Transaction metrics
    COUNT(DISTINCT t.transaction_id) AS total_transactions,
    SUM(t.amount) AS total_payments,
    -- Support metrics
    COUNT(DISTINCT c.case_id) AS total_support_cases,
    SUM(CASE WHEN c.status = 'OPEN' THEN 1 ELSE 0 END) AS open_cases,
    AVG(c.satisfaction_rating) AS avg_satisfaction,
    -- Property metrics
    COUNT(DISTINCT p.property_id) AS total_properties,
    SUM(p.property_value) AS total_property_value
FROM RAW.BORROWERS b
LEFT JOIN RAW.LOANS l ON b.borrower_id = l.borrower_id
LEFT JOIN RAW.TRANSACTIONS t ON l.loan_id = t.loan_id
LEFT JOIN RAW.SUPPORT_CASES c ON b.borrower_id = c.borrower_id
LEFT JOIN RAW.PROPERTIES p ON l.property_id = p.property_id
GROUP BY
    b.borrower_id, b.first_name, b.last_name, b.email, b.phone, 
    b.credit_score, b.employment_status, b.annual_income, 
    b.debt_to_income_ratio, b.borrower_type, b.borrower_status, b.state;

-- ============================================================================
-- Display confirmation
-- ============================================================================
SELECT 'Analytical views created successfully' AS status;

-- Verify views exist
SELECT 
    table_name AS view_name,
    comment AS description
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'ANALYTICS'
  AND table_name LIKE 'V_%'
ORDER BY table_name;

