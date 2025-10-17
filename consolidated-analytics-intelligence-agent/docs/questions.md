# Consolidated Analytics Intelligence Agent - Complex Questions

These 15 complex questions demonstrate the intelligence agent's ability to analyze Consolidated Analytics' mortgage loan portfolio, property valuations, due diligence reviews, and operational metrics across multiple dimensions.

---

## Structured Data Questions (Semantic Views)

### 1. Loan Portfolio Risk Concentration Analysis

**Question:** "Analyze our loan portfolio by risk rating and property type. Show total loan count, total outstanding balance, average LTV ratio, and percentage of portfolio for each risk rating. Which risk ratings have concentration above 30% of the portfolio? Identify any geographic concentrations by state."

**Why Complex:**
- Multi-dimensional segmentation (risk rating × property type × geography)
- Portfolio concentration analysis
- Percentage calculations and thresholds
- Risk assessment across multiple factors
- Actionable identification of concentration risk

**Data Sources:** LOANS, BORROWERS, PROPERTIES (via SV_LOAN_PORTFOLIO_INTELLIGENCE)

**Expected Insights:**
- Risk rating distribution
- Geographic concentration risks
- Property type exposure
- LTV ratios by segment

---

### 2. Valuation Variance Analysis

**Question:** "Compare property valuations over time. Show properties with more than 10% valuation variance between current value and most recent appraisal. Group by property type and market conditions. What percentage of properties show declining valuations? Which appraisers have the highest variance rates?"

**Why Complex:**
- Temporal comparison analysis
- Variance calculation and threshold filtering
- Multi-dimensional grouping
- Trend identification (declining values)
- Quality analysis by appraiser

**Data Sources:** PROPERTIES, VALUATIONS, ANALYSTS (via SV_VALUATION_RISK_INTELLIGENCE)

**Expected Insights:**
- Properties with significant value changes
- Market condition impacts
- Appraiser accuracy metrics
- Geographic value trends

---

### 3. Due Diligence Quality Metrics

**Question:** "Analyze review quality by analyst and review type. Show average compliance scores, exception counts, critical findings rate, and average days to complete. Which analysts have compliance scores below 85%? What are the most common exception types, and which review types have the highest exception rates?"

**Why Complex:**
- Analyst-level performance metrics
- Quality scoring and benchmarking
- Exception rate calculations
- Time efficiency analysis
- Identification of training needs

**Data Sources:** DUE_DILIGENCE_REVIEWS, LOANS, ANALYSTS (via SV_DUE_DILIGENCE_INTELLIGENCE)

**Expected Insights:**
- Analyst performance rankings
- Quality control effectiveness
- Exception patterns
- Process improvement opportunities

---

### 4. Delinquency Trend Prediction

**Question:** "Identify loans at risk of delinquency based on: payment history, LTV ratio above 85%, credit score below 640, and DTI ratio above 43%. Calculate a composite risk score for each at-risk loan and prioritize by outstanding balance. How many loans fall into high-risk category, and what is the total exposure?"

**Why Complex:**
- Multi-factor risk assessment
- Composite scoring methodology
- Threshold-based filtering across multiple criteria
- Financial exposure calculation
- Risk prioritization for action

**Data Sources:** LOANS, BORROWERS, TRANSACTIONS (via SV_LOAN_PORTFOLIO_INTELLIGENCE)

**Expected Insights:**
- At-risk loan identification
- Total exposure amount
- Early warning indicators
- Proactive workout candidates

---

### 5. Geographic Market Performance

**Question:** "Compare property values and loan performance across states. Show average property values, median loan amounts, average LTV ratios, delinquency rates, and average credit scores by state. Which states have delinquency rates above 5%? Rank states by portfolio size and identify concentration risks."

**Why Complex:**
- Geographic aggregation and comparison
- Multiple performance metrics per geography
- Delinquency rate calculations
- Portfolio concentration analysis
- Risk-adjusted ranking

**Data Sources:** PROPERTIES, LOANS, BORROWERS, TRANSACTIONS (via SV_LOAN_PORTFOLIO_INTELLIGENCE)

