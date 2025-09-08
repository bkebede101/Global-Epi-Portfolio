/*
  Stata script to process tuberculosis incidence data

  This example reads the sample CSV file from the processed data directory,
  renames columns for clarity, and exports a tidy table.  In a real use case
  you would import the raw WHO dataset, merge with population denominators
  and compute per‑100,000 rates.
*/

clear all

/* Define file paths */
local input "data/processed/tb_timeseries_sample.csv"
local output "data/processed/tb_timeseries.dta"

/* Import the sample CSV */
import delimited using `input', varnames(1) clear stringcols(_all)

/* Rename variables for consistency */
rename tb_incidence_per100k incidence_per100k
rename tb_incidence_per100k_low incidence_lower
rename tb_incidence_per100k_upp incidence_upper

/* Save as Stata dataset */
save `output', replace

display "TB incidence data processed and saved to `output'"