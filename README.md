# Global Disease Epidemiology Portfolio – Biruk Kebede (MSPH)

This repository contains a small-scale example of how to structure and document a personal research portfolio for a global disease epidemiologist.  The goal of this repository is to provide a clean, reproducible set of scripts, data and documentation that support the interactive Tableau dashboard described in the accompanying plan.

## Contents

- **`data/`** – Raw and processed data used in the dashboard.  The `processed/` directory contains sample CSV files prepared for analysis and visualization.  See `data/README.md` for details.
- **`scripts/`** – R and Stata scripts for ingesting, cleaning and checking the datasets.  These show the analytic workflow used to produce the processed tables.
- **`tableau/`** – Notes about the Tableau workbook and individual sheets.  A published dashboard would live on Tableau Public.
- **`examples/`** – Small demonstration projects such as a simple SIR model in R and a short TB brief.  These illustrate your ability to code and communicate epidemiologic methods.

## How to reproduce

1. Install R (≥4.0) and Stata (optional).  Install the `dplyr`, `readr`, and `deSolve` packages in R.
2. Clone this repository and navigate to its root.
3. Run `Rscript scripts/R/01_tb_etl.R` and `Rscript scripts/R/02_eid_etl.R` to ingest raw files and produce the processed tables in `data/processed/`.  These sample scripts read the WHO and outbreak data and compute per‑100k rates and case fatality ratios.
4. Run `Rscript scripts/R/03_qaqc_checks.R` to perform simple quality assurance checks on the processed tables.  Logs will be printed to the console.
5. Open Tableau and connect to the CSV files in `data/processed/`.  Build the dashboard following the notes in `tableau/workbook_notes.md`.  Publish the final dashboard to Tableau Public and link it back in this repository.

## Skills demonstrated

- **Data management and cleaning:** ingesting raw tables, harmonizing country codes, computing rates and uncertainty bounds, and reshaping data into tidy long formats.
- **Analysis and visualization:** preparing summary tables and metrics (incidence rates, mortality estimates, case fatality ratios) that can be directly visualized in Tableau.
- **Quality assurance:** implementing simple missingness checks, logical constraints (e.g., mortality ≤ incidence), and per‑indicator review.
- **Documentation:** writing clear READMEs for data sources, methods and limitations, and adding inline comments in scripts to explain each step.