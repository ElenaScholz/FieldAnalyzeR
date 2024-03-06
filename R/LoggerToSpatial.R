
#' Title
#'
#' @param in_file Type: String; The input file containing the logger data including columns for coordinates named "X", "Y", can be a csv or xlsx file
#' @param csv_sep Optional Argument, Default Value: ",", Type: String, the separator for the in_file vairable
#' @param input_EPSG a String - the epsg code for the inputdata - structure: "EPSG:21781"
#' @param output_crs optional, a string containing the output crs. Default value is: "+proj=longlat +datum=WGS84"
#' @param save Optional Argument, Default Value: FALSE, Type: Logical; Can be set to TRUE, if the added coordinates sohuld be saved inside the input file
#' @param out_dir Optional Argument, Default Value: NULL, Type: String; The variable defines the output directory of the dataset, that should be saved
#'
#' @return Returns two gpkg-files, one in the original epsg and one in WGS1984
#'
#' @import sf
#' @import utils
#' @import readxl
#' @import tools
#'
#' @examples
#' make_loggerdata_spatial(in_file = "~/Documents/R-FinalExam/packagetest/spatialdata/logger_geodata.csv", csv_sep = "," , input_EPSG = "EPSG:21781", output_crs = "+proj=longlat +datum=WGS84", save = FALSE, out_dir = NULL)
#' make_loggerdata_spatial(in_file  = "~/Documents/R-FinalExam/packagetest/spatialdata/logger_geodata.csv", csv_sep = "," , input_EPSG = "EPSG:21781", output_crs = "+proj=longlat +datum=WGS84", save = TRUE, out_dir = "~/Documents/R-FinalExam/packagetest/spatialdata/")
#'
#' @export
#'
make_loggerdata_spatial <- function(in_file, csv_sep = "," , input_EPSG, output_crs = "+proj=longlat +datum=WGS84", save = FALSE, out_dir = NULL){
  source("~/Documents/R-Projects/loggeranalysis/R/helperFunctions.R")

  check_file(in_file)
  check_save(save, out_dir)

  logger_df <- check_format(in_file, csv_sep)

  logger_as_sf <- st_as_sf(logger_df, coords = c("X", "Y"), crs = input_EPSG)
  logger_sf_wgs84 <- st_transform(logger_as_sf, crs = output_crs)

  filename1 <- paste0("Logger_geodata_orig_EPSG.gpkg")
  filename2 <- paste0("Logger_geodata_", substr(output_crs, nchar(output_crs) - 5, nchar(output_crs)), ".gpkg")

  if (save) {
    st_write(logger_as_sf, paste0(out_dir,filename1), delete_layer = TRUE)
    st_write(logger_sf_wgs84, paste0(out_dir,filename2), delete_layer = TRUE)
  }

  # return(c(logger_as_sf = logger_as_sf, logger_sf_wgs84 = logger_sf_wgs84))
}
