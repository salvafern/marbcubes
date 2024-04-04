library(arrow)
library(tidyverse)

# Define relative paths
input_data_path <- "data/raw_data"
output_data_path <- "data/derived_data"

# List all CSV files in the raw data directory
csv_files <- list.files(input_data_path, pattern = "\\.csv$", full.names = TRUE)

# Extract species names from CSV filenames
# CSV files should have consistent names like "speciesname_data_cube.csv"
species_names <- gsub("_data_cube\\.csv$", "", basename(csv_files))

# Loop over each species
for (species in species_names) {
  # Read input data
  species_data_cube <- open_dataset(
    sources = file.path(input_data_path, paste0(species, "_data_cube.csv")), 
    col_types = schema(eqdgcCode = string()),
    format = "csv"
  )
  
  # Prepare output path
  pq_path <- file.path(output_data_path, "parquet", species)
  
  # Write dataset
  species_data_cube %>%
    mutate(year = as.integer(substring(yearMonth, 1, 4))) %>%
    group_by(year) %>%
    write_dataset(path = pq_path, format = "parquet")
  
  # List files and sizes
  files_tibble <- tibble(
    files = list.files(pq_path, recursive = TRUE),
    size_MB = file.size(file.path(pq_path, files)) / 1024^2
  )
  
  # Print the species name and corresponding file sizes
  print(paste("Species:", species))
  print(files_tibble)
  cat("\n")
}