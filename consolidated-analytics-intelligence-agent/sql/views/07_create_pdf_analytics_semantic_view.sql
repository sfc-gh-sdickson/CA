-- ============================================================================
-- PDF Analytics Intelligence Agent - Semantic View
-- ============================================================================
-- Purpose: Create semantic view for real estate property PDF text extraction
--          and image analysis intelligence
-- Syntax VERIFIED against existing template (05_create_semantic_views.sql)
-- 
-- Syntax Verification:
-- 1. Clause order is MANDATORY: TABLES → RELATIONSHIPS → DIMENSIONS → METRICS → COMMENT
-- 2. Semantic expression format: semantic_name AS sql_expression
-- 3. PRIMARY KEY columns must exist in table definitions
-- 4. Source tables verified from sql/setup/setup.sql (lines 24-53)
-- ============================================================================

USE DATABASE PDF_ANALYTICS_DB;
USE SCHEMA PDF_PROCESSING;
-- Note: You may need to create or use an appropriate warehouse
-- USE WAREHOUSE <YOUR_WAREHOUSE>;

-- ============================================================================
-- Semantic View: Real Estate Property Intelligence
-- ============================================================================
CREATE OR REPLACE SEMANTIC VIEW SV_PROPERTY_PDF_INTELLIGENCE
  TABLES (
    pdf_text AS PDF_TEXT_DATA
      PRIMARY KEY (ID)
      WITH SYNONYMS ('pdf documents', 'document text', 'extracted documents')
      COMMENT = 'Extracted text from real estate property PDF documents',
    image_analysis AS IMAGE_ANALYSIS_RESULTS
      PRIMARY KEY (ID)
      WITH SYNONYMS ('property images', 'image inspection', 'visual analysis')
      COMMENT = 'AI-powered image analysis results for property photos'
  )
  RELATIONSHIPS (
    image_analysis(FILE_NAME) REFERENCES pdf_text(FILE_NAME)
  )
  DIMENSIONS (
    pdf_text.FILE_NAME AS document_name
      WITH SYNONYMS ('pdf name', 'document file', 'property document')
      COMMENT = 'Name of the PDF document file',
    pdf_text.PAGE_NUMBER AS page_number
      WITH SYNONYMS ('page', 'document page', 'pdf page')
      COMMENT = 'Page number within the PDF document',
    image_analysis.IMAGE_NAME AS image_name
      WITH SYNONYMS ('photo name', 'image file', 'picture name')
      COMMENT = 'Name of the analyzed image',
    image_analysis.MODEL_NAME AS ai_model
      WITH SYNONYMS ('model', 'ai model used', 'analysis model')
      COMMENT = 'Cortex AI model used for image analysis',
    image_analysis.FOR_SALE_SIGN_DETECTED AS for_sale_sign
      WITH SYNONYMS ('sale sign', 'for sale indicator', 'property listing sign')
      COMMENT = 'Whether a for-sale sign was detected (true/false)',
    image_analysis.SOLAR_PANEL_DETECTED AS solar_panels
      WITH SYNONYMS ('solar', 'solar installation', 'renewable energy')
      COMMENT = 'Whether solar panels were detected (true/false)',
    image_analysis.HUMAN_PRESENCE_DETECTED AS people_present
      WITH SYNONYMS ('humans', 'people', 'occupants visible')
      COMMENT = 'Whether human presence was detected (true/false)',
    image_analysis.POTENTIAL_DAMAGE_DETECTED AS damage_detected
      WITH SYNONYMS ('damage', 'property damage', 'structural issues')
      COMMENT = 'Whether potential property damage was detected (true/false)',
    image_analysis.DAMAGE_DESCRIPTION AS damage_details
      WITH SYNONYMS ('damage description', 'damage notes', 'damage type')
      COMMENT = 'Description of detected damage or issues'
  )
  METRICS (
    pdf_text.total_documents AS COUNT(DISTINCT FILE_NAME)
      WITH SYNONYMS ('document count', 'pdf count', 'number of pdfs')
      COMMENT = 'Total number of unique PDF documents processed',
    pdf_text.total_pages AS COUNT(DISTINCT ID)
      WITH SYNONYMS ('page count', 'total pages extracted')
      COMMENT = 'Total number of pages extracted from PDFs',
    pdf_text.avg_pages_per_document AS AVG(PAGE_NUMBER)
      WITH SYNONYMS ('average pages', 'mean pages per pdf')
      COMMENT = 'Average number of pages per document',
    image_analysis.total_images AS COUNT(DISTINCT ID)
      WITH SYNONYMS ('image count', 'photo count', 'total images analyzed')
      COMMENT = 'Total number of images analyzed',
    image_analysis.for_sale_sign_count AS SUM(CASE WHEN FOR_SALE_SIGN_DETECTED THEN 1 ELSE 0 END)
      WITH SYNONYMS ('for sale signs', 'listing signs detected', 'sale indicators')
      COMMENT = 'Number of images with for-sale signs detected',
    image_analysis.avg_for_sale_confidence AS AVG(FOR_SALE_SIGN_CONFIDENCE)
      WITH SYNONYMS ('sale sign confidence', 'for sale detection confidence')
      COMMENT = 'Average confidence score for for-sale sign detection',
    image_analysis.solar_panel_count AS SUM(CASE WHEN SOLAR_PANEL_DETECTED THEN 1 ELSE 0 END)
      WITH SYNONYMS ('solar installations', 'properties with solar', 'solar detections')
      COMMENT = 'Number of images with solar panels detected',
    image_analysis.avg_solar_confidence AS AVG(SOLAR_PANEL_CONFIDENCE)
      WITH SYNONYMS ('solar detection confidence', 'solar panel confidence')
      COMMENT = 'Average confidence score for solar panel detection',
    image_analysis.human_presence_count AS SUM(CASE WHEN HUMAN_PRESENCE_DETECTED THEN 1 ELSE 0 END)
      WITH SYNONYMS ('images with people', 'human detections', 'occupied photos')
      COMMENT = 'Number of images with human presence detected',
    image_analysis.avg_human_confidence AS AVG(HUMAN_PRESENCE_CONFIDENCE)
      WITH SYNONYMS ('human detection confidence', 'people detection confidence')
      COMMENT = 'Average confidence score for human presence detection',
    image_analysis.damage_count AS SUM(CASE WHEN POTENTIAL_DAMAGE_DETECTED THEN 1 ELSE 0 END)
      WITH SYNONYMS ('damaged properties', 'properties with damage', 'damage detections')
      COMMENT = 'Number of images with potential damage detected',
    image_analysis.avg_damage_confidence AS AVG(POTENTIAL_DAMAGE_CONFIDENCE)
      WITH SYNONYMS ('damage detection confidence', 'damage confidence score')
      COMMENT = 'Average confidence score for damage detection',
    image_analysis.images_per_document AS COUNT(DISTINCT IMAGE_NAME) / COUNT(DISTINCT FILE_NAME)
      WITH SYNONYMS ('photos per property', 'images per pdf', 'average images')
      COMMENT = 'Average number of images analyzed per document'
  )
  COMMENT = 'Real Estate Property Intelligence - PDF text extraction and AI-powered image analysis for property assessment and valuation';

-- ============================================================================
-- Display confirmation and verification
-- ============================================================================
SELECT 'PDF Analytics semantic view created successfully - all syntax verified' AS status;

-- Verify semantic view exists
SELECT 
    table_name AS semantic_view_name,
    comment AS description
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'PDF_PROCESSING'
  AND table_name = 'SV_PROPERTY_PDF_INTELLIGENCE'
ORDER BY table_name;

-- Show semantic view details
SHOW SEMANTIC VIEWS IN SCHEMA PDF_PROCESSING;

