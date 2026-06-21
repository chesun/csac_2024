********************************************************************************
/* 2024 CSAC / C2C high school graduating senior survey -- master do file */
* Author: Christina Sun (che.sun.1996@gmail.com / christinasun101@gmail.com)
*
* Runs the full pipeline in order: clean -> explore -> sample -> share.
* To run:  do /home/research/ca_ed_lab/projects/csac_survey2024/do/main.do
*
* CHANGE LOG:
* - 2026-06-21: expand to full end-to-end pipeline (added sample/ and share/),
*               add per-file descriptions and a fresh-checkout mkdir toggle -CS
********************************************************************************

********************************* Preamble *************************************

// clear state first, THEN load globals so settings.do's path macros survive
cd "/home/research/ca_ed_lab/projects/csac_survey2024"
clear all

// load global path macros ($projdir, $rawdtadir, $csac2023projdir)
do do/settings.do

set more off
set varabbrev off
set graphics off
set scheme s1color
set seed 1984

// asdoc is required by do/share/appendix_tab.do; reinstall a clean copy
net install uninstall_asdoc, from(http://fintechprofessor.com) replace
uninstall_asdoc
net install asdoc, from(http://fintechprofessor.com) replace

// First run on a fresh checkout? set to 1 to create the output folders
local mkdir 0
if `mkdir' == 1 {
    cap mkdir "$projdir/dta"          // cleaned datasets
    cap mkdir "$projdir/log"          // execution logs
    cap mkdir "$projdir/log/clean"
    cap mkdir "$projdir/log/explore"
    cap mkdir "$projdir/tab"          // output tables
    cap mkdir "$projdir/tab/check"    // report appendix .doc files
}

// Each sub-do file opens and closes its own log (`log close _all` at its top),
// so no master log is opened here.

*------------------------------ DATA CLEANING ---------------------------------
// import raw Qualtrics export; recode/label survey vars; drop PII
// -> $projdir/dta/csac_2024_initial_clean.dta
do $projdir/do/clean/clean_qualtrics_download.do

*------------------------------ EXPLORATION -----------------------------------
// sample characteristics: HS-senior status, college-going, demographics
do $projdir/do/explore/explore_sample_char.do
// tabulate every question overall and by demographics; 2023-vs-2024 comparison
do $projdir/do/explore/tab_questions.do

*------------------------------- SUBSAMPLE ------------------------------------
// subset to students not planning on college (Q27 = No / I-don't-know)
// -> $projdir/dta/no_idk_col_sample.dta
do $projdir/do/sample/no_idk_col_sample.do

*-------------------------- REPORT APPENDIX TABLES ----------------------------
// one-/two-way tabs of referenced questions for the CSAC and C2C reports
// -> $projdir/tab/check/appendix_c2c.doc, appendix_csac.doc, appendix.doc
do $projdir/do/share/appendix_tab.do
