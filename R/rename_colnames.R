#' rename_columns
#'
#' @param df MANDADORY - the input dataframe you want to apply the changes to
#' @param rename_map OPTIONAL - a list containing all old and new column names. The structure is: rename_map = list(New_Colname1 = "Old_Colname1, New_Colname2 = "Old_Colname2", ...)
#' default: list(Number = "No", Logger_ID = "Logger_ID", Time = "Time", Temperature_C = "X1.oC", Battery_Voltage = "HK.Bat.V")
#
#' @return returns a dataframe with the new column names
#'
#' @import dplyr
#'
#' @examples
#'
#' rename_columns(df = read.csv("/home/ela/Documents/R-FinalExam/examples/01_logger.csv"))
#'
#' @export
#'

rename_columns <- function(df,rename_map = list(Number = "No",
                                                Logger_ID = "Logger_ID",
                                                Time = "Time",
                                                Temperature_C = "X1.oC",
                                                Battery_Voltage = "HK.Bat.V")){
  renamed_df <- df

  if (!is.null(rename_map)) {
    renamed_df <- dplyr::rename(renamed_df, !!!rename_map)
  }
}


