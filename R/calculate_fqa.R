# calculate_fqa.R
# Floristic Quality Assessment calculations
library(tidyverse)

calculate_fqa <- function(species_df) {
  sp     <- species_df |> mutate(c_value = as.numeric(c_value))
  native <- sp |> filter(native_status == "Native", !is.na(c_value))
  all_c  <- sp$c_value[!is.na(sp$c_value)]
  
  list(
    mean_c        = round(mean(all_c), 2),
    native_mean_c = round(mean(native$c_value), 2),
    fqi           = round(mean(all_c) * sqrt(nrow(sp)), 2),
    native_fqi    = round(mean(native$c_value) * sqrt(nrow(native)), 2),
    total_species  = nrow(sp),
    native_species = nrow(native)
  )
}