**Expected Insights:**
- Geographic performance variations
- Market condition differences
- Concentration risk by geography
- Target markets for expansion

---

### 6. Appraisal Turnaround Efficiency

**Question:** "Analyze appraisal completion times by property type and appraiser specialization. Show average days from order to completion, volume of appraisals per appraiser, average confidence levels, and percentage meeting SLA (< 10 days). Which appraisers are underperforming, and which property types take longest to appraise?"

**Why Complex:**
- Turnaround time analysis
- SLA compliance measurement
- Volume and quality metrics
- Bottleneck identification
- Specialization impact assessment

**Data Sources:** VALUATIONS, PROPERTIES, ANALYSTS (via SV_VALUATION_RISK_INTELLIGENCE)

**Expected Insights:**
- Appraiser productivity rankings
- Property-specific challenges
- Process efficiency opportunities
- Capacity planning needs

---

### 7. Compliance Exception Analysis

**Question:** "Identify the most common compliance exceptions by loan type and review type. Show exception frequency, average severity levels, resolution rates, and impact on loan approval timing. Which exception types require the most time to resolve? Calculate the percentage of loans with critical findings by loan type."

**Why Complex:**
- Exception pattern analysis
- Frequency and severity calculations
- Resolution rate tracking
- Time impact measurement
- Risk stratification by loan type

**Data Sources:** DUE_DILIGENCE_REVIEWS, LOANS, LOAN_REVIEW_NOTES (via SV_DUE_DILIGENCE_INTELLIGENCE)

**Expected Insights:**
- Common compliance issues
- Process improvement targets
- Training needs identification
- Regulatory risk exposure

---

### 8. Portfolio Profitability Analysis

**Question:** "Calculate profitability by loan type including interest income, servicing fees, and projected lifetime value. Factor in cost of funds, operating expenses, and estimated default losses by risk rating. Show net margin percentage by loan type and identify which loan types generate highest returns. What is the profitability trend over the past 12 months?"

**Why Complex:**
- Multi-component revenue calculations
- Cost allocation and expense modeling
- Risk-adjusted return analysis
- Trend analysis over time
- Product profitability ranking

**Data Sources:** LOANS, TRANSACTIONS, BORROWERS (via SV_LOAN_PORTFOLIO_INTELLIGENCE)

**Expected Insights:**
- Product profitability rankings
- Price/yield optimization opportunities
- Resource allocation decisions
- Strategic product focus

---

### 9. Client Relationship Analysis

**Question:** "Segment borrowers by total loan count, total financing amount, payment history (delinquency status), and support case volume. Calculate lifetime value for each segment. Identify high-value clients with multiple loans and excellent payment history. Which clients are at risk (high support cases + delinquent payments)?"

**Why Complex:**
- Customer segmentation analysis
- Lifetime value calculations
- Multi-factor scoring
- Relationship depth metrics
- At-risk client identification

**Data Sources:** BORROWERS, LOANS, TRANSACTIONS, SUPPORT_CASES (via SV_LOAN_PORTFOLIO_INTELLIGENCE, SV_DUE_DILIGENCE_INTELLIGENCE)

**Expected Insights:**
- Customer segmentation
- Relationship value quantification
- Retention risk identification
- Cross-sell opportunities

---

### 10. Analyst Productivity Benchmarking

**Question:** "Compare analyst performance across specializations (underwriting, appraisal, QC review, compliance). Show reviews per day, average quality scores, exception rates per review, average case resolution times, and customer satisfaction ratings. Which analysts exceed performance benchmarks? Identify analysts requiring additional training based on quality metrics."

**Why Complex:**
- Cross-functional performance comparison
- Multiple productivity metrics
- Quality vs. quantity trade-offs
- Benchmark establishment
- Training needs assessment

**Data Sources:** ANALYSTS, DUE_DILIGENCE_REVIEWS, SUPPORT_CASES (via SV_DUE_DILIGENCE_INTELLIGENCE)

**Expected Insights:**
- Performance benchmarks by role
- Top performer identification
- Training and development needs
- Resource allocation optimization

---

## Unstructured Data Questions (Cortex Search)

### 11. Property Foundation Issues Search

