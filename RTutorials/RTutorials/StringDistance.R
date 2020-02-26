# Clear memory
rm(list = ls())

# Set working directory
#setwd("../Data")
setwd("H:/Personal/Code/TFS2013/RTutorials/TutorialsPoint/Data")
getwd()

#load data
companyData <- read.table("CreditNotesCompanyData.csv", header = TRUE, sep = "|")
issuerData <- read.table("BRSUltimateIssuers.csv", header = TRUE, sep = "|")

# Style 1
BRSIssuers <- issuerData$ult_issuer_name
CompanyNames <- companyData$CompanyName

library(stringdist)

smallestDistanceWord <- function(word) {
    matched <- stringdist(word, BRSIssuers, method = 'osa')
    #matched <- pmatch(word, BRSIssuers, nomatch="NA", duplicates.ok=FALSE)
    #matched <- agrep(word, BRSIssuers, 0.01)
    minPos <- which.min(matched)
    BRSIssuers[minPos]
    #BRSIssuers[matched]
}

# test
testList <- CompanyNames
matchedList <- lapply(testList, FUN = smallestDistanceWord)

results <- do.call(rbind, Map(data.frame, A = testList, B = matchedList))
colnames(results) <- c("Company", "Match")

write.csv(results, file = "StringDistanceMappedList.csv")


# Style 2
# http://bigdata-doctor.com/fuzzy-string-matching-survival-skill-tackle-unstructured-information-r/
issuerData$ult_issuer_name <- as.character(issuerData$ult_issuer_name)
companyData$CompanyName <- as.character(companyData$CompanyName)

dist.issuers <- adist(companyData$CompanyName, issuerData$ult_issuer_name, partial = TRUE, ignore.case = TRUE)

min.issuers <- apply(dist.issuers, 1, min)

match.s1.s2 <- NULL
for (i in 1:nrow(dist.issuers)) {
    s2.i <- match(min.issuers[i], dist.issuers[i,])
    s1.i <- i
    match.s1.s2 <- rbind(data.frame(s2.i = s2.i, s1.i = s1.i, s2name = companyData[s2.i,]$CompanyName, s1name = issuerData[s1.i,]$ult_issuer_name, adist = min.issuers[i]), match.s1.s2)
}

# and we then can have a look at the results
View(match.s1.s2)