# CLAUDE.md — CSAC / C2C 2024 High School Senior Survey

Guidance for Claude Code (claude.ai/code) working in this repository. Kept lean — it loads every session.

**Project:** CSAC 2024 High School Graduating Senior Survey
**Institution:** California Education Lab (UC Davis), with the California Student Aid Commission (CSAC) and the California Cradle-to-Career Data System (C2C)
**Branch:** main
**Analysis roots:** `do/` (the dir the evidence-gating recorder and file-class rules scope to — this repo uses `do/`, not the template default `scripts/`; `.claude/file-classes.toml` still lists `scripts/`/`paper/`/`talks/` and would need adapting before the gating hooks scope correctly here)

---

## Offboarding status (CS, 2026)

CS is offboarding from CEL and wrapping up this project. Open tasks, in order:

1. Draft `README.md` (handoff doc for the next maintainer).
2. Fill in `do/main.do` to run the full pipeline start to finish, with a one-line description of each do file.
3. Run the entire pipeline end to end on the **Scribe** server and verify it runs without error.
4. Record the input and output of each do file in the README.

Track this in `TODO.md` / the `.claude/` workflow as it progresses.

---

## Project overview

The 2024 iteration of the CSAC high school senior survey (predecessor: 2023, at `~/github_repos/csac/`, project `csac_survey2023`). A single wave was fielded to graduating California high school seniors; the raw Qualtrics export is dated **August 2, 2024**.

The two published reports are the final research products of this project:

