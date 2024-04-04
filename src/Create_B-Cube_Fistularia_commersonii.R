library(rgbif)
library(dplyr)
library(stringr)
library(purrr)

#get all records of Fistularia commersonii
myData<-occ_data(taxonKey=5200938, limit = 20000)
fcommdata <- myData$data

#filter
filtered_fcommdata <- fcommdata %>%
  filter(occurrenceStatus == "PRESENT",
         !is.na(decimalLatitude) & !is.na(decimalLongitude),
         is.na(identificationVerificationStatus) | !str_detect(identificationVerificationStatus, "unverified|unvalidated|not able to validate|control could not be conclusive due to insufficient knowledge|unconfirmed|unconfirmed - not reviewed|validation requested"),
         !grepl('ZERO_COORDINATE', fcommdata$issues),
         !grepl('COORDINATE_OUT_OF_RANGE', fcommdata$issues),
         !grepl('COORDINATE_INVALID', fcommdata$issues),
         !grepl('COUNTRY_COORDINATE_MISMATCH', fcommdata$issues),
         !is.na(month))

# Transform to cube -------------------------------------------------------

#get centroid of the grid cell of a quarter degree grid
getCentroidGrid <- function(coord){
  if(coord < 0){
    round((coord)*4)/4 - 0.025
  } else {
    round((coord)*4)/4 + 0.025
  }
}

enh_filtered_fcommdata <- filtered_fcommdata %>%
  mutate(coordinateUncertaintyInMeters = replace_na(filtered_fcommdata$coordinateUncertaintyInMeters, 1000)) %>%
  mutate(yearMonth = paste0(year, "-", month)) %>%
  mutate(gridCornerLat = map(filtered_fcommdata$decimalLatitude, ~getCentroidGrid(.x))) %>%
  mutate(gridCornerLong = map(filtered_fcommdata$decimalLongitude, ~getCentroidGrid(.x))) %>%
  mutate(cellCode = paste0(gridCornerLat, "_", gridCornerLong)) %>%
  select(speciesKey, yearMonth, cellCode, coordinateUncertaintyInMeters )

#get counts and minimum uncertainty
test <- enh_filtered_fcommdata %>% count(cellCode, yearMonth)
test2 <- aggregate(enh_filtered_fcommdata, list(enh_filtered_fcommdata$cellCode, enh_filtered_fcommdata$yearMonth), min) 
cube_fcomm <- test2 %>% left_join(test, by = c("cellCode", "yearMonth")) %>%
  select(-c(Group.1, Group.2))

write.csv(cube_fcomm, "bcube_fcomm.csv")
