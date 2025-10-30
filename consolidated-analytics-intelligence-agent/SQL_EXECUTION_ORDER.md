# SQL Script Execution Order

Execute SQL scripts in this **exact order** for proper setup of the Consolidated Analytics Intelligence Agent with PDF Analytics.

---

## Part 1: Core Analytics Setup

### 1. Database & Schema Setup
```bash
sql/setup/01_database_and_schema.sql
```
**Creates**: `CONSOLIDATED_ANALYTICS_DB`, `RAW` and `ANALYTICS` schemas, `CA_ANALYTICS_WH` warehouse  
**Time**: < 5 seconds

### 2. Create Tables
```bash
sql/setup/02_create_tables.sql
```
**Creates**: 10 core tables (BORROWERS, PROPERTIES, LOANS, VALUATIONS, etc.)  
**Time**: < 10 seconds

### 3. Generate Sample Data
```bash
sql/data/03_generate_synthetic_data.sql
```
**Creates**: Realistic sample data (50K borrowers, 75K loans, 1M transactions)  
**Time**: 5-15 minutes

### 4. Create Analytical Views
```bash
sql/views/04_create_views.sql
```
**Creates**: 7 analytical views (V_LOAN_PORTFOLIO, V_PROPERTY_VALUATIONS, etc.)  
**Time**: < 5 seconds

### 5. Create Semantic Views
```bash
sql/views/05_create_semantic_views.sql
```
**Creates**: 3 semantic views for AI agents  
**Time**: < 5 seconds

### 6. Create Cortex Search Services
```bash
sql/search/06_create_cortex_search.sql
```
**Creates**: 3 Cortex Search services + unstructured data tables  
**Time**: 3-5 minutes

---

## Part 2: PDF Analytics Setup (NEW)

### 7. PDF Analytics Database & Tables
```bash
sql/setup/setup.sql
```
**Creates**: `PDF_ANALYTICS_DB`, `PDF_PROCESSING` schema, PDF tables and stages  
**Time**: < 5 seconds

### 8. PDF Analytics Semantic View
```bash
sql/views/07_create_pdf_analytics_semantic_view.sql
```
**Creates**: `SV_PROPERTY_PDF_INTELLIGENCE` semantic view  
**Time**: < 5 seconds  
**⚠️ EDIT FIRST**: Replace warehouse name on line 18

### 9. PDF Analytics Cortex Search
```bash
sql/search/08_create_pdf_analytics_cortex_search.sql
```
**Creates**: 3 PDF-related Cortex Search services  
**Time**: 1-3 minutes  
**⚠️ EDIT FIRST**: Replace `<YOUR_WAREHOUSE>` on lines 24, 48, 77

---

## Complete Execution Script

### Option A: Manual Execution (Snowsight)
Copy and paste each script into Snowsight SQL worksheet and execute in order.

### Option B: SnowSQL Command Line
```bash
# Core Analytics
snowsql -f sql/setup/01_database_and_schema.sql
snowsql -f sql/setup/02_create_tables.sql
snowsql -f sql/data/03_generate_synthetic_data.sql
snowsql -f sql/views/04_create_views.sql
snowsql -f sql/views/05_create_semantic_views.sql
snowsql -f sql/search/06_create_cortex_search.sql

# PDF Analytics (AFTER editing warehouse references)
snowsql -f sql/setup/setup.sql
snowsql -f sql/views/07_create_pdf_analytics_semantic_view.sql
snowsql -f sql/search/08_create_pdf_analytics_cortex_search.sql
```

### Option C: All-in-One (After Editing)
```bash
# Create combined script
cat sql/setup/01_database_and_schema.sql \
    sql/setup/02_create_tables.sql \
    sql/data/03_generate_synthetic_data.sql \
    sql/views/04_create_views.sql \
    sql/views/05_create_semantic_views.sql \
    sql/search/06_create_cortex_search.sql \
    sql/setup/setup.sql \
    sql/views/07_create_pdf_analytics_semantic_view.sql \
    sql/search/08_create_pdf_analytics_cortex_search.sql \
    > full_setup.sql

# Execute
snowsql -f full_setup.sql
```

