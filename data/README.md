# Data Notes

This folder contains tuberculosis (TB) data for analysis and visualization.  

- The `raw/` subfolder holds original downloads (large-scale Excel files).  
- The `processed/` subfolder contains cleaned extracts focused on TB.  

## Raw Data

- **`raw/IHME_GBD_2021_MORTALITY_1990_2021_SR_TABLE_1_Y2024M04D03.XLSX`**  
  Original Excel file from the **Institute for Health Metrics and Evaluation (IHME)** Global Burden of Disease (GBD) 2021 study.  
  - **Coverage:** 1990–2021  
  - **Measure:** Mortality (age-standardized rates per 100,000 and all-age deaths)  
  - **Geography:** Global, regional, and national estimates for >200 countries  
  - **Size:** Large dataset (hundreds of thousands of rows across causes)  
  - Source: [IHME GBD Results Tool](https://ghdx.healthdata.org/gbd-results-tool)  

## Processed Data

- **`processed/tb_mortality_timeseries.csv`**  
  Cleaned extract from the IHME raw dataset, filtered to tuberculosis-specific causes.  
  - **Columns:**  
    - `location` – Country or region  
    - `year` – Calendar year (1990–2021)  
    - `deaths_all_age` – All-age TB deaths  
    - `mortality_rate_age_std` – Age-standardized TB mortality rate per 100,000  
    - `lower_bound` / `upper_bound` – Uncertainty interval  
  - **Use:** This dataset is lightweight and ready for analysis in R, Stata, or Tableau.  

## Sources

- **IHME GBD 2021:** Mortality estimates, 1990–2021 (GBD study collaborators).  
- [IHME GBD Results Tool](https://ghdx.healthdata.org/gbd-results-tool).
# Data Notes

This folder contains data used in the example portfolio.  The `raw/` subfolder is intended for original data downloads; the `processed/` subfolder holds cleaned, tidy tables ready for analysis and visualization.

## Files

- **`processed/tb_timeseries_sample.csv`** – An extract of WHO tuberculosis incidence estimates.  It contains one row per country–year combination for six countries (Afghanistan, Bangladesh, Nigeria, India, Brazil and South Africa) from 2000–2023.  Columns include:
  - `country` – country name.
  - `year` – calendar year.
  - `tb_incidence_per100k` – point estimate of TB incidence per 100 000 population.
  - `tb_incidence_per100k_low` – lower bound of the 95 % uncertainty interval.
  - `tb_incidence_per100k_upp` – upper bound of the 95 % uncertainty interval.
  These estimates are derived from the WHO global TB database【514790560382519†L49-L139】.

- **`processed/eid_outbreaks_sample.csv`** – A simulated data set of emerging infectious disease outbreaks.  It lists six pathogens (Lassa fever, Marburg virus disease, Ebola virus disease, Zika virus, SARS‑CoV‑2 and MERS‑CoV) across several countries and years.  Columns include `pathogen`, `country`, `year`, `cases`, `deaths` and `cfr_pct` (case fatality ratio), calculated as deaths divided by cases times 100.  This structure is inspired by the global outbreak dataset described by Torres Munguía et al.【776747488782145†L126-L141】.

- **`processed/indicator_catalog_sample.csv`** – A short catalog of indicators used in the dashboard.  For each indicator it provides a definition, numerator, denominator, notes on limitations and a source URL.  This helps keep definitions transparent when building visualizations.

## Transformations

- Harmonized country names using ISO‑3166 codes (not shown here since the sample uses a small subset).
- Computed per‑100 000 population rates within the visualization rather than storing derived values in the data when possible.  In this sample the rate is supplied directly to keep the example simple.
- Added lower and upper uncertainty bounds from the WHO TB estimates.
- For outbreaks, calculated the case fatality ratio (CFR) as `deaths / cases × 100`.

## Sources

- **WHO TB incidence estimates:** The WHO global TB programme publishes annual incidence estimates per 100 000 population【514790560382519†L49-L139】.  Data in this repository were downloaded from `data.who.int` and cleaned for a small subset of countries.
- **Global outbreak dataset:** An open dataset of pandemic‑ and epidemic‑prone disease outbreaks assembled from WHO’s Disease Outbreak News and the Coronavirus Dashboard contains information on 70 infectious diseases and over 2 200 public health events from 1996–2022 across 233 countries【776747488782145†L126-L141】.  The simulated `eid_outbreaks_sample.csv` mirrors this structure for illustration.
