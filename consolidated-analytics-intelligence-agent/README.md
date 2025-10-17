# Consolidated Analytics Intelligence Agent Solution

<img src="https://www.snowflake.com/wp-content/themes/snowflake/assets/img/brand-guidelines/logo-sno-blue-example.svg" width="200">

## About Consolidated Analytics

Consolidated Analytics is a leading provider of mortgage and real estate finance services, offering comprehensive solutions to the industry.

### Key Business Lines

- **Mortgage Due Diligence**: Pre-funding and post-closing loan file reviews, quality control
- **Real Estate Asset Management**: Property portfolio management, performance monitoring
- **Valuation Services**: Appraisals, BPOs, desktop valuations, AVM analysis
- **Consulting & Advisory**: Risk analysis, portfolio strategy, market analytics
- **Business Process Services**: Document management, compliance tracking, workflow automation

### Market Position

- Comprehensive mortgage analytics and due diligence platform
- Advanced property valuation capabilities
- Regulatory compliance expertise
- Technology-enabled process efficiency

## Project Overview

This Snowflake Intelligence solution demonstrates how Consolidated Analytics can leverage AI agents to analyze:

- **Loan Portfolio Management**: Originations, risk ratings, performance tracking, delinquency analysis
- **Property Valuations**: Appraisal quality, market trends, valuation variance, geographic patterns
- **Due Diligence Operations**: Review quality, compliance scores, exception management, turnaround times
- **Risk Analytics**: Credit risk, concentration analysis, early warning indicators
- **Operational Efficiency**: Analyst productivity, process metrics, client satisfaction
- **Unstructured Data Search**: Semantic search over review notes, appraisal reports, and compliance knowledge base using Cortex Search

## Database Schema

The solution includes:

### 1. RAW Schema: Core Business Tables

**Borrower & Client Data:**
- **BORROWERS**: Customer master data with credit scores, income, employment
- **SUPPORT_CASES**: Client support and inquiries with resolution tracking

**Property & Valuation Data:**
- **PROPERTIES**: Real estate assets with characteristics, values, conditions
- **VALUATIONS**: Property appraisals with methodologies and market conditions

**Loan Portfolio Data:**
- **LOANS**: Mortgage loan portfolio with terms, rates, risk ratings
- **TRANSACTIONS**: Financial transactions, payments, disbursements

**Operations & Quality Data:**
- **DUE_DILIGENCE_REVIEWS**: Quality control and compliance reviews
- **ANALYSTS**: Staff performance, specializations, quality metrics
- **COMPLIANCE_DOCUMENTS**: Regulatory documentation and status
- **PORTFOLIO_SEGMENTS**: Portfolio categorization and limits

**Unstructured Data Tables:**
- **LOAN_REVIEW_NOTES**: Detailed review findings and exception narratives (50K notes)
- **APPRAISAL_REPORTS**: Full property appraisal report narratives (30K reports)
- **COMPLIANCE_KNOWLEDGE_BASE**: Regulatory guidance and procedures (3 articles)

### 2. ANALYTICS Schema: Curated Views and Semantic Models

**Analytical Views:**
- **V_LOAN_PORTFOLIO**: Complete loan portfolio with borrower and property details
- **V_PROPERTY_VALUATIONS**: Property values over time with trends
- **V_DUE_DILIGENCE_METRICS**: Review performance and compliance scores
- **V_PORTFOLIO_RISK**: Risk segmentation and concentration analysis
- **V_TRANSACTION_ANALYTICS**: Payment patterns and delinquency tracking
- **V_ANALYST_PERFORMANCE**: Productivity and quality metrics
- **V_CLIENT_360**: Complete borrower relationship view

**Semantic Views for AI Agents:**
- **SV_LOAN_PORTFOLIO_INTELLIGENCE**: Comprehensive loan, borrower, property, transaction analysis
- **SV_VALUATION_RISK_INTELLIGENCE**: Property valuations, appraisals, risk metrics
- **SV_DUE_DILIGENCE_INTELLIGENCE**: Review quality, compliance, operational efficiency

