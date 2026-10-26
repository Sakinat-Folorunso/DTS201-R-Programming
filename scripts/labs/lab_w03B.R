# DTS 201 lecture-note practical, Week 03B: Data visualisation
# Run from the project root (open DTS201_R.Rproj first).

library(tidyverse)
ads <- read_csv("data/advertising.csv") |> rename(Time = `Daily Time Spent on Site`)

# Base R (one line)
plot(ads$Age, ads$Time, xlab = "Age", ylab = "Minutes on site", main = "Time on site vs age")

# ggplot2: scatter plot with a trend line
p <- ggplot(ads, aes(Age, Time)) +
  geom_point(alpha = 0.5, colour = "steelblue") +
  geom_smooth(method = "lm", colour = "firebrick") +
  labs(title = "Time on site vs age", x = "Age (years)", y = "Minutes on site") +
  theme_minimal(base_size = 12)
p

# Line chart, bar chart and histogram follow the same pattern
ads |> count(Age) |> ggplot(aes(Age, n)) + geom_line()
ads |> count(`Clicked on Ad`) |> ggplot(aes(factor(`Clicked on Ad`), n)) + geom_col()
ggplot(ads, aes(Time)) + geom_histogram(bins = 20)

# Several groups: map colour to a variable and let ggplot2 add the legend
ggplot(ads, aes(Age, Time, colour = factor(`Clicked on Ad`))) +
  geom_point() + labs(colour = "Clicked on ad")

# Figure size and saving
ggsave("outputs/time_vs_age.png", p, width = 8, height = 5, dpi = 150)

