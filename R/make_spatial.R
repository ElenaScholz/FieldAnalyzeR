#' Create a spatial object in wgs84 coordinates
#'
#' @param df MANDATORY - Type:dataframe - df must be with coordinates
#' @param coordinate_column OPTIONAL - Type: a vector - defining the columnnames for the coordinates
#' @param data_crs_original MANDATORY - Type: String - String with EPSG code in the format :"EPSG:XXXXX"
#' @param transformed_crs OPTIONAL - Type: String - the crs to which the original should be transformed
#' @param preferred_spatial_object OPTIONAL - Type: String - choose between : "logger_wgs84" , "logger_original_crs"
#'
#' @return an sf object
#'
#' @import sf
#'
#' @export
#'
make_spatial_data <- function(df, coordinate_column = c("X", "Y"), data_crs_original, transformed_crs = "+proj=longlat +datum=WGS84", preferred_spatial_object = "logger_wgs84") {

  logger_original_crs <- sf::st_as_sf(df, coords = c("X", "Y"), crs = data_crs_original)
  logger_wgs84 <- sf::st_transform(logger_original_crs, crs = transformed_crs)

  if (preferred_spatial_object == "logger_wgs84") {
    return(logger_wgs84)
  } else {
    return(logger_original_crs)
  }
}


