#' Check_path Function
#'
#' checks if the given path is a character and if it is an existing directory
#'
#' @param dir - A String containing the directory path
#'
#' @noRd
#'

check_path <- function(dir){
  if (!is.character(dir)){
    stop(paste0(dir,"should be a string containing your input directory path"))
  }
  if (!dir.exists(dir)) {
    stop("The directory does not exist.")
  }
}

#' Check file Function
#'
#' checks if the input file is a string, and if it exists in the directory
#'
#' @param file A string containing the file
#' @noRd
#'


check_file <- function(file){
  if (!is.character(file)) {
    stop("The input directory and file must be a string")
  }
  else if (!file.exists(file)) {
    stop("The input file does not exist.")
  }
}

#' check format Function
#'
#' Reads input dataset in either CSV or XLSX format and returns a dataframe.
#'
#' @param input_dataset Character string indicating the file path of the input dataset.
#' @param csv_sep Character specifying the delimiter used in the CSV file. Default is ",".
#' @param comment.char  Character specifying the comment character used in the CSV file. Default is "#".
#'
#' @return A dataframe
#'
#' @noRd
#'

check_format <- function(input_dataset, csv_sep = ",", comment.char = '#'){

  extension <- tools::file_ext(input_dataset)

  if (extension == "csv"){

    dataframe <- utils::read.csv(input_dataset, sep = csv_sep, comment.char = comment.char , header = TRUE)
  }
  else if (extension == "xlsx"){
    dataframe <- readxl::read_excel(input_dataset)
  }
  else{
    stop("Unsupported file format or input type.")
  }

  return(dataframe)

}

#' check_save Function
#'
#' Validates the output directory before saving files.
#'
#' @param save Logical indicating whether files should be saved.
#' @param out_dir Character string specifying the output directory path.
#'
#' @return Logical indicating whether the output directory is valid.
#'
#'
#' @noRd
#'
check_save <- function(save, out_dir){
  if (save){
    if (is.null(out_dir)){
      stop("The output directory must be provided as a non-null string, when save is TRUE.")
    }
    else if (!is.null(out_dir)){
      check_path(out_dir)
    } else {
      if (!is.null(out_dir)){
        warning("Output directory is provided but save is FALSE. Files won't be saved!")}
    }
  }}
