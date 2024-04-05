# Function to perform mutation operations
#
#doesn't work
mutate_columns <- function(df) {
  mutated_df <- df%>%
    dplyr::mutate(Time = as.POSIXct(Time, format = "%d.%m.%Y %H:%M:%S")) %>%
    dplyr::mutate(Date = as.Date(Time)) %>% # Extracting only the date component
    dplyr::mutate(Julian = lubridate::yday(Time)) %>%
    dplyr::mutate(Month = factor(month.name[as.integer(format(Time, "%m"))], levels = month.name)) %>%
    dplyr::mutate(Year = lubridate::year(Time))

}


all_logger <- read_data(input_directory = "/home/ela/Documents/R-FinalExam/Muragl/")
logger_df <- all_logger$A50276_20231006143640.csv

logger_df <- rename_columns(logger_df)

str(logger_df$Time)

logger_df <- mutate_columns(logger_df)
