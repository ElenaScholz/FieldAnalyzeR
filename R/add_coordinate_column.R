#' Add Coordinates to the dataframe
#'
#' 'add_coordinates' will add the coordinates in new columns to an existing dataframe. They are added based on an identifier column
#' @param df MANDATORY - Type: Dataframe - input dataframe
#' @param logger_coordinates MANDATORY - Type: String , contains the directory of the file (excel, csv) or dataframe with the coordinates
#' @param Coordinate_Column_Name MANDATORY - Type: String - the column that contains the logger id and on which the coordinates will be merged to the dataframe
#'
#' @return logger dataset with the coordinates for the logger position
#' @examples
#' add_coordinates(df = read.csv("/home/ela/Documents/R-FinalExam/examples/02_logger.csv"), "/home/ela/Documents/R-FinalExam/Loggerpositionen_Muragl.csv")
#' @export
#'

add_coordinates <- function(df, logger_coordinates, Coordinate_Column_Name = "Logger_ID"){

  check_file(logger_coordinates)


  coordinates <- check_format(logger_coordinates)

  logger_df <- merge(df, coordinates, by = Coordinate_Column_Name)

  return(logger_df = logger_df)
}

