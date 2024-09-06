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


foreach demog in race gender parent_edu {
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

