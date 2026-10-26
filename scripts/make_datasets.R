# ==============================================================================
# DTS 201 - Introduction to Data Science (R edition)
# scripts/make_datasets.R
#
# Generates the two SYNTHETIC datasets used in the course:
#   data/grocery_transactions.csv  (Week 6  - market basket analysis & clustering)
#   data/retail_sales_ng.csv       (Week 8  - business intelligence dashboard)
#
# Both are simulated with set.seed(42) so every run reproduces identical files.
# They are NOT real sales records: they are designed so that known patterns
# exist in the data, which lets students check that their analysis finds them.
#
# Run from the project root:   Rscript scripts/make_datasets.R
# ==============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
  library(tibble)
  library(lubridate)
})

set.seed(42)
dir.create("data", showWarnings = FALSE)

# ------------------------------------------------------------------------------
# 1. Grocery transactions (long format: one row = one item in one basket)
# ------------------------------------------------------------------------------
# Each basket is generated from a latent "shopping mission". Items belonging to
# the mission are included with probability `p_in`; any other item is added
# with small probability `p_noise`. Students are NOT told the missions; they
# must recover them with Apriori and k-means.

missions <- list(
  breakfast  = c("Bread", "Butter", "Eggs", "Milk", "Tea"),
  jollof     = c("Rice", "Tomatoes", "Vegetable oil", "Onions", "Pepper"),
  garri_meal = c("Garri", "Groundnut", "Sugar", "Milk"),
  beans_meal = c("Beans", "Palm oil", "Plantain", "Onions", "Pepper"),
  snacks     = c("Biscuits", "Soft drink", "Indomie noodles", "Water sachet")
)
mission_prob <- c(0.28, 0.27, 0.15, 0.15, 0.15)
all_items    <- sort(unique(unlist(missions)))
p_in    <- 0.80
p_noise <- 0.03
n_baskets <- 1000

make_basket <- function(id) {
  m      <- sample(names(missions), 1, prob = mission_prob)
  in_m   <- missions[[m]][runif(length(missions[[m]])) < p_in]
  others <- setdiff(all_items, missions[[m]])
  extra  <- others[runif(length(others)) < p_noise]
  items  <- unique(c(in_m, extra))
  if (length(items) == 0) items <- sample(missions[[m]], 1)   # no empty baskets
  tibble(TransactionID = id, Item = items)
}

grocery <- bind_rows(lapply(seq_len(n_baskets), make_basket))
write_csv(grocery, "data/grocery_transactions.csv")
message("Wrote data/grocery_transactions.csv : ", nrow(grocery), " rows, ",
        n_distinct(grocery$TransactionID), " baskets, ",
        n_distinct(grocery$Item), " items")

# ------------------------------------------------------------------------------
# 2. Retail sales for six Nigerian cities (one row = one sales transaction)
# ------------------------------------------------------------------------------
n_sales   <- 6000
regions   <- c("Lagos", "Abuja", "Ibadan", "Kano", "Port Harcourt", "Enugu")
region_w  <- c(0.30, 0.20, 0.15, 0.13, 0.12, 0.10)
region_mu <- c(1.20, 1.10, 0.95, 0.90, 1.05, 0.85)   # price/demand multiplier
cats      <- c("Groceries", "Electronics", "Fashion", "Household", "Beauty")
cat_w     <- c(0.35, 0.12, 0.20, 0.20, 0.13)
cat_price <- c(Groceries = 4500, Electronics = 65000, Fashion = 12000,
               Household = 9000, Beauty = 6000)
cat_margin <- c(Groceries = 0.12, Electronics = 0.18, Fashion = 0.35,
                Household = 0.25, Beauty = 0.40)

# Seasonality index by calendar month (Dec peak, Jan/Feb dip)
season <- c(0.85, 0.85, 0.95, 1.00, 1.00, 0.95, 0.95, 1.00, 1.05, 1.10, 1.20, 1.45)

dates <- sample(seq(as.Date("2024-01-01"), as.Date("2025-12-31"), by = "day"),
                n_sales, replace = TRUE)
# thin out low-season days so the seasonal pattern shows in counts too
keep  <- runif(n_sales) < season[month(dates)] / max(season)
dates <- dates[keep]; n_sales <- length(dates)

retail <- tibble(
  Date             = sort(dates),
  Region           = sample(regions, n_sales, TRUE, prob = region_w),
  Product_Category = sample(cats,    n_sales, TRUE, prob = cat_w)
) |>
  mutate(
    Quantity     = pmax(1L, rpois(n_sales, lambda = ifelse(Product_Category == "Groceries", 4,
                                                    ifelse(Product_Category == "Electronics", 1.3, 2.2)))),
    unit_price   = cat_price[Product_Category] *
                   region_mu[match(Region, regions)] *
                   rlnorm(n_sales, meanlog = 0, sdlog = 0.25),
    Sales_Amount = round(Quantity * unit_price * season[month(Date)] ^ 0.5, 2),
    Cost         = round(Sales_Amount * (1 - cat_margin[Product_Category] *
                                           rnorm(n_sales, 1, 0.15)), 2),
    Profit       = round(Sales_Amount - Cost, 2),
    Customer_Segment = sample(c("Individual", "SME", "Corporate"), n_sales, TRUE,
                              prob = c(0.65, 0.25, 0.10))
  ) |>
  select(Date, Region, Product_Category, Customer_Segment, Quantity,
         Sales_Amount, Cost, Profit)

write_csv(retail, "data/retail_sales_ng.csv")
message("Wrote data/retail_sales_ng.csv : ", nrow(retail), " rows (amounts in Naira)")
