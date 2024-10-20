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


local check_tab_dir "$projdir/tab/check"

use $projdir/dta/csac_2024_initial_clean.dta, clear 

// this macros file needs data to run.
include $projdir/do/macros_csac.doh 


label var race_hrchy "Race"
label var parent_edu "Parental Education"
label var gender "Gender"

// write document title
asdoc, save(`check_tab_dir'/appendix.doc) replace text( Appendix: Tabulations of All Survey Questions)
asdoc, save(`check_tab_dir'/appendix.doc) append text(\) 

local secnum 1
foreach qnum in `all_qnums' {
    // write heading 
    asdoc, save(`check_tab_dir'/appendix.doc) append text(\b `secnum'. Tabulations of Question `qnum': `q`qnum'_str')  fs(16)
    asdoc, save(`check_tab_dir'/appendix.doc) append text(\)

    local subsecnum 1


    foreach var of varlist `q`qnum'_subqs' {
        // write subheading for sub question
        asdoc, save(`check_tab_dir'/appendix.doc) append text(\b `secnum'.`subsecnum'. ``var'_str') fs(14)
        asdoc, save(`check_tab_dir'/appendix.doc) append text(\)

        // one way tabulation, rtf font size are half of the number 
        local subsubsecnum 1
        asdoc, save(`check_tab_dir'/appendix.doc) append text(\b `secnum'.`subsecnum'.`subsubsecnum'. One-Way Tabulation) fs(12)
        asdoc tab `var', save(`check_tab_dir'/appendix.doc) append title(\) label fs(12) 

        // twoway tabulation
        local subsubsecnum 2

        foreach demo of varlist `demo_qs' {

            asdoc, save(`check_tab_dir'/appendix.doc) append text(\b `secnum'.`subsecnum'.`subsubsecnum'. Two-Way Tabulation by ``demo'_str') fs(12)

            asdoc tab2 `demo' `var', save(`check_tab_dir'/appendix.doc) append title(\) label row fs(12) nokey

            local subsubsecnum `= `subsubsecnum' + 1'


        }

        local subsecnum `= `subsecnum' + 1'

    }



    local secnum `=`secnum'+ 1'

}

