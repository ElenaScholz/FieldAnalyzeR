#' Add Coordinates to the dataframe
#'
#' 'add_coordinates' will add the coordinates in new columns to an existing dataframe. They are added based on an identifier column
#' @param df - Type: Dataframe - The input dataframe to which coordinates will be added.
#' @param logger_coordinates - Type: String or Dataframe - The file path (Excel, CSV) or dataframe containing the coordinates.
#' @param Coordinate_Column_Name - Type: String - The name of the column in 'logger_coordinates' that contains the identifier (logger ID) for merging.
#'
#' @return Dataframe - The input dataframe with added coordinates based on the identifier column.
#'
#' @export
#'
add_coordinates <- function(df, logger_coordinates, Coordinate_Column_Name = "Logger_ID"){

  # Check if logger_coordinates is a file or dataframe
  check_file(logger_coordinates)

  # Read and format coordinates
  coordinates <- check_format(logger_coordinates)

  # Merge dataframe with coordinates based on the identifier column
  logger_df <- merge(df, coordinates, by = Coordinate_Column_Name)

  # Return the dataframe with added coordinates
  return(logger_df)
}
