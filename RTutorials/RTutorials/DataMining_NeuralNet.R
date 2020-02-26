################################################
# Neural Net - Big Five By State
#
# Data Mining Algorithms in SSAS, Excel, and R
# https://app.pluralsight.com/player?course=data-mining-algorithms-ssas-excel-r&author=dejan-sarka&name=data-mining-algorithms-ssas-excel-r-m2
#
################################################

################################################
* prep workspace
################################################

# Clear memory
rm(list = ls())

# update all packages
update.packages(ask = FALSE)



################################################
# Load and clean data
################################################

# set Working directory
getwd()
setwd('../Data')

# load data
Politics.df <- read.csv("BigFiveScoresByState.csv", na.strings = c("", "NA"))
nrow(Politics.df)

# remove NULLs
Politics.df <- na.omit(Politics.df)
nrow(Politics.df)



################################################
# create formula used for all samples
################################################

names(Portfolio.df)

equation <- as.formula("Liberal ~ Openness + Conscientiousness + Extraversion + Neuroticism + Agreeableness")



################################################
# Logisitc Regression
################################################

# generalized logistic model
Politics.logR <- glm(data = Politics.df, family = binomial(), equation)

# summary
#summary(Politics.logR)

# confidence interval
#confint(Politics.logR)

# predict
Politics.predict <- predict(Politics.logR, type = "response")

# combine frame for calculation
Politics.combined <- cbind(Politics.predict, Politics.df)

# visually review data frame result
#View(Politics.combined)

# calculate percent correct
Politics.combined$predictionBinary <- ifelse(Politics.combined$Politics.predict >= .5, 1, 0)
Politics.combined$Correct <- ifelse(Politics.combined$predictionBinary == Politics.combined$Liberal, 1, 0)
(Correct.LogR <- paste("Logistic Regression (All) - Correct (%) = ", (sum(Politics.combined$Correct) / length(Politics.combined$Correct))))

# percent correct Red
Politics.combined.red <- Politics.combined[Politics.combined$Liberal == 0,]
(Correct.LogR.Red <- paste("Logistic Regression (Red) - Correct (%) = ", (sum(Politics.combined.red$Correct) / length(Politics.combined.red$Correct))))

# percent correct Red
Politics.combined.blue <- Politics.combined[Politics.combined$Liberal == 1,]
(Correct.LogR.Blue <- paste("Logistic Regression (Blue) - Correct (%) = ", (sum(Politics.combined.blue$Correct) / length(Politics.combined.blue$Correct))))

# graph log regression
library(ggplot2)
plotPart1 <- ggplot(data = Politics.combined, aes(y = Politics.predict, x = Liberal))
plotPart1 + geom_point() + stat_smooth(method = "lm", formula = y ~ x, size = 2)

table(Politics.combined$predictionBinary, Politics.combined$Liberal)


################################################
# Neural Net with neuralnet
################################################

# load packages
install.packages('neuralnet')
library(neuralnet)

# chart correlations to select candidates for inlcusion in 
Politics.corr <- as.data.frame(cbind(Politics.df$Openness, Politics.df$Conscientiousness, Politics.df$Extraversion, Politics.df$Agreeableness, Politics.df$Neuroticism))
colnames(Politics.corr) <- c('Openness','Conscientiousness','Extraversion','Agreeableness','Neuroticism')

#install.packages("GGally", dependencies = TRUE)
library(GGally)
ggpairs(Politics.corr)

#install.packages("corrplot", dependencies = TRUE)
library(corrplot)
corrplot.mixed(cor(Politics.corr), order = "hclust", tl.col = "black")

# set parameters for neural net
maxLayers = 1
maxRep = 1
df.Size = maxLayers * maxRep

# create empty data frame, for best performance
NeuralNet.Predictions <- data.frame(Layer = numeric(df.Size), Repition = numeric(df.Size), Prediction = numeric(df.Size), stringsAsFactors = FALSE)

# loop through parameters and neural net to buil;d results
currentRow = 0
for (layerCount in 1:maxLayers) {
    for (repCount in 1:maxRep) {

        currentRow <- currentRow + 1
        NeuralNet.Predictions$Layer[currentRow] <- layerCount
        NeuralNet.Predictions$Repition[currentRow] <- repCount

        # train
        Politics.nn <- neuralnet(equation, data = Politics.df, hidden = layerCount, rep = repCount)

        # predict
        Politics.prediction <- as.data.frame(prediction(Politics.nn))

        # set comparison value
        Politics.prediction$predictionBinary <- ifelse(Politics.prediction$rep1.Liberal >= .5, 1, 0)

        # compare actual versus result
        Politics.prediction$Correct <- ifelse(Politics.prediction$predictionBinary == Politics.prediction$data.Liberal, 1, 0)

        # find percent correct, add to array
        correct <- (sum(Politics.prediction$Correct) / length(Politics.prediction$Correct))
        NeuralNet.Predictions$Prediction[currentRow] <- correct
    }
}

