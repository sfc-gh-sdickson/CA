-- ============================================================================
-- Consolidated Analytics Intelligence Agent - Table Definitions
-- ============================================================================
-- Purpose: Create all necessary tables for mortgage and real estate finance
-- Based on verified GoDaddy template structure
-- ============================================================================

USE DATABASE CONSOLIDATED_ANALYTICS_DB;
USE SCHEMA RAW;
USE WAREHOUSE CA_ANALYTICS_WH;

-- ============================================================================
-- BORROWERS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE BORROWERS (
    borrower_id VARCHAR(20) PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(200) NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    credit_score NUMBER(5,0),
    employment_status VARCHAR(50),
    annual_income NUMBER(12,2),
    debt_to_income_ratio NUMBER(5,2),
    borrower_type VARCHAR(30) DEFAULT 'INDIVIDUAL',
    borrower_status VARCHAR(30) DEFAULT 'ACTIVE',
    state VARCHAR(2),
    city VARCHAR(100),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- PROPERTIES TABLE
-- ============================================================================
CREATE OR REPLACE TABLE PROPERTIES (
    property_id VARCHAR(30) PRIMARY KEY,
    property_address VARCHAR(500) NOT NULL,
    city VARCHAR(100),
    state VARCHAR(2),
    zip_code VARCHAR(10),
    property_type VARCHAR(50) NOT NULL,
    property_value NUMBER(12,2),
    appraisal_date DATE,
    square_footage NUMBER(10,0),
    year_built NUMBER(4,0),
    bedrooms NUMBER(3,0),
    bathrooms NUMBER(4,1),
    condition_rating VARCHAR(20),
    occupancy_status VARCHAR(30),
    market_status VARCHAR(30),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- LOANS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE LOANS (
    loan_id VARCHAR(30) PRIMARY KEY,
    borrower_id VARCHAR(20) NOT NULL,
    property_id VARCHAR(30) NOT NULL,
    loan_amount NUMBER(12,2) NOT NULL,
    interest_rate NUMBER(5,3) NOT NULL,
    loan_term NUMBER(5,0) NOT NULL,
    loan_type VARCHAR(50) NOT NULL,
    origination_date DATE NOT NULL,
    maturity_date DATE NOT NULL,
    loan_status VARCHAR(30) DEFAULT 'ACTIVE',
    ltv_ratio NUMBER(5,2),
    dti_ratio NUMBER(5,2),
    credit_score NUMBER(5,0),
    risk_rating VARCHAR(10),
    current_balance NUMBER(12,2),
    monthly_payment NUMBER(10,2),
    payment_count NUMBER(10,0) DEFAULT 0,
    delinquent_payments NUMBER(10,0) DEFAULT 0,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (borrower_id) REFERENCES BORROWERS(borrower_id),
    FOREIGN KEY (property_id) REFERENCES PROPERTIES(property_id)
);

-- ============================================================================
-- ANALYSTS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE ANALYSTS (
    analyst_id VARCHAR(20) PRIMARY KEY,
    analyst_name VARCHAR(200) NOT NULL,
    email VARCHAR(200) NOT NULL,
    department VARCHAR(50),
    specialization VARCHAR(100),
    hire_date DATE,
    certification_level VARCHAR(30),
    avg_review_score NUMBER(5,2),
    total_reviews_completed NUMBER(10,0) DEFAULT 0,
    analyst_status VARCHAR(30) DEFAULT 'ACTIVE',
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- VALUATIONS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE VALUATIONS (
    valuation_id VARCHAR(30) PRIMARY KEY,
    property_id VARCHAR(30) NOT NULL,
    valuation_type VARCHAR(50) NOT NULL,
    valuation_date DATE NOT NULL,
    valuation_amount NUMBER(12,2) NOT NULL,
    appraiser_id VARCHAR(20),
    valuation_method VARCHAR(50),
    confidence_level VARCHAR(20),
    market_conditions VARCHAR(50),
    comparable_count NUMBER(3,0),
    adjustment_amount NUMBER(12,2),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (property_id) REFERENCES PROPERTIES(property_id),
    FOREIGN KEY (appraiser_id) REFERENCES ANALYSTS(analyst_id)
);

-- ============================================================================
-- DUE_DILIGENCE_REVIEWS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE DUE_DILIGENCE_REVIEWS (
    review_id VARCHAR(30) PRIMARY KEY,
    loan_id VARCHAR(30) NOT NULL,
    review_type VARCHAR(50) NOT NULL,
    review_date DATE NOT NULL,
    reviewer_id VARCHAR(20) NOT NULL,
    review_status VARCHAR(30) DEFAULT 'IN_PROGRESS',
    compliance_score NUMBER(5,2),
    risk_findings NUMBER(5,0) DEFAULT 0,
    exceptions_count NUMBER(5,0) DEFAULT 0,
    critical_findings NUMBER(5,0) DEFAULT 0,
    review_completion_date DATE,
    findings_summary VARCHAR(1000),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (loan_id) REFERENCES LOANS(loan_id),
    FOREIGN KEY (reviewer_id) REFERENCES ANALYSTS(analyst_id)
);

-- ============================================================================
-- TRANSACTIONS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE TRANSACTIONS (
    transaction_id VARCHAR(30) PRIMARY KEY,
    loan_id VARCHAR(30) NOT NULL,
    transaction_date TIMESTAMP_NTZ NOT NULL,
    transaction_type VARCHAR(50) NOT NULL,
    amount NUMBER(12,2) NOT NULL,
    principal_amount NUMBER(12,2) DEFAULT 0.00,
    interest_amount NUMBER(12,2) DEFAULT 0.00,
    escrow_amount NUMBER(12,2) DEFAULT 0.00,
    payment_status VARCHAR(30) DEFAULT 'COMPLETED',
    payment_method VARCHAR(30),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (loan_id) REFERENCES LOANS(loan_id)
);

-- ============================================================================
-- SUPPORT_CASES TABLE
-- ============================================================================
CREATE OR REPLACE TABLE SUPPORT_CASES (
    case_id VARCHAR(30) PRIMARY KEY,
    borrower_id VARCHAR(20) NOT NULL,
    loan_id VARCHAR(30),
    case_type VARCHAR(50) NOT NULL,
    priority VARCHAR(20) DEFAULT 'MEDIUM',
    status VARCHAR(30) DEFAULT 'OPEN',
    assigned_analyst_id VARCHAR(20),
    created_date TIMESTAMP_NTZ NOT NULL,
    resolved_date TIMESTAMP_NTZ,
    resolution_time_hours NUMBER(10,2),
    satisfaction_rating NUMBER(3,0),
    case_description VARCHAR(1000),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (borrower_id) REFERENCES BORROWERS(borrower_id),
    FOREIGN KEY (loan_id) REFERENCES LOANS(loan_id),
    FOREIGN KEY (assigned_analyst_id) REFERENCES ANALYSTS(analyst_id)
);

-- ============================================================================
-- COMPLIANCE_DOCUMENTS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE COMPLIANCE_DOCUMENTS (
    document_id VARCHAR(30) PRIMARY KEY,
    loan_id VARCHAR(30) NOT NULL,
    document_type VARCHAR(50) NOT NULL,
    document_date DATE NOT NULL,
    compliance_status VARCHAR(30) DEFAULT 'PENDING',
    expiration_date DATE,
    reviewer_id VARCHAR(20),
    review_notes VARCHAR(1000),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (loan_id) REFERENCES LOANS(loan_id),
    FOREIGN KEY (reviewer_id) REFERENCES ANALYSTS(analyst_id)
);

-- ============================================================================
-- PORTFOLIO_SEGMENTS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE PORTFOLIO_SEGMENTS (
    segment_id VARCHAR(20) PRIMARY KEY,
    segment_name VARCHAR(200) NOT NULL,
    segment_type VARCHAR(50) NOT NULL,
    risk_category VARCHAR(20),
    target_ltv_max NUMBER(5,2),
    target_credit_score_min NUMBER(5,0),
    concentration_limit NUMBER(5,2),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- Display confirmation
-- ============================================================================
SELECT 'All tables created successfully' AS status;

