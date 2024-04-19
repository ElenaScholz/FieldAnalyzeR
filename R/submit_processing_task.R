#' submit a processing task to AppEEARS
#'
#'  the function "submit_processing_task()" submits a data request to the AppEEARS platform.
#'
#' @param task_name MANDATORY -  Type: String - Name of the task you want to download
#' @param products_df MANDATORY -  Type: dataframe - created through the function show_appeears_products()
#' @param topic_filter MANDATORY -  Type: String - the topic of your dataanalysis (e.g. LST, NDVI, NDSI)
#' @param token MANDATORY -  Type:  - String in JSON Type - generated through the function appeears_login()
#' @param start_date MANDATORY -  Type: String - in format dd-mm-yy
#' @param end_date MANDATORY -  Type: String - in format dd-mm-yy
#' @param coordinates_dataframe MANDATORY -  Type: dataframe - must have the following structure: id, longitude, latitude, category-name. The category name defines the name for the different sites you collect data from
#'
#' @return task_id
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
#'
#'
#' @export
#'


submit_processing_task <- function(task_name, products_df, topic_filter, token, start_date, end_date, coordinates_dataframe){
  # calling functions to filter products and their layers
  filtered_products <- filter_products_by_topic(data = products_df, topic_filter = topic_filter)

  product_layers <- get_product_layer(filtered_products)


  # defining API URL and token
  API_URL = 'https://appeears.earthdatacloud.nasa.gov/api/'
  token <- paste("Bearer", jsonlite::fromJSON(token)$token)
  taskType = 'point'

  date = data.frame(startDate = start_date, endDate = end_date)
  layers = data.frame(product = filtered_products, layer = product_layers)
  names(coordinates_dataframe) <- c("id", "longitude", "latitude", "category")
  coordinates_dataframe$id <- as.character(coordinates_dataframe$id)



  task_info <- list(date,layers, coordinates_dataframe)
  names(task_info) <- c("dates", "layers", "coordinates")


  task <- list(task_info, taskName = task_name, taskType)
  names(task) <- c("params", "task_name", "task_type")


  task_json <- jsonlite::toJSON(task,auto_unbox = TRUE)


  response <- httr::POST(paste0(API_URL, "task"),
                         body = task_json ,
                         encode = "json",
                         httr::add_headers(Authorization = token, "Content-Type" = "application/json"))

  task_content <- httr::content(response)

  task_response <- jsonlite::prettify(jsonlite::toJSON(task_content, auto_unbox = TRUE))


  task_id <- jsonlite::fromJSON(task_response)$task_id
  status_req <- httr::GET(paste0(API_URL,"task/", task_id), httr::add_headers(Authorization = token))
  status_content <- httr::content(status_req)
  statusResponse <-jsonlite::toJSON(status_content, auto_unbox = TRUE)
  stat <- jsonlite::fromJSON(statusResponse)$status
  jsonlite::prettify(statusResponse)

  print("You'll receive an email if the task submission was successful and anotherone when your data is ready for download. If you cannot access the task id from this function, you can find it inside these Emails")
  print(paste("Your Task-id is:", task_id))
  return(task_id = task_id)
}
