# CSAC / C2C 2024 High School Graduating Senior Survey

Code, outputs, and documentation for the **2024 California high school graduating senior survey**, a collaboration between the California Education Lab (CEL, UC Davis), the California Student Aid Commission (CSAC), and the California Cradle-to-Career Data System (C2C).

A single survey wave was fielded to graduating California high school seniors in 2024; the raw Qualtrics export used here is dated **August 2, 2024**. This repo cleans that survey, explores it, and produces the tabulations that back the two published 2024 reports.

This is the 2024 iteration of the 2023 survey (project `csac_survey2023`; local sibling repo `csac/`), whose conventions and code it reuses.

**Code author:** Christina Sun (CS, `che.sun.1996@gmail.com`).

**CS offboarding complete (2026-06-21):** README and the full `do/main.do` pipeline finalized. The pipeline ran end to end on the Scribe server with no errors; logs and the appendix tables were synced back to this repo.

---

## Research outputs

This survey supports two published reports — the final products of the project:

| Report | Published | Code that feeds it |
|---|---|---|
| [CSAC 2024 Survey Report](https://www.csac.ca.gov/sites/default/files/2025-04/csac_2024_survey_report.pdf) | Apr 2025 | `do/clean/`, `do/explore/`, `do/share/appendix_tab.do` (CSAC appendix) |
| [C2C Student Experience Report (2024 Academic Year)](https://c2c.ca.gov/wp-content/uploads/2025/02/C2C-Student-Experience-Report-2024-Academic-Year.pdf) | Feb 2025 | `do/clean/`, `do/explore/`, `do/share/appendix_tab.do` (C2C appendix) |

The report PDFs are written and assembled outside this repo. This repo's shipped artifacts are the **appendix tabulation tables** (`tab/check/appendix_csac.doc`, `appendix_c2c.doc`, combined `appendix.doc`, and the rendered `appendix.pdf`) plus the exploratory tabulations the report narratives draw on.

## Project history (brief)

- **2024-08** — Repo created (2024-08-01). The raw Qualtrics export (2024-08-02) is cleaned into the analysis dataset; initial sample-characteristics and question tabulations written.
- **2025-01** — Appendix tabulation tables built for the CSAC and C2C reports; non-college-going subsample (`no_idk_col_sample.do`) created (2025-01-29).
- **2025-02 / 2025-04** — C2C and CSAC reports published.
- **2026-06-21** — Offboarding: README and full `main.do` pipeline (clean → explore → sample → share) finalized; pipeline verified end to end on Scribe with no errors. `main.do` switched to `ssc install asdoc`.

---

## Execution model

All Stata code runs on the **remote Linux research server ("Scribe")**, not locally. Restricted survey data lives on the server only; the local repo holds code, synced-back outputs (logs and the appendix tables), and documentation. File transfer is via FileZilla or scp.

Workflow: edit do files locally, upload to Scribe, run in Stata (`do <file>.do`). There is no local build or test command.

Server paths are defined in `do/settings.do`:

```stata
global projdir         "/home/research/ca_ed_lab/projects/csac_survey2024"
global rawdtadir       "/home/research/ca_ed_lab/data/restricted_access/raw/csac_survey/2024"
global csac2023projdir "/home/research/ca_ed_lab/projects/csac_survey2023"
```

### Running the full pipeline

`do/main.do` is the master file: it `cd`s to the project directory, sources `do/settings.do`, installs `asdoc` from SSC, and runs the do files in order:

```stata
do do/main.do
```

> **Note:** `main.do` runs the full pipeline (clean → explore → sample → share) and was verified end to end on Scribe (2026-06-21). On a fresh checkout, set `local mkdir 1` near the top of the file for the first run to create the output folders.

---

## Repository structure

Local repo (code + synced-back outputs):

```
do/                                  Stata do files (all executable code)
  main.do                              Master pipeline (clean -> explore -> sample -> share)
  settings.do                          Global path macros (Scribe server paths)
  macros_csac.doh                      Per-question variable-lists & label strings; include AFTER loading data
  clean/                               Data cleaning
  explore/                             Sample characteristics + question tabulations
  sample/                              Analysis subsamples
  share/                               Report appendix tables
log/                                 Stata logs (.smcl + translated .log), mirroring do/ subdirs
tab/check/                           Report appendix .doc files
appendix.pdf / appendix.doc          Rendered combined appendix referenced by the reports
.claude/  CLAUDE.md                   Claude Code workflow scaffolding (not part of the analysis)
```

On Scribe, the project directory (`$projdir`) additionally holds `dta/` — the cleaned datasets (`csac_2024_initial_clean.dta`, `no_idk_col_sample.dta`), which are restricted and **not** committed to this repo.

---

## The pipeline, file by file

Paths use the `do/settings.do` globals. Inputs marked **[external]** are not produced by any code in this repo.

### Setup

| File | Purpose |
|---|---|
| `do/settings.do` | Defines the global path macros (`$projdir`, `$rawdtadir`, `$csac2023projdir`). Sourced first by `main.do`. |
| `do/macros_csac.doh` | Builds the per-question variable-lists (e.g., `q<n>_subqs`), the all-questions list, and the human-readable question/variable label strings the tabulation scripts consume. `include` it **after** loading the data — it reads the loaded variables, so it errors on an empty dataset. |

### Stage 1 — Cleaning (`do/clean/`)

| File | Purpose | Input | Output |
|---|---|---|---|
| `clean_qualtrics_download.do` | First-pass clean: import the raw Qualtrics CSV, drop header/system rows and PII, recode and label survey variables (FAFSA reasons, college applications, demographics, etc.) | `$rawdtadir/CSAC_2024_Senior_Survey_August 2, 2024_12.04.csv` **[external]** | `$projdir/dta/csac_2024_initial_clean.dta`; `log/clean/clean_qualtrics_download.{smcl,log}` |

### Stage 2 — Exploration (`do/explore/`)

| File | Purpose | Input | Output |
|---|---|---|---|
| `explore_sample_char.do` | Tabulate sample characteristics: HS-senior status, college-going, race, parental education, home language, employment | `csac_2024_initial_clean.dta` | `log/explore/explore_sample_char.{smcl,log}` |
| `tab_questions.do` | Tabulate every survey question overall and by demographics (two race codings, gender, parental education); college-application crosstabs; FAFSA reasons; a 2023-vs-2024 comparison | `csac_2024_initial_clean.dta`; `macros_csac.doh`; `$csac2023projdir/dta/cln/csac_hs_senior_2023_brief.dta` **[external]** | A suite of `log/explore/tab_questions_*.{smcl,log}` plus related comparison logs (`compare_2023`, `tab_coll_app`, `tab_why_fafsa`, etc.) |

### Stage 3 — Subsample (`do/sample/`)

| File | Purpose | Input | Output |
|---|---|---|---|
| `no_idk_col_sample.do` | Subset to students who answered No / "I don't know" to "do you plan on going to college" (Q27); keep college-attitude, application, fall-plan, and reason-for-no-college variables | `csac_2024_initial_clean.dta`; `macros_csac.doh` | `$projdir/dta/no_idk_col_sample.dta` |

### Stage 4 — Report appendices (`do/share/`)

| File | Purpose | Input | Output |
|---|---|---|---|
| `appendix_tab.do` | Build the report appendices: one-way and by-demographic two-way tabulations of the questions referenced in each report, written separately for C2C and CSAC plus a combined version | `csac_2024_initial_clean.dta`; `macros_csac.doh` | `tab/check/appendix_c2c.doc`; `tab/check/appendix_csac.doc`; `tab/check/appendix.doc` |

> **Key intermediate:** `csac_2024_initial_clean.dta` (in `$projdir/dta/`) is the single cleaned dataset that every Stage 2–4 script reads. `clean_qualtrics_download.do` must run first.

---

## Key datasets

### Produced by the pipeline

| Dataset | Produced by | Used by |
|---|---|---|
| `csac_2024_initial_clean.dta` | `clean/clean_qualtrics_download.do` | `explore/`, `sample/`, `share/` (all downstream scripts) |
| `no_idk_col_sample.dta` | `sample/no_idk_col_sample.do` | Standalone subsample (shared for downstream/qualitative work; no do file in this repo reads it) |

### External inputs

| Input | What it is | Provenance |
|---|---|---|
| `CSAC_2024_Senior_Survey_August 2, 2024_12.04.csv` | Raw Qualtrics survey export (the survey itself) | CSAC / Qualtrics. **Use this exact file** — `clean_qualtrics_download.do:18` notes an earlier export had line breaks inside text responses that corrupt the import. |
| `csac_hs_senior_2023_brief.dta` | Prior-wave cleaned data for the 2023-vs-2024 comparison in `tab_questions.do` (read from `$csac2023projdir/dta/cln/`) | The 2023 project (`csac_survey2023`; local sibling repo `csac/`) |

---

## Gotchas for the next person

- **`macros_csac.doh` needs data loaded first.** `include` it only after a `use`; it builds macros from the loaded variables and errors on an empty dataset.
- **One cleaned dataset feeds everything.** Every analysis script reads `csac_2024_initial_clean.dta`, so `clean_qualtrics_download.do` must run before anything else.
- **Use the August 2, 2024 Qualtrics export.** An earlier export imports incorrectly (line breaks in text responses).
- **`tab_questions.do` reaches into the 2023 project.** Its comparison section (`tab_questions.do:178`) reads `$csac2023projdir/dta/cln/csac_hs_senior_2023_brief.dta`; that file must exist on Scribe or the comparison errors.
- **Network install.** `main.do` installs `asdoc` from SSC (`ssc install asdoc, replace`); the server needs internet access on first run.
- **Stata version.** No `version` is set in the do files; run on Scribe (the project's standard Stata install) to match the authoring environment.
