-- ============================================================================
-- Consolidated Analytics Intelligence Agent - Cortex Search Service Setup
-- ============================================================================
-- Purpose: Create unstructured data tables and Cortex Search services for
--          loan review notes, appraisal reports, and compliance knowledge base
-- Syntax verified against: https://docs.snowflake.com/en/sql-reference/sql/create-cortex-search
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
    CASE (ABS(RANDOM()) % 25)
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
-- Step 6: Generate sample appraisal reports
-- ============================================================================
INSERT INTO APPRAISAL_REPORTS
SELECT
    'RPT' || LPAD(SEQ4(), 10, '0') AS report_id,
    v.valuation_id,
    v.property_id,
    CASE (ABS(RANDOM()) % 20)
        WHEN 0 THEN 'PROPERTY APPRAISAL REPORT - Subject property is a single-family residence located at suburban address. Site visit conducted on inspection date. PROPERTY DESCRIPTION: 2,450 square feet, 4 bedrooms, 2.5 bathrooms, built in 1998. Two-story colonial style construction with brick and vinyl siding exterior. Attached two-car garage. Property situated on 0.42 acre lot in established neighborhood. CONDITION: Overall condition rated Good. Roof approximately 8 years old, estimated 12-15 years remaining useful life. HVAC system operational, replaced 5 years ago. Kitchen updated 3 years ago with granite counters and stainless appliances. Hardwood floors refinished, carpet in bedrooms shows normal wear. No major deferred maintenance observed. NEIGHBORHOOD: Well-maintained residential area with good access to schools, shopping, and employment centers. Similar properties range from $380,000 to $450,000. Stable market conditions. COMPARABLE SALES: Three comparable sales identified within 0.5 miles. Comp 1: 2,520 sf, sold $412,000 three months ago. Comp 2: 2,380 sf, sold $395,000 two months ago. Comp 3: 2,510 sf, sold $425,000 one month ago. Adjustments made for square footage (+$25/sf), garage spaces, lot size, and condition. FINAL VALUE ESTIMATE: Based on sales comparison approach, subject property appraised value $405,000 as of valuation date. Effective date of value same as inspection date. Market exposure time estimated 45-60 days in current market conditions.'
        WHEN 1 THEN 'COMMERCIAL PROPERTY APPRAISAL - Subject is a retail shopping center containing 45,000 square feet gross leasable area. Property constructed in 2005, well-maintained. TENANT INFORMATION: Anchored by national grocery tenant on 15-year lease with 8 years remaining. Six other retail tenants with average lease terms 3-5 years. Current occupancy 94%. INCOME ANALYSIS: Gross potential income $1,125,000 annually based on current lease rates. Vacancy and collection loss estimated at 5% or $56,250. Effective gross income $1,068,750. Operating expenses including taxes, insurance, maintenance, management totaling $425,000 annually. Net operating income $643,750. MARKET OVERVIEW: Retail properties in area showing stable occupancy. Cap rates for similar properties ranging 7.0% to 7.5%. VALUATION: Using direct capitalization method with 7.25% cap rate based on comparable sales. Indicated value $8,880,000. Cross-checked with comparable sales approach showing similar value range. Income approach most reliable for income-producing property. FINAL OPINION OF VALUE: $8,900,000 rounded.'
        WHEN 2 THEN 'CONDOMINIUM APPRAISAL REPORT - Subject property is a 2-bedroom, 2-bathroom condominium unit in mid-rise building. Unit 304, approximately 1,180 square feet. Building constructed 2012, modern construction with amenities including fitness center, pool, secured entry. UNIT CONDITION: Excellent condition throughout. Builder-grade finishes with recent upgrades including new flooring and paint. Kitchen with granite counters, stainless appliances. In-unit washer/dryer. One assigned parking space included. HOA REVIEW: Homeowners association properly managed, 85% funded reserves, no special assessments pending. Monthly HOA fee $385 includes exterior maintenance, insurance, amenities, reserves. HOA documents reviewed and acceptable per Fannie Mae condo project guidelines. COMPARABLE SALES: Four recent sales in same complex. Comp 1: Unit 512, 1,200 sf, $275,000. Comp 2: Unit 208, 1,150 sf, $265,000. Comp 3: Unit 615, 1,190 sf, $280,000. Comp 4: Unit 410, 1,175 sf, $272,000. All sales within past 4 months. Adjustments minimal due to similarity. VALUE CONCLUSION: Subject property value $270,000. Market exposure 30-45 days typical for this project. Strong demand in area.'
        WHEN 3 THEN 'RURAL PROPERTY APPRAISAL - Subject property is a residential home on acreage. Improvements include 1,850 square foot ranch-style home built 1985, detached 2-car garage, pole barn. Total acreage 5.25 acres, mostly wooded with approximately 1 acre cleared. PROPERTY ACCESS: Paved county road frontage, gravel driveway. Public water available, septic system on-site (inspected and approved). Propane heat. CONDITION ASSESSMENT: Home shows deferred maintenance. Roof estimated 3-5 years remaining life. HVAC system 20+ years old, may require near-term replacement. Plumbing and electrical appear functional but dated. Kitchen and bathrooms original, showing wear. Recommend buyer budget $30,000-$40,000 for updates and deferred maintenance. MARKET CONSIDERATIONS: Rural properties have longer market exposure, typically 90-180 days. Fewer comparable sales available due to unique nature of properties. COMPARABLE ANALYSIS: Three sales identified within 5-mile radius. Comp 1: 1,950 sf on 4.5 acres, sold $245,000. Comp 2: 1,720 sf on 6 acres, sold $228,000. Comp 3: 1,900 sf on 3.8 acres, sold $252,000. Subject falls in middle of value range. APPRAISED VALUE: $235,000 "as-is". If recommended improvements completed, value could increase to $265,000.'
        WHEN 4 THEN 'DESKTOP APPRAISAL REPORT (Exterior-only inspection) - Subject property located in residential neighborhood. Public records indicate 1,675 square foot home, 3 bedrooms, 2 bathrooms, built 1992. Property observed from street only. EXTERIOR OBSERVATIONS: Property appears well-maintained from street view. Roof appears in good condition, siding clean. Landscaping maintained. No obvious signs of deferred maintenance visible from public view. Unable to assess interior condition. LIMITATION OF DESKTOP APPRAISAL: This appraisal based on exterior observation and public record data only. Interior condition, system functionality, and any interior defects could not be assessed. Recommended for low-risk transactions only. COMPARABLE SALES: Three recent sales in neighborhood. Comp 1: 1,720 sf, $312,000. Comp 2: 1,650 sf, $305,000. Comp 3: 1,690 sf, $318,000. All sales within 0.75 miles and past 3 months. Adjusted for square footage differences. OPINION OF VALUE: Based on available data and subject to limitations noted, estimated value $310,000. Confidence level Medium due to lack of interior inspection. For refinance purposes only, not recommended for purchase transactions.'
        WHEN 5 THEN 'MULTI-FAMILY PROPERTY APPRAISAL - Subject is a 12-unit apartment building, two-story wood-frame construction built 1978. Each unit approximately 850 square feet, 2-bedroom/1-bathroom configuration. Surface parking for 18 vehicles. PHYSICAL CONDITION: Average to Fair condition. Roof replaced 6 years ago. HVAC systems mix of ages, 4 units with newer systems, 8 units with older systems requiring replacement within 2-3 years. Plumbing functional but aging. Electrical updated to code. Building shows normal wear for age. INCOME AND EXPENSE ANALYSIS: Current rents average $1,250 per unit per month. Gross potential income $180,000 annually. Economic vacancy estimated 7% based on area market. Effective gross income $167,400. Operating expenses: Property taxes $18,500, Insurance $8,400, Utilities $12,600, Maintenance $22,000, Management (5%) $8,370, Reserves $9,600, Total $79,470. Net operating income $87,930. CAPITALIZATION: Market cap rates for comparable apartment properties 8.0% to 8.5%. Selected cap rate 8.25% based on age and condition. VALUE INDICATION: $1,065,000. Reconciled value $1,060,000.'
        WHEN 6 THEN 'LUXURY HOME APPRAISAL - Subject property is an executive-level single-family residence in prestigious gated community. Approximately 5,200 square feet of living area, 5 bedrooms, 4.5 bathrooms, 3-car garage. Built 2015, high-end custom construction. SPECIAL FEATURES: Gourmet kitchen with commercial-grade appliances, butler pantry. Master suite with spa-like bathroom, custom walk-in closets. Home theater, wine cellar, home office with custom built-ins. Outdoor living area with pool, spa, outdoor kitchen, covered patio. Premium lot backing to golf course. QUALITY AND CONDITION: Superior quality throughout with high-end finishes including hardwood floors, custom millwork, granite and quartz counters, designer fixtures. Condition excellent with meticulous maintenance. Smart home technology integrated throughout. MARKET: High-end market segment has limited buyers and longer marketing times, typically 90-180 days. Sales less frequent than mid-range properties. COMPARABLE SALES: Three comparable luxury sales identified. Comp 1: 5,400 sf, golf course lot, sold $1,285,000. Comp 2: 4,950 sf, premium lot, sold $1,195,000. Comp 3: 5,350 sf, golf course frontage, sold $1,325,000. Subject falls mid-range. Limited adjustments required. FINAL VALUE: $1,250,000.'
        WHEN 7 THEN 'MANUFACTURED HOME APPRAISAL - Subject is a manufactured home, 2005 model, 1,540 square feet, 3 bedrooms, 2 bathrooms. Permanently affixed to foundation on owned land, 0.75 acre lot. Title converted to real property. CONSTRUCTION: HUD-code manufactured home, vinyl siding exterior, shingle roof. Home situated on permanent foundation per local building code. CONDITION: Good overall condition. Roof 5 years old. HVAC system operational. Interior well-maintained with updated flooring and fresh paint. Kitchen and bath original but clean and functional. SITE: Rural residential area, public road access. Well water, septic system. Lot partially wooded, level topography. MANUFACTURED HOME MARKET: Manufactured homes typically financed differently than site-built homes. Lending guidelines more restrictive. Market smaller, marketing times longer. COMPARABLE SALES: Three manufactured home sales on owned land. Comp 1: 2008 model, 1,620 sf, 0.5 acre, $168,000. Comp 2: 2003 model, 1,480 sf, 1.0 acre, $152,000. Comp 3: 2007 model, 1,550 sf, 0.65 acre, $162,000. Adjusted for age, size, lot size. OPINION OF VALUE: $158,000. Note: FHA and conventional financing available as home is permanently affixed and title converted to real property.'
        WHEN 8 THEN 'NEW CONSTRUCTION APPRAISAL - Subject property is new construction currently under construction, approximately 70% complete. Plans and specifications reviewed. Expected completion in 60 days. PROPOSED IMPROVEMENTS: Two-story home, 2,850 square feet per plans. 4 bedrooms, 3.5 bathrooms. Open floor plan with great room concept. Builder-selected finishes consistent with area new construction. Two-car garage, covered front porch. COST APPROACH: Land value $85,000 based on comparable lot sales. Estimated construction cost including builder profit: $285,000 (approximately $100 per square foot all-in cost). Site improvements $12,000. Indicated value by cost approach $382,000. SALES COMPARISON: Three recent new construction sales by same builder in development. Comp 1: 2,920 sf, $395,000. Comp 2: 2,780 sf, $385,000. Comp 3: 2,900 sf, $398,000. Subject falls in line with these sales on per-square-foot basis. AS-COMPLETE VALUE: Based on sales comparison and cost approaches, subject property "as-complete" value estimated $390,000. SUBJECT-TO COMPLETION: Appraisal contingent on home being completed per plans and specifications reviewed. Final inspection required before loan closing to verify completion.'
        WHEN 9 THEN 'FORECLOSURE/REO PROPERTY APPRAISAL - Subject property is a bank-owned (REO) single-family residence acquired through foreclosure. Property has been vacant approximately 8 months. PROPERTY CONDITION: Fair to Poor condition. Property shows signs of neglect and deferred maintenance. Evidence of water intrusion in basement, water staining on ceilings. HVAC system inoperative, may require replacement. Kitchen appliances missing, bathroom fixtures damaged. Carpet heavily soiled, likely requiring replacement. Exterior shows peeling paint, gutters damaged, overgrown landscaping. REQUIRED REPAIRS: Estimate $45,000 in repairs needed to bring property to average condition for neighborhood. Major items: HVAC replacement $8,500, water damage remediation $6,500, flooring replacement $8,000, plumbing repairs $3,500, kitchen appliances $2,500, exterior paint $5,500, other repairs $10,500. AS-IS VALUE VS. AS-REPAIRED: Property in current "as-is" condition appraised at $235,000. If repairs completed, estimated "as-repaired" value $295,000. Repair costs $45,000 plus carrying costs during renovation. Potential investor opportunity. MARKET: REO properties typically sell to cash buyers or investors. Marketing time 60-90 days typical. Suitable for FHA 203(k) renovation financing or conventional renovation loan.'
        WHEN 10 THEN 'DRIVE-BY APPRAISAL REPORT - Subject property observed from street only, no interior access granted. Public record data utilized. EXTERIOR OBSERVATIONS: Single-story ranch home, appears approximately 1,425 square feet per tax records. Home built 1975 per public records. Composition shingle roof appears in average condition. Aluminum siding exterior, needs paint. Single-car attached garage. Property on approximately 0.22 acre lot per tax records. NEIGHBORHOOD: Established residential neighborhood with mix of homes from 1960s-1980s. Well-located with good access to amenities. Market stable. LIMITATIONS: This is a limited-scope appraisal. Interior condition, system functionality, and any interior defects could not be assessed. Value opinion subject to interior being in average condition consistent with age and location. COMPARABLES: Three recent sales. Comp 1: 1,480 sf, $218,000. Comp 2: 1,390 sf, $208,000. Comp 3: 1,450 sf, $224,000. VALUE ESTIMATE: Based on drive-by inspection and subject to limitations noted, estimated value $215,000. Recommend full interior inspection for purchase transactions. This appraisal type acceptable for refinance of existing loan only, not for purchase or cash-out refinance.'
        WHEN 11 THEN 'APPRAISAL UPDATE/RECERTIFICATION - Original appraisal completed 4 months ago with value $345,000. Lender requesting recertification due to delayed closing. PROPERTY RE-INSPECTION: Property re-inspected, condition unchanged. No new damage or deterioration noted. Property remains in good condition as originally reported. MARKET UPDATE: Four additional comparable sales have occurred in neighborhood since original appraisal. Recent Comp 1: 1,820 sf, sold $352,000. Recent Comp 2: 1,740 sf, sold $338,000. Recent Comp 3: 1,790 sf, sold $348,000. Recent Comp 4: 1,810 sf, sold $355,000. These recent sales support and confirm original value conclusion. Market has remained stable, no significant appreciation or depreciation trends observed. UPDATED VALUE OPINION: Original appraised value $345,000 remains valid and supported by recent market activity. Value updated and recertified as of current date. No change to original value conclusion. This update satisfies lender requirement for current valuation within 120 days of loan closing. Original appraiser certifies updated value opinion.'
        WHEN 12 THEN 'COMPLEX PROPERTY APPRAISAL WITH ACCESSORY DWELLING UNIT - Main residence is 2,180 square feet, 4 bedrooms, 2.5 bathrooms built 2000. Separate accessory dwelling unit (ADU) added in 2018: 650 square feet, 1 bedroom, 1 bathroom, kitchenette. ADU has separate entrance, legally permitted per county records. INCOME POTENTIAL: ADU currently rented for $1,200 per month. Rental income can be considered in appraisal if property marketed as investment property. Can also be valued as single-family residence with accessory unit. VALUATION APPROACH: Two-scenario analysis provided. Scenario 1 - Primary Residence: Main house plus ADU valued as single-family property with accessory unit. Value: $485,000. Scenario 2 - Income Property: Property valued considering rental income from ADU. Gross income $14,400 annually from ADU rental. After expenses and applying gross rent multiplier of 12.5, income approach indicates $485,000-$495,000. RECONCILIATION: Both approaches indicate similar value. Market supports strong demand for properties with ADUs given housing shortage. Final value opinion $490,000. ADU adds significant value above standard single-family residence.'
        WHEN 13 THEN 'ESTATE/PROBATE APPRAISAL - Appraisal performed for estate settlement purposes. Effective date of value is date of decedent passing. SPECIAL PURPOSE: This appraisal intended for estate tax purposes only, not for financing. Value as of historical date (14 months ago). Property condition and market data as of that date analyzed. SUBJECT PROPERTY: Single-family residence, 1,920 square feet, 3 bedrooms, 2 bathrooms. Home built 1968, maintained in average condition. COMPARABLE SALES: Three sales from time period closest to effective date of value. Comp 1: 2,050 sf, sold $268,000 two months before effective date. Comp 2: 1,880 sf, sold $255,000 one month after effective date. Comp 3: 1,940 sf, sold $272,000 on effective date. Adjustments for time, size, condition. RETROSPECTIVE VALUE: As of date of decedent passing (14 months ago), property value estimated $265,000. Note: Current market value would be higher due to market appreciation over past 14 months. CERTIFICATION: Appraiser certifies retrospective value opinion for estate tax purposes. IRS Form 706 (Estate Tax Return) guidelines followed.'
        WHEN 14 THEN 'APPRAISAL REVIEW/DESK REVIEW - Reviewing appraisal report prepared by another appraiser with original value conclusion of $425,000. SCOPE OF REVIEW: Desk review only, no property inspection. Reviewing for guideline compliance, comparable sale selection, adjustment accuracy, and reasonableness of value conclusion. FINDINGS: 1) Comparable sale selection appropriate, all three comps within 1 mile and 3 months, good matches. 2) Adjustments reasonable and well-supported. Square footage adjustment of $30/sf appropriate for market. Condition adjustment of $8,000 for Comp 2 reasonable. 3) Highest and best use analysis adequate. 4) Photos and property description thorough. 5) One minor issue: Comp 3 is a pending sale, should have been disclosed as such and given less weight. Does not materially affect value conclusion. OPINION: Original appraisal report meets guidelines and standards. Value conclusion of $425,000 reasonable and supported. Recommend acceptance with no additional conditions. Minor issue noted does not warrant reduced confidence in value. Review appraiser concurs with original value opinion within acceptable tolerance. Appraisal suitable for intended use.'
        WHEN 15 THEN 'LAND APPRAISAL - VACANT LOT - Subject property is a vacant residential building lot in subdivision under development. Lot dimensions approximately 100 feet x 150 feet, 0.34 acres. SITE CHARACTERISTICS: Level topography, all utilities to lot line (water, sewer, electric, gas). Paved street access, curbs and sidewalks installed. Site ready for construction, no special site preparation required beyond typical builder grading and foundation work. HIGHEST AND BEST USE: Residential single-family home site. Zoning R-1, minimum 8,000 square foot lots. Subject lot at 14,800 sf provides ample building envelope. Deed restrictions limit homes to minimum 2,000 sf. COMPARABLE LOT SALES: Four recent vacant lot sales in same subdivision. Comp 1: 0.32 acre, sold $95,000. Comp 2: 0.38 acre, sold $105,000. Comp 3: 0.31 acre, sold $92,000. Comp 4: 0.36 acre, sold $100,000. Subject lot competitive with these sales. Market absorption rate approximately 2 lots per month in this subdivision. OPINION OF VALUE: Subject vacant lot valued at $98,000 as of appraisal date. Typical marketing time for vacant lots 60-90 days. Recommend lot purchase loan with construction financing to follow.'
        WHEN 16 THEN 'DECLINING MARKET ANALYSIS - Subject property located in neighborhood experiencing declining values. Past 12 months show average -3.2% decline in home values per MLS data. SUBJECT PROPERTY: 1,745 square foot home, 3 bedrooms, 2 bathrooms, built 1999. Good condition but market headwinds. MARKET FACTORS: Local plant closure affecting employment. Increased foreclosure activity in area. Inventory levels elevated at 8 months supply (balanced market typically 5-6 months). Days on market increasing, currently averaging 82 days vs. 55 days 12 months ago. Price reductions common. COMPARABLE SALES: Using most recent sales (within 60 days) to reflect current declining market. Comp 1: 1,820 sf, sold $232,000 after 73 days on market and $12,000 price reduction. Comp 2: 1,680 sf, sold $218,000 after 95 days and $15,000 reduction. Comp 3: 1,760 sf, sold $228,000 after 68 days and $10,000 reduction. OPINION OF VALUE: Subject property value $225,000 based on current market conditions. MARKET CONDITIONS ADDENDUM: Declining market. Caution advised on subject property as collateral. Recommend monitoring market trends. Value may continue to decline. Marketing time extended, estimated 75-90 days. Forecasted 6-month trend: continued decline of 2-3%.'
        WHEN 17 THEN 'SHORT SALE APPRAISAL - Subject property is subject to short sale negotiation. Homeowner owes $315,000 on mortgage, property being marketed at $275,000. Lender considering short sale to avoid foreclosure. PROPERTY CONDITION: Property in average to fair condition. Some deferred maintenance but no major defects. Mechanicals functional. Property livable and in better condition than typical foreclosure. Owner-occupied during short sale process. MARKET: Typical sales in neighborhood range $285,000 to $325,000 for similar homes. Short sales and foreclosures have put downward pressure on values. COMPARABLE SALES: Mix of traditional sales and distressed sales (REO, short sale). Comp 1: Traditional sale, 1,880 sf, $305,000. Comp 2: Short sale, 1,840 sf, $278,000. Comp 3: Traditional sale, 1,910 sf, $312,000. Comp 4: REO sale, 1,865 sf, $268,000. VALUATION ANALYSIS: Subject in current condition, marketed as short sale, estimated value $280,000. In traditional sale without short sale stigma, value could be $295,000. Short sale status impacts marketability and typical buyer profile. OPINION FOR LENDER: As short sale property in current condition, estimated value $280,000. Lender loss on short sale approximately $35,000 plus closing costs. Short sale likely better outcome than foreclosure which would result in greater loss. Recommend approval of short sale.'
        WHEN 18 THEN 'APPRAISAL FOR REVERSE MORTGAGE - Subject property being evaluated for reverse mortgage (HECM). Borrowers both age 72. PROPERTY REQUIREMENTS: Property must meet FHA minimum property standards for reverse mortgages. Subject property: single-family residence, 1,680 square feet, 3 bedrooms, 2 bathrooms, built 1982. CONDITION ASSESSMENT: Overall good condition with no major defects noted. Roof 7 years old, estimated 13+ years remaining life. HVAC systems operational and functional. No safety hazards identified. Kitchen and baths dated but functional. Property meets FHA minimum property standards with no required repairs. Some deferred maintenance (exterior paint, minor repairs) noted but not required for loan approval. BORROWER RESPONSIBILITIES: Property taxes current, homeowners insurance in force. Borrowers financially qualify and have received required reverse mortgage counseling. VALUE ANALYSIS: Three comparable sales. Comp 1: 1,720 sf, $242,000. Comp 2: 1,650 sf, $235,000. Comp 3: 1,695 sf, $248,000. OPINION OF VALUE: $245,000. Available loan amount (principal limit) based on age of youngest borrower (72) and appraised value will be approximately 55% of value, or $134,750. Property suitable for reverse mortgage financing.'
        WHEN 19 THEN 'APPRAISAL WITH SOLAR PANELS - Subject property features solar panel system installed 3 years ago. System is owned (not leased), 8.5 kW capacity. SOLAR PANEL CONSIDERATIONS: Solar panels can add value but market acceptance varies by location. In subject market area, solar panels viewed favorably due to high electricity costs. System paid off and owned by seller, will convey with property. COST vs. VALUE: Original system cost approximately $28,000. After tax credits, net cost to owner $19,600. Typical payback period 8-10 years in this market. MARKET ANALYSIS: Limited sales with solar panels in immediate area. Extracted analysis from broader market and solar industry studies suggests solar panels add 2-4% to home value in this market when owned outright. Leased panels can be detrimental to value. Subject panels owned, no lease issues. COMPARABLE SALES: Three sales without solar panels used as primary comparables. Added fourth comparable with solar panels as supporting comparable. Subject solar panels estimated to add approximately $10,000 to value (3.5% of base value). FINAL VALUE: Base value without solar panels $285,000. Solar panel adjustment +$10,000. Total value $295,000. Solar panels viewed as attractive feature by buyers in this market.'
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
-- Step 7: Generate sample compliance knowledge base articles
-- ============================================================================
INSERT INTO COMPLIANCE_KNOWLEDGE_BASE VALUES
('KB001', 'TRID (TILA-RESPA Integrated Disclosure) Compliance Guide',
$$The TILA-RESPA Integrated Disclosure (TRID) rule consolidates four existing disclosures under TILA and RESPA into two forms: Loan Estimate and Closing Disclosure.

KEY REQUIREMENTS:

LOAN ESTIMATE (LE):
- Must be provided within 3 business days of receiving a loan application
- Application defined as: name, income, SSN, property address, estimate of property value, loan amount sought
- Consumer must receive LE at least 7 business days before consummation
- LE valid for 10 business days
- If intent to proceed received, may charge fees other than credit report, appraisal, pest inspection

LOAN ESTIMATE CONTENT:
Page 1: Loan terms, projected payments, costs at closing
Page 2: Closing cost details, calculating cash to close
Page 3: Additional information, comparisons, contact information

CLOSING DISCLOSURE (CD):
- Must be provided at least 3 business days before consummation
- Shows actual transaction terms and costs
- If changes occur requiring new 3-day waiting period: APR increases more than 1/8% for regular loans (1/4% for irregular), loan product changes, or prepayment penalty added

TIMING RULES:
- Business days for delivery of LE and CD = all days except Sundays and legal public holidays
- Business days for waiting period before consummation = all days except Sundays and holidays
- Consummation = time consumer becomes contractually obligated on the loan (typically closing/settlement)

CHANGE OF CIRCUMSTANCES:
Valid changed circumstances allow revised LE:
- Acts of God, war, disaster, or other emergency
- Information specific to consumer or transaction becomes inaccurate
- New information specific to consumer or transaction
- Revisions requested by consumer
- Interest rate lock expiration
- Construction delays

COMMON VIOLATIONS TO AVOID:
1. Providing LE more than 3 business days after application
2. Consummating loan before 7-day waiting period expires
3. Failing to provide CD at least 3 business days before consummation
4. Improperly calculating good faith estimate tolerances
5. Using incorrect business day calculations

ZERO TOLERANCE ITEMS:
Cannot increase from LE to CD:
- Fees paid to creditor, mortgage broker, or affiliate
- Fees for services where creditor does not permit shopping
- Transfer taxes

10% TOLERANCE ITEMS:
Aggregate cannot increase more than 10%:
- Recording fees
- Fees for third-party services where creditor permits shopping

UNLIMITED TOLERANCE:
May increase from LE to CD:
- Prepaid interest
- Property insurance premiums
- Amounts for initial escrow deposit
- Fees for services consumer shops for and selects provider not on creditor list

BEST PRACTICES:
- Document application date clearly
- Track delivery dates of all disclosures
- Maintain evidence of delivery (email confirmations, mail receipts)
- Train staff on business day calculations
- Implement system controls and checks
- Review sample of loans for TRID compliance monthly
- Correct errors promptly and provide corrected disclosures

PENALTIES FOR NON-COMPLIANCE:
- CFPB enforcement actions and fines
- State regulatory enforcement
- Private lawsuits by consumers
- Loan rescission rights for consumers
- Reputational damage

For questions on TRID compliance, consult CFPB official resources or legal counsel.$$,
'REGULATORY', 'TRID', CURRENT_TIMESTAMP(), 2847, 4.8, TRUE, CURRENT_TIMESTAMP()),

