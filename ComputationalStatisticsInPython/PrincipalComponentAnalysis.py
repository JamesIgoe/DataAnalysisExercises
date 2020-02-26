#################################
# Load and clean data
# - Load libraries
# - Clean data
#################################

# changing directory
import os

# data frames
import pandas as pd

# linear algebra
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
# Perform PCA
#################################


# select only numeric values and calculate returns
returns = portfolios[[ key for key in dict(portfolios.dtypes) if dict(portfolios.dtypes)[key] in [ 'float64', 'int64']]].pct_change()

# exclude the first row, chich is NaN
returns = returns[1:]

# scale returns
returnsScaled = ( returns - returns.mean() ) / (returns.std())

# correct covariance matrix
returnsCovarMatrix = returnsScaled.cov()

# correct correlation matrix
returnsCorrMatrix = returnsScaled.corr()

# use scaled returns in eigen decomposition
eigenValue, eigenVector = np.linalg.eig(returnsCovarMatrix)

# should equal the number of vectors
sum(eigenValue)

# verify
eigenPairs = [(np.abs(eigenValue[i]), eigenVector[:i]) for i in range(len(eigenValue))]
eigenPairs.sort(key=lambda x: x[0], reverse=True)
for i in eigenPairs: print(i[0])

eigenVectorOne = eigenPairs[0][1]
eigenVectorTwo = eigenPairs[1][1]
eigenVectorThree = eigenPairs[2][1]

# create principal componenet vectors
np.dot(returnsScaled, eigenVectorOne.reshape(-1,1))  .reshape(1,-1)



