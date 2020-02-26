################################################
# Neural Net - Predicting Price Change
#
# Data Mining Algorithms in SSAS, Excel, and R
# https://app.pluralsight.com/player?course=data-mining-algorithms-ssas-excel-r&author=dejan-sarka&name=data-mining-algorithms-ssas-excel-r-m2
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
# Load and clean data
################################################

# set Working directory
getwd()
setwd('../Data')
#setwd('../Documents/Visual Studio 2013/Projects/RTutorials/TutorialsPoint/Data')
#setwd('H:/Personal/Code/TFS2013/RTutorials/TutorialsPoint/Data')

# load data
Portfolio.df.preclean <- read.csv("SamplePortfolio.csv", na.strings = c("", "NA"))
nrow(Portfolio.df.preclean)

# removes invalid price from all assets
Portfolio.df.preclean <- Portfolio.df.preclean[Portfolio.df.preclean$Price > 1,]
nrow(Portfolio.df.preclean)

# remove NULLs
Portfolio.df.preclean <- na.omit(Portfolio.df.preclean)
nrow(Portfolio.df.preclean)

Portfolio.df <- Portfolio.df.preclean



################################################
# create forulae used for all samples
################################################

names(Portfolio.df)

equation <- as.formula("PriceChange ~ Coupon + Duration + Convexity")


################################################
# Logisitc Regression
################################################

# generalized logistic model
Portfolio.logR <- glm(data = Portfolio.df, family = binomial(), equation)

# summary
#summary(Portfolio.logR)

# confidence interval
#confint(Portfolio.logR)

# predict
Portfolio.predict <- predict(Portfolio.logR, type = "response")

# combine frame for calculation
Portfolio.combined <- cbind(Portfolio.predict, Portfolio.df)

# visually review data frame result
#View(Portfolio.combined)

# calculate percent correct
Portfolio.combined$predictionBinary <- ifelse(Portfolio.combined$Portfolio.predict >= .5, 1, 0)
Portfolio.combined$Correct <- ifelse(Portfolio.combined$predictionBinary == Portfolio.combined$PriceChange, 1, 0)
(Correct.LogR <- paste("Logistic Regression - Correct (%) = ", (sum(Portfolio.combined$Correct) / length(Portfolio.combined$Correct))))

# graph log regression
#install.packages('ggplot2')
library(ggplot2)
plotPart1 <- ggplot(data = Portfolio.combined, aes(y = Portfolio.predict, x = PriceChange))
plotPart1 + geom_point() + stat_smooth(method = "lm", formula = y ~ x, size = 2)

library(ggplot2)
plotPart1 <- ggplot(data = Portfolio.combined, aes(x = PriceChange, fill = Sec_Type))
plotPart1 + geom_histogram(binwidth = .5)

Portfolio.combined.matrix <- confusionMatrix(Portfolio.combined$predictionBinary, Portfolio.combined$PriceChange)
colnames(Portfolio.combined.matrix$table) <- c("No Price Change", "Price Change")
rownames(Portfolio.combined.matrix$table) <- c("No Price Change", "Price Change")
fourfoldplot(Portfolio.combined.matrix$table, color = c("Red", "Green"), conf.level = 0, margin = 1, main = "Confusion Matrix for Model")


################################################
# Neural Net with neuralnet
################################################

# load packages
#install.packages('neuralnet')
library(neuralnet)

# chart correlations to select candidates for inlcusion in 
Portfolio.corr <- as.data.frame(cbind(Portfolio.df$Coupon, Portfolio.df$Duration, Portfolio.df$Convexity))
colnames(Portfolio.corr) <- c('Coupon', 'Duration', 'Convexity')

#install.packages("GGally", dependencies = TRUE)
library(GGally)
ggpairs(Portfolio.corr)

#install.packages("corrplot", dependencies = TRUE)
library(corrplot)
corrplot.mixed(cor(Portfolio.corr), order = "hclust", tl.col = "black")

# set parameters for neural net
maxLayers = 5
maxRep = 5
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
        Portfolio.nn <- neuralnet(equation, data = Portfolio.df, hidden = layerCount, rep = repCount)

        # predict
        Portfolio.prediction <- as.data.frame(prediction(Portfolio.nn))

        # set comparison value
        Portfolio.prediction$predictionBinary <- ifelse(Portfolio.prediction$rep1.PriceChange >= .5, 1, 0)

        # compare actual versus result
        Portfolio.prediction$Correct <- ifelse(Portfolio.prediction$predictionBinary == Portfolio.prediction$data.PriceChange, 1, 0)

        # find percent correct, add to array
        correct <- (sum(Portfolio.prediction$Correct) / length(Portfolio.prediction$Correct))
        NeuralNet.Predictions$Prediction[currentRow] <- correct
    }
}

