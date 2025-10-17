-- ============================================================================
-- Consolidated Analytics Intelligence Agent - Cortex Search Service Setup
-- ============================================================================
-- Purpose: Create unstructured data tables and Cortex Search services for
--          loan review notes, appraisal reports, and compliance knowledge base
-- Syntax verified against GoDaddy template (lines 581-646)
-- ============================================================================

USE DATABASE CONSOLIDATED_ANALYTICS_DB;
USE SCHEMA RAW;
USE WAREHOUSE CA_ANALYTICS_WH;

-- ============================================================================
-- Step 1: Create table for loan review notes (unstructured text data)
-- ============================================================================
CREATE OR REPLACE TABLE LOAN_REVIEW_NOTES (
    note_id VARCHAR(30) PRIMARY KEY,
    review_id VARCHAR(30),
    loan_id VARCHAR(30),
    note_text VARCHAR(16777216) NOT NULL,
    note_type VARCHAR(50),
    severity VARCHAR(20),
    issue_resolved BOOLEAN DEFAULT FALSE,
    created_by VARCHAR(100),
    created_date TIMESTAMP_NTZ NOT NULL,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (review_id) REFERENCES DUE_DILIGENCE_REVIEWS(review_id),
    FOREIGN KEY (loan_id) REFERENCES LOANS(loan_id)
);

-- ============================================================================
-- Step 2: Create table for appraisal reports
-- ============================================================================
CREATE OR REPLACE TABLE APPRAISAL_REPORTS (
    report_id VARCHAR(30) PRIMARY KEY,
    valuation_id VARCHAR(30),
    property_id VARCHAR(30),
    report_text VARCHAR(16777216) NOT NULL,
    appraiser_id VARCHAR(20),
    report_date TIMESTAMP_NTZ NOT NULL,
    report_status VARCHAR(30),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (valuation_id) REFERENCES VALUATIONS(valuation_id),
    FOREIGN KEY (property_id) REFERENCES PROPERTIES(property_id),
    FOREIGN KEY (appraiser_id) REFERENCES ANALYSTS(analyst_id)
);

