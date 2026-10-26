# DTS 201 data folder

Datasets used in the course (R edition).

| File | Description | Used in |
|---|---|---|
| `student_score.csv` | Hours studied and exam score (25 students) | Weeks 1, 5 |
| `Sales_data.csv` / `.txt` / `.xlsx` | Amazon product listings in three formats (messy on purpose) | Weeks 1, 2 |
| `titanic_train.csv`, `titanic_test.csv` | Titanic passengers | Weeks 2, 3, EDA template |
| `advertising.csv` | Website users and ad clicks | Weeks 5, 7 |
| `heart.csv` | 303 patients, clinical variables (teaching data only) | Week 11 |
| `data.csv` | Breast-tissue measurements | Optional practice |
| `grocery_transactions.csv` | **Simulated** grocery baskets (Nigerian items) | Week 6 |
| `retail_sales_ng.csv` | **Simulated** retail sales in naira, 2024–2025 | Week 8 |
| `amazon_products_clean.csv`, `titanic_clean.csv` | Written by the Week 2 notebook | Weeks 3, 11 |

Simulated files are produced by `scripts/make_datasets.R` (seed 42) and are for teaching only.

## Loading data in R

Inside the RStudio project:

```r
library(tidyverse)
df <- read_csv("data/heart.csv")
```

Directly from GitHub (no download needed; replace the user and repository names):

```r
url <- "https://raw.githubusercontent.com/Sakinat-Folorunso/OOU_DTS201_R/main/data/heart.csv"
df  <- read_csv(url)

# Excel files must be downloaded first
download.file("https://raw.githubusercontent.com/Sakinat-Folorunso/OOU_DTS201_R/main/data/Sales_data.xlsx",
              "Sales_data.xlsx", mode = "wb")
sales <- readxl::read_excel("Sales_data.xlsx")
```
