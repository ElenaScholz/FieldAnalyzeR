#' AppEEARS login
#'
#' 'appeears_login' checks if a netrc file exists,
#' if not it sets it up and then checks the credentials and logs in to Appears
#'
#' @return returns a token that is needed for further data access
#'
#' @importFrom httr POST
#' @importFrom httr add_headers
#' @importFrom httr content
#' @importFrom jsonlite toJSON
#' @importFrom jsonlite prettify
#'
#'
#' @export
#'
appeears_login <- function() {

  source("~/Documents/R-Projects/loggeranalysis/R/helperFunctions.R")

  if (!check_netrc_file()) {
    setup_netrc_file()
  }

  # Path to the netrc file
  netrc_path <- file.path(Sys.getenv('HOME'), ".netrc")

  # Read lines from the .netrc file
  netrc_lines <- readLines(netrc_path)

  # Extract login and password
  login <- gsub('login ', '', netrc_lines[grep("^login ", netrc_lines)])
  password <- gsub('password ', '', netrc_lines[grep("^password ", netrc_lines)])

  # Encode credentials
  secret <- encode_credentials(login, password)

  # Perform the API login request
  API_URL <- 'https://appeears.earthdatacloud.nasa.gov/api/'
  response <- httr::POST(paste0(API_URL, "login"),
                         httr::add_headers("Authorization" = paste("Basic", gsub("\n", "", secret)),
                                           "Content-Type" = "application/x-www-form-urlencoded;charset=UTF-8"),
                         body = "grant_type=client_credentials")

  # Retrieve the content of the request
  response_content <- httr::content(response)

  # Convert the response to the JSON object
  token_response <- jsonlite::toJSON(response_content, auto_unbox = TRUE)

  # Remove variables that are not needed anymore
  remove(secret, response)

  # Print the prettified response
  jsonlite::prettify(token_response)

  # Return the token response
  return(token_response)
}
