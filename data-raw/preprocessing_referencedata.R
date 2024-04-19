## code to prepare `DATASET` dataset goes here

library(fastR)
library(dplyr)



#### used functions

# function to filter quality
filter_quality <- function(data, quality_column, acceptable_qualities) {
  data %>%
    dplyr::filter({{ quality_column }} %in% acceptable_qualities)
}

create_subset <- function(data, columns) {
  data %>%
    dplyr::select({{ columns }})
}

merge_dataframes <- function(df1, df2) {
  merged_df <- merge(df1, df2, by = "Date")
  return(merged_df)
}
####


reference_data <- read_data("data-raw/raw-data/",add_ID_from_filename = FALSE )

lst <- reference_data$`example-lst-MOD11A1-061-results.csv`

ndsi <- reference_data$`example-ndsi-MOD10A1-061-results.csv`


# prepare LandSurfaceTemperature
lst_day <- lst[c("Category", "Date", "MOD11A1_061_LST_Day_1km", "MOD11A1_061_QC_Day_MODLAND")]
lst_night <- lst[c("Category", "Date", "MOD11A1_061_LST_Night_1km", "MOD11A1_061_QC_Night_MODLAND")]

ndsi <- ndsi[c("Category", "Date", "MOD10A1_061_NDSI_Snow_Cover", "MOD10A1_061_NDSI_Snow_Cover_Basic_QA_Quality_Mask_Description")]
names(ndsi) <- c("Logger_ID", "Date", "SnowCover", "Quality")
# filter out all values that are not snow related
ndsi$SnowCover[ndsi$SnowCover >= 100 ] <- NA


# filter datasets
lst_day <- dplyr::filter(lst_day, MOD11A1_061_QC_Day_MODLAND %in% c("0b00", "0b01"))
names(lst_day) <- c("Logger_ID", "Date", "Temperature_Day", "Quality")
lst_night <- dplyr::filter(lst_night, MOD11A1_061_QC_Night_MODLAND %in% c("0b00", "0b01"))
names(lst_night) <- c("Logger_ID", "Date", "Temperature_Night", "Quality")

ndsi_daily <- filter_quality(ndsi, quality_column = Quality, c("Best", "Good", "OK"))
ndsi_daily <- mutate_dates(ndsi_daily, time_column = "Date", time_format = "%Y-%m-%d")


#combine datasets and convert in daily Temperature in degree Celisius
lst_combined <- left_join(lst_day, lst_night, by = c("Logger_ID", "Date"), suffix = c("_day", "_night"))

lst_daily <- lst_combined %>% mutate(Temperature_C = ((Temperature_Day + Temperature_Night) / 2) - 273.15)

combined_data <- merge_dataframes(ndsi_daily, lst_daily)
# Subset the dataset to keep only the desired variables

lst_ndsi_subset <- combined_data %>%
  select(Date, Logger_ID.x, SnowCover, Julian, Month, Year, Temperature_C) %>%
  rename(Logger_ID = Logger_ID.x,
         LST_C = Temperature_C)


usethis::use_data(lst_daily, overwrite = TRUE)
usethis::use_data(ndsi_daily, overwrite = TRUE)
usethis::use_data(lst_ndsi_subset, overwrite = TRUE)
