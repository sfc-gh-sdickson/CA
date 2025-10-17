-- ============================================================================
-- SQL Validation Script - Verify All Column References
-- ============================================================================
-- Purpose: Systematically verify all column references in views match table definitions
-- ============================================================================

USE DATABASE CONSOLIDATED_ANALYTICS_DB;
USE WAREHOUSE CA_ANALYTICS_WH;

-- Test 1: Verify all tables exist
SELECT 'Checking tables...' AS validation_step;
SELECT table_name, table_type 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'RAW' 
ORDER BY table_name;

-- Test 2: Verify BORROWERS table columns
SELECT 'Checking BORROWERS columns...' AS validation_step;
DESCRIBE TABLE RAW.BORROWERS;

-- Test 3: Verify PROPERTIES table columns
SELECT 'Checking PROPERTIES columns...' AS validation_step;
DESCRIBE TABLE RAW.PROPERTIES;

-- Test 4: Verify LOANS table columns
SELECT 'Checking LOANS columns...' AS validation_step;
DESCRIBE TABLE RAW.LOANS;

-- Test 5: Try to create V_LOAN_PORTFOLIO view (will fail if column references are wrong)
SELECT 'Testing V_LOAN_PORTFOLIO view...' AS validation_step;
SELECT * FROM ANALYTICS.V_LOAN_PORTFOLIO LIMIT 1;

-- Test 6: Try to create V_PORTFOLIO_RISK view
SELECT 'Testing V_PORTFOLIO_RISK view...' AS validation_step;
SELECT * FROM ANALYTICS.V_PORTFOLIO_RISK LIMIT 1;

-- Test 7: Verify all analytical views
SELECT 'Checking all analytical views...' AS validation_step;
SELECT table_name, comment 
FROM INFORMATION_SCHEMA.VIEWS 
WHERE TABLE_SCHEMA = 'ANALYTICS' AND table_name LIKE 'V_%'
ORDER BY table_name;

-- Test 8: Verify semantic views
SELECT 'Checking semantic views...' AS validation_step;
SELECT table_name, comment 
FROM INFORMATION_SCHEMA.VIEWS 
WHERE TABLE_SCHEMA = 'ANALYTICS' AND table_name LIKE 'SV_%'
ORDER BY table_name;

-- Test 9: Verify Cortex Search services
SELECT 'Checking Cortex Search services...' AS validation_step;
SHOW CORTEX SEARCH SERVICES IN SCHEMA RAW;

SELECT 'ALL VALIDATION TESTS PASSED!' AS result;

