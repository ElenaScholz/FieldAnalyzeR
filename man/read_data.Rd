% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_data.R
\name{read_data}
\alias{read_data}
\title{read_data
Reads in files used for the analysis of logger data. Possible file types are Excel, CSV, or a data frame.}
\usage{
read_data(
  input_directory,
  file_pattern = NULL,
  skip_lines = 0,
  csv_sep = ",",
  csv_comment_character = "#",
  add_ID_from_filename = TRUE,
  index_id = c(0, 6)
)
}
\arguments{
\item{input_directory}{MANDATORY, Type: String - The input directory where the file(s) are stored.}

\item{file_pattern}{the pattern if not all datasets of the input directory should be used (e.g."_daily\\.csv$")}

\item{skip_lines}{OPTIONAL, Type: Integer - Number of lines to skip before the actual data. Default is 0.}

\item{csv_sep}{OPTIONAL, Type: String - The separator used in the CSV file. Default is ",".}

\item{csv_comment_character}{OPTIONAL, Type: String - Character for commenting lines in CSV. Default is '#'.}

\item{add_ID_from_filename}{OPTIONAL, Type: TRUE/FALSE - Whether to add an ID from the filename to the data. Default is TRUE.}

\item{index_id}{OPTIONAL, Type: vector - Vector specifying the start and end positions of the ID in the filename. Default is c(0, 6).}
}
\value{
A single data frame or a list of data frames containing the raw data.
}
\description{
read_data
Reads in files used for the analysis of logger data. Possible file types are Excel, CSV, or a data frame.
}
