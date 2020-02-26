# Charting correlations in R
# http://jamesmarquezportfolio.com/correlation_matrices_in_r.html

# Clear workspace
rm(list = ls())

# Set working directory
setwd("../Data")
getwd()

# load data
oecdData <- read.table("OECD - Quality of Life.csv", header = TRUE, sep = ",")
hofsted.vectors <- oecdData[,c('HofstederPowerDx', 'HofstederMasculinity', 'HofstederIndividuality', 'HofstederUncertaintyAvoidance', 'HofstederLongtermOrientation', 'HofstederIndulgence')]

#rename columns
names(hofsted.vectors)[1:6] = c('PowerDx', 'Masculinity', 'Individuality', 'UAE', 'LTO', 'Indulgence')

# PerformanceAnalytics
install.packages("PerformanceAnalytics", dependencies = TRUE)
library("PerformanceAnalytics")
chart.Correlation(hofsted.vectors, histogram = TRUE, pch = 19)


# psych
install.packages("psych", dependencies = TRUE)
library(psych)
pairs.panels(hofsted.vectors, scale = TRUE)


# corr
install.packages("corrr", dependencies = TRUE)
library(corr)
# mydata %>% correlate() %>% network_plot(min_cor = 0.6)
network_plot(correlate(hofsted.vectors), min_cor = 0.5)


# corrplot
install.packages("corrplot", dependencies = TRUE)
library(corrplot)
corrplot.mixed(cor(hofsted.vectors), order = "hclust", tl.col = "black")


# GGally
install.packages("GGally", dependencies = TRUE)
library(GGally)
ggpairs(hofsted.vectors)


# ggcorrplot
install.packages("ggcorrplot", dependencies = TRUE)
library(ggcorrplot)
ggcorrplot(cor(hofsted.vectors), p.mat = cor_pmat(hofsted.vectors), hc.order = TRUE, type = 'lower')


# load data, more countries
oecdData <- read.table("HofstedePatterns.csv", header = TRUE, sep = ",")
hofsted.vectors <- oecdData[,c('PowerDx', 'Masculinity', 'Individuality', 'UAE')]

# PerformanceAnalytics
install.packages("PerformanceAnalytics", dependencies = TRUE)
library("PerformanceAnalytics")
chart.Correlation(hofsted.vectors, histogram = TRUE, pch = 19)


# psych
install.packages("psych", dependencies = TRUE)
library(psych)
pairs.panels(hofsted.vectors, scale = TRUE)


# corr
install.packages("corrr", dependencies = TRUE)
library(corr)
# mydata %>% correlate() %>% network_plot(min_cor = 0.6)
network_plot(correlate(hofsted.vectors), min_cor = 0.5)


# corrplot
install.packages("corrplot", dependencies = TRUE)
library(corrplot)
corrplot.mixed(cor(hofsted.vectors), order = "hclust", tl.col = "black")


# GGally
install.packages("GGally", dependencies = TRUE)
library(GGally)
ggpairs(hofsted.vectors)


# ggcorrplot
install.packages("ggcorrplot", dependencies = TRUE)
library(ggcorrplot)
ggcorrplot(cor(hofsted.vectors), p.mat = cor_pmat(hofsted.vectors), hc.order = TRUE, type = 'lower')
