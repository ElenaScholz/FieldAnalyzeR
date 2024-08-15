#' read_data
#' reads in files used for the analysis of logger data. Possible file types are: Excel, csv or a dataframe
#' @param input_directory MANDATORY, Type: String - The input directory where the file(s) is/are stored
#' @param skip_lines OPTIONAL, Type: Integer - If your csv file has some lines above the actual data, change the parameter from 0 to the number of lines that need to be skipped.
#' @param csv_sep MANDATORY, Type: String - The csv seperator used in the file. If no
#' @param csv_comment_character OPTIONAL, Type: String - default values: ","
#' @param add_ID_from_filename OPTIONAL, Type: TRUE/FALSE - default value: TRUE
#' @param index_id OPTIONAL, Type: vector - should contain the start and end position of the ID in the filename, default: c(0,6)
#'
#' @return a single dataframe or a list of dataframes containing the raw data
#'
#'
#' @export
#'

read_data <- function(input_directory, skip_lines = 0, csv_sep = ",", csv_comment_character = '#', add_ID_from_filename = TRUE, index_id = c(0, 6)) {

  check_path(input_directory)
  files <- list.files(input_directory)

  logger_dataframes <- list()

  if (length(files) == 1) {
    check_file(paste0(input_directory, files))
    dataframe <- check_format(paste0(input_directory, files), skip_lines = skip_lines)
    if (add_ID_from_filename) {
      id_logger <- substr(files, index_id[1], index_id[2])
      dataframe$Logger.ID <- id_logger
    }
    return(dataframe)
  } else {
    for (i in files) {
      check_file(paste0(input_directory, i))
      dataframe <- check_format(paste0(input_directory, i))
      if (add_ID_from_filename) {
        id_logger <- substr(i, index_id[1], index_id[2])
        dataframe$Logger_ID <- id_logger
      }
      logger_dataframes[[i]] <- dataframe
    }
    return(logger_dataframes)
  }
}

