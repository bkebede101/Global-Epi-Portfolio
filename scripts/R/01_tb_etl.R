#!/usr/bin/env Rscript
#
# Script to process tuberculosis incidence data
#
# This example script demonstrates how to ingest WHO TB incidence data and
# prepare a tidy country–year table with point estimates and uncertainty bounds.
# In practice, you would download the raw dataset from data.who.int and read
# population denominators from a separate source.  Here we illustrate using
# a small sample dataset stored in `data/processed/`.

source("scripts/R/00_utils.R")
library(readr)
library(dplyr)

# Define file paths
input_path <- "data/processed/tb_timeseries_sample.csv"  # sample processed data
output_path <- "data/processed/tb_timeseries.csv"        # final tidy table

# Read the sample data
tb <- read_csv(input_path, show_col_types = FALSE)

# In a full pipeline, you would read raw WHO data, harmonize country codes,
# merge with population denominators and compute per‑100k rates.  The sample
# already includes point estimates and uncertainty bounds, so we simply rename
# columns for consistency and write the final file.
tb_processed <- tb %>%
  rename(
    incidence_per100k = tb_incidence_per100k,
    incidence_lower = tb_incidence_per100k_low,
    incidence_upper = tb_incidence_per100k_upp
  )

# Write out the tidy table
write_csv(tb_processed, output_path)
message("TB incidence data processed and saved to ", output_path)
