#' Convert Spatial Data to WGS84 Coordinates
#'
#' This function takes spatial data in a specified coordinate reference system (CRS) and transforms it to WGS84 coordinates.
#'
#' @param df A data frame containing spatial data.
#' @param coordinate_column A character vector specifying the column names for the X and Y coordinates.
#' @param data_crs_original The CRS of the original spatial data.
#' @param transformed_crs The target CRS for transformation. Defaults to WGS84.
#' @param logger_id_column The name of the column containing the logger IDs. Defaults to "Logger_ID".
#'
#' @importFrom sf st_as_sf
#' @importFrom sf st_transform
#' @importFrom sf st_coordinates
#' @import dplyr
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#' @importFrom dplyr bind_cols
#' @importFrom tibble rowid_to_column
#'
#'
#' @return A list with two elements:
#' \item{spatial_object}{The spatial object transformed to WGS84 coordinates.}
#' \item{coordinates_df}{A data frame containing the WGS84 longitude, latitude coordinates along with the logger IDs.}
#'
#' @export
#'
make_spatial_data <- function(df, coordinate_column = c("X", "Y"), data_crs_original, transformed_crs = "+proj=longlat +datum=WGS84", logger_id_column = "Logger_ID") {

  logger_original_crs <- sf::st_as_sf(df, coords = coordinate_column, crs = data_crs_original)
  logger_transformed_crs <- sf::st_transform(logger_original_crs, crs = transformed_crs)

  coordinates_df <- logger_transformed_crs %>%
    sf::st_coordinates() %>%
    as.data.frame() %>%
    dplyr::mutate(longitude = .[,1],
           latitude = .[,2]) %>%
    tibble::rowid_to_column("id") %>%
    dplyr::select(id, longitude, latitude) %>%
    dplyr::bind_cols(category = df[[logger_id_column]])

  return(list(spatial_object = logger_transformed_crs, coordinates_df = coordinates_df))
}
