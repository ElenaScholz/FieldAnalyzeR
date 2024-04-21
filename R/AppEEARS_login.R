#' AppEEARS Login
#'
#' `appeears_login` checks if a .netrc file exists and contains login credentials. If not, it sets up the .netrc file with the necessary credentials
#' and then logs in to the AppEEARS service.
#'
#' @return A token that is required for further data access.
#'
#' @importFrom httr POST add_headers content
#' @importFrom jsonlite toJSON prettify
#'
#' @export
#'
appeears_login <- function() {
  # Check if .netrc file exists and set it up if not
  if (!check_netrc_file()) {
    setup_netrc_file()
  }

  # Path to the .netrc file
  netrc_path <- file.path(Sys.getenv('HOME'), ".netrc")

  # Read lines from the .netrc file
  netrc_lines <- readLines(netrc_path)

  # Extract login and password from .netrc file
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

  # Convert the response to JSON
  token_response <- jsonlite::toJSON(response_content, auto_unbox = TRUE)

  # Remove sensitive data
  remove(secret, response)

  # Prettify the JSON response
  jsonlite::prettify(token_response)

  # Return the token response
  return(token_response)
}
