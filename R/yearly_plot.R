#' create_yearly_overview_plot
#'
#' creates a plot to get an overview over the whole time span (?)
#'
#' @param daily_data Type: list of dataframes or a dataframe - the input dataset - aggregated on a daily basis can be a list of dataframes or one big dataframe
#' @param x_var variable for the x-axis
#' @param y_var variable for the y-axis
#' @param group_var the grouping variable for facet_wrap()
#' @param title The title of the plot
#'
#' @importFrom dplyr bin_rows
#' @importFrom ggplot2
#'
#'
#' @return a single plot containing the timeseries for all sites
#' @export
#'
#'
create_yearly_overview_plot <- function(daily_data, x_var, y_var, group_var, title) {
  # Check if daily_data is a list of data frames or a single data frame
  if (!is.data.frame(daily_data)) {
    # If daily_data is a list, combine data frames into a single data frame
    daily_temperature <- dplyr::bind_rows(daily_data)
  } else {
    # If daily_data is already a single data frame, use it directly
    daily_temperature <- daily_data
  }

  ggplot2::ggplot(daily_temperature, aes_string(x = x_var, y = y_var)) +
    ggplot2::geom_line(color = '#6bd2db', linewidth = 1) +
    ggplot2::geom_smooth() +
    ggplot2::theme(panel.grid.major = ggplot2::element_line(color = "#0c457d",
                                                            linewidth = 0.5,
                                                            linetype = 2)) +
    ggplot2::theme(panel.grid.minor.x = ggplot2::element_line(color = "#6d8fb1",
                                                              linewidth = 0.25,
                                                              linetype = 1)) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, size = 10),
                   axis.title.x = ggplot2::element_blank(),
                   axis.title.y = ggplot2::element_blank()) +
    ggplot2::labs(x = "Year",
                  y = "Mean Temperature") +
    ggplot2::facet_wrap(~ {{ group_var }}) +
    ggplot2::ggtitle(title)
}

