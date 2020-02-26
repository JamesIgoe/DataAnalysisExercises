################################################
#
# Hierarchical Clustering
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
AccountHoldings.df.preclean <- read.csv("AccountHoldingsLogData.csv", na.strings = c("", "NA"))
nrow(AccountHoldings.df.preclean)

# remove NULLs
AccountHoldings.df.preclean <- na.omit(AccountHoldings.df.preclean)
nrow(AccountHoldings.df.preclean)

AccountHoldings.df <- AccountHoldings.df.preclean
str(AccountHoldings.df)



################################################
# H Clustering
################################################

AccountHoldings.df.unique <- unique(AccountHoldings.df)

AccountHoldings.dist <- dist(AccountHoldings.df.unique[,2:20], method = "euclidean")
AccountHoldings.hClustModel <- hclust(AccountHoldings.dist, method = "ward.D2")
hClust.plot <- plot(AccountHoldings.hClustModel)

kClusters <- 16
AccountHoldings.hClustModel.groups <- cutree(AccountHoldings.hClustModel, k = kClusters)
rect.hclust(AccountHoldings.hClustModel, k = kClusters, border = "red")


################################################
# Join and Interpret
################################################

# join data against grouping
AccountHoldings.hclust.combined <- as.data.frame(cbind(AccountHoldings.hClustModel.groups, AccountHoldings.df.unique))
#head(AccountHoldings.hclust.combined)

# review data, natively
(AccountHoldings.hclust.combined[AccountHoldings.hclust.combined$AccountHoldings.hClustModel.groups == 1,])
(AccountHoldings.hclust.combined[AccountHoldings.hclust.combined$AccountHoldings.hClustModel.groups == 2,])
(AccountHoldings.hclust.combined[AccountHoldings.hclust.combined$AccountHoldings.hClustModel.groups == 3,])
(AccountHoldings.hclust.combined[AccountHoldings.hclust.combined$AccountHoldings.hClustModel.groups == 4,])
(AccountHoldings.hclust.combined[AccountHoldings.hclust.combined$AccountHoldings.hClustModel.groups == 5,])
(AccountHoldings.hclust.combined[AccountHoldings.hclust.combined$AccountHoldings.hClustModel.groups == 6,])
(AccountHoldings.hclust.combined[AccountHoldings.hclust.combined$AccountHoldings.hClustModel.groups == 7,])
(AccountHoldings.hclust.combined[AccountHoldings.hclust.combined$AccountHoldings.hClustModel.groups == 8,])
(AccountHoldings.hclust.combined[AccountHoldings.hclust.combined$AccountHoldings.hClustModel.groups == 9,])
(AccountHoldings.hclust.combined[AccountHoldings.hclust.combined$AccountHoldings.hClustModel.groups == 10,])
(AccountHoldings.hclust.combined[AccountHoldings.hclust.combined$AccountHoldings.hClustModel.groups == 11,])
(AccountHoldings.hclust.combined[AccountHoldings.hclust.combined$AccountHoldings.hClustModel.groups == 12,])
(AccountHoldings.hclust.combined[AccountHoldings.hclust.combined$AccountHoldings.hClustModel.groups == 13,])
(AccountHoldings.hclust.combined[AccountHoldings.hclust.combined$AccountHoldings.hClustModel.groups == 14,])
(AccountHoldings.hclust.combined[AccountHoldings.hclust.combined$AccountHoldings.hClustModel.groups == 15,])
(AccountHoldings.hclust.combined[AccountHoldings.hclust.combined$AccountHoldings.hClustModel.groups == 16,])

# review data in Excel
# export data
#install.packages("rio", dependencies = TRUE)
library(rio)
export(AccountHoldings.hclust.combined, "AccountHoldings.hclust.combined.csv")


################################################
# K-Means
################################################

set.seed(20)
AccountHoldings.kMean <- kmeans(AccountHoldings.df[, 3:20], 10, nstart = 20)

# display kkmeans
#AccountHoldings.kMean$cluster

# display means of clusters
AccountHoldings.kMean$centers

# summarize result
#summary(AccountHoldings.kMean)

#install.packages("broom", dependencies = TRUE)
library(broom)
tidy.plot <- tidy(AccountHoldings.kMean)
# display tidy
tidy.plot



################################################
# Alternate elbow
# https://cran.r-project.org/web/packages/broom/vignettes/kmeans.html
################################################

#install.packages('dyplr', dependencies = TRUE)
library(dplyr)
kclusts <- NA
kclusts <- data.frame(k = 1:20) %>% group_by(k) %>% do(kclust = kmeans(AccountHoldings.df[, 3:20], .$k))

clusterings <- kclusts %>% group_by(k) %>% do(glance(.$kclust[[1]]))
#plot(clusterings)

library(ggplot2)
ggplot(clusterings, aes(k, tot.withinss)) + geom_line()


################################################
# K-Means - stat methods
################################################

# Determine number of clusters
AccountHoldings.scaled <- scale(AccountHoldings.df[, 3:20])
head(AccountHoldings.scaled)

wss <- (nrow(AccountHoldings.scaled) - 1) * sum(apply(AccountHoldings.scaled, 2, var))
for (i in 2:20)
    wss[i] <- sum(kmeans(AccountHoldings.scaled, centers = i)$withinss)
plot(1:20, wss, type = "b", xlab = "Number of Clusters", ylab = "Within groups sum of squares")



# set clusters
kClusters = 10

# K-Means Cluster Analysis
AccountHoldings.scaled.fit <- kmeans(AccountHoldings.scaled, kClusters)

# get cluster means 
aggregate(AccountHoldings.scaled, by = list(AccountHoldings.scaled.fit$cluster), FUN = mean)

# append cluster assignment
AccountHoldings.scaled.combined <- data.frame(AccountHoldings.scaled.fit$cluster, AccountHoldings.scaled)

#plot(AccountHoldings.scaled, col = (AccountHoldings.scaled.fit$cluster + 1), main = "K-Means result with 6 clusters", pch = 20, cex = 2)

AccountHoldings.scaled.fit.centers <- as.data.frame(AccountHoldings.scaled.fit$centers)

# plot
library(ggplot2)
centerColor <- 'Blue'
plot <- ggplot(AccountHoldings.scaled.combined, aes(x = SecGroup, y = Account, color = AccountHoldings.scaled.fit$cluster)) + geom_point()
plotCenter1 <- plot + geom_point(data = AccountHoldings.scaled.fit.centers, aes(x = SecGroup, y = Account), color = centerColor)
plotCenter1 + geom_point(data = AccountHoldings.scaled.fit.centers, aes(x = SecGroup, y = Account), color = centerColor, size = 100, alpha = .3)


################################################
# K-Means - analyze categorizationsin Excel
################################################

# append cluster assignment
AccountHoldings.df.combined <- data.frame(AccountHoldings.df, AccountHoldings.scaled.fit$cluster)
head(AccountHoldings.df.combined)

# export dasta
#install.packages("rio", dependencies = TRUE)
library(rio)
export(AccountHoldings.df.combined, "AccountHoldings.df.combined.csv")
