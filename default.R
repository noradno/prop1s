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
