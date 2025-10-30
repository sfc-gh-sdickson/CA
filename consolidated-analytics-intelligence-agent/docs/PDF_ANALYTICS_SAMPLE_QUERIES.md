# PDF Analytics Sample Queries

**Natural language questions to ask your Snowflake Intelligence Agent after PDF Analytics integration**

---

## 📄 Document Processing Queries

### Basic Document Statistics

```
"How many PDF documents have been processed?"
```
Returns: Total count of unique documents in PDF_TEXT_DATA

```
"What is the average number of pages per property document?"
```
Returns: Mean page count across all documents

```
"Show me the most recently uploaded property documents"
```
Returns: Latest documents by UPLOAD_TIMESTAMP

```
"How many pages of text have been extracted in total?"
```
Returns: Total page count from PDF_TEXT_DATA

---

## 🖼️ Image Analysis Queries

### Solar Panel Detection

```
"How many properties have solar panels detected?"
```
Returns: Count of IMAGE_ANALYSIS_RESULTS where SOLAR_PANEL_DETECTED = true

```
"What is the average confidence score for solar panel detection?"
```
Returns: AVG(SOLAR_PANEL_CONFIDENCE) for detected solar panels

```
"Show me properties with solar panels detected with confidence > 0.9"
```
Returns: High-confidence solar panel detections

```
"What percentage of analyzed properties have solar panels?"
```
Returns: Percentage calculation of solar panel presence

### For-Sale Sign Detection

```
"How many properties have for-sale signs detected?"
```
Returns: Count where FOR_SALE_SIGN_DETECTED = true

```
"Show me properties with for-sale signs detected in the last 30 days"
```
Returns: Recent for-sale sign detections filtered by ANALYSIS_TIMESTAMP

```
"What is the average confidence for for-sale sign detection?"
```
Returns: AVG(FOR_SALE_SIGN_CONFIDENCE)

```
"Find properties with for-sale signs and high detection confidence"
```
Returns: Properties with FOR_SALE_SIGN_CONFIDENCE > threshold

### Human Presence Detection

```
"Which properties have human presence detected in their images?"
```
Returns: Properties where HUMAN_PRESENCE_DETECTED = true

```
"What percentage of property photos show human presence?"
```
Returns: Percentage of images with people detected

```
"Show me properties with people present and confidence > 0.85"
```
Returns: High-confidence human presence detections

---

## 🏚️ Property Damage & Condition Queries

### Damage Detection

```
"How many properties have potential damage detected?"
```
Returns: Count where POTENTIAL_DAMAGE_DETECTED = true

```
"Show me all properties with damage detected and confidence > 0.8"
```
Returns: High-confidence damage detections

```
"What is the average damage detection confidence score?"
```
Returns: AVG(POTENTIAL_DAMAGE_CONFIDENCE) for damaged properties

```
"List properties requiring inspection based on damage detection"
```
Returns: Properties with damage flags for follow-up

### Damage Description Search

```
"Search for properties with roof damage"
```
Uses: PROPERTY_DAMAGE_SEARCH Cortex Search service

```
"Find properties with water damage or staining"
```
Uses: PROPERTY_DAMAGE_SEARCH with semantic search

```
"Show properties with structural concerns"
```
Uses: PROPERTY_DAMAGE_SEARCH to find structural issues

```
"Find properties with foundation or wall cracks"
```
Uses: PROPERTY_DAMAGE_SEARCH semantic matching

---

## 🔍 Cortex Search Queries

### PDF Text Search

```
"Search all property documents for 'swimming pool and garage'"
```
Uses: PDF_TEXT_SEARCH to find specific amenities

```
"Find properties mentioning HOA fees"
```
Uses: PDF_TEXT_SEARCH to locate HOA references

```
"Search for properties with waterfront or lake view"
```
Uses: PDF_TEXT_SEARCH for location features

```
"Find documents mentioning square footage over 3000"
```
Uses: PDF_TEXT_SEARCH for size specifications

### Image Analysis Search

```
"Find properties with modern kitchen detected in images"
```
Uses: IMAGE_ANALYSIS_SEARCH for specific features

