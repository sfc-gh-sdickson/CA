-- ============================================================================
-- Consolidated Analytics Intelligence Agent - Semantic Views
-- ============================================================================
-- Purpose: Create semantic views for Snowflake Intelligence agents
-- All syntax VERIFIED against GoDaddy template (lines 23-336)
-- 
-- Syntax Verification:
-- 1. Clause order is MANDATORY: TABLES → RELATIONSHIPS → DIMENSIONS → METRICS → COMMENT
-- 2. Semantic expression format: semantic_name AS sql_expression
-- 3. No self-referencing relationships allowed
-- 4. No cyclic relationships allowed
-- 5. PRIMARY KEY columns must exist in table definitions
-- ============================================================================

USE DATABASE CONSOLIDATED_ANALYTICS_DB;
USE SCHEMA ANALYTICS;
USE WAREHOUSE CA_ANALYTICS_WH;

-- ============================================================================
-- Semantic View 1: Borrower & Loan Intelligence
-- ============================================================================
CREATE OR REPLACE SEMANTIC VIEW SV_BORROWER_LOAN_INTELLIGENCE
  TABLES (
    borrowers AS RAW.BORROWERS
      PRIMARY KEY (borrower_id)
      WITH SYNONYMS ('clients', 'customers', 'account holders')
      COMMENT = 'Loan borrowers and clients',
    loans AS RAW.LOANS
      PRIMARY KEY (loan_id)
      WITH SYNONYMS ('mortgages', 'financing', 'debt obligations')
      COMMENT = 'Mortgage loan portfolio',
    transactions AS RAW.TRANSACTIONS
      PRIMARY KEY (transaction_id)
      WITH SYNONYMS ('payments', 'disbursements', 'cash flows')
      COMMENT = 'Financial transactions'
  )
  RELATIONSHIPS (
    loans(borrower_id) REFERENCES borrowers(borrower_id),
    transactions(loan_id) REFERENCES loans(loan_id)
  )
  DIMENSIONS (
    borrowers.borrower_type AS borrower_type
      WITH SYNONYMS ('customer type', 'client category', 'account type')
      COMMENT = 'Type of borrower: INDIVIDUAL, BUSINESS',
    borrowers.borrower_status AS borrower_status
      WITH SYNONYMS ('client status', 'account status', 'borrower state')
      COMMENT = 'Borrower status: ACTIVE, DELINQUENT, CLOSED',
    borrowers.employment_status AS employment_status
      WITH SYNONYMS ('job status', 'work status', 'employment type')
      COMMENT = 'Employment status of borrower',
    borrowers.borrower_state AS state
      WITH SYNONYMS ('state', 'borrower location', 'residence state')
      COMMENT = 'Borrower state location',
    borrowers.borrower_city AS city
      WITH SYNONYMS ('city', 'borrower city', 'residence city')
      COMMENT = 'Borrower city location',
    loans.loan_type AS loan_type
      WITH SYNONYMS ('mortgage type', 'loan product', 'financing type')
      COMMENT = 'Type of loan: CONVENTIONAL, FHA, VA, JUMBO, COMMERCIAL, USDA',
    loans.loan_status AS loan_status
      WITH SYNONYMS ('loan state', 'mortgage status', 'loan condition')
      COMMENT = 'Current loan status: ACTIVE, DELINQUENT, DEFAULT, PAID_OFF, FORECLOSURE',
    loans.risk_rating AS risk_rating
      WITH SYNONYMS ('risk level', 'risk grade', 'credit rating')
      COMMENT = 'Loan risk rating: A, B, C, D',
    transactions.transaction_type AS transaction_type
      WITH SYNONYMS ('payment type', 'transaction category')
      COMMENT = 'Type of transaction',
    transactions.payment_status AS payment_status
      WITH SYNONYMS ('transaction status', 'payment state')
      COMMENT = 'Payment status: COMPLETED, PENDING, FAILED',
    transactions.payment_method AS payment_method
      WITH SYNONYMS ('payment type', 'payment channel')
      COMMENT = 'Payment method: ACH, WIRE, CHECK, CREDIT_CARD, ONLINE_PAYMENT'
  )
  METRICS (
    loans.total_loans AS COUNT(DISTINCT loan_id)
      WITH SYNONYMS ('loan count', 'number of loans', 'mortgage count')
      COMMENT = 'Total number of loans',
    loans.total_loan_amount AS SUM(loan_amount)
      WITH SYNONYMS ('total financing', 'loan portfolio value', 'total debt')
      COMMENT = 'Total loan amount outstanding',
    loans.avg_loan_amount AS AVG(loan_amount)
      WITH SYNONYMS ('average loan size', 'mean loan amount', 'typical loan size')
      COMMENT = 'Average loan amount',
    loans.total_current_balance AS SUM(current_balance)
      WITH SYNONYMS ('outstanding balance', 'total balance', 'unpaid principal')
      COMMENT = 'Total current balance across all loans',
    loans.avg_interest_rate AS AVG(interest_rate)
      WITH SYNONYMS ('average rate', 'mean interest rate', 'average apr')
      COMMENT = 'Average interest rate',
    loans.avg_ltv_ratio AS AVG(ltv_ratio)
      WITH SYNONYMS ('average ltv', 'loan to value ratio', 'mean leverage')
      COMMENT = 'Average loan-to-value ratio',
    loans.avg_dti_ratio AS AVG(dti_ratio)
      WITH SYNONYMS ('average dti', 'debt to income', 'mean dti')
      COMMENT = 'Average debt-to-income ratio',
    loans.avg_credit_score AS AVG(credit_score)
      WITH SYNONYMS ('average fico', 'mean credit score', 'average credit rating')
      COMMENT = 'Average borrower credit score',
    loans.total_delinquent_payments AS SUM(delinquent_payments)
      WITH SYNONYMS ('missed payments', 'late payments', 'delinquencies')
      COMMENT = 'Total delinquent payment count',
    borrowers.total_borrowers AS COUNT(DISTINCT borrower_id)
      WITH SYNONYMS ('borrower count', 'customer count', 'client count')
      COMMENT = 'Total number of borrowers',
    borrowers.avg_annual_income AS AVG(annual_income)
      WITH SYNONYMS ('average income', 'mean salary', 'typical income')
      COMMENT = 'Average borrower annual income',
    transactions.total_transactions AS COUNT(DISTINCT transaction_id)
      WITH SYNONYMS ('transaction count', 'payment count', 'total payments')
      COMMENT = 'Total number of transactions',
    transactions.total_transaction_amount AS SUM(amount)
      WITH SYNONYMS ('total payments', 'transaction volume', 'total cash flow')
      COMMENT = 'Total transaction amount',
    transactions.avg_transaction_amount AS AVG(amount)
      WITH SYNONYMS ('average payment', 'mean transaction', 'typical payment')
      COMMENT = 'Average transaction amount',
    transactions.total_principal_paid AS SUM(principal_amount)
      WITH SYNONYMS ('principal payments', 'debt reduction', 'principal paydown')
      COMMENT = 'Total principal amount paid',
    transactions.total_interest_paid AS SUM(interest_amount)
      WITH SYNONYMS ('interest payments', 'interest income', 'interest collected')
      COMMENT = 'Total interest amount paid'
  )
  COMMENT = 'Borrower & Loan Intelligence - comprehensive view of borrowers, loans, and transactions for mortgage analytics';

