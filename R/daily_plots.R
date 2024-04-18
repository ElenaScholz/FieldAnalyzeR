#' create_daily_plots
#'
#' @param data uses a list of daily temperature data to create plots by site
#'
#' @return a list of plots
#' @export
#'

create_daily_plots <- function(data) {
  plots <- list()
  for (logger_id in names(data)) {
    plot <- ggplot2::ggplot(data[[logger_id]], aes(x = Julian, y = mean_temperature)) +
      ggplot2::geom_line(color = '#6bd2db', linewidth = 1) +
      ggplot2::geom_smooth() +
      ggplot2::theme_bw() +
      ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, size = 10),
                     axis.title.x = ggplot2::element_blank(),
                     axis.title.y = ggplot2::element_blank()) +
      ggplot2::facet_wrap(~Year) +
      ggplot2::ggtitle(paste("Development of temperature over Year for Logger ID:", logger_id))
    plots[[logger_id]] <- plot
  }
  return(plots)
}
