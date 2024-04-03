library(stars)
library(dplyr)

# Reads zarr files and transform to a bcube
zarr2bcubed <- function(file, variable, min_time, max_time, min_lon, 
                        max_lon, min_lat, max_lat){
  dsn <- glue::glue('ZARR:"{file}"')
  
  # Read the file with only the var of interest
  r = read_mdim(dsn, variable = variable)
  
  # slice on space and time
  t <- r |> filter(longitude > min_lon, longitude < max_lon,
                   latitude > min_lat, longitude < max_lat,
                   time > min_time, time < max_time)
  
  # Extract dimension values and variable
  d <- st_dimensions(t)
  lon = st_get_dimension_values(d, which = "longitude", center = TRUE)
  lat = st_get_dimension_values(d, which = "latitude", center = TRUE)
  time = st_get_dimension_values(d, which = "time", where = "start")
  values <- t |> pull(variable)
  
  # Add values of dimensions as dim names
  dimnames(values) <- list(lon, lat, time)
  
  # Reshape to long format
  long_df <- reshape2:::melt.array(values, 
                                   varnames = c("longitude", "latitude", "time"),
                                   na.rm = T,
                                   value.name = variable)
  
}
# debug(zarr2bcubed)
# 
# df <- zarr2bcubed(
#   "./data/chl_ssp585_2020_2100_depthsurf.zarr",
#   variable = "chl_mean",
#   decade = "2089-12-31",
#   min_lon = -30, max_lon = 45,
#   min_lat = 25, max_lat = 80
# )


# GET ONLY THE PRESENT
files <- list.files("./data/raw_data/", pattern = "baseline", full.names = TRUE)
vars <- c(
  "chl_mean",
  "dfe_mean",
  "no3_mean",
  "PAR_mean_mean",
  "phyc_mean",
  "so_mean",
  "sws_mean",
  "thetao_mean"
)

df <- zarr2bcubed(
  files[1],
  variable = vars[1],
  min_time = "2009-12-31",
  max_time = "2010-01-01",
  min_lon = -30, max_lon = 45,
  min_lat = 25, max_lat = 80
)

df <- df |>
  mutate(
    cellCode = glue::glue('{round(longitude, 3)}_{round(latitude, 3)}')
  )

for(i in 2:8){
  df_i <- zarr2bcubed(
    files[i],
    variable = vars[i],
    decade = "2009-12-31",
    min_lon = -30, max_lon = 45,
    min_lat = 25, max_lat = 80
  )
  
  df_i <- df_i |>
    mutate(
      cellCode = glue::glue('{round(longitude, 3)}_{round(latitude, 3)}')
    ) |> select(-latitude, -longitude, -time)
  
  df <- df |> full_join(df_i, by = "cellCode")
  
}

# Write csv
write.csv(df, "./data/bo_baseline_bcubed.csv", fileEncoding = "UTF-8",
          row.names = FALSE, quote = FALSE)



#### GET ONLY THE FUTURE 2030 ssp119 -----------------
files <- list.files("./data", pattern = "ssp119", full.names = TRUE)
vars <- c(
  "chl_mean",
  "dfe_mean",
  "no3_mean",
  "phyc_mean",
  "so_mean",
  "sws_mean",
  "thetao_mean"
)

df_2030_ssp119 <- zarr2bcubed(
  files[1],
  variable = vars[1],
  min_time = "2029-12-31",
  max_time = "2030-01-02",
  min_lon = -30, max_lon = 45,
  min_lat = 25, max_lat = 80
)

df_2030_ssp119 <- df_2030_ssp119 |>
  mutate(
    cellCode = glue::glue('{round(longitude, 3)}_{round(latitude, 3)}')
  )

for(i in 2:7){
  df_i <- zarr2bcubed(
    files[i],
    variable = vars[i],
    min_time = "2029-12-31",
    max_time = "2030-01-02",
    min_lon = -30, max_lon = 45,
    min_lat = 25, max_lat = 80
  )
  
  df_i <- df_i |>
    mutate(
      cellCode = glue::glue('{round(longitude, 3)}_{round(latitude, 3)}')
    ) |> select(-latitude, -longitude, -time)
  
  df_2030_ssp119 <- df_2030_ssp119 |> full_join(df_i, by = "cellCode")
}
head(df_2030_ssp119)

write.csv(df_2030_ssp119, "./data/bo_2030_ssp119.csv", fileEncoding = "UTF-8",
          row.names = FALSE, quote = FALSE)


