#' Create Subset
#'
#' `create_subset()` generates a subset of a given dataframe based on a vector of column names.
#'
#' @param data The input dataframe.
#' @param columns A vector containing the names of columns to be retained in the subset.
#'
#' @importFrom dplyr select
#'
#' @return A subset of the original dataframe.
#' @export
#'

create_subset <- function(data, columns) {
  data %>%
    dplyr::select({{ columns }})
}
