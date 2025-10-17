-- ============================================================================
-- Consolidated Analytics Intelligence Agent - Synthetic Data Generation
-- ============================================================================
-- Purpose: Generate realistic sample data for mortgage and real estate finance
-- Volume: 50K borrowers, 60K properties, 75K loans, 1M transactions
-- ============================================================================

USE DATABASE CONSOLIDATED_ANALYTICS_DB;
USE SCHEMA RAW;
USE WAREHOUSE CA_ANALYTICS_WH;

-- ============================================================================
-- Step 1: Generate Analysts
-- ============================================================================
INSERT INTO ANALYSTS
SELECT
    'ANL' || LPAD(SEQ4(), 5, '0') AS analyst_id,
    ARRAY_CONSTRUCT('John Smith', 'Sarah Johnson', 'Michael Chen', 'Emily Williams', 'David Martinez',
                    'Jessica Brown', 'Christopher Lee', 'Amanda Garcia', 'Matthew Rodriguez', 'Ashley Lopez',
                    'James Wilson', 'Mary Taylor', 'Robert Anderson', 'Jennifer Thomas', 'William Jackson')[UNIFORM(0, 14, RANDOM())] 
        || ' ' || ARRAY_CONSTRUCT('Sr', 'Jr', 'II', 'III', '')[UNIFORM(0, 4, RANDOM())] AS analyst_name,
    'analyst' || SEQ4() || '@consolidatedanalytics.com' AS email,
    ARRAY_CONSTRUCT('UNDERWRITING', 'APPRAISAL', 'QC_REVIEW', 'COMPLIANCE', 'VALUATION')[UNIFORM(0, 4, RANDOM())] AS department,
    ARRAY_CONSTRUCT('FHA Loans', 'VA Loans', 'Commercial RE', 'Residential Appraisal', 'Compliance Audit', 
                    'Desktop Valuation', 'Portfolio Review', 'Risk Assessment')[UNIFORM(0, 7, RANDOM())] AS specialization,
    DATEADD('day', -1 * UNIFORM(90, 3650, RANDOM()), CURRENT_DATE()) AS hire_date,
    ARRAY_CONSTRUCT('CERTIFIED', 'SENIOR', 'PRINCIPAL', 'ASSOCIATE')[UNIFORM(0, 3, RANDOM())] AS certification_level,
    (UNIFORM(75, 98, RANDOM()) / 1.0)::NUMBER(5,2) AS avg_review_score,
    UNIFORM(50, 5000, RANDOM()) AS total_reviews_completed,
    'ACTIVE' AS analyst_status,
    DATEADD('day', -1 * UNIFORM(90, 3650, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM TABLE(GENERATOR(ROWCOUNT => 200));

-- ============================================================================
-- Step 2: Generate Portfolio Segments
-- ============================================================================
INSERT INTO PORTFOLIO_SEGMENTS VALUES
('SEG001', 'Prime Residential', 'RESIDENTIAL', 'LOW', 80.00, 720, 25.00, CURRENT_TIMESTAMP()),
('SEG002', 'Alt-A Residential', 'RESIDENTIAL', 'MEDIUM', 85.00, 660, 20.00, CURRENT_TIMESTAMP()),
('SEG003', 'Subprime Residential', 'RESIDENTIAL', 'HIGH', 90.00, 620, 10.00, CURRENT_TIMESTAMP()),
('SEG004', 'Prime Commercial', 'COMMERCIAL', 'LOW', 75.00, 700, 30.00, CURRENT_TIMESTAMP()),
('SEG005', 'Multi-Family', 'MULTI_FAMILY', 'MEDIUM', 80.00, 680, 15.00, CURRENT_TIMESTAMP()),
('SEG006', 'Jumbo Prime', 'JUMBO', 'LOW', 70.00, 740, 20.00, CURRENT_TIMESTAMP()),
('SEG007', 'FHA/VA Government', 'GOVERNMENT', 'MEDIUM', 96.50, 580, 25.00, CURRENT_TIMESTAMP());

-- ============================================================================
-- Step 3: Generate Borrowers
-- ============================================================================
INSERT INTO BORROWERS
SELECT
    'BOR' || LPAD(SEQ4(), 10, '0') AS borrower_id,
    ARRAY_CONSTRUCT('James', 'John', 'Robert', 'Michael', 'William', 'David', 'Richard', 'Joseph', 
                    'Thomas', 'Charles', 'Mary', 'Patricia', 'Jennifer', 'Linda', 'Elizabeth', 
                    'Barbara', 'Susan', 'Jessica', 'Sarah', 'Karen')[UNIFORM(0, 19, RANDOM())] AS first_name,
    ARRAY_CONSTRUCT('Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis', 
                    'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Gonzalez', 'Wilson', 'Anderson', 
                    'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin')[UNIFORM(0, 19, RANDOM())] AS last_name,
    'borrower' || SEQ4() || '@' || ARRAY_CONSTRUCT('gmail', 'yahoo', 'outlook', 'hotmail', 'protonmail')[UNIFORM(0, 4, RANDOM())] || '.com' AS email,
    CONCAT('+1-', UNIFORM(200, 999, RANDOM()), '-', UNIFORM(100, 999, RANDOM()), '-', UNIFORM(1000, 9999, RANDOM())) AS phone,
    DATEADD('year', -1 * UNIFORM(25, 65, RANDOM()), CURRENT_DATE()) AS date_of_birth,
    CASE 
        WHEN UNIFORM(0, 100, RANDOM()) < 40 THEN UNIFORM(740, 850, RANDOM())
        WHEN UNIFORM(0, 100, RANDOM()) < 75 THEN UNIFORM(660, 739, RANDOM())
        ELSE UNIFORM(580, 659, RANDOM())
    END AS credit_score,
    ARRAY_CONSTRUCT('EMPLOYED_FULL_TIME', 'EMPLOYED_PART_TIME', 'SELF_EMPLOYED', 'RETIRED', 'CONTRACTOR')[UNIFORM(0, 4, RANDOM())] AS employment_status,
    (UNIFORM(35000, 250000, RANDOM()) / 1.0)::NUMBER(12,2) AS annual_income,
    (UNIFORM(15, 45, RANDOM()) / 1.0)::NUMBER(5,2) AS debt_to_income_ratio,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 85 THEN 'INDIVIDUAL' ELSE 'BUSINESS' END AS borrower_type,
    CASE 
        WHEN UNIFORM(0, 100, RANDOM()) < 90 THEN 'ACTIVE'
        WHEN UNIFORM(0, 100, RANDOM()) < 5 THEN 'DELINQUENT'
        ELSE 'CLOSED'
    END AS borrower_status,
    ARRAY_CONSTRUCT('CA', 'TX', 'FL', 'NY', 'PA', 'IL', 'OH', 'GA', 'NC', 'MI', 
                    'NJ', 'VA', 'WA', 'AZ', 'MA', 'TN', 'IN', 'MO', 'MD', 'WI')[UNIFORM(0, 19, RANDOM())] AS state,
    ARRAY_CONSTRUCT('Los Angeles', 'Houston', 'Phoenix', 'Philadelphia', 'San Antonio', 'San Diego', 
                    'Dallas', 'San Jose', 'Austin', 'Jacksonville', 'Fort Worth', 'Columbus', 
                    'Charlotte', 'San Francisco', 'Indianapolis', 'Seattle', 'Denver', 'Boston')[UNIFORM(0, 17, RANDOM())] AS city,
    DATEADD('day', -1 * UNIFORM(30, 3650, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM TABLE(GENERATOR(ROWCOUNT => 50000));

-- ============================================================================
-- Step 4: Generate Properties
-- ============================================================================
INSERT INTO PROPERTIES
SELECT
    'PROP' || LPAD(SEQ4(), 10, '0') AS property_id,
    UNIFORM(100, 9999, RANDOM())::VARCHAR || ' ' || 
        ARRAY_CONSTRUCT('Main', 'Oak', 'Maple', 'Pine', 'Cedar', 'Elm', 'Washington', 'Lake', 'Hill', 'Park',
                        'Sunset', 'Broadway', 'Madison', 'Jackson', 'Lincoln')[UNIFORM(0, 14, RANDOM())] || ' ' ||
        ARRAY_CONSTRUCT('St', 'Ave', 'Blvd', 'Dr', 'Ln', 'Rd', 'Way', 'Ct')[UNIFORM(0, 7, RANDOM())] AS property_address,
    ARRAY_CONSTRUCT('Los Angeles', 'Houston', 'Phoenix', 'Philadelphia', 'San Antonio', 'San Diego', 
                    'Dallas', 'San Jose', 'Austin', 'Jacksonville', 'Fort Worth', 'Columbus', 
                    'Charlotte', 'San Francisco', 'Indianapolis', 'Seattle', 'Denver', 'Boston')[UNIFORM(0, 17, RANDOM())] AS city,
    ARRAY_CONSTRUCT('CA', 'TX', 'FL', 'NY', 'PA', 'IL', 'OH', 'GA', 'NC', 'MI', 
                    'NJ', 'VA', 'WA', 'AZ', 'MA', 'TN', 'IN', 'MO', 'MD', 'WI')[UNIFORM(0, 19, RANDOM())] AS state,
    LPAD(UNIFORM(10000, 99999, RANDOM()), 5, '0') AS zip_code,
    CASE 
        WHEN UNIFORM(0, 100, RANDOM()) < 70 THEN 'RESIDENTIAL_SINGLE_FAMILY'
        WHEN UNIFORM(0, 100, RANDOM()) < 85 THEN 'RESIDENTIAL_CONDO'
        WHEN UNIFORM(0, 100, RANDOM()) < 95 THEN 'MULTI_FAMILY'
        ELSE 'COMMERCIAL'
    END AS property_type,
    CASE 
        WHEN UNIFORM(0, 100, RANDOM()) < 70 THEN (UNIFORM(150000, 600000, RANDOM()) / 1.0)::NUMBER(12,2)
        WHEN UNIFORM(0, 100, RANDOM()) < 90 THEN (UNIFORM(600000, 2000000, RANDOM()) / 1.0)::NUMBER(12,2)
        ELSE (UNIFORM(2000000, 50000000, RANDOM()) / 1.0)::NUMBER(12,2)
    END AS property_value,
    DATEADD('day', -1 * UNIFORM(30, 730, RANDOM()), CURRENT_DATE()) AS appraisal_date,
    CASE 
        WHEN UNIFORM(0, 100, RANDOM()) < 80 THEN UNIFORM(1000, 3500, RANDOM())
        ELSE UNIFORM(3500, 15000, RANDOM())
    END AS square_footage,
    UNIFORM(1950, 2024, RANDOM()) AS year_built,
    UNIFORM(2, 6, RANDOM()) AS bedrooms,
    UNIFORM(1, 4, RANDOM()) + (UNIFORM(0, 1, RANDOM()) * 0.5) AS bathrooms,
    ARRAY_CONSTRUCT('EXCELLENT', 'GOOD', 'AVERAGE', 'FAIR', 'POOR')[UNIFORM(0, 4, RANDOM())] AS condition_rating,
    ARRAY_CONSTRUCT('OWNER_OCCUPIED', 'RENTED', 'VACANT', 'SECOND_HOME')[UNIFORM(0, 3, RANDOM())] AS occupancy_status,
    ARRAY_CONSTRUCT('ACTIVE', 'PENDING', 'UNDER_CONTRACT', 'SOLD')[UNIFORM(0, 3, RANDOM())] AS market_status,
    DATEADD('day', -1 * UNIFORM(30, 3650, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM TABLE(GENERATOR(ROWCOUNT => 60000));

-- ============================================================================
-- Step 5: Generate Loans
-- ============================================================================
INSERT INTO LOANS
SELECT
    'LOAN' || LPAD(SEQ4(), 10, '0') AS loan_id,
    b.borrower_id,
    p.property_id,
    CASE 
        WHEN p.property_value < 600000 THEN (UNIFORM(100000, 500000, RANDOM()) / 1.0)::NUMBER(12,2)
        WHEN p.property_value < 2000000 THEN (UNIFORM(500000, 1500000, RANDOM()) / 1.0)::NUMBER(12,2)
        ELSE (UNIFORM(1500000, 40000000, RANDOM()) / 1.0)::NUMBER(12,2)
    END AS loan_amount,
    CASE 
        WHEN UNIFORM(0, 100, RANDOM()) < 30 THEN (UNIFORM(250, 400, RANDOM()) / 100.0)::NUMBER(5,3)
        WHEN UNIFORM(0, 100, RANDOM()) < 70 THEN (UNIFORM(400, 650, RANDOM()) / 100.0)::NUMBER(5,3)
        ELSE (UNIFORM(650, 850, RANDOM()) / 100.0)::NUMBER(5,3)
    END AS interest_rate,
    ARRAY_CONSTRUCT(180, 240, 360)[UNIFORM(0, 2, RANDOM())] AS loan_term,
    ARRAY_CONSTRUCT('CONVENTIONAL', 'FHA', 'VA', 'JUMBO', 'COMMERCIAL', 'USDA')[UNIFORM(0, 5, RANDOM())] AS loan_type,
    DATEADD('day', -1 * UNIFORM(30, 1825, RANDOM()), CURRENT_DATE()) AS origination_date,
    DATEADD('month', ARRAY_CONSTRUCT(180, 240, 360)[UNIFORM(0, 2, RANDOM())], 
            DATEADD('day', -1 * UNIFORM(30, 1825, RANDOM()), CURRENT_DATE())) AS maturity_date,
    CASE 
        WHEN UNIFORM(0, 100, RANDOM()) < 88 THEN 'ACTIVE'
        WHEN UNIFORM(0, 100, RANDOM()) < 5 THEN 'DELINQUENT'
        WHEN UNIFORM(0, 100, RANDOM()) < 3 THEN 'DEFAULT'
        WHEN UNIFORM(0, 100, RANDOM()) < 2 THEN 'PAID_OFF'
        ELSE 'FORECLOSURE'
    END AS loan_status,
    (UNIFORM(60, 97, RANDOM()) / 1.0)::NUMBER(5,2) AS ltv_ratio,
    b.debt_to_income_ratio AS dti_ratio,
    b.credit_score AS credit_score,
    CASE 
        WHEN b.credit_score >= 740 AND UNIFORM(60, 97, RANDOM()) <= 80 THEN 'A'
        WHEN b.credit_score >= 680 AND UNIFORM(60, 97, RANDOM()) <= 85 THEN 'B'
        WHEN b.credit_score >= 620 THEN 'C'
        ELSE 'D'
    END AS risk_rating,
    (UNIFORM(95000, 500000, RANDOM()) / 1.0)::NUMBER(12,2) AS current_balance,
    (UNIFORM(800, 5000, RANDOM()) / 1.0)::NUMBER(10,2) AS monthly_payment,
    UNIFORM(0, 60, RANDOM()) AS payment_count,
    CASE 
        WHEN UNIFORM(0, 100, RANDOM()) < 88 THEN 0
        ELSE UNIFORM(1, 6, RANDOM())
    END AS delinquent_payments,
    DATEADD('day', -1 * UNIFORM(30, 1825, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM BORROWERS b
CROSS JOIN PROPERTIES p
WHERE UNIFORM(0, 100, RANDOM()) < 3
LIMIT 75000;

-- ============================================================================
-- Step 6: Generate Valuations
-- ============================================================================
INSERT INTO VALUATIONS
SELECT
    'VAL' || LPAD(SEQ4(), 10, '0') AS valuation_id,
    p.property_id,
    ARRAY_CONSTRUCT('FULL_APPRAISAL', 'DESKTOP_APPRAISAL', 'BPO', 'AVM', 'DRIVE_BY')[UNIFORM(0, 4, RANDOM())] AS valuation_type,
    p.appraisal_date AS valuation_date,
    (p.property_value * (UNIFORM(95, 105, RANDOM()) / 100.0))::NUMBER(12,2) AS valuation_amount,
    'ANL' || LPAD(UNIFORM(1, 200, RANDOM()), 5, '0') AS appraiser_id,
    ARRAY_CONSTRUCT('SALES_COMPARISON', 'COST_APPROACH', 'INCOME_APPROACH', 'HYBRID')[UNIFORM(0, 3, RANDOM())] AS valuation_method,
    ARRAY_CONSTRUCT('HIGH', 'MEDIUM', 'LOW')[UNIFORM(0, 2, RANDOM())] AS confidence_level,
    ARRAY_CONSTRUCT('STRONG', 'STABLE', 'DECLINING', 'VOLATILE', 'IMPROVING')[UNIFORM(0, 4, RANDOM())] AS market_conditions,
    UNIFORM(3, 8, RANDOM()) AS comparable_count,
    (UNIFORM(-50000, 50000, RANDOM()) / 1.0)::NUMBER(12,2) AS adjustment_amount,
    p.created_at AS created_at
FROM PROPERTIES p
CROSS JOIN TABLE(GENERATOR(ROWCOUNT => 2))
WHERE UNIFORM(0, 100, RANDOM()) < 65
LIMIT 80000;

-- ============================================================================
-- Step 7: Generate Due Diligence Reviews
-- ============================================================================
INSERT INTO DUE_DILIGENCE_REVIEWS
SELECT
    'REV' || LPAD(SEQ4(), 10, '0') AS review_id,
    l.loan_id,
    ARRAY_CONSTRUCT('PRE_FUNDING', 'POST_CLOSING', 'COMPLIANCE_AUDIT', 'QUALITY_CONTROL', 'PORTFOLIO_REVIEW')[UNIFORM(0, 4, RANDOM())] AS review_type,
    DATEADD('day', UNIFORM(5, 90, RANDOM()), l.origination_date) AS review_date,
    'ANL' || LPAD(UNIFORM(1, 200, RANDOM()), 5, '0') AS reviewer_id,
    CASE 
        WHEN UNIFORM(0, 100, RANDOM()) < 75 THEN 'COMPLETED'
        WHEN UNIFORM(0, 100, RANDOM()) < 15 THEN 'IN_PROGRESS'
        ELSE 'PENDING'
    END AS review_status,
    (UNIFORM(70, 100, RANDOM()) / 1.0)::NUMBER(5,2) AS compliance_score,
    UNIFORM(0, 15, RANDOM()) AS risk_findings,
    UNIFORM(0, 8, RANDOM()) AS exceptions_count,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 10 THEN UNIFORM(1, 3, RANDOM()) ELSE 0 END AS critical_findings,
    CASE 
        WHEN UNIFORM(0, 100, RANDOM()) < 75 THEN DATEADD('day', UNIFORM(7, 30, RANDOM()), DATEADD('day', UNIFORM(5, 90, RANDOM()), l.origination_date))
        ELSE NULL
    END AS review_completion_date,
    ARRAY_CONSTRUCT(
        'Review completed with minor findings',
        'All documentation verified and compliant',
        'Exceptions noted in credit documentation',
        'Property valuation reviewed and approved',
        'Income verification requires additional documentation',
        'Title issues identified and resolved',
        'Appraisal review shows acceptable variance'
    )[UNIFORM(0, 6, RANDOM())] AS findings_summary,
    DATEADD('day', UNIFORM(5, 90, RANDOM()), l.origination_date) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM LOANS l
CROSS JOIN TABLE(GENERATOR(ROWCOUNT => 2))
WHERE UNIFORM(0, 100, RANDOM()) < 70
LIMIT 100000;

-- ============================================================================
-- Step 8: Generate Transactions
-- ============================================================================
INSERT INTO TRANSACTIONS
SELECT
    'TXN' || LPAD(SEQ4(), 12, '0') AS transaction_id,
    l.loan_id,
    DATEADD('day', -1 * UNIFORM(0, 1095, RANDOM()), CURRENT_TIMESTAMP()) AS transaction_date,
    ARRAY_CONSTRUCT('PRINCIPAL_PAYMENT', 'INTEREST_PAYMENT', 'FULL_PAYMENT', 'PARTIAL_PAYMENT', 
                    'ESCROW_PAYMENT', 'LATE_FEE', 'DISBURSEMENT')[UNIFORM(0, 6, RANDOM())] AS transaction_type,
    (l.monthly_payment * (UNIFORM(80, 120, RANDOM()) / 100.0))::NUMBER(12,2) AS amount,
    (l.monthly_payment * 0.6 * (UNIFORM(80, 120, RANDOM()) / 100.0))::NUMBER(12,2) AS principal_amount,
    (l.monthly_payment * 0.35 * (UNIFORM(80, 120, RANDOM()) / 100.0))::NUMBER(12,2) AS interest_amount,
    (l.monthly_payment * 0.05 * (UNIFORM(80, 120, RANDOM()) / 100.0))::NUMBER(12,2) AS escrow_amount,
    CASE 
        WHEN UNIFORM(0, 100, RANDOM()) < 96 THEN 'COMPLETED'
        WHEN UNIFORM(0, 100, RANDOM()) < 2 THEN 'PENDING'
        ELSE 'FAILED'
    END AS payment_status,
    ARRAY_CONSTRUCT('ACH', 'WIRE', 'CHECK', 'CREDIT_CARD', 'ONLINE_PAYMENT')[UNIFORM(0, 4, RANDOM())] AS payment_method,
    DATEADD('day', -1 * UNIFORM(0, 1095, RANDOM()), CURRENT_TIMESTAMP()) AS created_at
FROM LOANS l
CROSS JOIN TABLE(GENERATOR(ROWCOUNT => 15))
WHERE UNIFORM(0, 100, RANDOM()) < 90
LIMIT 1000000;

-- ============================================================================
-- Step 9: Generate Support Cases
-- ============================================================================
INSERT INTO SUPPORT_CASES
SELECT
    'CASE' || LPAD(SEQ4(), 10, '0') AS case_id,
    l.borrower_id,
    l.loan_id,
    ARRAY_CONSTRUCT('PAYMENT_INQUIRY', 'LOAN_MODIFICATION', 'DOCUMENTATION_REQUEST', 
                    'ESCROW_INQUIRY', 'PAYOFF_REQUEST', 'RATE_INQUIRY', 'STATEMENT_REQUEST',
                    'COMPLAINT', 'GENERAL_INQUIRY')[UNIFORM(0, 8, RANDOM())] AS case_type,
    ARRAY_CONSTRUCT('LOW', 'MEDIUM', 'HIGH', 'URGENT')[UNIFORM(0, 3, RANDOM())] AS priority,
    CASE 
        WHEN UNIFORM(0, 100, RANDOM()) < 70 THEN 'RESOLVED'
        WHEN UNIFORM(0, 100, RANDOM()) < 20 THEN 'IN_PROGRESS'
        ELSE 'OPEN'
    END AS status,
    'ANL' || LPAD(UNIFORM(1, 200, RANDOM()), 5, '0') AS assigned_analyst_id,
    DATEADD('day', -1 * UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP()) AS created_date,
    CASE 
        WHEN UNIFORM(0, 100, RANDOM()) < 70 
        THEN DATEADD('hour', UNIFORM(2, 72, RANDOM()), DATEADD('day', -1 * UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP()))
        ELSE NULL
    END AS resolved_date,
    CASE 
        WHEN UNIFORM(0, 100, RANDOM()) < 70 THEN (UNIFORM(2, 72, RANDOM()) / 1.0)::NUMBER(10,2)
        ELSE NULL
    END AS resolution_time_hours,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 70 THEN UNIFORM(1, 5, RANDOM()) ELSE NULL END AS satisfaction_rating,
    ARRAY_CONSTRUCT(
        'Customer requesting payment history',
        'Borrower inquiring about loan modification options',
        'Documentation needed for refinance',
        'Escrow account balance inquiry',
        'Request for payoff quote',
        'Question about interest rate adjustment',
        'Monthly statement not received'
    )[UNIFORM(0, 6, RANDOM())] AS case_description,
    DATEADD('day', -1 * UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM LOANS l
WHERE UNIFORM(0, 100, RANDOM()) < 70
LIMIT 50000;

-- ============================================================================
-- Step 10: Generate Compliance Documents
-- ============================================================================
INSERT INTO COMPLIANCE_DOCUMENTS
SELECT
    'DOC' || LPAD(SEQ4(), 10, '0') AS document_id,
    l.loan_id,
    ARRAY_CONSTRUCT('CLOSING_DISCLOSURE', 'LOAN_ESTIMATE', 'APPRAISAL', 'TITLE_INSURANCE', 
                    'DEED_OF_TRUST', 'PROMISSORY_NOTE', 'TRID_DOCUMENTS', 'DISCLOSURE_PACKAGE')[UNIFORM(0, 7, RANDOM())] AS document_type,
    l.origination_date AS document_date,
    CASE 
        WHEN UNIFORM(0, 100, RANDOM()) < 85 THEN 'APPROVED'
        WHEN UNIFORM(0, 100, RANDOM()) < 10 THEN 'PENDING'
        ELSE 'REQUIRES_CORRECTION'
    END AS compliance_status,
    DATEADD('year', UNIFORM(3, 7, RANDOM()), l.origination_date) AS expiration_date,
    'ANL' || LPAD(UNIFORM(1, 200, RANDOM()), 5, '0') AS reviewer_id,
    ARRAY_CONSTRUCT(
        'Document reviewed and approved',
        'All required disclosures present',
        'Minor corrections needed',
        'Compliant with TRID requirements',
        'All signatures verified'
    )[UNIFORM(0, 4, RANDOM())] AS review_notes,
    l.created_at AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM LOANS l
CROSS JOIN TABLE(GENERATOR(ROWCOUNT => 3))
WHERE UNIFORM(0, 100, RANDOM()) < 80
LIMIT 200000;

-- ============================================================================
-- Display summary statistics
-- ============================================================================
SELECT 'Data generation completed successfully' AS status;

SELECT 'BORROWERS' AS table_name, COUNT(*) AS row_count FROM BORROWERS
UNION ALL
SELECT 'PROPERTIES', COUNT(*) FROM PROPERTIES
UNION ALL
SELECT 'LOANS', COUNT(*) FROM LOANS
UNION ALL
SELECT 'VALUATIONS', COUNT(*) FROM VALUATIONS
UNION ALL
SELECT 'DUE_DILIGENCE_REVIEWS', COUNT(*) FROM DUE_DILIGENCE_REVIEWS
UNION ALL
SELECT 'TRANSACTIONS', COUNT(*) FROM TRANSACTIONS
UNION ALL
SELECT 'SUPPORT_CASES', COUNT(*) FROM SUPPORT_CASES
UNION ALL
SELECT 'ANALYSTS', COUNT(*) FROM ANALYSTS
UNION ALL
SELECT 'PORTFOLIO_SEGMENTS', COUNT(*) FROM PORTFOLIO_SEGMENTS
UNION ALL
SELECT 'COMPLIANCE_DOCUMENTS', COUNT(*) FROM COMPLIANCE_DOCUMENTS
ORDER BY table_name;

