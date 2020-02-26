################################
#
# Understanding and Applying Financial Risk Modeling Techniques
# https://app.pluralsight.com/library/courses/financial-risk-modeling-techniques/table-of-contents
# Implementing Financial Risk Models in R
#
#################################


#################################
# Load libraries
#################################

# changing directory
import os

# data frames
import pandas as pd

# statistcial work
import numpy as np

# for factor models
import statsmodels.api as sm


#################################
# Load and clean data
#################################

# Set working directory
os.chdir("../Data")
workingDirectory = os.getcwd()
workingDirectory

# Get data
portfoliosFilePath = workingDirectory + "/Portfolios.csv"
portfolios = pd.read_csv(portfoliosFilePath, sep=",")
portfolios.head()

# format date
portfolios['AsOfDate'] = pd.to_datetime(portfolios['AsOfDate'], format='%m/%d/%Y', yearfirst = True)
portfolios.head()

# sort by date
portfolios = portfolios.sort_values(['AsOfDate'] , ascending=True)
portfolios.head()


#################################
# Estimating Historical Risk
#################################

# calculate returns
returns = portfolios[[ key for key in dict(portfolios.dtypes) if dict(portfolios.dtypes)[key] in [ 'float64', 'int64']]].pct_change()
returns = returns[1:]
returns.head()

# add intercept column
returns['Intercept'] = 1
returns.head()

# create lists of names to easily filter returns
stockNames = list(returns)[0:10]
factorNames = list(returns)[10:13]

# set values for returns and weights
stockReturns = returns[stockNames]
factorReturns = returns[factorNames]
weights = np.array([1.0/len(stockNames)]*len(stockNames))


# cacluate portfolio variance
# Var(p) = W * COV(Y) * W_transposed
# matrix multiplication is done via np.dot
# first is transpose of weights
# second is the covariance of the returns
# third is the matrix of weights
historicalRisk = np.dot(np.dot(weights, stockReturns.cov()), weights.T)



#################################
# Building Factor Models
#################################

# calculate lm (regression) for FVX, SP500, and the stock value

# make set to use
factorData = factorReturns
factorData.head()

# loops for each stock to create
modelCoeffs =[]
for stockName in stockNames:
    stockReturn = returns[stockName]
    model = sm.OLS(stockReturn, factorData)
    result = model.fit()
    modelCoeffRow = list(result.params)
    modelCoeffRow.append(np.std(result.resid,ddof=1))
    modelCoeffs.append(modelCoeffRow)
    #print(result.summary())
    
# convert and cleanup data frame
modelCoeffs = pd.DataFrame(modelCoeffs)
modelCoeffs.columns = ["B_FVX", "B_SP500",  "Alpha", "ResidualVol"]
modelCoeffs["Names"] = stockNames
modelCoeffs


#################################
# Factor Analysis - Idiosyncratic and Systemic Risk
#################################

# TotalVaR(P) = SystemicVaR(P) + IdisyncraticVaR(P)

# SystemicVaR(P) = weights * betas * Cov(Factors) * betas_transposed * weights_transposed
# inner terms
factorCovariance = factorReturns[["SP500","FVX"]].cov()
reconstructedCov = np.dot(np.dot(modelCoeffs[["B_SP500", "B_FVX"]],factorCovariance),modelCoeffs[["B_SP500", "B_FVX"]].T)

# include outer terms
systemicVariance = np.dot(np.dot(weights, reconstructedCov), weights.T)

# idosyncraticVariance(P) = weights * var(residuals) * weight_transposed
idiosyncraticVariance = sum(weights * modelCoeffs["ResidualVol"] * weights * modelCoeffs["ResidualVol"])

# totalVariance = systemicVariance + idiosyncraticVariance
factorBasedVariance = systemicVariance + idiosyncraticVariance


#################################
# Scenario-based Stress Testing
#################################

# create a range of scenarios, stepping from min to max for factors, FVX and S&P500
fvxScenarios = np.arange(min(returns["FVX"]), max(returns["FVX"]), .05)
sp500Scenarios = np.arange(min(returns["SP500"]), max(returns["SP500"]), .02)

# build scenarios from fvxScenarios by sp500Scenarios
scenarios = []
for fvxValue in fvxScenarios:
    for sp500value in sp500Scenarios:
        scenario = [fvxValue, sp500value]
        for stockName in stockNames:
            alpha = float(modelCoeffs[modelCoeffs["Names"] == stockName]["Alpha"])
            beta_sp = float(modelCoeffs[modelCoeffs["Names"] == stockName]["B_SP500"])
            beta_fvx = float(modelCoeffs[modelCoeffs["Names"] == stockName]["B_FVX"])
            scenarioPredictedReturn = alpha + (beta_sp * sp500value) + (beta_fvx * fvxValue)
            scenario.append(scenarioPredictedReturn)
        scenarios.append(scenario)

scenarios = pd.DataFrame(scenarios)

# set column names
scenarios.columns = ["FVX","SP500","AAPL","ADBE","CVX","GOOG","IBM","MDLZ","MSFT","NFLX","ORCL","SBUX"]
scenarios.head()

# totalVariance(P) = weights * cov(scenarios) * weight_transposed
scenariosCov = scenarios[stockNames].cov()
scenarioTotalVariance = np.dot(np.dot(weights, scenariosCov), weights.T)
scenarioTotalVariance


#################################
# Quantifying the Worst Case
#################################

# VaR = P x Z_alpha x stdDev
def calculateVaR(risk, confidenceLevel, principal = 1, numMonths = 1):
    vol = math.sqrt(risk)
    return abs(principal * norm.ppf(1-confidenceLevel, 0, 1) * vol * math.sqrt(numMonths))

# Worst Case: VaR based on scenario-based stress testing
calculateVaR(scenarioTotalVariance, 0.99)

# Allternaitve Risk Measure:  VaR based on factors
calculateVaR(factorBasedVariance, 0.99)

# Allternaitve Risk Measure:  VaR based on history
calculateVaR(historicalRisk, 0.99)

