('KB002', 'Fair Lending and Anti-Discrimination Compliance',
$$OVERVIEW:
Fair lending laws prohibit discrimination in any aspect of a credit transaction. Key laws include Fair Housing Act (FHA), Equal Credit Opportunity Act (ECOA), and various state laws.

PROTECTED CLASSES:
Federal protected classes:
- Race or color
- National origin
- Religion
- Sex (including sexual orientation and gender identity)
- Familial status (families with children under 18)
- Disability/Handicap
- Age (ECOA - age discrimination in credit)
- Marital status (ECOA)
- Receipt of income from public assistance (ECOA)

PROHIBITED PRACTICES:

1. OVERT DISCRIMINATION:
Treating applicants differently based on protected class status. Example: Different interest rates or terms based on race.

2. DISPARATE TREATMENT:
Treating similarly situated applicants differently based on prohibited basis. Examples:
- Requiring more documentation from minority applicants
- Steering minorities to subprime products when they qualify for prime
- Different underwriting standards based on protected class

3. DISPARATE IMPACT:
Policy or practice that appears neutral but has disproportionate adverse effect on protected class. Examples:
- Minimum loan amount that disproportionately excludes minorities
- Geographic restrictions (redlining)
- Policy prohibiting consideration of public assistance income

COMPLIANCE REQUIREMENTS:

LOAN OFFICER TRAINING:
- Annual fair lending training mandatory
- Document all training sessions
- Cover protected classes, prohibited practices, red flags
- Include practical examples and case studies

POLICIES AND PROCEDURES:
- Written fair lending policy
- Clear underwriting guidelines applied consistently
- Objective credit scoring models
- Documented exceptions to policy
- Secondary review of all denials

HMDA REPORTING:
- Accurate data collection required
- Report on race, ethnicity, sex, income
- Report application disposition (approved, denied, withdrawn)
- Analysis for disparate impact patterns
- Annual HMDA data filing

MONITORING AND ANALYSIS:
- Regular fair lending self-assessment
- Statistical analysis of lending patterns
- Denial rate analysis by protected class
- Pricing disparities analysis
- Geographic distribution analysis
- Corrective actions for identified issues

RED FLAGS TO AVOID:
- Comments about applicant's protected class status
- Assumptions about ability to afford based on protected class
- Different information requests based on protected class
- Discouragin applications from protected classes
- Steering to different loan products based on protected class
- Different fee structures or pricing

MARKETING AND ADVERTISING:
- Market to diverse communities
- Avoid statements that suggest preference or limitation
- Use diverse imagery in marketing materials
- Consistent messaging across all channels
- Comply with Regulation B advertising requirements

BEST PRACTICES:
- Use objective criteria for all lending decisions
- Apply underwriting guidelines consistently
- Document reasons for all adverse actions
- Provide adverse action notices within required timeframes
- Monitor third-party vendors for fair lending compliance
- Establish second review process for denials
- Regular compliance audits
- Executive management oversight of fair lending

PENALTIES FOR VIOLATIONS:
- CFPB and DOJ enforcement actions
- Fines and penalties (can be substantial)
- Required policy changes and monitoring
- Compensatory damages to affected consumers
- Pattern or practice investigations
- Consent orders and compliance plans
- Reputational harm

CASE EXAMPLES:
Major settlements in recent years show regulators' focus on fair lending. Violations included pricing disparities, steering, redlining, and discriminatory underwriting.

For fair lending questions, consult compliance team or legal counsel immediately.$$,
'REGULATORY', 'FAIR_LENDING', CURRENT_TIMESTAMP(), 1923, 4.9, TRUE, CURRENT_TIMESTAMP()),

