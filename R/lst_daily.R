#' A preprocessed Land Surface Temperature Dataset
#'
#'
#' @format
#' A data frame with 2270 observations and 7 variables:
#' \describe{
#'   \item{Logger_ID}{Identifier for the data logger.}
#'   \item{Date}{Date of the temperature measurement.}
#'   \item{Temperature_Day}{Temperature measured during the day (in Kelvin).}
#'   \item{Quality_day}{Quality indicator for daytime temperature measurement.}
#'   \item{Temperature_Night}{Temperature measured during the night (in Kelvin).}
#'   \item{Quality_night}{Quality indicator for nighttime temperature measurement.}
#'   \item{Temperature_C}{Calculated temperature in Celsius from day and night temperatures.}
#' }
#'
#' @source
#' https://appeears.earthdatacloud.nasa.gov/
#'
#'  The original dataset was downloaded with AppEEARS containing the following layers:
#'  LST_Day_1km (MOD11A1.061)
#'  LST_Night_1km (MOD11A1.061)
#'
#'  Spatial details: 1, testdata, 46.5493, 9.8174
#'
#'
#' Note: Temperature values are provided in Kelvin. Temperature_C represents
#' temperature values converted to Celsius.
#'
#' @examples
#' data(lst_daily)

"lst_daily"
