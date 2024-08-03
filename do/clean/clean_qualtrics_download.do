/* First pass clean of qualtrics downloaded data */

log close _all

log using $projdir/log/clean/clean_qualtrics_download.smcl, replace 

graph drop _all
set more off
set varabbrev off
set graphics off
set scheme s1color
set seed 1984

// this is the correct file, the older file has line breaks in text response which results in incorrect import
import delimited "$rawdtadir/CSAC_2024_Senior_Survey_August 2, 2024_12.04.csv", varnames(1) clear 


//---------------------------------------------------------------
// initial cleaning
//---------------------------------------------------------------
// drop header rows
drop if _n==1 | _n==2
// drop empty system variables
drop recipient*name recipientemail externalreference

// rename and recode variables 
encode q4, generate(ready_to_start) label(ready_to_start_lab)
label var ready_to_start "Ready to start survey or show more info"

// remove leading and trailing spaces and convert to lower case
replace q6 = strlower(strtrim(q6))
rename q6 email 

encode q8, generate(graduate_hs) label(graduate_hs_lab)
label var graduate_hs "Graduated HS in spring or summer 2024"
drop q8

encode q11, generate(why_fafsa) label(why_fafsa_lab)
label var why_fafsa "Reason for completing FAFSA or CADAA"
drop q11 

rename q11_5_text why_fafsa_other
replace why_fafsa_other = strlower(strtrim(why_fafsa_other))
label var why_fafsa_other "Free response for why completed FAFSA or CADAA"

encode q12, generate(when_heard_fafsa) label(when_heard_fafsa_lab)
label var when_heard_fafsa "When did you first hear about FAFSA or CADAA"
drop q12 



log close 
translate $projdir/log/clean/clean_qualtrics_download.smcl ///
    $projdir/log/clean/clean_qualtrics_download.log, replace 