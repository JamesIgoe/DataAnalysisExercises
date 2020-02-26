# Data Mining Algorithms in SSAS, Excel, and R
# https://app.pluralsight.com/player?course=data-mining-algorithms-ssas-excel-r&author=dejan-sarka&name=data-mining-algorithms-ssas-excel-r-m2&clip=6&mode=live

# Clear memory
rm(list = ls())


# set Working directory
getwd()
setwd('../Data')
setwd('H:/Personal/Code/TFS2013/RTutorials/TutorialsPoint/Data')
Portfolio.df <- read.csv("SamplePortfolio.csv")

# explore data #1
nrow(Portfolio.df)
head(Portfolio.df)
names(Portfolio.df)

# explore data #2
# but str shows type
summary(Portfolio.df)
str(Portfolio.df)

#explore data #3
library(ggplot2)
ggplot(Portfolio.df, aes(x = Price, fill = Sec_Type)) + geom_histogram(binwidth = 1)
ggplot(Portfolio.df, aes(x = Price, fill = Sec_Type)) + geom_histogram(binwidth = 10)
ggplot(Portfolio.df, aes(x = Price, fill = LEH_Rating__)) + geom_histogram(binwidth = 1)
ggplot(Portfolio.df, aes(x = Price, fill = LEH_Rating__)) + geom_histogram(binwidth = 10)

# Regression Trees
library(rpart)
Portfolio.tree.classified <- rpart(data = Portfolio.df, Sec_Group ~ Price + LEH_Sector + CountryOfRisk + LEH_Rating_Val + Analyst, method = 'anova')
summary(Portfolio.tree.classified)

Portfolio.tree.continuous <- rpart(data = Portfolio.df, Price ~ Duration + OAS + YTW, method = 'anova')
summary(Portfolio.tree.continuous)

# plot trees - discrete
plot(Portfolio.tree.classified, uniform = TRUE, main = "Regression Tree for Portfolio Price")
text(Portfolio.tree.classified, use.n = TRUE, all = TRUE, cex = .8)

# plot trees - continuous
plot(Portfolio.tree.continuous, uniform = TRUE, main = "Regression Tree for Portfolio Price")
text(Portfolio.tree.continuous, use.n = TRUE, all = TRUE, cex = .8)

# Linear Regression
Portfolio.lm <- lm(data = Portfolio.df, Price ~ Duration + OAS + YTW + DWE + WAL + Sec_Group)
summary(Portfolio.lm)

# plot linear regressions
plot(Portfolio.lm, uniform = TRUE, main = "Linear Regression for Portfolio Price")
text(Portfolio.lm, use.n = TRUE, all = TRUE, cex = .8)









