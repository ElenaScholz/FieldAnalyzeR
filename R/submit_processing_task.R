#' submit a processing task to AppEEARS
#'
#'  the function "submit_processing_task()" submits a data request to the AppEEARS platform.
#'
#' @param task_name MANDATORY -  Type: String - Name of the task you want to download
#' @param products_df MANDATORY -  Type: dataframe - created through the function show_appeears_products()
#' @param filter_topic MANDATORY -  Type: String - the topic of your dataanalysis (e.g. LST, NDVI, NDSI)
#' @param token MANDATORY -  Type:  - String in JSON Type - generated through the function appeears_login()
#' @param start_date MANDATORY -  Type: String - in format dd-mm-yy
#' @param end_date MANDATORY -  Type: String - in format dd-mm-yy
#' @param coordinates MANDATORY -  Type: array/matrix - in longitude, latitude
#'
#' @return task status, task_id and the token
#'
#' @importFrom jsonlite fromJSON
#' @importFrom jsonlite toJSON
#' @importFrom jsonlite prettify
#' @importFrom httr POST
#' @importFrom httr add_headers
#' @importFrom httr content
#' @importFrom httr GET
#' @importFrom httr content
#'
#' @export
#'

submit_processing_task <- function(task_name, products_df, filter_topic, token, start_date, end_date, coordinates){
  source("~/Documents/R-Projects/loggeranalysis/R/helperFunctions.R")
  # calling functions to filter products and their layers
  filtered_products <- filter_products(df = products_df, filter_topic = filter_topic)
  product_layers <- get_product_layer_information(filtered_products)


  # defining API URL and token
  API_URL = 'https://appeears.earthdatacloud.nasa.gov/api/'
  token <- paste("Bearer", jsonlite::fromJSON(token)$token)
  taskType = 'point'

  date = data.frame(startDate = start_date, endDate = end_date)
  layers = data.frame(product = filtered_products, layer = product_layers)
  coordinates = data.frame(id = "01", longitude = coordinates[1], latitude= coordinates[2], category = task_name)


  task_info <- list(date,layers, coordinates)
  names(task_info) <- c("dates", "layers", "coordinates")

  task <- list(task_info, taskName = task_name, taskType)
  names(task) <- c("params", "task_name", "task_type")

  task_json <- jsonlite::toJSON(task,auto_unbox = TRUE)

  response <- httr::POST(paste0(API_URL, "task"),
                         body = task_json ,
                         encode = "json",
                         httr::add_headers(Authorization = token, "Content-Type" = "application/json"))

  task_content <- httr::content(response)
  #
  task_response <- jsonlite::prettify(jsonlite::toJSON(task_content, auto_unbox = TRUE))

  params <- list(limit = 2, pretty = TRUE)
  response_req <- httr::GET(paste0(API_URL,"task"), query = params, httr::add_headers(Authorization = token))
  response_content <- httr::content(response_req)
  status_response <- jsonlite::toJSON(response_content, auto_unbox = TRUE)
  jsonlite::prettify(status_response)

  task_id <- jsonlite::fromJSON(task_response)$task_id
  status_req <- httr::GET(paste0(API_URL,"task/", task_id), httr::add_headers(Authorization = token))
  status_content <- httr::content(status_req)
  statusResponse <-jsonlite::toJSON(status_content, auto_unbox = TRUE)
  stat <- jsonlite::fromJSON(statusResponse)$status
  jsonlite::prettify(statusResponse)

  # while (stat != 'done') {
  #   Sys.sleep(5)
  #   # Request the task status and retrieve content of request from task URL
  #   stat_content <- httr::content(httr::GET(paste0(API_URL,"task/", task_id), httr::add_headers(Authorization = token)))
  #   stat <-jsonlite::fromJSON(jsonlite::toJSON(stat_content, auto_unbox = TRUE))$status    # Get the status
  #   remove(stat_content)
  #   print(stat)
  # }

  return(task_id = task_id, token = token)
}
