# 📊 Data Notes

This folder contains the data used in the Global Epidemiology Portfolio, including raw and processed versions of datasets prepared for visualization and analysis.

The current focus is on **Tuberculosis (TB) mortality estimates** from the IHME Global Burden of Disease 2021 (GBD 2021) study. Additional datasets for other pathogens may be added in future iterations.

---

## 📁 Folder Structure

- `raw/` – Original unmodified datasets as downloaded from official sources.
- `processed/` – Cleaned and reshaped versions of raw data, ready for analysis.

---

## 📂 `raw/` Contents

### • `IHME_GBD_2021_MORTALITY_1990_2021_SR_TABLE_1_Y2024M04D03.XLSX`

- Source: [IHME GBD Data Tools](https://www.healthdata.org/research-analysis/gbd-data)
- Description: A comprehensive spreadsheet containing mortality estimates (age-standardized rates and all-age deaths) for dozens of causes across 204 countries/territories and multiple years (1990–2021).
- Included metrics:
  - **Age-standardized mortality rate per 100,000**
  - **All-age deaths**
  - With corresponding 95% uncertainty intervals (UIs)

---

## 📂 `processed/` Contents

### • `tb_mortality_processed.csv`

- Description: A cleaned and subsetted version of the IHME mortality spreadsheet focusing specifically on **Tuberculosis-related deaths** (including drug-sensitive, MDR, and HIV co-infected TB).
- Time points included: **1990, 2010, 2019, 2020, 2021**
- Countries/regions: **All locations reported by IHME (204 total)**
- Indicators included:
  - **Age-standardized mortality rate (ASMR)** per 100,000
  - **All-age death counts**
  - Both indicators include upper and lower bounds of 95% uncertainty intervals

#### 📌 Columns:

| Column         | Description                                                  |
|----------------|--------------------------------------------------------------|
| `location_name`| Country, territory, or region name                          |
| `cause_name`   | TB subcategory (e.g., drug-sensitive, MDR, HIV-related)      |
| `year`         | Calendar year of estimate                                    |
| `asmr`         | Age-standardized mortality rate per 100,000                  |
| `asmr_lower`   | Lower bound of ASMR UI                                       |
| `asmr_upper`   | Upper bound of ASMR UI                                       |
| `deaths`       | All-age death count                                          |
| `deaths_lower` | Lower bound of deaths UI                                     |
| `deaths_upper` | Upper bound of deaths UI                                     |

---

## 🔄 Processing Notes

- Extracted all rows where the cause name included “tuberculosis”
- Parsed ASMR and deaths into estimate + upper/lower bound columns
- Reshaped to long format for dashboarding and analysis
- Preserved all available country-level data to enable filtering by geography, time, or TB subtype

---

## 🔗 Source

**Institute for Health Metrics and Evaluation (IHME)**  
Global Burden of Disease 2021 (GBD 2021)  
🔗 https://www.healthdata.org/research-analysis/gbd-data  
📅 Downloaded: April 2024

---

## 🗂 Planned Additions

- Outbreak data for epidemic-prone diseases (e.g., Lassa fever, Marburg, Ebola)
- Immunization coverage and delivery strategy data
- Health system readiness indicators for vaccine rollout

---
