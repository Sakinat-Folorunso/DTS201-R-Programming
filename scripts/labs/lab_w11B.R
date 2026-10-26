# DTS 201 lecture-note practical, Week 11B: Model evaluation
# Run from the project root (open DTS201_R.Rproj first).

library(tidyverse)
set.seed(42)
df <- read_csv("data/student_score.csv")

rmse <- function(y, yhat) sqrt(mean((y - yhat)^2))

# 1. Hold-out: training error is optimistic, test error is honest
idx <- sample(nrow(df), 18); train <- df[idx, ]; test <- df[-idx, ]

# 2. Overfitting: increase model flexibility (polynomial degree)
res <- map_dfr(1:8, function(d) {
  m <- lm(Scores ~ poly(Hours, d), data = train)
  tibble(degree = d,
         train_rmse = rmse(train$Scores, fitted(m)),
         test_rmse  = rmse(test$Scores, predict(m, test)))
})
res |> pivot_longer(-degree) |>
  ggplot(aes(degree, value, colour = name)) + geom_line() + geom_point() +
  labs(y = "RMSE", colour = "")

# 3. k-fold cross-validation (k = 5)
k <- 5
fold <- sample(rep(1:k, length.out = nrow(df)))
cv <- map_dbl(1:k, function(f) {
  m <- lm(Scores ~ Hours, data = df[fold != f, ])
  rmse(df$Scores[fold == f], predict(m, df[fold == f, ]))
})
c(mean = mean(cv), sd = sd(cv))

# 4. Confusion matrix for a classifier (see Week 11, Part A)
heart <- read_csv("data/heart.csv")
g <- glm(target ~ age + thalach + chol, data = heart, family = binomial)
table(Actual = heart$target, Predicted = as.integer(fitted(g) > 0.5))

