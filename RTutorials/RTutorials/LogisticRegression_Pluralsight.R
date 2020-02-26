
# Clear memory
rm(list = ls())

# Set working directory
setwd("../Data")
getwd()

#load data
GOOG.data <- read.csv("GOOG.csv", header = TRUE, sep = ",")[, c("Date","Adj.Close")]
SPY.data <- read.csv("SPY.csv", header = TRUE, sep = ",")[, c("Date", "Adj.Close")]

print(names(GOOG.data))
print(names(SPY.data))

head(GOOG.data)
head(SPY.data)


# merge sources
GOOG.merged <- merge(GOOG.data, SPY.data, by = "Date")
head(GOOG.merged)

# change colum nheading
names(GOOG.merged)[2] <- "GOOG.Close"
head(GOOG.merged)

# change columnheading
names(GOOG.merged)[3] <- "SPY.Close"
head(GOOG.merged)

# cast as date
GOOG.merged$Date <- as.Date(GOOG.merged$Date)
head(GOOG.merged)
typeof(GOOG.merged$Date)

# sort descending
GOOG.merged <- GOOG.merged[order(GOOG.merged$Date, decreasing = TRUE),]
head(GOOG.merged)

# calculate returns fron previous row
GOOG.returns <- GOOG.merged
GOOG.returns[ - nrow(GOOG.merged), -1] <- GOOG.merged[ - nrow(GOOG.merged), -1]/GOOG.merged[-1,-1]-1

# change column heading
names(GOOG.returns)[2] <- "GOOG.Returns"
names(GOOG.returns)[3] <- "SPY.Returns"
head(GOOG.returns)

# removes last row
GOOG.returns <- GOOG.returns[ - nrow(GOOG.returns),]
tail(GOOG.returns)

# correlation of prices
(corr.Prices <- cor.test(GOOG.merged$GOOG.Close, GOOG.merged$SPY.Close))

# correlation of returns
(corr.Return <- cor.test(GOOG.returns$GOOG.Returns, GOOG.returns$SPY.Returns))

# create combines 
GOOG.lagging <- data.frame(GOOG.returns[ - nrow(GOOG.returns),], GOOG.returns[-1, -1])
head(GOOG.lagging)
tail(GOOG.lagging)

# rename lagged columns
names(GOOG.lagging)[4:5] <- c("GOOG.Returns.Lagged","SPY.Returns.Lagged")
head(GOOG.lagging)

# create column for logitic regression
GOOG.lagging$Up = GOOG.lagging$GOOG.Returns >= 0
head(GOOG.lagging)

# perform logistic regresssion
GOOG.logRegression <- glm(GOOG.lagging$Up ~ GOOG.lagging$GOOG.Returns.Lagged + GOOG.lagging$SPY.Returns.Lagged, fam = binomial)
summary(GOOG.logRegression)

# create frame of actual versus predicted
GOOG.fitted <- data.frame(GOOG.lagging$Up, fitted(GOOG.logRegression) >= 0.5)
names(GOOG.fitted) <- c("Actual","Predicted")
head(GOOG.fitted)

# create column for correct/incorrect prediction
GOOG.fitted$CorrectForecast = GOOG.fitted$Actual == GOOG.fitted$Predicted

# find percent correct
length(GOOG.fitted$CorrectForecast[GOOG.fitted$CorrectForecast == TRUE]) / length(GOOG.fitted$CorrectForecast)



