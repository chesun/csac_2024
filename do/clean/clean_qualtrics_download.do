/* First pass clean of qualtrics downloaded data */

/* to run this do file, type
do $projdir/do/clean/clean_qualtrics_download.do
 */

log close _all

log using $projdir/log/clean/clean_qualtrics_download.smcl, replace 

graph drop _all
set more off
set varabbrev off
set graphics off
set scheme s1color
set seed 1984

// this is the correct file, the older file has line breaks in text response which results in incorrect import
import delimited "$rawdtadir/CSAC_2024_Senior_Survey_August 2, 2024_12.04.csv", varnames(1) rowrange(4) clear 

//-------------------- -------------------------------------------
// initial cleaning
// do not encode select all that apply questions
//---------------------------------------------------------------
// drop header rows
drop if _n==1 | _n==2
// drop empty system variables
drop recipient*name recipientemail externalreference

drop distributionchannel  
drop *click* *pagesubmit

    // code the date time variables as stata datetime format
    foreach var of varlist startdate enddate recordeddate {
        gen num`var' = clock(`var', "YMD hms")
        format num`var' %tc
    }

    //create a month variable
    gen month =  month(dofc(numenddate))
    lab var month "Month of response"

// rename and recode variables 
encode q4, generate(ready_to_start) label(ready_to_start_lab)
label var ready_to_start "Q4: Ready to start survey or show more info"
drop q4

// remove leading and trailing spaces and convert to lower case
replace q6 = strlower(strtrim(q6))
rename q6 email 

label define hs_senior_lab 0 "No" 1 "Yes"
encode q8, generate(hs_senior) label(hs_senior_lab)
label var hs_senior "Q8: Graduated HS in spring or summer 2024"
drop q8

*********** FAFSA*********

// Q11: wy did you complete FAFSA or CADAA? select all that apply
rename q11 why_fafsa_raw
label var why_fafsa_raw "Q11: Reason for completing FAFSA or CADAA"

gen why_fafsa_requirement = (strpos(why_fafsa_raw, "It was a requirement for graduation")!=0)
replace why_fafsa_requirement = . if mi(why_fafsa_raw)
gen why_fafsa_assignment = (strpos(why_fafsa_raw, "It was part of an assignment for a class")!=0)
replace why_fafsa_assignment = . if mi(why_fafsa_raw)
gen why_fafsa_eligible = (strpos(why_fafsa_raw, "I wanted to see if I was eligible for financial aid")!=0)
replace why_fafsa_eligible = . if mi(why_fafsa_raw)
gen why_fafsa_expected = (strpos(why_fafsa_raw, "It was an expectation at my school")!=0)
replace why_fafsa_expected = . if mi(why_fafsa_raw)
gen why_fafsa_other = (strpos(why_fafsa_raw, "Other (Please describe)")!=0)
replace why_fafsa_other = . if mi(why_fafsa_raw)

label var why_fafsa_requirement "Q11: Requirement for Graduation"
label var why_fafsa_assignment "Q11: Assignment for Class"
label var why_fafsa_eligible "Q11: Check Eligibility for Financial Aid"
label var why_fafsa_expected "Q11: Expected at School"
label var why_fafsa_other "Q11: Other"



rename q11_5_text why_fafsa_other_text
replace why_fafsa_other_text = strlower(strtrim(why_fafsa_other_text))
label var why_fafsa_other_text "Q11: Free response for why completed FAFSA or CADAA"

encode q12, generate(when_heard_fafsa) label(when_heard_fafsa_lab)
label var when_heard_fafsa "Q12: When did you first hear about FAFSA or CADAA"
drop q12 

encode q14, generate(difficulty_apply_finaid) label(difficulty_apply_finaid_lab)
label var difficulty_apply_finaid "Q14: How difficult was applying for financial aid"
drop q14

// Q15: what challenges did you face in applying for financial aid 
    // via FAFSA or CADAA? select all that apply
rename q15 finaid_challenge_raw
label var finaid_challenge_raw "Q15: challenges you faced applying to FAFSA/CADAA"

gen finaid_challenge_tech = (strpos(finaid_challenge_raw, "I had technical difficulties with the application")!=0)
gen finaid_challenge_none = (strpos(finaid_challenge_raw, "I had no difficulties with the application") !=0)
gen finaid_challenge_doc = (strpos(finaid_challenge_raw, "I had issues with the required documents") !=0)
gen finaid_challenge_invite = (strpos(finaid_challenge_raw, "I had issues inviting financial contributors to FAFSA") !=0)
gen finaid_challenge_multi = (strpos(finaid_challenge_raw, "It took me multiple attempts to submit the application") !=0)
gen finaid_challenge_confusing = (strpos(finaid_challenge_raw, "The application was confusing") !=0)
gen finaid_challenge_nohelp = (strpos(finaid_challenge_raw, "I could not find someone to help me complete the application") !=0)
gen finaid_challenge_info = (strpos(finaid_challenge_raw, "I was concerned about sharing my family's information") !=0)
gen finaid_challenge_whichapp = (strpos(finaid_challenge_raw, "I did not know which application to complete") !=0)
gen finaid_challenge_other = (strpos(finaid_challenge_raw, "Other: (please explain)") !=0)

replace finaid_challenge_tech =. if mi(finaid_challenge_raw)
replace finaid_challenge_none =. if mi(finaid_challenge_raw)
replace finaid_challenge_doc =. if mi(finaid_challenge_raw)
replace finaid_challenge_invite =. if mi(finaid_challenge_raw)
replace finaid_challenge_multi =. if mi(finaid_challenge_raw)
replace finaid_challenge_confusing =. if mi(finaid_challenge_raw)
replace finaid_challenge_nohelp =. if mi(finaid_challenge_raw)
replace finaid_challenge_info =. if mi(finaid_challenge_raw)
replace finaid_challenge_whichapp =. if mi(finaid_challenge_raw)
replace finaid_challenge_other =. if mi(finaid_challenge_raw)

label var finaid_challenge_tech "FAFSA challenges: technical difficulties"
label var finaid_challenge_none "FAFSA challenges: no difficulties"
label var finaid_challenge_doc "FAFSA challenges: issues with required documents"
label var finaid_challenge_invite "FAFSA challenges: issues inviting financial contributors"
label var finaid_challenge_multi "FAFSA challenges: took multiple attempts to submit"
label var finaid_challenge_confusing "FAFSA challenges: application was confusing"
label var finaid_challenge_nohelp "FAFSA challenges: could not find someone to help"
label var finaid_challenge_info "FAFSA challenges: concerned about sharing family information"
label var finaid_challenge_whichapp "FAFSA challenges: didn't know which applicationt o complete"
label var finaid_challenge_other "FAFSA challenges: other/eplain"


rename q15_9_text finaid_challenge_other_text 
replace finaid_challenge_other_text  = strlower(strtrim(finaid_challenge_other_text ))
label var finaid_challenge_other_text  "Q15: Free response for challenges faced applying to FAFSA/CADAA"


/* Q16: tell us about the support your received in completing FAFSA/CADAA. 
    select all that apply */
rename q16 support_received_raw
label var support_received_raw "Q16: Support received when applying for FAFSA/CADAA"

gen support_received_counselor = (strpos(support_received_raw, "High school counselor") !=0)
gen support_received_teacher = (strpos(support_received_raw, "Teacher") !=0)
gen support_received_hsworkshop = (strpos(support_received_raw, "FAFSA/CADAA workshop or training at your high school") !=0)
gen support_received_cmworkshop = (strpos(support_received_raw, "FAFSA/CADAA workshop at community location outside of high school") !=0)
gen support_received_parent = (strpos(support_received_raw, "Parent") !=0)
gen support_received_family = (strpos(support_received_raw, "Family member other than parent") !=0)
gen support_received_friend = (strpos(support_received_raw, "Friend") !=0)
gen support_received_online = (strpos(support_received_raw, "Online resources") !=0)
gen support_received_nobody = (strpos(support_received_raw, "Nobody (I completed it on my own)") !=0)

replace support_received_counselor =. if mi(support_received_raw)
replace support_received_teacher =. if mi(support_received_raw)
replace support_received_hsworkshop =. if mi(support_received_raw)
replace support_received_cmworkshop =. if mi(support_received_raw)
replace support_received_parent =. if mi(support_received_raw)
replace support_received_family =. if mi(support_received_raw)
replace support_received_friend =. if mi(support_received_raw)
replace support_received_online =. if mi(support_received_raw)
replace support_received_nobody =. if mi(support_received_raw)

lab var support_received_counselor "Q16 FAFSA support: HS counselor"
lab var support_received_teacher "Q16 FAFSA support: teacher"
lab var support_received_hsworkshop "Q16 FAFSA support: HS workshop"
lab var support_received_cmworkshop "Q16 FAFSA support: community workshop"
lab var support_received_parent "Q16 FAFSA support: parent"
lab var support_received_family "Q16 FAFSA support: family other than parent"
lab var support_received_friend "Q16 FAFSA support: friend"
lab var support_received_online "Q16 FAFSA support: Online resources"
lab var support_received_nobody "Q16 FAFSA support: Nobody, completed on my own"

order why_fafsa_* when_heard_fafsa difficulty_apply_finaid finaid_challenge_* support_received_*, after(hs_senior)

********** College Attitudes ************
label define coll_att_3pt_lab -1 "Disagree" 0 "Somewhat agree" 1 "Strongly agree"
encode q18_1, generate(coll_att_3pt_important) label(coll_att_3pt_lab)
encode q18_2, generate(coll_att_3pt_worth) label(coll_att_3pt_lab)
encode q18_3, generate(coll_att_3pt_ready) label(coll_att_3pt_lab)

label define coll_att_5pt_lab -2 "Strongly disagree" -1 "Somewhat disagree" 0 "Neither agree nor disagree" 1 "Somewhat agree" 2 "Strongly agree"
encode q19_1, generate(coll_att_5pt_important) label(coll_att_5pt_lab)
encode q19_2, generate(coll_att_5pt_worth) label(coll_att_5pt_lab)
encode q19_3, generate(coll_att_5pt_ready) label(coll_att_5pt_lab)

foreach scale in 3pt 5pt {
    label var coll_att_`scale'_important "College is important for my future plans"
    label var coll_att_`scale'_worth "College is worth the cost"
    label var coll_att_`scale'_ready "I am academically ready for college"

}
drop q18_? q19_?

