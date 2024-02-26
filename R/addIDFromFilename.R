#' add.id
#'
#' `add.id` adds the id inside the filename to the dataframe
#'
#' @param indir A string containing the directory where the raw data is from
#' @param outdir A string containing the directory where the processed data should be stored (optional, necessary if save = TRUE)
#' @param save A logical value which defines whether the generated datasets should be stored or not
#' @param index.id A vector containing two integer. The first one marks the start index of the logger id in the filename, the second one the end
#' @return Returns the processed dataset containing logger data
#'
#' @import dplyr
#' @import magrittr
#' @import utils
#' @examples
#'
#' add.id("/home/ela/Documents/R-FinalExam/packagetest/reorder", "/home/ela/Documents/R-FinalExam/packagetest/append_df/", save = TRUE, index.id = c(0,6))
#' add.id("/home/ela/Documents/R-FinalExam/packagetest/reorder", "/home/ela/Documents/R-FinalExam/packagetest/append_df/", save = FALSE, index.id = c(0,6))
#' @export

add.id <- function(indir, outdir, save = TRUE, index.id = c(0,6)){

  if (!is.character(indir)){
    stop("indir should be a string containing your input directory path")
  }

  if (!is.character(outdir)){
    stop("outdir should be a string containing your input directory path")
  }

  if(!is.logical(save)){
    stop("save needs to be either TRUE or FALSE")
  }

  if(!is.numeric(index.id) || length(index.id) != 2){
    stop("index.id needs to be a numeric vector of length 2. Each integer defines the start and end position of the Logger-ID in the filename")
  }

  files <- list.files(indir)

  for (i in files){

    id.logger <- substr(i, index.id[1] , index.id[2])


    logger_ds <- read.csv(paste0(indir,"/",i) , sep = ',', comment.char = '#') %>%

      mutate(Logger.ID=id.logger) %>%

      select(No, Logger.ID, Date, Year, Month, Day, Time, X1.oC, HK.Bat.V)


    # Saving the Files if wanted
    if (save == TRUE){
      if (file.exists(paste0(outdir,  "id_",i))){
        print(paste("File exists:", i))}
      else{write.csv(logger_ds, file = paste0(outdir,  "id_",i), row.names = FALSE)}}


  }

  return(logger_ds = logger_ds)


}

