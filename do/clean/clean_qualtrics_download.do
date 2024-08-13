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
import delimited "$rawdtadir/CSAC_2024_Senior_Survey_August 2, 2024_12.04.csv", varnames(1) clear 


//---------------------------------------------------------------
// initial cleaning
// do not encode select all that apply questions
//---------------------------------------------------------------
// drop header rows
drop if _n==1 | _n==2
// drop empty system variables
drop recipient*name recipientemail externalreference

drop distributionchannel  
drop *click* *pagesubmit

// rename and recode variables 
encode q4, generate(ready_to_start) label(ready_to_start_lab)
label var ready_to_start "Q4: Ready to start survey or show more info"
drop q4

// remove leading and trailing spaces and convert to lower case
replace q6 = strlower(strtrim(q6))
rename q6 email 

label define hs_senior_lab 0 "No" 1 "Yes"
encode q8, generate(hs_senior) label(hs_senior_lab)
label var hs_senior "W8: Graduated HS in spring or summer 2024"
drop q8

*********** FAFSA*********

rename q11 why_fafsa 
label var why_fafsa "W11: Reason for completing FAFSA or CADAA"

rename q11_5_text why_fafsa_other
replace why_fafsa_other = strlower(strtrim(why_fafsa_other))
label var why_fafsa_other "W11: Free response for why completed FAFSA or CADAA"

encode q12, generate(when_heard_fafsa) label(when_heard_fafsa_lab)
label var when_heard_fafsa "W12: When did you first hear about FAFSA or CADAA"
drop q12 

encode q14, generate(difficulty_apply_finaid) label(difficulty_apply_finaid_lab)
label var difficulty_apply_finaid "Q14: How difficult was applying for financial aid"
drop q14

rename q15 apply_finaid_challenge
label var apply_finaid_challenge "Q15: challenges you faced applying to FAFSA/CADAA"

rename q15_9_text apply_finaid_challenge_other 
replace apply_finaid_challenge_other = strlower(strtrim(apply_finaid_challenge_other))
label var apply_finaid_challenge_other "Q15: Free response for challenges faced applying to FAFSA/CADAA"

rename q16 support_received
label var support_received "Q16: Support received when applying for FAFSA/CADAA"

order why_fafsa why_fafsa_other when_heard_fafsa difficulty_apply_finaid apply_finaid_challenge apply_finaid_challenge_other support_received, after(hs_senior)

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

rename q22 coll_factor_other 
label var coll_factor_other "Q22: what other factors should be considered in coll app"

rename q25 colleges_applied
label var colleges_applied "Q25: What colleges or universities did you apply to"

rename q26 coll_app_challenges
label var coll_app_challenges "Q26: challenges applying to college/trade school"

rename q26_10_text coll_app_challenges_other
label var coll_app_challenges_other "Q26: Free response for Other in college application challenges"

order coll_factor_other colleges_applied coll_app_challenges coll_app_challenges_other, after(coll_factor_extra)

label define attend_coll_lab 0 "No" 1 "Yes" -1 "I don't know"
encode q27, generate(attend_coll) label(attend_coll_lab)
label var attend_coll "Q27: plan to attend college in the fall"
drop q27 


********** If not attending college ************
rename q29 fall_plan
label var fall_plan "Q29: plans for coming fall"

rename q29_5_text fall_plan_other
label var fall_plan_other "Q29: free response for fall plans: other"

rename q30 why_no_coll
label var why_no_coll "Q30: why won't you attend college this fall"

rename q30_9_text why_no_coll_other 
label var why_no_coll_other "Q30: why won't attend college this fall: other"

********* If IDK college ***********
rename q32 coll_decision_inf
label var coll_decision_inf "Q32: which might influence decision to attend college"


order fall_plan - coll_decision_inf, after(attend_coll)

******** If yes to attend college ***********
encode q34, generate(where_attend_coll) label(where_attend_coll_lab)
label var where_attend_coll "Q34: where are you mostly likely to attend college this fall"
drop q34 

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

