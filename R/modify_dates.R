#' Mutate Time Column
#'
#' This function mutates the time-related columns in the dataframe to extract useful components such as Date, Julian day, Month, and Year.
#'
#' @param df The input dataframe containing time-related columns.
#' @param datetime_column The name of the column containing both Date and Time information, or just Date.
#' @param time_format The format of the datetime information in the datetime_column. This should follow standard datetime formatting conventions, such as "%Y-%m-%d %H:%M:%S".
#'
#' @return A modified dataframe with additional columns for Date, Julian day, Month, and Year extracted from the datetime_column.
#'
#' @import dplyr
#' @import lubridate
#' @import rlang
#'
#' @export
#'

mutate_dates <- function(df, datetime_column, time_format) {

  mutated_df <- df %>%
    dplyr::mutate(!!datetime_column := as.POSIXct(!!rlang::sym(datetime_column), format = time_format)) %>%
    dplyr::mutate(Date = as.Date(!!rlang::sym(datetime_column))) %>% # Extracting only the date component
    dplyr::mutate(Julian = lubridate::yday(!!rlang::sym(datetime_column))) %>%
    dplyr::mutate(Month = factor(month.name[as.integer(format(!!rlang::sym(datetime_column), "%m"))], levels = month.name)) %>%
    dplyr::mutate(Year = lubridate::year(!!rlang::sym(datetime_column)))

  return(mutated_df)
}
