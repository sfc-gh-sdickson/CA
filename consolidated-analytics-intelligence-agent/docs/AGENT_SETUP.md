<img src="../Snowflake_Logo.svg" width="200">

# Consolidated Analytics Intelligence Agent - Setup Guide

This guide walks through configuring a Snowflake Intelligence agent for Consolidated Analytics' mortgage and real estate finance intelligence solution.

---

## Prerequisites

1. **Snowflake Account** with:
   - Snowflake Intelligence (Cortex) enabled
   - Appropriate warehouse size (recommended: X-SMALL or larger)
   - Permissions to create databases, schemas, tables, and semantic views

2. **Roles and Permissions**:
   - `ACCOUNTADMIN` role or equivalent for initial setup
   - `CREATE DATABASE` privilege
   - `CREATE SEMANTIC VIEW` privilege
   - `CREATE CORTEX SEARCH SERVICE` privilege
   - `USAGE` on warehouses

---

## Step 1: Execute SQL Scripts in Order

Execute the SQL files in the following sequence:

### 1.1 Database Setup
```sql
-- Execute: sql/setup/01_database_and_schema.sql
-- Creates database, schemas (RAW, ANALYTICS), and warehouse
-- Execution time: < 1 second
```

### 1.2 Create Tables
```sql
-- Execute: sql/setup/02_create_tables.sql
-- Creates all table structures with proper relationships
-- Tables: BORROWERS, PROPERTIES, LOANS, VALUATIONS, DUE_DILIGENCE_REVIEWS,
--         TRANSACTIONS, SUPPORT_CASES, ANALYSTS, PORTFOLIO_SEGMENTS, COMPLIANCE_DOCUMENTS
-- Execution time: < 5 seconds
```

### 1.3 Generate Sample Data
```sql
-- Execute: sql/data/03_generate_synthetic_data.sql
-- Generates realistic sample data:
--   - 50,000 borrowers
--   - 60,000 properties
--   - 75,000 loans
--   - 80,000 valuations
--   - 100,000 due diligence reviews
--   - 1,000,000 transactions
--   - 50,000 support cases
--   - 200 analysts
-- Execution time: 5-15 minutes (depending on warehouse size)
```

### 1.4 Create Analytical Views
```sql
-- Execute: sql/views/04_create_views.sql
-- Creates curated analytical views:
--   - V_LOAN_PORTFOLIO
--   - V_PROPERTY_VALUATIONS
--   - V_DUE_DILIGENCE_METRICS
--   - V_PORTFOLIO_RISK
--   - V_TRANSACTION_ANALYTICS
--   - V_ANALYST_PERFORMANCE
--   - V_CLIENT_360
-- Execution time: < 5 seconds
```

### 1.5 Create Semantic Views
```sql
-- Execute: sql/views/05_create_semantic_views.sql
-- Creates semantic views for AI agents (VERIFIED SYNTAX):
--   - SV_BORROWER_LOAN_INTELLIGENCE
--   - SV_PROPERTY_VALUATION_INTELLIGENCE
--   - SV_DUE_DILIGENCE_INTELLIGENCE
-- Execution time: < 5 seconds
```

### 1.6 Create Cortex Search Services
```sql
-- Execute: sql/search/06_create_cortex_search.sql
-- Creates tables for unstructured text data:
--   - LOAN_REVIEW_NOTES (50,000 review notes)
--   - APPRAISAL_REPORTS (30,000 appraisal narratives)
--   - COMPLIANCE_KNOWLEDGE_BASE (3 regulatory articles)
-- Creates Cortex Search services for semantic search:
--   - LOAN_REVIEW_NOTES_SEARCH
--   - APPRAISAL_REPORTS_SEARCH
--   - COMPLIANCE_KB_SEARCH
-- Execution time: 3-5 minutes (data generation + index building)
```

---

## Step 2: Create Snowflake Intelligence Agent

### 2.1 Via Snowsight UI

1. Navigate to **Snowsight** (Snowflake Web UI)
2. Go to **AI & ML** → **Agents**
3. Click **Create Agent**
4. Configure the agent:

**Basic Settings:**
```yaml
Name: Consolidated_Analytics_Intelligence_Agent
Description: AI agent for analyzing mortgage loans, property valuations, due diligence reviews, and real estate finance operations
```

**Data Sources (Semantic Views):**
Add the following semantic views:
- `CONSOLIDATED_ANALYTICS_DB.ANALYTICS.SV_BORROWER_LOAN_INTELLIGENCE`
- `CONSOLIDATED_ANALYTICS_DB.ANALYTICS.SV_PROPERTY_VALUATION_INTELLIGENCE`
- `CONSOLIDATED_ANALYTICS_DB.ANALYTICS.SV_DUE_DILIGENCE_INTELLIGENCE`

**Warehouse:**
- Select: `CA_ANALYTICS_WH`