order coll_att*, after(support_received_nobody)



********** College Applications *************
label define coll_factor_lab 0 "Not a factor" 1 "Minor Factor" 2 "Major Factor"
encode q21_1, generate(coll_factor_gpa) label(coll_factor_lab)
encode q21_2, generate(coll_factor_score) label(coll_factor_lab)
encode q21_3, generate(coll_factor_service) label(coll_factor_lab)
encode q21_4, generate(coll_factor_firstgen) label(coll_factor_lab)
encode q21_5, generate(coll_factor_extra) label(coll_factor_lab)
drop q21_?

label var coll_factor_gpa "Q21: how should High School GPA factor in college applications"
label var coll_factor_score "Q21: how should std test score factor in coll app"
label var coll_factor_service "Q21: how should community service factor in coll app"
label var coll_factor_firstgen "Q21: how should being firstgen factor in coll app"
label var coll_factor_extra "Q21: how should extracurricular activites factor in coll app"

rename q22 coll_factor_other_text 
label var coll_factor_other_text "Q22: what other factors should be considered in coll app"

/* Q25: did you apply to any colleges and universities? select all that apply */
rename q25 coll_applied_raw
label var coll_applied_raw "Q25: What colleges or universities did you apply to"

gen coll_applied_ccc = (strpos(coll_applied_raw, "California Community College (CCC)") !=0)
gen coll_applied_csu = (strpos(coll_applied_raw, "California State University (CSU)") !=0)
gen coll_applied_uc = (strpos(coll_applied_raw, "University of California (UC)") !=0)
gen coll_applied_priv4yr = (strpos(coll_applied_raw, "Private four-year college/university in California") !=0)
gen coll_applied_vocation = (strpos(coll_applied_raw, "Vocational, technical, or career college in California") !=0)
gen coll_applied_outside = (strpos(coll_applied_raw, "College or university outside of California") !=0)
gen coll_applied_notsure = (strpos(coll_applied_raw, "I'm not sure") !=0)
gen coll_applied_none = (strpos(coll_applied_raw, "I did not apply to a college") !=0)

