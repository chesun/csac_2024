/* macros for the project */

#delimit ;

// question macros ;
local all_qnums 
    8 
    11 12 14 15 16 
    18 19 
    21 25 26 27 
    29 30 32 
    34 36 37 38 40 42 
    45 47 49 50 
    54 55 56 58 
    61 62 63 64 66 67 68 69
    76 80 81
    ;

local q8_subqs
    hs_senior
    ;
local q11_subqs
    why_fafsa_requirement why_fafsa_assignment why_fafsa_eligible
    why_fafsa_expected why_fafsa_other
    ;
local q12_subqs
    when_heard_fafsa
    ;
local q14_subqs
    difficulty_apply_finaid
    ;
local q15_subqs
    finaid_challenge_tech finaid_challenge_doc finaid_challenge_invite 
    finaid_challenge_multi finaid_challenge_confusing finaid_challenge_nohelp
    finaid_challenge_info finaid_challenge_whichapp
    finaid_challenge_none finaid_challenge_other
    ;
local q16_subqs 
    support_received_counselor support_received_teacher 
    support_received_hsworkshop support_received_cmworkshop
    support_received_parent support_received_family
    support_received_friend support_received_online
    support_received_nobody
    ;
local q18_subqs
    coll_att_3pt_important coll_att_3pt_worth coll_att_3pt_ready
    ;
local q19_subqs
    coll_att_5pt_important coll_att_5pt_worth coll_att_5pt_ready
    ;
local q21_subqs 
    coll_factor_gpa coll_factor_score coll_factor_service 
    coll_factor_firstgen coll_factor_extra
    ;
local q25_subqs
    coll_applied_ccc coll_applied_csu coll_applied_uc
    coll_applied_priv4yr coll_applied_vocation coll_applied_outside
    coll_applied_notsure coll_applied_none
    ;
local q26_subqs
    collapp_chall_dna collapp_chall_none collapp_chall_noinfo
    collapp_chall_dnu collapp_chall_course collapp_chall_miss
    collapp_chall_fee collapp_chall_deadline collapp_chall_notready
    collapp_chall_submit collapp_chall_other
    ;
local q27_subqs
    attend_coll
    ;
local q29_subqs
    fall_plan_workpt fall_plan_workft fall_plan_family
    fall_plan_military fall_plan_other
    ;
local q30_subqs
    why_no_coll_notforme why_no_coll_expensive why_no_coll_notworth
    why_no_coll_gapyear why_no_coll_military why_no_coll_health
    why_no_coll_work why_no_coll_training why_no_coll_other
    ;
local q32_subqs
    coll_decision_financial coll_decision_academic coll_decision_family
    ;
local q34_subqs
    where_attend_coll
    ;
local q36_subqs
    which_uc_campus
    ;
local q37_subqs
    which_csu_campus
    ;
local q38_subqs
    how_sure_attend
    ;
local q40_subqs 
    coll_contact
    ;
local q42_subqs
    coll_contact_subject_doc coll_contact_subject_work 
    coll_contact_subject_grant coll_contact_subject_loan
    ;
local q45_subqs
    helpful_source_hs helpful_source_parent
    helpful_source_family helpful_source_friend
    helpful_source_social helpful_source_college
    helpful_source_private
    ;
local q47_subqs
    social_reddit social_fb social_yt
    social_tiktok social_insta social_twitter 
    social_other
    ;
local q49_subqs
    help_parent help_family help_teacher
    help_collstsaff help_privcounselor help_hscounselor
    help_other help_self
    ;
local q50_subqs
    resrc_finaidtool resrc_website resrc_comptool
    resrc_agtool resrc_apptool resrc_essaytool
    resrc_counselor resrc_other
    ;
local q54_subqs 
    pay_plan_scholarship pay_plan_grant 
    pay_plan_saving pay_plan_work
    pay_plan_otherppl pay_plan_loan
    pay_plan_va pay_plan_credit
    ;
local q55_subqs
    major_business major_engineering major_science
    major_social major_humanity major_health
    major_education major_applied major_service 
    major_undecided
    ;
local q56_subqs
    highest_degree
    ;
local q58_subqs
    coll_worry_tuition coll_worry_living coll_worry_academic
    coll_worry_work coll_worry_family coll_worry_community
    coll_worry_living_away coll_worry_support
    ;
local q61_subqs 
    hs_type
    ;
local q62_subqs 
    complete_atog
    ;
local q63_subqs 
    track_atog
    ;
