# Tutorial
"""https://app.pluralsight.com/player?course=understanding-applying-logistic-regression&author=vitthal-srinivasan&name=understanding-applying-logistic-regression-m5&clip=0&mode=live"""

import pandas as pd
import numpy as np
import os

# assumes directory
os.chdir('..\Data')
cwd = os.getcwd()
cwd

goog =  pd.read_csv("GOOG.csv")
spy =  pd.read_csv("SPY.csv")

import statsmodels.api as sm