replace coll_applied_ccc =. if mi(coll_applied_raw)
replace coll_applied_csu =. if mi(coll_applied_raw)
replace coll_applied_uc =. if mi(coll_applied_raw)
replace coll_applied_priv4yr =. if mi(coll_applied_raw)
replace coll_applied_vocation =. if mi(coll_applied_raw)
replace coll_applied_outside =. if mi(coll_applied_raw)
replace coll_applied_notsure =. if mi(coll_applied_raw)
replace coll_applied_none =. if mi(coll_applied_raw)

label var coll_applied_ccc "Q25: applied to CCC"
label var coll_applied_csu "Q25: applied to CSU"
label var coll_applied_uc "Q25: applied to UC"
label var coll_applied_priv4yr "Q25: applied to private 4 year in CA"
label var coll_applied_vocation "Q25: applied to vocational college in CA"
label var coll_applied_outside "Q25: applied to college outside CA"
label var coll_applied_notsure "Q25: not sure"
label var coll_applied_none "Q25: did not apply to college"

    // a shortened variable for encoding different combos
    gen coll_applied_short = coll_applied_raw
    replace coll_applied_short = subinstr(coll_applied_short, "California Community College (CCC)", "CCC", .)
    replace coll_applied_short = subinstr(coll_applied_short, "California State University (CSU)", "CSU", .)
    replace coll_applied_short = subinstr(coll_applied_short, "University of California (UC)", "UC", .)
    replace coll_applied_short = subinstr(coll_applied_short, "Private four-year college/university in California", "PRIVATE", .)
    replace coll_applied_short = subinstr(coll_applied_short, "Vocational, technical, or career college in California", "VOCATIONAL", .)
    replace coll_applied_short = subinstr(coll_applied_short, "College or university outside of California", "OUTSIDE", .)
    replace coll_applied_short = subinstr(coll_applied_short, "I'm not sure", "NOTSURE", .)
    replace coll_applied_short = subinstr(coll_applied_short, "I did not apply to a college", "DIDNOTAPPLY", .)

    // encode 
    lab define coll_applied_coded 1 "CCC" 2 "CSU" 3 "UC" ///
        4 "CCC,UC" 5 "CCC,CSU" 6 "CSU,UC" 7 "CCC,CSU,UC" ///
        8 "CCC,UC,PRIVATE" 9 "CCC,CSU,PRIVATE" 10 "CSU,UC,PRIVATE" 11 "CCC,CSU,UC,PRIVATE" ///
        12 "CCC,UC,VOCATIONAL" 13 "CCC,CSU,VOCATIONAL" 14 "CSU,UC,VOCATIONAL" 15 "CCC,CSU,UC,VOCATIONAL" ///
        16 "CCC,UC,OUTSIDE" 17 "CCC,CSU,OUTSIDE" 18 "CSU,UC,OUTSIDE" 19 "CCC,CSU,UC,OUTSIDE" 

    encode coll_applied_short, gen(coll_applied_coded) lab(coll_applied_coded)
    lab var coll_applied_coded "College applied coded with all categories"

    gen coll_applied_coded_trunc = coll_applied_coded
    replace coll_applied_coded_trunc = 20 if coll_applied_coded_trunc >= 20 & !mi(coll_applied_coded_trunc)
    lab define coll_applied_coded_trunc ///
        1 "CCC" 2 "CSU" 3 "UC" ///
        4 "CCC,UC" 5 "CCC,CSU" 6 "CSU,UC" 7 "CCC,CSU,UC" ///
        8 "CCC,UC,PRIVATE" 9 "CCC,CSU,PRIVATE" 10 "CSU,UC,PRIVATE" 11 "CCC,CSU,UC,PRIVATE" ///
        12 "CCC,UC,VOCATIONAL" 13 "CCC,CSU,VOCATIONAL" 14 "CSU,UC,VOCATIONAL" 15 "CCC,CSU,UC,VOCATIONAL" ///
        16 "CCC,UC,OUTSIDE" 17 "CCC,CSU,OUTSIDE" 18 "CSU,UC,OUTSIDE" 19 "CCC,CSU,UC,OUTSIDE"  ///
        20 "OTHERCOMBINATIONS"

    lab values coll_applied_coded_trunc coll_applied_coded_trunc
    lab var coll_applied_coded_trunc "Colleges applied with truncated categories"

    //dummies
    gen coll_applied_only_ccc = 1 if coll_applied_coded == 1
    gen coll_applied_only_csu = 1 if coll_applied_coded == 2
    gen coll_applied_only_uc = 1 if coll_applied_coded == 3 
    gen coll_applied_only_ccc_uc = 1 if coll_applied_coded == 4
    gen coll_applied_only_ccc_csu = 1 if coll_applied_coded == 5 
    gen coll_applied_only_csu_uc = 1 if coll_applied_coded == 6 
    gen coll_applied_only_ccc_csu_uc = 1 if coll_applied_coded == 7


/* Q26: what challenges did you face when applying to college or trade school? select all that apply */
rename q26 collapp_chall_raw
label var collapp_chall_raw "Q26: challenges applying to college/trade school"

gen collapp_chall_dna = (strpos(collapp_chall_raw, "I did not apply to a college or a trade school") !=0)
gen collapp_chall_none = (strpos(collapp_chall_raw, "I did not face any challenges during the application process") !=0)
gen collapp_chall_noinfo = (strpos(collapp_chall_raw, "I did not have enough information about how to apply") !=0)
gen collapp_chall_dnu = (strpos(collapp_chall_raw, "I did not understand some of the questions on the application") !=0)
gen collapp_chall_course = (strpos(collapp_chall_raw, "I had trouble entering in my high school coursework") !=0)
gen collapp_chall_miss = (strpos(collapp_chall_raw, "I was missing necessary coursework for eligibility") !=0)
gen collapp_chall_fee = (strpos(collapp_chall_raw, "I could not afford the application fees") !=0)
gen collapp_chall_deadline = (strpos(collapp_chall_raw, "I missed an application deadline") !=0)
gen collapp_chall_notready = (strpos(collapp_chall_raw, "I do not feel academically ready for college") !=0)
gen collapp_chall_submit = (strpos(collapp_chall_raw, "I had difficulty submitting other required items (transcripts, essays, test scores, etc.)") !=0)
gen collapp_chall_other = (strpos(collapp_chall_raw, "Other (please specify)") !=0)