### 3. Cortex Search Services: Semantic Search Over Unstructured Data

- **LOAN_REVIEW_NOTES_SEARCH**: Search 50,000 due diligence review findings
- **APPRAISAL_REPORTS_SEARCH**: Search 30,000 property appraisal narratives
- **COMPLIANCE_KB_SEARCH**: Search regulatory compliance knowledge base

## Files

### SQL Scripts (Execute in Order)

1. `sql/setup/01_database_and_schema.sql` - Database and schema creation
2. `sql/setup/02_create_tables.sql` - Table definitions with constraints
3. `sql/data/03_generate_synthetic_data.sql` - Realistic sample data generation
4. `sql/views/04_create_views.sql` - Analytical views
5. `sql/views/05_create_semantic_views.sql` - Semantic views for AI agents (verified syntax)
6. `sql/search/06_create_cortex_search.sql` - Unstructured data tables and Cortex Search services

### Documentation

- `docs/AGENT_SETUP.md` - Step-by-step configuration instructions for Snowflake agents
- `docs/questions.md` - 15 complex questions the agent can answer
- `README.md` - This file: solution overview and architecture

## Setup Instructions

### Prerequisites

1. Snowflake account with Cortex Intelligence enabled
2. ACCOUNTADMIN or equivalent privileges
3. X-SMALL or larger warehouse

### Quick Start

```sql
-- 1. Create database and schemas
@sql/setup/01_database_and_schema.sql

-- 2. Create tables
@sql/setup/02_create_tables.sql

-- 3. Generate sample data (5-15 minutes)
@sql/data/03_generate_synthetic_data.sql

-- 4. Create analytical views
@sql/views/04_create_views.sql

-- 5. Create semantic views
@sql/views/05_create_semantic_views.sql

-- 6. Create Cortex Search services (3-5 minutes)
@sql/search/06_create_cortex_search.sql
```

### Configure Agent

Follow the detailed instructions in `docs/AGENT_SETUP.md` to:
1. Create the Snowflake Intelligence Agent
2. Add semantic views as data sources
3. Configure Cortex Search services
4. Set up system prompts
5. Test with sample questions

## Data Model Highlights

### Structured Data

- **Realistic mortgage data**: Loan amounts $100K-$50M, interest rates 2.5%-8.5%, LTV 60%-97%
- **Comprehensive credit profiles**: Credit scores 580-850 with weighted distributions
- **Property diversity**: Single-family, condos, multi-family, commercial properties
- **Geographic distribution**: 20 major states with realistic market patterns
- **Risk segmentation**: A, B, C, D risk ratings based on multiple factors
- **Complete transaction history**: 1M+ payments tracking loan performance
- **Due diligence records**: 100K reviews with compliance scores and findings

### Unstructured Data

- **50,000 loan review notes** with realistic due diligence findings
- **30,000 appraisal report narratives** with property descriptions and market analysis
- **3 comprehensive compliance articles** (TRID, Fair Lending, FHA Guidelines)
- **Semantic search** powered by Snowflake Cortex Search
- **RAG-ready** for AI agent context retrieval

## Key Features

✅ **Hybrid Data Architecture**: Combines structured tables with unstructured text data  
✅ **Semantic Search**: Find similar issues and solutions by meaning, not just keywords  
✅ **RAG-Ready**: Agent can retrieve context from review notes and appraisal reports  
✅ **Production-Ready Syntax**: All SQL verified against GoDaddy template and Snowflake documentation  
✅ **Comprehensive Demo**: 75K loans, 1M+ transactions, 50K review notes, 30K appraisals  
✅ **Verified Syntax**: CREATE SEMANTIC VIEW and CREATE CORTEX SEARCH SERVICE syntax verified

## Complex Questions Examples

The agent can answer sophisticated questions like:

**Portfolio Analytics:**
1. Loan portfolio risk concentration by rating, property type, and geography
2. Valuation variance analysis with market condition correlation
3. Geographic market performance comparison across states
4. Portfolio profitability analysis by loan type with risk adjustments