**Question:** "Search loan review notes for cases where foundation issues were identified during due diligence. What were the findings, how severe were the issues, and how were they resolved? Find similar appraisal reports that mention foundation concerns."

**Why Complex:**
- Semantic search across review notes
- Pattern identification in findings
- Resolution procedure extraction
- Cross-reference between reviews and appraisals

**Data Sources:** LOAN_REVIEW_NOTES_SEARCH, APPRAISAL_REPORTS_SEARCH

**Expected Insights:**
- Common foundation issues
- Resolution strategies
- Cost implications
- Risk mitigation approaches

---

### 12. Flood Zone and Water Damage Reports

**Question:** "Find appraisal reports that mention flood zones, flood insurance requirements, or water damage. What property types are most commonly affected? What were the appraiser recommendations? Search review notes for related compliance issues."

**Why Complex:**
- Semantic search for related concepts
- Property type pattern analysis
- Recommendation extraction
- Compliance cross-check

**Data Sources:** APPRAISAL_REPORTS_SEARCH, LOAN_REVIEW_NOTES_SEARCH

**Expected Insights:**
- Flood risk exposure
- Insurance requirement patterns
- Geographic flood concentrations
- Compliance considerations

---

### 13. TRID Regulatory Compliance

**Question:** "What does our compliance knowledge base say about TRID (TILA-RESPA Integrated Disclosure) requirements? Search for timing rules, common violations, and best practices. Find any loan reviews that identified TRID violations and how they were corrected."

**Why Complex:**
- Regulatory guidance retrieval
- Best practice extraction
- Violation case identification
- Corrective action procedures

**Data Sources:** COMPLIANCE_KB_SEARCH, LOAN_REVIEW_NOTES_SEARCH

**Expected Insights:**
- TRID requirements summary
- Common violation patterns
- Remediation procedures
- Staff training needs

---

### 14. Title Insurance Exceptions

**Question:** "Search loan review notes for cases involving title insurance exceptions. What were the most common title issues found? How long did title issues typically delay closings? What procedures were used to clear title problems?"

**Why Complex:**
- Issue pattern identification
- Time impact quantification
- Resolution procedure extraction
- Process optimization insights

**Data Sources:** LOAN_REVIEW_NOTES_SEARCH

**Expected Insights:**
- Common title defects
- Resolution timelines
- Process improvements
- Vendor performance

---

### 15. Difficult Comparable Sales Appraisals

**Question:** "Find appraisal reports where appraisers noted challenges finding comparable sales. What property types or locations had the most difficulty? What alternative valuation methods were used? Were there any resulting valuation disputes in review notes?"

**Why Complex:**
- Challenge pattern identification
- Geographic/property analysis
- Methodology extraction
- Dispute correlation

**Data Sources:** APPRAISAL_REPORTS_SEARCH, LOAN_REVIEW_NOTES_SEARCH

**Expected Insights:**
- Difficult-to-value properties
- Geographic challenges
- Methodology alternatives
- Quality control focus areas

---

## Question Complexity Summary

These questions test the agent's ability to:

1. **Multi-table joins** - connecting loans, borrowers, properties, valuations, reviews
2. **Temporal analysis** - time-based patterns, trends, aging analysis
3. **Segmentation & classification** - risk ratings, loan types, property types
4. **Derived metrics** - rates, percentages, ratios, scores
5. **Aggregation at multiple levels** - loan-level, borrower-level, portfolio-level
6. **Threshold-based filtering** - LTV > 85%, scores < 640, etc.
7. **Risk assessment** - composite scoring, concentration analysis
8. **Pattern recognition** - exception patterns, performance trends
9. **Comparative analysis** - benchmarking, rankings, peer comparison
10. **Financial calculations** - profitability, exposure, lifetime value
11. **Semantic search** - understanding intent in unstructured text
12. **Information synthesis** - combining structured and unstructured insights

These questions reflect realistic business intelligence needs for mortgage and real estate finance operations including risk management, quality control, regulatory compliance, and operational efficiency.

---

**Version:** 1.0  
**Created:** October 2025  
**Business:** Mortgage and Real Estate Finance

