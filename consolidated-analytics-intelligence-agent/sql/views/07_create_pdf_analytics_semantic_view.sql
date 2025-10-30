-- ============================================================================
-- PDF Analytics Intelligence Agent - Semantic View
-- ============================================================================
-- Purpose: Create semantic view for real estate property image analysis
-- Syntax VERIFIED against GoDaddy template (05_create_semantic_views.sql lines 23-336)
-- ============================================================================

USE DATABASE PDF_ANALYTICS_DB;
USE SCHEMA PDF_PROCESSING;
-- Note: You may need to create or use an appropriate warehouse
-- USE WAREHOUSE <YOUR_WAREHOUSE>;

-- ============================================================================
-- Semantic View: Property Image Analysis Intelligence
-- ============================================================================
CREATE OR REPLACE SEMANTIC VIEW SV_PROPERTY_IMAGE_INTELLIGENCE
  TABLES (
    image_analysis AS IMAGE_ANALYSIS_RESULTS
      PRIMARY KEY (id)
      WITH SYNONYMS ('property images', 'image inspection', 'visual analysis', 'ai analysis')
      COMMENT = 'AI-powered image analysis results for property photos'
  )
  DIMENSIONS (
    image_analysis.file_name AS file_name
      WITH SYNONYMS ('document name', 'pdf name', 'property document')
      COMMENT = 'Name of the PDF document file',
    image_analysis.image_name AS image_name
      WITH SYNONYMS ('photo name', 'image file', 'picture name')
      COMMENT = 'Name of the analyzed image',
    image_analysis.model_name AS model_name
      WITH SYNONYMS ('model', 'ai model used', 'analysis model', 'ai model')
      COMMENT = 'Cortex AI model used for image analysis',
    image_analysis.page_number AS page_number
      WITH SYNONYMS ('page', 'document page', 'pdf page')
      COMMENT = 'Page number within the PDF document',
    image_analysis.for_sale_sign_detected AS for_sale_sign_detected
      WITH SYNONYMS ('sale sign', 'for sale indicator', 'property listing sign', 'for sale sign')
      COMMENT = 'Whether a for-sale sign was detected (true/false)',
    image_analysis.solar_panel_detected AS solar_panel_detected
      WITH SYNONYMS ('solar', 'solar installation', 'renewable energy', 'solar panels')
      COMMENT = 'Whether solar panels were detected (true/false)',
    image_analysis.human_presence_detected AS human_presence_detected
      WITH SYNONYMS ('humans', 'people', 'occupants visible', 'people present')
      COMMENT = 'Whether human presence was detected (true/false)',
    image_analysis.potential_damage_detected AS potential_damage_detected
      WITH SYNONYMS ('damage', 'property damage', 'structural issues', 'damage detected')
      COMMENT = 'Whether potential property damage was detected (true/false)',
    image_analysis.damage_description AS damage_description
      WITH SYNONYMS ('damage details', 'damage notes', 'damage type', 'damage text')
      COMMENT = 'Description of detected damage or issues'
  )
  METRICS (
    image_analysis.total_images AS COUNT(DISTINCT id)
      WITH SYNONYMS ('image count', 'photo count', 'total images analyzed')
      COMMENT = 'Total number of images analyzed',
    image_analysis.total_documents AS COUNT(DISTINCT file_name)
      WITH SYNONYMS ('document count', 'pdf count', 'number of pdfs')
      COMMENT = 'Total number of unique PDF documents',
    image_analysis.for_sale_sign_count AS SUM(CASE WHEN for_sale_sign_detected THEN 1 ELSE 0 END)
      WITH SYNONYMS ('for sale signs', 'listing signs detected', 'sale indicators')
      COMMENT = 'Number of images with for-sale signs detected',
    image_analysis.avg_for_sale_confidence AS AVG(for_sale_sign_confidence)
      WITH SYNONYMS ('sale sign confidence', 'for sale detection confidence')
      COMMENT = 'Average confidence score for for-sale sign detection',
    image_analysis.solar_panel_count AS SUM(CASE WHEN solar_panel_detected THEN 1 ELSE 0 END)
      WITH SYNONYMS ('solar installations', 'properties with solar', 'solar detections')
      COMMENT = 'Number of images with solar panels detected',
    image_analysis.avg_solar_confidence AS AVG(solar_panel_confidence)
      WITH SYNONYMS ('solar detection confidence', 'solar panel confidence')
      COMMENT = 'Average confidence score for solar panel detection',
    image_analysis.human_presence_count AS SUM(CASE WHEN human_presence_detected THEN 1 ELSE 0 END)
      WITH SYNONYMS ('images with people', 'human detections', 'occupied photos')
      COMMENT = 'Number of images with human presence detected',
    image_analysis.avg_human_confidence AS AVG(human_presence_confidence)
      WITH SYNONYMS ('human detection confidence', 'people detection confidence')
      COMMENT = 'Average confidence score for human presence detection',
    image_analysis.damage_count AS SUM(CASE WHEN potential_damage_detected THEN 1 ELSE 0 END)
      WITH SYNONYMS ('damaged properties', 'properties with damage', 'damage detections')
      COMMENT = 'Number of images with potential damage detected',
    image_analysis.avg_damage_confidence AS AVG(potential_damage_confidence)
      WITH SYNONYMS ('damage detection confidence', 'damage confidence score')
      COMMENT = 'Average confidence score for damage detection'
  )
  COMMENT = 'Property Image Intelligence - AI-powered image analysis for real estate property assessment';

-- ============================================================================
-- Display confirmation and verification
-- ============================================================================
SELECT 'PDF Analytics semantic view created successfully - syntax verified' AS status;

-- Verify semantic view exists
SELECT 
    table_name AS semantic_view_name,
    comment AS description
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'PDF_PROCESSING'
  AND table_name = 'SV_PROPERTY_IMAGE_INTELLIGENCE'
ORDER BY table_name;

-- Show semantic view details
SHOW SEMANTIC VIEWS IN SCHEMA PDF_PROCESSING;
