# DTS 201 lecture-note practical, Week 04A: Probability, distributions and simulation
# Run from the project root (open DTS201_R.Rproj first).

library(tidyverse)
set.seed(42)                                  # reproducible random numbers

# 1. Coin toss: 1000 fair tosses
tosses <- sample(c("H", "T"), 1000, replace = TRUE)
table(tosses) / 1000                          # relative frequencies, close to 0.5
binom.test(sum(tosses == "H"), 1000)$conf.int # 95% CI for P(heads)

# 2. Law of large numbers: running proportion of heads
tibble(n = 1:1000, p_hat = cumsum(tosses == "H") / (1:1000)) |>
  ggplot(aes(n, p_hat)) + geom_line() + geom_hline(yintercept = 0.5, linetype = 2) +
  labs(x = "Number of tosses", y = "Proportion of heads")

# 3. Two dice: the sum is not uniform
sums <- replicate(10000, sum(sample(1:6, 2, replace = TRUE)))
ggplot(tibble(sums), aes(factor(sums))) + geom_bar() + labs(x = "Sum of two dice", y = "Count")
mean(sums)                                    # theory: 7

# 4. Three key distributions
tibble(x = rnorm(5000, mean = 50, sd = 10)) |>
  ggplot(aes(x)) + geom_histogram(aes(y = after_stat(density)), bins = 30, fill = "grey80") +
  stat_function(fun = dnorm, args = list(mean = 50, sd = 10), colour = "firebrick")

tibble(k = 0:20, p = dbinom(0:20, size = 20, prob = 0.3)) |>
  ggplot(aes(k, p)) + geom_col() + labs(title = "Binomial(n = 20, p = 0.3)")

mean(runif(5000, 0, 10))                      # uniform on [0, 10]: theory 5

# 5. Descriptive statistics of a sample
x <- rnorm(200, 50, 10)
c(mean = mean(x), median = median(x), sd = sd(x), var = var(x))

