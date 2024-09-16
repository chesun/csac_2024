/* macros for the project */

#delimit ;

// question macros ;

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
    `fafsa_qs' `coll_att_qs' `coll_app_qs' 
    `not_coll_qs' `idk_coll_qs' `yes_coll_qs'
    `tools_qs' `coll_exp_qs' `hs_exp_qs'
    ;

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