/* tabulate main questions */

/* to run this do file, type
do $projdir/do/explore/tab_questions.do
 */

log close _all

set linesize 200

graph drop _all
set more off
set varabbrev off
set graphics off
set scheme s1color
set seed 1984


use $projdir/dta/csac_2024_initial_clean.dta, clear 

include $projdir/do/macros_csac.doh 


foreach demog in race_simple_24 race_simple_23 race_hrchy gender parent_edu {
    di "tabulation by `demog'"
    log using $projdir/log/explore/tab_questions_`demog'.smcl, replace 

    foreach var of local all_qs {
        di "`var' by `demog'"


        tabulate `demog' `var'  if hs_senior==1, row 

    }

    log close 
    translate $projdir/log/explore/tab_questions_`demog'.smcl ///
        $projdir/log/explore/tab_questions_`demog'.log, replace
}

// simple tabulation of all questions
log using $projdir/log/explore/tab_questions_simple.smcl, replace 

foreach var of local all_qs {
    di "tabulation of `var'"
    
    tab `var' if hs_senior==1

}

log close 
translate $projdir/log/explore/tab_questions_simple.smcl ///
    $projdir/log/explore/tab_questions_simple.log, replace 

// tabulation of college applications
log using $projdir/log/explore/tab_coll_app.smcl, replace 

di "colleges applied"
tab coll_applied_coded if hs_senior==1

di "truncated colleges applied"
tab coll_applied_coded_trunc if hs_senior==1

di "where are you attending college"
tab coll_applied_coded_trunc where_attend_coll if hs_senior==1

di "has college contacted you about finaid"
tab coll_applied_coded_trunc coll_contact if hs_senior==1


log close 
translate $projdir/log/explore/tab_coll_app.smcl ///
    $projdir/log/explore/tab_coll_app.log, replace


// denominators for select all that apply questions 
log using $projdir/log/explore/select_all_denom.smcl, replace 

foreach var of local select_all_raw_qs {
    di "number of nonmissing responses for `var'"

    mdesc `var' if hs_senior==1, none
}

log close 
translate $projdir/log/explore/select_all_denom.smcl ///
    $projdir/log/explore/select_all_denom.log, replace 


log using $projdir/log/explore/q62_63.smcl, replace 

tab complete_atog if hs_senior==1, missing

tab track_atog if hs_senior==1, missing 

log close 
translate $projdir/log/explore/q62_63.smcl ///
    $projdir/log/explore/q62_63.log, replace 



count if why_fafsa_requirement==1 |why_fafsa_assignment==1 |why_fafsa_expected==1


// tab of heard back from college about financial aid by college applied and month of response
log using $projdir/log/explore/heard_back_by_applied_month.smcl, replace 

bysort month: tab  coll_applied_coded_trunc coll_contact, row 

log close 
translate $projdir/log/explore/heard_back_by_applied_month.smcl ///
    $projdir/log/explore/heard_back_by_applied_month.log, replace 

// tab of all questions by college likely to attend
log using $projdir/log/explore/tab_all_by_coll_attend.smcl, replace 

    foreach var of local all_qs {
        di "`var' by college likely to attend"


        tabulate where_attend_coll `var'  if hs_senior==1, row 

    }

log close 
translate  $projdir/log/explore/tab_all_by_coll_attend.smcl ///
     $projdir/log/explore/tab_all_by_coll_attend.log, replace 

// tab of all questions by college applied 

log using $projdir/log/explore/tab_all_by_coll_applied.smcl, replace 

    foreach var of local all_qs {
        di "`var' by college applied"


        tabulate coll_applied_coded_trunc `var'  if hs_senior==1, row 

    }

log close 
translate $projdir/log/explore/tab_all_by_coll_applied.smcl ///
    $projdir/log/explore/tab_all_by_coll_applied.log, replace 


// tab categories of why did you complete FAFSA, q11
gen why_fafsa_school = (why_fafsa_requirement==1) | (why_fafsa_assignment==1) | (why_fafsa_expected==1)

log using $projdir/log/explore/tab_why_fafsa.smcl, replace 

di "simple tabulation"

tab why_fafsa_eligible

tab why_fafsa_school

foreach demog in race_simple_24 race_simple_23 race_hrchy parent_edu {
    di "tabulation by `demog'"
    tab `demog' why_fafsa_eligible, row 

    tab `demog' why_fafsa_school, row
}

log close 
translate $projdir/log/explore/tab_why_fafsa.smcl ///
    $projdir/log/explore/tab_why_fafsa.log, replace 


//-------------------------------------------------------------
// comparison of questions between 2024 and 2023 survey, simple tab

log using $projdir/log/explore/compare_2023.smcl, replace 

use $projdir/dta/csac_2024_initial_clean.dta, clear 
tempfile csac2024 
save `csac2024', replace 

use "$csac2023projdir/dta/cln/csac_hs_senior_2023_brief.dta", clear 
tempfile csac2023
save `csac2023', replace 

//why did you complete FAFSA


