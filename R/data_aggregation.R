#' Aggregate Data
#'
#' Perform data aggregation by Day, Month, Season, or Year based on a specified aggregation column.
#'
#' @param df A dataframe containing the Logger data. Columns should include "Logger_ID", "Month", "Date", "Year", "Julian", and the specified aggregation column.
#' @param aggregation_type The type of aggregation to perform: "daily", "monthly", "seasonal", or "annual".
#' @param aggregation_column The name of the column to use for aggregation.
#'
#' @return A dataframe with the aggregated data including mean, standard deviation, minimum, and maximum of the specified aggregation column.
#'
#' @importFrom dplyr group_by filter summarise mutate case_when first
#' @importFrom stats sd
#' @importFrom lubridate month year
#'
#' @export
#'
aggregate_data <- function(df, aggregation_type, aggregation_column) {
  # Check if required columns are present in the dataframe
  required_columns <- c("Logger_ID", "Month", "Date", "Year", "Julian", aggregation_column)
  if (!all(required_columns %in% colnames(df))) {
    missing_columns <- required_columns[!required_columns %in% colnames(df)]
    stop(paste("Required columns missing in the dataframe:", paste(missing_columns, collapse = ", ")))
  }

  # Rename the specified aggregation column within the dataframe
  colnames(df)[colnames(df) == aggregation_column] <- "Aggregation_Column"

  # Perform aggregation based on aggregation type
  if (aggregation_type == "daily") {
    daily_data <- df %>%
      dplyr::group_by(Date) %>%
      dplyr::filter(!is.na(Aggregation_Column)) %>%
      dplyr::summarise(mean_value = mean(Aggregation_Column),
                       std_value = stats::sd(Aggregation_Column),
                       min_value = min(Aggregation_Column),
                       max_value = max(Aggregation_Column),
                       Logger_ID = dplyr::first(Logger_ID),
                       Month = dplyr::first(Month),
                       Year = dplyr::first(Year),
                       Julian = dplyr::first(Julian))
    return(daily_data)
  } else if (aggregation_type == "monthly") {
    monthly_data <- df %>%
      dplyr::group_by(Month, Year) %>%
      dplyr::filter(!is.na(Aggregation_Column)) %>%
      dplyr::summarise(mean_value = mean(Aggregation_Column),
                       std_value = stats::sd(Aggregation_Column),
                       min_value = min(Aggregation_Column),
                       max_value = max(Aggregation_Column),
                       Logger_ID = dplyr::first(Logger_ID))
    return(monthly_data)
  } else if (aggregation_type == "annual") {
    annual_data <- df %>%
      dplyr::group_by(Year) %>%
      dplyr::filter(!is.na(Aggregation_Column)) %>%
      dplyr::summarise(mean_value = mean(Aggregation_Column),
                       std_value = stats::sd(Aggregation_Column),
                       min_value = min(Aggregation_Column),
                       max_value = max(Aggregation_Column),
                       Logger_ID = dplyr::first(Logger_ID),
                       .groups = "drop")
    return(annual_data)
  } else if (aggregation_type == "seasonal") {
    seasonal_data <- df %>%
      dplyr::mutate(Season = dplyr::case_when(
        lubridate::month(Date) %in% 3:5 ~ "Spring",
        lubridate::month(Date) %in% 6:8 ~ "Summer",
        lubridate::month(Date) %in% 9:11 ~ "Autumn",
        TRUE ~ "Winter"
      )) %>%
      dplyr::group_by(Year = lubridate::year(Date), Season) %>%
      dplyr::filter(!is.na(Aggregation_Column)) %>%
      dplyr::summarise(mean_value = mean(Aggregation_Column),
                       std_value = stats::sd(Aggregation_Column),
                       min_value = min(Aggregation_Column),
                       max_value = max(Aggregation_Column),
                       Logger_ID = dplyr::first(Logger_ID),
                       .groups = "drop")
    return(seasonal_data)
  } else {
    stop("Invalid aggregation_type. Please choose 'daily', 'monthly', 'seasonal', or 'annual'.")
  }
}
