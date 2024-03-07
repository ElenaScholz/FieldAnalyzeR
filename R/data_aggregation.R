#' aggregate_data
#'
#' `aggregate_data` aggregates data daily, monthly, seasonal and annual and calculates Mean, Standard Derivation, Minimum and Maximum for the Temperature
#'
#' @param input_file Type: String: The input file containing the data to be aggregatet
#' @param column_names Optional, Type: List; a list with the column names of the input file. Default is:  list(id = 'ID', date = "Date" , year = "Year", month = "Month", time = "Time", temperature = "temp")
#' @param daily Optional, Type: logical; Default value is TRUE
#' @param monthly Optional, Type: logical; Default value is TRUE
#' @param annual Optional, Type: logical; Default value is TRUE
#' @param seasonal Optional, Type: logical; Default value is TRUE
#'
#' @return returns dataframes for aggregatet temperature data (daily, monthly, seasonal, annual)
#'
#' @import utils
#' @import dplyr
#' @import rlang
#'
#' @examples
#' aggregate_data(input_file= "~/Documents/R-FinalExam/packagetest/spatialdata/logger_geodata.csv", column_names = list(id = 'Logger.ID', date = "Date" , year = "Year", month = "Month", time = "Time", temperature = "X1.oC"))
#' aggregate_data(input_file= "~/Documents/R-FinalExam/packagetest/spatialdata/logger_geodata.csv", column_names = list(id = 'Logger.ID', date = "Date" , year = "Year", month = "Month", time = "Time", temperature = "X1.oC"), daily = TRUE, monthly = TRUE, annual = TRUE, seasonal = TRUE)
#'
#' @export
#'

aggregate_data <- function(input_file, column_names = list(id = 'ID', date = "Date" , year = "Year", month = "Month", time = "Time", temperature = "temp"), daily = TRUE, monthly = TRUE, annual = TRUE, seasonal = TRUE){
  source("~/Documents/R-Projects/loggeranalysis/R/helperFunctions.R")
  check_file(input_file)
  ds <- check_format(input_file)

  subset_ds <- ds[, c(column_names$id, column_names$date, column_names$year, column_names$month, column_names$time, column_names$temperature)]

  if (daily){
    daily_temperature_data <- subset_ds %>%
      group_by(!!sym(column_names$id), !!sym(column_names$date)) %>%
      summarise(mean_temperature = mean(!!sym(column_names$temperature), na.rm = TRUE),
                std_temperature = sd(!!sym(column_names$temperature), na.rm = TRUE),
                T_min = min(!!sym(column_names$temperature), na.rm = TRUE),
                T_max = max(!!sym(column_names$temperature), na.rm = TRUE))
  }

  if (monthly){
    monthly_temperature_data <- subset_ds %>%
      group_by(!!sym(column_names$id), !!sym(column_names$month)) %>%
      summarise(mean_temperature = mean(!!sym(column_names$temperature), na.rm = TRUE),
                std_temperature = sd(!!sym(column_names$temperature), na.rm = TRUE),
                T_min = min(!!sym(column_names$temperature), na.rm = TRUE),
                T_max = max(!!sym(column_names$temperature), na.rm = TRUE))
  }

  # Create a new column for the season
  subset_ds <- subset_ds %>%
    mutate(season = month_to_season(column_names$month))

  if (seasonal){
    seasonal_temperature_data <- subset_ds %>%
      group_by(!!sym(column_names$id), season) %>%
      summarise(mean_temperature = mean(!!sym(column_names$temperature), na.rm = TRUE),
                std_temperature = sd(!!sym(column_names$temperature), na.rm = TRUE),
                T_min = min(!!sym(column_names$temperature), na.rm = TRUE),
                T_max = max(!!sym(column_names$temperature), na.rm = TRUE))
  }

  if (annual){
    annual_temperature_data <- subset_ds %>%
      group_by(!!sym(column_names$id), !!sym(column_names$year)) %>%
      summarise(mean_temperature = mean(!!sym(column_names$temperature), na.rm = TRUE),
                std_temperature = sd(!!sym(column_names$temperature), na.rm = TRUE),
                T_min = min(!!sym(column_names$temperature), na.rm = TRUE),
                T_max = max(!!sym(column_names$temperature), na.rm = TRUE))
  }

  return(list(daily_temperature_data = daily_temperature_data, monthly_temperature_data = monthly_temperature_data, seasonal_temperature_data = seasonal_temperature_data, annual_temperature_data = annual_temperature_data))
}
