# DTS 201 lecture-note practical, Week 02B: Preprocessing and feature engineering
# Run from the project root (open DTS201_R.Rproj first).

library(tidyverse)
df <- read_csv("data/titanic_train.csv")

# 1. Missing values and feature engineering
df <- df |>
  mutate(Age       = replace_na(Age, median(Age, na.rm = TRUE)),
         FamilySize = SibSp + Parch + 1,                         # new feature
         IsAlone    = as.integer(FamilySize == 1),
         Title      = str_extract(Name, "(?<=, )[A-Za-z]+"),      # text feature
         Sex        = factor(Sex),
         Pclass     = factor(Pclass))

# 2. Encoding a categorical variable (one-hot)
head(model.matrix(~ Sex + Pclass, data = df), 3)

# 3. Scaling: standardisation (z-score) and min-max
df <- df |> mutate(Fare_z   = as.numeric(scale(Fare)),
                   Fare_mm  = (Fare - min(Fare)) / (max(Fare) - min(Fare)))
summary(df[, c("Fare_z", "Fare_mm")])

# 4. Binning a numerical variable
df <- df |> mutate(AgeGroup = cut(Age, c(0, 12, 18, 40, 60, Inf),
                                  labels = c("Child", "Teen", "Adult", "Middle", "Senior")))
df |> group_by(AgeGroup) |> summarise(survival = mean(Survived), n = n())

# 5. Simple feature selection: association with the target
round(cor(df[, c("Survived", "Age", "Fare", "FamilySize", "SibSp", "Parch")])[, "Survived"], 2)