1. [CSAC 2024 Survey Report](https://www.csac.ca.gov/sites/default/files/2025-04/csac_2024_survey_report.pdf)
2. [C2C Student Experience Report (2024 Academic Year)](https://c2c.ca.gov/wp-content/uploads/2025/02/C2C-Student-Experience-Report-2024-Academic-Year.pdf)

This repo produces the analysis behind those reports: a cleaned survey dataset, exploratory tabulations, a non-college-going subsample, and the **appendix tabulation tables** (`tab/check/appendix_csac.doc`, `appendix_c2c.doc`, combined `appendix.doc`) referenced in each report. The report PDFs themselves are written and assembled outside this repo. Reuse the 2023 repo's conventions and code as a reference where helpful.

## Execution model

All Stata runs on the **remote Linux research server ("Scribe")**, not locally. Restricted survey data lives on the server only; the local repo holds code, synced-back outputs, and docs. Transfer via FileZilla or scp.

Workflow: edit do files locally → upload to Scribe → run in Stata (`do <file>.do`). There is no local build or test command.

Server paths (`do/settings.do`):

```stata
global projdir         "/home/research/ca_ed_lab/projects/csac_survey2024"
global rawdtadir       "/home/research/ca_ed_lab/data/restricted_access/raw/csac_survey/2024"
global csac2023projdir "/home/research/ca_ed_lab/projects/csac_survey2023"
```

## Running the pipeline

`do/main.do` is the master file: it `cd`s to the project dir, sources `do/settings.do`, (re)installs `asdoc`, then runs the do files in order. Run with:

```stata
do do/main.do
```

`main.do` is **mid-buildout** for offboarding — it currently runs cleaning plus the two `explore/` scripts but does not yet call `do/sample/` or `do/share/`. Completing it end to end is the open task above.

## Repository structure

```
do/                                  Stata do files (all executable code)
  main.do                              Master pipeline (mid-buildout)
  settings.do                          Global path macros (Scribe server paths)
  macros_csac.doh                      Question variable-lists & label strings; include AFTER loading data
  clean/clean_qualtrics_download.do    Raw Qualtrics CSV -> cleaned dataset
  explore/explore_sample_char.do       Sample characteristics (HS-senior, college-going, demographics)
  explore/tab_questions.do             Tabulate all questions, overall and by demographics; 2023-vs-2024 compare
  sample/no_idk_col_sample.do          Subset: students not planning college (Q27 = No/IDK)
  share/appendix_tab.do                Appendix tabulation tables for the CSAC & C2C reports
log/                                 Stata logs (.smcl + translated .log), mirroring do/ subdirs
tab/check/                           Report appendix .doc files
dta/                                 Local data (cleaned .dta live on Scribe; not committed)
appendix.pdf / appendix.doc          Rendered combined appendix referenced by the reports
.claude/                             Claude Code workflow scaffolding (rules, skills, agents, hooks)
```

## The pipeline, file by file

Paths use the `do/settings.do` globals. **[external]** = produced outside this repo.

| File | Purpose | Input | Output |
|---|---|---|---|
| `clean/clean_qualtrics_download.do` | First-pass clean: import raw Qualtrics CSV, drop header/system rows & PII, recode/label survey vars | `$rawdtadir/CSAC_2024_Senior_Survey_August 2, 2024_12.04.csv` **[external]** | `$projdir/dta/csac_2024_initial_clean.dta`; log |
| `explore/explore_sample_char.do` | Explore sample: HS-senior status, college-going, demographics | `csac_2024_initial_clean.dta` | log only |
| `explore/tab_questions.do` | Tabulate every question overall and by race/gender/parent-edu; compare to 2023 | `csac_2024_initial_clean.dta` + `macros_csac.doh`; 2023 data via `$csac2023projdir` | `$projdir/log/explore/tab_questions_*.{smcl,log}` and related logs |
| `sample/no_idk_col_sample.do` | Subset to students answering No/IDK to "plan on going to college" (Q27); keep college-attitude vars | `csac_2024_initial_clean.dta` + `macros_csac.doh` | `$projdir/dta/no_idk_col_sample.dta` |
| `share/appendix_tab.do` | Build report appendices: one- and two-way tabs of referenced questions, separately for C2C and CSAC plus a combined version | `csac_2024_initial_clean.dta` + `macros_csac.doh` | `tab/check/appendix_c2c.doc`, `appendix_csac.doc`, `appendix.doc` |

> **Key dataset:** `csac_2024_initial_clean.dta` (in `$projdir/dta/`) is the single cleaned dataset every downstream script reads. `macros_csac.doh` must be `include`d **after** the data is loaded — it builds variable lists and label strings from the loaded variables, so it errors on an empty dataset.

## Do-file conventions

Standard preamble (all scripts):

```stata
log close _all
log using $projdir/log/<subdir>/<name>.smcl, replace
graph drop _all
set more off
set varabbrev off
set graphics off
set scheme s1color
set seed 1984
```

- **Logs:** SMCL to `$projdir/log/<subdir>/`, then `translate`d to `.log`.
- **Tables:** `asdoc` for the Word/RTF report appendices.
- **Variable naming:** snake_case keyed to survey questions (e.g., `why_fafsa_requirement`, `coll_applied_ccc`, `race_hrchy`, `attend_coll`). Select-all-that-apply items are split into one 0/1 dummy per option.

## Core principles (from `.claude/rules/`)

This repo carries the applied-micro Claude Code workflow in `.claude/`. Highlights relevant here:

- **Plan first / verify after** — plan non-trivial tasks; confirm output runs at the end (`workflow.md`, `verification-protocol.md`).
- **Derive, don't guess** — look up paths/vars/conventions in the repo and cite the source line (`derive-dont-guess.md`).
- **Stata conventions** — `stata-code-conventions.md`; a balanced-block-comment PreToolUse hook checks every `.do` edit.
- **Adversarial / evidence gating** — verdicts are PASS / UNVERIFIED / FAIL, never silent-PASS (`adversarial-default.md`).
- **Destructive-action guard** — a Bash PreToolUse hook blocks risky deletes (`destructive-actions.md`).
- **[LEARN] tags** — on correction, save `[LEARN:category] wrong -> right` to `MEMORY.md`.

Full rule set in `.claude/rules/`; skills in `.claude/skills/` (e.g., `/stata`, `/analyze`, `/review`, `/commit`).
