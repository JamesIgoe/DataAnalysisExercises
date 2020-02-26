
#################################
# Import modules
#################################

# string matching
from fuzzywuzzy import fuzz

# changing directory
import os

# data frames
import pandas as pd


#################################
# Set working directoy
#################################

# Set working directory
os.chdir("../Data")
workingDirectory = os.getcwd()
workingDirectory


#################################
# Get Data
#################################

# FROM dbo.vw_BRSIssuers WHERE ISSUER_ID <> '(null)'
issuersFilePath = workingDirectory + "/vw_BRSIssuers.csv"
issuers = pd.read_csv(issuersFilePath, sep=",")
#issuers.head()

# FROM dbo.vw_CurrentCompanyData
companiesFilePath = workingDirectory + "/vw_CurrentCompanyData.csv"
companies = pd.read_csv(companiesFilePath, sep=",", encoding = "ISO-8859-1")
#companies.head()


#################################
# Process:
# set fuzzy threshold
# iterate companies
# compare against all issuers
# if >= threshold write row
#################################

resultListColumns = ['CompanyID', 'AnalystID', 'LastName', 'FirstName', 'Company Name', 'ID', 'ISSUER_ID', 'NAME', 'LONG_NAME', 'MatchID', 'MatchQuality', 'StateID', 'State', 'Fuzzy']
resultList = []

fuzzyThreshold = 80
companyCounterMax = range(0, len(companies)-1)
issuerCounterMax = range(0, len(issuers)-1)
for companyCounter in companyCounterMax:
    companyCounter
    for issueCounter in issuerCounterMax:
        temp = fuzz.token_sort_ratio(companies['CoShtName'].iloc[companyCounter], issuers['LONG_NAME'].iloc[issueCounter])
        if (temp >= fuzzyThreshold):
            resultList.append([companies['CompanyID'].iloc[companyCounter]
                              ,companies['AnalystID'].iloc[companyCounter]
                              ,''
                              ,''
                              ,companies['CoShtName'].iloc[companyCounter]
                              ,0
                              ,issuers['ISSUER_ID'].iloc[issueCounter]
                              ,issuers['NAME'].iloc[issueCounter]
                              ,issuers['LONG_NAME'].iloc[issueCounter]
                              ,0
                              ,temp
                              ,0
                              ,''
                              ,temp])


#################################
# cleanup data
# remove issuers used twice, using highest match
#################################




            
#################################
# Convert list to data frame
#################################

result = pd.DataFrame(resultList, columns=resultListColumns)


#################################
# Output to file
#################################

resultOutputPath = workingDirectory + "/CompanyIssuerMap_Result.csv"
result.to_csv(resultOutputPath, sep=',')






