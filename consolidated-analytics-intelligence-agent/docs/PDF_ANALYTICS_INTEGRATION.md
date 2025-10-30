<img src="../Snowflake_Logo.svg" width="200">

# PDF Analytics Integration Guide
## Adding Real Estate Property Intelligence to Snowflake Intelligence Agent

This guide explains how to integrate the PDF Analytics semantic view and Cortex Search services into your existing Snowflake Intelligence Agent for Consolidated Analytics.

---

## Overview

The PDF Analytics module adds **real estate property intelligence** capabilities to your agent through:
1. **Semantic View**: Structured queries over PDF text extraction and image analysis
2. **Cortex Search Services**: Semantic search over property documents, image analysis, and damage reports

---

## Prerequisites

1. **Completed Base Setup**:
   - Existing Snowflake Intelligence Agent (from AGENT_SETUP.md)
   - Working warehouse with Cortex enabled

2. **PDF Analytics Database Setup**:
   - Execute: `sql/setup/setup.sql` (creates PDF_ANALYTICS_DB, tables, and stages)
   - Verify database exists: `PDF_ANALYTICS_DB.PDF_PROCESSING`

3. **Warehouse Configuration**:
   - Edit new SQL files to replace `<YOUR_WAREHOUSE>` with your actual warehouse name
   - Recommended: Use same warehouse as main agent (e.g., `CA_ANALYTICS_WH`)

---

## Step 1: Create Semantic View

### 1.1 Execute Semantic View Script

Before running, **edit the file** to specify your warehouse:

```sql
-- In sql/views/07_create_pdf_analytics_semantic_view.sql
-- Replace line 18 with your warehouse name:
USE WAREHOUSE CA_ANALYTICS_WH;  -- or your warehouse name
```

Then execute:
```bash
# Execute: sql/views/07_create_pdf_analytics_semantic_view.sql
# Creates: SV_PROPERTY_PDF_INTELLIGENCE
# Execution time: < 5 seconds
```

**What It Creates:**
- **Semantic View**: `PDF_ANALYTICS_DB.PDF_PROCESSING.SV_PROPERTY_PDF_INTELLIGENCE`
- **Tables**: 
  - `pdf_text` (PDF_TEXT_DATA) - document text extraction
  - `image_analysis` (IMAGE_ANALYSIS_RESULTS) - AI image analysis
- **Dimensions**: document names, page numbers, AI model used, detection flags
- **Metrics**: document counts, detection rates, confidence scores

### 1.2 Verify Creation

```sql
-- Check semantic view exists
SHOW SEMANTIC VIEWS IN SCHEMA PDF_ANALYTICS_DB.PDF_PROCESSING;

-- Query the view
SELECT * FROM PDF_ANALYTICS_DB.PDF_PROCESSING.SV_PROPERTY_PDF_INTELLIGENCE LIMIT 10;
```

---

## Step 2: Create Cortex Search Services

### 2.1 Execute Cortex Search Script

Before running, **edit the file** to specify your warehouse in **3 places**:

```sql
-- In sql/search/08_create_pdf_analytics_cortex_search.sql
-- Replace <YOUR_WAREHOUSE> with your warehouse name on lines:
-- - Line 24 (PDF_TEXT_SEARCH)
-- - Line 48 (IMAGE_ANALYSIS_SEARCH)
-- - Line 77 (PROPERTY_DAMAGE_SEARCH)

-- Example:
WAREHOUSE = CA_ANALYTICS_WH
```

Then execute:
```bash
# Execute: sql/search/08_create_pdf_analytics_cortex_search.sql
# Creates: 3 Cortex Search services
# Execution time: 1-3 minutes (depending on data volume)
```

**What It Creates:**

1. **PDF_TEXT_SEARCH**: Search across all PDF document text
   - Use for: Finding property details, legal terms, descriptions
   
2. **IMAGE_ANALYSIS_SEARCH**: Search across AI image analysis results
   - Use for: Property features, conditions, AI detections
   
3. **PROPERTY_DAMAGE_SEARCH**: Search damage descriptions specifically
   - Use for: Insurance claims, inspection issues, risk assessment

### 2.2 Verify Creation

```sql
-- Check all services exist
SHOW CORTEX SEARCH SERVICES IN SCHEMA PDF_ANALYTICS_DB.PDF_PROCESSING;

-- Test a search (after data is loaded)
SELECT * FROM TABLE(
  PDF_ANALYTICS_DB.PDF_PROCESSING.PDF_TEXT_SEARCH('property description')
) LIMIT 5;
```

