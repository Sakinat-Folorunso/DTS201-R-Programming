# DTS 201 lecture-note practical, Week 06A: Data mining and association rules
# Run from the project root (open DTS201_R.Rproj first).

library(tidyverse)
library(arules)
set.seed(42)

tx_df <- read_csv("data/grocery_transactions.csv")          # one row = one item in one basket
baskets <- split(tx_df$Item, tx_df$TransactionID)           # list of baskets
trans <- as(baskets, "transactions")
summary(trans)

# 1. Most frequent items
itemFrequencyPlot(trans, topN = 10, main = "Top 10 items")

# 2. Mine rules (thresholds are choices: justify them)
rules <- apriori(trans, parameter = list(supp = 0.05, conf = 0.6, minlen = 2), control = list(verbose = FALSE))
rules <- rules[!is.redundant(rules)]                        # drop rules that add nothing
inspect(head(sort(rules, by = "lift"), 5))

# 3. Check one rule by hand: support, confidence, lift
n  <- length(trans)
nA <- sum(sapply(baskets, function(b) "Beans" %in% b))
nB <- sum(sapply(baskets, function(b) "Palm oil" %in% b))
nAB <- sum(sapply(baskets, function(b) all(c("Beans", "Palm oil") %in% b)))
c(support = nAB / n, confidence = nAB / nA, lift = (nAB / nA) / (nB / n))

