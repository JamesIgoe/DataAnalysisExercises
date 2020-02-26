################################################
# Hierarchical Clustering
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
# H Clustering
################################################

Hofstede.dist <- dist(Hofstede.df, method = "euclidean")

kClusters <- 10
Hofstede.hClustModel <- hclust(Hofstede.dist, method = "ward.D2")
plot(Hofstede.hClustModel)
Hofstede.hClustModel.groups <- cutree(Hofstede.hClustModel, k = kClusters)
rect.hclust(Hofstede.hClustModel, k = kClusters, border = "red")


################################################
# Join and Interpret
################################################

# join data against grouping
Hofstede.hclust.combined <- as.data.frame(cbind(Hofstede.hClustModel.groups, Hofstede.df))
#head(Hofstede.hclust.combined)

# review data, natively
(Hofstede.hclust.combined[Hofstede.hclust.combined$Hofstede.hClustModel.groups == 1,])
(Hofstede.hclust.combined[Hofstede.hclust.combined$Hofstede.hClustModel.groups == 2,])
(Hofstede.hclust.combined[Hofstede.hclust.combined$Hofstede.hClustModel.groups == 3,])
(Hofstede.hclust.combined[Hofstede.hclust.combined$Hofstede.hClustModel.groups == 4,])
(Hofstede.hclust.combined[Hofstede.hclust.combined$Hofstede.hClustModel.groups == 5,])
(Hofstede.hclust.combined[Hofstede.hclust.combined$Hofstede.hClustModel.groups == 6,])
(Hofstede.hclust.combined[Hofstede.hclust.combined$Hofstede.hClustModel.groups == 7,])
(Hofstede.hclust.combined[Hofstede.hclust.combined$Hofstede.hClustModel.groups == 8,])
(Hofstede.hclust.combined[Hofstede.hclust.combined$Hofstede.hClustModel.groups == 9,])
(Hofstede.hclust.combined[Hofstede.hclust.combined$Hofstede.hClustModel.groups == 10,])

# review data in Excel
# export data
#install.packages("rio", dependencies = TRUE)
library(rio)
export(Hofstede.hclust.combined, "Hofstede.hclust.combined.csv")