---

## Step 3: Add to Existing Snowflake Intelligence Agent

### 3.1 Add Semantic View to Agent

1. Navigate to **Snowsight** → **AI & ML** → **Agents**
2. Open your existing agent: **Consolidated_Analytics_Intelligence_Agent**
3. Go to **Settings** → **Data Sources**
4. Click **+ Add Data Source**
5. Configure:

```yaml
Type: Semantic View
Database: PDF_ANALYTICS_DB
Schema: PDF_PROCESSING
View: SV_PROPERTY_PDF_INTELLIGENCE
```

6. Click **Add**

### 3.2 Add Cortex Analyst Tool (if not already configured)

1. In Agent settings, click **Tools**
2. Find **Cortex Analyst** and click **+ Add** (or edit existing)
3. Add the new semantic model:
   - **Semantic models**: Add `PDF_ANALYTICS_DB.PDF_PROCESSING.SV_PROPERTY_PDF_INTELLIGENCE`
   - **Warehouse**: `CA_ANALYTICS_WH` (or your warehouse)
   - **Description**:
     ```
     Query real estate property PDF documents and image analysis data.
     Analyze property text extraction, AI-powered image analysis, property
     features (solar panels, for-sale signs, damage), and condition assessments.
     ```

4. Click **Save** or **Update**

### 3.3 Add Cortex Search Services

Add each of the three search services:

#### Service 1: PDF Text Search

1. In Agent settings, click **Tools**
2. Find **Cortex Search** and click **+ Add**
3. Configure:
   - **Name**: Property Document Text Search
   - **Search service**: `PDF_ANALYTICS_DB.PDF_PROCESSING.PDF_TEXT_SEARCH`
   - **Warehouse**: `CA_ANALYTICS_WH`
   - **Description**:
     ```
     Search property PDF documents for specific text, property descriptions,
     legal terms, and document details. Use for questions about property
     characteristics, contract terms, and document contents.
     ```

#### Service 2: Image Analysis Search

1. Click **+ Add** again for Cortex Search
2. Configure:
   - **Name**: Property Image Analysis Search
   - **Search service**: `PDF_ANALYTICS_DB.PDF_PROCESSING.IMAGE_ANALYSIS_SEARCH`
   - **Warehouse**: `CA_ANALYTICS_WH`
   - **Description**:
     ```
     Search AI-powered image analysis results to find properties with specific
     features: solar panels, for-sale signs, human presence, or damage. Use for
     visual property assessment and feature detection queries.
     ```

#### Service 3: Property Damage Search

1. Click **+ Add** again for Cortex Search
2. Configure:
   - **Name**: Property Damage & Inspection Search
   - **Search service**: `PDF_ANALYTICS_DB.PDF_PROCESSING.PROPERTY_DAMAGE_SEARCH`
   - **Warehouse**: `CA_ANALYTICS_WH`
   - **Description**:
     ```
     Search property damage descriptions and structural issues detected in
     images. Use for insurance, inspection, risk assessment, and property
     condition queries.
     ```

---

## Step 4: Update Agent Instructions (System Prompt)

Update your agent's instructions to include PDF Analytics capabilities:

### 4.1 Edit Agent Instructions

1. In Agent settings, find **Instructions** or **System Prompt**
2. **Append** the following to existing instructions:

```
Real Estate Property Intelligence (PDF Analytics):
6. Property Documents: PDF text extraction, document analysis, property descriptions
7. Property Images: AI-powered visual analysis of property photos
8. Property Conditions: Solar panel detection, for-sale sign detection, damage assessment
9. Risk Assessment: Property damage detection, structural issues, condition ratings

When analyzing properties:
- Search PDF documents for specific property details and legal terms
- Query image analysis for visual features (solar panels, damage, occupancy)
- Assess property condition based on AI image analysis confidence scores
- Identify properties with specific features using semantic search
- Calculate detection rates and confidence metrics across property portfolios
- Compare properties based on extracted text and visual analysis
- Highlight properties with damage or condition concerns for inspection

Property Data Context:
- Detection Types: For-sale signs, solar panels, human presence, property damage
- Confidence Scores: All AI detections include confidence levels (0.0 to 1.0)
- Document Types: Property PDFs with page-level text extraction
- Image Analysis: Cortex AI model-powered visual property assessment
```

### 4.2 Complete Updated Instructions

