#' add_coordinates
#'
#' `add_coordinates` does smth.
#'
#' @param in_file Type: String; The input file containing the logger data, can be a csv or xlsx file
#' @param logger_coordinates_file Type: String; This file has the coordinates for each logger, can be a csv or xlsx file
#' @param add_coordinates_By_Column Type: String; The column name of input file and the coordinate dataset on which the two datasets should be merged (Needs to be the same!)
#' @param csv_sep Optional Argument, Default Value: ",", Type: String; If one of the datasets is a csv file the seperator needs to be defined, at this moment the seperator needs to be the same in both datasets
#' @param save Optional Argument, Default Value: FALSE, Type: Logical; Can be set to TRUE, if the added coordinates sohuld be saved inside the input file
#' @param out_dir Optional Argument, Default Value: NULL, Type: String; The variable defines the output directory of the dataset, that should be saved
#'
#' @return Returns a dataframe (logger_df) that has new columns for x,y (,z) added
#'
#' @import utils
#' @import readxl
#' @import tools
#'
#'
#'
#'
#' @examples
#' add_coordinates(in_file = "~/Documents/R-FinalExam/packagetest/append_df/combined_loggerByID.csv", logger_coordinates_file = "~/Documents/R-FinalExam/Loggerpositionen_Muragl.csv" ,add_coordinates_By_Column ="Logger.ID")
#' add_coordinates(in_file = "~/Documents/R-FinalExam/packagetest/append_df/combined_loggerByID.csv", logger_coordinates_file = "~/Documents/R-FinalExam/Loggerpositionen_Muragl.csv" , add_coordinates_By_Column = "Logger.ID", csv_sep = "," , save = TRUE, out_dir = "~/Documents/R-FinalExam/packagetest/spatialdata/")
#'
#' @export


add_coordinates <- function(in_file, logger_coordinates_file , add_coordinates_By_Column, csv_sep = ",", save = FALSE, out_dir = NULL){

  source("~/Documents/R-Projects/loggeranalysis/R/helperFunctions.R")

  check_file(in_file)
  check_file(logger_coordinates_file)

  check_save(save, out_dir)

  # checking input file format and read input file for logger data and the input coordinates as a dataframe
  logger_df <- check_format(in_file)
  coordinates <- check_format(logger_coordinates_file)


  # merges coordinates for each logger-dataset to the logger_df dataframe and saves it, if save = TRUE
  logger_df <- merge(logger_df, coordinates, by = add_coordinates_By_Column)

  if (save){
    if (file.exists(paste0(out_dir, "logger_geodata.csv"))){
      print(paste("Csv_File exists"))}
    else{utils::write.csv(logger_df, file = paste0(out_dir,"logger_geodata.csv"), row.names = FALSE , sep = ",") }}




  return(logger_df = logger_df)

}

