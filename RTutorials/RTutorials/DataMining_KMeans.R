################################################
# K-Means Clustering
#
# Data Mining Algorithms in SSAS, Excel, and R
# https://app.pluralsight.com/player?course=data-mining-algorithms-ssas-excel-r&author=dejan-sarka&name=data-mining-algorithms-ssas-excel-r-m2
#
################################################

################################################
# prep workspace
################################################

# Clear memory
rm(list = ls())

# update all packages
update.packages(ask = FALSE)


################################################
# Load and clean data
################################################

# set Working directory
getwd()
#setwd('../Data')

# load data
Hofstede.df.preclean <- read.csv("HofstedePatterns.csv", na.strings = c("", "NA"))
nrow(Hofstede.df.preclean)

# remove NULLs
Hofstede.df.preclean <- na.omit(Hofstede.df.preclean)
nrow(Hofstede.df.preclean)

Hofstede.df <- Hofstede.df.preclean


################################################
# K-Means
################################################

set.seed(20)
Hofstede.kMean <- kmeans(Hofstede.df[,2:5], 6, nstart = 20)

# display kkmanes 
Hofstede.kMean$

# display means of clusters
Hofstede.kMean$centers

# summarize result
#summary(Hofstede.kMean)

#install.packages("broom", dependencies = TRUE)
library(broom)
tidy.plot <- tidy(Hofstede.kMean)
# display tidy
tidy.plot

# plot 2-dimensional relationship
Hofsted.plot <- as.factor(Hofstede.kMean$cluster)
library(ggplot2)
ggplot(Hofstede.df, aes(Individuality, Masculinity, color = Hofsted.plot)) + geom_point()


################################################
# Alternate elbow
# https://cran.r-project.org/web/packages/broom/vignettes/kmeans.html
################################################

#install.packages('dyplr', dependencies = TRUE)
library(dplyr)
kclusts <- NA
kclusts <- data.frame(k = 1:20) %>% group_by(k) %>% do(kclust = kmeans(Hofstede.df[, 2:5], .$k))

clusterings <- kclusts %>% group_by(k) %>% do(glance(.$kclust[[1]]))
#plot(clusterings)

library(ggplot2)
ggplot(clusterings, aes(k, tot.withinss)) + geom_line()


################################################
# K-Means - stat methods
################################################

# Determine number of clusters
Hofstede.scaled <- scale(Hofstede.df[, 2:5])
wss <- (nrow(Hofstede.scaled) - 1) * sum(apply(Hofstede.scaled, 2, var))
for (i in 2:20)
    wss[i] <- sum(kmeans(Hofstede.scaled, centers = i)$withinss)
    plot(1:20, wss, type = "b", xlab = "Number of Clusters", ylab = "Within groups sum of squares")

# set clusters
kClusters = 6

# K-Means Cluster Analysis
Hofstede.scaled.fit <- kmeans(Hofstede.scaled, kClusters)

# get cluster means 
aggregate(Hofstede.scaled, by = list(Hofstede.scaled.fit$cluster), FUN = mean)

# append cluster assignment
Hofstede.scaled.combined <- data.frame(Hofstede.scaled.fit$cluster, Hofstede.scaled)

#plot(Hofstede.scaled, col = (Hofstede.scaled.fit$cluster + 1), main = "K-Means result with 6 clusters", pch = 20, cex = 2)

Hofstede.scaled.fit.centers <- as.data.frame(Hofstede.scaled.fit$centers)

# plot
library(ggplot2)
centerColor <- 'Blue'
plot <- ggplot(Hofstede.scaled.combined, aes(x = Individuality, y = Masculinity, color = Hofstede.scaled.fit$cluster)) + geom_point()
plotCenter1 <- plot + geom_point(data = Hofstede.scaled.fit.centers, aes(x = Individuality, y = Masculinity), color = centerColor)
plotCenter1 + geom_point(data = Hofstede.scaled.fit.centers, aes(x = Individuality, y = Masculinity), color = centerColor, size = 100, alpha = .3)


################################################
# K-Means - analyze categorizationsin Excel
################################################

# append cluster assignment
Hofstede.df.combined <- data.frame(Hofstede.df, Hofstede.scaled.fit$cluster)
head(Hofstede.df.combined)

# export dasta
#install.packages("rio", dependencies = TRUE)
library(rio)
export(Hofstede.df.combined, "Hofstede.df.combined.csv")


