# ==============================================================================
# DTS 201 - Introduction to Data Science (R edition)
# scripts/check_setup.R
#
# Checks that your computer is ready for the course. Run from the project root:
#     source("scripts/check_setup.R")
# Copy the whole printed report into your Week 0 answer sheet.
# ==============================================================================

ok   <- function(msg) cat("  [PASS]", msg, "\n")
fail <- function(msg) cat("  [FAIL]", msg, "\n")
chk  <- function(cond, pass_msg, fail_msg) if (isTRUE(cond)) ok(pass_msg) else fail(fail_msg)

cat("\n=== DTS 201 setup check ===\n")
cat("Date    :", format(Sys.time(), "%Y-%m-%d %H:%M"), "\n")
cat("System  :", Sys.info()[["sysname"]], Sys.info()[["release"]], "\n")
cat("R       :", R.version.string, "\n")
cat("Folder  :", getwd(), "\n\n")

cat("1. R version\n")
r_ok <- getRversion() >= "4.1.0"
chk(r_ok, paste("R", getRversion(), "is new enough (need 4.1 or later)"),
    paste("R", getRversion(), "is too old. Install the current release from cran.r-project.org"))

cat("2. RStudio\n")
in_rstudio <- identical(Sys.getenv("RSTUDIO"), "1")
chk(in_rstudio, "You are running inside RStudio",
    "Not running inside RStudio (fine on Posit Cloud / Colab, but check your install)")

cat("3. Packages\n")
pkgs <- c("tidyverse", "readxl", "arules", "rmarkdown", "knitr")
for (p in pkgs) {
  has <- requireNamespace(p, quietly = TRUE)
  chk(has, paste0(p, " ", if (has) as.character(packageVersion(p)) else ""),
      paste0(p, " is NOT installed -> run source('scripts/install_packages.R')"))
}

cat("4. Project folder and data\n")
data_dir <- if (dir.exists("data")) "data" else if (dir.exists("../data")) "../data" else NA
chk(!is.na(data_dir), paste("Found data folder:", data_dir),
    "No data/ folder found. Open DTS201_R.Rproj (File > Open Project) so the working directory is correct")
if (!is.na(data_dir)) {
  needed <- c("student_score.csv", "Sales_data.csv", "Sales_data.xlsx", "titanic_train.csv",
              "advertising.csv", "heart.csv", "grocery_transactions.csv", "retail_sales_ng.csv")
  for (f in needed) chk(file.exists(file.path(data_dir, f)), f, paste(f, "is missing"))
}

cat("5. Can R read a data file and draw a plot?\n")
if (!is.na(data_dir) && requireNamespace("readr", quietly = TRUE) &&
    file.exists(file.path(data_dir, "student_score.csv"))) {
  d <- readr::read_csv(file.path(data_dir, "student_score.csv"), show_col_types = FALSE)
  chk(nrow(d) > 0 && ncol(d) == 2, paste("Read student_score.csv:", nrow(d), "rows,", ncol(d), "columns"),
      "student_score.csv did not load correctly")
  plot(d$Hours, d$Scores, xlab = "Hours studied", ylab = "Score", pch = 19,
       main = "Setup check: if you can see this plot, graphics work")
  ok("Plot drawn (look at the Plots pane)")
} else {
  fail("Skipped (fix the items above first)")
}

cat("\nIf every line says [PASS], you are ready for Week 1.\n")
