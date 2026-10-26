# DTS 201 lecture-note practical, Week 05B: Regression
# Run from the project root (open DTS201_R.Rproj first).

library(tidyverse)
set.seed(42)
df <- read_csv("data/student_score.csv")

# 1. Fit and interpret
fit <- lm(Scores ~ Hours, data = df)
summary(fit)                      # slope, intercept, R-squared, p-values
confint(fit)                      # 95% confidence intervals

# 2. Plot the fitted line
ggplot(df, aes(Hours, Scores)) + geom_point() + geom_smooth(method = "lm") +
  labs(title = "Exam score versus study hours")

# 3. Error metrics: MSE, RMSE, MAE, R-squared
y <- df$Scores; yhat <- fitted(fit)
MSE <- mean((y - yhat)^2)
c(MSE = MSE, RMSE = sqrt(MSE), MAE = mean(abs(y - yhat)),
  R2 = 1 - sum((y - yhat)^2) / sum((y - mean(y))^2))

# 4. Residual check: should look like random noise around zero
ggplot(tibble(fitted = yhat, resid = resid(fit)), aes(fitted, resid)) +
  geom_point() + geom_hline(yintercept = 0, linetype = 2)

# 5. Multiple regression
ads <- read_csv("data/advertising.csv") |> rename(Time = `Daily Time Spent on Site`,
                                                  Usage = `Daily Internet Usage`)
summary(lm(Time ~ Age + Usage, data = ads))$coefficients

