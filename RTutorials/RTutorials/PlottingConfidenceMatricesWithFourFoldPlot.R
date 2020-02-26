

################################################
# Load and clean data
################################################

Politics.df <- read.csv("BigFiveScoresByState.csv", na.strings = c("", "NA"))
Politics.df <- na.omit(Politics.df)

################################################3
# Neural Net with nnet and caret
################################################3

# load packages
library(nnet)
library(caret)

# set equation
equation <- as.formula("Liberal ~ Openness + Conscientiousness + Extraversion + Neuroticism + Agreeableness")

# train, predict, combine
Politics.model <- train(equation, Politics.df, method = 'nnet', linout = TRUE, trace = FALSE)
Politics.model.predicted <- predict(Politics.model, Politics.df)
Politics.model.combined <- cbind(Politics.model.predicted, Politics.df)

################################################3
# Plot with FourFoldPlot
################################################3

Politics.model.matrix <- confusionMatrix(Politics.model.combined$predictionBinary, Politics.model.combined$Liberal)
colnames(Politics.model.matrix$table) <- c("Conservative", "Liberal")
rownames(Politics.model.matrix$table) <- c("Conservative", "Liberal")

fourfoldplot(Politics.model.matrix$table, color = c("Red", "Green"), conf.level = 0, margin = 1, main = "Confusion Matrix for Model")
