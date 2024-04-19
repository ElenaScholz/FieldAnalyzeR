#' Create Subset
#'
#' create_subset() creates a subset of a given dataframe based on a vector of columns
#'
#' @param data The input dataframe
#' @param columns A vector containing all columns that should stay in the dataframe
#'
#' @return returns a subset of the original dataframe
#' @export
#'

create_subset <- function(data, columns) {
  data %>%
    dplyr::select({{ columns }})
}
