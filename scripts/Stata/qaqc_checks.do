/*
  Stata script for basic QA/QC checks on the TB incidence data

  This script checks for missing values and logical consistency of
  the uncertainty bounds.  It prints summary statistics to the console.
*/

clear all
/* Define path */
local tbfile "data/processed/tb_timeseries.dta"
use `tbfile', clear

/* 1. Missing values */
foreach var of varlist * {
    count if missing(`var')
    display "Missing values in `var': " r(N)
}

/* 2. Check bounds */
gen outside_bounds = incidence_per100k < incidence_lower | incidence_per100k > incidence_upper
count if outside_bounds
if r(N) == 0 {
    display "All TB point estimates lie within the uncertainty bounds."
} else {
    list country year incidence_per100k incidence_lower incidence_upper if outside_bounds
}

drop outside_bounds

display "QA/QC checks completed."