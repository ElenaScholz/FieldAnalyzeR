#' check_netrc_file
#'
#' Check if the .netrc File Exists
#'
#' This function checks if the .netrc file exists in the user's home directory.
#'
#' @return Logical indicating whether the .netrc file exists.
#' @noRd
check_netrc_file <- function() {
  # Path to the .netrc file
  netrc_path <- file.path(Sys.getenv('HOME'), ".netrc")

  # Check if the .netrc file exists
  if (!file.exists(netrc_path)) {
    cat("The .netrc file does not exist. Please call function setup_netrc_file() to set it up.\n")
    return(FALSE)
  } else {
    cat("The .netrc file exists.\n")
    return(TRUE)
  }
}

#' Setup .netrc File
#'
#' This function sets up the .netrc file in the user's home directory with NASA Earthdata credentials.
#'
#' @return None
#' @noRd
setup_netrc_file <- function() {
  cat("Setting up the .netrc file...\n")
  # Prompt for NASA Earthdata credentials
  username <- readline("Enter NASA Earthdata Login Username: ")
  password <- readline("Enter NASA Earthdata Login Password: ")

  # Path to the .netrc file
  netrc_path <- file.path(Sys.getenv('HOME'), ".netrc")

  # Write credentials to the .netrc file
  writeLines(
    c(
      "machine urs.earthdata.nasa.gov",
      sprintf("login %s", username),
      sprintf("password %s", password)
    ),
    netrc_path
  )

  cat(".netrc file setup complete.\n")
}

#' Encode Credentials
#'
#' This function encodes the given login and password credentials into base64 format.
#'
#' @param login The login username.
#' @param password The login password.
#'
#' @return The encoded credentials in base64 format.
#' @noRd
encode_credentials <- function(login, password) {
  # Concatenate login and password separated by a colon
  credentials <- paste(login, password, sep = ":")

  # Remove any spaces from the credentials
  credentials <- gsub(' ', '', credentials)

  # Encode the credentials in base64
  encoded_credentials <- jsonlite::base64_enc(credentials)

  return(encoded_credentials)
}





#' Filter Products by Topic
#'
#' This function filters a dataset of products by topic and/or product version.
#' It prompts the user to choose a dataset from the filtered results.
#'
#' @param data A dataframe containing product information.
#' @param topic_filter A character string indicating the topic to filter by.
#' @param version_filter A character string indicating the product version to filter by.
#'
#' @return The name of the selected dataset.
#'
#' @noRd
filter_products_by_topic <- function(data, topic_filter = NULL, version_filter = NULL) {
  # Initialize an empty dataframe to store the filtered results
  filtered_data <- data.frame(ProductAndVersion = character(),
                              Description = character(),
                              Source = character(),
                              TemporalGranularity = character(),
                              stringsAsFactors = FALSE)

  # Filter by both topic and product version if provided
  if (!is.null(topic_filter) && !is.null(version_filter)) {
    filtered_data <- subset(data, grepl(topic_filter, Description) & grepl(version_filter, ProductAndVersion))
  } else if (!is.null(topic_filter)) {
    # Filter only by topic if product version is not provided
    filtered_data <- subset(data, grepl(topic_filter, Description))
  } else if (!is.null(version_filter)) {
    # Filter only by product version if topic is not provided
    filtered_data <- subset(data, grepl(version_filter, ProductAndVersion))
  } else {
    # If no filters are provided, return the original dataframe
    return(data)
  }

  # If filtered dataframe is empty, return NULL
  if (nrow(filtered_data) == 0) {
    print("No datasets match the provided criteria.")
    return(NULL)
  }

  # Prompt the user to choose a dataset
  cat("Choose a dataset:\n")
  for (i in 1:nrow(filtered_data)) {
    cat(i, ": ", filtered_data[i, "ProductAndVersion"], "\n")
    cat("    Description: ", filtered_data[i, "Description"], "\n")
    cat("    Temporal Resolution: ", filtered_data[i, "TemporalGranularity"], "\n")
  }

  # Get user input for selecting a dataset
  selected_index <- as.integer(readline(prompt = "Enter the number corresponding to the dataset: "))

  # Check if the selected index is valid
  if (selected_index < 1 || selected_index > nrow(filtered_data)) {
    print("Invalid selection. Please enter a valid number.")
    return(NULL)
  }

  # Get the selected dataset
  selected_dataset <- filtered_data[selected_index, ]

  # Return the selected dataset
  product_name <- selected_dataset$ProductAndVersion
  return(product_name)
}

#' Get Product Layer
#'
#' This function retrieves layers for a selected product from a remote API.
#' It prompts the user to choose layers from the retrieved list.
#'
#' @param selected_product A character string indicating the selected product.
#'
#' @return A character vector containing the selected layers.
#'
#' @noRd
get_product_layer <- function(selected_product) {
  API_URL <- 'https://appeears.earthdatacloud.nasa.gov/api/'
  product <- selected_product

  # Request layers for the 1st product in the list: product
  product_req <- httr::GET(paste0(API_URL, "product/", product))  # Request the info of a product from product URL
  product_content <- httr::content(product_req)                   # Retrieve content of the request
  product_response <- jsonlite::toJSON(product_content, auto_unbox = TRUE)  # Convert the content to JSON object
  remove(product_req, product_content)                            # Remove the variables that are not needed anymore

  layer_names <- names(jsonlite::fromJSON(product_response))      # Get the layer's names

  cat("Choose layers (enter numbers separated by spaces):\n")
  for (i in seq_along(layer_names)) {
    cat(i, ": ", layer_names[i], "\n")
  }

  selected_layer_indices <- as.integer(strsplit(readline(prompt = "Enter the numbers corresponding to the layers (enter numbers separated by spaces): "), "\\s+")[[1]])

  if (any(selected_layer_indices < 1) || any(selected_layer_indices > length(layer_names))) {
    print("Invalid selection. Please enter valid numbers.")
    return(NULL)
  }

  # Get the selected layers
  selected_layers <- layer_names[selected_layer_indices]

  # Return the selected layers
  return(selected_layers)
}