**Operations & Quality:**
5. Due diligence quality metrics by analyst and review type
6. Appraisal turnaround efficiency by property type and appraiser
7. Analyst productivity benchmarking across specializations
8. Compliance exception analysis with resolution tracking

**Risk Management:**
9. Delinquency trend prediction with multi-factor risk scoring
10. Client relationship analysis with lifetime value segmentation

**Unstructured Data (Cortex Search):**
11. Search review notes for foundation issues and resolution procedures
12. Find appraisal reports mentioning flood zones or water damage
13. Retrieve TRID regulatory compliance guidance
14. Identify title insurance exception patterns
15. Find appraisals with comparable sales challenges

## Semantic Views

The solution includes three verified semantic views with proper syntax:

### 1. SV_LOAN_PORTFOLIO_INTELLIGENCE
Comprehensive view of loans, borrowers, properties, and transactions
- **Tables**: BORROWERS, LOANS, PROPERTIES, TRANSACTIONS
- **Dimensions**: borrower_type, loan_type, property_type, risk_rating, states, statuses
- **Metrics**: loan counts, amounts, averages, ratios, property values, transaction volumes

### 2. SV_VALUATION_RISK_INTELLIGENCE
Property valuations, appraisals, and risk metrics
- **Tables**: PROPERTIES, VALUATIONS, LOANS, ANALYSTS
- **Dimensions**: property_type, valuation_type, valuation_method, confidence_level, market_conditions
- **Metrics**: valuation counts, averages, property values, LTV ratios, analyst quality scores

### 3. SV_DUE_DILIGENCE_INTELLIGENCE
Review quality, compliance, and operational metrics
- **Tables**: DUE_DILIGENCE_REVIEWS, LOANS, ANALYSTS, SUPPORT_CASES
- **Dimensions**: review_type, review_status, analyst_specialization, case_priority
- **Metrics**: review counts, compliance scores, exception rates, resolution times, satisfaction ratings

**All semantic views follow verified syntax structure:**
- TABLES clause with PRIMARY KEY definitions and synonyms
- RELATIONSHIPS clause defining foreign keys
- DIMENSIONS clause with synonyms and comments
- METRICS clause with aggregations and calculations
- Proper clause ordering (TABLES → RELATIONSHIPS → DIMENSIONS → METRICS → COMMENT)

## Cortex Search Services

Three Cortex Search services enable semantic search over unstructured data:

### 1. LOAN_REVIEW_NOTES_SEARCH
Search 50,000 loan due diligence review notes
- Find similar findings by description, not exact keywords
- Retrieve resolution procedures from past successful cases
- Analyze exception patterns and compliance issues
- Searchable attributes: loan_id, review_id, note_type, severity, created_date

### 2. APPRAISAL_REPORTS_SEARCH
Search 30,000 property appraisal report narratives
- Find similar property valuations and characteristics
- Identify comparable sales analysis patterns
- Retrieve market condition assessments
- Searchable attributes: property_id, valuation_id, appraiser_id, report_date

### 3. COMPLIANCE_KB_SEARCH
Search regulatory compliance knowledge base
- Retrieve TRID, fair lending, and FHA guidelines
- Find troubleshooting procedures
- Access regulatory documentation
- Searchable attributes: article_category, regulation_type, title

**All Cortex Search services use verified syntax:**
- ON clause: single column to search
- ATTRIBUTES clause: filterable columns (comma-separated)
- WAREHOUSE assignment
- TARGET_LAG: refresh frequency
- AS clause: source SELECT statement

## Syntax Verification

All SQL syntax has been verified against:
- **GoDaddy Template Repository** (local clone): Verified patterns for all SQL structures
- **CREATE SEMANTIC VIEW**: https://docs.snowflake.com/en/sql-reference/sql/create-semantic-view
- **CREATE CORTEX SEARCH SERVICE**: https://docs.snowflake.com/en/sql-reference/sql/create-cortex-search

