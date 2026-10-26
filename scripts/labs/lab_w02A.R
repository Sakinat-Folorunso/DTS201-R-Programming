# DTS 201 lecture-note practical, Week 02A: Data collection and cleaning
# Run from the project root (open DTS201_R.Rproj first).

library(tidyverse)

messy <- tribble(
  ~id, ~name,     ~dept,        ~score,
  1,   " Ade ",   "computer",   "72",
  2,   "BOLA",    "Computer",   NA,
  2,   "BOLA",    "Computer",   NA,
  3,   "chidi",   "COMPUTER ",  "65",
  4,   "Dayo",    "Physics",    "58"
)

# 1. Detect problems
colSums(is.na(messy))               # missing values per column
sum(duplicated(messy))              # exact duplicate rows
count(messy, dept)                  # inconsistent category labels

# 2. Fix them
clean <- messy |>
  distinct() |>                                       # remove duplicates (base R: unique())
  mutate(name  = str_to_title(str_trim(name)),        # standardise text
         dept  = str_to_title(str_trim(dept)),
         score = as.numeric(score),                   # fix the data type
         score = replace_na(score, median(score, na.rm = TRUE)))  # impute with the median
clean

tibble(completeness = mean(!is.na(messy$score)),
       uniqueness   = n_distinct(messy$id) / nrow(messy),
       validity     = mean(as.numeric(messy$score) >= 0 & as.numeric(messy$score) <= 100, na.rm = TRUE))

