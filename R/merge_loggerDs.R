#' merge_logger_ds
#'
#' `merge_logger_ds` does something.
#'
#' @param in_dir A string containing the directory where the raw data is from
#' @param csv_sep A string containg the seperator of the csv file, default value is ",", but can be changed to e.g. ";" , "."
#' @param out_dir A string containing the directory where the processed data should be stored (optional, necessary if save = TRUE)
#' @param save A logical value which defines whether the generated datasets should be stored or not

#'
#' @return Returns one csv dataset containing all loggerdata
#'
#' @import dplyr
#' @import utils
#'
#' @examples
#'
#' merge_logger_ds(in_dir = '~/Documents/R-FinalExam/packagetest/append_df/', out_dir = '~/Documents/R-FinalExam/packagetest/append_df/', save = TRUE)
#' merge_logger_ds(in_dir = '~/Documents/R-FinalExam/packagetest/append_df/')
#'
#' @export


merge_logger_ds <- function(in_dir, csv_sep = "," , out_dir = NULL, save = FALSE){
  source("~/Documents/R-Projects/loggeranalysis/R/helperFunctions.R")

  check_path(in_dir)

  if (is.character(out_dir)){
    check_path(out_dir)
  }

  if(!is.logical(save)){
    stop("save needs to be either TRUE or FALSE")
  }
  all_logger.ds <- list()
  files <- list.files(in_dir)


  for (i in files){
    logger_ds <- read.csv(paste0(in_dir,i) , sep = csv_sep , comment.char = '#')

    all_logger.ds <- c(all_logger.ds, list(logger_ds))
  }

  combined_logger.ds <- combined_dataset <- bind_rows(all_logger.ds)
  # Saving the Files if wanted
  if (save == TRUE){
    if (file.exists(paste0(out_dir, 'combined_loggerByID'))){
      print(paste("File exists:", 'combined_loggerByID'))}
    else{write.csv(combined_logger.ds, file = paste0(out_dir,'combined_loggerByID.csv'), row.names = FALSE, sep = ",")}}
}

