library(readxl)
library(lubridate)
library(dplyr)
library(stringr)
library(utils)
library(tools)

# reads in logger data, checks if file path and formats are correct, returns  a
#dataframe if only one file otherwise it returns a list with dataframes
# id is added



read_logger_data <- function(input_directory, csv_sep = ",", csv_comment_character = '#', id_from_file_name = TRUE, index_id = c(0, 6)) {
  source("~/Documents/R-Projects/loggeranalysis/R/helperFunctions.R")
  check_path(input_directory)
  files <- list.files(input_directory)

  logger_dataframe <- list()

  if (length(files) == 1) {
    check_file(paste0(input_directory, files))
    dataframe <- check_format(paste0(input_directory, files))
    if (id_from_file_name) {
      id_logger <- substr(files, index_id[1], index_id[2])
      dataframe$Logger.ID <- id_logger
    }
    return(dataframe)
  } else {
    for (i in files) {
      check_file(paste0(input_directory, i))
      dataframe <- check_format(paste0(input_directory, i))
      if (id_from_file_name) {
        id_logger <- substr(i, index_id[1], index_id[2])
        dataframe$Logger_ID <- id_logger
      }
      logger_dataframe[[i]] <- dataframe
    }
    return(logger_dataframe)
  }
}


ds <- read_logger_data(input_directory = "/home/ela/Documents/R-FinalExam/Muragl/")

# check columnnames - doesn't work too good - redo for only one df

check_column_names <- function(list_dataframes){

  columns <- c()

  for (i in ds){
    column_names <- colnames(i)

  }
  return(column_names = column_names)
}

#column_names <- check_column_names(ds)

# rearrange time column, if date and time are in one column or a character and not in the date time format
# rearranges it for only one dataset
library(lubridate)
library(stringr)
add_dates <- function(df){

  logger_ds <- df %>%

      mutate(date_time = str_split_fixed(Time, " ", 2)) %>%

      mutate(Date=as.Date(date_time[,1], format = "%d.%m.%Y"),
             Time = format(as.POSIXct(date_time[, 2], format = "%H:%M:%S"), format = "%H:%M:%S")) %>%

      select(-date_time) %>%

      mutate(Year=year(Date),
             Month=month(Date),
             Day=day(Date)) %>%

      select(No, Logger_ID, Date, Year, Month, Day, Time, X1.oC, HK.Bat.V)



  return(logger_ds=logger_ds)

}

all_logger <- list()

for (i in seq_along(ds)) {
  df <- add_dates(ds[[i]])
  all_logger[[i]] <- df
  # Assign names to the data frames based on Logger_ID column
  names(all_logger)[i] <- unique(df$Logger_ID)
}

add_coordinates <- function(df, logger_coordinates_file, add_coordinates_By_Column = "Logger_ID"){

  check_file(logger_coordinates_file)


  coordinates <- check_format(logger_coordinates_file)

  logger_df <- merge(df, coordinates, by = add_coordinates_By_Column)

  return(logger_df = logger_df)
}

coordinates <- list()
for (i in seq_along(all_logger)){
  df_coord <- add_coordinates(all_logger[[i]], logger_coordinates_file = "/home/ela/Documents/R-FinalExam/Loggerpositionen_Muragl.csv")

  coordinates[[i]] <- df_coord

  names(coordinates)[i] <- unique(df_coord$Logger_ID)
}


group_data <- function(df, col_name_for_grouped_data){
  if (col_name_for_grouped_data == Date){
    daily_temperature_data <- df %>%
      group_by(Date) %>%
      summarise(mean_temperature = mean(X1.oC, na.rm = TRUE),
                std_temperature = sd(X1.oC, na.rm = TRUE),
                T_min = min(X1.oC, na.rm = TRUE),
                T_max = max(X1.oC, na.rm = TRUE)) %>%
      mutate(Year = year(Date),
             Month = month(Date),
             Day = day(Date))


    # extract the id, x and y values
    logger_id <- df$Logger_ID[1]
    x <- df$X[1]
    y <- df$Y[1]
    # add these values to the new dataframe
    daily_temperature_data <- daily_temperature_data %>%
      mutate(Logger_ID = logger_id, X = x, Y = y) %>%
      select(Logger_ID, Year, Month, Day, Date, mean_temperature, std_temperature, T_min, T_max, X, Y)
  }


}
test <- coordinates$A50276

library(dplyr)
library(lubridate)






library(ggplot2)
library(ggplot2)

daily_temperature_data %>%
  ggplot(aes(x = Day, y = mean_temperature), g) +
  geom_point(color = "darkorchid4") +
  facet_wrap(~Year, ncol = 3) +
 # scale_x_date(date_breaks = "1 month", date_labels = "%b") +  # Divide axis into months
  labs(title = "Temperature - Logger1",
       subtitle = "The data frame is sent to the plot using pipes",
       y = "Daily Temperature (°C)",
       x = "Date")+ theme_bw(base_size = 15)

library(ggplot2)



library(ggplot2)
library(hrbrthemes)
daily_temperature_data %>%
  ggplot(aes(x = Day, y = mean_temperature, group = Year)) +
  geom_line() +
  labs(title = "Temperature - Logger1",
       subtitle = "The data frame is sent to the plot using pipes",
       y = "Daily Temperature (°C)",
       x = "Date") +
  theme_minimal() +
  facet_wrap(~Year, ncol = 3)

daily_temperature_data %>%
  ggplot(aes(x = Day, y = mean_temperature))+
  geom_line(color = "#69b3a2")+
  xlab("")+
  theme_ipsum()+
  theme(axis.text.x = element_text(angle=60, hjust = 1))


library(sf)
make_spatial_data <- function(df, coordinate_column = c("X", "Y"), data_crs_original, transformed_crs = "+proj=longlat +datum=WGS84", preferred_df = "logger_wgs84") {
  logger_original_crs <- st_as_sf(df, coords = c("X", "Y"), crs = data_crs_original)
  logger_wgs84 <- st_transform(logger_original_crs, crs = transformed_crs)

  if (preferred_df == "logger_wgs84") {
    return(logger_wgs84)
  } else {
    return(logger_original_crs)
  }
}


spatial_df <- list()

for (i in seq_along(coordinates)){
  sf_object <- make_spatial_data(coordinates[[i]], data_crs_original = "EPSG:21781")
  spatial_df[[i]] <- sf_object

  # Assign names to spatial_df if needed
  names(spatial_df)[i] <- unique(sf_object$Logger_ID)
}






# aggregate data functions

# plots: https://r-graph-gallery.com/279-plotting-time-series-with-ggplot2.html
