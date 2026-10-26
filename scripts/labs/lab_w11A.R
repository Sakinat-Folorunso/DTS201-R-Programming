# DTS 201 lecture-note practical, Week 11A: Classification
# Run from the project root (open DTS201_R.Rproj first).

library(tidyverse)
library(rpart)                    # decision trees (ships with R)
set.seed(42)

df <- read_csv("data/titanic_train.csv") |>
  mutate(Age = replace_na(Age, median(Age, na.rm = TRUE)),
         Sex = factor(Sex), Pclass = factor(Pclass)) |>
  select(Survived, Pclass, Sex, Age, SibSp, Parch, Fare)

idx   <- sample(nrow(df), floor(0.8 * nrow(df)))
train <- df[idx, ]; test <- df[-idx, ]

# 1. Logistic regression
logit <- glm(Survived ~ ., data = train, family = binomial)
prob  <- predict(logit, test, type = "response")      # probabilities
pred  <- as.integer(prob > 0.5)                       # decision threshold 0.5

# 2. Confusion matrix and metrics
cm <- table(Actual = test$Survived, Predicted = pred)
cm
TP <- cm["1", "1"]; TN <- cm["0", "0"]; FP <- cm["0", "1"]; FN <- cm["1", "0"]
c(accuracy  = (TP + TN) / sum(cm),
  precision = TP / (TP + FP),
  recall    = TP / (TP + FN),
  F1        = 2 * TP / (2 * TP + FP + FN))

# 3. Decision tree
tree <- rpart(factor(Survived) ~ ., data = train, method = "class")
tree_pred <- predict(tree, test, type = "class")
mean(tree_pred == test$Survived)                      # accuracy
plot(tree, margin = 0.1); text(tree, use.n = TRUE, cex = 0.7)