-- ============================================================================
-- Step 3: Create table for compliance knowledge base articles
-- ============================================================================
CREATE OR REPLACE TABLE COMPLIANCE_KNOWLEDGE_BASE (
    article_id VARCHAR(30) PRIMARY KEY,
    title VARCHAR(500) NOT NULL,
    content VARCHAR(16777216) NOT NULL,
    article_category VARCHAR(50),
    regulation_type VARCHAR(50),
    last_updated TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    view_count NUMBER(10,0) DEFAULT 0,
    helpfulness_score NUMBER(3,2),
    is_published BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- Step 4: Enable change tracking (required for Cortex Search)
-- ============================================================================
ALTER TABLE LOAN_REVIEW_NOTES SET CHANGE_TRACKING = TRUE;
ALTER TABLE APPRAISAL_REPORTS SET CHANGE_TRACKING = TRUE;
ALTER TABLE COMPLIANCE_KNOWLEDGE_BASE SET CHANGE_TRACKING = TRUE;

-- ============================================================================
-- Step 5: Generate sample loan review notes
-- ============================================================================
INSERT INTO LOAN_REVIEW_NOTES
SELECT
    'NOTE' || LPAD(SEQ4(), 10, '0') AS note_id,
    r.review_id,
    r.loan_id,
    CASE (ABS(RANDOM()) % 10)
        WHEN 0 THEN 'Pre-funding review completed for conventional loan. Borrower credit score of 745 meets guidelines. DTI ratio at 38% is acceptable. Property appraisal came in at contract price. All income documentation verified including W2s and paystubs. Employment verified with VOE. Title search shows no liens or encumbrances. Loan approved for funding with standard conditions.'
        WHEN 1 THEN 'Post-closing quality control review identified minor documentation deficiency. Missing signed copy of final HUD-1 settlement statement. Loan file otherwise complete. Contacted closing agent to obtain executed copy. Low severity finding, does not impact loan validity. File to be updated within 5 business days. No monetary impact.'
        WHEN 2 THEN 'Compliance audit found TRID timing violation. Initial Loan Estimate provided to borrower 8 days before closing, should have been 10 days minimum under CFPB regulations. Critical finding requiring corrective action. Management notified. Additional staff training on TRID requirements recommended. Potential regulatory exposure. Legal review requested.'
        WHEN 3 THEN 'FHA loan file review shows property appraisal concerns. Appraiser noted foundation cracks and roof damage requiring repairs estimated at $15,000. FHA 203(k) rehabilitation mortgage may be appropriate. Alternative: borrower to complete repairs before closing with re-inspection required. Underwriter recommends 203(k) option to streamline process.'
        WHEN 4 THEN 'Income calculation discrepancy identified during review. Underwriter used gross income instead of net for self-employed borrower. Corrected DTI ratio is 47%, exceeds maximum 43% threshold for conventional loan. Loan does not meet approval guidelines. Recommend denial or request additional compensating factors. Significant finding requiring immediate action.'
        WHEN 5 THEN 'Title insurance exception found in review. Property has undisclosed HOA lien of $3,200 for unpaid assessments. Lien must be satisfied before closing. Title company working with seller to pay off lien from sale proceeds. Closing delayed 7-10 days. Impact: minimal, standard title clearing issue. Borrower notified of delay.'
        WHEN 6 THEN 'VA loan entitlement verification shows borrower has remaining entitlement of $453,000, sufficient for requested loan amount of $425,000. No second tier entitlement needed. Certificate of Eligibility valid. Property meets VA minimum property requirements per appraisal. Termite inspection clear. Well and septic inspections passed. Loan meets all VA guidelines.'
        WHEN 7 THEN 'Jumbo loan portfolio review shows strong credit quality. Average FICO 785, average LTV 68%, no delinquencies. Property types: 80% single family residence, 15% condos, 5% multi-family. Geographic concentration in California at 40% of portfolio. Recommend geographic diversification. Overall risk rating: Low. Portfolio performance excellent.'
        WHEN 8 THEN 'Anti-steering compliance review completed. Loan originator provided required three loan options to borrower with varying rates and points. Documentation in file demonstrates compliance with anti-steering safe harbor provisions. Borrower selected mid-range option. No violations identified. File demonstrates good compliance practices.'
        WHEN 9 THEN 'Appraisal review reveals significant variance from AVMs. Property appraised at $425,000, but three different AVMs show range of $380,000-$395,000. Variance of 10% triggers secondary review. Ordered desk review by independent appraiser. May require full second appraisal. Loan approval on hold pending review resolution.'
        WHEN 10 THEN 'Credit report analysis shows recent inquiries and new trade lines. Borrower opened new auto loan 30 days before closing, increasing DTI from 41% to 46%. Exceeds maximum DTI threshold. Loan no longer meets approval guidelines. Options: pay off auto loan before closing, or request manual underwrite with compensating factors. High severity issue requiring immediate borrower communication.'
        WHEN 11 THEN 'Employment verification returned showing borrower left job 2 weeks ago. New employment started but is outside 2-year industry requirement for self-employed income. Undermines loan approval. Loan must be denied or delayed until 2-year employment history established. Critical finding. Immediate action required to notify borrower and withdraw commitment.'
        WHEN 12 THEN 'Property insurance review shows coverage amount of $350,000 insufficient for replacement cost of $425,000. Lender requires insurance coverage equal to lesser of loan amount or replacement cost. Borrower must increase coverage to minimum $400,000. Easy resolution, low severity. Closing can proceed once updated declarations page received.'
        WHEN 13 THEN 'Escrow account analysis shows shortage of $1,200 due to increased property tax assessment. Borrower options: pay shortage in lump sum, or increase monthly payment by $100. Borrower elected to increase monthly payment. Updated RESPA escrow disclosure provided. Complies with escrow regulations. Minor issue, resolved satisfactorily.'
        WHEN 14 THEN 'Quality control sampling review of 25 loans from Q4. Findings: 23 loans (92%) had no defects, 2 loans (8%) had minor documentation issues. Both defects corrected within 30 days. No material findings, no credit or collateral defects. Excellent quality metrics. Underwriting team performance exceeds industry benchmarks. No corrective actions needed.'
        WHEN 15 THEN 'Commercial loan review for $2.5M acquisition. Property cash flow analysis shows DSCR of 1.45, exceeds minimum 1.25 requirement. Environmental Phase I report clear, no concerns. Zoning confirmed for intended use. Tenant roll shows 92% occupancy with average 4-year remaining lease terms. Strong deal, low risk. Approved with standard commercial terms.'
        WHEN 16 THEN 'Subordination agreement issue identified. Borrower has HELOC on property requiring subordination for refinance. HELOC lender refusing to subordinate, demanding payoff instead. HELOC balance $85,000. Options: pay off HELOC from refinance proceeds, or find alternative lender willing to accept 2nd position. Significant delay likely. Borrower considering options.'
        WHEN 17 THEN 'Gift funds documentation review shows $50,000 gift from parents properly documented. Gift letter signed by donors stating funds are gift, not loan, and no repayment expected. Donors bank statements show sufficient funds and transfer. Paper trail complete. Meets FHA gift fund requirements. Acceptable per guidelines.'
        WHEN 18 THEN 'Self-employed income analysis for 2-year average shows declining income trend. Year 1: $125,000, Year 2: $98,000. 22% decline raises concerns about income stability. Underwriting guidelines require stable or increasing income trend. Recommended denial unless borrower can provide written explanation and evidence trend has reversed. Significant finding requiring senior underwriter review.'
        WHEN 19 THEN 'Condo project review shows HOA has insufficient reserves, only 18% funded. Fannie Mae requires minimum 10% reserves, so project meets minimum but is concerning. Also noted: 22% investor-owned units, approaching 25% maximum for conventional financing. Project is marginally acceptable. Monitor for future guideline compliance issues.'
        WHEN 20 THEN 'Loan modification review completed. Borrower 4 months delinquent due to job loss. New employment secured at 85% of previous income. Modified loan extends term from 15 to 20 years remaining, reduces payment by $340/month. New DTI at 39%, acceptable. Trial payment plan: 3 months at new payment amount before permanent modification. Workout option approved.'
        WHEN 21 THEN 'Wire fraud prevention review: All wire instructions verified via phone call to known closing agent number from independent source. Confirmed account number, routing number, and wire amount. Security procedures followed properly. No red flags identified. Wire sent securely. Strong fraud prevention protocols observed. Excellent practices demonstrated.'
        WHEN 22 THEN 'HOA estoppel certificate review shows special assessment pending for $8,500 per unit for building exterior renovation. Assessment not yet levied but anticipated within 60 days. Significantly impacts affordability. Borrower DTI increases to 44% when assessment payment included. Loan approval contingent on borrower demonstrating ability to afford assessment. Requires additional documentation.'
        WHEN 23 THEN 'PMI approval received from mortgage insurer for 95% LTV loan. Borrower credit score 710 meets minimum 680 requirement. Debt-to-income ratio 40% acceptable. Property appraisal shows stable neighborhood values. PMI rate: 0.85% annually. Loan meets all insurer guidelines. Approved as submitted. No additional conditions.'
        WHEN 24 THEN 'Final walkthrough inspection revealed undisclosed property damage. Borrower discovered broken HVAC system and water damage in basement not present at initial inspection. Estimate for repairs: $12,000. Requesting seller credit or price reduction. Appraisal may need revision if repairs affect property value. Closing on hold pending resolution of inspection issues. Contract addendum required.'
    END AS note_text,
    ARRAY_CONSTRUCT('PRE_FUNDING', 'POST_CLOSING', 'COMPLIANCE', 'QUALITY_CONTROL', 'EXCEPTION')[UNIFORM(0, 4, RANDOM())] AS note_type,
    ARRAY_CONSTRUCT('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')[UNIFORM(0, 3, RANDOM())] AS severity,
    UNIFORM(0, 100, RANDOM()) < 80 AS issue_resolved,
    'Reviewer ' || UNIFORM(1, 50, RANDOM())::VARCHAR AS created_by,
    r.review_date AS created_date,
    r.review_date AS created_at
FROM RAW.DUE_DILIGENCE_REVIEWS r
WHERE r.review_id IS NOT NULL
LIMIT 50000;

-- ============================================================================
-- Step 6: Generate sample appraisal reports (shortened for brevity)
-- ============================================================================
INSERT INTO APPRAISAL_REPORTS
SELECT
    'RPT' || LPAD(SEQ4(), 10, '0') AS report_id,
    v.valuation_id,
    v.property_id,
    CASE (ABS(RANDOM()) % 10)
        WHEN 0 THEN 'PROPERTY APPRAISAL REPORT - Subject property is a single-family residence. PROPERTY DESCRIPTION: 2,450 square feet, 4 bedrooms, 2.5 bathrooms, built 1998. Two-story colonial with brick and vinyl siding. Two-car garage. 0.42 acre lot. CONDITION: Good overall. Roof 8 years old, 12-15 years remaining. HVAC replaced 5 years ago. Kitchen updated with granite counters. NEIGHBORHOOD: Well-maintained residential with good schools access. Market stable. COMPARABLE SALES: Three comps within 0.5 miles. Comp 1: 2,520 sf, $412,000. Comp 2: 2,380 sf, $395,000. Comp 3: 2,510 sf, $425,000. FINAL VALUE: $405,000 as of valuation date.'
        WHEN 1 THEN 'COMMERCIAL PROPERTY APPRAISAL - Retail shopping center, 45,000 sf gross leasable area. Built 2005, well-maintained. TENANT INFO: Anchored by grocery tenant, 8 years remaining lease. Six retail tenants, 3-5 year leases. 94% occupied. INCOME ANALYSIS: Gross potential income $1,125,000. Vacancy 5% ($56,250). Effective gross income $1,068,750. Operating expenses $425,000. Net operating income $643,750. VALUATION: 7.25% cap rate. Indicated value $8,880,000. FINAL VALUE: $8,900,000.'
        WHEN 2 THEN 'CONDO APPRAISAL - 2-bed, 2-bath condo, 1,180 sf, unit 304. Built 2012, excellent condition. Builder finishes with recent flooring and paint. Granite counters, stainless appliances. HOA: $385/month, 85% reserves, no special assessments. COMPARABLES: Four sales in complex. Comp 1: 1,200 sf, $275,000. Comp 2: 1,150 sf, $265,000. Comp 3: 1,190 sf, $280,000. Comp 4: 1,175 sf, $272,000. VALUE: $270,000.'
        WHEN 3 THEN 'RURAL PROPERTY - Home on 5.25 acres. 1,850 sf ranch built 1985. Detached garage, pole barn. PUBLIC UTILITIES: County road, gravel drive, public water, septic. CONDITION: Deferred maintenance noted. Roof 3-5 years remaining. HVAC 20+ years old. Recommend $30,000-$40,000 for updates. COMPARABLES: Three rural sales. Comp 1: 1,950 sf on 4.5 acres, $245,000. Comp 2: 1,720 sf on 6 acres, $228,000. Comp 3: 1,900 sf on 3.8 acres, $252,000. AS-IS VALUE: $235,000.'
        WHEN 4 THEN 'DESKTOP APPRAISAL (Exterior only) - 1,675 sf home, 3 bed, 2 bath, built 1992. Exterior appears well-maintained. LIMITATION: Interior not inspected. Condition unknown. For low-risk refinance only. COMPARABLES: Comp 1: 1,720 sf, $312,000. Comp 2: 1,650 sf, $305,000. Comp 3: 1,690 sf, $318,000. OPINION: $310,000. Confidence Medium due to no interior inspection.'
        WHEN 5 THEN 'MULTI-FAMILY APPRAISAL - 12-unit apartment, 2-story, built 1978. Each unit 850 sf, 2-bed/1-bath. CONDITION: Average to Fair. Roof replaced 6 years ago. HVAC mix, 8 units need replacement. INCOME: Rents $1,250/unit/month. Gross $180,000. Vacancy 7%. Effective income $167,400. Expenses $79,470. NOI $87,930. CAP RATE: 8.25%. VALUE: $1,060,000.'
        WHEN 6 THEN 'LUXURY HOME - 5,200 sf executive residence, 5 bed, 4.5 bath, 3-car garage. Built 2015, custom. FEATURES: Gourmet kitchen, theater, wine cellar, office, pool, spa. Golf course lot. QUALITY: Superior with high-end finishes throughout. Smart home technology. MARKET: High-end segment, 90-180 day marketing. COMPARABLES: Comp 1: 5,400 sf, $1,285,000. Comp 2: 4,950 sf, $1,195,000. Comp 3: 5,350 sf, $1,325,000. VALUE: $1,250,000.'
        WHEN 7 THEN 'MANUFACTURED HOME - 2005 model, 1,540 sf, 3-bed, 2-bath. Permanently affixed to foundation on 0.75 acre owned land. Title converted to real property. CONDITION: Good. Roof 5 years old. HUD-code compliant. COMPARABLES: Comp 1: 2008 model, 1,620 sf, $168,000. Comp 2: 2003 model, 1,480 sf, $152,000. Comp 3: 2007 model, 1,550 sf, $162,000. VALUE: $158,000. FHA/conventional eligible.'
        WHEN 8 THEN 'NEW CONSTRUCTION - Under construction, 70% complete, 60 days to completion. 2,850 sf two-story, 4 bed, 3.5 bath. COST APPROACH: Land $85,000, construction cost $285,000, site $12,000. Total $382,000. SALES COMPARISON: Three builder sales. Comp 1: 2,920 sf, $395,000. Comp 2: 2,780 sf, $385,000. Comp 3: 2,900 sf, $398,000. AS-COMPLETE VALUE: $390,000. Subject to completion per plans.'
        WHEN 9 THEN 'FORECLOSURE/REO - Bank-owned, vacant 8 months. CONDITION: Fair to Poor. Water damage, HVAC inoperative, appliances missing, carpet soiled. REPAIRS NEEDED: $45,000 (HVAC $8,500, water remediation $6,500, flooring $8,000, etc). AS-IS VALUE: $235,000. AS-REPAIRED VALUE: $295,000. Suitable for 203(k) renovation loan.'
    END AS report_text,
    v.appraiser_id,
    v.valuation_date AS report_date,
    'COMPLETED' AS report_status,
    v.created_at AS created_at
FROM RAW.VALUATIONS v
WHERE v.valuation_id IS NOT NULL
  AND v.appraiser_id IS NOT NULL
LIMIT 30000;

-- ============================================================================
-- Step 7: Generate compliance knowledge base articles
-- ============================================================================
INSERT INTO COMPLIANCE_KNOWLEDGE_BASE VALUES
('KB001', 'TRID (TILA-RESPA Integrated Disclosure) Compliance Guide',
$$The TILA-RESPA Integrated Disclosure (TRID) rule consolidates four existing disclosures under TILA and RESPA into two forms: Loan Estimate and Closing Disclosure.

KEY REQUIREMENTS:

LOAN ESTIMATE (LE):
- Must be provided within 3 business days of receiving a loan application
- Consumer must receive LE at least 7 business days before consummation
- LE valid for 10 business days

CLOSING DISCLOSURE (CD):
- Must be provided at least 3 business days before consummation
- Shows actual transaction terms and costs
- If changes occur requiring new 3-day waiting period: APR increases >1/8%, loan product changes, prepayment penalty added

COMMON VIOLATIONS TO AVOID:
1. Providing LE more than 3 business days after application
2. Consummating loan before 7-day waiting period expires
3. Failing to provide CD at least 3 business days before consummation

BEST PRACTICES:
- Document application date clearly
- Track delivery dates of all disclosures
- Train staff on business day calculations$$,
'REGULATORY', 'TRID', CURRENT_TIMESTAMP(), 2847, 4.8, TRUE, CURRENT_TIMESTAMP()),

('KB002', 'Fair Lending and Anti-Discrimination Compliance',
$$Fair lending laws prohibit discrimination in any aspect of a credit transaction. Key laws include Fair Housing Act (FHA) and Equal Credit Opportunity Act (ECOA).

PROTECTED CLASSES:
- Race or color
- National origin
- Religion
- Sex
- Familial status
- Disability
- Age
- Marital status
- Receipt of public assistance income

PROHIBITED PRACTICES:
1. Overt discrimination
2. Disparate treatment
3. Disparate impact

COMPLIANCE REQUIREMENTS:
- Annual fair lending training
- Written fair lending policy
- HMDA reporting
- Regular self-assessment$$,
'REGULATORY', 'FAIR_LENDING', CURRENT_TIMESTAMP(), 1923, 4.9, TRUE, CURRENT_TIMESTAMP()),

('KB003', 'FHA Loan Guidelines and Requirements',
$$FHA loans are government-insured mortgages for lower-income and first-time homebuyers.

BORROWER ELIGIBILITY:
- Minimum credit score 580 for 3.5% down
- Minimum credit score 500-579 for 10% down
- Maximum 43% back-end DTI ratio

PROPERTY REQUIREMENTS:
- Must meet minimum property standards
- All major systems operational
- No health or safety hazards
- FHA-approved condominiums only

MORTGAGE INSURANCE:
- Upfront MIP: 1.75% of base loan amount
- Annual MIP: 0.45% to 1.05% depending on LTV$$,
'GUIDELINES', 'FHA', CURRENT_TIMESTAMP(), 3104, 4.7, TRUE, CURRENT_TIMESTAMP());

-- ============================================================================
-- Step 8: Create Cortex Search Service for Loan Review Notes
-- ============================================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE LOAN_REVIEW_NOTES_SEARCH
  ON note_text
  ATTRIBUTES loan_id, review_id, note_type, severity, created_date
  WAREHOUSE = CA_ANALYTICS_WH
  TARGET_LAG = '1 hour'
  COMMENT = 'Cortex Search service for loan review notes - enables semantic search across due diligence findings and exceptions'
AS
  SELECT
    note_id,
    note_text,
    review_id,
    loan_id,
    note_type,
    severity,
    issue_resolved,
    created_by,
    created_date,
    created_at
  FROM RAW.LOAN_REVIEW_NOTES;

-- ============================================================================
-- Step 9: Create Cortex Search Service for Appraisal Reports
-- ============================================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE APPRAISAL_REPORTS_SEARCH
  ON report_text
  ATTRIBUTES property_id, valuation_id, appraiser_id, report_date
  WAREHOUSE = CA_ANALYTICS_WH
  TARGET_LAG = '2 hours'
  COMMENT = 'Cortex Search service for appraisal reports - enables semantic search across property valuations and narratives'
AS
  SELECT
    report_id,
    report_text,
    valuation_id,
    property_id,
    appraiser_id,
    report_date,
    report_status,
    created_at
  FROM RAW.APPRAISAL_REPORTS;

-- ============================================================================
-- Step 10: Create Cortex Search Service for Compliance Knowledge Base
-- ============================================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE COMPLIANCE_KB_SEARCH
  ON content
  ATTRIBUTES article_category, regulation_type, title
  WAREHOUSE = CA_ANALYTICS_WH
  TARGET_LAG = '24 hours'
  COMMENT = 'Cortex Search service for compliance knowledge base - enables semantic search across regulatory guidance and procedures'
AS
  SELECT
    article_id,
    title,
    content,
    article_category,
    regulation_type,
    last_updated,
    view_count,
    helpfulness_score,
    created_at
  FROM RAW.COMPLIANCE_KNOWLEDGE_BASE;

-- ============================================================================
-- Step 11: Verify Cortex Search Services Created
-- ============================================================================
SHOW CORTEX SEARCH SERVICES IN SCHEMA RAW;

-- ============================================================================
-- Display success message
-- ============================================================================
SELECT 'Cortex Search services created successfully' AS status,
       COUNT(*) AS service_count
FROM (
  SELECT 'LOAN_REVIEW_NOTES_SEARCH' AS service_name
  UNION ALL
  SELECT 'APPRAISAL_REPORTS_SEARCH'
  UNION ALL
  SELECT 'COMPLIANCE_KB_SEARCH'
);

-- ============================================================================
-- Display data counts
-- ============================================================================
SELECT 'LOAN_REVIEW_NOTES' AS table_name, COUNT(*) AS row_count FROM LOAN_REVIEW_NOTES
UNION ALL
SELECT 'APPRAISAL_REPORTS', COUNT(*) FROM APPRAISAL_REPORTS
UNION ALL
SELECT 'COMPLIANCE_KNOWLEDGE_BASE', COUNT(*) FROM COMPLIANCE_KNOWLEDGE_BASE
ORDER BY table_name;

