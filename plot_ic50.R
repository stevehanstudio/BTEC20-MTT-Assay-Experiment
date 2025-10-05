# IC50 Curve Plotting for BTEC20 Experiment #2
# This script reads raw absorbance data, calculates percent viability,
# and generates a dose-response curve.

# --- 1. Load Required Libraries ---
# We use the 'tidyverse' package for data manipulation (dplyr, tidyr) and
# plotting (ggplot2).
library(tidyverse)

# --- 2. Read the Data ---
# This reads the raw absorbance data from the CSV file.
# Make sure the CSV file is in the same directory as this R script.
raw_data <- read.csv("mtt_assay_data.csv")

# --- 3. Process and Tidy the Data ---
# The data is currently in a "wide" format. We need to convert it to a "long"
# format to make it easier to work with for calculations and plotting.
# We will also add the caffeine concentrations corresponding to each column.
processed_data <- raw_data %>%
  # Convert from wide to long format
  pivot_longer(cols = starts_with("Col"), names_to = "Column",
               values_to = "Absorbance") %>%
  # Add a new column with the correct caffeine concentrations based on the
  # protocol
  mutate(Concentration_mM = case_when(
    Column == "Col3" ~ 0,
    Column == "Col4" ~ 0.5,
    Column == "Col5" ~ 1.0,
    Column == "Col6" ~ 2.0,
    Column == "Col7" ~ 4.0,
    Column == "Col8" ~ 8.0,
    TRUE ~ NA_real_ # Assign NA to columns we don't need for the plot
    # (Col1, Col2)
  )) %>%
  # Remove the control columns that are not part of the dose-response curve
  filter(!is.na(Concentration_mM))

# --- 4. Calculate Percent Viability ---
# First, we need to find the average absorbance of the control wells
# (0 mM Caffeine)
control_avg <- processed_data %>%
  filter(Concentration_mM == 0) %>%
  summarise(avg_absorbance = mean(Absorbance)) %>%
  pull(avg_absorbance) # pull() extracts the single value

# Now, we calculate the percent viability for every data point
viability_data <- processed_data %>%
  mutate(Percent_Viability = (Absorbance / control_avg) * 100)

# To make plotting easier, let's also create a summary table with the mean
# and standard error
summary_data <- viability_data %>%
  group_by(Concentration_mM) %>%
  summarise(
    Mean_Viability = mean(Percent_Viability),
    SD_Viability = sd(Percent_Viability), # Standard Deviation
    N = n(),
    SE_Viability = SD_Viability / sqrt(N) # Standard Error
  )

# --- 5. Generate the Plot ---
# We use ggplot2 to create the dose-response curve.
# This plot will show the mean viability with error bars, as well as the
# individual data points.
ic50_plot <- ggplot(summary_data,
                    aes(x = Concentration_mM, y = Mean_Viability)) +

  # Add a line connecting the mean viability points
  geom_line(color = "blue", linewidth = 1) +

  # Add error bars representing the standard error
  geom_errorbar(aes(ymin = Mean_Viability - SE_Viability,
                    ymax = Mean_Viability + SE_Viability),
                width = 0.2, color = "blue") +

  # Add points for the mean viability values
  geom_point(color = "blue", size = 4, shape = 15) +

  # Show the individual, raw data points to visualize the spread
  geom_jitter(data = viability_data,
              aes(x = Concentration_mM, y = Percent_Viability),
              width = 0.1, alpha = 0.5, color = "red") +

  # Add a horizontal dashed line at 50% viability to indicate the IC50 level
  geom_hline(yintercept = 50, linetype = "dashed", color = "black") +

  # Add labels and title for clarity
  labs(
    title = "Effect of Caffeine on CHO Cell Viability (MTT Assay)",
    subtitle = "Data shows high variability; IC50 cannot be determined.",
    x = "Caffeine Concentration (mM)",
    y = "Percent Viability (%)"
  ) +

  # Use a clean, scientific theme for the plot
  theme_bw() +

  # Set the y-axis to start at 0
  scale_y_continuous(limits = c(0, NA))

# --- 6. Display and Save the Plot ---
# This will show the plot in the RStudio plots pane.
# Only print the plot in interactive sessions to avoid Rscript
# creating Rplots.pdf
if (interactive()) {
  print(ic50_plot)
}

# Save the plot as a PNG image
ggsave("ic50_plot.png", plot = ic50_plot, width = 8, height = 6, dpi = 300)