# display results
NeuralNet.Predictions

# average / min / max prediction
(NeuralNet.Predictions.Correct <- paste("NeuralNet - Ave (%) = ", ave(NeuralNet.Predictions$Prediction)[1]))
(NeuralNet.Min <- paste("NeuralNet - Min (%) = ", min(NeuralNet.Predictions$Prediction)))
(NeuralNet.Max <- paste("NeuralNet - Max (%) = ", max(NeuralNet.Predictions$Prediction)))

# display last neural net
plot(Portfolio.nn)

# plot result
library(ggplot2)
plotPart1 <- ggplot(data = NeuralNet.Predictions, aes(x = (Layer + Repition), y = Prediction))
plotPart1 + geom_point() + stat_smooth(method = "glm", formula = y ~ x, size = 2)


################################################
# create forulae used for all samples
################################################

names(Portfolio.df)

equation <- as.formula("PriceChange ~ Coupon + Duration + Convexity")


################################################3
# Neural Net with nnet and caret
################################################3

# load packages
#install.packages('nnet')
#install.packages('caret')
library(nnet)
library(caret)

# train
Portfolio.model <- train(equation, Portfolio.df, method = 'nnet', linout = TRUE, trace = FALSE)
Portfolio.model.predicted <- predict(Portfolio.model, Portfolio.df)

# classification result
#plot(Portfolio.model.predicted)

Portfolio.model.combined <- cbind(Portfolio.model.predicted, Portfolio.df)
#View(Portfolio.model.combined)

# percent correct using nnet & caret
Portfolio.model.combined$predictionBinary <- ifelse(Portfolio.model.combined$Portfolio.model.predicted >= .5, 1, 0)
Portfolio.model.combined$Correct <- ifelse(Portfolio.model.combined$predictionBinary == Portfolio.model.combined$PriceChange, 1, 0)
(Correct.nnet <- paste("caret using nnet - Correct (%) = ", (sum(Portfolio.model.combined$Correct) / length(Portfolio.model.combined$Correct))))

# install.packages('NeuralNetTools')
library(NeuralNetTools)
plotnet(Portfolio.model, alpha = 0.6)

# graph log regression
library(ggplot2)
plotPart1 <- ggplot(data = Portfolio.model.combined, aes(y = Portfolio.model.predicted, x = PriceChange))
plotPart1 + geom_point() + stat_smooth(method = "lm", formula = y ~ x, size = 2)

Portfolio.model.combined.matrix <- confusionMatrix(Portfolio.model.combined$predictionBinary, Portfolio.model.combined$PriceChange)
colnames(Portfolio.model.combined.matrix$table) <- c("No Price Change", "Price Change")
rownames(Portfolio.model.combined.matrix$table) <- c("No Price Change", "Price Change")
fourfoldplot(Portfolio.model.combined.matrix$table, color = c("Red", "Green"), conf.level = 0, margin = 1, main = "Confusion Matrix for Model")


################################################3
# Neural Net with nnet and caret
# Train / Test scenario
################################################3

# traing and testing a model
Portfolio.training <- createDataPartition(y = Portfolio.df$PriceChange, p = 0.8, list = FALSE)

train.set <- Portfolio.df[Portfolio.training,]
test.set <- Portfolio.df[-Portfolio.training,]
nrow(train.set) / nrow(test.set) # should be around 4

Portfolio.training.model <- train(equation, train.set, method = "nnet", trace = FALSE)
Portfolio.training.prediction <- predict(Portfolio.training.model, test.set)
summary(Portfolio.training.prediction)

Portfolio.training.combined <- as.data.frame(cbind(Portfolio.training.prediction, test.set))
# View(Portfolio.training.combined)

# percent correct for test set
# percent correct using nnet & caret
Portfolio.training.combined$predictionBinary <- ifelse(Portfolio.training.combined$Portfolio.training.prediction >= .5, 1, 0)
Portfolio.training.combined$Correct <- ifelse(Portfolio.training.combined$predictionBinary == Portfolio.training.combined$PriceChange, 1, 0)
(Correct.test <- paste("caret using nnet (Test/Train) - Correct (%) = ", (sum(Portfolio.training.combined$Correct) / length(Portfolio.training.combined$Correct))))

