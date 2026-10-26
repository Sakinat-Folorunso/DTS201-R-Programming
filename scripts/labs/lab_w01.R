# DTS 201 lecture-note practical, Week 01: Datasets and data types
# Run from the project root (open DTS201_R.Rproj first).

library(tidyverse)

students <- read_csv("data/student_score.csv")   # structured data (rows and columns)
glimpse(students)          # variable names, types and first values
dim(students)              # number of rows and columns
head(students, 5)          # first five rows

library(jsonlite)
js <- '{"student": "Ade", "scores": {"maths": 70, "stats": 82}, "courses": ["DTS201", "CSC201"]}'
rec <- fromJSON(js)
rec$scores$stats           # navigate the nested fields

review <- "Delivery was fast but the packaging was poor."
nchar(review)                          # number of characters
str_split(review, " ")[[1]]            # split into words

