# DTS 201 lecture-note practical, Week 03A: EDA
# Run from the project root (open DTS201_R.Rproj first).

library(tidyverse)
df <- read_csv("data/titanic_train.csv")

# 1. Numerical summaries
summary(df$Age)                                  # min, quartiles, mean, max, NAs
df |> summarise(mean = mean(Age, na.rm = TRUE),
                sd   = sd(Age, na.rm = TRUE),
                median = median(Age, na.rm = TRUE),
                IQR  = IQR(Age, na.rm = TRUE))

# 2. Categorical summaries
df |> count(Sex)
df |> group_by(Pclass) |> summarise(survival_rate = mean(Survived), n = n())

# 3. Distribution of a numerical variable
ggplot(df, aes(Age)) +
  geom_histogram(bins = 25, fill = "steelblue", colour = "white") +
  labs(title = "Distribution of passenger age", x = "Age (years)", y = "Count")

# 4. Compare groups
ggplot(df, aes(factor(Pclass), Fare)) + geom_boxplot() +
  labs(x = "Passenger class", y = "Fare")

# 5. Relationship between two numerical variables
ct <- cor.test(df$Age, df$Fare)
c(r = unname(ct$estimate), lower = ct$conf.int[1], upper = ct$conf.int[2])

