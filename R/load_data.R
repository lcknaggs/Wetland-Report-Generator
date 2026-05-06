# load_data.R setup script
# required to run final report.Rmd

# Install and load required packages
packageLoad <- function(x) {
  for (i in seq_along(x)) {
    if (!x[i] %in% installed.packages()) {
      install.packages(x[i])
    }
    library(x[i], character.only = TRUE)
  }
}

packages <- c(
  "tidyverse",
  "readxl",
  "flextable",
  "sf",
  "here",
  "kableExtra"
)

packageLoad(packages)

# Load all Excel sheets from data folder 
load_all_sites <- function(data_folder = "data") {
  read_sheet <- function(file, na_vals = c("", "NA", "N/A")) {
    read_excel(file.path(data_folder, file), na = na_vals) |>
      mutate(TIA_ID = as.character(TIA_ID))
  }

  list(
    site_info = read_sheet("site_information.xlsx"),
    eco       = read_sheet("ecological_integrity_assessment.xlsx"),
    social    = read_sheet("social_values.xlsx"),
    species   = read_sheet("species_inventory.xlsx") |>
                  mutate(c_value = suppressWarnings(as.numeric(c_value))),
    water     = read_sheet("water_quality.xlsx"),
    soil      = read_sheet("soil.xlsx")
  )
}
