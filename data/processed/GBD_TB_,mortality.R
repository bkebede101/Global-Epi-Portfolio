#!/usr/bin/env Rscript


# ============================================================
# Author: Biruk Kebede
# Project: Working with IHME GBD 2021
# File: R/01_process_tb_mortality.R
# Purpose: Creating a TB dataset using data wrangling techniques
# Input: data/raw/IHME_GBD_2021_MORTALITY_1990_2021_SR_TABLE_1_Y2024M04D03.XLSX
# Output: data/processed/tb_mortality_processed.csv
# Reference: https://ghdx.healthdata.org/record/ihme-data/gbd-2021-cause-specific-mortality-1990-2021
# ============================================================




# Load libraries
library(readxl)
library(dplyr)
library(tidyr)
library(stringr)
library(readr)
library(ggplot2)
install.packages('janitor')  #helpful with handling messy data
library(janitor)

#Read File 

raw_path <- "C:/Users/brook/OneDrive - Johns Hopkins/Documents/global-epi-portfolio/data/raw/IHME_GBD_2021_MORTALITY_1990_2021_SR_TABLE_1_Y2024M04D03.csv"
GBD2021_Mortality <- read_csv(raw_path, skip = 1)

# Preview Data ()

head(GBD2021_Mortality)   
tail(GBD2021_Mortality)
names(GBD2021_Mortality)
glimpse(GBD2021_Mortality)
summary(GBD2021_Mortality)
unique(GBD2021_Mortality) #similar to having a glimpse of the data
table(GBD2021_Mortality$cause_name)
length(unique(GBD2021_Mortality$cause_name))
Cause_table <- GBD2021_Mortality %>% count(cause_name, sort = TRUE)  


# Cleaning 
GBD2021_Mortality <- GBD2021_Mortality %>% clean_names()  #fromt the Janitor Package for messy naming issues

GBD2021_Mortality_long <- GBD2021_Mortality %>%
  pivot_longer(
    cols = matches("^x\\d{4}_(asmr|all_age_deaths)$"),    # could also use Col nums (eg: 3:13) but cleaner this way
      names_to = c( "year", "metric"),
        names_pattern = "^x(\\d{4})_(asmr|all_age_deaths)$",  
            values_to = "raw_estimates"
        ) %>%
            mutate(
                year = as.integer(year),
                metric = recode(
                    metric, 
                    asmr = "ASMR",
                    all_age_deaths = "All-age deaths"),
            raw_estimates = str_squish(raw_estimates)
                
            )

#Pause: QA for mortality estimates
  
  str(GBD2021_Mortality_long$raw_estimates)
        
  is.na(GBD2021_Mortality_long$raw_estimates)
  sum(is.na(GBD2021_Mortality_long$raw_estimates))
  
# Extracting TB mortality 
  
  GBD2021_TB <- GBD2021_Mortality_long %>%
                    filter (str_detect(cause_name, regex("tuberculosis|^tb$", ignore_case = TRUE))
)

  GBD2021_TB <- GBD2021_TB %>%
    arrange(location_name, cause_name, desc(year), metric)
  
    