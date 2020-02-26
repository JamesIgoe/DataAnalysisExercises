################################
#
# Understanding and Applying Factor Analysis and PCA
# https://app.pluralsight.com/library/courses/understanding-applying-factor-analysis-pca/table-of-contents
#
#################################


#################################
# Load Data: Format Data & Sort
#################################

# set WD
getwd()
#setwd("../../Data")
#getwd()

# load data
filePath <- "Portfolios.csv"
portfolios.dirty <- read.table(filePath, header = TRUE, sep = ",", stringsAsFactors = FALSE)

# convert: http://www.statmethods.net/input/dates.html
portfolios.dirty[, c("AsOfDate")] <- as.Date(portfolios.dirty[, c("AsOfDate")], "%m/%d/%Y")

# sort: # http://www.statmethods.net/management/sorting.html
portfolios.sorted <- portfolios.dirty[order(portfolios.dirty$AsOfDate, decreasing = FALSE),]
head(portfolios.sorted)


#################################
# Prep Data: Create Returns
#################################

# new data, preserving original
returns <- portfolios.sorted

# calculate returns
returns[-nrow(returns), -1] <- returns[-nrow(returns), -1] / returns[-1, -1] - 1

# removes last row, since it is not a valid return value
returns <- returns[-nrow(returns),]

# create a data frame of stock names, not the date and not the factors
stockNames = names(returns)[-which(names(returns) %in% c('AsOfDate'))]

# create a data frame of only stocks
stockReturns <- returns[stockNames]
head(stockReturns)


#################################
#
# Generate Principal Components
#
#################################

#################################
# Eigen Decomposition and Scree Plot
#################################

stockReturns.scaled = scale(stockReturns)

stockReturns.cov <- cov(stockReturns.scaled)

stockReturns.eigen <- eigen(stockReturns.cov)

eigenValues <- stockReturns.eigen$values
eigenVectors <- stockReturns.eigen$vectors

# scree plot
plot(eigenValues, type = "b")


#################################
# Create Principal Components
#################################

# check on correctness
#eigenVetors %*% t(eigenVetors)

# create principal component analysis
pcaOne <- as.matrix(stockReturns.scaled) %*% eigenVectors[, 1]
pcaTwo <- as.matrix(stockReturns.scaled) %*% eigenVectors[, 2]
pcaThree <- as.matrix(stockReturns.scaled) %*% eigenVectors[, 3]

pca <- data.frame(pcaOne, pcaTwo, pcaThree)

# examine result
head(pca)
tail(pca)


#################################
#
# Analysis
#
#################################

#################################
# FVX using PCA
#################################

pcaFVX <- lm(stockReturns$FVX ~ pcaOne + pcaTwo + pcaThree)
summary(pcaFVX)


#################################
# FVX using Logisitic Regression
#################################

pcaCompare <- lm(FVX ~ SP500 + GOOG + AAPL + ADBE + CVX + IBM + MDLZ + MSFT + NFLX + ORCL + SBUX, data = stockReturns)
summary(pcaCompare)


#################################
#
# Alternative Libraries:Psych for
#   the Social Sciences # Analysis
#
#################################

.
install.packages('psych')
library(psych)
principal(stockReturns.cov, nfactors = 3, rotate = "none")


#################################
# Factor analysis on Hofstede
#################################

#setwd("..../Data")
getwd()

# load data
Hofstede.df.preclean <- read.csv("OECD - Quality of Life - No NULLs.csv", na.strings = c("", "NA"))
nrow(Hofstede.df.preclean)
#View(Hofstede.df.preclean)

# remove NULLs
Hofstede.df.preclean <- na.omit(Hofstede.df.preclean)
nrow(Hofstede.df.preclean)

Hofstede.df <- Hofstede.df.preclean

ncol(Hofstede.df)
HofstedePaterrns.scaled = scale(Hofstede.df[2:27])

HofstedePaterrns.cov <- cov(HofstedePaterrns.scaled)

HofstedePaterrns.eigen <- eigen(HofstedePaterrns.cov)

hofstedeEigenValues <- HofstedePaterrns.eigen$values
hofstedeEigenVectors <- HofstedePaterrns.eigen$vectors

# scree plot
plot(hofstedeEigenValues, type = "b")

hofstedPcaOne <- as.matrix(HofstedePaterrns.scaled) %*% hofstedeEigenVectors[, 1]
hofstedPcaTwo <- as.matrix(HofstedePaterrns.scaled) %*% hofstedeEigenVectors[, 2]
hofstedPcaThree <- as.matrix(HofstedePaterrns.scaled) %*% hofstedeEigenVectors[, 3]

hofstedPca <- data.frame(hofstedPcaOne, hofstedPcaTwo, hofstedPcaThree)

# examine result
head(hofstedPca)
tail(hofstedPca)

# examine result
cor(hofstedPca)

pcaIQ <- lm(Hofstede.df$IQ ~ hofstedPcaOne + hofstedPcaTwo + hofstedPcaThree)
summary(pcaIQ)

pcaPISAMath <- lm(Hofstede.df$PISAMath ~ hofstedPcaOne + hofstedPcaTwo + hofstedPcaThree)
summary(pcaPISAMath)

install.packages('psych')
library(psych)
principal(HofstedePaterrns.cov, nfactors = 7, rotate = "none")



# load data
BigFive.df.preclean <- read.csv("BigFiveScoresByState_Trimmed.csv", na.strings = c("", "NA"))
nrow(BigFive.df.preclean)
#View(BigFive.df.preclean)

# remove NULLs
BigFive.df.preclean <- na.omit(BigFive.df.preclean)
nrow(BigFive.df.preclean)

BigFive.df <- BigFive.df.preclean

ncol(BigFive.df)
BigFivePaterrns.scaled = scale(BigFive.df[2:6])

BigFivePaterrns.cov <- cov(BigFivePaterrns.scaled)

BigFivePaterrns.eigen <- eigen(BigFivePaterrns.cov)

BigFiveEigenValues <- BigFivePaterrns.eigen$values
BigFiveEigenVectors <- BigFivePaterrns.eigen$vectors

# scree plot
plot(BigFiveEigenValues, type = "b")

BigFivePcaOne <- as.matrix(BigFivePaterrns.scaled) %*% BigFiveEigenVectors[, 1]
BigFivePcaTwo <- as.matrix(BigFivePaterrns.scaled) %*% BigFiveEigenVectors[, 2]
BigFivePcaThree <- as.matrix(BigFivePaterrns.scaled) %*% BigFiveEigenVectors[, 3]

BigFivePca <- data.frame(BigFivePcaOne, BigFivePcaTwo, BigFivePcaThree)

# examine result
head(BigFivePca)
tail(BigFivePca)

# examine result
cor(BigFivePca)

pcaLiberal <- lm(BigFive.df$Liberal ~ BigFivePcaOne + BigFivePcaTwo + BigFivePcaThree)
summary(pcaLiberal)

pcaLiberalAlt <- glm(BigFive.df$Liberal ~ BigFive.df$Conscientiousness + BigFive.df$Openness)
summary(pcaLiberalAlt)

install.packages('psych')
library(psych)
principal(BigFivePaterrns.cov, nfactors = 5, rotate = "none")
