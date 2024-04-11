#' mutate time column
#'
#' This function mutates the time-related columns in the dataframe, including Time, Date,
#' Julian, Month, and Year.
#'
#' @param df MANDATORY, Dataframe containing the time-related columns
#' @param time_column MANDATORY, Type: String, The column name containing the Date and Time or only Date column
#' @param time_format MANDATORY, Type: String, The format of Time and Date. For example: "%d.%m.%Y %H:%M:%S"
#'
#' @return dataframe with the correct Time, Date, Juliam Month and Year columns
#'
#' @import dplyr
#' @import lubridate
#' @import rlang
#'
#' @examples
#'
#'mutated_df <- mutate_dates(df = read.csv("/home/ela/Documents/R-FinalExam/examples/02_logger.csv"), time_column = "Time", time_format = "%d.%m.%Y %H:%M:%S")
#'
#' @export
#'

mutate_dates <- function(df, time_column, time_format) {

    mutated_df <- df %>%
      dplyr::mutate(!!time_column := as.POSIXct(!!rlang::sym(time_column), format = time_format)) %>%
      dplyr::mutate(Date = as.Date(!!rlang::sym(time_column))) %>% # Extracting only the date component
      dplyr::mutate(Julian = lubridate::yday(!!rlang::sym(time_column))) %>%
      dplyr::mutate(Month = factor(month.name[as.integer(format(!!rlang::sym(time_column), "%m"))], levels = month.name)) %>%
      dplyr::mutate(Year = lubridate::year(!!rlang::sym(time_column)))

    return(mutated_df)
  }





