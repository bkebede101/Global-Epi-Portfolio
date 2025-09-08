#!/usr/bin/env Rscript
#
# Script to process emerging infectious disease outbreaks data
#
# This example ingests a simulated outbreaks dataset and recalculates the
# case fatality ratio (CFR).  In a real workflow, you would download an
# official dataset (e.g., from the WHO Disease Outbreak News) and clean it.

source("scripts/R/00_utils.R")
library(readr)
library(dplyr)

# Paths
input_path <- "data/processed/eid_outbreaks_sample.csv"
output_path <- "data/processed/eid_outbreaks.csv"

# Read sample data
eid <- read_csv(input_path, show_col_types = FALSE)

# Compute CFR if not already present
eid_processed <- eid %>%
  mutate(
    cfr_pct_calculated = cfr_pct(cases = cases, deaths = deaths)
  )

# Write final file
write_csv(eid_processed, output_path)
message("EID outbreaks data processed and saved to ", output_path)
