#' Rename Columns
#'
#' Renames columns of a dataframe according to the provided mapping.
#'
#' @param df The input dataframe to which the changes should be applied.
#' @param rename_map An optional list specifying the old and new column names.
#'                   The structure should be: rename_map = list(New_Colname1 = "Old_Colname1", New_Colname2 = "Old_Colname2", ...)
#'                   Default: list(Number = "No", Logger_ID = "Logger_ID", Time = "Time", Temperature_C = "X1.oC", Battery_Voltage = "HK.Bat.V").
#'
#' @return A dataframe with the new column names.
#'
#' @importFrom dplyr rename
#'
#' @export
#'

rename_columns <- function(df, rename_map = list(Number = "No",
                                                 Logger_ID = "Logger_ID",
                                                 Time = "Time",
                                                 Temperature_C = "X1.oC",
                                                 Battery_Voltage = "HK.Bat.V")) {
  renamed_df <- df

  if (!is.null(rename_map)) {
    renamed_df <- dplyr::rename(renamed_df, !!!rename_map)
  }

  return(renamed_df)
}
