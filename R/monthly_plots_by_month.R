#' create_monthly_plots_by_month
#'
#' Creates a List of Plots for each month of a year where the monthly temperature developements for all plots are shown
#'
#' @param data a list of dataframes containing daily aggregated datasets
#'
#' @return A list of plots
#' @export
#'

create_monthly_plots_by_month <- function(data) {
  monthly_temperature <- bind_rows(data)
  monthly_datasets <- list()

  # Loop through each month and filter the data
  for (month in unique(monthly_temperature$Month)) {
    # Filter data for the current month
    monthly_data <- filter(monthly_temperature, Month == month)
    # Store the filtered data in the list
    monthly_datasets[[as.character(month)]] <- monthly_data
  }

  plots <- list()

  # Loop through each month
  for (month_name in names(monthly_datasets)) {
    # Get the dataset for the current month
    month_data <- monthly_datasets[[month_name]]

    # Create the plot for the current month
    plot <- ggplot(month_data, aes(Year, mean_temperature, colour = Logger_ID)) +
      geom_point(size = 0.5) +
      geom_smooth() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
            axis.title.x = element_blank(),
            legend.position = "none") +
      labs(x = "Year",
           y = "Mean Temperature") +
      facet_wrap(~Logger_ID) +
      ggtitle(paste("Muragl - Temperature of", month_name, "for each Site"))

    # Store the plot in the list
    plots[[month_name]] <- plot
  }
  return(plots)
}
