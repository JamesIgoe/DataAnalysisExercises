# Text for this can be acquired here
# http://www.gutenberg.org/cache/epub/989/pg989.tx

# Read Text
textToRead = 'pg989.txt'
exclusionFile = 'StopList_Extended.csv'
text.scan <- scan(file = textToRead, what = 'char')
text.scan <- tolower(text.scan)

# Create list
text.list <- strsplit(text.scan, '\\W+', perl = TRUE)
text.vector <- unlist(text.list)

# Create exclusion list  
exclusion.file <- scan(exclusionFile, what = 'char')
exclusion.v <- strsplit(exclusion.file, ',', perl = TRUE)
exclusion.v <- tolower(exclusion.v)

# Remove exclusions
not.exclusions.v <- which(!text.vector %in% exclusion.v)
text.vector <- text.vector[not.exclusions.v]

# Create sorted list
text.frequency = table(text.vector)
text.frequency.sorted = sort(text.frequency, decreasing = TRUE)

# Plots
# Types: p = point, l = line, b = both, h = hist, s = stairs
plot(text.frequency.sorted[1:50]
    , type="s" 
    , main = "Word Frequency"
    , xlab = "Word Rank (Decreasing)"
    , ylab = "Frequency")

# dispersion plot building
text.frequency.sorted[1:50]

n.time.v = seq(1:length(text.vector))

textToPlot = 'A Theological-Political Treatise [Part I]'
wordToPlot = 'god'
wordToPlot = 'law'
wordToPlot = 'prophets'
wordToPlot = 'lord'

word.v <- which(text.vector == wordToPlot)
w.count.v <- rep(NA, length(n.time.v))
w.count.v[word.v] <- 1

plot(w.count.v
    , main = paste(wordToPlot, 'in', textToPlot, sep = " ")
    , xlab = "Document Time"
    , ylab = wordToPlot
    , type = "h"
    , ylim = c(0, 1), yaxt = 'n')


# Attempt at correlation
god.v = which(text.vector == 'god')
law.v = which(text.vector == 'law')
prophets.v = which(text.vector == 'prophets')
lord.v = which(text.vector == 'lord')
the.v = which(text.vector == 'the')
he.v = which(text.vector == 'he')

god.count.v <- rep(0, length(n.time.v))
god.count.v[god.v] <- 1

law.count.v <- rep(0, length(n.time.v))
law.count.v[law.v] <- 1

prophets.count.v <- rep(0, length(n.time.v))
prophets.count.v[prophets.v] <- 1

lord.count.v <- rep(0, length(n.time.v))
lord.count.v[lord.v] <- 1

the.count.v <- rep(0, length(n.time.v))
the.count.v[the.v] <- 1

he.count.v <- rep(0, length(n.time.v))
he.count.v[he.v] <- 1

cor(god.count.v, lord.count.v)
cor(prophets.count.v, lord.count.v)
cor(law.count.v, god.count.v)
cor(god.count.v, the.count.v)
cor(god.count.v, he.count.v)



# Exploring non-linear least square
oecdData <- read.table("OECD - Quality of Life.csv", header = TRUE, sep = ",")
gini.v <- c(oecdData$Gini[1:9],oecdData$Gini[18:24])
death.v <- c(oecdData$InfantDeath[1:9], oecdData$InfantDeath[18:24])

# Take the assumed values and fit into the model.
model <- nls(death.v ~ b1 * gini.v ^ 2 + b2, start = list(b1 = 1, b2 = 3))

# Plot the chart with new data by fitting it to a prediction from 100 data points.
new.data <- data.frame(death.v = seq(min(death.v), max(death.v), len = 16))
lines(new.data$death.v, predict(model, newdata = new.data))

plot(gini.v, death.v, col = "blue", main = "Infant Death v Gini", abline(nls(death.v ~ b1 * gini.v ^ 2 + b2, start = list(b1 = 1, b2 = 3))), cex = 1.3, pch = 16, xlab = "Gini", ylab = "Infant Death")



# Decision Trees

# Decision Tree - Big Five and Politics
library("rpart")

# grow tree 
input.dat <- read.table("BigFiveScoresByState.csv", header = TRUE, sep = ",")
fit <- rpart(Liberal ~ Openness + Conscientiousness + Neuroticism + Extraversion + Agreeableness, data = input.dat, method="poisson")

# display the results
printcp(fit)

# visualize cross-validation results   
plotcp(fit)

# detailed summary of splits
summary(fit) 

# plot tree 
plot(fit, uniform = TRUE, main = "Classification Tree for Liberal")
text(fit, use.n = TRUE, all = TRUE, cex = .8)

#prune the tree
pfit <- prune(fit, cp = fit$cptable[which.min(fit$cptable[, "xerror"]), "CP"])

# plot the pruned tree 
plot(pfit, uniform = TRUE, main = "Pruned Classification Tree for Liberal")
text(pfit, use.n = TRUE, all = TRUE, cex = .8)

# create attractive postscript plot of tree 
post(pfit, file = file.choose(), title = "Pruned Classification Tree for Liberal")


# Attempt to plot Logistic Regression
rm(list = ls())

stateData <- read.table("BigFiveScoresByState.csv", header = TRUE, sep = ",")
lib.v = stateData$Liberal
conc.v = stateData$Conscientiousness
open.v = stateData$Openness
am.data = glm(formula = Liberal ~ Conscientiousness, data = stateData, family = binomial)
print(summary(am.data))

open.v = stateData$Openness
am.data = glm(formula = Liberal ~ Openness, data = stateData, family = binomial)
print(summary(am.data))

am.data = glm(formula = Liberal ~ Openness + Conscientiousness, data = stateData, family = binomial)
print(summary(am.data))
