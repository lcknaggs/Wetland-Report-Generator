# ==============================================================================
# load_data.R
# All data loading and spatial functions
# ==============================================================================

library(tidyverse)
library(readxl)
library(sf)

# ------------------------------------------------------------------------------
# Load wetland polygons from KML
# ------------------------------------------------------------------------------

load_wetland_polygons <- function(kml_file = "data/wetland_polygons.kml") {

  if (!file.exists(kml_file)) stop("KML file not found: ", kml_file)

  polygons <- st_read(kml_file, quiet = TRUE)

  # Find name column
  name_col <- intersect(c("Name", "name", "TIA_ID", "TIA ID", "ID", "id"),
                        names(polygons)) |> first()

  if (is.na(name_col)) {
    stop("Could not find name column in KML. Available: ",
         paste(names(polygons), collapse = ", "))
  }

  polygons <- polygons |>
    mutate(TIA_ID = sub("^(\\d+)\\s.*", "\\1", as.character(.data[[name_col]])),
           TIA_ID = as.character(TIA_ID))

  # Warn and deduplicate
  dupes <- polygons$TIA_ID[duplicated(polygons$TIA_ID)]
  if (length(dupes) > 0) {
    warning("Duplicate TIA_IDs in KML (keeping first): ",
            paste(unique(dupes), collapse = ", "))
    polygons <- polygons[!duplicated(polygons$TIA_ID), ]
  }

  polygons
}

# ------------------------------------------------------------------------------
# Load all Excel data for one or more sites
# ------------------------------------------------------------------------------

load_all_sites <- function(data_folder = "data") {

  read_sheet <- function(file, na_vals = c("", "NA", "N/A")) {
    path <- file.path(data_folder, file)
    if (!file.exists(path)) {
      warning("File not found: ", path)
      return(tibble())
    }
    read_excel(path, na = na_vals) |>
      mutate(TIA_ID = as.character(TIA_ID))
  }

  list(
    site_info    = read_sheet("site_information.xlsx"),
    eco          = read_sheet("ecological_integrity_assessment.xlsx"),
    social       = read_sheet("social_values.xlsx"),
    species      = read_sheet("species_inventory.xlsx") |>
                     mutate(c_value = suppressWarnings(as.numeric(c_value))),
    water        = read_sheet("water_quality.xlsx"),
    soil         = read_sheet("soil.xlsx")
  )
}

# ------------------------------------------------------------------------------
# Filter all data to a single site
# ------------------------------------------------------------------------------

filter_site <- function(all_data, tia_id) {
  id <- as.character(tia_id)
  map(all_data, \(df) if (nrow(df) > 0) filter(df, TIA_ID == id) else df)
}

# ------------------------------------------------------------------------------
# Get polygon for a single site
# ------------------------------------------------------------------------------

get_site_polygon <- function(polygons, tia_id) {
  id <- as.character(tia_id)
  poly <- filter(polygons, TIA_ID == id)
  if (nrow(poly) == 0) stop("No polygon found for TIA_ID: ", id)
  if (!all(st_is_valid(poly))) poly <- st_make_valid(poly)
  poly
}

# ------------------------------------------------------------------------------
# Safe column getter (returns NA if column or data missing)
# ------------------------------------------------------------------------------

safe_get <- function(df, col, default = NA_character_) {
  if (nrow(df) == 0 || !col %in% names(df)) return(default)
  val <- df[[col]][1]
  if (is.na(val)) return(default)
  as.character(val)
}
