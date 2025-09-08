# Simple SIR Model (Toy Example)

This directory contains a small demonstration of a Susceptible–Infected–Recovered (SIR) model implemented in R.  The goal is not to model a specific disease but to show your ability to write clean, reproducible code and visualise dynamic processes.

## Files

- **`sir_model.R`** – The main script defining the SIR model and plotting the trajectories of the susceptible, infected and recovered compartments over time.  It uses the `deSolve` package to numerically integrate the differential equations and `ggplot2` for plotting.

## Running the model

To run the script and view the plot:

```sh
Rscript sir_model.R
```

This will produce a line plot showing how the proportions of susceptible, infected and recovered individuals evolve over 160 days with a reproduction number (R₀) of 4.0.  Feel free to adjust the parameters (`beta` and `gamma`) and initial conditions to explore different epidemic trajectories.

## Notes

- The model assumes a closed population with no births or deaths.
- The parameters used here are arbitrary; they do not correspond to a particular pathogen.
- This example is included in your portfolio to demonstrate compartmental modelling skills and may serve as a template for more complex analyses.