encode q42, generate(coll_contact_subject) label(coll_contact_subject_lab)
label var coll_contact_subject "Q42: what did the colleges contact you about regarding your finaid"
drop q42 

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


rename q47 social_platform
label var social_platform "Q47: which social media platform did you use"

rename q47_7_text social_platform_other
label var social_platform_other "Q47: free response for which social media platform: other"

order social_platform social_platform_other, after(helpful_source_private)

gen social_reddit = (strpos(social_platform, "Reddit") !=0)
gen social_fb = (strpos(social_platform, "Facebook") != 0)
gen social_yt = (strpos(social_platform, "YouTube")!=0)
gen social_tiktok = (strpos(social_platform, "TikTok") != 0)
gen socila_insta = (strpos(social_platform, "Instagram") != 0)
gen social_twitter = (strpos(social_platform, "Twitter/X") != 0)
gen social_other = (strpos(social_platform, "Other (please list):") != 0)

rename q49 help
label var help "Q49: Who helped fill out college app"

order help, after(social_other)

gen help_parent = (strpos(help, "Parent(s)") != 0)
gen help_family = (strpos(help, "Family members other than a parent") != 0)
gen help_teacher = (strpos(help, "Teacher") != 0)
gen help_collstsaff = (strpos(help, "Staff at my future college") != 0)
gen help_privcounselor = (strpos(help, "College counselor or consultant hired by my family") != 0)
gen help_hscounselor = (strpos(help, "High school counselor") != 0)
gen help_other = (strpos(help, "Other members of my community") != 0)
gen help_self = (strpos(help, "I did it myself") != 0)

label var help_parent "Q49: Parents"
label var help_family "Q49: family other than parent"
label var help_teacher "Q49: teacher"
label var help_collstsaff "Q49: staff at future college"
label var help_privcounselor "Q49: private counselor"
label var help_hscounselor "Q49: HS counselor"
label var help_other "Q49: other member of community"
label var help_self "Q49: did it myself"


rename q50 resrc
label var resrc "Q50: Resources used when planning for college"

order resrc, after(help_self)

gen resrc_finaidtool = (strpos(resrc, "Financial aid tools") != 0)
gen resrc_website = (strpos(resrc, "College websites") != 0)
gen resrc_comptool = (strpos(resrc, "College comparison tools") != 0)
gen resrc_agtool = (strpos(resrc, "a-g course eligibility tools") != 0)
gen resrc_apptool = (strpos(resrc, "College application tools") != 0)
gen resrc_essaytool = (strpos(resrc, "College essay writing tools") != 0)
gen resrc_privcounselor = (strpos(resrc, "Private college counselor/consultant") != 0)
gen resrc_other = (strpos(resrc, "Other (please specify)") != 0)


rename q50_8_text resrc_other_text
label var resrc_other_text "Q50: free response for resources when planning for college: other"

rename q51 what_make_app_easier
label var what_make_app_easier "Q51: what would have made coll app easier"

order resrc_other_text what_make_app_easier, after(resrc_other)

*********** College experience expectation ***********
rename q54 how_to_pay
label var how_to_pay "Q54: how do you plan to pay college tuition and fees"

order how_to_pay, after(what_make_app_easier)

encode q55, generate(major) label(major_lab) 
label var major "Q55: what are you most likely to study in college"
drop q55

encode q56, generate(highest_degree) label(highest_degree_lab)
label var highest_degree "Q56: highest degree you hope to earn"
drop q56 

