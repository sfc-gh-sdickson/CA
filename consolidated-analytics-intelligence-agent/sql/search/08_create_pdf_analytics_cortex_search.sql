-- ============================================================================
-- PDF Analytics Intelligence Agent - Cortex Search Services
-- ============================================================================
-- Purpose: Create Cortex Search services for semantic search over
--          PDF text extraction and image analysis data
-- Syntax VERIFIED against existing template (06_create_cortex_search.sql)
-- Source tables verified from sql/setup/setup.sql (lines 24-53)
-- ============================================================================

USE DATABASE PDF_ANALYTICS_DB;
USE SCHEMA PDF_PROCESSING;
USE WAREHOUSE CA_ANALYTICS_WH;

-- ============================================================================
-- Step 1: Create Cortex Search Service for PDF Text Extraction
-- ============================================================================
-- Enables semantic search across all extracted text from property PDFs
-- Useful for finding specific information, property details, legal text, etc.

CREATE OR REPLACE CORTEX SEARCH SERVICE PDF_TEXT_SEARCH
  ON EXTRACTED_TEXT
  ATTRIBUTES FILE_NAME, PAGE_NUMBER, UPLOAD_TIMESTAMP
  WAREHOUSE = CA_ANALYTICS_WH
  TARGET_LAG = '1 hour'
  COMMENT = 'Cortex Search service for PDF text extraction - enables semantic search across property document text, contracts, and descriptions'
AS
  SELECT
    ID,
    FILE_NAME,
    PAGE_NUMBER,
    EXTRACTED_TEXT,
    UPLOAD_TIMESTAMP,
    METADATA
  FROM PDF_PROCESSING.PDF_TEXT_DATA
  WHERE EXTRACTED_TEXT IS NOT NULL;

-- ============================================================================
-- Step 2: Create Cortex Search Service for Image Analysis Results
-- ============================================================================
-- Enables semantic search across image analysis findings
-- Useful for finding specific property conditions, damage descriptions, etc.

CREATE OR REPLACE CORTEX SEARCH SERVICE IMAGE_ANALYSIS_SEARCH
  ON FULL_ANALYSIS_TEXT
  ATTRIBUTES FILE_NAME, IMAGE_NAME, MODEL_NAME, FOR_SALE_SIGN_DETECTED, SOLAR_PANEL_DETECTED, HUMAN_PRESENCE_DETECTED, POTENTIAL_DAMAGE_DETECTED, ANALYSIS_TIMESTAMP
  WAREHOUSE = CA_ANALYTICS_WH
  TARGET_LAG = '1 hour'
  COMMENT = 'Cortex Search service for image analysis - enables semantic search across property image analysis results, conditions, and AI-detected features'
AS
  SELECT
    ID,
    FILE_NAME,
    IMAGE_NAME,
    MODEL_NAME,
    PAGE_NUMBER,
    FOR_SALE_SIGN_DETECTED,
    FOR_SALE_SIGN_CONFIDENCE,
    SOLAR_PANEL_DETECTED,
    SOLAR_PANEL_CONFIDENCE,
    HUMAN_PRESENCE_DETECTED,
    HUMAN_PRESENCE_CONFIDENCE,
    POTENTIAL_DAMAGE_DETECTED,
    POTENTIAL_DAMAGE_CONFIDENCE,
    DAMAGE_DESCRIPTION,
    FULL_ANALYSIS_TEXT,
    ANALYSIS_TIMESTAMP,
    METADATA
  FROM PDF_PROCESSING.IMAGE_ANALYSIS_RESULTS
  WHERE FULL_ANALYSIS_TEXT IS NOT NULL;

-- ============================================================================
-- Step 3: Create Cortex Search Service for Damage Descriptions
-- ============================================================================
-- Specialized search for property damage findings
-- Useful for insurance, inspection, and risk assessment queries

CREATE OR REPLACE CORTEX SEARCH SERVICE PROPERTY_DAMAGE_SEARCH
  ON DAMAGE_DESCRIPTION
  ATTRIBUTES FILE_NAME, IMAGE_NAME, POTENTIAL_DAMAGE_DETECTED, POTENTIAL_DAMAGE_CONFIDENCE, ANALYSIS_TIMESTAMP
  WAREHOUSE = CA_ANALYTICS_WH
  TARGET_LAG = '2 hours'
  COMMENT = 'Cortex Search service for property damage - enables semantic search across damage descriptions, structural issues, and property condition concerns'
AS
  SELECT
    ID,
    FILE_NAME,
    IMAGE_NAME,
    MODEL_NAME,
    PAGE_NUMBER,
    POTENTIAL_DAMAGE_DETECTED,
    POTENTIAL_DAMAGE_CONFIDENCE,
    DAMAGE_DESCRIPTION,
    FULL_ANALYSIS_TEXT,
    ANALYSIS_TIMESTAMP,
    METADATA
  FROM PDF_PROCESSING.IMAGE_ANALYSIS_RESULTS
  WHERE DAMAGE_DESCRIPTION IS NOT NULL
    AND POTENTIAL_DAMAGE_DETECTED = TRUE;

-- ============================================================================
-- Step 4: Verify Cortex Search Services Created
-- ============================================================================
SHOW CORTEX SEARCH SERVICES IN SCHEMA PDF_PROCESSING;

-- ============================================================================
-- Display success message and counts
-- ============================================================================
SELECT 'PDF Analytics Cortex Search services created successfully' AS status,
       COUNT(*) AS service_count
FROM (
  SELECT 'PDF_TEXT_SEARCH' AS service_name
  UNION ALL
  SELECT 'IMAGE_ANALYSIS_SEARCH'
  UNION ALL
  SELECT 'PROPERTY_DAMAGE_SEARCH'
);

-- ============================================================================
-- Display data counts for verification
-- ============================================================================
SELECT 'PDF_TEXT_DATA' AS table_name, COUNT(*) AS row_count 
FROM PDF_TEXT_DATA
WHERE EXTRACTED_TEXT IS NOT NULL
UNION ALL
SELECT 'IMAGE_ANALYSIS_RESULTS', COUNT(*) 
FROM IMAGE_ANALYSIS_RESULTS
WHERE FULL_ANALYSIS_TEXT IS NOT NULL
UNION ALL
SELECT 'PROPERTY_DAMAGE_RECORDS', COUNT(*) 
FROM IMAGE_ANALYSIS_RESULTS
WHERE DAMAGE_DESCRIPTION IS NOT NULL AND POTENTIAL_DAMAGE_DETECTED = TRUE
ORDER BY table_name;

-- ============================================================================
-- Example Search Queries (for testing after data population)
-- ============================================================================
-- Uncomment and run these after you have data in your tables:

-- Example 1: Search for properties with solar panels
-- SELECT * FROM TABLE(
--   PDF_ANALYTICS_DB.PDF_PROCESSING.IMAGE_ANALYSIS_SEARCH(
--     'solar panels on roof'
--   )
-- ) LIMIT 10;

-- Example 2: Search for specific property features in text
-- SELECT * FROM TABLE(
--   PDF_ANALYTICS_DB.PDF_PROCESSING.PDF_TEXT_SEARCH(
--     'swimming pool and garage'
--   )
-- ) LIMIT 10;

-- Example 3: Search for damage descriptions
-- SELECT * FROM TABLE(
--   PDF_ANALYTICS_DB.PDF_PROCESSING.PROPERTY_DAMAGE_SEARCH(
--     'roof damage or water stains'
--   )
-- ) LIMIT 10;

-- ============================================================================
-- END OF PDF ANALYTICS CORTEX SEARCH SETUP
-- ============================================================================

