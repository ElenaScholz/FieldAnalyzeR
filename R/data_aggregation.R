#' Aggregate Data
#'
#' Data aggregation by Day, Month, Season or Year
#'
#' @param df MANDATORY Type: dataframe- - the input Dataframe containing the Loggerdata (please apply rename colnames and modify dates before)
#' @param aggregation_type MANDATORY - Type: String - you can choose between "daily", "monthly", "seasonal" and "annual"
#' @param temperature_column OPTIONAL - Type: String - if temperature column is not "Temperature_C" change the parameter
#'
#' @return returns a dataframe with the aggregated temperature data. it will contain new columns for mean, standard derivation, minimum and maximum Temperature
#'
#' @import dplyr
#' @import lubridate
#' @importFrom stats sd
#'
#' @example
#'
#' aggregate_data(df = read.csv("/home/ela/Documents/R-FinalExam/examples/01_logger.csv"), aggregation_type = "daily, temperature_column = "Temperature_C")
#'
#' @export
#'
#'
aggregate_data <- function(df, aggregation_type, temperature_column) {
  required_columns <- c("Logger_ID","Month", "Date", "Year", "Julian",temperature_column)

  if (!all(required_columns %in% colnames(df))) {
    missing_columns <- required_columns[!required_columns %in% colnames(df)]
    stop(paste("Required columns missing in the dataframe:", paste(missing_columns, collapse = ", ")))
  }

  colnames(df)[colnames(df) == temperature_column] <- "Temperature_C"

  if (aggregation_type == "daily") {
    daily_temperature <- dplyr::group_by(df, Date) %>%
      dplyr::summarise(mean_temperature = mean(Temperature_C),
                       std_temperature = stats::sd(Temperature_C),
                       min_temperature = min(Temperature_C),
                       max_temperature = max(Temperature_C),
                       Logger_ID = dplyr::first(Logger_ID),
                       Month = dplyr::first(Month),
                       Year = dplyr::first(Year),
                       Julian = dplyr::first(Julian))
    return(daily_temperature)
  } else if (aggregation_type == "monthly") {
    monthly_temperature <- dplyr::group_by(df, Month, Year) %>%
      dplyr::summarise(mean_temperature = mean(Temperature_C),
                       std_temperature = stats::sd(Temperature_C),
                       min_temperature = min(Temperature_C),
                       max_temperature = max(Temperature_C))
    return(monthly_temperature)
  } else if (aggregation_type == "annual") {
    annual_temperature <- dplyr::group_by(df, Year) %>%
      dplyr::summarise(mean_temperature = mean(Temperature_C),
                       std_temperature = stats::sd(Temperature_C),
                       min_temperature = min(Temperature_C),
                       max_temperature = max(Temperature_C),
                       .groups = "drop")
    return(annual_temperature)
  } else if (aggregation_type == "seasonal") {
    seasonal_temperature <- dplyr::mutate(df, Season = dplyr::case_when(
      lubridate::month(Date) %in% 3:5 ~ "Spring",
      lubridate::month(Date) %in% 6:8 ~ "Summer",
      lubridate::month(Date) %in% 9:11 ~ "Autumn",
      TRUE ~ "Winter"
    )) %>%
      dplyr::group_by(Year = lubridate::year(Date), Season) %>%
      dplyr::summarise(mean_temperature = mean(Temperature_C),
                       std_temperature = stats::sd(Temperature_C),
                       Tmin_temperature = min(Temperature_C),
                       Tmax_temperature = max(Temperature_C),
                       .groups = "drop")
    return(seasonal_temperature)
  } else {
    stop("Invalid aggregation_type. Please choose 'daily', 'monthly', 'seasonal', or 'annual'.")
  }
}