('KB003', 'FHA Loan Guidelines and Requirements',
$$FHA LOAN OVERVIEW:
Federal Housing Administration (FHA) loans are government-insured mortgages designed to help lower-income and first-time homebuyers. HUD 4000.1 Handbook is the comprehensive FHA guideline document.

BORROWER ELIGIBILITY:

CREDIT REQUIREMENTS:
- Minimum credit score 580 for 3.5% down payment
- Minimum credit score 500-579 for 10% down payment
- Bankruptcy: 2 years from discharge date (Chapter 7)
- Foreclosure: 3 years from completion date
- Manual underwrite required for credit scores < 620

DEBT-TO-INCOME RATIOS:
- Maximum 31% front-end ratio (housing payment to income)
- Maximum 43% back-end ratio (total debt to income)
- Higher ratios permitted with compensating factors
- Compensating factors: minimal increase in housing payment, significant cash reserves, residual income test, conservative credit use

PROPERTY REQUIREMENTS:

ELIGIBLE PROPERTIES:
- Single-family homes (1-4 units)
- FHA-approved condominiums
- Manufactured homes (meeting HUD code)
- Must be primary residence
- Property must meet minimum property standards

MINIMUM PROPERTY STANDARDS (MPS):
- Property must be safe, sound, and secure
- All major systems operational (HVAC, plumbing, electrical)
- No health or safety hazards
- Roof must have at least 2 years remaining useful life
- Foundation must be structurally sound
- No lead-based paint hazards
- Adequate access to property

REQUIRED REPAIRS:
FHA appraisal may note required repairs that must be completed before closing:
- Safety hazards must be corrected
- Structural issues must be addressed
- Roof leaks must be repaired
- Non-functioning systems must be repaired or replaced
- Repair escrow (up to $5,000) permitted for minor items
- 203(k) loan option for major repairs

LOAN AMOUNTS:
- Maximum loan amounts vary by county
- Based on area median home prices
- Range from $498,257 to $1,149,825 (2024 limits)
- Check FHA loan limit for specific county

DOWN PAYMENT:
- Minimum 3.5% with credit score 580+
- Minimum 10% with credit score 500-579
- Down payment can be gift funds (documented)
- Seller can contribute up to 6% toward closing costs

MORTGAGE INSURANCE:

UPFRONT MIP:
- 1.75% of base loan amount
- Can be financed into loan
- Due at closing

ANNUAL MIP:
- 0.45% to 1.05% annually depending on loan amount, LTV, and term
- Divided into monthly payments
- Required for life of loan if LTV > 90% at origination
- Can be cancelled after 11 years if LTV was ≤ 90% at origination

UNDERWRITING REQUIREMENTS:

INCOME DOCUMENTATION:
- 2 years employment history
- W-2s and paystubs for employed borrowers
- Tax returns for self-employed (2 years)
- Verification of employment within 10 days of closing
- Acceptable income: salary, overtime, bonus, commission, retirement, disability

ASSET DOCUMENTATION:
- 2 months bank statements
- Source of large deposits must be documented
- Minimum 1 month reserves preferred
- Gift funds acceptable with documentation

APPRAISAL REQUIREMENTS:
- FHA-approved appraiser required
- Appraisal valid for 120 days (can be extended to 240 days with update)
- Appraisal transfers to another buyer if original contract cancelled
- Direct Endorsement underwriters review appraisals
- May require additional review for high-value homes

SPECIAL FHA PROGRAMS:

203(k) RENOVATION LOAN:
- Purchase and rehabilitation financing combined
- Standard 203(k) for major renovations > $35,000
- Limited 203(k) for minor repairs < $35,000
- Contractor work required, documented draws

ENERGY EFFICIENT MORTGAGE (EEM):
- Additional financing for energy improvements
- Up to $8,000 or 5% of property value
- Can be used with purchase or refinance

FHA STREAMLINE REFINANCE:
- For existing FHA loans only
- Reduced documentation requirements
- No appraisal required (usually)
- Must demonstrate net tangible benefit

COMMON FHA PITFALLS TO AVOID:
- Non-approved condos
- Self-employment income calculation errors
- Inadequate documentation of credit issues
- Property not meeting minimum property standards
- Incorrect gift fund documentation
- Occupancy requirements not met
- Non-approved funding sources

FHA loans popular with first-time buyers due to low down payment and flexible credit requirements. Proper documentation and property standards compliance essential.$$,
'GUIDELINES', 'FHA', CURRENT_TIMESTAMP(), 3104, 4.7, TRUE, CURRENT_TIMESTAMP());

-- More knowledge base articles can be added following similar pattern...

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

