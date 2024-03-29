#' add_id
#'
#' `add_id` adds the id inside the filename to the dataframe
#'
#' @param in_dir A string containing the directory where the raw data is from
#' @param csv_sep A string containg the seperator of the csv file, default value is ",", but can be changed to e.g. ";" , "."#'
#' @param out_dir A string containing the directory where the processed data should be stored (optional, necessary if save = TRUE)
#' @param save A logical value which defines whether the generated datasets should be stored or not
#' @param index_id A vector containing two integer. The first one marks the start index of the logger id in the filename, the second one the end
#' @return Returns the processed dataset containing logger data
#'
#' @import dplyr
#' @import magrittr
#' @import utils
#'
#'
#' @examples
#'
#' add_id("~/Documents/R-FinalExam/packagetest/reorder/", csv_sep = "," , "~/Documents/R-FinalExam/packagetest/append_df/", save = TRUE)
#' add_id("~/Documents/R-FinalExam/packagetest/reorder/", csv_sep = ",")
#'
#' @export


add_id <- function(in_dir, csv_sep = ",", out_dir = NULL, save = FALSE, index_id = c(0,6)){

  source("~/Documents/R-Projects/loggeranalysis/R/helperFunctions.R")

  check_path(in_dir)
  if (is.character(out_dir)){
    check_path(out_dir)
  }

  if(!is.logical(save)){
    stop("save needs to be either TRUE or FALSE")
  }

  if(!is.numeric(index_id) || length(index_id) != 2){
    stop("index_id needs to be a numeric vector of length 2. Each integer defines the start and end position of the Logger-ID in the filename")
  }

  files <- list.files(in_dir)
  all_logger_ds <- list()
  for (i in files){

    id.logger <- substr(i, index_id[1] , index_id[2])


    logger_ds <- read.csv(paste0(in_dir,i) , sep = csv_sep, comment.char = '#') %>%

      mutate(Logger.ID=id.logger) %>%

      select(No, Logger.ID, Date, Year, Month, Day, Time, X1.oC, HK.Bat.V)


    # Saving the Files if wanted
    if (save == TRUE){
      if (file.exists(paste0(out_dir,  "id_",i))){
        print(paste("File exists:", i))}
      else{write.csv(logger_ds, file = paste0(out_dir,  "id_",i), row.names = FALSE, sep = ",")}}

    all_logger_ds[[i]] <- logger_ds
  }

  return(all_logger_ds=all_logger_ds)

}

