/* create appendix tables  */

/* to run this do file, type
do $projdir/do/share/appendix_tab.do
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

local check_tab_dir "$projdir/tab/check"

use $projdir/dta/csac_2024_initial_clean.dta, clear 

label var race_hrchy "Race"
label var parent_edu "Parental Education"
label var gender "Gender"

// write document title
asdoc, save(`check_tab_dir'/appendix.doc) replace text(Appendix: Tabulations of All Survey Questions) fs(12)

local secnum 1
foreach qnum in `test_qnums' {
    // write heading 
    asdoc, save(`check_tab_dir'/appendix.doc) append text(`secnum'. Tabulations of Question `q`qnum'_heading')  fs(12)

    local subsecnum 1


    foreach var of varlist `q`qnum'_subqs' {
        // write subheading for sub question
        asdoc, save(`check_tab_dir'/appendix.doc) append text(`secnum'.`subsecnum'. ``var'_title')

        // one way tabulation
        asdoc tab `var', mi save(`check_tab_dir'/appendix.doc) append title(One-Way Tabulation) label 

        // twoway tabulation
        foreach demo of varlist `demo_qs' {

            asdoc tab `demo' `var', mi save(`check_tab_dir'/appendix.doc) append title(Two-Way Tabulation by ``demo'_str') label row 

        }

        local subsecnum `= `subsecnum' + 1'

    }



    local secnum `=`secnum'+ 1'

}

