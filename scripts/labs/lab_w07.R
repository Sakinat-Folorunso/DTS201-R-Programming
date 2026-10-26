# DTS 201 lecture-note practical, Week 07: Statistical analysis
# Run from the project root (open DTS201_R.Rproj first).

library(tidyverse)
ads <- read_csv("data/advertising.csv") |>
  rename(Time = `Daily Time Spent on Site`, Clicked = `Clicked on Ad`)

# 1. One-sample t-test: is mean Time different from 60 minutes?
t.test(ads$Time, mu = 60)

# 2. Welch two-sample t-test: do clickers spend different time on the site?
t.test(Time ~ Clicked, data = ads)

# Effect size: Cohen's d with pooled SD
g  <- split(ads$Time, ads$Clicked)
sp <- sqrt(((length(g[[1]]) - 1) * var(g[[1]]) + (length(g[[2]]) - 1) * var(g[[2]])) /
           (length(g[[1]]) + length(g[[2]]) - 2))
abs(mean(g[[1]]) - mean(g[[2]])) / sp

# 3. Chi-square test: is gender associated with clicking?
tab <- table(ads$Male, ads$Clicked)
tab
res <- chisq.test(tab)
res
sqrt(unname(res$statistic) / (sum(tab) * (min(dim(tab)) - 1)))   # Cramer's V

# 4. Correlation with a 95% confidence interval
ct <- cor.test(ads$Age, ads$Time)
c(r = unname(ct$estimate), lower = ct$conf.int[1], upper = ct$conf.int[2], p = ct$p.value)

