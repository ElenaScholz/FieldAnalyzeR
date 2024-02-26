#' merge_logger.ds
#'
#' `merge_logger.ds` does something.
#'
#' @param indir A string containing the directory where the raw data is from
#' @param outdir A string containing the directory where the processed data should be stored (optional, necessary if save = TRUE)
#' @param save A logical value which defines whether the generated datasets should be stored or not
#'
#' @return Returns one csv dataset containing all loggerdata
#'
#' @import dplyr
#' @import utils
#'
#' @examples
#'
#' merge_logger.ds(indir = '/home/ela/Documents/R-FinalExam/packagetest/append_df', outdir = '/home/ela/Documents/R-FinalExam/packagetest/append_df/', save = TRUE)
#' merge_logger.ds(indir = '/home/ela/Documents/R-FinalExam/packagetest/append_df', outdir = '/home/ela/Documents/R-FinalExam/packagetest/append_df/', save = FALSE)
#'
#' @export

merge_logger.ds <- function(indir, outdir, save = TRUE){

  if (!is.character(indir)){
    stop("indir should be a string containing your input directory path")
  }

  if (!is.character(outdir)){
    stop("outdir should be a string containing your input directory path")
  }

  if(!is.logical(save)){
    stop("save needs to be either TRUE or FALSE")
  }
  all_logger.ds <- list()
  files <- list.files(indir)

  print(files)
  for (i in files){
    logger_ds <- read.csv(paste0(indir,"/",i) , sep = ',', comment.char = '#')

    all_logger.ds <- c(all_logger.ds, list(logger_ds))
  }

  combined_logger.ds <- combined_dataset <- bind_rows(all_logger.ds)
  # Saving the Files if wanted
  if (save == TRUE){
    if (file.exists(paste0(outdir, 'combined_loggerByID'))){
      print(paste("File exists:", 'combined_loggerByID'))}
    else{write.csv(combined_logger.ds, file = paste0(outdir,'combined_loggerByID'), row.names = FALSE)}}
}