Your full agent instructions should now cover:
1. Loan Portfolio Intelligence (existing)
2. Property Valuations Intelligence (existing)
3. Due Diligence Intelligence (existing)
4. Risk Analytics (existing)
5. Operational Efficiency (existing)
6. **Property Documents** (NEW)
7. **Property Images** (NEW)
8. **Property Conditions** (NEW)
9. **Risk Assessment** (NEW)

---

## Step 5: Test the Integration

### 5.1 Test Semantic View Queries

Ask the agent questions like:
- "How many PDF documents have been processed?"
- "What is the average confidence score for solar panel detection?"
- "Show me documents where damage was detected"
- "How many images contain for-sale signs?"
- "What percentage of properties have solar panels?"

### 5.2 Test Cortex Search

Ask the agent questions like:
- "Find properties with pool and garage in the description"
- "Search for properties with roof damage"
- "Which properties have solar panels detected in images?"
- "Find documents mentioning HOA fees"
- "Show properties with structural concerns"

### 5.3 Combined Analysis

Ask complex questions combining multiple data sources:
- "Compare properties with solar panels vs. without - average values"
- "Find damaged properties in California with appraisals below market"
- "Which properties have for-sale signs but no active loan?"

---

## Example Questions for the Enhanced Agent

### Property Document Analysis
1. "How many property PDF documents have been processed this month?"
2. "Search all property documents for mentions of 'water damage' or 'flooding'"
3. "What is the average number of pages per property document?"

### Image Analysis & Detection
4. "Show me all properties where solar panels were detected"
5. "What is the average confidence score for damage detection?"
6. "Find properties with for-sale signs detected in the last 30 days"
7. "Which properties have human presence detected in their photos?"

### Property Condition Assessment
8. "List all properties with potential damage detected and confidence > 0.8"
9. "Compare damage detection rates across different property documents"
10. "Find properties with both damage detected and low appraisal values"

### Risk & Insurance
11. "Identify high-risk properties based on damage detection and condition scores"
12. "Search for properties with structural concerns in their image analysis"
13. "Show properties requiring inspection based on AI damage detection"

### Market Intelligence
14. "How many properties have for-sale signs vs. solar panels?"
15. "Compare property values for solar-equipped vs. non-solar properties"
16. "Find properties with for-sale signs but no recent appraisal"

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│         Snowflake Intelligence Agent                        │
│     (Consolidated Analytics + PDF Analytics)                │
└───────────────────┬─────────────────────────────────────────┘
                    │
        ┌───────────┴───────────┐
        │                       │
        ▼                       ▼
┌───────────────────┐   ┌──────────────────────┐
│  Cortex Analyst   │   │   Cortex Search      │
│  (Semantic Views) │   │   (Text Search)      │
└────────┬──────────┘   └──────────┬───────────┘
         │                         │
    ┌────┴─────┐         ┌─────────┴──────────┐
    │          │         │         │           │
    ▼          ▼         ▼         ▼           ▼
