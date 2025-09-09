library(readxl)
library(dplyr)
library(readr)
library(stringr)

# Extract
df_raw <- read_excel("data/raw/IHME_GBD_2021_MORTALITY_1990_2021_SR_TABLE_1_Y2024M04D03.XLSX")

# Transform
tb_df <- df_raw %>%
  filter(Year %in% c(1990, 2000, 2010, 2015, 2021)) %>%
  filter(Sex == "Both", Metric %in% c("Rate (per 100,000)", "Number")) %>%
  select(location_name = Location,
         cause_name = Cause,
         year = Year,
         metric = Metric,
         val = Value,
         val_low = Lower_bound,
         val_upp = Upper_bound) %>%
  pivot_wider(names_from = metric,
              values_from = c(val, val_low, val_upp),
              names_glue = "{tolower(metric)}_{.value}") %>%
  rename(asmr = `rate_(per_100,000)_val`,
         asmr_low = `rate_(per_100,000)_val_low`,
         asmr_upp = `rate_(per_100,000)_val_upp`,
         deaths = `number_val`,
         deaths_low = `number_val_low`,
         deaths_upp = `number_val_upp`) %>%
  arrange(location_name, year, cause_name)

# Load
write_csv(tb_df, "data/processed/tb_mortality_allcountries_1990_2021.csv")
