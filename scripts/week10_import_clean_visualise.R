# ==============================================================================
# DTS 201 - Introduction to Data Science (R edition)
# Week 10 script: import  ->  clean  ->  summarise  ->  visualise
#
# HOW TO RUN
#   1. In RStudio: File > Open File... and choose this script.
#   2. Click the "Source" button (top right of the editor), or press Ctrl/Cmd + Shift + S.
#   3. Read the messages in the Console and look at the Plots pane.
#
# A script is a plain-text file of R commands that runs from top to bottom.
# Unlike a notebook, it has no text or chunks: only code and comments (# ...).
# ==============================================================================

# ---- 0. Setup ----------------------------------------------------------------
suppressPackageStartupMessages(library(tidyverse))
set.seed(42)

# Find the data and outputs folders whether the script is run from the project
# root (RStudio Project) or from the notebooks/ folder (knitting).
data_dir <- if (dir.exists("data")) "data" else "../data"
out_dir  <- file.path(dirname(normalizePath(data_dir)), "outputs")
dir.create(out_dir, showWarnings = FALSE)

# ---- 1. Import ---------------------------------------------------------------
raw <- read_csv(file.path(data_dir, "titanic_train.csv"), show_col_types = FALSE)
message("Imported ", nrow(raw), " rows and ", ncol(raw), " columns.")

# ---- 2. Clean ----------------------------------------------------------------
clean <- raw |>
  mutate(
    Age_missing = is.na(Age),                                   # remember which ages were missing
    Age         = replace_na(Age, median(Age, na.rm = TRUE)),   # fill with the median age
    Survived    = factor(Survived, levels = c(0, 1), labels = c("No", "Yes")),
    Pclass      = factor(Pclass, levels = 1:3, labels = c("1st", "2nd", "3rd")),
    Sex         = factor(Sex)
  ) |>
  select(PassengerId, Survived, Pclass, Sex, Age, Fare, Age_missing)

stopifnot(!anyNA(clean$Age), nrow(clean) == nrow(raw))          # validation checks
message("Cleaning done: ", sum(clean$Age_missing), " missing ages were filled.")

# ---- 3. Summarise ------------------------------------------------------------
survival_table <- clean |>
  group_by(Pclass, Sex) |>
  summarise(passengers = n(),
            survival_rate = mean(Survived == "Yes"),
            .groups = "drop")
print(survival_table)

# ---- 4. Visualise ------------------------------------------------------------
p <- ggplot(survival_table, aes(x = Pclass, y = survival_rate, fill = Sex)) +
  geom_col(position = "dodge") +
  scale_y_continuous(labels = scales::percent, limits = c(0, 1)) +
  labs(title = "Titanic survival rate by class and sex",
       x = "Passenger class", y = "Survival rate", fill = NULL) +
  theme_minimal(base_size = 12)
print(p)

# ---- 5. Save the figure ------------------------------------------------------
fig_path <- file.path(out_dir, "week10_survival_by_class_sex.png")
ggsave(fig_path, p, width = 7, height = 4.2, dpi = 150)
message("Figure saved to: ", fig_path)
