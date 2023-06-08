# Nice to know :) --------------------------------------------------------

# Write comments: start comment with "#"
# Insert sections: use shortcut Ctrl+Shift+R
# Run code in selected line(s): use shortcut Ctrl+Enter
# Restart Rstudio: use shortcut Ctrl+Shift+F10
# Save script file: use shortcut Ctrl+S

# Getting started --------------------------------------------------------

# Load packages
library(tidyverse)
library(janitor)
library(noradstats)

# Load data
df_statsys_ten <- read_aiddata("statsys_ten.csv")

# Clean column names
df_statsys_ten <- clean_names(df_statsys_ten)

# Basic ODA data
df_oda_ten <- df_statsys_ten |> 
  filter(type_of_flow == "ODA") |> 
  filter(type_of_agreement != "Rammeavtale")

# View data structure
glimpse(df_oda_ten)

# Function
f_region <- function(select_region = NULL, select_year = NULL){
  
  # Find top ten countries
  v_topten <- df_oda_ten |> 
    filter(main_region == select_region,
           year == select_year,
           income_category != "Unspecified") |> 
    group_by(recipient_country_no) |> 
    summarise(nok_tusen = sum(disbursed_1000_nok)) |> 
    slice_max(nok_tusen, n = 10) |> 
    pull(recipient_country_no)
  
  # Make table
  df_region <- df_oda_ten |> 
    filter(main_region == select_region,
           year == select_year,
           chapter_code_name != "N/A") |> 
    mutate(topten = if_else(
      recipient_country_no %in% v_topten, recipient_country_no, "Andre land/uspesifisert")
    ) |> 
    group_by(chapter_code_name, post_code_name, topten) |> 
    summarise(nok_tusen = sum(disbursed_1000_nok)) |> 
    ungroup() |> 
    mutate(topten = fct_relevel(topten, c(v_topten, "Andre land/uspesifisert"))) |> 
    arrange(topten) |> 
    pivot_wider(names_from = topten, values_from = nok_tusen) |> 
    adorn_totals("both")
}

df_africa <- f_region(select_region = "Africa", select_year = 2022)
df_asia <- f_region(select_region = "Asia", select_year = 2022)