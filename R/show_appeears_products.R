#' Get an overview over all products of AppEEARS
#'
#' Shows the list of all appeears products
#'
#' @return returns a dataframe with all available products, their description and temporal resolution
#'
#' @importFrom httr GET content
#'
#' @export
#'

show_appeears_products <- function(){

  #TODO check if dir exists if not write a new
  # dir.create(output_directory)

  API_URL = 'https://appeears.earthdatacloud.nasa.gov/api/'

  # Request the info of all products from product service (class: response)
  prods_req <- httr::GET(paste0(API_URL, "product"))

  # content of the request -> class: list
  prods_content <- httr::content(prods_req)


  product_df <- data.frame(ProductAndVersion = character(),
                           Description = character(),
                           Source = character(),
                           TemporalGranularity = character(),
                           stringsAsFactors = FALSE)

  # Populate the dataframe with product information
  for (p in prods_content){
    product_df <- rbind(product_df, data.frame(ProductAndVersion = p$ProductAndVersion,
                                               Description = p$Description,
                                               Source = p$Source,
                                               TemporalGranularity = p$TemporalGranularity,
                                               stringsAsFactors = FALSE))
  }


  # Return the dataframe
  return(product_df)

}
