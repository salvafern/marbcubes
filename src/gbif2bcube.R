library(rgbif)
library(dplyr)
library(stringr)
library(purrr)
library(tidyr)

getBCube <- function(id, limit = 100000){
  #get all records 
  myData<-occ_data(taxonKey=id, limit = limit)
  data <- myData$data
  
  #filter
  filtered_data <- data %>%
    filter(occurrenceStatus == "PRESENT",
           !is.na(speciesKey),
           !is.na(decimalLatitude) & !is.na(decimalLongitude),
           !grepl('ZERO_COORDINATE', data$issues),
           !grepl('COORDINATE_OUT_OF_RANGE', data$issues),
           !grepl('COORDINATE_INVALID', data$issues),
           !grepl('COUNTRY_COORDINATE_MISMATCH', data$issues),
           !is.na(month))
  
  if("identificationVerificationStatus" %in% names(data)){
    #filter
    filtered_data <- filtered_data %>%
      filter(is.na(identificationVerificationStatus) | !str_detect(identificationVerificationStatus, "unverified|unvalidated|not able to validate|control could not be conclusive due to insufficient knowledge|unconfirmed|unconfirmed - not reviewed|validation requested"))
  }
  
  # Transform to cube -------------------------------------------------------
  
  #get centroid of the grid cell of a quarter degree grid
  getCentroidGrid <- function(coord){
    if(coord < 0){
      round((coord)*4)/4 - 0.025
    } else {
      round((coord)*4)/4 + 0.025
    }
  }
  
  if(!"coordinateUncertaintyInMeters" %in% names(data)){
    filtered_data <- filtered_data %>% mutate(coordinateUncertaintyInMeters= 1000)
  }
  
  enh_filtered_data <- filtered_data %>%
    mutate(coordinateUncertaintyInMeters = replace_na(filtered_data$coordinateUncertaintyInMeters, 1000)) %>%
    mutate(yearMonth = paste0(year, "-", month)) %>%
    mutate(gridCornerLat = map(filtered_data$decimalLatitude, ~getCentroidGrid(.x))) %>%
    mutate(gridCornerLong = map(filtered_data$decimalLongitude, ~getCentroidGrid(.x))) %>%
    mutate(cellCode = paste0(gridCornerLat, "_", gridCornerLong)) %>%
    select(speciesKey, yearMonth, cellCode, coordinateUncertaintyInMeters )
  
  #get counts and minimum uncertainty
  test <- enh_filtered_data %>% count(cellCode, yearMonth, speciesKey)
  test2 <- aggregate(enh_filtered_data, list(enh_filtered_data$cellCode, enh_filtered_data$yearMonth, enh_filtered_data$speciesKey), min) 
  cube <- test2 %>% left_join(test, by = c("cellCode", "yearMonth", "speciesKey")) %>%
    select(-c(Group.1, Group.2, Group.3))
  
  return(cube)
}
