# calculate_fqa.R script
# C-values have not been updated since 2020
# This function uses more updated c-value added to the species list to calculated8 the fqi
# c-values were added using an internal list that has yet to be published
# When c-value list is published the fqacalc package can be used for to calculate fqi 



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