local q64_subqs
    why_no_atog_notrequired why_no_atog_unknown
    why_no_atog_nocourse why_no_atog_lowgrade
    why_no_atog_nocollege why_no_atog_other
    ;
local q66_subqs 
    de 
    ;
local q67_subqs
    why_de_class why_de_college
    why_de_reduce why_de_trade
    why_de_other
    ;
local q68_subqs
    de_atog
    ;
local q69_subqs
    transcript_atog
    ;
local q76_subqs 
    home_lang_eng
    ;
local q80_subqs
    has_job
    ;
local q81_subqs 
    hours_perweek
    ;

local q8_str
    "Did you graduate from high school in spring 2024 or are you planning to graduate in summer 2024?"
    ;
local q11_str
    "Why did you complete the FAFSA or CADAA? (Select all that apply)"
    ;
local q12_str  
    "When did you first hear of the FAFSA or CADAA?"
    ;
local q14_str 
    "How difficult was the experience applying for financial aid?"
    ;
local q15_str 
    "What challenges did you face in applying for financial aid via the FAFSA or CADAA? (Select all that apply)"
    ;
local q16_str
    "Please tell us about the support you received in completing your FAFSA/CADAA. (Select all that apply)"
    ;
local q18_str 
    "How much do you agree with the statements about college below?"
    ;
local q19_str
    "How much do you agree with the statements about college below?"
    ;
local q21_str 
    "To what extent do you think each of these should be considered as factor in college admissions"
    ;
local q25_str
    "Did you apply to any colleges and universities? (Select all that apply)"
    ;
local q26_str
    "What challenges did you face when applying to college or trade school? (Select all that apply)"
    ;
local q27_str 
    "Do you plan to attend college in the fall?"
    ;
local q29_str
    "What do you think you will be doing this coming Fall? (Select all that apply)"
    ;
local q30_str
    "Why won't you be attending college this fall? (Select all that apply)"
    ;
local q32_str
    "Which of the following might influence your decision of whether or not to attend college? (Select all that apply)"
    ;
local q34_str
    "Where are you most likely to attend college this fall?"
    ;
local q36_str
    "Which (UC) campus are you most likely to attend?"
    ;
local q37_str 
    "Which (CSU) campus are you most likely to attend?"
    ;
local q38_str 
    "How sure are you that you will attend this school in the fall?"
    ;
local q40_str 
    "Have any of the colleges that you have been accepted to contacted you about your financial aid offer (e.g. email, letter, phone call) ?"
    ;
local q42_str
    "What did the colleges contact you about regarding your financial aid offer? (Select all that apply) "
    ;
local q45_str
    "How helpful were each of these sources of information about college planning and financial aid?"
    ;
local q47_str 
    "Which of these social media platforms did you use to find college or financial aid information? (Select all that apply)"
    ;
local q49_str
    "Who helped you fill out your college application(s)? (Select all that apply)"
    ;
local q50_str
    "Which of the following resources did you use when planning for college? (Select all that apply)"
    ;
local q54_str 
    "How do you plan to pay college tuition and fees? (Select all that apply)"
    ;
local q55_str
    "What are you most likely to study in college?"
    ;
local q56_str
    "What is the highest degree you hope to earn after you have completed all of your schooling?"
    ;
local q58_str
    "When you think about college, how worried are you about the following?"
    ;
local q61_str
    "Please tell us what type of high school you are graduating from:"
    ;
local q62_str 
    "Are you on track to complete the 'a-g' course requirements - the group of courses necessary for admission to UC and CSU?"
    ;
local q63_str 
    "How difficult was it to keep track of your 'a-g' course progress?"
    ;
local q64_str
    "Why are you not on track to complete the 'a-g' course requirements? (Select all that apply)"
    ;
local q66_str
    "Did you take college courses while in high school (sometimes referred to as dual enrollment)?"
    ;
local q67_str 
    "Why did you take these dual enrollment courses? (Select all that apply)"
    ;
local q68_str 
    "Did you use any of these courses to satisfy 'a-g' requirements for admission to a CSU or UC?"
    ;
local q69_str 
    "How difficult was it for you to add the dual enrollment college coursework or transcript information to your college applications?"
    ;
local q76_str 
    "When you were growing up, was English the primary language spoken in your home?"
    ;
local q80_str 
    "Do you currently have a job?"
    ;
local q81_str 
    "How many hours a week do you work at your job?"
    ;


foreach num in `all_qnums' {;
    foreach q in `q`num'_subqs' {;
        local `q'_str: variable label `q';
    };
}
;






