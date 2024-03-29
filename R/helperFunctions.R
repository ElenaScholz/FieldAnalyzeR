
check_path <- function(dir){
  if (!is.character(dir)){
    stop(paste0(dir,"should be a string containing your input directory path"))
  }
  if (!dir.exists(dir)) {
    stop("The directory does not exist.")
    }
}

check_file <- function(file){
  if (!is.character(file)) {
    stop("The input directory and file must be a string")
  }
  else if (!file.exists(file)) {
    stop("The input file does not exist.")
  }
}

check_format <- function(input, csv_sep = ","){

  extension <- tools::file_ext(input)

  if (extension == "csv"){
    dataframe <- utils::read.csv(input, sep = csv_sep, header = TRUE)
  }
  else if (extension == "xlsx"){
    dataframe <- readxl::read_excel(input)
  }
  else{
    stop("Unsupported file format or input type.")
  }

  return(dataframe)

}

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

# function for meteorological seasons
month_to_season <- function(month_num) {
  if (month_num %in% c(3, 4, 5)) {
    return("Spring")
  } else if (month_num %in% c(6, 7, 8)) {
    return("Summer")
  } else if (month_num %in% c(9, 10, 11)) {
    return("Autumn")
  } else {
    return("Winter")
  }
}

# data aggregation function
