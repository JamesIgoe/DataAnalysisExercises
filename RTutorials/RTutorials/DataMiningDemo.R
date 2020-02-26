
# Data Mining Algorithms in SSAS, Excel, and R
# https://app.pluralsight.com/player?course=data-mining-algorithms-ssas-excel-r&author=dejan-sarka&name=data-mining-algorithms-ssas-excel-r-m2&clip=6&mode=live

# Clear memory
rm(list = ls())

# install RODBC
install.packages('RODBC')
library(RODBC)

# 
# FROM DEMO
#

# connect
connection <- odbcConnect("AccountHoldings_TST")
 
# read from data frame
AccountHoldings.df <- as.data.frame(sqlQuery(connection, "SELECT DISTINCT [As of Date], Account, Cusip, Issuer, Price, Duration, OAS, YTW, Moodys, [Sec. Group] AS 'SecGroup', [Mkt Val] as 'MarketValue' FROM dbo.AH_HY_Portfolio_Positions AH_HY_Portfolio_Positions WHERE [As of Date] > '2017-04-01' AND Account = 'GHY'"), stringAsFactors = FALSE)

# close connection
close(connection)

# review data
head(AccountHoldings.df)
nrow(AccountHoldings.df)
summary(AccountHoldings.df)

# rename as of date
(names(AccountHoldings.df))
names(AccountHoldings.df)[1] <- "AsOfDate"
(names(AccountHoldings.df))

# varous aggregations
# as "count this value" ~ grouped by this + this
date.dist <- aggregate(Cusip ~ AsOfDate, data = AccountHoldings.df, FUN = length)
head(date.dist)

rating.dist <- aggregate(Cusip ~ Moodys + AsOfDate, data = AccountHoldings.df, FUN = length)
head(rating.dist)

SecGroup.dist <- aggregate(Cusip ~ SecGroup + AsOfDate, data = AccountHoldings.df, FUN = length)
head(SecGroup.dist)

MktVal.dist <- aggregate(MarketValue ~ SecGroup + AsOfDate, data = AccountHoldings.df, FUN = sum)
head(MktVal.dist)


# install ggplot
install.packages('ggplot2')
library(ggplot2)

# plotting
ggplot(AccountHoldings.df, aes(x = Price)) + geom_histogram(binwidth = 1)
ggplot(AccountHoldings.df, aes(x = Duration)) + geom_histogram(binwidth = 1)
ggplot(AccountHoldings.df, aes(x = OAS)) + geom_histogram(binwidth = 100)
ggplot(AccountHoldings.df, aes(x = YTW,)) + geom_histogram(binwidth = 1)
ggplot(AccountHoldings.df, aes(x = Moodys)) + geom_histogram()
ggplot(AccountHoldings.df, aes(y = Moodys, x = Price)) + geom_histogram()

ggplot(AccountHoldings.df, aes(AsOfDate, fill=Moodys)) + geom_bar()
ggplot(AccountHoldings.df, aes(AsOfDate, fill = SecGroup)) + geom_bar()
ggplot(AccountHoldings.df, aes(AsOfDate, fill = SecGroup)) + geom_bar()

CountPerDay <- ggplot(AccountHoldings.df, aes(x = AsOfDate))
CountPerDay + geom_bar()

moodyBuckets <- ggplot(AccountHoldings.df, aes(x = Moodys))
moodyBuckets + geom_bar()

mktVal <- ggplot(AccountHoldings.df, aes(x = AsOfDate, y = MarketValue))
mktVal + geom_line

install.packages('e1071', dependencies = TRUE)
library(e1071)

NaiveBayes <- naiveBayes(AccountHoldings.df$Moodys, AccountHoldings.df$SecGroup)

# a priori probabilities for the target variables
NaiveBayes$apriori

# a priori probabilities for the input variables
NaiveBayes$tables

# predictions
predict(NaiveBayes, AccountHoldings.df, type = 'raw')

