
# calculate_fqa.R
# Floristic Quality Assessment calculations

library(tidyverse)

calculate_fqa <- function(species_df) {

  empty <- list(mean_c = NA_real_, native_mean_c = NA_real_,
                fqi = NA_real_, native_fqi = NA_real_,
                total_species = 0L, native_species = 0L)

  if (nrow(species_df) == 0) return(empty)

  if (!"c_value" %in% names(species_df)) {
    warning("No c_value column in species data — FQA will be NA.")
    return(modifyList(empty, list(
      total_species  = nrow(species_df),
      native_species = sum(species_df$native_status == "Native", na.rm = TRUE)
    )))
  }

  sp <- species_df |>
    mutate(c_value = suppressWarnings(as.numeric(c_value)))

  all_c    <- sp$c_value[!is.na(sp$c_value)]
  native   <- sp |> filter(native_status == "Native", !is.na(c_value))

  mean_c        <- if (length(all_c) > 0) mean(all_c) else NA_real_
  fqi           <- if (!is.na(mean_c)) mean_c * sqrt(nrow(sp)) else NA_real_
  native_mean_c <- if (nrow(native) > 0) mean(native$c_value) else NA_real_
  native_fqi    <- if (!is.na(native_mean_c)) native_mean_c * sqrt(nrow(native)) else NA_real_

  list(
    mean_c        = round(mean_c, 2),
    native_mean_c = round(native_mean_c, 2),
    fqi           = round(fqi, 2),
    native_fqi    = round(native_fqi, 2),
    total_species = nrow(sp),
    native_species = nrow(native)
  )
}
