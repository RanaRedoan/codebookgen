*===========================================*
*       codebookgen EXAMPLE FILE            *
*       Survey Documentation System         *
*===========================================*

// Setup environment
version 16
clear all
set more off
capture log close
log using codebookgen_example.log, replace

*----------------------------*
* 1. BASIC USAGE EXAMPLE     *
*----------------------------*

// Load example dataset
sysuse auto, clear

// Generate basic codebook (default format)
codebookgen using "auto_basic_codebook.xlsx", replace

*----------------------------*
* 2. SURVEY DATA EXAMPLE     *
*----------------------------*

// Create mock survey data with metadata
clear
set obs 100

// Generate variables with labels and characteristics
gen respondent_id = _n
label var respondent_id "Unique respondent identifier"

gen age = runiformint(18,80)
label var age "Respondent age in years"
char age[note1] "What is your age in completed years?"
char age[source] "Demographic section"
char age[validation] "Range checked (18-80)"

gen gender = runiformint(1,3)
label var gender "Respondent gender"
label define gender 1 "Male" 2 "Female" 3 "Other"
label values gender gender
char gender[note1] "What is your gender identity?"
char gender[source] "Demographic section"

gen income = runiform(500,5000)
label var income "Monthly income in USD"
char income[note1] "What is your total monthly income in US dollars?"
char income[source] "Economic status section"
char income[validation] "Outlier checks applied"

gen satisfied = runiformint(1,5)
label var satisfied "Service satisfaction"
label define likert 1 "Very unsatisfied" 2 "Unsatisfied" 3 "Neutral" 4 "Satisfied" 5 "Very satisfied"
label values satisfied likert
char satisfied[note1] "How satisfied are you with our services?"
char satisfied[source] "Opinion section"

*---------------------------------*
* 3. ADVANCED CODEGEN USAGE       *
*---------------------------------*

// Generate comprehensive codebook with:
// - Custom sheet name
// - Additional metadata columns
// - Excel formatting
codebookgen using "survey_documentation.xlsx", ///
    sheet("MainVariables") ///
    addvars(source validation) ///
    replace format

*---------------------------------*
* 4. SUBSET OF VARIABLES EXAMPLE  *
*---------------------------------*

// Document only demographic variables
codebookgen respondent_id age gender using "demographics_codebook.xlsx", ///
    sheet("Demographics") ///
    addvars(source note1) ///
    replace

*---------------------------------*
* 5. REAL-WORLD SCENARIO          *
*---------------------------------*

// Typical workflow for survey documentation:

// Step 1: Prepare metadata
char define _dta[project] "Customer Satisfaction Survey 2023"
char define _dta[version] "v2.1.5"
char define _dta[fieldwork] "June-July 2023"

// Step 2: Document complex variable
gen customer_type = runiformint(1,4)
label var customer_type "Type of customer relationship"
label define custype 1 "New" 2 "Regular" 3 "VIP" 4 "Inactive"
label values customer_type custype
char customer_type[note1] "How would you classify your relationship with our company?"
char customer_type[source] "Screening question"
char customer_type[logic_check] "If inactive, must have purchase_date < 2022"
char customer_type[coding_notes] "Recoded from Q12 in original questionnaire"

// Step 3: Generate final documentation
codebookgen using "final_survey_codebook.xlsx", ///
    sheet("MasterCodebook") ///
    addvars(source note1 validation logic_check coding_notes) ///
    replace format excelx

// View the log
log close
view codebookgen_example.log
