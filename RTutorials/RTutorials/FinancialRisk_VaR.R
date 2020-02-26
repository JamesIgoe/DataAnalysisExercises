################################
#
# Understanding and Applying Financial Risk Modeling Techniques
# https://app.pluralsight.com/library/courses/financial-risk-modeling-techniques/table-of-contents
# Implementing Financial Risk Models in R
#
#################################


#################################
# Load and clean data
#################################

# set WD
getwd()
#setwd("../Data")
#getwd()

# load data
filePath <- "Portfolios.csv"
portfolios.dirty <- read.table(filePath, header = TRUE, sep = ",", stringsAsFactors = FALSE)

# convert: http://www.statmethods.net/input/dates.html
portfolios.dirty[, c("AsOfDate")] <- as.Date(portfolios.dirty[, c("AsOfDate")], "%m/%d/%Y")

# sort: # http://www.statmethods.net/management/sorting.html
portfolios.sorted <- portfolios.dirty[order(portfolios.dirty$AsOfDate, decreasing = FALSE),]
head(portfolios.sorted)

# remove nulls
# NA in this module



#################################
# Estimating Historical Risk
#################################

# new data, preserving original
returns <- portfolios.sorted

# calculate returns
returns[-nrow(returns), -1] <- returns[-nrow(returns), -1] / returns[-1, -1] - 1
head(returns)

# removes last row, since it is not a valid return value
tail(returns)
returns <- returns[-nrow(returns),]
tail(returns)

# create a data frame of stock names, not the date and not the factors
stockNames = names(returns)[-which(names(returns) %in% c('AsOfDate', 'FVX', 'SP500'))]

# create a data frame of only stocks
stockReturns <- returns[stockNames]

# create a data frame of weights, but make it equal weighted
# it is hterfore 1 for each item, divided by the number of names
# in effect, 1 divided by 10
(weights <- data.frame(rep(1, times = length(stockNames)) / length(stockNames)))

# rename the row names, then rename the column header
row.names(weights) <- stockNames
names(weights) <- "Weights"

# cacluate portfolio variance
# Var(p) = W * COV(Y) * W_transposed
# matrix multiplication is done via %*%
# first is transpose of weights
# second is the covariance of the returns
# third is the matrix of weights
(historicalReturnRisk <- t(weights) %*% cov(stockReturns) %*% as.matrix(weights))



#################################
# Building Factor Models
#################################

# calculate lm (regression) for FVX, SP500, and the stock value


# loops for each stock to create
# create data frame
modelCoeffs <- data.frame()
for (stockName in stockNames) {
    stockReturn <- as.matrix(returns[stockName])
    sp500 <- as.matrix(returns["SP500"])
    fvx <- as.matrix(returns["FVX"])
    model <- lm(stockReturn ~ sp500 + fvx)
    modelCoeffs <- rbind(modelCoeffs, cbind(coef(model)[1], coef(model)[2], coef(model)[3], sd(resid(model))))
}

# cleanup data frame
row.names(modelCoeffs) <- stockNames
names(modelCoeffs) <- c("Alpha","B_SP500","B_FVX","ResidualVol")
modelCoeffs



#################################
# Idiosyncratic and Systemi Risk
#################################

# systemic risk
# systemicVariance(P) = weights * betas * covariance(factor returns) * betas_transposed * weight_transposed

# create matrix of factors
factorNames <- c("SP500","FVX")
factorReturns <- returns[factorNames]

# guess
#systemicVariance <- t(weights) %*% as.matrix(weights) %*% cov(factorReturns) %*% t(modelCoeffs) %*% as.matrix(modelCoeffs)

# actual
# internal covariance matrix
(reconstructedCov <- as.matrix(modelCoeffs[c("B_SP500", "B_FVX")]) %*% as.matrix(cov(factorReturns)) %*% t(modelCoeffs[c("B_SP500", "B_FVX")]))
# external covariance matrix
(systemicVariance <- t(weights) %*% reconstructedCov %*% as.matrix(weights))


# idosyncratic risk
# idosyncraticVariance(P) = weights * var(residuals) * weight_transposed
(idosyncraticVariance <- sum((weights ^ 2) * (modelCoeffs$ResidualVol ^ 2)))

(totalvariance = systemicVariance + idosyncraticVariance)



#################################
# Scenario-based Stress Testing
#################################

# currentPrices <- subset(portfolios.sorted, AsOfDate == max(portfolios.sorted$AsOfDate))
(currentPrices <- portfolios.sorted[1,])

# going to use min and max of this to create scenarios
(summary(returns[factorNames]))

(fvxScenarios <- seq(min(returns["FVX"]), max(returns["FVX"]), by = .05))
(sp500Scenarios <- seq(min(returns["SP500"]), max(returns["SP500"]), by = .02))

# build scenarios from fvxScenarios by sp500Scenarios
scenarios <- data.frame()
for (fvxValue in fvxScenarios) {
    for (sp500value in sp500Scenarios) {
        scenario <- cbind(fvxValue, sp500value)
        scenarioPredictedReturns <- data.frame()
        for (stockName in stockNames) {
            alpha = subset(modelCoeffs, row.names(modelCoeffs) %in% c(stockName)) ["Alpha"]
            beta_sp = subset(modelCoeffs, row.names(modelCoeffs) %in% c(stockName))["B_SP500"]
            beta_fvx = subset(modelCoeffs, row.names(modelCoeffs) %in% c(stockName))["B_FVX"]
            scenarioPredictedReturn = alpha + (beta_sp * sp500value) + (beta_fvx * fvxValue)
            scenarioPredictedReturns = rbind(scenarioPredictedReturns, scenarioPredictedReturn)
        }
        scenario <- (cbind(scenario, t(scenarioPredictedReturns)))
        scenarios <- rbind(scenarios, scenario)
    }
}
head(scenarios)


# totalVariance(P) = weights * cov(scenarios) * weight_transposed
(scenarioTotalVariance <- t(weights) %*% cov(as.matrix(scenarios[stockNames]))  %*% as.matrix(weights))



#################################
# Quantifying the Worst Case
#################################

# VaR = P x Z_alpha x stdDev
calculateVaR <- function(risk, confidenceLevel, principal = 1, numMonths = 1) {
    vol <- sqrt(risk)
    data.frame(VaR = abs(principal * qnorm(1-confidenceLevel, 0, 1) * vol * sqrt(numMonths))[1])
}

calculateVaR(scenarioTotalVariance, 0.99)

calculateVaR(historicalReturnRisk, 0.99)

calculateVaR(totalvariance, 0.99)


#################################
# Plotting Var
#################################

library(PerformanceAnalytics)

returnsForChart <- returns

row.names(returnsForChart) <- c(returnsForChart$AsOfDate)

chart.VaRSensitivity(returnsForChart[, 2:11, drop=TRUE],
		methods=c("HistoricalVaR", "ModifiedVaR", "GaussianVaR"),
        colorset = bluefocus,
        lwd=2)

chart.RelativePerformance(returnsForChart[, 2:11],
    returnsForChart[, 13],
    main = "Relative Performace vs. Benchmark",
    colorset = c(1:8),
    xaxis = TRUE,
    ylog = FALSE,
    legend.loc = "topright",
    cex.legend = 0.8)










