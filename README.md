# Colorado Critical Wetlands of the Front Range Urban Corridor Report

This is an R Markdown report summarizing Ecological Integrity Assessment (EIA) data collected in 2025 across sites in the Colorado Front Range Urban Corridor. Data was collected under two projects:

-   **SNHS** — Statewide Natural Heritage Surveys: undisturbed wetland habitat in remote pockets of the Front Range
-   **FRVW** — Front Range Vulnerable Wetlands Project: wetlands at risk of habitat destruction on the development front

------------------------------------------------------------------------

## Report Contents

-   Ecological Integrity Assessment scores (landscape, hydrology, vegetation, soil)
-   Floristic Quality Assessment using Colorado C-values
-   Water quality metrics (conductivity, temperature, pH)
-   Social values assessment developed by Colorado Natural Heritage Program
-   Appendices: Ecological Integrity Assessment Data, Soil Data, Water Quality Data, Most Frequently Observed Species, Site Overview Maps

------------------------------------------------------------------------

## Project Structure

```         
├── data/
│   ├── site_information.xlsx
│   ├── ecological_integrity_assessment.xlsx
│   ├── social_values.xlsx
│   ├── species_inventory.xlsx
│   ├── water_quality.xlsx
│   └── soil.xlsx
├── maps/
│   ├── Front_Range_Overview_Map.jpg
│   └── report_map_<TIA_ID>.jpg
├── R/
│   ├── load_data.R
│   └── calculate_fqa.R
├── reports/
│   └── final_report.Rmd
├── .gitignore
└── README.md
```

------------------------------------------------------------------------

## Requirements

Install required R packages before knitting:

``` r
install.packages(c("tidyverse", "flextable", "sf", "here", "kableExtra", "readxl"))
```

------------------------------------------------------------------------

## Usage

In RStudio open the final_report.Rmd located in the reports folder. Knit the R Markdown to generate a report using excel data sheets formatted as above.

Alternatively run this code:

``` r
rmarkdown::render("reports/final_report.Rmd")
```

The rendered HTML will be saved to `reports/` folder next to the R markdown document.

------------------------------------------------------------------------

## Data

Raw data is stored in `data/` as Excel files. The species inventory uses a custom Colorado C-value list for Floristic Quality Assessment calculations, which may differ from the `fqacalc` package database (`colorado_2020`). When fqacalc package is updated this package can be used for FQA calculations.

------------------------------------------------------------------------

## Protocol Reference

[Colorado Ecological Integrity Assessment Field Manual v2.1](https://www.cnhp.colostate.edu/download/documents/2016/2016_Colorado_EIA_Field_Manual_Version_2.1.pdf)

------------------------------------------------------------------------

*Report authored by Luke Knaggs. Data collected by Hanna Mohr and Luke Knaggs in 2025.*
