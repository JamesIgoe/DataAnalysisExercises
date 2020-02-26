# Clear memory
rm(list = ls())

source("http://www.bioconductor.org/biocLite.R")
class(biocLite)

biocLite("limma")
n

library(limma)

# Set working directory
setwd("../Data")
# setwd("H:/Personal/Code/TFS2013/RTutorials/TutorialsPoint/Data")
getwd()

#load data
mappingData <- read.table("Sources and Database Overlaps As Of 2016-6-24.csv", header = TRUE, sep = ",")

attach(mappingData)

Blackrock <- (mappingData$Blackrock > 0)
Bony_CEF <- (mappingData$Bony_CEF > 0)
BoNY_ETF <- (mappingData$BoNY_ETF > 0)
Confluence <- (mappingData$Confluence > 0)
CRD <- (mappingData$CRD > 0)
ePAM <- (mappingData$ePAM > 0)
EquityData <- (mappingData$EquityData > 0)
FundAccounting <- (mappingData$FundAccounting > 0)
GS <- (mappingData$GS > 0)
Internal_BRS <- (mappingData$Internal_BRS > 0)
Internal_ePAM <- (mappingData$Internal_ePAM > 0)
Internal_WSO <- (mappingData$Internal_WSO > 0)
InvestOne <- (mappingData$InvestOne > 0)
PowerAgent <- (mappingData$PowerAgent > 0)
Ryport <- (mappingData$Ryport > 0)
RyportMaster <- (mappingData$RyportMaster > 0)
UIT <- (mappingData$UIT > 0)
VendorCRD <- (mappingData$VendorCRD > 0)
WSO <- (mappingData$WSO > 0)

combinedCounts <- cbind(Blackrock, Bony_CEF, BoNY_ETF, Confluence, CRD, ePAM, EquityData, FundAccounting, GS, Internal_BRS, Internal_ePAM, Internal_WSO, InvestOne, PowerAgent, Ryport, RyportMaster, UIT, VendorCRD, WSO)
combinedCounts <- cbind(Blackrock, Internal_BRS, Internal_ePAM, Internal_WSO, WSO)
combinedCounts <- cbind(Blackrock, Bony_CEF, BoNY_ETF, Confluence, CRD)
combinedCounts <- cbind(Blackrock, BoNY_ETF)
combinedCounts <- cbind(Blackrock, BoNY_ETF, ePAM, WSO)
combinedCounts <- cbind(ePAM, WSO)
combinedCounts <- cbind(VendorCRD, InvestOne, ePAM, Blackrock)
combinedCounts <- cbind(BoNY_ETF, ePAM)
combinedCounts <- cbind(ePAM, WSO, Blackrock)
combinedCounts <- cbind(ePAM, WSO, Blackrock)
combinedCounts <- cbind(BoNY_ETF, ePAM, WSO, Blackrock)
combinedCounts <- cbind(Blackrock, WSO)
combinedCounts <- cbind(InvestOne, VendorCRD)
combinedCounts <- cbind(ePAM, VendorCRD, Blackrock)
combinedCounts <- cbind(ePAM, VendorCRD, Blackrock, InvestOne, WSO)
combinedCounts <- cbind(InvestOne, ePAM)

combinedCounts <- cbind(BoNY_ETF, ePAM, WSO, Blackrock)

countsforVenn <- vennCounts(combinedCounts)
# countsforVenn
# write.csv(countsforVenn, file = "combinedCounts.csv")

vennDiagram(countsforVenn, circle.col = c("red", "blue", "green"))


# Publish
# Clear memory
rm(list = ls())

source("http://www.bioconductor.org/biocLite.R")
class(biocLite)

biocLite("limma")

library(limma)
# Set working directory
#setwd("../Data")

#load data
mappingData <- read.table("Sources and Database Overlaps As Of 2016-6-24.csv", header = TRUE, sep = ",")

attach(mappingData)

Blackrock <- (mappingData$Blackrock > 0)
BoNY_ETF <- (mappingData$BoNY_ETF > 0)
ePAM <- (mappingData$ePAM > 0)
InvestOne <- (mappingData$InvestOne > 0)

combinedCounts <- cbind(BoNY_ETF, ePAM, Blackrock, InvestOne)
countsforVenn <- vennCounts(combinedCounts)
write.csv(countsforVenn, file = "combinedCounts.csv")
vennDiagram(countsforVenn, circle.col = c("red", "blue", "green"), )


