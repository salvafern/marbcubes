library(tidyverse)

files <- list.files("C:/Users/ward.standaert/Desktop/b-cubed", pattern = ".csv")

# Define a function to apply conditions based on variable specifications
apply_conditions <- function(data, variable, type, min_val, max_val, val1) {
  if (type == "constant") {
    data[data >= min_val & data <= max_val & !is.na(data)] <- val1
  } else if (type == "linear increasing") {
    data[data >= min_val & data <= max_val & !is.na(data)] <- 1 / (max_val - min_val) * (data[data >= min_val & data <= max_val & !is.na(data)] - min_val)
  } else if (type == "linear decreasing") {
    data[data >= min_val & data <= max_val & !is.na(data)] <- (- 1 / (max_val - min_val) * (data[data >= min_val & data <= max_val & !is.na(data)] - min_val)) + 1
  }
  return(data)
}

for(f in files) {
  # Read the CSV file

  data <- readRDS(paste0("C:/Users/ward.standaert/Desktop/b-cubed/",f))
  # data <- read_csv(paste0("C:/Users/ward.standaert/Desktop/b-cubed/",f))
  
  data <- data %>% mutate(chl_mean = chl_mean * 100)
  
  # Apply conditions for each variable, excluding specified columns
  data$thetao_mean <- apply_conditions(data$thetao_mean, "thetao_mean", "constant", -9999, 15, 0)
  data$thetao_mean <- apply_conditions(data$thetao_mean, "thetao_mean", "linear increasing", 15, 19.5, 0)
  data$thetao_mean <- apply_conditions(data$thetao_mean, "thetao_mean", "constant", 19.5, 21, 1)
  data$thetao_mean <- apply_conditions(data$thetao_mean, "thetao_mean", "linear decreasing", 21, 30, 0)
  data$thetao_mean <- apply_conditions(data$thetao_mean, "thetao_mean", "constant", 30, 9999, 0)
  
  data$so_mean <- apply_conditions(data$so_mean, "so_mean", "constant", -9999, 32, 0)
  data$so_mean <- apply_conditions(data$so_mean, "so_mean", "linear increasing", 32, 38.5, 0)
  data$so_mean <- apply_conditions(data$so_mean, "so_mean", "constant", 38.5, 9999, 1.000)
  
  data$chl_mean <- apply_conditions(data$chl_mean, "chl_mean", "linear increasing", 0, 75, 0)
  data$chl_mean <- apply_conditions(data$chl_mean, "chl_mean", "constant", 75, 140, 1)
  data$chl_mean <- apply_conditions(data$chl_mean, "chl_mean", "linear decreasing", 140, 300, 0)
  data$chl_mean <- apply_conditions(data$chl_mean, "chl_mean", "constant", 300, 9999, 0)
  
  data <- data %>% 
    mutate(hsi_mean = rowMeans(select(., c(chl_mean, so_mean, thetao_mean)), na.rm = TRUE))
  
  data <- data %>% select(longitude, latitude, cellCode, time, chl_mean, so_mean, thetao_mean, hsi_mean)
  
  # Write the modified data to a new CSV file
  output_csv <- paste0("C:/Users/ward.standaert/Desktop/b-cubed/new_fish_", str_remove(files[1], ".rds"), ".csv")
  write.csv(data, file = output_csv, row.names = FALSE)
  
  # Display message
  cat("New CSV file created:", output_csv)
}

