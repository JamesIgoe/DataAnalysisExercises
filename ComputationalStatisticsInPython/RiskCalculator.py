from  enum import Enum
class VaRType(Enum):
    Historical = 1
    Factor = 2
    Scenario = 3

class RiskCalculator(object):

    #################################
    # Class back-of-the-napkin
    # 
    # - Provide dataframe of stocks prices
    #
    # - Provide weights of stocks
    # -- Alt: Calculate weights
    #
    # - Provide dataframe of factor prices
    #
    # - Extracts stock names into data frame 
    # - Extract stock returns
    #
    # - Extracts factor names into data frame 
    # - Extract factor returns
    #
    # Historical
    # - Use weights and stock returns (no dates)
    #
    # Factor Model
    # - Use factors, stock names, returns
    # - create matrix of scenarios
    #
    # VaR
    # - for different risk types and confidence levels calculate VaR
    # - for different risk types and confidence levels calculate a range ofVaR
    # - for different risk types and confidence levels plot a range ofVaR
    #
    # To do
    # - dynamicqally build factor matrix
    # - Compare dates between stocks and factors
    # - Validate data
    # - Allow date range
    # - Auto-limit date range, with warning
    ###################################

    
    # Hiden Attributes
    __stockNames = []
    __factorNames = []
    __historicalRisk = 0
    __systemicVariance = 0
    __idiosyncraticVariance = 0
    __factorBasedVariance = 0
    __scenarioTotalVariance = 0
    __modelCoeffs = []

    
    #################################
    # Constructor
    #################################
    def __init__(self, stockReturns, factorReturns, weights):

        self.stockReturns = stockReturns
        self.factorReturns = factorReturns
        self.weights = weights
        
        
    #################################
    # Run interrnal code
    #################################
    def Run(self):
        RiskCalculator.__extractNames()
        RiskCalculator.__calculateHistoricalVariance()
        RiskCalculator.__buildFactorModel()
        RiskCalculator.__calculateFactorVariance()
        RiskCalculator.__calculateScenarioVariance()

        
    #################################
    # Extract names
    #################################
    def __extractNames():
        RiskCalculator.__stockNames = stockReturns.columns
        RiskCalculator.__factorNames = factorReturns.columns
    
    
    #################################
    # Estimating Historical Risk
    # cacluate portfolio variance
    # Var(p) = W * COV(Y) * W_transposed
    # matrix multiplication is done via np.dot
    # first is transpose of weights
    # second is the covariance of the returns
    # third is the matrix of weights
    #################################
    def __calculateHistoricalVariance():
        RiskCalculator.__historicalRisk = np.dot(np.dot(weights, stockReturns.cov()), weights.T)


    #################################
    # Building Factor Models
    # - Calculate lm (regression) for FVX, SP500, and the each stock
    #################################
    def __buildFactorModel():

        import statsmodels.api as sm

        # loops for each stock to create
        RiskCalculator.__modelCoeffs = []
        for stockName in RiskCalculator.__stockNames:
            stockReturn = returns[stockName]
            model = sm.OLS(stockReturn, factorReturns)
            result = model.fit()
            modelCoeffRow = list(result.params)
            modelCoeffRow.append(np.std(result.resid,ddof=1))
            RiskCalculator.__modelCoeffs.append(modelCoeffRow)
    
        # convert and cleanup data frame
        RiskCalculator.__modelCoeffs = pd.DataFrame(RiskCalculator.__modelCoeffs)
        RiskCalculator.__modelCoeffs.columns = ["B_FVX", "B_SP500",  "Alpha", "ResidualVol"]
        RiskCalculator.__modelCoeffs["Names"] = RiskCalculator.__stockNames

        
    #################################
    # Factor Analysis - Idiosyncratic and Systemic Risk
    # TotalVaR(P) = SystemicVaR(P) + IdisyncraticVaR(P)
    # SystemicVaR(P) = weights * betas * Cov(Factors) * betas_transposed * weights_transposed
    # idosyncraticVariance(P) = weights * var(residuals) * weight_transposed
    # totalVariance = systemicVariance + idiosyncraticVariance
    #################################
    def __calculateFactorVariance():

        # inner terms
        factorCovariance = factorReturns[["SP500","FVX"]].cov()
        reconstructedCov = np.dot(np.dot(RiskCalculator.__modelCoeffs[["B_SP500", "B_FVX"]],factorCovariance),RiskCalculator.__modelCoeffs[["B_SP500", "B_FVX"]].T)
        # include outer terms
        RiskCalculator.__systemicVariance = np.dot(np.dot(weights, reconstructedCov), weights.T)

        RiskCalculator.__idiosyncraticVariance = sum(weights * RiskCalculator.__modelCoeffs["ResidualVol"] * weights * RiskCalculator.__modelCoeffs["ResidualVol"])

        RiskCalculator.__factorBasedVariance =  RiskCalculator.__systemicVariance +  RiskCalculator.__idiosyncraticVariance

        
    #################################
    # Scenario-based Stress Testing
    # create a range of scenarios, stepping from min to max for factors, FVX and S&P500
    # build scenarios from fvxScenarios by sp500Scenarios
    # set column names
    # totalVariance(P) = weights * cov(scenarios) * weight_transposed
    #################################
    def __calculateScenarioVariance():

        fvxScenarios = np.arange(min(returns["FVX"]), max(returns["FVX"]), .05)
        sp500Scenarios = np.arange(min(returns["SP500"]), max(returns["SP500"]), .02)

        scenarios = []
        for fvxValue in fvxScenarios:
            for sp500value in sp500Scenarios:
                scenario = [fvxValue, sp500value]
                for stockName in RiskCalculator.__stockNames:
                    alpha = float( RiskCalculator.__modelCoeffs[ RiskCalculator.__modelCoeffs["Names"] == stockName]["Alpha"])
                    beta_sp = float( RiskCalculator.__modelCoeffs[ RiskCalculator.__modelCoeffs["Names"] == stockName]["B_SP500"])
                    beta_fvx = float( RiskCalculator.__modelCoeffs[ RiskCalculator.__modelCoeffs["Names"] == stockName]["B_FVX"])
                    scenarioPredictedReturn = alpha + (beta_sp * sp500value) + (beta_fvx * fvxValue)
                    scenario.append(scenarioPredictedReturn)
                scenarios.append(scenario)

        scenarios = pd.DataFrame(scenarios)

        scenarios.columns = ["FVX","SP500","AAPL","ADBE","CVX","GOOG","IBM","MDLZ","MSFT","NFLX","ORCL","SBUX"]

        scenariosCov = scenarios[RiskCalculator.__stockNames].cov()
        RiskCalculator.__scenarioTotalVariance = np.dot(np.dot(weights, scenariosCov), weights.T)


    #################################
    # Simple VaR calculator
    # VaR = P x Z_alpha x stdDev
    #################################
    def __calculateVaR(risk, percentile, principal = 1, numMonths = 1):

        import math
        import scipy.stats as st

        vol = math.sqrt(risk)
        return abs(principal * st.norm.ppf(1-percentile, 0, 1) * vol * math.sqrt(numMonths))
    
    
    #################################
    # Returns the instance value of the risk type
    #################################
    def __getRiskByType(varType):
                
        if varType == VaRType.Historical:
            varianceType = RiskCalculator.__historicalRisk
        elif varType == VaRType.Factor:
            varianceType = RiskCalculator.__factorBasedVariance
        elif varType == VaRType.Scenario:
            varianceType = RiskCalculator.__scenarioTotalVariance

        return varianceType
        
        
    #################################
    # Exposed calculator
    #################################
    def GetVaR(self, varType = VaRType.Historical, percentile = 0.99):

        # Type checking
        if not isinstance(varType, VaRType):
            raise TypeError('vaRType must be an instance of VaRType Enum')
        
        varianceType = RiskCalculator.__getRiskByType(varType)

        return RiskCalculator.__calculateVaR(varianceType, percentile)
        
        
    #################################
    # Exposed range calcualtor
    #################################
    def GetVaRRange(self, varType = VaRType.Historical, minPercentile = 0.90, maxPercentile = 0.995, step = 0.01):

        return RiskCalculator.__getVaRRange(varType, minPercentile, maxPercentile, step)
        

    #################################
    # Exposed range calcualtor
    #################################
    def __getVaRRange(varType = VaRType.Historical, minPercentile = 0.90, maxPercentile = 0.995, step = 0.01):

        # Type checking
        if not isinstance(varType, VaRType):
            raise TypeError('varType must be an instance of VaRType Enum')
        
        varianceType = RiskCalculator.__getRiskByType(varType)

        import numpy as np
        stepValues = np.arange(minPercentile, maxPercentile, step) 
        
        # loops for each stock to create
        riskArray = []
        for stepValue in range(0, len(stepValues), 1):
            percentile = stepValues[stepValue]
            riskVal = RiskCalculator.__calculateVaR(varianceType, percentile)
            riskRow = [percentile, riskVal]
            riskArray.append(riskRow)
            
        import pandas as pd
        riskArray = pd.DataFrame(riskArray)
        riskArray.columns = ["Confidence","VaR"]

        return riskArray

    
    #################################
    # Exposed range calcualtor
    #################################
    def PlotVaRRange(self, varType = VaRType.Historical, minPercentile = 0.90, maxPercentile = 0.995, step = 0.01):

        varArray = RiskCalculator.__getVaRRange(varType, minPercentile, maxPercentile, step)

        import matplotlib.pyplot as plt
        plt.plot(varArray["Confidence"],varArray["VaR"])
        plt.show()
