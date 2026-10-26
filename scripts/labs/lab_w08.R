# DTS 201 lecture-note practical, Week 08: BI and knowledge management
# Run from the project root (open DTS201_R.Rproj first).

library(tidyverse)
sales <- read_csv("data/retail_sales_ng.csv")

# 1. KPIs
kpis <- sales |>
  summarise(Revenue = sum(Sales_Amount), Profit = sum(Profit),
            Margin_pct = 100 * sum(Profit) / sum(Sales_Amount),
            Avg_order = mean(Sales_Amount), Orders = n())
kpis

# 2. Revenue and profit by region
by_region <- sales |> group_by(Region) |>
  summarise(Revenue = sum(Sales_Amount), Profit = sum(Profit)) |>
  arrange(desc(Revenue))
ggplot(by_region, aes(reorder(Region, Revenue), Revenue)) +
  geom_col(fill = "steelblue") + coord_flip() +
  scale_y_continuous(labels = scales::label_comma()) +
  labs(title = "Revenue by region", x = NULL, y = "Revenue (naira)")

# 3. Monthly trend (seasonality)
monthly <- sales |> mutate(Month = lubridate::floor_date(Date, "month")) |>
  group_by(Month) |> summarise(Revenue = sum(Sales_Amount))
ggplot(monthly, aes(Month, Revenue)) + geom_line() + geom_point() +
  scale_y_continuous(labels = scales::label_comma()) +
  labs(title = "Monthly revenue", x = NULL, y = "Revenue (naira)")

# 4. Export for Excel or Power BI
dir.create("outputs", showWarnings = FALSE)
write_csv(by_region, "outputs/revenue_by_region.csv")