---

## Verification Queries

### After Core Analytics Setup (Step 6):
```sql
-- Check databases
SHOW DATABASES LIKE 'CONSOLIDATED_ANALYTICS_DB';

-- Check schemas
SHOW SCHEMAS IN DATABASE CONSOLIDATED_ANALYTICS_DB;

-- Check tables (should show 10 tables)
SHOW TABLES IN SCHEMA CONSOLIDATED_ANALYTICS_DB.RAW;

-- Check data counts
SELECT COUNT(*) FROM CONSOLIDATED_ANALYTICS_DB.RAW.BORROWERS;
SELECT COUNT(*) FROM CONSOLIDATED_ANALYTICS_DB.RAW.LOANS;

-- Check semantic views (should show 3)
SHOW SEMANTIC VIEWS IN SCHEMA CONSOLIDATED_ANALYTICS_DB.ANALYTICS;

-- Check Cortex Search services (should show 3)
SHOW CORTEX SEARCH SERVICES IN SCHEMA CONSOLIDATED_ANALYTICS_DB.RAW;
```

### After PDF Analytics Setup (Step 9):
```sql
-- Check PDF database
SHOW DATABASES LIKE 'PDF_ANALYTICS_DB';

-- Check schema
SHOW SCHEMAS IN DATABASE PDF_ANALYTICS_DB;

-- Check tables (should show 3: PDF_TEXT_DATA, IMAGE_ANALYSIS_RESULTS, APP_CONFIG)
SHOW TABLES IN SCHEMA PDF_ANALYTICS_DB.PDF_PROCESSING;

-- Check stages (should show 2: PDF_IMAGES_STAGE, PDF_FILES_STAGE)
SHOW STAGES IN SCHEMA PDF_ANALYTICS_DB.PDF_PROCESSING;

-- Check semantic view (should show 1)
SHOW SEMANTIC VIEWS IN SCHEMA PDF_ANALYTICS_DB.PDF_PROCESSING;

-- Check Cortex Search services (should show 3)
SHOW CORTEX SEARCH SERVICES IN SCHEMA PDF_ANALYTICS_DB.PDF_PROCESSING;
```

---

## Troubleshooting

### Error: "Warehouse does not exist"
**Solution**: Edit scripts 7, 8, 9 to use your actual warehouse name

### Error: "Insufficient privileges"
**Solution**: Use ACCOUNTADMIN role or grant required permissions:
```sql
USE ROLE ACCOUNTADMIN;
GRANT CREATE DATABASE ON ACCOUNT TO ROLE <YOUR_ROLE>;
GRANT CREATE SEMANTIC VIEW ON SCHEMA TO ROLE <YOUR_ROLE>;
```

### Error: "Object already exists"
**Solution**: Scripts use `CREATE OR REPLACE` - safe to re-run most scripts

### Error: Cortex Search service fails
**Solution**: 
1. Verify Cortex is enabled: Contact Snowflake support
2. Check warehouse permissions: `SHOW GRANTS ON WAREHOUSE <YOUR_WAREHOUSE>`
3. Ensure data exists in source tables before creating search services

---

## Total Setup Time

| Phase | Time | Notes |
|-------|------|-------|
| Core Analytics Setup | 10-20 minutes | Includes data generation |
| PDF Analytics Setup | 5-10 minutes | Faster if no data generation yet |
| **Total** | **15-30 minutes** | One-time setup |

---

## Next Steps After Execution

1. ✅ Configure Snowflake Intelligence Agent (see `docs/AGENT_SETUP.md`)
2. ✅ Add PDF Analytics integration (see `docs/PDF_ANALYTICS_INTEGRATION.md`)
3. ✅ Test with sample questions (see `docs/questions.md`)
4. ✅ Load your own data into tables

---

**Last Updated**: October 30, 2025  
**Version**: 1.0

