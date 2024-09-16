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

include $projdir/do/macros_csac.doh 

use $projdir/dta/csac_2024_initial_clean.dta, clear 


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

