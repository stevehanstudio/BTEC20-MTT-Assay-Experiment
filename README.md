# BTEC20 MTT Assay Experiment

This repository contains the analysis code and data for a MTT Assay Experiment conducted in Professor Zimmerman's BTEC 20 Mammalian Cell Culture class at City College of San Francisco (CCSF). The drug used is caffeine.

## Files

- `plot_ic50.R` - R script for analyzing MTT assay data and generating dose-response curves
- `mtt_assay_data.csv` - Raw absorbance data from the MTT assay experiment
- `ic50_plot.png` - Generated plot showing the effect of caffeine on CHO cell viability
- `BioTek_ELx808_readings.jpg` - Screenshot of raw absorbance readings from the BioTek ELx808 microplate reader

## Experimental Setup

The experiment was conducted using a BioTek ELx808 microplate reader to measure absorbance at 570 nm. The screenshot shows the raw data output from the microplate reader, displaying absorbance values for each well in a 96-well plate format. Wells were color-coded based on absorbance intensity, with darker colors indicating higher absorbance values.

## Analysis

The experiment measures the effect of caffeine on Chinese Hamster Ovary (CHO) cell viability using the MTT assay. The analysis script:

1. Reads raw absorbance data from the CSV file
2. Calculates percent viability relative to control wells (0 mM caffeine)
3. Generates a dose-response curve with error bars
4. Saves the plot as a high-resolution PNG file

## Results

For detailed experimental results and conclusions, see: [Experiment Results](https://1drv.ms/w/c/b389d1ea39d50b0e/EYCKZsYGKlhHrx7hYthsB-ABN8g6eBjNbrWHi1oT9YuNvQ?e=SyyvFT)

## Running the Analysis

To generate the IC50 plot:

```bash
Rscript plot_ic50.R
```

This will create `ic50_plot.png` in the same directory.

## Course Information

- **Course**: BTEC 20 Mammalian Cell Culture
- **Instructor**: Professor Zimmerman
- **Institution**: City College of San Francisco (CCSF)
- **Experiment**: MTT Assay with caffeine as the test compound
