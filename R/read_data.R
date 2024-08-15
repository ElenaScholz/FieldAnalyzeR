#' read_data
#' Reads in files used for the analysis of logger data. Possible file types are Excel, CSV, or a data frame.
#'
#' @param input_directory MANDATORY, Type: String - The input directory where the file(s) are stored.
#' @param skip_lines OPTIONAL, Type: Integer - Number of lines to skip before the actual data. Default is 0.
#' @param csv_sep OPTIONAL, Type: String - The separator used in the CSV file. Default is ",".
#' @param csv_comment_character OPTIONAL, Type: String - Character for commenting lines in CSV. Default is '#'.
#' @param add_ID_from_filename OPTIONAL, Type: TRUE/FALSE - Whether to add an ID from the filename to the data. Default is TRUE.
#' @param index_id OPTIONAL, Type: vector - Vector specifying the start and end positions of the ID in the filename. Default is c(0, 6).
#'
#' @return A single data frame or a list of data frames containing the raw data.
#'
#' @export
#'
read_data <- function(input_directory, skip_lines = 0, csv_sep = ",", csv_comment_character = '#', add_ID_from_filename = TRUE, index_id = c(0, 6)) {

  check_path(input_directory)
  files <- list.files(input_directory)

  logger_dataframes <- list()

  if (length(files) == 1) {
    check_file(paste0(input_directory, files))
    dataframe <- check_format(paste0(input_directory, files), skip_lines = skip_lines, csv_sep = csv_sep, comment.char = csv_comment_character)
    if (add_ID_from_filename) {
      id_logger <- substr(files, index_id[1], index_id[2])
      dataframe$Logger_ID <- id_logger
    }
    return(dataframe)
  } else {
    for (i in files) {
      check_file(paste0(input_directory, i))
      dataframe <- check_format(paste0(input_directory, i), skip_lines = skip_lines, csv_sep = csv_sep, comment.char = csv_comment_character)
      if (add_ID_from_filename) {
        id_logger <- substr(i, index_id[1], index_id[2])
        dataframe$Logger_ID <- id_logger
      }
      logger_dataframes[[i]] <- dataframe
    }
    return(logger_dataframes)
  }
}