#### GET ONLY THE FUTURE 2030 ssp585 -----------------
files <- list.files("./data", pattern = "ssp585", full.names = TRUE)
vars <- c(
  "chl_mean",
  "dfe_mean",
  "no3_mean",
  "phyc_mean",
  "so_mean",
  "sws_mean",
  "thetao_mean"
)

df_2030_ssp585 <- zarr2bcubed(
  files[1],
  variable = vars[1],
  min_time = "2029-12-31",
  max_time = "2030-01-02",
  min_lon = -30, max_lon = 45,
  min_lat = 25, max_lat = 80
)

df_2030_ssp585 <- df_2030_ssp585 |>
  mutate(
    cellCode = glue::glue('{round(longitude, 3)}_{round(latitude, 3)}')
  )

for(i in 2:7){
  df_i <- zarr2bcubed(
    files[i],
    variable = vars[i],
    min_time = "2029-12-31",
    max_time = "2030-01-02",
    min_lon = -30, max_lon = 45,
    min_lat = 25, max_lat = 80
  )
  
  df_i <- df_i |>
    mutate(
      cellCode = glue::glue('{round(longitude, 3)}_{round(latitude, 3)}')
    ) |> select(-latitude, -longitude, -time)
  
  df_2030_ssp585 <- df_2030_ssp585 |> full_join(df_i, by = "cellCode")
}
head(df_2030_ssp585)

write.csv(df_2030_ssp585, "./data/bo_2030_ssp585.csv", fileEncoding = "UTF-8",
          row.names = FALSE, quote = FALSE)


#### GET ONLY THE FUTURE 2100 ssp119 -----------------
files <- list.files("./data", pattern = "ssp119", full.names = TRUE)
vars <- c(
  "chl_mean",
  "dfe_mean",
  "no3_mean",
  "phyc_mean",
  "so_mean",
  "sws_mean",
  "thetao_mean"
)

df_2100_ssp119 <- zarr2bcubed(
  files[1],
  variable = vars[1],
  min_time = "2089-12-31",
  max_time = "2090-01-02",
  min_lon = -30, max_lon = 45,
  min_lat = 25, max_lat = 80
)

df_2100_ssp119 <- df_2100_ssp119 |>
  mutate(
    cellCode = glue::glue('{round(longitude, 3)}_{round(latitude, 3)}')
  )

for(i in 2:7){
  df_i <- zarr2bcubed(
    files[i],
    variable = vars[i],
    min_time = "2089-12-31",
    max_time = "2090-01-02",
    min_lon = -30, max_lon = 45,
    min_lat = 25, max_lat = 80
  )
  
  df_i <- df_i |>
    mutate(
      cellCode = glue::glue('{round(longitude, 3)}_{round(latitude, 3)}')
    ) |> select(-latitude, -longitude, -time)
  
  df_2100_ssp119 <- df_2100_ssp119 |> full_join(df_i, by = "cellCode")
}
head(df_2100_ssp119)

write.csv(df_2100_ssp119, "./data/bo/bo_2100_ssp119.csv", fileEncoding = "UTF-8",
          row.names = FALSE, quote = FALSE)


#### GET ONLY THE FUTURE 2100 ssp585 -----------------
files <- list.files("./data", pattern = "ssp585", full.names = TRUE)
vars <- c(
  "chl_mean",
  "dfe_mean",
  "no3_mean",
  "phyc_mean",
  "so_mean",
  "sws_mean",
  "thetao_mean"
)

df_2100_ssp585 <- zarr2bcubed(
  files[1],
  variable = vars[1],
  min_time = "2089-12-31",
  max_time = "2090-01-02",
  min_lon = -30, max_lon = 45,
  min_lat = 25, max_lat = 80
)

df_2100_ssp585 <- df_2100_ssp585 |>
  mutate(
    cellCode = glue::glue('{round(longitude, 3)}_{round(latitude, 3)}')
  )

for(i in 2:7){
  df_i <- zarr2bcubed(
    files[i],
    variable = vars[i],
    min_time = "2089-12-31",
    max_time = "2090-01-02",
    min_lon = -30, max_lon = 45,
    min_lat = 25, max_lat = 80
  )
  
  df_i <- df_i |>
    mutate(
      cellCode = glue::glue('{round(longitude, 3)}_{round(latitude, 3)}')
    ) |> select(-latitude, -longitude, -time)
  
  df_2100_ssp585 <- df_2100_ssp585 |> full_join(df_i, by = "cellCode")
}
head(df_2100_ssp585)

write.csv(df_2100_ssp585, "./data/bo/bo_2100_ssp585.csv", fileEncoding = "UTF-8",
          row.names = FALSE, quote = FALSE)
