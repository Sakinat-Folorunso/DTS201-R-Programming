# DTS 201 lecture-note practical, Week 04B: Sampling and bias
# Run from the project root (open DTS201_R.Rproj first).

library(tidyverse)
set.seed(42)
pop <- read_csv("data/retail_sales_ng.csv")     # treat these 4,257 sales as the population
mean(pop$Sales_Amount)                          # true population mean

# 1. Simple random sample
srs <- slice_sample(pop, n = 200)
mean(srs$Sales_Amount)

# 2. Stratified sample: 40 sales from each region
strat <- pop |> group_by(Region) |> slice_sample(n = 40) |> ungroup()
mean(strat$Sales_Amount)

# 3. Systematic sample: every k-th row
k <- floor(nrow(pop) / 200)
sys <- pop[seq(sample(k, 1), nrow(pop), by = k), ]
mean(sys$Sales_Amount)

# 4. Sampling variability: 1000 repeated samples of size 200
means <- replicate(1000, mean(slice_sample(pop, n = 200)$Sales_Amount))
c(mean_of_means = mean(means), standard_error = sd(means))

# 5. Sampling bias: only the largest sales are surveyed
biased <- pop |> arrange(desc(Sales_Amount)) |> slice_head(n = 200)
mean(biased$Sales_Amount)                       # far above the true mean

