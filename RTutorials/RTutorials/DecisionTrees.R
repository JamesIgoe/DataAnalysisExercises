# Decision Tree - Big Five and Politics  
library("rpart")

# Set working directory
setwd("../Data")
getwd()

# grow tree   
input.dat <- read.table("BigFiveScoresByState.csv", header = TRUE, sep = ",")
fit <- rpart(Liberal ~ Openness + Conscientiousness + Neuroticism + Extraversion + Agreeableness, data = input.dat, method = "poisson")

# display the results  
printcp(fit)

# visualize cross-validation results    
plotcp(fit)

# detailed summary of splits  
summary(fit)

# plot tree   
plot(fit, uniform = TRUE, main = "Classification Tree for Liberal")
text(fit, use.n = TRUE, all = TRUE, cex = .8)

# create attractive postscript plot of tree   
#post(fit, file = file.choose(), title = "Classification Tree for Liberal")  

# prune the tree
pfit <- prune(fit, cp = fit$cptable[which.min(fit$cptable[, "xerror"]), "CP"])

# plot the pruned tree   
plot(pfit, uniform = TRUE, main = "Pruned Classification Tree for Liberal")
text(pfit, use.n = TRUE, all = TRUE, cex = .8)

# create attractive postscript plot of tree   
#post(pfit, file = file.choose(), title = "Pruned Classification Tree for Liberal")