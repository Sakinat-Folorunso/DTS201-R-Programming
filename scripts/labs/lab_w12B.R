# DTS 201 lecture-note practical, Week 12B: Course review
# Run from the project root (open DTS201_R.Rproj first).

set.seed(42)
# Coin: 118 heads in 200 tosses
binom.test(118, 200)

# Regression by hand and with lm()
hours <- c(2, 4, 6, 8); score <- c(50, 60, 75, 85)
fit <- lm(score ~ hours)
coef(fit)
predict(fit, data.frame(hours = 5))

# Basket measures
n <- 500; rice <- 100; oil <- 80; both <- 60
c(support = both / n, confidence = both / rice, lift = (both / rice) / (oil / n))

# Classifier: TP = 40, FP = 10, FN = 20, TN = 130
TP <- 40; FP <- 10; FN <- 20; TN <- 130
c(accuracy = (TP + TN) / (TP + FP + FN + TN), precision = TP / (TP + FP),
  recall = TP / (TP + FN), F1 = 2 * TP / (2 * TP + FP + FN))
