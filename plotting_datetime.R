library(tidyverse)
library(reshape2)
library(cowplot)
library(magrittr)
library(stringr)

read_data <- function(file, add_ID_From_FileName = TRUE, index_id = c(0, 6)){
  read.csv(file, header = TRUE, comment.char = '#') %>%
    rename(
      Time = Time,
      Temperature_C = X1.oC,
      Battery_Voltage = HK.Bat.V
    ) %>%
    mutate(Time = as.POSIXct(Time, format = "%d.%m.%Y %H:%M:%S")) %>%
    mutate(Date = as.Date(Time)) %>% # Extracting only the date component
    mutate(Julian = yday(Time)) %>%
    mutate(Month = factor(month.name[as.integer(format(Time, "%m"))], levels = month.name)) %>%
    mutate(Year = year(Time))



}


logger1 <- read_data("/home/ela/Documents/R-FinalExam/Muragl/A5027A_20231006105136.csv")

aggregate <- function(df, aggregation_type){
  if (aggregation_type == "daily"){
    daily_temperature <- df %>%
      group_by(Date) %>%
      summarise(mean_temperature = mean(Temperature_C),
                std_temperature = sd(Temperature_C),
                min_temperature = min(Temperature_C),
                max_temperature = max(Temperature_C)) %>%
      mutate(Julian=yday(Date),
             Year = year(Date),
             Month = month(Date),
             Day = day(Date))
  }

  else if (aggregation_type == "monthly"){
    monthly_temperature <- df %>%
      group_by(Month, Year) %>%
      summarise(mean_temperature = mean(Temperature_C),
                std_temperature = sd(Temperature_C),
                min_temperature = min(Temperature_C),
                max_temperature = max(Temperature_C))
  }
}

monthly_temperature <- aggregate(logger1, aggregation_type = "monthly")
daily_temperature <- aggregate(logger1, aggregation_type = "daily")

aggregate_temperature <- function(df, start_date, end_date, name_temp_column, name_id_column, aggregation_type = "daily") {

  filtered_df <- df %>%
    filter(Date >= start_date & Date <= end_date) %>%
    mutate(Temperature = !!sym(name_temp_column)) %>%
    select(-!!sym(name_temp_column), -Time, !!sym(name_id_column))

  id <- filtered_df$Logger_ID[1]

  # Calculate aggregation based on user's choice
  if (aggregation_type == "daily") {
    # Daily aggregation
    aggregated_data <- filtered_df %>%
      group_by(Date) %>%
      summarise(mean_temperature = mean(Temperature),
                std_temperature = sd(Temperature),
                Tmin_temperature = min(Temperature),
                Tmax_temperature = max(Temperature)) %>%
      mutate(Logger_ID = id,
             Year = year(Date),
             Month = month(Date),
             Day = day(Date)
             #, JULIAN=yday(Date)
      )
  } else if (aggregation_type == "monthly") {
    # Monthly aggregation
    aggregated_data <- filtered_df %>%
      group_by(Year, Month) %>%
      summarise(mean_temperature = mean(Temperature),
                std_temperature = sd(Temperature),
                Tmin_temperature = min(Temperature),
                Tmax_temperature = max(Temperature)) %>%
      mutate(Logger_ID = id,
             Year = year(Date),
             Month = month(Date))
  } else if (aggregation_type == "seasonal") {
    # Seasonal aggregation
    aggregated_data <- filtered_df %>%
      mutate(Season = case_when(
        month(Date) %in% 3:5 ~ "Spring",
        month(Date) %in% 6:8 ~ "Summer",
        month(Date) %in% 9:11 ~ "Autumn",
        TRUE ~ "Winter"
      )) %>%
      group_by(Year, Season) %>%
      summarise(mean_temperature = mean(Temperature),
                std_temperature = sd(Temperature),
                Tmin_temperature = min(Temperature),
                Tmax_temperature = max(Temperature)) %>%
      mutate(Logger_ID = id,
             Year = year())
  } else if (aggregation_type == "annual") {
    # Annual aggregation
    aggregated_data <- filtered_df %>%
      group_by(Year) %>%
      summarise(mean_temperature = mean(Temperature),
                std_temperature = sd(Temperature),
                Tmin_temperature = min(Temperature),
                Tmax_temperature = max(Temperature)) %>%
      mutate(Logger_ID = id)
  } else {
    # Handle invalid aggregation type
    stop("Invalid aggregation_type. Please choose 'daily', 'monthly', 'seasonal', or 'annual'.")
  }

  # Return the aggregated data
  return(aggregated_data)
}


library(ggplot2)

theme_set(theme_bw())

get_colour <- function(df){

  colfunc <- colorRampPalette(c("blue", "red"))
  my_colour <- colfunc(12)

  df %>%
    group_by(Month) %>%
    summarise(month_mean_Temp = mean(Temperature_C)) %>%
    arrange(month_mean_Temp) %>%
    pull(Month) %>%
    as.integer() -> my_order

  my_colour[match(1:12, my_order)]
}

my_colour <- get_colour(logger1)


# Plot: Plots mean Temperature for each month between 2010 and 2020
a <- ggplot(monthly_temperature, aes(Year, max_temperature, colour = Month)) +
  geom_point(size = 0.5) +
  geom_smooth(method = "loess") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
        axis.title.x = element_blank(),
        legend.position = "none") +
  scale_color_manual(values = my_colour) +
  labs(title = "Monthly mean maximum temperature", subtitle = "Muragl Logger data", y = "Degrees Celsius") +
  facet_wrap(~Month) +
  NULL


b <- ggplot(monthly_temperature, aes(Year, min_temperature, colour = Month)) +
  geom_point(size = 0.5) +
  geom_smooth(method = "loess") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
        axis.title.x = element_blank(),
        legend.position = "none") +
  scale_color_manual(values = my_colour) +
  labs(title = "Monthly mean minimum temperature", subtitle = "Muragl Logger data", y = "Degrees Celsius") +
  facet_wrap(~Month) +
  NULL

plot_grid(a, b)

c <- monthly_temperature %>%
  filter(Year != 2010) %>%
  group_by(Year) %>%
  summarise(year_mean = mean(min_temperature)) %>%
  ggplot(., aes(Year, year_mean)) +
  geom_point() +
  geom_line() +
  geom_smooth(method = "loess") +
  theme(axis.title.x = element_blank(),
        legend.position = "none") +
  labs(title = "Annual mean minimum temperature", subtitle = "Murgal Logger data", y = "Degrees Celsius") +
  NULL
c


# bar plot for monthly mean temperature
d <- monthly_temperature %>%
  ggplot(aes(x = Month, y = mean_temperature), color = Month)+
  geom_bar(stat = "identity")+
  facet_wrap(~Year, ncol = 3)+
  NULL

d