replace collapp_chall_dna =. if mi(collapp_chall_raw)
replace collapp_chall_none =. if mi(collapp_chall_raw)
replace collapp_chall_noinfo =. if mi(collapp_chall_raw)
replace collapp_chall_dnu =. if mi(collapp_chall_raw)
replace collapp_chall_course =. if mi(collapp_chall_raw)
replace collapp_chall_miss =. if mi(collapp_chall_raw)
replace collapp_chall_fee =. if mi(collapp_chall_raw)
replace collapp_chall_deadline =. if mi(collapp_chall_raw)
replace collapp_chall_notready =. if mi(collapp_chall_raw)
replace collapp_chall_submit =. if mi(collapp_chall_raw)
replace collapp_chall_other =. if mi(collapp_chall_raw)

lab var collapp_chall_dna "Q26: did not apply to college"
lab var collapp_chall_none "Q26: did not face challenges"
lab var collapp_chall_noinfo "Q26: did nothave enough info"
lab var collapp_chall_dnu "Q26: did not understand questions on application"
lab var collapp_chall_course "Q26: trouble entering HS coursework"
lab var collapp_chall_miss "Q26: missing necessary coursework for eligibility"
lab var collapp_chall_fee "Q26: could not afford application fees"
lab var collapp_chall_deadline "Q26: missed application deadline"
lab var collapp_chall_notready "Q26: not academically ready for college"
lab var collapp_chall_submit "Q26: difficulty submitting other required items"
lab var collapp_chall_other "Q26: other (please specify)"

rename q26_10_text collapp_chall_other_text
label var collapp_chall_other_text "Q26: Free response for Other in college application challenges"

label define attend_coll_lab 0 "No" 1 "Yes" -1 "I don't know"
encode q27, generate(attend_coll) label(attend_coll_lab)
label var attend_coll "Q27: plan to attend college in the fall"
drop q27 

order coll_applied* collapp_chall* attend_coll, after(coll_factor_extra)


********** If not attending college ************
// Q29: what are your plans for this coming fall? select all that apply
rename q29 fall_plan_raw
label var fall_plan_raw "Q29: plans for coming fall"

gen fall_plan_workpt = (strpos(fall_plan_raw, "Work part-time") !=0)
gen fall_plan_workft = (strpos(fall_plan_raw, "Work full-time") !=0)
gen fall_plan_family = (strpos(fall_plan_raw, "Family obligations") !=0)
gen fall_plan_military = (strpos(fall_plan_raw, "Military") !=0)
gen fall_plan_other = (strpos(fall_plan_raw, "Other (please tell us):") !=0)

replace fall_plan_workpt =. if mi(fall_plan_raw)
replace fall_plan_workft =. if mi(fall_plan_raw)
replace fall_plan_family =. if mi(fall_plan_raw)
replace fall_plan_military =. if mi(fall_plan_raw)
replace fall_plan_other =. if mi(fall_plan_raw)

lab var fall_plan_workpt "Q29: work part time"
lab var fall_plan_workft "Q29: work full time"
lab var fall_plan_family "Q29: family obligations"
lab var fall_plan_military "Q29: military"
lab var fall_plan_other "Q29: other"

rename q29_5_text fall_plan_other_text
label var fall_plan_other_text "Q29: free response for fall plans: other"


// Q30: why won't you be attending college this fall? select all that apply
rename q30 why_no_coll_raw
label var why_no_coll_raw "Q30: why won't you attend college this fall"

gen why_no_coll_notforme = (strpos(why_no_coll_raw, "College is not for me") !=0)
gen why_no_coll_expensive = (strpos(why_no_coll_raw, "College is too expensive, even with financial aid") !=0)
gen why_no_coll_notworth = (strpos(why_no_coll_raw, "Going to college is not worth the cost") !=0)
gen why_no_coll_gapyear = (strpos(why_no_coll_raw, "Gap year/break before college") !=0)
gen why_no_coll_military = (strpos(why_no_coll_raw, "Military") !=0)
gen why_no_coll_health = (strpos(why_no_coll_raw, "Health reasons") !=0)
gen why_no_coll_work = (strpos(why_no_coll_raw, "I need to work") !=0)
gen why_no_coll_training = (strpos(why_no_coll_raw, "In another education or training program") !=0)
gen why_no_coll_other = (strpos(why_no_coll_raw, "Other (Please list)") !=0)

replace why_no_coll_notforme =. if mi(why_no_coll_raw)
replace why_no_coll_expensive =. if mi(why_no_coll_raw)
replace why_no_coll_notworth =. if mi(why_no_coll_raw)
replace why_no_coll_gapyear =. if mi(why_no_coll_raw)
replace why_no_coll_military =. if mi(why_no_coll_raw)
replace why_no_coll_health =. if mi(why_no_coll_raw)
replace why_no_coll_work =. if mi(why_no_coll_raw)
replace why_no_coll_training =. if mi(why_no_coll_raw)
replace why_no_coll_other =. if mi(why_no_coll_raw)

lab var why_no_coll_notforme "Q30: not for me"
lab var why_no_coll_expensive "Q30: too expensive"
lab var why_no_coll_notworth "Q30: Not worth the cost"
lab var why_no_coll_gapyear "Q30: gap year"
lab var why_no_coll_military "Q30: military"
lab var why_no_coll_health "Q30: health reasons"
lab var why_no_coll_work "Q30: need to work"
lab var why_no_coll_training "Q30: in another education/training program"
lab var why_no_coll_other "Q30: other"

rename q30_9_text why_no_coll_other_text
label var why_no_coll_other_text "Q30: why won't attend college this fall: other"

********* If IDK college ***********

// Q32: which of the following might influence your decision of whether or not to attend college? select all that apply
rename q32 coll_decision_raw
label var coll_decision_raw "Q32: which might influence decision to attend college"

gen coll_decision_financial = (strpos(coll_decision_raw, "Financial support") !=0)
lab var coll_decision_financial "Q32: financial support"
gen coll_decision_academic = (strpos(coll_decision_raw, "Academic support") !=0)
lab var coll_decision_academic "Q32: academic support"
gen coll_decision_family = (strpos(coll_decision_raw, "Family or other support") !=0)
lab var coll_decision_family "Q32: family or other support"

replace coll_decision_financial =. if mi(coll_decision_raw)
replace coll_decision_academic =. if mi(coll_decision_raw)
replace coll_decision_family =. if mi(coll_decision_raw)

order fall_plan_raw fall_plan_workpt - fall_plan_other fall_plan_other_text ///
    why_no_coll_raw why_no_coll_notforme - why_no_coll_other why_no_coll_other_text ///
    coll_decision_raw coll_decision_financial - coll_decision_family, after(attend_coll)

