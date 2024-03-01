#' extract_date_time
#'
#' `extract_date_time` does something.
#'
#' @param indir A string containing the directory where the raw data is from
#' @param outdir A string containing the directory where the processed data should be stored (optional, necessary if save = TRUE)
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
#' extract_date_time("~/Documents/R-FinalExam/Muragl/", "/home/ela/Documents/R-FinalExam/reordered_data/", save = TRUE)
#' extract_date_time("~/Documents/R-FinalExam/Muragl/", "/home/ela/Documents/R-FinalExam/reordered_data/", save = FALSE)
#'
#'
#' @export

extract_date_time <- function(indir, outdir, save){

  if (!is.character(indir)){
    stop("indir should be a string containing your input directory path")
  }

  if (!is.character(outdir)){
    stop("outdir should be a string containing your input directory path")
  }

  # Error handling for invalid paths
  if (!dir.exists(indir)) {
    stop("The input directory does not exist.")
  }
  if (!dir.exists(outdir)) {
    stop("The output directory does not exist.")
  }

  if(!is.logical(save)){
    stop("save needs to be either TRUE or FALSE")
  }

  files <- list.files(indir)

  for (i in files){
    logger_ds <- read.csv(paste0(indir,i) , sep = ',', comment.char = '#') %>%

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
      if (file.exists(paste0(outdir,i))){
        print(paste("File exists:", i))}
      else{write.csv(logger_ds, file = paste0(outdir,i), row.names = FALSE , sep = ",") }}
  }

  return(logger_ds = logger_ds)
}
