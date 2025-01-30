/* create a dataset of students who answered No or IDK to do you plan on going to college (Q27) */

/* First created by Christina Sun, 1/29/2025 */

/* To run this do file:
do $projdir/do/sample/no_idk_col_sample.do 
 */

 graph drop _all
set more off
set varabbrev off
set graphics off
set scheme s1color
set seed 1984


use $projdir/dta/csac_2024_initial_clean.dta, clear 

include $projdir/do/macros_csac.doh 


// subset the sample 
keep if attend_coll == 0 | attend_coll == -1

#delimit ;
keep     coll_att_3pt_important coll_att_3pt_worth coll_att_3pt_ready

        coll_att_5pt_important coll_att_5pt_worth coll_att_5pt_ready

            coll_applied_ccc coll_applied_csu coll_applied_uc
    coll_applied_priv4yr coll_applied_vocation coll_applied_outside
    coll_applied_notsure coll_applied_none

    attend_coll

        fall_plan_workpt fall_plan_workft fall_plan_family
    fall_plan_military fall_plan_other

        why_no_coll_notforme why_no_coll_expensive why_no_coll_notworth
    why_no_coll_gapyear why_no_coll_military why_no_coll_health
    why_no_coll_work why_no_coll_training why_no_coll_other

        coll_decision_financial coll_decision_academic coll_decision_family
    ;


# delimit cr 

save $projdir/dta/no_idk_col_sample.dta, replace 