┌───────┐ ┌──────────┐ ┌──────┐ ┌──────┐ ┌─────────┐
│Loan & │ │Property  │ │PDF   │ │Image │ │Damage   │
│Borrower│ │Valuation│ │Text  │ │Analysis│ │Search  │
│SV     │ │SV       │ │Search│ │Search │ │        │
└───────┘ └──────────┘ └──────┘ └──────┘ └─────────┘
│          │           │        │         │
▼          ▼           ▼        ▼         ▼
CONSOLIDATED_ANALYTICS_DB   PDF_ANALYTICS_DB
```

---

## Data Flow

1. **PDF Upload** → `PDF_FILES_STAGE` (setup.sql line 73-76)
2. **Text Extraction** → `PDF_TEXT_DATA` table (setup.sql line 24-31)
3. **Image Extraction** → `PDF_IMAGES_STAGE` (setup.sql line 66-69)
4. **AI Analysis** → `IMAGE_ANALYSIS_RESULTS` table (setup.sql line 35-53)
5. **Semantic View** → `SV_PROPERTY_PDF_INTELLIGENCE`
6. **Cortex Search** → 3 search services (text, images, damage)
7. **Intelligence Agent** → Natural language queries

---

## Troubleshooting

### Issue: Semantic View Not Found
**Solution**: Verify database and schema context:
```sql
USE DATABASE PDF_ANALYTICS_DB;
USE SCHEMA PDF_PROCESSING;
SHOW SEMANTIC VIEWS;
```

### Issue: Cortex Search Service Failed
**Solution**: Check warehouse permissions:
```sql
SHOW GRANTS ON WAREHOUSE <YOUR_WAREHOUSE>;
-- Need: USAGE, OPERATE permissions
```

### Issue: No Search Results
**Solution**: Verify data exists and text columns are populated:
```sql
SELECT COUNT(*) FROM PDF_TEXT_DATA WHERE EXTRACTED_TEXT IS NOT NULL;
SELECT COUNT(*) FROM IMAGE_ANALYSIS_RESULTS WHERE FULL_ANALYSIS_TEXT IS NOT NULL;
```

### Issue: Agent Not Using New Tools
**Solution**: 
1. Verify tools are enabled in agent settings
2. Check warehouse is specified correctly
3. Test tools individually in Snowsight before using in agent
4. Refresh agent configuration (disable/enable tools)

---

## Performance Optimization

### For Large Document Sets (>10,000 documents):

1. **Increase Target Lag** for less frequent updates:
```sql
-- Modify in 08_create_pdf_analytics_cortex_search.sql
TARGET_LAG = '6 hours'  -- instead of '1 hour'
```

2. **Partition Large Tables** by date:
```sql
-- Add clustering to improve query performance
ALTER TABLE PDF_TEXT_DATA CLUSTER BY (UPLOAD_TIMESTAMP);
ALTER TABLE IMAGE_ANALYSIS_RESULTS CLUSTER BY (ANALYSIS_TIMESTAMP);
```

3. **Use Larger Warehouse** for search services:
```sql
-- Consider SMALL or MEDIUM warehouse for high query volume
WAREHOUSE = CA_ANALYTICS_WH_MEDIUM
```

---

## Security & Permissions

Required permissions for PDF Analytics:

```sql
-- Grant to your role (replace <YOUR_ROLE>)
GRANT USAGE ON DATABASE PDF_ANALYTICS_DB TO ROLE <YOUR_ROLE>;
GRANT USAGE ON SCHEMA PDF_PROCESSING TO ROLE <YOUR_ROLE>;
GRANT SELECT ON TABLE PDF_TEXT_DATA TO ROLE <YOUR_ROLE>;
GRANT SELECT ON TABLE IMAGE_ANALYSIS_RESULTS TO ROLE <YOUR_ROLE>;
GRANT USAGE ON CORTEX SEARCH SERVICE PDF_TEXT_SEARCH TO ROLE <YOUR_ROLE>;
GRANT USAGE ON CORTEX SEARCH SERVICE IMAGE_ANALYSIS_SEARCH TO ROLE <YOUR_ROLE>;
GRANT USAGE ON CORTEX SEARCH SERVICE PROPERTY_DAMAGE_SEARCH TO ROLE <YOUR_ROLE>;
```

---

## Maintenance

### Refresh Search Services (after large data loads):
```sql
-- Cortex Search automatically refreshes based on TARGET_LAG
-- To force immediate refresh:
ALTER CORTEX SEARCH SERVICE PDF_TEXT_SEARCH RESUME;
ALTER CORTEX SEARCH SERVICE IMAGE_ANALYSIS_SEARCH RESUME;
ALTER CORTEX SEARCH SERVICE PROPERTY_DAMAGE_SEARCH RESUME;
```

### Monitor Search Performance:
```sql
-- Check service status
SHOW CORTEX SEARCH SERVICES IN SCHEMA PDF_PROCESSING;

-- View service details
DESCRIBE CORTEX SEARCH SERVICE PDF_TEXT_SEARCH;
```

---

## Next Steps

1. ✅ Execute setup.sql to create database and tables
2. ✅ Edit and execute 07_create_pdf_analytics_semantic_view.sql
3. ✅ Edit and execute 08_create_pdf_analytics_cortex_search.sql
4. ✅ Add semantic view to agent data sources
5. ✅ Add Cortex Search services to agent tools
6. ✅ Update agent instructions
7. ✅ Load sample data (from your PDF processing application)
8. ✅ Test queries and searches
9. ✅ Refine instructions based on agent performance

---

## Support

For issues or questions:
- Review main agent setup: `docs/AGENT_SETUP.md`
- Check Snowflake documentation: https://docs.snowflake.com/en/guides/cortex/overview
- Verify syntax against template: `sql/views/05_create_semantic_views.sql`
- Review Cortex Search examples: `sql/search/06_create_cortex_search.sql`

---

**Last Updated**: October 30, 2025  
**Version**: 1.0  
**Compatibility**: Snowflake Cortex Intelligence (2024+)