// q58 is already recoded
label define coll_worry_lab 0 "Not at all worried" 1 "Somewhat worried" 2 "Very worried"
foreach var of varlist tuition-support {
    encode `var', generate(coll_worry_`var') label(coll_worry_lab)
    label var coll_worry_`var' "Q58: worry about college"
}

order tuition-support, after(highest_degree)

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

rename q64 why_no_atog
label var why_no_atog "Q64: why not on track to complete a-g"

label define dual_enr_lab -1 "Not sure" 0 "No" 1 "Yes"
encode q66, generate(dual_enr) label(dual_enr_lab)
label var dual_enr "Q66: did you take college courses in HS"
drop q66 

rename q67 why_dual_enr 
label var why_dual_enr "Q67: why did you take dual enrollment courses"

rename q67_5_text why_dual_enr_other
label var why_dual_enr_other "Q67: why did you take dual enrollment: other"

label define dual_enr_atog_lab -1 "Not sure" 0 "No" 1 "Yes"
encode q68, g(dual_enr_atog) l(dual_enr_atog_lab)
label var dual_enr_atog "Q68: did you use any dual enroll courses to satisfy a-g for CSU/UC"
drop q68 

encode q69, g(transcript_atog) l(transcript_atog_lab)
label var transcript_atog "Q69: how difficult to add DE coursework to transcript"
drop q69

order why_no_atog-why_dual_enr_other, after(track_atog)

************ Demographics *************

// race
rename q72 race_raw
gen black = 1 if strpos(race_raw, "Black/African American") !=0
replace black = 0 if strpos(race_raw, "Black/African American") ==0 & !mi(race_raw)

gen native = 1 if strpos(race_raw, "American Indian/Alaskan Native") != 0
replace native = 0 if strpos(race_raw, "American Indian/Alaskan Native") == 0 & !mi(race_raw)

gen asian = 1 if strpos(race_raw, "Asian") != 0
replace asian = 0 if strpos(race_raw, "Asian") ==0 & !mi(race_raw)

gen filipino = 1 if strpos(race_raw, "Filipino") !=0
replace filipino = 0 if strpos(race_raw, "Filipino") == 0 & !mi(race_raw)

gen hispanic = 1 if strpos(race_raw, "Hispanic/Latinx") != 0
replace hispanic = 0 if strpos(race_raw, "Hispanic/Latinx") == 0 & !mi(race_raw)

gen islander = 1 if strpos(race_raw, "Pacific Islander") !=0
replace islander = 0 if strpos(race_raw, "Pacific Islander") ==0 & !mi(race_raw)

gen white = 1 if strpos(race_raw, "White/Non-Hispanic") !=0
replace white = 0 if strpos(race_raw, "White/Non-Hispanic") ==0 & !mi(race_raw)

// count as other race only if no predefined option was selected
gen other_race = (strpos(race_raw, "Other (Please specify):") !=0 ///
     & (black == 0) & (native == 0) & (asian == 0) & (filipino == 0) ///
     & (hispanic == 0) & (islander == 0) & (white == 0))

rename q72_8_text other_race_text
label var other_race_text "Q72: free response for race/ethnicity: other"

// limit mutlirace to people who chose two or more from predefined options 
gen numrace = 0
foreach v of varlist black-white {
    replace numrace = numrace + `v'
}
gen multirace = (numrace >= 2)

label define race_lab 1 "Black" 2 "Native" 3 "Asian" 4 "Filipino" 5 "Hispanic" 6 "Pacific Islander" 7 "White" 8 "Other Race" 9 "Multiracial"
gen race = .

replace race = 8 if other_race == 1 & multirace == 0 

replace race = 1 if black == 1 & multirace == 0
replace race = 2 if native == 1 & multirace == 0
replace race = 3 if asian == 1 & multirace == 0
replace race = 4 if filipino == 1 & multirace == 0
replace race = 5 if hispanic == 1 & multirace == 0
replace race = 6 if islander == 1 & multirace == 0
replace race = 7 if white == 1 & multirace == 0

replace race = 9 if multirace == 1
label values race race_lab
label var race "cleaned race, this is a partition"

order race_raw other_race_text black-other_race numrace multirace race, after(transcript_atog)

// parent education
label define parent_edu_lab 0 "Don't know"
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

rename q83_5_text gender_other 
label var gender_other "Free response for gender: other"

label define interview_lab 0 "No" 1 "Yes"
encode q85, g(interview) l(interview_lab)
label var interview "Q85: interested in future interview"
drop q85 

rename q87 interview_email 
replace interview_email = strlower(strtrim(interview_email))
label var interview_email "Q87: email for future interview"

order gender_raw gender_other gender interview interview_email, after(hours_perweek)

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