# display results
NeuralNet.Predictions

# average / min / max prediction
(NeuralNet.Predictions.Correct <- paste("NeuralNet - Correct (%) = ", ave(NeuralNet.Predictions$Prediction)[1]))
(NeuralNet.Min <- paste("NeuralNet - Min (%) = ", min(NeuralNet.Predictions$Prediction)))
(NeuralNet.Max <- paste("NeuralNet - Max (%) = ", max(NeuralNet.Predictions$Prediction)))

# display last neural net
plot(Politics.nn)

# plot
library(ggplot2)
plotPart1 <- ggplot(data = NeuralNet.Predictions, aes(x = (Layer + Repition), y = Prediction))
plotPart1 + geom_point() + stat_smooth(method = "glm", formula = y ~ x, size = 2)


################################################3
# Neural Net with nnet and caret
################################################3

# load packages
library(nnet)
library(caret)

# train
Politics.model <- train(equation, Politics.df, method = 'nnet', linout = TRUE, trace = FALSE)
Politics.model.predicted <- predict(Politics.model, Politics.df)

# classification result
#plot(Politics.model.predicted)

Politics.model.combined <- cbind(Politics.model.predicted, Politics.df)
#View(Politics.model.combined)

# percent correct using nnet & caret
Politics.model.combined$predictionBinary <- ifelse(Politics.model.combined$Politics.model.predicted > .5, 1, 0)
Politics.model.combined$Correct <- ifelse(Politics.model.combined$predictionBinary == Politics.model.combined$Liberal, 1, 0)
(Correct.nnet <- paste("caret using nnet - Correct (%) = ", (sum(Politics.model.combined$Correct) / length(Politics.model.combined$Correct))))

# display neural net model
# install.packages('NeuraNetTools')
library(NeuralNetTools)
plotnet(Politics.model, alpha = 0.6)

# graph log regression
library(ggplot2)
plotPart1 <- ggplot(data = Politics.model.combined, aes(y = Politics.model.predicted, x = Liberal))
plotPart1 + geom_point() + stat_smooth(method = "lm", formula = y ~ x, size = 2)

Politics.model.table <- confusionMatrix(Politics.model.combined$predictionBinary, Politics.model.combined$Liberal)
colnames(Politics.model.table$table) <- c("Red State", "Blue State")
rownames(Politics.model.table$table) <- c("Red State", "Blue State")

fourfoldplot(Politics.model.table$table, color = c("Red", "Green"), conf.level = 0, margin = 1, main = "Confusion Matrix for Model")


################################################3
# Neural Net with nnet and caret
# Train / Test scenario
################################################3

# traing and testing a model
Politics.training <- createDataPartition(y = Politics.df$Liberal, p = 0.8, list = FALSE) 

train.set <- Politics.df[Politics.training,]
test.set <- Politics.df[ - Politics.training,]
nrow(train.set) / nrow(test.set) # should be around 4

Politics.training.model <- train(equation, train.set, method = "nnet", trace = FALSE)
Politics.training.prediction <- predict(Politics.training.model, test.set)
 
Politics.training.combined <- as.data.frame(cbind(Politics.training.prediction, test.set))
# View(Politics.training.combined)

# percent correct for test set
# percent correct using nnet & caret
Politics.training.combined$predictionBinary <- ifelse(Politics.training.combined$Politics.training.prediction > .5, 1, 0)
Politics.training.combined$Correct <- ifelse(Politics.training.combined$predictionBinary == Politics.training.combined$Liberal, 1, 0)
(Correct.test <- paste("caret using nnet (Test/Train) - Correct (%) = ", (sum(Politics.training.combined$Correct) / length(Politics.training.combined$Correct))))


Politics.training.table <- confusionMatrix(Politics.training.combined$predictionBinary, Politics.training.combined$Liberal)
colnames(Politics.training.table$table) <- c("Red State", "Blue State")
rownames(Politics.training.table$table) <- c("Red State", "Blue State")

fourfoldplot(Politics.training.table$table, color = c("Red", "Green"), conf.level = 0, margin = 1, main = "Confusion Matrix for Model")


# display neural net model
# install.packages('NeuraNetTools')
library(NeuralNetTools)
plotnet(Politics.training.model, alpha = 0.6)

# graph log regression
library(ggplot2)
plotPart1 <- ggplot(data = Politics.training.combined, aes(y = Politics.training.prediction, x = Liberal))
plotPart1 + geom_point() + stat_smooth(method = "lm", formula = y ~ x, size = 2)