```
"Search for properties with landscaping or garden features"
```
Uses: IMAGE_ANALYSIS_SEARCH semantic matching

```
"Find properties with updated exteriors"
```
Uses: IMAGE_ANALYSIS_SEARCH for property condition

---

## 📊 Comparative & Analytical Queries

### Detection Rate Analysis

```
"What is the detection rate for each feature type (solar, damage, for-sale signs)?"
```
Returns: Percentage of images with each feature detected

```
"Compare average confidence scores across all detection types"
```
Returns: Confidence metrics for solar, damage, for-sale, human presence

```
"Show me the distribution of properties by detected features"
```
Returns: Breakdown of properties by feature combinations

### Document vs Image Analysis

```
"How many images are analyzed per property document on average?"
```
Returns: IMAGE_ANALYSIS_RESULTS count / PDF_TEXT_DATA count

```
"Which documents have the most images analyzed?"
```
Returns: Documents ranked by image count

```
"Show properties with text extracted but no images analyzed"
```
Returns: Documents in PDF_TEXT_DATA not in IMAGE_ANALYSIS_RESULTS

---

## 🎯 Combined Analytics (Multi-Source)

### Cross-Database Queries

These queries combine PDF Analytics with Core Analytics data:

```
"Compare property values for properties with solar panels vs. without"
```
Joins: IMAGE_ANALYSIS_RESULTS + CONSOLIDATED_ANALYTICS_DB.RAW.PROPERTIES

```
"Find properties with damage detected and appraisal values below market"
```
Joins: IMAGE_ANALYSIS_RESULTS + CONSOLIDATED_ANALYTICS_DB.RAW.VALUATIONS

```
"Show properties with for-sale signs but no active loans"
```
Joins: IMAGE_ANALYSIS_RESULTS + CONSOLIDATED_ANALYTICS_DB.RAW.LOANS

```
"Which states have the highest percentage of properties with solar panels?"
```
Joins: IMAGE_ANALYSIS_RESULTS + CONSOLIDATED_ANALYTICS_DB.RAW.PROPERTIES (by state)

```
"Compare damage detection rates across different property types"
```
Joins: IMAGE_ANALYSIS_RESULTS + CONSOLIDATED_ANALYTICS_DB.RAW.PROPERTIES (by type)

---

## 🔬 Advanced Analytical Queries

### Confidence Score Analysis

```
"What is the correlation between confidence scores and feature detection?"
```
Returns: Statistical analysis of confidence metrics

```
"Show properties where all detection types have confidence > 0.9"
```
Returns: High-confidence properties across all features

```
"Find properties with conflicting detection results (low confidence)"
```
Returns: Properties with confidence scores < threshold

### Time-Based Analysis

```
"How many documents were processed in the last 7 days?"
```
Filters by UPLOAD_TIMESTAMP

```
"Show trends in damage detection over the past month"
```
Time-series analysis of POTENTIAL_DAMAGE_DETECTED

```
"Which day had the most property images analyzed?"
```
Groups by ANALYSIS_TIMESTAMP date

### Property Risk Assessment

```
"Identify high-risk properties based on damage detection and condition"
```
Combines damage flags, confidence scores, and descriptions

```
"Show properties requiring immediate inspection"
```
Filters for critical damage indicators

```
"Find properties with multiple damage indicators"
```
Properties with damage + low confidence or multiple damage types

---

## 🏢 Business Intelligence Queries

### Portfolio Analysis

```
"What percentage of our property portfolio has been analyzed?"
```
Compares PDF_TEXT_DATA count to total properties

```
"How complete is our image analysis coverage?"
```
Percentage of documents with corresponding image analysis

```
"Show properties missing image analysis"
```
Documents without IMAGE_ANALYSIS_RESULTS records

### Quality Metrics

```
"What is the average AI model confidence across all analyses?"
```
Average of all confidence scores

```
"Show distribution of confidence scores by detection type"
```
Histogram/breakdown of confidence ranges

```
"Which AI model version is most frequently used?"
```
Groups by MODEL_NAME

---

## 💡 Example Use Cases by Role

