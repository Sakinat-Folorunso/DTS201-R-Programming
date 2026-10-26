# DTS 201 lecture-note practical, Week 11C: Mini-project skeleton
# Run from the project root (open DTS201_R.Rproj first).

library(tidyverse)
set.seed(42)

# 1. Load and inspect (change the file for your project)
df <- read_csv("data/heart.csv") |> distinct()
dim(df); colSums(is.na(df))

# 2. EDA
ggplot(df, aes(age, thalach)) + geom_point(alpha = 0.6) + geom_smooth(method = "lm") +
  labs(x = "Age (years)", y = "Maximum heart rate (bpm)")
cor.test(df$age, df$thalach)

# 3. Model with a train/test split
idx <- sample(nrow(df), floor(0.8 * nrow(df)))
fit <- lm(thalach ~ age, data = df[idx, ])
pred <- predict(fit, df[-idx, ])
c(RMSE = sqrt(mean((df$thalach[-idx] - pred)^2)))

# 4. Group comparison
t.test(thalach ~ target, data = df)