**Instructions (System Prompt):**
```
You are an AI intelligence agent for Consolidated Analytics, specializing in mortgage and real estate finance operations.

Your role is to analyze:
1. Loan Portfolio: Mortgage originations, risk ratings, performance metrics
2. Property Valuations: Appraisals, market conditions, valuation variance
3. Due Diligence: Quality control reviews, compliance scores, exception management
4. Risk Analytics: Credit risk, portfolio concentration, delinquency trends
5. Operational Efficiency: Analyst productivity, turnaround times, client satisfaction

When answering questions:
- Provide specific metrics and data-driven insights
- Compare trends over time and across dimensions
- Highlight risk concentrations and compliance issues
- Benchmark performance across loan types, property types, and geographies
- Calculate rates, percentages, and derived metrics
- Identify actionable recommendations for portfolio management

Data Context:
- Loan Types: CONVENTIONAL, FHA, VA, JUMBO, COMMERCIAL, USDA
- Property Types: RESIDENTIAL_SINGLE_FAMILY, RESIDENTIAL_CONDO, MULTI_FAMILY, COMMERCIAL
- Risk Ratings: A (lowest risk), B, C, D (highest risk)
- Review Types: PRE_FUNDING, POST_CLOSING, COMPLIANCE_AUDIT, QUALITY_CONTROL, PORTFOLIO_REVIEW
- Valuation Types: FULL_APPRAISAL, DESKTOP_APPRAISAL, BPO, AVM, DRIVE_BY
```

5. Click **Create Agent**

---

## Step 3: Add Cortex Analyst Tool to Agent

Cortex Analyst enables the agent to query your semantic views using natural language.

### 3.1 Add Cortex Analyst

1. In Agent settings, click **Tools**
2. Find **Cortex Analyst** and click **+ Add**
3. Configure:
   - **Name**: Consolidated Analytics Data Analysis
   - **Semantic models**: Select all three semantic views:
     - `CONSOLIDATED_ANALYTICS_DB.ANALYTICS.SV_BORROWER_LOAN_INTELLIGENCE`
     - `CONSOLIDATED_ANALYTICS_DB.ANALYTICS.SV_PROPERTY_VALUATION_INTELLIGENCE`
     - `CONSOLIDATED_ANALYTICS_DB.ANALYTICS.SV_DUE_DILIGENCE_INTELLIGENCE`
   - **Warehouse**: `CA_ANALYTICS_WH`
   - **Description**:
     ```
     Query loan portfolio, property valuations, and due diligence data using
     natural language. Analyzes mortgage loans, borrower profiles, property
     values, appraisals, compliance reviews, and operational metrics across
     the entire portfolio.
     ```

4. Click **Add** to enable Cortex Analyst

**Important**: Cortex Analyst is the primary tool for querying structured data from your semantic views. The agent will use this tool to answer analytical questions about loans, properties, valuations, and reviews.

---

## Step 4: Add Cortex Search Services to Agent

Cortex Search enables semantic search over unstructured text data.

### 4.1 Add Loan Review Notes Search

1. In Agent settings, click **Tools**
2. Find **Cortex Search** and click **+ Add**
3. Configure:
   - **Name**: Loan Review Notes Search
   - **Search service**: `CONSOLIDATED_ANALYTICS_DB.RAW.LOAN_REVIEW_NOTES_SEARCH`
   - **Warehouse**: `CA_ANALYTICS_WH`
   - **Description**:
     ```
     Search 50,000 loan due diligence review notes to find similar findings,
     compliance issues, exceptions, and resolution procedures. Use for questions
     about loan defects, underwriting exceptions, and quality control issues.
     ```

### 4.2 Add Appraisal Reports Search

1. Click **+ Add** again for Cortex Search
2. Configure:
   - **Name**: Appraisal Reports Search
   - **Search service**: `CONSOLIDATED_ANALYTICS_DB.RAW.APPRAISAL_REPORTS_SEARCH`
   - **Warehouse**: `CA_ANALYTICS_WH`
   - **Description**:
     ```
     Search 30,000 property appraisal reports to find similar valuations,
     property conditions, market analyses, and comparable sales. Use for
     questions about property characteristics, appraisal methodologies, and
     valuation challenges.
     ```

### 4.3 Add Compliance Knowledge Base Search

1. Click **+ Add** again for Cortex Search
2. Configure:
   - **Name**: Compliance Knowledge Base Search
   - **Search service**: `CONSOLIDATED_ANALYTICS_DB.RAW.COMPLIANCE_KB_SEARCH`
   - **Warehouse**: `CA_ANALYTICS_WH`
   - **Description**:
     ```
     Search regulatory compliance knowledge base for TRID requirements, fair
     lending rules, FHA guidelines, and mortgage regulations. Use for questions
     about compliance procedures, regulatory requirements, and lending guidelines.
     ```

---

## Step 5: Test the Agent

### 5.1 Simple Test Questions

Start with simple questions to verify connectivity:

1. **"How many loans does Consolidated Analytics have?"**
   - Should query SV_BORROWER_LOAN_INTELLIGENCE
   - Expected: ~75,000 loans

2. **"What is the average property value?"**
   - Should query SV_PROPERTY_VALUATION_INTELLIGENCE
   - Expected: Varies by property type

