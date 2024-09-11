/* explore sample chacracteristics */

/* to run this do file, type
do $projdir/do/explore/explore_sample_char.do
 */

log close _all

log using $projdir/log/explore/explore_sample_char.smcl, replace 

graph drop _all
set more off
set varabbrev off
set graphics off
set scheme s1color
set seed 1984

use $projdir/dta/csac_2024_initial_clean, clear

//------------------------------------------------
// HS Senior status and college going
//------------------------------------------------

tab hs_senior 

tab attend_coll if hs_senior == 1



//------------------------------------------------
// demographics
//------------------------------------------------

di "race for all respondents"
tab race_simple_23
tab race_simple_24
tab race_hrchy

di "race for high school seniors"
tab race_simple_23 if hs_senior==1 
tab race_simple_23 if hs_senior==1 
tab race_hrchy if hs_senior == 1


di "parent education"

tab parent_edu if hs_senior==1


di "home language is english"

tab home_lang_eng if hs_senior == 1

di "has a job"

tab has_job if hs_senior == 1

di "gender"

tab gender if hs_senior == 1



//------------------------------------------------
// tools and factors in college selection 
//------------------------------------------------

di "Q45: how helpful was..."

foreach var of varlist helpful_source_* {
    tab `var' if hs_senior == 1
}

di "Q47: social media platforms"

sum social_reddit - social_other if hs_senior == 1

di "Q49: who helpd you fill out the college application"
sum help_parent - help_self if hs_senior==1

di "Q50: college planning resources"
sum resrc_finaidtool - resrc_other  if hs_senior==1

log close 
translate $projdir/log/explore/explore_sample_char.smcl ///
    $projdir/log/explore/explore_sample_char.log, replace 