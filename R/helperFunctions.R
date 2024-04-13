
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

check_format <- function(input, csv_sep = ",", comment.char = '#'){

  extension <- tools::file_ext(input)

  if (extension == "csv"){

    dataframe <- utils::read.csv(input, sep = csv_sep, comment.char = comment.char , header = TRUE)
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

# check if netrc file exists
check_netrc_file <- function() {
  # Path to the netrc file
  netrc_path <- file.path(Sys.getenv('HOME'), ".netrc")

  # Check if the netrc file exists
  if (!file.exists(netrc_path)) {
    cat("netrc file does not exist. Please call function setup_netrc_file() to set it up.\n")
    return(FALSE)
  } else {
    cat("netrc file exists.\n")
    return(TRUE)
  }
}

# setup netrc file
setup_netrc_file <- function() {
  cat("Setting up netrc file...\n")
  # Prompt for NASA Earthdata credentials
  username <- readline("Enter NASA Earthdata Login Username: ")
  password <- readline("Enter NASA Earthdata Login Password: ")

  # Path to the netrc file
  netrc_path <- file.path(Sys.getenv('HOME'), ".netrc")

  # Write credentials to the netrc file
  writeLines(
    c(
      "machine urs.earthdata.nasa.gov",
      sprintf("login %s", username),
      sprintf("password %s", password)
    ),
    netrc_path
  )

  cat("netrc file setup complete.\n")
}

# encode credentials
encode_credentials <- function(login, password) {
  # Concatenate login and password separated by a colon
  credentials <- paste(login, password, sep = ":")

  # Remove any spaces from the credentials
  credentials <- gsub(' ', '', credentials)

  # Encode the credentials in base64
  encoded_credentials <- jsonlite::base64_enc(credentials)

  return(encoded_credentials)
}