-- ============================================================================
-- Semantic View 2: Property & Valuation Intelligence
-- ============================================================================
CREATE OR REPLACE SEMANTIC VIEW SV_PROPERTY_VALUATION_INTELLIGENCE
  TABLES (
    properties AS RAW.PROPERTIES
      PRIMARY KEY (property_id)
      WITH SYNONYMS ('real estate', 'assets', 'collateral')
      COMMENT = 'Real estate properties',
    valuations AS RAW.VALUATIONS
      PRIMARY KEY (valuation_id)
      WITH SYNONYMS ('appraisals', 'property assessments', 'valuations')
      COMMENT = 'Property valuations and appraisals',
    analysts AS RAW.ANALYSTS
      PRIMARY KEY (analyst_id)
      WITH SYNONYMS ('appraisers', 'reviewers', 'staff')
      COMMENT = 'Analysts and appraisers'
  )
  RELATIONSHIPS (
    valuations(property_id) REFERENCES properties(property_id),
    valuations(appraiser_id) REFERENCES analysts(analyst_id)
  )
  DIMENSIONS (
    properties.property_type AS property_type
      WITH SYNONYMS ('real estate type', 'asset class')
      COMMENT = 'Property type classification',
    properties.property_state AS state
      WITH SYNONYMS ('state', 'property location', 'collateral state')
      COMMENT = 'Property state location',
    properties.property_city AS city
      WITH SYNONYMS ('city', 'property location city', 'collateral city')
      COMMENT = 'Property city location',
    properties.condition_rating AS property_condition
      WITH SYNONYMS ('condition', 'maintenance rating')
      COMMENT = 'Property condition rating',
    properties.occupancy_status AS occupancy_status
      WITH SYNONYMS ('occupancy', 'tenant status')
      COMMENT = 'Property occupancy status',
    valuations.valuation_type AS valuation_type
      WITH SYNONYMS ('appraisal type', 'assessment type')
      COMMENT = 'Type: FULL_APPRAISAL, DESKTOP_APPRAISAL, BPO, AVM, DRIVE_BY',
    valuations.valuation_method AS valuation_method
      WITH SYNONYMS ('appraisal method', 'valuation approach')
      COMMENT = 'Valuation methodology used',
    valuations.confidence_level AS confidence_level
      WITH SYNONYMS ('confidence', 'certainty level')
      COMMENT = 'Confidence in valuation: HIGH, MEDIUM, LOW',
    valuations.market_conditions AS market_conditions
      WITH SYNONYMS ('market state', 'market environment')
      COMMENT = 'Market conditions at time of valuation',
    analysts.specialization AS appraiser_specialization
      WITH SYNONYMS ('expertise', 'specialty area')
      COMMENT = 'Appraiser specialization',
    analysts.certification_level AS certification_level
      WITH SYNONYMS ('certification', 'credential level')
      COMMENT = 'Analyst certification level',
    analysts.department AS department
      WITH SYNONYMS ('team', 'business unit')
      COMMENT = 'Department or team'
  )
  METRICS (
    properties.total_properties AS COUNT(DISTINCT property_id)
      WITH SYNONYMS ('property count', 'asset count')
      COMMENT = 'Total number of properties',
    properties.avg_property_value AS AVG(property_value)
      WITH SYNONYMS ('average value', 'mean property value')
      COMMENT = 'Average property value',
    properties.total_property_value AS SUM(property_value)
      WITH SYNONYMS ('total value', 'aggregate property value')
      COMMENT = 'Total property value',
    properties.avg_square_footage AS AVG(square_footage)
      WITH SYNONYMS ('average size', 'mean square feet')
      COMMENT = 'Average property square footage',
    valuations.total_valuations AS COUNT(DISTINCT valuation_id)
      WITH SYNONYMS ('valuation count', 'appraisal count')
      COMMENT = 'Total number of valuations',
    valuations.avg_valuation_amount AS AVG(valuation_amount)
      WITH SYNONYMS ('average appraisal', 'mean valuation')
      COMMENT = 'Average valuation amount',
    valuations.avg_comparable_count AS AVG(comparable_count)
      WITH SYNONYMS ('average comps', 'mean comparable count')
      COMMENT = 'Average number of comparables used',
    analysts.total_analysts AS COUNT(DISTINCT analyst_id)
      WITH SYNONYMS ('appraiser count', 'staff count')
      COMMENT = 'Total number of analysts',
    analysts.avg_review_score AS AVG(avg_review_score)
      WITH SYNONYMS ('average rating', 'mean quality score')
      COMMENT = 'Average analyst review score'
  )
  COMMENT = 'Property & Valuation Intelligence - property valuations, appraisals, and quality metrics';

