# Data Mining Algorithms in SSAS, Excel, and R
# https://app.pluralsight.com/player?course=data-mining-algorithms-ssas-excel-r&author=dejan-sarka&name=data-mining-algorithms-ssas-excel-r-m2&clip=12&mode=live

# Clear memory
rm(list = ls())

# 
# Load Data
#

# Set working directory
setwd("../Data")
getwd()

# read from data frame
BigFivByState.df <- read.table("BigFiveScoresByState.csv", header = TRUE, sep = ",")

# 
# Run Analysis
#

# Load package, 
install.packages('party', dependencies = TRUE)
library(party)

# train the model
BigFivByState.dt <- ctree(data = BigFivByState.df, Liberal ~ Openness + Conscientiousness + Extraversion + Neuroticism + Agreeableness)

# plot result
plot(BigFivByState.dt, uniform = TRUE, main = "Classification Tree for Politics on Big Five")



