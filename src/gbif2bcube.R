library(rgbif)
library(dplyr)
library(stringr)
library(purrr)
library(tidyr)
library(mgrs)

getBCube <- function(name, limit = 100000, grid = "MGRS"){
  #get taxonKey
  namematch <- name_backbone(name)
  if (is.null(namematch$usageKey) ||  namematch$matchType != "EXACT"){
    stop("Invalid name")
  } else {
    id <- namematch$usageKey
  }
  #check grid parameter
  if(!grid %in% c("MGRS", "0.05")){
    stop("Invalid grid")
  }
  
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
  

  if(!"coordinateUncertaintyInMeters" %in% names(data)){
    filtered_data <- filtered_data %>% mutate(coordinateUncertaintyInMeters= 1000)
  }
  
  enh_filtered_data <- filtered_data %>%
    mutate(coordinateUncertaintyInMeters = replace_na(filtered_data$coordinateUncertaintyInMeters, 1000)) %>%
    mutate(yearMonth = paste0(year, "-", month))
  
  #give cell code according to chosen grid system
  if(grid == "MGRS"){
    enh_filtered_data <- enh_filtered_data %>%
      mutate(cellCode =  unlist(map2(enh_filtered_data$decimalLatitude, enh_filtered_data$decimalLongitude, ~latlng_to_mgrs(.x, .y))))
  } else if (grid == "0.05"){
    enh_filtered_data <- enh_filtered_data %>%
      mutate(gridCornerLat = map(enh_filtered_data$decimalLatitude, ~getCentroidGrid(.x))) %>%
      mutate(gridCornerLong = map(enh_filtered_data$decimalLongitude, ~getCentroidGrid(.x))) %>%
      mutate(cellCode = paste0(gridCornerLat, "_", gridCornerLong))
  }
  
  enh_filtered_data <- enh_filtered_data %>%
    select(speciesKey, yearMonth, cellCode, coordinateUncertaintyInMeters )
  
  #get counts and minimum uncertainty
  test <- enh_filtered_data %>% count(cellCode, yearMonth, speciesKey)
  test2 <- aggregate(enh_filtered_data, list(enh_filtered_data$cellCode, enh_filtered_data$yearMonth, enh_filtered_data$speciesKey), min) 
  cube <- test2 %>% left_join(test, by = c("cellCode", "yearMonth", "speciesKey")) %>%
    select(-c(Group.1, Group.2, Group.3))
  
  return(cube)
}

#get centroid of the grid cell of a quarter degree grid
getCentroidGrid <- function(coord){
  if(coord < 0){
    round((coord)*4)/4 - 0.025
  } else {
    round((coord)*4)/4 + 0.025
  }
}