# PDF Analytics Quick Start Guide

**⚡ Fast setup for adding Real Estate Property Intelligence to your Snowflake Intelligence Agent**

---

## Prerequisites ✅

- [ ] Existing Snowflake account with Cortex enabled
- [ ] Warehouse created (e.g., `CA_ANALYTICS_WH`)
- [ ] ACCOUNTADMIN or sufficient permissions
- [ ] `sql/setup/setup.sql` executed (creates `PDF_ANALYTICS_DB`)

---

## Quick Setup (5 Minutes)

### Step 1: Edit Warehouse References

**File 1**: `sql/views/07_create_pdf_analytics_semantic_view.sql`
```sql
-- Line 18: Replace with your warehouse
USE WAREHOUSE CA_ANALYTICS_WH;
```

**File 2**: `sql/search/08_create_pdf_analytics_cortex_search.sql`
```sql
-- Lines 24, 48, 77: Replace <YOUR_WAREHOUSE> with your warehouse
WAREHOUSE = CA_ANALYTICS_WH
```

### Step 2: Execute SQL Scripts

```bash
# 1. Create Semantic View (5 seconds)
snowsql -f sql/views/07_create_pdf_analytics_semantic_view.sql

# 2. Create Cortex Search Services (1-3 minutes)
snowsql -f sql/search/08_create_pdf_analytics_cortex_search.sql
```

### Step 3: Add to Snowflake Intelligence Agent

**In Snowsight UI:**

1. **Add Semantic View**:
   - Navigate to: AI & ML → Agents → Your Agent → Settings → Data Sources
   - Add: `PDF_ANALYTICS_DB.PDF_PROCESSING.SV_PROPERTY_PDF_INTELLIGENCE`

2. **Add 3 Cortex Search Services** (Tools section):
   
   | Service Name | Fully Qualified Name |
   |-------------|---------------------|
   | Property Document Text Search | `PDF_ANALYTICS_DB.PDF_PROCESSING.PDF_TEXT_SEARCH` |
   | Property Image Analysis Search | `PDF_ANALYTICS_DB.PDF_PROCESSING.IMAGE_ANALYSIS_SEARCH` |
   | Property Damage Search | `PDF_ANALYTICS_DB.PDF_PROCESSING.PROPERTY_DAMAGE_SEARCH` |

3. **Update Agent Instructions** (append):
```
Real Estate Property Intelligence:
- Analyze property PDFs, text extraction, and image analysis
- Detect features: solar panels, for-sale signs, damage, occupancy
- Search documents and images for specific property characteristics
- Assess property risk based on AI damage detection
```

---

## Test Queries

After loading data, test with:

```
"How many properties have solar panels detected?"
"Search for properties with roof damage"
"Show properties with for-sale signs in the last 30 days"
"What's the average confidence score for damage detection?"
```

---

## What You Get

✅ **Semantic View**: Structured queries over PDF text and AI image analysis  
✅ **3 Cortex Search Services**: Semantic search over documents, images, and damage  
✅ **Natural Language Queries**: Ask questions about property documents and images  
✅ **AI-Powered Insights**: Solar panels, damage, for-sale signs, and more  

---

## Files Created

| File | Purpose |
|------|---------|
| `sql/views/07_create_pdf_analytics_semantic_view.sql` | Semantic view for structured queries |
| `sql/search/08_create_pdf_analytics_cortex_search.sql` | 3 Cortex Search services |
| `docs/PDF_ANALYTICS_INTEGRATION.md` | Complete integration guide |
| `docs/PDF_ANALYTICS_QUICK_START.md` | This quick start guide |

---

## Need More Details?

📖 See full guide: `docs/PDF_ANALYTICS_INTEGRATION.md`

---

**Setup Time**: 5 minutes  
**Difficulty**: Easy  
**Prerequisites**: Basic Snowflake knowledge

