#' extract_date_time
#'
#' `extract_date_time` does something.
#'
#' @param in_dir A string containing the directory where the raw data is from
#' @param csv_sep A string containg the seperator of the csv file, default value is ",", but can be changed to e.g. ";" , "."
#' @param out_dir A string containing the directory where the processed data should be stored (optional, necessary if save = TRUE)
#' @param save A logical value which defines whether the generated datasets should be stored or not

#' @return Returns the processed dataset containing logger data
#'
#' @import lubridate
#' @import dplyr
#' @import stringr
#' @import magrittr
#' @import utils
#'
#'
#' @examples
#' extract_date_time("~/Documents/R-FinalExam/Muragl/", "~/Documents/R-FinalExam/packagetest/reorder/", save = TRUE, csv_sep = ",")
#' extract_date_time("~/Documents/R-FinalExam/Muragl/", csv_sep = ",")
#'
#'
#' @export






extract_date_time <- function(in_dir, csv_sep = ",", out_dir = NULL, save = FALSE){
  source("~/Documents/R-Projects/loggeranalysis/R/helperFunctions.R")
  check_path(in_dir)
  if (is.character(out_dir)){
    check_path(out_dir)
  }

  if(!is.logical(save)){
    stop("save needs to be either TRUE or FALSE")
  }

  files <- list.files(in_dir)

  for (i in files){
    logger_ds <- read.csv(paste0(in_dir,i) , sep = csv_sep, comment.char = '#') %>%

      mutate(date_time = str_split_fixed(.$Time, " ", 2)) %>%

      mutate(Date=as.Date(date_time[,1], format = "%d.%m.%Y"),
             Time = format(as.POSIXct(date_time[, 2], format = "%H:%M:%S"), format = "%H:%M:%S")) %>%

      select(-date_time) %>%

      mutate(Year=year(Date),
             Month=month(Date),
             Day=day(Date)) %>%

      select(No, Date, Year, Month, Day, Time, X1.oC, HK.Bat.V)

    # Saving the Files if wanted ->
    if (save == TRUE){
      if (file.exists(paste0(out_dir,i))){
        print(paste("File exists:", i))}
      else{write.csv(logger_ds, file = paste0(out_dir,i), row.names = FALSE , sep = ",") }}
  }

  #return(logger_ds = logger_ds)
}
