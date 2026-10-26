# ==============================================================================
# DTS 201 - Introduction to Data Science (R edition)
# scripts/install_packages.R
#
# Installs every R package used in Weeks 0-11, skipping those already present.
# Run ONCE, on a good internet connection (the tidyverse is a large download):
#     source("scripts/install_packages.R")
# ==============================================================================

required_pkgs <- c(
  "tidyverse",   # dplyr, ggplot2, readr, tidyr, tibble, stringr, forcats, lubridate, purrr
  "readxl",      # read Excel (.xlsx) files                    (Weeks 1-2)
  "arules",      # Apriori / association rules                 (Week 6)
  "rmarkdown",   # knit the .Rmd class notebooks               (all weeks)
  "knitr"        # code-chunk engine and kable() tables        (all weeks)
)

# Choose the CRAN mirror automatically (no pop-up window).
options(repos = c(CRAN = "https://cloud.r-project.org"))

missing_pkgs <- required_pkgs[!vapply(required_pkgs, requireNamespace,
                                      logical(1), quietly = TRUE)]

if (length(missing_pkgs) == 0) {
  message("All required packages are already installed. You are ready for Week 1.")
} else {
  message("Installing: ", paste(missing_pkgs, collapse = ", "))
  install.packages(missing_pkgs)
  still_missing <- missing_pkgs[!vapply(missing_pkgs, requireNamespace,
                                        logical(1), quietly = TRUE)]
  if (length(still_missing) > 0) {
    warning("These packages did not install: ", paste(still_missing, collapse = ", "),
            "\nSee the Troubleshooting table in the Week 0 notebook.")
  } else {
    message("Done. All packages installed successfully.")
  }
}