di "2024:why did you complete FAFSA"
use `csac2024', clear 
tab why_fafsa_requirement
tab why_fafsa_assignment
tab why_fafsa_eligible
tab why_fafsa_expected
tab why_fafsa_other


di "2023: were you required by your high school to fill out FAFSA"
use `csac2023', clear 
tab hs_req_fafsa


// support for FAFSA

di "2024: support you received in completing FAFSA"
use `csac2024', clear 
tab support_received_counselor
tab support_received_teacher
tab support_received_hsworkshop
tab support_received_cmworkshop
tab support_received_parent
tab support_received_family
tab support_received_friend
tab support_received_online
tab support_received_nobody

di "2023: support you received in completin FAFSA"
use `csac2023', clear 
tab fafsa_support_icounselor
tab fafsa_support_iteacher
tab fafsa_support_ihsworkshop
tab fafsa_support_icmworkshop
tab fafsa_support_iparent
tab fafsa_support_ifamily
tab fafsa_support_ifriend
tab fafsa_support_inobody

// do you plan to attend college this fall
di "2024: do you plan to attend college this fall"
use `csac2024', clear 
tab attend_coll

di "2023: do you plan to attend college this fall"
use `csac2023', clear 
tab college_fall 

// what do you think you will be doing this fall
di "2024: why do you think you will be doing this fall"
use `csac2024', clear 
tab fall_plan_workpt
tab fall_plan_workft
tab fall_plan_family
tab fall_plan_military
tab fall_plan_other

di "2023: what do you think you will be doing this fall"
use `csac2023', clear 
tab fall_plan_iworkpt
tab fall_plan_iworkft
tab fall_plan_ifamily
tab fall_plan_imilitary






di "2024: which of the following might influence your decision of whether or not to attend college"
use `csac2024', clear 
tab coll_decision_financial
tab coll_decision_academic
tab coll_decision_family

di "2023: which of the following might influence your decision of whether or not to attend college"
use `csac2023', clear 
tab inf_no_college_ifinancial
tab inf_no_college_iacademic
tab inf_no_college_ifam_other



di "2024: where are you most likely to attend college"
use `csac2024', clear 
tab where_attend_coll

di "2023: where do you plan to attend college this fall"
use `csac2023', clear 
tab where_college 



di "2024: have any of the colleges contacted you about your financial aid"
use `csac2024', clear 
tab coll_contact

di "2023: have any of the colleges contacted you about your financial aid"
use `csac2023', clear 
tab college_contact



di "2024: what did the colleges contact you about regarding your financial aid offer"
use `csac2024', clear 
tab coll_contact_subject_doc
tab coll_contact_subject_work
tab coll_contact_subject_grant
tab coll_contact_subject_loan

di "2023: what did the colleges contact you about regarding your financial aid offer"
use `csac2023', clear 
tab college_contact_iverification
tab college_contact_ifaoffer
tab college_contact_iworkstudy
tab college_contact_iloans



di "2024: how do you plan to pay for college"
use `csac2024', clear 
tab pay_plan_scholarship
tab pay_plan_grant
tab pay_plan_saving
tab pay_plan_work
tab pay_plan_otherppl
tab pay_plan_loan
tab pay_plan_va
tab pay_plan_credit

di "2023: how do you plan to pay for college"
use `csac2023', clear 
tab pay_plan_ischolarships
tab pay_plan_igrants
tab pay_plan_isavings
tab pay_plan_iworking
tab pay_plan_ipeople
tab pay_plan_iloans
tab pay_plan_imilitary
tab pay_plan_icredit


di "2024: what are you most likely to study in college"
use `csac2024', clear 
tab major_business
tab major_engineering
tab major_science
tab major_social
tab major_humanity
tab major_health
tab major_education
tab major_applied
tab major_service
tab major_undecided


di "2023: what are you most likely to study in college"
use `csac2023', clear 
tab major 


di "2024: highest degree you hope to earn"
use `csac2024', clear 
tab highest_degree

di "2023: highest degree you hope to earn"
use `csac2023', clear 
tab highest_degree



di "2024: when you think about college, how worried are you about the following"
use `csac2024', clear 
foreach q of local q58_subqs {
    tab `q'
}

di "2023: when you think about college, how worried are you about the following"
use `csac2023', clear 
tab worry_tuition 
tab worry_living 
tab worry_academic
tab worry_work 
tab worry_family 
tab worry_community 
tab worry_away 
tab worry_support 


log close
translate $projdir/log/explore/compare_2023.smcl ///
    $projdir/log/explore/compare_2023.log, replace 

//----------------------------------------------------
// corsstab of q54 method of payment  by q40 contact about financial aid
// and y contact subject financial aid q42
log using $projdir/log/explore/pay_method_by_contact.smcl, replace 

use `csac2024', clear 

foreach q of local q54_subqs {
    di "payment plan: `q' crosstab by q40: has any college contacted you about finaid"
    tab `q' coll_contact

    foreach j of local q42_subqs {
        di "payment plan: `q' crosstab by q42: subject of contact `j'"

        tab `q' `j'
    }
}

log close 
translate $projdir/log/explore/pay_method_by_contact.smcl ///
    $projdir/log/explore/pay_method_by_contact.log, replace 