<img src="consolidated-analytics-intelligence-agent/
/Snowflake_Logo.svg" width="200">

# Consolidated Analytics Intelligence Agent Solution

## About Consolidated Analytics

Consolidated Analytics is a leading provider of mortgage and real estate finance services.

### Key Business Lines

- **Mortgage Due Diligence**: Pre-funding and post-closing loan file reviews, quality control
- **Real Estate Asset Management**: Property portfolio management, performance monitoring
- **Valuation Services**: Appraisals, BPOs, desktop valuations, AVM analysis
- **Consulting & Advisory**: Risk analysis, portfolio strategy, market analytics
- **Business Process Services**: Document management, compliance tracking, workflow automation

## Project Overview

This Snowflake Intelligence solution demonstrates how Consolidated Analytics can leverage AI agents to analyze:

- **Loan Portfolio Management**: Originations, risk ratings, performance tracking
- **Property Valuations**: Appraisal quality, market trends, valuation variance
- **Due Diligence Operations**: Review quality, compliance scores, exception management
- **Risk Analytics**: Credit risk, concentration analysis, delinquency prediction
- **Operational Efficiency**: Analyst productivity, process metrics, client satisfaction
- **Unstructured Data Search**: Semantic search over review notes, appraisal reports, compliance KB

## Database Schema

### RAW Schema: Core Business Tables

**Borrower & Client Data:**
- **BORROWERS**: Customer data with credit scores, income, employment (50,000 records)
- **SUPPORT_CASES**: Client support and inquiries (50,000 records)

**Property & Valuation Data:**
- **PROPERTIES**: Real estate assets with characteristics and values (60,000 records)
- **VALUATIONS**: Property appraisals with methodologies (80,000 records)

**Loan Portfolio Data:**
- **LOANS**: Mortgage loan portfolio with terms, rates, risk ratings (75,000 records)
- **TRANSACTIONS**: Financial transactions, payments, disbursements (1,000,000 records)

**Operations & Quality Data:**
- **DUE_DILIGENCE_REVIEWS**: Quality control and compliance reviews (100,000 records)
- **ANALYSTS**: Staff performance and specializations (200 records)
- **COMPLIANCE_DOCUMENTS**: Regulatory documentation (200,000 records)
- **PORTFOLIO_SEGMENTS**: Portfolio categorization (7 records)

**Unstructured Data Tables:**
- **LOAN_REVIEW_NOTES**: Review findings and exception narratives (50,000 notes)
- **APPRAISAL_REPORTS**: Property appraisal report narratives (30,000 reports)
- **COMPLIANCE_KNOWLEDGE_BASE**: Regulatory guidance (3 articles)

### ANALYTICS Schema: Semantic Models

**Semantic Views for AI Agents:**
1. **SV_BORROWER_LOAN_INTELLIGENCE**: Borrowers, loans, and transactions
2. **SV_PROPERTY_VALUATION_INTELLIGENCE**: Properties, valuations, and appraisers
3. **SV_DUE_DILIGENCE_INTELLIGENCE**: Reviews, cases, and operational metrics

**Analytical Views:**
- V_LOAN_PORTFOLIO, V_PROPERTY_VALUATIONS, V_DUE_DILIGENCE_METRICS
- V_PORTFOLIO_RISK, V_TRANSACTION_ANALYTICS, V_ANALYST_PERFORMANCE, V_CLIENT_360

### Cortex Search Services

- **LOAN_REVIEW_NOTES_SEARCH**: Search 50,000 due diligence review findings
- **APPRAISAL_REPORTS_SEARCH**: Search 30,000 property appraisal narratives
- **COMPLIANCE_KB_SEARCH**: Search regulatory compliance knowledge base

## Files

### SQL Scripts (Execute in Order)

1. `sql/setup/01_database_and_schema.sql` - Database and schema creation
2. `sql/setup/02_create_tables.sql` - Table definitions with constraints
3. `sql/data/03_generate_synthetic_data.sql` - Realistic sample data generation
4. `sql/views/04_create_views.sql` - Analytical views
5. `sql/views/05_create_semantic_views.sql` - Semantic views for AI agents
6. `sql/search/06_create_cortex_search.sql` - Unstructured data and Cortex Search

### Documentation

- `docs/AGENT_SETUP.md` - Step-by-step agent configuration guide
- `docs/questions.md` - 15 complex questions the agent can answer
- `README.md` - This file

## Setup Instructions

### Quick Start

```sql
-- Execute in order:
@sql/setup/01_database_and_schema.sql
@sql/setup/02_create_tables.sql
@sql/data/03_generate_synthetic_data.sql
@sql/views/04_create_views.sql
@sql/views/05_create_semantic_views.sql
@sql/search/06_create_cortex_search.sql
```

Then follow `docs/AGENT_SETUP.md` for agent configuration.

## Key Features

✅ **Verified Syntax**: All SQL verified against GoDaddy template  
✅ **Separate Semantic Views**: No column naming conflicts  
✅ **Hybrid Data**: Structured tables + unstructured text search  
✅ **Production-Ready**: 75K loans, 1M transactions, 50K review notes  
✅ **RAG-Enabled**: Agent retrieves context from unstructured data  

## Data Volumes

- Borrowers: 50,000
- Properties: 60,000
- Loans: 75,000
- Valuations: 80,000
- Due Diligence Reviews: 100,000
- Transactions: 1,000,000
- Support Cases: 50,000
- Loan Review Notes: 50,000 (unstructured)
- Appraisal Reports: 30,000 (unstructured)

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│           Snowflake Intelligence Agent                   │
│                                                          │
│  ┌────────────────────────────────────────────────────┐ │
│  │       Semantic Views (Structured Data)             │ │
│  │  • SV_BORROWER_LOAN_INTELLIGENCE                   │ │
│  │  • SV_PROPERTY_VALUATION_INTELLIGENCE              │ │
│  │  • SV_DUE_DILIGENCE_INTELLIGENCE                   │ │
│  └────────────────────────────────────────────────────┘ │
│                                                          │
│  ┌────────────────────────────────────────────────────┐ │
│  │       Cortex Search (Unstructured Data)            │ │
│  │  • LOAN_REVIEW_NOTES_SEARCH                        │ │
│  │  • APPRAISAL_REPORTS_SEARCH                        │ │
│  │  • COMPLIANCE_KB_SEARCH                            │ │
│  └────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

---

**Created**: October 2025  
**Template**: GoDaddy Intelligence Demo (Verified Patterns)  
**Business**: Consolidated Analytics Mortgage and Real Estate Finance

**NO GUESSING - ALL SYNTAX VERIFIED** ✅