******** If yes to attend college ***********
encode q34, generate(where_attend_coll) label(where_attend_coll_lab)
label var where_attend_coll "Q34: where are you mostly likely to attend college this fall"
drop q34 
label def where_attend_coll_lab 1 "CCC" 2 "CSU" 3 "UC" 4 "Priv 4yr" 5 "Vocational" 6 "Outside CA" 7 "None of these" 8 "Not sure", modify
lab val where_attend_coll where_attend_coll_lab

rename q35 which_coll
label var which_coll "Q35: Which specific college are you mostly likely to attend"

order which_coll, after(where_attend_coll)

encode q36, generate(which_uc_campus) label(which_uc_campus_lab)
label var which_uc_campus "Q36: which campus are you most likely to attend (if UC)"
drop q36  

encode q37, generate(which_csu_campus) label(which_csu_campus_lab)
label var which_csu_campus "Q37: which campus are you mostly likely to attend (if CSU)"
drop q37 

label define how_sure_attend_lab 0 "unsure" 1 "Somewhat sure" 2 "Absolutely sure"
encode q38, generate(how_sure_attend) label(how_sure_attend_lab)
label var q38 "Q38: how sure are you that you will attend this school in the fall"
drop q38 

encode q40, generate(coll_contact) label(coll_contact_lab)
label var coll_contact "Q40: has any college contacted you about finaid"
drop q40

// Q42: what did the colleges contact you about regarding your financial aid offer? select all that apply
rename q42 coll_contact_subject_raw
label var coll_contact_subject_raw "Q42: what did the colleges contact you about regarding your finaid"

gen coll_contact_subject_doc = (strpos(coll_contact_subject_raw, "FAFSA/CADAA verification or additional documentation needed to process financial aid") !=0)
gen coll_contact_subject_work = (strpos(coll_contact_subject_raw, "Eligibility for work study") !=0)
gen coll_contact_subject_grant = (strpos(coll_contact_subject_raw, "Grants or scholarships") !=0)
gen coll_contact_subject_loan = (strpos(coll_contact_subject_raw, "Information about loans") !=0)

replace coll_contact_subject_doc =. if mi(coll_contact_subject_raw)
replace coll_contact_subject_work =. if mi(coll_contact_subject_raw)
replace coll_contact_subject_grant =. if mi(coll_contact_subject_raw)
replace coll_contact_subject_loan =. if mi(coll_contact_subject_raw)

lab var coll_contact_subject_doc "Q42: FAFSA/CADAA verification or additional documentation"
lab var coll_contact_subject_work "Q42: eligibility for work study"
lab var coll_contact_subject_grant "Q42: grants or scholarships"
lab var coll_contact_subject_loan "Q42: information about loans"

************ tools and factors in college selection ***********

label define helpful_source_lab -99 "Not Applicable" 0 "Not at all helpful" 1 "Somewhat helpful" 2 "Very helpful"
encode q45_1, generate(helpful_source_hs) label(helpful_source_lab)
label var helpful_source_hs "Q45: how helpful was HS counselors and teachers"
encode q45_2, generate(helpful_source_parent) label(helpful_source_lab)
label var helpful_source_parent "Q45: how helpful were parents"
encode q45_3, generate(helpful_source_family) label(helpful_source_lab)
label var helpful_source_family "Qrt: how helpful were family members"
encode q45_4, generate(helpful_source_friend) label(helpful_source_lab)
label var helpful_source_friend "Q45: how helpful were friends"
encode q45_5, generate(helpful_source_social) label(helpful_source_lab)
label var helpful_source_social "Q45: how helpful was social media"
encode q45_6, generate(helpful_source_college) label(helpful_source_lab)
label var helpful_source_college "Q45: how helpful were college website/staff"
encode q45_7, generate(helpful_source_private) label(helpful_source_lab)
label var helpful_source_private "Q45: how helpful was private college counselor"
drop q45_?

// Q47: Which of these social media platforms did you use to find college or financial aid information? (Select all that apply)
rename q47 social_raw
label var social_raw "Q47: which social media platform did you use"

rename q47_7_text social_other_text
label var social_other_text "Q47: free response for which social media platform: other"

order social_raw social_other_text, after(helpful_source_private)

gen social_reddit = (strpos(social_raw, "Reddit") !=0)
gen social_fb = (strpos(social_raw, "Facebook") != 0)
gen social_yt = (strpos(social_raw, "YouTube")!=0)
gen social_tiktok = (strpos(social_raw, "TikTok") != 0)
gen social_insta = (strpos(social_raw, "Instagram") != 0)
gen social_twitter = (strpos(social_raw, "Twitter/X") != 0)
gen social_other = (strpos(social_raw, "Other (please list):") != 0)

replace social_reddit =. if mi(social_raw)
replace social_fb =. if mi(social_raw)
replace social_yt =. if mi(social_raw)
replace social_tiktok =. if mi(social_raw)
replace social_insta =. if mi(social_raw)
replace social_twitter =. if mi(social_raw)
replace social_other =. if mi(social_raw)

lab var social_reddit "Q47: Reddit"
lab var social_fb "Q47: Facebook"
lab var social_yt "Q47: YouTube"
lab var social_tiktok "Q47: TikTok"
lab var social_insta "Q47: Instagram"
lab var social_twitter "Q47: Twitter"
lab var social_other "Q47: Other (please list)"

// Q49: Who helped you fill out your college application(s)? (Select all that apply)
rename q49 help_raw
label var help_raw "Q49: Who helped fill out college app"

order help_raw, after(social_other)

gen help_parent = (strpos(help_raw, "Parent(s)") != 0)
gen help_family = (strpos(help_raw, "Family members other than a parent") != 0)
gen help_teacher = (strpos(help_raw, "Teacher") != 0)
gen help_collstsaff = (strpos(help_raw, "Staff at my future college") != 0)
gen help_privcounselor = (strpos(help_raw, "College counselor or consultant hired by my family") != 0)
gen help_hscounselor = (strpos(help_raw, "High school counselor") != 0)
gen help_other = (strpos(help_raw, "Other members of my community") != 0)
gen help_self = (strpos(help_raw, "I did it myself") != 0)