**Key verification points:**
- ✅ Clause order is mandatory (TABLES → RELATIONSHIPS → DIMENSIONS → METRICS)
- ✅ PRIMARY KEY columns must exist in source tables
- ✅ No self-referencing or cyclic relationships
- ✅ Semantic expression format: `name AS expression`
- ✅ Change tracking enabled for Cortex Search tables
- ✅ Correct ATTRIBUTES syntax for filterable columns

## Data Volumes

- **Borrowers**: 50,000
- **Properties**: 60,000
- **Loans**: 75,000
- **Valuations**: 80,000
- **Due Diligence Reviews**: 100,000
- **Transactions**: 1,000,000
- **Support Cases**: 50,000
- **Analysts**: 200
- **Loan Review Notes**: 50,000 (unstructured)
- **Appraisal Reports**: 30,000 (unstructured)
- **Compliance Articles**: 3 comprehensive guides

## Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│               Snowflake Intelligence Agent                           │
│                                                                      │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │            Semantic Views (Structured Data)                    │ │
│  │  • SV_LOAN_PORTFOLIO_INTELLIGENCE                              │ │
│  │  • SV_VALUATION_RISK_INTELLIGENCE                              │ │
│  │  • SV_DUE_DILIGENCE_INTELLIGENCE                               │ │
│  └────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │          Cortex Search (Unstructured Data)                     │ │
│  │  • LOAN_REVIEW_NOTES_SEARCH                                    │ │
│  │  • APPRAISAL_REPORTS_SEARCH                                    │ │
│  │  • COMPLIANCE_KB_SEARCH                                        │ │
│  └────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌────────────────────────────────────────────────┐
        │         RAW Schema (Source Data)               │
        │  • Borrowers, Properties, Loans                │
        │  • Valuations, Due Diligence Reviews           │
        │  • Transactions, Support Cases, Analysts       │
        │  • Loan Review Notes (Unstructured)            │
        │  • Appraisal Reports (Unstructured)            │
        │  • Compliance Knowledge Base (Unstructured)    │
        └────────────────────────────────────────────────┘
```

## Testing

### Verify Installation
```sql
-- Check semantic views
SHOW VIEWS LIKE 'SV_%' IN SCHEMA CONSOLIDATED_ANALYTICS_DB.ANALYTICS;

-- Check Cortex Search services
SHOW CORTEX SEARCH SERVICES IN SCHEMA CONSOLIDATED_ANALYTICS_DB.RAW;

-- Test Cortex Search
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'CONSOLIDATED_ANALYTICS_DB.RAW.LOAN_REVIEW_NOTES_SEARCH',
      '{"query": "title insurance issues", "limit":5}'
  )
)['results'] as results;
```

### Sample Test Questions
1. "How many loans does Consolidated Analytics have by risk rating?"
2. "What is the average property value by property type and state?"
3. "Show me due diligence reviews with compliance scores below 85%"
4. "Search loan review notes for foundation or structural issues"

## Support

For questions or issues:
- Review `docs/AGENT_SETUP.md` for detailed setup instructions
- Check `docs/questions.md` for example questions
- Consult Snowflake documentation for syntax verification
- Contact your Snowflake account team for assistance

## Version History

- **v1.0** (October 2025): Initial release
  - Verified semantic view syntax from GoDaddy template
  - Verified Cortex Search syntax
  - 50K borrowers, 75K loans, 1M+ transactions
  - 50K loan review notes, 30K appraisal reports
  - 15 complex test questions (10 structured + 5 unstructured)
  - Comprehensive documentation

## License

This solution is provided as a template for building Snowflake Intelligence agents. Adapt as needed for your specific use case.

---

**Created**: October 2025  
**Template Based On**: GoDaddy Intelligence Demo (Verified Patterns)  
**Snowflake Documentation**: Syntax verified against official documentation  
**Target Use Case**: Consolidated Analytics mortgage and real estate finance intelligence

**NO GUESSING - ALL SYNTAX VERIFIED** ✅