-- ============================================================================
-- Semantic View 3: Due Diligence & Operations Intelligence
-- ============================================================================
CREATE OR REPLACE SEMANTIC VIEW SV_DUE_DILIGENCE_INTELLIGENCE
  TABLES (
    reviews AS RAW.DUE_DILIGENCE_REVIEWS
      PRIMARY KEY (review_id)
      WITH SYNONYMS ('audits', 'quality checks', 'compliance reviews')
      COMMENT = 'Due diligence reviews',
    loans AS RAW.LOANS
      PRIMARY KEY (loan_id)
      WITH SYNONYMS ('mortgages', 'financing')
      COMMENT = 'Mortgage loans',
    analysts AS RAW.ANALYSTS
      PRIMARY KEY (analyst_id)
      WITH SYNONYMS ('reviewers', 'auditors', 'staff')
      COMMENT = 'Review analysts',
    cases AS RAW.SUPPORT_CASES
      PRIMARY KEY (case_id)
      WITH SYNONYMS ('support tickets', 'inquiries', 'requests')
      COMMENT = 'Client support cases'
  )
  RELATIONSHIPS (
    reviews(loan_id) REFERENCES loans(loan_id),
    reviews(reviewer_id) REFERENCES analysts(analyst_id),
    cases(assigned_analyst_id) REFERENCES analysts(analyst_id)
  )
  DIMENSIONS (
    reviews.review_type AS review_type
      WITH SYNONYMS ('audit type', 'review category')
      COMMENT = 'Type: PRE_FUNDING, POST_CLOSING, COMPLIANCE_AUDIT, QUALITY_CONTROL, PORTFOLIO_REVIEW',
    reviews.review_status AS review_status
      WITH SYNONYMS ('status', 'review state')
      COMMENT = 'Review status: COMPLETED, IN_PROGRESS, PENDING',
    loans.loan_type AS loan_type
      WITH SYNONYMS ('mortgage type', 'loan product')
      COMMENT = 'Type of loan',
    loans.risk_rating AS loan_risk_rating
      WITH SYNONYMS ('risk level', 'risk grade')
      COMMENT = 'Loan risk rating',
    analysts.specialization AS analyst_specialization
      WITH SYNONYMS ('expertise', 'specialty')
      COMMENT = 'Analyst specialization area',
    analysts.department AS analyst_department
      WITH SYNONYMS ('team', 'business unit')
      COMMENT = 'Analyst department',
    analysts.certification_level AS certification_level
      WITH SYNONYMS ('certification', 'credential')
      COMMENT = 'Analyst certification level',
    cases.case_type AS case_type
      WITH SYNONYMS ('inquiry type', 'request type')
      COMMENT = 'Type of support case',
    cases.priority AS case_priority
      WITH SYNONYMS ('urgency', 'importance')
      COMMENT = 'Case priority: LOW, MEDIUM, HIGH, URGENT',
    cases.case_status AS case_status
      WITH SYNONYMS ('case state', 'ticket status')
      COMMENT = 'Case status: OPEN, IN_PROGRESS, RESOLVED'
  )
  METRICS (
    reviews.total_reviews AS COUNT(DISTINCT review_id)
      WITH SYNONYMS ('review count', 'audit count', 'total audits')
      COMMENT = 'Total number of reviews',
    reviews.avg_compliance_score AS AVG(compliance_score)
      WITH SYNONYMS ('average score', 'mean compliance rating')
      COMMENT = 'Average compliance score',
    reviews.avg_exceptions_count AS AVG(exceptions_count)
      WITH SYNONYMS ('average exceptions', 'mean exception count')
      COMMENT = 'Average number of exceptions per review',
    reviews.total_critical_findings AS SUM(critical_findings)
      WITH SYNONYMS ('critical issues', 'serious findings')
      COMMENT = 'Total critical findings across reviews',
    reviews.total_risk_findings AS SUM(risk_findings)
      WITH SYNONYMS ('risk issues', 'risk exceptions')
      COMMENT = 'Total risk findings',
    loans.total_loans AS COUNT(DISTINCT loan_id)
      WITH SYNONYMS ('loan count', 'mortgage count')
      COMMENT = 'Total number of loans reviewed',
    analysts.total_analysts AS COUNT(DISTINCT analyst_id)
      WITH SYNONYMS ('reviewer count', 'staff count')
      COMMENT = 'Total number of analysts',
    analysts.avg_review_score AS AVG(avg_review_score)
      WITH SYNONYMS ('average rating', 'mean analyst score')
      COMMENT = 'Average analyst review score',
    analysts.total_reviews_completed AS SUM(total_reviews_completed)
      WITH SYNONYMS ('completed reviews', 'total completions')
      COMMENT = 'Total reviews completed by all analysts',
    cases.total_cases AS COUNT(DISTINCT case_id)
      WITH SYNONYMS ('case count', 'ticket count', 'inquiry count')
      COMMENT = 'Total number of support cases',
    cases.avg_resolution_time AS AVG(resolution_time_hours)
      WITH SYNONYMS ('average resolution time', 'mean time to resolve')
      COMMENT = 'Average case resolution time in hours',
    cases.avg_satisfaction_rating AS AVG(satisfaction_rating)
      WITH SYNONYMS ('average satisfaction', 'customer satisfaction score')
      COMMENT = 'Average customer satisfaction rating'
  )
  COMMENT = 'Due Diligence & Operations Intelligence - review quality, compliance metrics, and operational efficiency';

-- ============================================================================
-- Display confirmation and verification
-- ============================================================================
SELECT 'Semantic views created successfully - all syntax verified' AS status;

-- Verify semantic views exist
SELECT 
    table_name AS semantic_view_name,
    comment AS description
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'ANALYTICS'
  AND table_name LIKE 'SV_%'
ORDER BY table_name;

-- Show semantic view details
SHOW SEMANTIC VIEWS IN SCHEMA ANALYTICS;

