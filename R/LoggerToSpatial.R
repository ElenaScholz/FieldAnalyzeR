#' My function
#'
#' `myfunction` does something.
#'
#' @param arg1 A value to return
#'
#'
#' @return Returns the value of \code{arg1}
#'
#' @import package
#'
#' @examples
#'
#' myfunction(1) # returns 1
#'
#' @export
#
# myfunction <- function(arg1 = "Change me") {
#   arg1
# }




library(utils)
library(dplyr)
library(readxl)
library(sf)
library(ggplot2)
library(rlang)

input_csv <- "~/Documents/R-FinalExam/packagetest/append_df/combined_loggerByID.csv"
logger_coords <- "~/Documents/R-FinalExam/Loggerpositionen_Muragl.csv"
add_coordinatesByColumn <- "Logger.ID"
inputEPSG <- "EPSG:21781"
outdir <- "/home/ela/Documents/R-FinalExam/packagetest/spatialdata/"



loggerToSpatial <- function(in_file, csv_sep = ",", logger_coordinates , out_dir = NULL, add_coordinates_By_Column, input_EPSG, output_crs = "+proj=longlat +datum=WGS84", save = FALSE){
  source("~/Documents/R-Projects/loggeranalysis/R/helperFunctions.R")

  check_file(in_file)
  check_file(logger_coordinates)

  check_save(save, out_dir)

# checking input file format and read input file for logger data and the input coordinates as a dataframe
  logger_df <- check_format(in_file)
  coordinates <- check_format(logger_coordinates)

# merges coordinates for each logger-dataset to the logger_df dataframe and saves it, if save = TRUE
  logger_df <- merge(logger_df, coordinates, by = add_coordinatesByColumn)

  # if (save){
  #   if (file.exists(paste0(out_dir, "logger_geodata.csv"))){
  #     print(paste("Csv_File exists"))}
  #   else{write.csv(logger_df, file = paste0(out_dir,"logger_geodata.csv"), row.names = FALSE , sep = ",") }}

# create gpkg files for the original and the given output coordinate system
  logger_as_sf <- st_as_sf(logger_df, coords = c("X", "Y", "Z"), crs = input_EPSG)
  logger_sf_wgs84 <- st_transform(logger_as_sf, crs = output_crs)

  filename1 <- paste0("Logger_geodata_", input_EPSG,".gpkg")
  filename2 <- paste0("Logger_geodata_", substr(outputcrs, nchar(outputcrs) - 5, nchar(outputcrs)), ".gpkg")

  if (save){
      st_write(logger_as_sf, paste0(out_dir,filename1), delete_layer = TRUE)
      st_write(wgs_coords, paste0(outdir, filename2), delete_layer = TRUE)
  }


  return(logger_as_sf = logger_as_sf, logger_sf_wgs84 = logger_sf_wgs84, logger_df = logger_df)

}

loggerToSpatial(in_file = input_csv, logger_coordinates = logger_coords , out_dir = outdir, add_coordinates_By_Column = 'Logger.ID', input_EPSG, output_crs = "+proj=longlat +datum=WGS84", save = TRUE)