local fafsa_qs
    why_fafsa_requirement why_fafsa_assignment why_fafsa_eligible
    why_fafsa_expected why_fafsa_other

    when_heard_fafsa difficulty_apply_finaid

    finaid_challenge_tech finaid_challenge_none finaid_challenge_doc
    finaid_challenge_invite finaid_challenge_multi finaid_challenge_confusing
    finaid_challenge_nohelp finaid_challenge_info finaid_challenge_whichapp
    finaid_challenge_other

    support_received_counselor support_received_teacher support_received_hsworkshop
    support_received_cmworkshop support_received_parent support_received_family
    support_received_friend support_received_online support_received_nobody
    ;

local coll_att_qs
    coll_att_3pt_important coll_att_3pt_worth coll_att_3pt_ready
    coll_att_5pt_important coll_att_5pt_worth coll_att_5pt_ready
    ;

local coll_app_qs
    coll_factor_gpa coll_factor_score coll_factor_service 
    coll_factor_firstgen coll_factor_extra

    coll_applied_ccc coll_applied_csu coll_applied_uc
    coll_applied_priv4yr coll_applied_vocation coll_applied_outside
    coll_applied_notsure coll_applied_none

    collapp_chall_dna collapp_chall_none collapp_chall_noinfo
    collapp_chall_dnu collapp_chall_course collapp_chall_miss
    collapp_chall_fee collapp_chall_deadline collapp_chall_notready
    collapp_chall_submit collapp_chall_other

    attend_coll
    ;

local not_coll_qs
    fall_plan_workpt fall_plan_workft fall_plan_family
    fall_plan_military fall_plan_other

    why_no_coll_notforme why_no_coll_expensive why_no_coll_notworth
    why_no_coll_gapyear why_no_coll_military why_no_coll_health
    why_no_coll_work why_no_coll_training why_no_coll_other
    ;

local idk_coll_qs
    coll_decision_financial coll_decision_academic coll_decision_family
    ;

local yes_coll_qs
    where_attend_coll
    which_uc_campus
    which_csu_campus
    how_sure_attend
    coll_contact

    coll_contact_subject_doc coll_contact_subject_work
    coll_contact_subject_grant coll_contact_subject_loan
    ;

local tools_qs
    helpful_source_hs helpful_source_parent
    helpful_source_family helpful_source_friend
    helpful_source_social helpful_source_college
    helpful_source_private

    social_reddit social_fb social_yt social_tiktok
    social_insta social_twitter social_other

    help_parent help_family help_teacher help_collstsaff
    help_privcounselor help_hscounselor help_other help_self

    resrc_finaidtool resrc_website resrc_comptool resrc_agtool
    resrc_apptool resrc_essaytool resrc_counselor resrc_other
    ;


local coll_exp_qs
    pay_plan_scholarship pay_plan_grant pay_plan_saving pay_plan_work
    pay_plan_otherppl pay_plan_loan pay_plan_va pay_plan_credit

    major_business major_engineering major_science major_social
    major_humanity major_health major_education major_applied
    major_service major_undecided

    highest_degree 

    coll_worry_tuition coll_worry_living
    coll_worry_academic coll_worry_work
    coll_worry_family coll_worry_community
    coll_worry_living_away coll_worry_support 
    ;

local hs_exp_qs
    hs_type 
    complete_atog track_atog 

    why_no_atog_notrequired why_no_atog_unknown why_no_atog_nocourse
    why_no_atog_lowgrade why_no_atog_nocollege why_no_atog_other

    de

    why_de_class why_de_college why_de_reduce
    why_de_trade why_de_other
    
    de_atog
    transcript_atog
    ;

local all_qs
    hs_senior `fafsa_qs' `coll_att_qs' `coll_app_qs' 
    `not_coll_qs' `idk_coll_qs' `yes_coll_qs'
    `tools_qs' `coll_exp_qs' `hs_exp_qs'
    home_lang_eng has_job hours_perweek
    ;

local demo_qs
    race_hrchy parent_edu  
    ;


local race_hrchy_str "Race";
local parent_edu_str "Parental Education";
local gender_str "Gender";

// questions with select all that apply, for counting denominators ;
local select_all_raw_qs
    why_fafsa_raw
    finaid_challenge_raw
    support_received_raw
    coll_applied_raw
    collapp_chall_raw
    fall_plan_raw
    why_no_coll_raw
    coll_decision_raw
    coll_contact_subject_raw
    social_raw
    help_raw
    resrc_raw
    pay_plan_raw
    major_raw
    why_no_atog_raw
    why_de_raw
    ;

#delimit cr 