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
outdir <- "~/Documents/R-FinalExam/packagetest/spatialdata/Muragl_"



loggerToSpatial <- function(input_csv, logger_coords, outdir, add_coordinatesByColumn, inputEPSG, outputcrs = "+proj=longlat +datum=WGS84", write = TRUE){


  if (!is.character(input_csv)) {
    stop("`input_csv` must be a string")
  }
  else if (!file.exists(input_csv)) {
    stop("`input_csv` does not exist: ", sQuote(input_csv))
  }
  else if(substr(input_csv, nchar(input_csv) - 3, nchar(input_csv)) != ".csv") {
    stop("`input_csv` must end with .csv")
  }


  logger_ds <- read.csv(input_csv, header = TRUE)
  logger_coords <- read.csv(logger_coords, header = TRUE, sep = ";")
  logger_addcoords <- merge(logger_ds, logger_coords, by = add_coordinatesByColumn)


  filename <- paste0(outdir, "loggerpositions",".gpkg")

  print(filename)
  logger_sf <- st_as_sf(logger_addcoords, coords = c("X", "Y", "Z"), crs = inputEPSG )


  crs <- substr(outputcrs, nchar(outputcrs) - 5, nchar(outputcrs))
  wgs_coords <- st_transform(logger_sf, crs = outputcrs)

  if (write == TRUE){
    st_write(logger_sf, filename, delete_layer = TRUE)
    st_write(wgs_coords, paste0(outdir, "loggerpositions_", crs, ".gpkg"), delete_layer = TRUE)
  }

  return(logger_sf = logger_sf, wgs_coords=wgs_coords)

}

loggerToSpatial(input_csv = input_csv, logger_coords = logger_coords, outdir = outdir, add_coordinatesByColumn = add_coordinatesByColumn, inputEPSG = inputEPSG)