replace help_parent =. if mi(help_raw)
replace help_family =. if mi(help_raw)
replace help_teacher =. if mi(help_raw)
replace help_collstsaff =. if mi(help_raw)
replace help_privcounselor =. if mi(help_raw)
replace help_hscounselor =. if mi(help_raw)
replace help_other =. if mi(help_raw)
replace help_self =. if mi(help_raw)

label var help_parent "Q49: Parents"
label var help_family "Q49: family other than parent"
label var help_teacher "Q49: teacher"
label var help_collstsaff "Q49: staff at future college"
label var help_privcounselor "Q49: private counselor"
label var help_hscounselor "Q49: HS counselor"
label var help_other "Q49: other member of community"
label var help_self "Q49: did it myself"

// Q50: Which of the following resources did you use when planning for college? (Select all that apply)
rename q50 resrc_raw
label var resrc_raw "Q50: Resources used when planning for college"

order resrc_raw, after(help_self)

gen resrc_finaidtool = (strpos(resrc_raw, "Financial aid tools") != 0)
gen resrc_website = (strpos(resrc_raw, "College websites") != 0)
gen resrc_comptool = (strpos(resrc_raw, "College comparison tools") != 0)
gen resrc_agtool = (strpos(resrc_raw, "a-g course eligibility tools") != 0)
gen resrc_apptool = (strpos(resrc_raw, "College application tools") != 0)
gen resrc_essaytool = (strpos(resrc_raw, "College essay writing tools") != 0)
gen resrc_counselor = (strpos(resrc_raw, "Private college counselor/consultant") != 0)
gen resrc_other = (strpos(resrc_raw, "Other (please specify)") != 0)

replace resrc_finaidtool =. if mi(resrc_raw)
replace resrc_website =. if mi(resrc_raw)
replace resrc_comptool =. if mi(resrc_raw)
replace resrc_agtool =. if mi(resrc_raw)
replace resrc_apptool =. if mi(resrc_raw)
replace resrc_essaytool =. if mi(resrc_raw)
replace resrc_counselor =. if mi(resrc_raw)
replace resrc_other =. if mi(resrc_raw)

lab var resrc_finaidtool "Q50: financial aid tools"
lab var resrc_website "Q50: college website"
lab var resrc_comptool "Q50: college comparison tools"
lab var resrc_agtool "Q50: a-g course eligibility tools"
lab var resrc_apptool "Q50: college application tools"
lab var resrc_essaytool "Q50: college essay writing tools"
lab var resrc_counselor "Q50: private college counselor"
lab var resrc_other "Q50: other, please specify"

rename q50_8_text resrc_other_text
label var resrc_other_text "Q50: free response for resources when planning for college: other"

rename q51 what_make_app_easier
label var what_make_app_easier "Q51: what would have made coll app easier"

order resrc_other_text what_make_app_easier, after(resrc_other)

*********** College experience expectation ***********
rename q54 pay_plan_raw
label var pay_plan_raw "Q54: how do you plan to pay college tuition and fees"

order pay_plan_raw, after(what_make_app_easier)

gen pay_plan_scholarship = (strpos(pay_plan_raw, "Scholarships") !=0) if !mi(pay_plan_raw)
gen pay_plan_grant = (strpos(pay_plan_raw, "Grants (e.g., Pell Grant, Cal Grant)") !=0) if !mi(pay_plan_raw)
gen pay_plan_saving = (strpos(pay_plan_raw, "My own savings") !=0) if !mi(pay_plan_raw)
gen pay_plan_work = (strpos(pay_plan_raw, "Working while enrolled") !=0) if !mi(pay_plan_raw)
gen pay_plan_otherppl = (strpos(pay_plan_raw, "Money from other people (e.g., parents, family, and friends)") !=0) if !mi(pay_plan_raw)
gen pay_plan_loan = (strpos(pay_plan_raw, "Student loans") !=0) if !mi(pay_plan_raw)
gen pay_plan_va = (strpos(pay_plan_raw, "Military/VA benefits") !=0) if !mi(pay_plan_raw)
gen pay_plan_credit = (strpos(pay_plan_raw, "Credit card(s)") !=0) if !mi(pay_plan_raw)

lab var pay_plan_scholarship "Q54: scholarships"
lab var pay_plan_grant "Q54: grants"
lab var pay_plan_saving "Q54: my own savings"
lab var pay_plan_work "Q54: working while enrolled"
lab var pay_plan_otherppl "Q54: money from other people"
lab var pay_plan_loan "Q54: student loans"
lab var pay_plan_va "Q54: military/VA benefits"
lab var pay_plan_credit "Q54: credit cards"

order pay_plan_raw, before(pay_plan_scholarship)

// Q55: what are you most likely to study in college? this is select all that apply
/* 
encode q55, generate(major) label(major_lab) 
label var major "Q55: what are you most likely to study in college"
drop q55 */


rename q55 major_raw 
lab var major_raw "Q55: what are you most likely to study in college"

gen major_business = (strpos(major_raw, "Business") !=0) if !mi(major_raw)
gen major_engineering = (strpos(major_raw, "Engineering") !=0) if !mi(major_raw)
gen major_science = (strpos(major_raw, "Natural sciences (e.g., biology, chemistry, physics)") !=0) if !mi(major_raw)
gen major_social = (strpos(major_raw, "Social sciences (e.g., psychology, sociology, economics)") !=0) if !mi(major_raw)
gen major_humanity = (strpos(major_raw, "Humanities & Arts (e.g., English, History, Arts)") !=0) if !mi(major_raw)
gen major_health = (strpos(major_raw, "Health sciences") !=0) if !mi(major_raw)
gen major_education = (strpos(major_raw, "Education") !=0) if !mi(major_raw)
gen major_applied = (strpos(major_raw, "Applied sciences (e.g., automotive repair, HVAC, construction)") !=0) if !mi(major_raw)
gen major_service = (strpos(major_raw, "Public service (e.g., criminal justice, fire science)") !=0) if !mi(major_raw)
gen major_undecided = (strpos(major_raw, "Undecided") !=0) if !mi(major_raw)


lab var major_business "Q55: Business"
lab var major_engineering "Q55: Engineering"
lab var major_science "Q55: Natural Scinces"
lab var major_social "Q55: Social Sciences"
lab var major_humanity "Q55: Humanities and Arts"
lab var major_health "Q55: Health Sciences"
lab var major_education "Q55: Education"
lab var major_applied "Q55: Applied Sciences"
lab var major_service "Q55: Public Service"
lab var major_undecided "Q55: Undecided"

