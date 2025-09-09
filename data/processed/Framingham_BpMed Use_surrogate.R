#!/usr/bin/env Rscript

# ============================================================
# Author: Biruk Kebede
# Project: Framingham Assignment
# File: R/03_analysis_framingham.R
# Research Question:
#   Which demographic and lifestyle factors (education, sex, age, BMI, smoking)
#   are associated with the odds of being on blood pressure medication (BPMeds)?
# ============================================================

# --- Load libraries ---
library(dplyr)
library(ggplot2)


# --- Load raw data ---
framingham <- read.csv("data/raw/framingham.csv")

# --- Explore raw data ---
summary(framingham)
str(framingham)
table(framingham$education)
table(framingham$male)
table(framingham$currentSmoker)

# --- Clean data ---
framingham_clean <- framingham %>%
  na.omit() %>%
  mutate(
    education = factor(
      education,
      levels = c(1, 2, 3, 4),
      labels = c("0–11 years", "High School Diploma/GED",
                 "Vocational School", "Higher Education")
    ),
    male = factor(male, labels = c("Female", "Male")),
    BPMeds = factor(BPMeds, labels = c("No", "Yes")),
    currentSmoker = factor(currentSmoker, labels = c("No", "Yes"))
  )

# --- Descriptive statistics ---
summary(framingham_clean)
table(framingham_clean$education)
table(framingham_clean$male, framingham_clean$education)
prop.table(table(framingham_clean$currentSmoker, framingham_clean$education))

# ============================================================
# Logistic regressions
# ============================================================

# Univariate models
slr_sex <- glm(BPMeds ~ male, family = binomial, data = framingham_clean)
summary(slr_sex); exp(coef(slr_sex)); exp(confint(slr_sex))

slr_age <- glm(BPMeds ~ age, family = binomial, data = framingham_clean)
summary(slr_age); exp(coef(slr_age)); exp(confint(slr_age))

slr_bmi <- glm(BPMeds ~ BMI, family = binomial, data = framingham_clean)
summary(slr_bmi); exp(coef(slr_bmi)); exp(confint(slr_bmi))

slr_smk <- glm(BPMeds ~ currentSmoker, family = binomial, data = framingham_clean)
summary(slr_smk); exp(coef(slr_smk)); exp(confint(slr_smk))

slr_edu <- glm(BPMeds ~ education, family = binomial, data = framingham_clean)
summary(slr_edu); exp(coef(slr_edu)); exp(confint(slr_edu))

# Multivariate models
mlr_edu_sex <- glm(BPMeds ~ education + male, family = binomial, data = framingham_clean)
summary(mlr_edu_sex); exp(coef(mlr_edu_sex)); exp(confint(mlr_edu_sex))

mlr_edu_sex_age <- glm(BPMeds ~ education + male + age, family = binomial, data = framingham_clean)
summary(mlr_edu_sex_age); exp(coef(mlr_edu_sex_age)); exp(confint(mlr_edu_sex_age))

mlr_noBMI <- glm(BPMeds ~ education + male + age + currentSmoker, family = binomial, data = framingham_clean)
summary(mlr_noBMI); exp(coef(mlr_noBMI)); exp(confint(mlr_noBMI))

mlr_all <- glm(BPMeds ~ education + male + age + currentSmoker + BMI, family = binomial, data = framingham_clean)
summary(mlr_all); exp(coef(mlr_all)); exp(confint(mlr_all))

# ============================================================
# Visualizations (added)
# ============================================================

# 1) Simple regression: Age → BPMeds
framingham_clean$pred_age <- predict(slr_age, type = "response")

ggplot(framingham_clean, aes(x = age, y = pred_age)) +
  geom_line(color = "blue") +
  labs(title = "Predicted Probability of BP Meds Use by Age",
       x = "Age (years)", y = "Predicted Probability") +
  theme_minimal()

# 2) Multiple regression: Age + BMI + Sex → BPMeds
mlr_sub <- glm(BPMeds ~ age + BMI + male, family = binomial, data = framingham_clean)

new_data <- expand.grid(
  age = seq(min(framingham_clean$age), max(framingham_clean$age), length.out = 100),
  BMI = mean(framingham_clean$BMI, na.rm = TRUE),
  male = levels(framingham_clean$male)
)

new_data$pred_prob <- predict(mlr_sub, newdata = new_data, type = "response")

ggplot(new_data, aes(x = age, y = pred_prob, color = male)) +
  geom_line(size = 1.2) +
  labs(title = "Predicted Probability of BP Meds Use by Age and Sex",
       x = "Age (years)", y = "Predicted Probability", color = "Sex") +
  theme_minimal()
