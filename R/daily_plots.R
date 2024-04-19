#' create_daily_plot
#'
#' Creates a plot showing the development of temperature over time for a single logger.
#'
#' @param data A dataframe containing daily temperature data with columns "Julian", "mean_temperature", and "Logger_ID".
#' @param title The title of the plot
#' @return A ggplot object displaying the temperature development over time.
#'
#'
#' @import ggplot2
#'
#' @export
#'

create_daily_plot <- function(data, title) {
  plot <- ggplot2::ggplot(data, aes(x = Julian, y = mean_temperature)) +
    ggplot2::geom_line(color = '#6bd2db', linewidth = 1) +
    ggplot2::geom_smooth() +
    ggplot2::theme_bw() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, size = 10),
                   axis.title.x = ggplot2::element_blank(),
                   axis.title.y = ggplot2::element_blank()) +
    ggplot2::ggtitle(title) +
    ggplot2::facet_wrap(~Year) +
    ggplot2::labs(subtitle = paste("Logger ID:", unique(data$Logger_ID)))
  return(plot)
}