3. **"How many due diligence reviews have been completed?"**
   - Should query SV_DUE_DILIGENCE_INTELLIGENCE
   - Expected: Count of completed reviews

### 5.2 Complex Test Questions

Test with the 10 complex questions provided in `docs/questions.md`

### 5.3 Cortex Search Test Questions

Test unstructured data search:

1. **"Search loan review notes for properties with foundation issues"**
2. **"Find appraisal reports mentioning commercial properties"**
3. **"What does our compliance knowledge base say about TRID regulations?"**

---

## Step 6: Query Cortex Search Services Directly

You can also query Cortex Search services directly using SQL:

### Query Loan Review Notes
```sql
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'CONSOLIDATED_ANALYTICS_DB.RAW.LOAN_REVIEW_NOTES_SEARCH',
      '{
        "query": "income verification issues",
        "columns":["note_text", "note_type", "severity"],
        "limit":10
      }'
  )
)['results'] as results;
```

### Query Appraisal Reports
```sql
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'CONSOLIDATED_ANALYTICS_DB.RAW.APPRAISAL_REPORTS_SEARCH',
      '{
        "query": "foundation concerns or structural issues",
        "columns":["report_text", "property_id"],
        "limit":10
      }'
  )
)['results'] as results;
```

### Query Compliance Knowledge Base
```sql
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'CONSOLIDATED_ANALYTICS_DB.RAW.COMPLIANCE_KB_SEARCH',
      '{
        "query": "FHA loan requirements",
        "columns":["title", "content"],
        "limit":5
      }'
  )
)['results'] as results;
```

---

## Step 7: Access Control

### Create Role for Agent Users
```sql
CREATE ROLE IF NOT EXISTS CA_AGENT_USER;

-- Grant necessary privileges
GRANT USAGE ON DATABASE CONSOLIDATED_ANALYTICS_DB TO ROLE CA_AGENT_USER;
GRANT USAGE ON SCHEMA CONSOLIDATED_ANALYTICS_DB.ANALYTICS TO ROLE CA_AGENT_USER;
GRANT USAGE ON SCHEMA CONSOLIDATED_ANALYTICS_DB.RAW TO ROLE CA_AGENT_USER;
GRANT SELECT ON ALL VIEWS IN SCHEMA CONSOLIDATED_ANALYTICS_DB.ANALYTICS TO ROLE CA_AGENT_USER;
GRANT USAGE ON WAREHOUSE CA_ANALYTICS_WH TO ROLE CA_AGENT_USER;

-- Grant Cortex Search usage
GRANT USAGE ON CORTEX SEARCH SERVICE CONSOLIDATED_ANALYTICS_DB.RAW.LOAN_REVIEW_NOTES_SEARCH TO ROLE CA_AGENT_USER;
GRANT USAGE ON CORTEX SEARCH SERVICE CONSOLIDATED_ANALYTICS_DB.RAW.APPRAISAL_REPORTS_SEARCH TO ROLE CA_AGENT_USER;
GRANT USAGE ON CORTEX SEARCH SERVICE CONSOLIDATED_ANALYTICS_DB.RAW.COMPLIANCE_KB_SEARCH TO ROLE CA_AGENT_USER;

-- Grant to specific user
GRANT ROLE CA_AGENT_USER TO USER your_username;
```

---

## Troubleshooting

### Issue: Semantic views not found

**Solution:**
```sql
-- Verify semantic views exist
SHOW SEMANTIC VIEWS IN SCHEMA CONSOLIDATED_ANALYTICS_DB.ANALYTICS;

-- Check permissions
SHOW GRANTS ON VIEW SV_BORROWER_LOAN_INTELLIGENCE;
```

### Issue: Cortex Search returns no results

**Solution:**
```sql
-- Verify service exists and is populated
SHOW CORTEX SEARCH SERVICES IN SCHEMA RAW;

-- Check data in source table
SELECT COUNT(*) FROM RAW.LOAN_REVIEW_NOTES;

-- Verify change tracking is enabled
SHOW TABLES LIKE 'LOAN_REVIEW_NOTES' IN SCHEMA RAW;
```

---

## Success Metrics

Your agent is successfully configured when:

✅ All 6 SQL scripts execute without errors  
✅ All semantic views are created and validated  
✅ All 3 Cortex Search services are created and indexed  
✅ Agent can answer simple test questions  
✅ Agent can answer complex analytical questions  
✅ Cortex Search returns relevant results  
✅ Query performance is acceptable (< 30 seconds for complex queries)  
✅ Results are accurate and match expected business logic  

---

## Support Resources

- **Snowflake Documentation**: https://docs.snowflake.com/en/sql-reference/sql/create-semantic-view
- **Cortex Search Documentation**: https://docs.snowflake.com/en/sql-reference/sql/create-cortex-search
- **Consolidated Analytics**: https://www.consolidatedanalytics.com
- **Snowflake Community**: https://community.snowflake.com

---

**Version:** 1.0  
**Created:** October 2025  
**Based on:** GoDaddy Intelligence Template with Verified Syntax
