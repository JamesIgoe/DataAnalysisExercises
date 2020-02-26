# Data Mining Algorithms in SSAS, Excel, and R
# https://app.pluralsight.com/player?course=data-mining-algorithms-ssas-excel-r&author=dejan-sarka&name=data-mining-algorithms-ssas-excel-r-m2&clip=6&mode=live

# Clear memory
rm(list = ls())


# set Working directory
getwd()
setwd('../Data')
Politics.df <- read.csv("BigFiveScoresByState.csv", na.strings = c("", "NA"))

# remove NULLs
Politics.df <- na.omit(Politics.df)

# explore data #1
nrow(Politics.df)
head(Politics.df)
names(Politics.df)


# explore data #2
# but str shows type
summary(Politics.df)
str(Politics.df)


#explore data #3
library(ggplot2)
plot.openness <- ggplot(Politics.df, aes(x = Openness, fill = Politics))
plot.openness.histo <- plot.openness + geom_histogram(binwidth = 1)
plot.openness.histo + scale_fill_manual(values = c("Red" = "red", "Blue" = "blue"))

plot.conscientiousness <- ggplot(Politics.df, aes(x = Conscientiousness, fill = Politics))
plot.conscientiousness.histo <- plot.conscientiousness + geom_histogram(binwidth = 1)
plot.conscientiousness.histo + scale_fill_manual(values = c("Red" = "red", "Blue" = "blue"))

# load library for SVM
library(e1071)

Politics.training <- Politics.df
str(Politics.training)

Politics.predictors <- Politics.training[,2:6]
Politics.predicted <- Politics.training[,12]

# review subsets
str(Politics.predictors)
str(Politics.predicted)

Politics.svm <- svm(data = Politics.training, Politics ~ Openness + Conscientiousness + Extraversion + Neuroticism + Agreeableness)
summary(Politics.svm)

Politics.prediction <- predict(Politics.svm, Politics.predictors)

table(Politics.prediction, Politics.predicted)

plot(Politics.svm, Politics.training, Openness ~ Conscientiousness, slice = list(Extraversion = 25, Neuroticism = 25, Agreeableness = 25))


# reduced predictors
str(Politics.training)
Politics.predictors <- Politics.training[, 4:6]
Politics.predicted <- Politics.training[, 12]

Politics.svm <- svm(data = Politics.training, Politics ~ Openness + Conscientiousness)
summary(Politics.svm)

Politics.prediction <- predict(Politics.svm, Politics.predictors)

table(Politics.prediction, Politics.predicted)

plot(Politics.svm, Politics.training, Openness ~ Conscientiousness)