### Property Inspector
```
"Find all properties with potential structural damage for inspection"
"Show me properties analyzed this week requiring follow-up"
"Which properties have damage descriptions mentioning water or moisture?"
```

### Real Estate Analyst
```
"Compare properties with solar panels: average values and market trends"
"Show properties with for-sale signs and their listing durations"
"Find properties with modern features (solar, updates) in specific zip codes"
```

### Risk Manager
```
"Identify high-risk properties based on damage detection confidence"
"Show properties with damage detected and no recent appraisal"
"What percentage of properties show damage indicators?"
```

### Portfolio Manager
```
"How many properties have been processed vs. remaining in queue?"
"Show completion rates for document and image analysis"
"Which properties need additional documentation or images?"
```

---

## 🧪 Testing Queries (After Initial Setup)

Run these to verify your setup is working correctly:

### Test 1: Basic Counts
```sql
SELECT COUNT(*) AS total_documents FROM PDF_TEXT_DATA;
SELECT COUNT(*) AS total_images FROM IMAGE_ANALYSIS_RESULTS;
```

### Test 2: Detection Verification
```sql
SELECT 
    SUM(CASE WHEN SOLAR_PANEL_DETECTED THEN 1 ELSE 0 END) AS solar_count,
    SUM(CASE WHEN FOR_SALE_SIGN_DETECTED THEN 1 ELSE 0 END) AS for_sale_count,
    SUM(CASE WHEN POTENTIAL_DAMAGE_DETECTED THEN 1 ELSE 0 END) AS damage_count
FROM IMAGE_ANALYSIS_RESULTS;
```

### Test 3: Confidence Scores
```sql
SELECT 
    AVG(SOLAR_PANEL_CONFIDENCE) AS avg_solar_conf,
    AVG(FOR_SALE_SIGN_CONFIDENCE) AS avg_for_sale_conf,
    AVG(POTENTIAL_DAMAGE_CONFIDENCE) AS avg_damage_conf
FROM IMAGE_ANALYSIS_RESULTS;
```

### Test 4: Cortex Search
```sql
-- Test PDF text search
SELECT * FROM TABLE(
  PDF_ANALYTICS_DB.PDF_PROCESSING.PDF_TEXT_SEARCH('property description')
) LIMIT 5;

-- Test image analysis search
SELECT * FROM TABLE(
  PDF_ANALYTICS_DB.PDF_PROCESSING.IMAGE_ANALYSIS_SEARCH('solar panels')
) LIMIT 5;

-- Test damage search
SELECT * FROM TABLE(
  PDF_ANALYTICS_DB.PDF_PROCESSING.PROPERTY_DAMAGE_SEARCH('roof damage')
) LIMIT 5;
```

---

## 📈 Performance Optimization Queries

### Index Usage
```
"Show which Cortex Search services are most frequently used"
"What is the average query response time for image analysis searches?"
```

### Data Quality
```
"How many records have null or empty text fields?"
"Show images with missing confidence scores"
"Find duplicate document entries"
```

---

## 🎓 Training Questions for Your Agent

Use these to test and train your agent's understanding:

1. "Explain what the PDF Analytics module does"
2. "What types of property features can be detected in images?"
3. "How do confidence scores work in image analysis?"
4. "What's the difference between PDF_TEXT_SEARCH and IMAGE_ANALYSIS_SEARCH?"
5. "When should I use PROPERTY_DAMAGE_SEARCH vs IMAGE_ANALYSIS_SEARCH?"

---

## 📝 Notes

- All queries assume data has been loaded into PDF_TEXT_DATA and IMAGE_ANALYSIS_RESULTS tables
- Cortex Search queries require the search services to be fully refreshed (based on TARGET_LAG)
- Cross-database queries require both CONSOLIDATED_ANALYTICS_DB and PDF_ANALYTICS_DB to be populated
- Confidence scores range from 0.0 (low) to 1.0 (high)
- Detection boolean flags (TRUE/FALSE) indicate presence/absence of features

---

**Last Updated**: October 30, 2025  
**Compatibility**: Snowflake Intelligence Agent with PDF Analytics Module

