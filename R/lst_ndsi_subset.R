#' Subsetting of Combined Land Surface Temperature and Snow Coverage Dataset
#'
#' This dataset contains a subset of observations from the combined land surface temperature
#' (LST) and snow coverage measurements. It includes selected variables related to date,
#' Julian day, month, year, data logger ID, calculated temperature in Celsius, and snow coverage in percent.
#'
#' @format
#' A data frame with 2261 observations and 7 variables:
#' \describe{
#'   \item{Date}{Date of the observation.}
#'   \item{Julian}{Julian day of the observation.}
#'   \item{Month}{Month of the observation (as a factor).}
#'   \item{Year}{Year of the observation.}
#'   \item{Logger_ID}{Identifier for the data logger.}
#'   \item{LST_C}{Calculated land surface temperature in Celsius.}
#'   \item{SnowCover}{Percentage of snow coverage. NA indicates missing or unavailable data.}
#' }
#'
#' @source
#' This dataset is a subset of the combined land surface temperature and snow coverage dataset,
#' both downloaded from https://appeears.earthdatacloud.nasa.gov/
#'
#' For the Following products, Layer, Sites:
#' LST_Day_1km (MOD11A1.061)
#' LST_Night_1km (MOD11A1.061)
#' NDSI_Snow_Cover (MOD10A1.061)
#' Spatial details: 1, testdata, 46.5493, 9.8174
#'
#' @examples
#' data(lst_ndsi_subset)
#'
#'
"lst_ndsi_subset"
