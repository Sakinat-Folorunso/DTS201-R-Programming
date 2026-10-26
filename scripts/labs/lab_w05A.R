# DTS 201 lecture-note practical, Week 05A: Introduction to machine learning
# Run from the project root (open DTS201_R.Rproj first).

library(tidyverse)
set.seed(42)
df <- read_csv("data/student_score.csv")

# 1. Train/test split (80/20)
idx   <- sample(nrow(df), floor(0.8 * nrow(df)))
train <- df[idx, ]
test  <- df[-idx, ]

# 2. Supervised: learn Scores from Hours
model <- lm(Scores ~ Hours, data = train)
coef(model)

# 3. Predict and evaluate on unseen data
pred <- predict(model, newdata = test)
c(RMSE = sqrt(mean((test$Scores - pred)^2)),
  MAE  = mean(abs(test$Scores - pred)))

# 4. Unsupervised: no labels, find groups
heart <- read_csv("data/heart.csv")
x  <- scale(heart[, c("age", "trestbps", "chol", "thalach")])
km <- kmeans(x, centers = 3, nstart = 25)
table(km$cluster)

