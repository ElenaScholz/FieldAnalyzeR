
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

# filter products by topic and layer

filter_products_by_topic <- function(df, filter_topic = NULL, product_version = NULL){

  # Initialize an empty dataframe to store the filtered results
  filtered_df <- data.frame(ProductAndVersion = character(),
                            Description = character(),
                            Source = character(),
                            TemporalGranularity = character(),
                            stringsAsFactors = FALSE)

  # Filter by both topic and product version if provided
  if (!is.null(filter_topic) && !is.null(product_version)){
    filtered_df <- subset(df, grepl(filter_topic, Description) & grepl(product_version, ProductAndVersion))
  } else if (!is.null(filter_topic)){
    # Filter only by topic if product version is not provided
    filtered_df <- subset(df, grepl(filter_topic, Description))
  } else if (!is.null(product_version)){
    # Filter only by product version if topic is not provided
    filtered_df <- subset(df, grepl(product_version, ProductAndVersion))
  } else {
    # If no filters are provided, return the original dataframe
    return(df)
  }

  # If filtered dataframe is empty, return NULL
  if (nrow(filtered_df) == 0) {
    print("No datasets match the provided criteria.")
    return(NULL)
  }

  # Prompt the user to choose a dataset
  cat("Choose a dataset:\n")
  for (i in 1:nrow(filtered_df)) {
    cat(i, ": ", filtered_df[i, "ProductAndVersion"], "\n")
    cat("    Description: ", filtered_df[i, "Description"], "\n")
    cat("    Temporal Resolution: ", filtered_df[i, "TemporalGranularity"], "\n")
  }

  # Get user input for selecting a dataset
  selected_index <- as.integer(readline(prompt = "Enter the number corresponding to the dataset: "))

  # Check if the selected index is valid
  if (selected_index < 1 || selected_index > nrow(filtered_df)) {
    print("Invalid selection. Please enter a valid number.")
    return(NULL)
  }

  # Get the selected dataset
  selected_dataset <- filtered_df[selected_index, ]


  # Return the selected dataset
  product_name <- selected_dataset$ProductAndVersion
  return(product_name)



}


get_product_layer <- function(product_name){
  API_URL = 'https://appeears.earthdatacloud.nasa.gov/api/'
  product <- product_name

  # Request layers for the 1st product in the list: product
  product_req <- httr::GET(paste0(API_URL,"product/", product))  # Request the info of a product from product URL
  product_content <- httr::content(product_req)                             # Retrieve content of the request
  product_response <- jsonlite::toJSON(product_content, auto_unbox = TRUE)      # Convert the content to JSON object
  remove(product_req, product_content)                                # Remove the variables that are not needed anymore
  #prettify(product_response)                                          # Print the prettified response
  layer_names <- names(jsonlite::fromJSON(product_response))                                    # print the layer's names


  cat("Choose layers (enter numbers seperated by spaces):\n")
  for (i in seq_along(layer_names)){
    cat(i, ": ", layer_names[i], "\n")
  }

  layer_names_indices <- as.integer(strsplit(readline(prompt = "Enter the numbers corresponding to the layers (enter numbers seperated by spaces): "), "\\s+")[[1]])

  if (any(layer_names_indices < 1) || any(layer_names_indices > length(layer_names))) {
    print("Invalid selection. Please enter valid numbers.")
    return(NULL)
  }
  # Get the selected layers
  selected_layers <- layer_names[layer_names_indices]

  # Return the selected layers
  # return(selected_layers)


}
