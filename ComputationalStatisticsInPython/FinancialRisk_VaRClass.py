################################
#
# Creating a class for VaR
#
#################################


#################################
# Load and clean data
# - Load libraries
# - Clean data
#################################

# changing directory
import os

# data frames
import pandas as pd

import numpy as np


# Set working directory

os.chdir("../Data")
workingDirectory = os.getcwd()
workingDirectory

# Get data
portfoliosFilePath = workingDirectory + "/Portfolios.csv"
portfolios = pd.read_csv(portfoliosFilePath, sep=",")

# format date
portfolios['AsOfDate'] = pd.to_datetime(portfolios['AsOfDate'], format='%m/%d/%Y', yearfirst = True)

# sort by date
portfolios = portfolios.sort_values(['AsOfDate'] , ascending=True)


#################################
# 
# Create data sets to pass
# 
#################################

# calculate returns
returns = portfolios[[ key for key in dict(portfolios.dtypes) if dict(portfolios.dtypes)[key] in [ 'float64', 'int64']]].pct_change()
returns = returns[1:]

# add intercept column
returns['Intercept'] = 1

# create lists of names to easily filter returns
stockNames = list(returns)[0:10]
factorNames = list(returns)[10:13]

# set values for returns and weights
stockReturns = returns[stockNames]
factorReturns = returns[factorNames]
weights = np.array([1.0/len(stockNames)]*len(stockNames))

from RiskCalculator import RiskCalculator
test = RiskCalculator(stockReturns, factorReturns, weights, 0.99)

from RiskCalculator import VaRType
test.GetVaR(VaRType.Scenario, 0.99)
test.GetVaRRange(VaRType.Scenario, 0.90, 0.995, 0.01)
test.PlotVaRRange(VaRType.Scenario, 0.5, 0.995, 0.003)





