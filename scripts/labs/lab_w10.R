# DTS 201 lecture-note practical, Week 10: R programming basics
# Run from the project root (open DTS201_R.Rproj first).

# 1. Variables and types
name <- "Ada"; age <- 21L; gpa <- 4.2; passed <- TRUE
class(name); class(age); class(gpa); class(passed)

# 2. Vectors
scores <- c(70, 82, 65, 90, 58)
mean(scores); sd(scores); max(scores)
scores[scores >= 65]                    # logical indexing
scores + 5                              # vectorised arithmetic

# 3. Data frame
students <- data.frame(name = c("Ade", "Bola", "Chidi", "Dayo", "Efe"),
                       score = scores)
students$grade <- ifelse(students$score >= 70, "Pass", "Fail")
students

# 4. A loop and a function
for (i in seq_len(nrow(students))) {
  cat(students$name[i], "scored", students$score[i], "\n")
}
grade_of <- function(score) {
  if (score >= 70) "A" else if (score >= 60) "B" else "C"
}
sapply(students$score, grade_of)

# 5. Tidyverse in three lines
library(tidyverse)
students |> group_by(grade) |> summarise(n = n(), mean_score = mean(score))

# 6. Run a script: save the lines above as my_script.R, then
# source("my_script.R")

