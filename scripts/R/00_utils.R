## Utility functions for data processing

#' Count missing values
#' 
#' @param x A vector
#' @return Number of NA values in x
num_na <- function(x) {
  sum(is.na(x))
}

#' Compute a rate per 100,000 population
#' 
#' @param n Numerator (e.g., number of cases)
#' @param pop Denominator (population)
#' @return Rate per 100,000 population or NA if pop <= 0
rate_per_100k <- function(n, pop) {
  ifelse(pop > 0, (n / pop) * 1e5, NA_real_)
}

#' Compute case fatality ratio percentage
#' 
#' @param deaths Number of deaths
#' @param cases Number of cases
#' @return Case fatality ratio (%), NA if cases <= 0
cfr_pct <- function(deaths, cases) {
  ifelse(cases > 0, (deaths / cases) * 100, NA_real_)
}