order major_raw, before(major_business)

lab define highest_degree_lab 1 "Get a certificate in a vocational or technical field" ///
    2 "Associate degree  (AA/AS/ADT)" 3 "Bachelor’s Degree (BA/BS)" ///
    4 "Master’s Degree (MA/MS)" 5 "Doctoral Degree (Ph.D., M.D., J.D., etc.)" ///
    6 "I'm unsure"
encode q56, generate(highest_degree) label(highest_degree_lab)
label var highest_degree "Q56: highest degree you hope to earn"
drop q56 

// q58 is already recoded
label define coll_worry_lab 0 "Not at all worried" 1 "Somewhat worried" 2 "Very worried"
foreach var of varlist tuition-support {
    encode `var', generate(coll_worry_`var') label(coll_worry_lab)
    label var coll_worry_`var' "Q58: worry about college"
}

order coll_worry_tuition-coll_worry_support, after(highest_degree)

*********** High School Experience ************
encode q61, generate(hs_type) label(hs_type_lab)
label var hs_type "Q61: type of HS you are graduating from"
drop q61

label define complete_atog_lab -1 "Not sure" 0 "No" 1 "Yes"
encode q62, generate(complete_atog) label(complete_atog_lab)
label var complete_atog "Q62: are you on track to complete a-g"
drop q62 

encode q63, generate(track_atog) label(track_atog_lab)
label var track_atog "Q63: how difficult was it to keep track of a-g progress"
drop q63 

// Q64: Why are you not on track to complete a-g? select all that apply 
rename q64 why_no_atog_raw
label var why_no_atog_raw "Q64: why not on track to complete a-g"

gen why_no_atog_notrequired = (strpos(why_no_atog_raw, "They were not required for the college I plan to attend") !=0) if !mi(why_no_atog_raw)
gen why_no_atog_unknown = (strpos(why_no_atog_raw, "I did not know about the requirements") !=0) if !mi(why_no_atog_raw)
gen why_no_atog_nocourse = (strpos(why_no_atog_raw, "My high school did not offer the necessary courses") !=0) if !mi(why_no_atog_raw)
gen why_no_atog_lowgrade = (strpos(why_no_atog_raw, "My grades were too low in some of the required courses") !=0) if !mi(why_no_atog_raw)
gen why_no_atog_nocollege = (strpos(why_no_atog_raw, "I am not planning on attending college") !=0) if !mi(why_no_atog_raw)
gen why_no_atog_other = (strpos(why_no_atog_raw, "Other (please specify):") !=0) if !mi(why_no_atog_raw)

lab var why_no_atog_notrequired "Q64: not required for the college I plan to attend"
lab var why_no_atog_unknown "Q64: didn't know about the requirements"
lab var why_no_atog_nocourse "Q64: my HS didn't offer necessary courses"
lab var why_no_atog_lowgrade "Q64: My grades were too low in some required courses"
lab var why_no_atog_nocollege "Q64: I am not planning to attend college"
lab var why_no_atog_other "Q64: Other"

rename q64_6_text why_no_atog_other_text

order why_no_atog_raw why_no_atog_other_text, after(why_no_atog_other)

label define de_lab -1 "Not sure" 0 "No" 1 "Yes"
encode q66, generate(de) label(de_lab)
label var de "Q66: did you take college courses in HS"
drop q66 

// Q67: Why did you take these dual enrollment courses? (Select all that apply)
rename q67 why_de_raw
label var why_de_raw "Q67: why did you take dual enrollment courses"

gen why_de_class = (strpos(why_de_raw, "To take classes not offered by my school") !=0) if !mi(why_de_raw)
gen why_de_college = (strpos(why_de_raw, "To improve my chances of getting in a more selective college") !=0) if !mi(why_de_raw)
gen why_de_reduce = (strpos(why_de_raw, "To reduce the number of courses I need to take in college") !=0) if !mi(why_de_raw)
gen why_de_trade = (strpos(why_de_raw, "To be ready for a trade or job after high school") !=0) if !mi(why_de_raw)
gen why_de_other = (strpos(why_de_raw, "Other (please explain)") !=0) if !mi(why_de_raw)

lab var why_de_class "Q67: take classes not offered by my school"
lab var why_de_college "Q67: improve chance of getting into selective college"
lab var why_de_reduce "Q67: reduce number of courses needed in college"
lab var why_de_trade "Q67: to be ready for a trade or job after HS"
lab var why_de_other "Q67: other"

rename q67_5_text why_de_other_text
label var why_de_other_text "Q67: why did you take dual enrollment: other"

order why_de_raw why_de_other_text, after(why_de_other)

label define de_atog_lab -1 "Not sure" 0 "No" 1 "Yes"
encode q68, g(de_atog) l(de_atog_lab)
label var de_atog "Q68: did you use any dual enroll courses to satisfy a-g for CSU/UC"
drop q68 

encode q69, g(transcript_atog) l(transcript_atog_lab)
label var transcript_atog "Q69: how difficult to add DE coursework to transcript"
drop q69


************ Demographics *************

//-----------------------------
// race
//------------------------------
rename q72 race_raw
gen black = 1 if strpos(race_raw, "Black/African American") !=0
replace black = 0 if strpos(race_raw, "Black/African American") ==0 & !mi(race_raw)
label var black "selected Black"

gen native = 1 if strpos(race_raw, "American Indian/Alaskan Native") != 0
replace native = 0 if strpos(race_raw, "American Indian/Alaskan Native") == 0 & !mi(race_raw)
label var native "selected American Indian/Alaskan Native"

gen asian = 1 if strpos(race_raw, "Asian") != 0
replace asian = 0 if strpos(race_raw, "Asian") ==0 & !mi(race_raw)
label var asian "selected Asian"

gen filipino = 1 if strpos(race_raw, "Filipino") !=0
replace filipino = 0 if strpos(race_raw, "Filipino") == 0 & !mi(race_raw)
label var filipino "selected Filipino"

gen hispanic = 1 if strpos(race_raw, "Hispanic/Latinx") != 0
replace hispanic = 0 if strpos(race_raw, "Hispanic/Latinx") == 0 & !mi(race_raw)
label var hispanic "selected Hispanic"

gen islander = 1 if strpos(race_raw, "Pacific Islander") !=0
replace islander = 0 if strpos(race_raw, "Pacific Islander") ==0 & !mi(race_raw)
label var islander "selected Pacific Islander"

gen white = 1 if strpos(race_raw, "White/Non-Hispanic") !=0
replace white = 0 if strpos(race_raw, "White/Non-Hispanic") ==0 & !mi(race_raw)
label var white "selected White/Non-Hispanic"

// if other race was selected 
gen other_race = 1 if strpos(race_raw, "Other (Please specify):") !=0 
replace other_race = 0 if strpos(race_raw, "Other (Please specify):") ==0 & !mi(race_raw)
     /* & (black == 0) & (native == 0) & (asian == 0) & (filipino == 0) ///
     & (hispanic == 0) & (islander == 0) & (white == 0)) */
label var other_race "selected Other race"

rename q72_8_text other_race_text
label var other_race_text "Q72: free response for race/ethnicity: other"

// limit mutlirace to people who chose two or more from predefined options 
gen numrace = 0
foreach v of varlist black-other_race {
    replace numrace = numrace + `v'
}

