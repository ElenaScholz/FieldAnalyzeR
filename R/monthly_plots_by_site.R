#' create_monthly_plots_by_site
#'
#' Creates a list of plots, each plot contains an overview over the temperature for the whole time span aggregated by month
#'
#' @param data list of monthly aggregated datasets
#'
#' @return a list of plots
#' @export
#'

create_monthly_plots_by_site <- function(data) {
  plots <- list()
  for (logger_id in names(data)) {
    plot <- ggplot(data[[logger_id]], aes(Year, mean_temperature, colour = Month)) +
      geom_point(size = 0.5) +
      geom_smooth() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
            axis.title.x = element_blank(),
            legend.position = "none") +
      labs(x = "Year",
           y = "Mean Temperature") +
      facet_wrap(~Month) +
      ggtitle(paste("Muragl - Development of temperature per Month for Logger ID:", logger_id))
    plots[[logger_id]] <- plot
  }
  return(plots)
}
