# Tableau Workbook Notes

This document outlines the structure and logic of the Tableau Public dashboard envisioned for the Global Disease Epidemiology Portfolio.  Use these notes as a guide when building your workbook.

## Overview tab

**Purpose:** Offer a snapshot of your portfolio.  Include key performance indicators such as the number of countries, years of data, number of datasets and number of analyses/publications.  Add a succinct “elevator pitch” summarising your skills (e.g., data management, analysis, visualization, survey design and QA/QC).

**Design tips:**
- Use cards or tiles for each KPI.  Make them clickable links that navigate to the appropriate tab.
- Keep colours restrained; choose one accent colour for highlights and callouts.
- Add a short paragraph explaining what the user will find in the dashboard.

## TB Analytics tab

**Data:** Use `data/processed/tb_timeseries.csv` as the primary source.  Filter to the countries of interest and compute per‑100 000 incidence rates in Tableau if not precomputed.

**Recommended visuals:**
- A choropleth map showing the latest year of TB incidence by country (hover to reveal values and uncertainty).
- Line charts to show TB incidence trends over time for selected countries.  Allow multi‑select filters for region and country.
- Bar or stacked bar charts for treatment outcomes (success, failure, lost to follow‑up) if you extend the dataset to include these variables.

**Calculations:**
- `Incidence per 100k = SUM(tb_incidence_per100k)` (the sample data already includes this rate).
- `Incidence lower` and `Incidence upper` fields can be displayed as error bands on line charts using Tableau’s built‑in confidence band feature.

## Emerging Infectious Diseases tab

**Data:** Use `data/processed/eid_outbreaks.csv`.  Each row corresponds to one outbreak of a specific pathogen in a given country and year.

**Recommended visuals:**
- Line chart of outbreak counts by pathogen over time.  Filter by pathogen or region as needed.
- Bar chart of case fatality ratios across pathogens and years.
- Map with bubbles sized by case counts and coloured by pathogen.

**Calculations:**
- `CFR%` is included in the dataset; you may compute it directly if not.
- Use filter actions to focus on specific diseases, years or countries.

## Survey & M&E tab (Methods showcase)

**Data:** Create a long table linking indicators to definitions and sources using `indicator_catalog_sample.csv` or an expanded version.  If you have examples of questionnaire design or monitoring frameworks, summarise them here.

**Visuals:**
- A table or list of indicators with filters for domain (e.g., incidence, mortality, treatment outcomes).
- A heatmap or bar chart showing data completeness or quality checks by indicator and country/year.
- Summary boxes describing QA/QC methods and design standards.

## About & Methods tab

Provide a narrative description of your methods: data sources, cleaning steps, QA checks and limitations.  Link to your GitHub repository and CV.

## General design guidance

- Use a clean, minimalist aesthetic with plenty of white space.
- Align charts and text boxes to a grid to maintain visual order.
- Consistently label axes and use informative titles.
- Keep tooltips concise but informative, including definitions, uncertainty information and source citations.