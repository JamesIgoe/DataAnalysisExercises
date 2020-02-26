################################################
# Classifier for Credit Notes Sec Types
#
################################################

################################################
# prep workspace
################################################

# Clear memory
rm(list = ls())

# update all packages
update.packages(ask = FALSE)


################################################
#
# Load and clean data
#
################################################

# set Working directory
getwd()
setwd('../Data')
#setwd('../Documents/Visual Studio 2013/Projects/RTutorials/TutorialsPoint/Data')
#setwd('H:/Personal/Code/TFS2013/RTutorials/TutorialsPoint/Data')

# load data
CreditNotes.df.full.preclean <- read.csv("CreditNotes_Full.csv", na.strings = c("", "NA"))
nrow(CreditNotes.df.full.preclean)

# remove NULLs
#CreditNotes.df.full <- na.omit(CreditNotes.df.full.preclean)
#nrow(CreditNotes.df.full)


################################################
# create formulae used for all samples
################################################

names(CreditNotes.df.full.preclean)
equation <- as.formula("StructureMapped ~ STRUCTURE + SM_SEC_GROUP")


################################################3
# Neural Net with nnet and caret
# Train / Test scenario
################################################3

# load packages
#install.packages('nnet')
#install.packages('caret')
library(nnet)
library(caret)


# traing and testing a model
CreditNotes.df.training <- createDataPartition(y = CreditNotes.df.full.preclean$StructureMapped, p = 0.8, list = FALSE)

train.set <- CreditNotes.df.full.preclean[CreditNotes.df.training,]
test.set <- CreditNotes.df.full.preclean[-CreditNotes.df.training,]
nrow(train.set) / nrow(test.set) # should be around 4


CreditNotes.df.model <- train(equation, train.set, method = "nnet", trace = FALSE)
CreditNotes.df.predicted <- predict(CreditNotes.df.model, test.set)
summary(CreditNotes.df.predicted)

CreditNotes.df.combined <- cbind(CreditNotes.df.predicted, test.set)
#View(CreditNotes.df.combined)

# percent correct for test set
# percent correct using nnet & caret
CreditNotes.df.combined$Correct <- ifelse(CreditNotes.df.combined$CreditNotes.df.predicted == CreditNotes.df.combined$StructureMapped, 1, 0)
(Correct.nnet <- paste("caret using nnet - Correct (%) = ", (sum(CreditNotes.df.combined$Correct) / length(CreditNotes.df.combined$Correct))))

plotnet(Portfolio.training.model, alpha = 0.6)

# graph log regression
library(ggplot2)
plotPart1 <- ggplot(data = Portfolio.training.combined, aes(y = Portfolio.training.prediction, x = PriceChange))
plotPart1 + geom_point() + stat_smooth(method = "lm", formula = y ~ x, size = 2)

library(ggplot2)
plotPart1 <- ggplot(data = Portfolio.training.combined, aes(x = PriceChange, fill = Sec_Type))
plotPart1 + geom_histogram(binwidth = .5)


################################################3
#
# Decision Tree
#
################################################3

library("rpart")

# grow tree   
fit <- rpart(equation, data = CreditNotes.df.full.preclean, method = "poisson")

# display the results  
printcp(fit)

# visualize cross-validation results    
plotcp(fit)

# detailed summary of splits  
summary(fit)

# plot tree   
plot(fit, uniform = TRUE, main = "Classification Tree for Structure + Sec Group")
text(fit, use.n = TRUE, all = TRUE, cex = .8)

# create attractive postscript plot of tree   
#post(fit, file = file.choose(), title = "Classification Tree for Liberal")  

# prune the tree
pfit <- prune(fit, cp = fit$cptable[which.min(fit$cptable[, "xerror"]), "CP"])

# plot the pruned tree   
plot(pfit, uniform = TRUE, main = "Pruned Classification Tree for Structure + Sec Group")
text(pfit, use.n = TRUE, all = TRUE, cex = .8)

# create attractive postscript plot of tree   
#post(pfit, file = file.choose(), title = "Pruned Classification Tree for Liberal")