# data frame with predictions
predictions.df <- as.data.frame(predict(NaiveBayes, AccountHoldings.df, type = 'raw'))

predictions.joined <- cbind(AccountHoldings.df, predictions.df)

# 
# Load & Explore Data
#

# Set working directory
setwd("../Data")
getwd()
write.csv(predictions.joined, file = "JoinedPredictions.csv")

# read from data frame
BigFivByState.df <- read.table("BigFiveScoresByState.csv", header = TRUE, sep = ",")

# review data
head(BigFivByState.df)
nrow(BigFivByState.df)
summary(BigFivByState.df)
names(BigFivByState.df)

# varous aggregations
# as "count this value" ~ grouped by this + this
Liberal.dist <- aggregate(State ~ Liberal, data = BigFivByState.df, FUN = length)
head(Liberal.dist)

RedBlue.dist <- aggregate(State ~ Politics, data = BigFivByState.df, FUN = length)
head(RedBlue.dist)

# 
# plotting
#

# install ggplot
#install.packages('ggplot2')
library(ggplot2)

# simple count per group
Political.dist <- ggplot(BigFivByState.df, aes(Politics), FUN = length)
Political.dist + geom_bar()

# charts with trendlines
cor.test(BigFivByState.df$Conscientiousness, BigFivByState.df$Openness)
OpennessVersusConscientiousness <- ggplot(BigFivByState.df, aes(x = Conscientiousness, y = Openness), FUN = length, na.rm = TRUE)
OpennessVersusConscientiousness + geom_line(na.rm = TRUE) + geom_smooth(method = lm, na.rm = TRUE)

cor.test(BigFivByState.df$Neuroticism, BigFivByState.df$Openness)
OpennessVersusNeuroticism <- ggplot(BigFivByState.df, aes(x = Neuroticism, y = Openness), FUN = length, na.rm = TRUE)
OpennessVersusNeuroticism + geom_line(na.rm = TRUE) + geom_smooth(method = lm, na.rm = TRUE)

cor.test(BigFivByState.df$Extraversion, BigFivByState.df$Neuroticism)
ExtraversionVersusNeuroticism <- ggplot(BigFivByState.df, aes(x = Neuroticism, y = Extraversion), FUN = length, na.rm = TRUE)
ExtraversionVersusNeuroticism + geom_line(na.rm = TRUE) + geom_smooth(method = lm, na.rm = TRUE)

cor.test(BigFivByState.df$Extraversion, BigFivByState.df$Openness)
ExtraversionVersusOpenness <- ggplot(BigFivByState.df, aes(x = Openness, y = Extraversion), FUN = length, na.rm = TRUE)
ExtraversionVersusOpenness + geom_line(na.rm = TRUE) + geom_smooth(method = lm, na.rm = TRUE)


#
# Naive Bayes
#

#install.packages('e1071', dependencies = TRUE)
library(e1071)

# naive bayes
NaiveBayes <- naiveBayes(BigFivByState.df[, 2:11], BigFivByState.df$Politics)

# a priori probabilities for the target variables
NaiveBayes$apriori

# a priori probabilities for the input variables
NaiveBayes$tables

# data frame with predictions
predictions.df <- as.data.frame(predict(NaiveBayes, BigFivByState.df, type = 'raw'))


# 
# Validate Results
#

# join predictions with source
predictions.joined <- cbind(BigFivByState.df, predictions.df)

# validate predictions
predictions.joined$Predicted <- ifelse(predictions.joined$Blue >= .05, "Blue", "Red")
predictions.joined$Check <- ifelse(predictions.joined$Politics == predictions.joined$Predicted, "Correct", "Incorrect")

# calculate right and wrong
length(predictions.joined$Check[predictions.joined$Check== "Correct"]) / length(predictions.joined$Check)

# chart count of right and wrong 
ggplot(predictions.joined, aes(Check), FUN = length) + geom_bar()

# output
write.csv(predictions.joined, file = "JoinedPoliticaLPredictions.csv")
