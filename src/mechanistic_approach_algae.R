# Read the CSV file
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
  
  data <- read_csv(paste0("C:/Users/ward.standaert/Desktop/b-cubed/",files[1]))
  # data <- readRDS(paste0("C:/Users/ward.standaert/Desktop/b-cubed/",f))
  
  # Apply conditions for each variable, excluding specified columns
  data$thetao_mean <- apply_conditions(data$thetao_mean, "thetao_mean", "constant", -99999, 15, 0)
  data$thetao_mean <- apply_conditions(data$thetao_mean, "thetao_mean", "linear increasing", 15, 23, 0)
  data$thetao_mean <- apply_conditions(data$thetao_mean, "thetao_mean", "constant", 23, 27, 1)
  data$thetao_mean <- apply_conditions(data$thetao_mean, "thetao_mean", "linear decreasing", 27, 28, 0)
  data$thetao_mean <- apply_conditions(data$thetao_mean, "thetao_mean", "constant", 28, 999999, 0)
  
  data$so_mean <- apply_conditions(data$so_mean, "so_mean", "constant", 0, 30, 0)
  data$so_mean <- apply_conditions(data$so_mean, "so_mean", "linear increasing", 30, 35, 0)
  data$so_mean <- apply_conditions(data$so_mean, "so_mean", "constant", 35, 999999, 1)
  
  data$chl_mean <- apply_conditions(data$chl_mean, "chl_mean", "linear increasing", 0, 6, 0)
  
  data$PAR_mean_mean  <- apply_conditions(data$PAR_mean_mean, "PAR_mean_mean", "linear increasing", 0, 48, 0)
  
  data$no3_mean <- apply_conditions(data$no3_mean, "no3_mean", "linear increasing", 0, 49, 0)
  
  
  data <- data %>% 
    mutate(hsi_mean = rowMeans(select(., c(chl_mean, so_mean, 
                                           thetao_mean, PAR_mean_mean, 
                                           no3_mean)), na.rm = TRUE))
  
  data <- data %>% select(longitude, latitude, cellCode, time, chl_mean, 
                          so_mean, PAR_mean_mean, thetao_mean, no3_mean, hsi_mean)
  
  # Write the modified data to a new CSV file
  output_csv <- paste0("C:/Users/ward.standaert/Desktop/b-cubed/new_algae_", f)
  write.csv(data, file = output_csv, row.names = FALSE)
  
  # Display message
  cat("New CSV file created:", output_csv)
}