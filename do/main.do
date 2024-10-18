/* Do file to run all project do files in order */

/* 
do /home/research/ca_ed_lab/projects/csac_survey2024/do/main.do
 */

cd "/home/research/ca_ed_lab/projects/csac_survey2024"
do do/settings.do

net install uninstall_asdoc, from(http://fintechprofessor.com) replace
uninstall_asdoc
net install asdoc, from(http://fintechprofessor.com) replace

// clean data
do $projdir/do/clean/clean_qualtrics_download.do

// initial exploration
do $projdir/do/explore/explore_sample_char.do

do $projdir/do/explore/tab_questions.do