************** simple mutually exclusive race, 2024 version
// differs from 2023 version in how multirace is defined
label define race_simple_lab 1 "Black" 2 "Native" 3 "Asian" 4 "Filipino" ///
    5 "Hispanic" 6 "Pacific Islander" 7 "White" 8 "Other Race" ///
    9 "Multiracial" 
gen race_simple_24 = .

// select only black, native, etc. 
replace race_simple_24 = 1 if black == 1 & numrace == 1
replace race_simple_24 = 2 if native == 1 & numrace == 1
replace race_simple_24 = 3 if asian == 1 & numrace == 1
replace race_simple_24 = 4 if filipino == 1 & numrace == 1
replace race_simple_24 = 5 if hispanic == 1 & numrace == 1
replace race_simple_24 = 6 if islander == 1 & numrace == 1
replace race_simple_24 = 7 if white == 1 & numrace == 1
replace race_simple_24 = 8 if other_race == 1 & numrace == 1
// select 1 predefined and other race
replace race_simple_24 = 1 if black == 1 & other_race == 1 & numrace == 2 
replace race_simple_24 = 2 if native == 1 & other_race == 1 & numrace == 2 
replace race_simple_24 = 3 if asian == 1 & other_race == 1 & numrace == 2 
replace race_simple_24 = 4 if filipino == 1 & other_race == 1 & numrace == 2 
replace race_simple_24 = 5 if hispanic == 1 & other_race == 1 & numrace == 2 
replace race_simple_24 = 6 if islander == 1 & other_race == 1 & numrace == 2 
replace race_simple_24 = 7 if white == 1 & other_race == 1 & numrace == 2 
// multiracial
// select 2 or more predefined options 
replace race_simple_24 = 9 if (inrange(numrace, 2, 8) & other_race == 0) ///
    | (inrange(numrace, 3, 8) & other_race == 1)
label values race_simple_24 race_simple_lab
label var race_simple_24 "race narrowly defined (mutually exclusive), 2024 version"

************** simple mutually exclusive race, 2023 version
gen race_simple_23 = .
label var race_simple_23 "mutually exclusive race, 2023 version"
replace race_simple_23 = race_simple_24 if numrace == 1
replace race_simple_23 = 9 if inrange(numrace, 2, 8)
lab val race_simple_23 race_simple_lab


************** mututally exclusive race based on URM hierarchy, same as 2023 version
gen race_hrchy = .
lab var race_hrchy "mutually exclusive race based on URM hierarchy"
// initiate numerical value for category
local j = 8
foreach cat in white other_race asian filipino islander hispanic black native {
    replace race_hrchy = `j' if `cat' == 1
    // copy the value label from the dummies
    local varlab: var lab `cat'
    // remove unused part of string, keep only the race
    local varlab = subinstr("`varlab'", "selected ", "", 1)
    // update value label
    lab define race_hrchy_lab `j' "`varlab'", add 
    // update numerical category
    local j = `j' - 1
}
label values race_hrchy race_hrchy_lab


order race_raw other_race_text black-other_race numrace race_simple_24, after(transcript_atog)

// parent education
label define parent_edu_lab 1 "Don't know" 2 "Did not complete high school" ///
    3 "High school diploma" 4 "Some college, no college degree" ///
    5 "Associate degree" 6 "Bachelor's degree" ///
    7 "Graduate/Professional degree beyond Bachelor's degree (Master's, PhD, JD, MD, etc.)"
encode q73, g(parent_edu) l(parent_edu_lab)
label var parent_edu "Q73: highest parent education"
drop q73 


label define home_lang_eng_lab 0 "No" 1 "Yes"
encode q76, g(home_lang_eng) l(home_lang_eng_lab)
label var home_lang_eng "Q76: Is English primary language at home"
drop q76 

rename q78 home_lang_other
label var home_lang_other "Q78: what language was primarily spoken at home"

order home_lang_other, after(home_lang_eng)

label define has_job_lab 0 "No" 1 "Yes"
encode q80, g(has_job) l(has_job_lab)
label var has_job "Q80: current has a job"
drop q80 

encode q81, g(hours_perweek) l(hours_perweek_lab)
label var hours_perweek "Q81: how many hours a week do you work"
drop q81 


// gender 
rename q83 gender_raw 

label define gender_lab 0 "Man" 1 "Woman" 2 "Non-binary" 3 "Prefer not to say" 4 "Other (please feel free to specify)"
encode gender_raw, g(gender) l(gender_lab)

rename q83_5_text gender_other_text
label var gender_other_text "Free response for gender: other"

label define interview_lab 0 "No" 1 "Yes"
encode q85, g(interview) l(interview_lab)
label var interview "Q85: interested in future interview"
drop q85 

rename q87 interview_email 
replace interview_email = strlower(strtrim(interview_email))
label var interview_email "Q87: email for future interview"

order gender_raw gender_other_text gender interview interview_email, after(hours_perweek)

************* open ended college expectations ***************
rename q90 coll_excite
label var coll_excite "Q90: what excites you most about college"

rename q92 coll_challenge 
label var coll_challenge "Q92: biggest challenge you will face in college"

order coll_excite coll_challenge, after(interview_email)

compress 
save $projdir/dta/csac_2024_initial_clean.dta, replace 


log close 
translate $projdir/log/clean/clean_qualtrics_download.smcl ///
    $projdir/log/clean/clean_qualtrics_download.log, replace 