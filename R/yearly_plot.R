#' create_yearly_overview_plot
#'
#' creates a plot to get an overview over the whole time span (?)
#'
#' @param daily_data Type: list of dataframes or a dataframe - the input dataset - aggregated on a daily basis can be a list of dataframes or one big dataframe
#' @param title The title of the plot
#'
#' @importFrom dplyr bind_rows
#' @import ggplot2
#'
#'
#' @return a single plot containing the timeseries for all sites
#' @export
#'
#'


create_yearly_overview_plot <- function(daily_data, title){

  # Check if daily_data is a list of data frames or a single data frame
  if (!is.data.frame(daily_data)) {
    # If daily_data is a list, combine data frames into a single data frame
    daily_temperature <- dplyr::bind_rows(daily_data)
  } else {
    # If daily_data is already a single data frame, use it directly
    daily_temperature <- daily_data
  }

  # colnames(daily_data)[colnames(daily_data) == temperature_column] <- "Temperature_C"

  yearly_overview <- ggplot2::ggplot(daily_temperature, aes(x = Date, y = mean_temperature))+
    ggplot2::geom_line(color = '#6bd2db', linewidth = 1)+
    ggplot2::geom_smooth()+
    # theme(panel.grid = element_line(color = "#8ccde3", size = 0.5, linetype = 2))+
    ggplot2::theme(panel.grid.major = ggplot2::element_line(color = "#0c457d",
                                          linewidth = 0.5,
                                          linetype = 2))+
    ggplot2::theme(panel.grid.minor.x = element_line(color = "#6d8fb1",
                                            linewidth = 0.25,
                                            linetype = 1))+
    ggplot2::theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
          axis.title.x = element_blank(),
          axis.title.y = element_blank())+
    ggplot2::labs(x = "Year",
         y = "Mean Temperature")+
    ggplot2::facet_wrap(~Logger_ID)+
    ggplot2::ggtitle(title)

  return(yearly_overview)
}



