#!/usr/bin/env Rscript
#
# Simple SIR model demonstration
#
# This script runs a toy Susceptible–Infected–Recovered (SIR) model using the
# `deSolve` package.  It illustrates basic compartmental modelling and
# plotting in R.  Parameters and initial conditions are chosen for
# demonstration and do not correspond to a specific disease.  Use this
# script as a portfolio example to show your coding skills.

library(deSolve)
library(ggplot2)

sir <- function(time, state, parameters) {
  with(as.list(c(state, parameters)), {
    dS <- -beta * S * I
    dI <- beta * S * I - gamma * I
    dR <- gamma * I
    list(c(dS, dI, dR))
  })
}

# Initial state: majority susceptible, small fraction infected
initial_state <- c(S = 0.999, I = 0.001, R = 0)
# Parameters: transmission (beta) and recovery (gamma)
parameters <- c(beta = 0.4, gamma = 0.1)  # R0 = beta/gamma = 4
# Time grid (days)
times <- seq(0, 160, by = 1)

out <- ode(y = initial_state, times = times, func = sir, parms = parameters)
out_df <- as.data.frame(out)

plot_df <- tidyr::pivot_longer(out_df, cols = c("S", "I", "R"), names_to = "compartment", values_to = "value")

ggplot(plot_df, aes(x = time, y = value, colour = compartment)) +
  geom_line(linewidth = 1) +
  labs(title = "Toy SIR Trajectory", x = "Time (days)", y = "Proportion of population", colour = "Compartment") +
  theme_minimal()