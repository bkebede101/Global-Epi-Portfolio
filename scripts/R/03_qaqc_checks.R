#!/usr/bin/env Rscript
#
# Quality assurance and quality control checks for processed data
#
# This script performs a few simple checks on the TB and EID datasets,
# reporting missingness and logical inconsistencies.  Additional checks
# should be added as needed for your specific data.

source("scripts/R/00_utils.R")
library(readr)
library(dplyr)

# Load processed data
tb_path <- "data/processed/tb_timeseries.csv"
eid_path <- "data/processed/eid_outbreaks.csv"

tb <- read_csv(tb_path, show_col_types = FALSE)
eid <- read_csv(eid_path, show_col_types = FALSE)

# 1. Check missingness in TB incidence data
tb_missing <- sapply(tb, num_na)
cat("\nMissing values in TB data (per column):\n")
print(tb_missing)

# 2. Check logical constraint: incidence_lower ≤ incidence_per100k ≤ incidence_upper
violations <- tb %>%
  filter(incidence_per100k < incidence_lower | incidence_per100k > incidence_upper)
if (nrow(violations) == 0) {
  cat("\nAll TB point estimates lie within the uncertainty bounds.\n")
} else {
  cat("\nWarning: Some TB estimates fall outside the uncertainty bounds:\n")
  print(violations)
}

# 3. Check missingness in EID data
eid_missing <- sapply(eid, num_na)
cat("\nMissing values in EID data (per column):\n")
print(eid_missing)

# 4. Check for negative cases or deaths in EID data
negatives <- eid %>% filter(cases < 0 | deaths < 0)
if (nrow(negatives) == 0) {
  cat("\nNo negative case or death counts detected in EID data.\n")
} else {
  cat("\nWarning: Negative values found in EID data:\n")
  print(negatives)
}

cat("\nQA/QC checks completed.\n")