plotnet(Portfolio.training.model, alpha = 0.6)

# graph log regression
library(ggplot2)
plotPart1 <- ggplot(data = Portfolio.training.combined, aes(y = Portfolio.training.prediction, x = PriceChange))
plotPart1 + geom_point() + stat_smooth(method = "lm", formula = y ~ x, size = 2)

library(ggplot2)
plotPart1 <- ggplot(data = Portfolio.training.combined, aes(x = PriceChange, fill = Sec_Type))
plotPart1 + geom_histogram(binwidth = .5)


################################################
# create forulae used for all samples
################################################

#names(Portfolio.df)
equation <- as.formula("PriceChange ~ Coupon + Duration + Convexity")


################################################3
# Neural Net with nnet and caret
# Filtering comparisons
################################################3

# load packages
library(nnet)
library(caret)

# set parameters for loop
secTypes <- unique(Portfolio.df$Sec_Type)
numRows <- length(secTypes)

# create empty data frame, for best performance
Filtered.Predictions <- data.frame(SecType = character(numRows), Values = numeric(numRows), HasPriceChange = numeric(numRows), PercentCorrect = numeric(numRows), PercentCorrectNoChange = numeric(numRows), PercentCorrectChange = numeric(numRows), stringsAsFactors = FALSE)

# loop through parameters and neural net to buil;d results
currentRow = 0
for (secType in secTypes) {

    currentRow <- currentRow + 1

    # filter data set
    Portfolio.filtered <- Portfolio.df.preclean[Portfolio.df.preclean$Sec_Type == secType,]
    #View(Portfolio.df.preclean)

    # only work on assets with price changes
    if ((sum(ifelse(Portfolio.filtered$PriceChange == 1, 1, 0)) / nrow(Portfolio.filtered)) >= 0.0) {

        # add sec type to result
        Filtered.Predictions$SecType[currentRow] <- secType

        # add number of values to result'
        Filtered.Predictions$Values[currentRow] <- nrow(Portfolio.filtered)
        Filtered.Predictions$HasPriceChange[currentRow] <- (sum(ifelse(Portfolio.filtered$PriceChange == 1, 1, 0)) / nrow(Portfolio.filtered))

        # train
        Portfolio.filtered.train <- train(equation, Portfolio.filtered, method = 'nnet', linout = TRUE, trace = FALSE)

        # predict
        Portfolio.filtered.predicted <- predict(Portfolio.filtered.train, Portfolio.filtered)

        # combine
        Portfolio.filtered.combined <- cbind(Portfolio.filtered.predicted, Portfolio.filtered)

        # calculate correct
        Portfolio.filtered.combined$predictionBinary <- ifelse(Portfolio.filtered.combined$Portfolio.filtered.predicted >= .5, 1, 0)
        Portfolio.filtered.combined$Correct <- ifelse(Portfolio.filtered.combined$predictionBinary == Portfolio.filtered.combined$PriceChange, 1, 0)
        correct <- (sum(Portfolio.filtered.combined$Correct) / length(Portfolio.filtered.combined$Correct))

        # calculate correct, no change
        Portfolio.filtered.combined.NoChange <- Portfolio.filtered.combined[Portfolio.filtered.combined$PriceChange == 0,]
        correctNoChange <- (sum(Portfolio.filtered.combined.NoChange$Correct) / length(Portfolio.filtered.combined.NoChange$Correct))

        # calculate correct, change
        Portfolio.filtered.combined.Change <- Portfolio.filtered.combined[Portfolio.filtered.combined$PriceChange == 1,]
        correctChange <- (sum(Portfolio.filtered.combined.Change$Correct) / length(Portfolio.filtered.combined.Change$Correct))
        
        # add percent correct to result
        Filtered.Predictions$PercentCorrect[currentRow] <- correct
        Filtered.Predictions$PercentCorrectNoChange[currentRow] <- correctNoChange
        Filtered.Predictions$PercentCorrectChange[currentRow] <- correctChange
    }
}

# display results
Filtered.Predictions <- Filtered.Predictions[Filtered.Predictions$HasPriceChange > 0,]

# plot result
library(ggplot2)
plotPart1 <- ggplot(data = Filtered.Predictions, aes(x = HasPriceChange, y = PercentCorrect))
plotpart2 <- plotPart1 + geom_point() + stat_smooth(method = "lm", formula = y ~ x, size = 1)
plotpart2 + geom_text(aes(label = SecType), hjust = 0, vjust = 0, nudge_x = -.00, nudge_y = .005, angle=0, size=3)

