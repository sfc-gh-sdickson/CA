# Consolidated Analytics Intelligence Agent - Complex Questions

These 15 complex questions demonstrate the intelligence agent's ability to analyze Consolidated Analytics' mortgage loan portfolio, property valuations, due diligence reviews, and operational metrics.

---

## Structured Data Questions (Semantic Views)

### 1. Loan Portfolio Risk Concentration Analysis

**Question:** "Analyze our loan portfolio by risk rating and loan type. Show total loan count, total outstanding balance, average LTV ratio, and percentage of portfolio for each risk rating. Which risk ratings have concentration above 30% of the portfolio?"

**Data Sources:** SV_BORROWER_LOAN_INTELLIGENCE

---

### 2. Geographic Loan Performance

**Question:** "Compare loan performance across states. Show total loan amounts, average interest rates, delinquency rates, and average credit scores by borrower state. Which states have the highest delinquency rates?"

**Data Sources:** SV_BORROWER_LOAN_INTELLIGENCE

---

### 3. Property Valuation Variance Analysis

**Question:** "Show properties with more than 10% valuation variance. Group by property type and market conditions. Which property states have the highest valuation variance?"

**Data Sources:** SV_PROPERTY_VALUATION_INTELLIGENCE

---

### 4. Due Diligence Quality Metrics

**Question:** "Analyze review quality by analyst department and review type. Show average compliance scores, exception counts, and critical findings rate. Which analysts have compliance scores below 85%?"

**Data Sources:** SV_DUE_DILIGENCE_INTELLIGENCE

---

### 5. Delinquency Risk Identification

**Question:** "Identify loans with LTV above 85%, credit scores below 640, and any delinquent payments. Calculate total exposure and prioritize by outstanding balance. How many loans are high-risk?"

**Data Sources:** SV_BORROWER_LOAN_INTELLIGENCE

---

### 6. Appraiser Performance Benchmarking

**Question:** "Compare appraiser performance by specialization. Show total valuations completed, average confidence levels, and review scores. Which appraisers exceed performance benchmarks?"

**Data Sources:** SV_PROPERTY_VALUATION_INTELLIGENCE

---

### 7. Loan Type Profitability Analysis

**Question:** "Calculate total interest paid by loan type. Show average interest rates, total principal paid, and transaction volumes. Which loan types generate the highest interest income?"

**Data Sources:** SV_BORROWER_LOAN_INTELLIGENCE

---

### 8. Property Market Trends by State

**Question:** "Analyze property values and market conditions by property state. Show average values, total properties, and distribution of market conditions. Which states show declining market conditions?"

**Data Sources:** SV_PROPERTY_VALUATION_INTELLIGENCE

---

### 9. Compliance Exception Patterns

**Question:** "Identify the most common compliance exceptions by review type. Show exception frequency, average severity, and resolution rates. Which review types have the highest exception rates?"

**Data Sources:** SV_DUE_DILIGENCE_INTELLIGENCE

---

### 10. Client Relationship Analysis

**Question:** "Segment borrowers by loan count and total financing. Show average credit scores, employment status distribution, and payment history by borrower type. Which borrower types have the best payment performance?"

**Data Sources:** SV_BORROWER_LOAN_INTELLIGENCE

---

## Unstructured Data Questions (Cortex Search)

### 11. Foundation Issues Search

**Question:** "Search loan review notes for cases where foundation issues were identified. What were the findings and how were they resolved?"

**Data Sources:** LOAN_REVIEW_NOTES_SEARCH

---

### 12. Commercial Property Appraisals

**Question:** "Find appraisal reports for commercial properties. What valuation methods were used and what were the typical cap rates?"

**Data Sources:** APPRAISAL_REPORTS_SEARCH

---

### 13. TRID Compliance Guidance

**Question:** "What does our compliance knowledge base say about TRID timing requirements and common violations?"

**Data Sources:** COMPLIANCE_KB_SEARCH

---

### 14. Title Insurance Exceptions

**Question:** "Search loan review notes for title insurance exceptions. What were the common issues and resolution procedures?"

**Data Sources:** LOAN_REVIEW_NOTES_SEARCH

---

### 15. Appraisal Challenges

**Question:** "Find appraisal reports mentioning challenges with comparables or market conditions. What alternative methods were used?"

**Data Sources:** APPRAISAL_REPORTS_SEARCH

---

**Version:** 1.0  
**Created:** October 2025  
**Business:** Mortgage and Real Estate Finance

