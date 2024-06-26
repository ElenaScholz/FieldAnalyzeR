% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AppEEARS_login.R
\name{appeears_login}
\alias{appeears_login}
\title{AppEEARS Login}
\usage{
appeears_login()
}
\value{
A token that is required for further data access.
}
\description{
\code{appeears_login} checks if a .netrc file exists and contains login credentials. If not, it sets up the .netrc file with the necessary credentials
and then logs in to the AppEEARS service.
}
