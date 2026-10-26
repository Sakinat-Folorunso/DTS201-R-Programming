# DTS 201 lecture-note practical, Week 06B: Clustering and PCA
# Run from the project root (open DTS201_R.Rproj first).

library(tidyverse)
set.seed(42)
heart <- read_csv("data/heart.csv")
x <- scale(heart[, c("age", "trestbps", "chol", "thalach", "oldpeak")])   # always scale first

# 1. Choose k: elbow (within-cluster sum of squares) and silhouette
wss <- map_dbl(1:8, ~ kmeans(x, .x, nstart = 25)$tot.withinss)
plot(1:8, wss, type = "b", xlab = "k", ylab = "Total within-cluster SS")

sil <- map_dbl(2:6, function(k) {
  km <- kmeans(x, k, nstart = 25)
  mean(cluster::silhouette(km$cluster, dist(x))[, "sil_width"])
})
round(setNames(sil, 2:6), 3)          # values below about 0.25 mean weak structure

# 2. K-means with the chosen k
km <- kmeans(x, centers = 3, nstart = 25)
heart |> mutate(cluster = factor(km$cluster)) |>
  group_by(cluster) |> summarise(n = n(), across(c(age, thalach, chol), mean))

# 3. Hierarchical clustering
hc <- hclust(dist(x), method = "ward.D2")
plot(hc, labels = FALSE, main = "Dendrogram")
table(cutree(hc, k = 3))

# 4. PCA for visualisation
pc <- prcomp(x)
summary(pc)$importance[, 1:2]         # variance explained
tibble(PC1 = pc$x[, 1], PC2 = pc$x[, 2], cluster = factor(km$cluster)) |>
  ggplot(aes(PC1, PC2, colour = cluster)) + geom_point()

