#' My function
#'
#' `myfunction` does something.
#'
#' @param arg1 A value to return
#' @return Returns the value of \code{arg1}
#' @examples
#'
#' myfunction(1) # returns 1
#'
#'

check_path <- function(dir){
  if (!is.character(dir)){
    stop("indir should be a string containing your input directory path")
  }
  if (!dir.exists(dir)) {
    stop("The input directory does not exist.")
    }
}

check_format

check_logical

