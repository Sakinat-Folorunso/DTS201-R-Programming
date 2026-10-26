# DTS 201 lecture-note practical, Week 09: Big data and large files
# Run from the project root (open DTS201_R.Rproj first).

library(tidyverse)
set.seed(42)

# 1. Simulate a large dataset (100,000 rows) and write it to disk
n <- 100000
big <- tibble(id = 1:n,
              region = sample(c("North", "South", "East", "West"), n, replace = TRUE),
              amount = rnorm(n, mean = 100, sd = 15))
dir.create("outputs", showWarnings = FALSE)
write_csv(big, "outputs/simulated_large_dataset.csv")
file.size("outputs/simulated_large_dataset.csv") / 1024^2     # size on disk in MB
format(object.size(big), units = "MB")                         # size in memory

# 2. Process the file in chunks, keeping only running totals (n, sum x, sum x^2)
stats <- list(n = 0, s = 0, ss = 0)
chunk_fun <- function(chunk, pos) {
  stats$n  <<- stats$n  + nrow(chunk)
  stats$s  <<- stats$s  + sum(chunk$amount)
  stats$ss <<- stats$ss + sum(chunk$amount^2)
}
invisible(read_csv_chunked("outputs/simulated_large_dataset.csv", SideEffectChunkCallback$new(chunk_fun),
                 chunk_size = 20000, col_types = cols()))
m  <- stats$s / stats$n
sd_chunk <- sqrt((stats$ss - stats$n * m^2) / (stats$n - 1))
c(chunked_mean = m, chunked_sd = sd_chunk, direct_mean = mean(big$amount), direct_sd = sd(big$amount))

# 3. Save memory with the right types
big2 <- big |> mutate(region = factor(region), id = as.integer(id))
c(before = object.size(big), after = object.size(big2))

# 4. Group summary on the full data
big2 |> group_by(region) |> summarise(n = n(), mean = mean(amount), sd = sd(amount))

