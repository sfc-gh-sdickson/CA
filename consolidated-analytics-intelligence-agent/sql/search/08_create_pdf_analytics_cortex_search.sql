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
CREATE OR REPLACE CORTEX SEARCH SERVICE PDF_TEXT_SEARCH
  ON extracted_text
  ATTRIBUTES file_name, page_number, upload_timestamp
  WAREHOUSE = CA_ANALYTICS_WH
  TARGET_LAG = '1 hour'
  COMMENT = 'Cortex Search service for PDF text extraction - enables semantic search across property document text, contracts, and descriptions'
AS
  SELECT
    id,
    file_name,
    page_number,
    extracted_text,
    upload_timestamp,
    metadata
  FROM PDF_PROCESSING.PDF_TEXT_DATA
  WHERE extracted_text IS NOT NULL;

-- ============================================================================
-- Step 2: Create Cortex Search Service for Image Analysis Results
-- ============================================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE IMAGE_ANALYSIS_SEARCH
  ON full_analysis_text
  ATTRIBUTES file_name, image_name, model_name, for_sale_sign_detected, solar_panel_detected, human_presence_detected, potential_damage_detected, analysis_timestamp
  WAREHOUSE = CA_ANALYTICS_WH
  TARGET_LAG = '1 hour'
  COMMENT = 'Cortex Search service for image analysis - enables semantic search across property image analysis results, conditions, and AI-detected features'
AS
  SELECT
    id,
    file_name,
    image_name,
    model_name,
    page_number,
    for_sale_sign_detected,
    for_sale_sign_confidence,
    solar_panel_detected,
    solar_panel_confidence,
    human_presence_detected,
    human_presence_confidence,
    potential_damage_detected,
    potential_damage_confidence,
    damage_description,
    full_analysis_text,
    analysis_timestamp,
    metadata
  FROM PDF_PROCESSING.IMAGE_ANALYSIS_RESULTS
  WHERE full_analysis_text IS NOT NULL;

-- ============================================================================
-- Step 3: Create Cortex Search Service for Damage Descriptions
-- ============================================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE PROPERTY_DAMAGE_SEARCH
  ON damage_description
  ATTRIBUTES file_name, image_name, potential_damage_detected, potential_damage_confidence, analysis_timestamp
  WAREHOUSE = CA_ANALYTICS_WH
  TARGET_LAG = '2 hours'
  COMMENT = 'Cortex Search service for property damage - enables semantic search across damage descriptions, structural issues, and property condition concerns'
AS
  SELECT
    id,
    file_name,
    image_name,
    model_name,
    page_number,
    potential_damage_detected,
    potential_damage_confidence,
    damage_description,
    full_analysis_text,
    analysis_timestamp,
    metadata
  FROM PDF_PROCESSING.IMAGE_ANALYSIS_RESULTS
  WHERE damage_description IS NOT NULL
    AND potential_damage_detected = TRUE;

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
WHERE extracted_text IS NOT NULL
UNION ALL
SELECT 'IMAGE_ANALYSIS_RESULTS', COUNT(*) 
FROM IMAGE_ANALYSIS_RESULTS
WHERE full_analysis_text IS NOT NULL
UNION ALL
SELECT 'PROPERTY_DAMAGE_RECORDS', COUNT(*) 
FROM IMAGE_ANALYSIS_RESULTS
WHERE damage_description IS NOT NULL AND potential_damage_detected = TRUE
ORDER BY table_name;

-- ============================================================================
-- END OF PDF ANALYTICS CORTEX SEARCH SETUP
-- ============================================================================
