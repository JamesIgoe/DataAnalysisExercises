################################################
# Neural Net - ARIMA and Time Series
#
# Data Mining Algorithms in SSAS, Excel, and R
# https://app.pluralsight.com/player?course=data-mining-algorithms-ssas-excel-r&author=dejan-sarka&name=data-mining-algorithms-ssas-excel-r-m2
#
################################################

#########################################################
# prep workspace
#########################################################

# Clear memory
rm(list = ls())

# update all packages
update.packages(ask = FALSE)

#install.packages('ggplot2', dependencies = TRUE)
library(ggplot2)
#install.packages('forecast', dependencies = TRUE)
library(forecast)


#########################################################
# Load and clean data
#########################################################

# set Working directory
getwd()
setwd('../Data')
#setwd('../Documents/Visual Studio 2013/Projects/RTutorials/TutorialsPoint/Data')
#setwd('H:/Personal/Code/TFS2013/RTutorials/TutorialsPoint/Data')

# load data
Portfolio.df.preclean <- read.csv("PortfoliosHistory.csv", na.strings = c("", "NA"), stringsAsFactors=FALSE)

# scrub as necessary
# reduced market value to millions, otherwise to large to aggregate
Portfolio.df.preclean$Mkt.Val <- Portfolio.df.preclean$Mkt.Val / 1000000

# copy set into demo data frame
Portfolio.df <- Portfolio.df.preclean


#########################################################
# Time series with ARIMA
#########################################################

# filtered to start on a date
Portfolio.filtered <- Portfolio.df[Portfolio.df$YearMonthIndex >= 201501,]

# aggregated by YearMonthIndex
Portfolio.summed <- aggregate(Portfolio.filtered$Mkt.Val, by = list(Portfolio.filtered$YearMonthIndex), FUN = sum)

# create time series
Portfolio.timeSeries <- ts(data = Portfolio.summed[, 2], start = c(2015, 01), frequency = 12)

# set arima models 
(a1 <- arima(Portfolio.timeSeries, order = c(1, 0, 0)))
(a2 <- arima(Portfolio.timeSeries, order = c(0, 0, 1)))
(a3 <- arima(Portfolio.timeSeries, order = c(1, 0, 1)))
(a4 <- arima(Portfolio.timeSeries, order = c(1, 1, 1)))
(a5 <- arima(Portfolio.timeSeries, order = c(2, 1, 0)))

# select and set model
series.predict.a1 <- predict(a1, 12)
series.predict.a2 <- predict(a2, 12)
series.predict.a3 <- predict(a3, 12)
series.predict.a4 <- predict(a4, 12)
series.predict.a5 <- predict(a5, 12)

# combine with source
series.predict.a1.combined <- ts(data = c(Portfolio.timeSeries, as.vector(series.predict.a1$pred)), start = c(2015, 01), frequency = 12)
series.predict.a2.combined <- ts(data = c(Portfolio.timeSeries, as.vector(series.predict.a2$pred)), start = c(2015, 01), frequency = 12)
series.predict.a3.combined <- ts(data = c(Portfolio.timeSeries, as.vector(series.predict.a3$pred)), start = c(2015, 01), frequency = 12)
series.predict.a4.combined <- ts(data = c(Portfolio.timeSeries, as.vector(series.predict.a4$pred)), start = c(2015, 01), frequency = 12)
series.predict.a5.combined <- ts(data = c(Portfolio.timeSeries, as.vector(series.predict.a5$pred)), start = c(2015, 01), frequency = 12)


#########################################################
# Time series with ARIMA - plotted
#########################################################

# plot time series
# plot predictions - lowest standard error
series.predict.a4.lone <- ts(data = as.vector(series.predict.a4$pred), start = c(2017, 05), frequency = 12)
plot(Portfolio.timeSeries, xlim = c(2015.0,2018.12),  ylim = c(0, 10000), col = "Black", ann = FALSE)
par(new = TRUE)
plot(series.predict.a4.lone, xlim = c(2015.0, 2018.12), ylim = c(0, 10000), col = "Red", ann = FALSE)

### Plot goes here - ARIMA Prediction


#########################################################
# ARIMA - subset time series, compare actual to predicted
#########################################################

predictions <- 14
startDate <- c(2014, 05)
endDate <- c(2016, 03)

# filtered to start on a date
Portfolio.unfiltered <- Portfolio.df

# aggregated by YearMonthIndex
Portfolio.unfiltered.summed <- aggregate(Portfolio.unfiltered$Mkt.Val, by = list(Portfolio.unfiltered$YearMonthIndex), FUN = sum)

# create time series
Portfolio.unfiltered.timeSeries <- ts(data = Portfolio.unfiltered.summed[, 2], start = startDate, frequency = 12)
Portfolio.unfiltered.timeSeries.window <- window(Portfolio.unfiltered.timeSeries, start = startDate, end = endDate)

(a1.w <- arima(Portfolio.unfiltered.timeSeries.window, order = c(1, 0, 0)))
(a2.w <- arima(Portfolio.unfiltered.timeSeries.window, order = c(0, 0, 1)))
(a3.w <- arima(Portfolio.unfiltered.timeSeries.window, order = c(1, 0, 1)))
(a4.w <- arima(Portfolio.unfiltered.timeSeries.window, order = c(1, 1, 1)))
(a5.w <- arima(Portfolio.unfiltered.timeSeries.window, order = c(5, 1, 0)))

# select and set model
series.predict.a1.w <- predict(a1.w, predictions)
series.predict.a2.w <- predict(a2.w, predictions)
series.predict.a3.w <- predict(a3.w, predictions)
series.predict.a4.w <- predict(a4.w, predictions)
series.predict.a5.w <- predict(a5.w, predictions)

# combine with source
series.predict.a1.w.combined <- ts(data = c(Portfolio.unfiltered.timeSeries.window, as.vector(series.predict.a1.w$pred)), start = startDate, frequency = 12)
series.predict.a2.w.combined <- ts(data = c(Portfolio.unfiltered.timeSeries.window, as.vector(series.predict.a2.w$pred)), start = startDate, frequency = 12)
series.predict.a3.w.combined <- ts(data = c(Portfolio.unfiltered.timeSeries.window, as.vector(series.predict.a3.w$pred)), start = startDate, frequency = 12)
series.predict.a4.w.combined <- ts(data = c(Portfolio.unfiltered.timeSeries.window, as.vector(series.predict.a4.w$pred)), start = startDate, frequency = 12)
series.predict.a5.w.combined <- ts(data = c(Portfolio.unfiltered.timeSeries.window, as.vector(series.predict.a5.w$pred)), start = startDate, frequency = 12)

# plotting all predictions against actual
plot(series.predict.a1.w.combined, ylim = c(0, 8000), col = "Red", ann = FALSE)
par(new = TRUE)
plot(series.predict.a2.w.combined, ylim = c(0, 8000), col = "Red", ann = FALSE)
par(new = TRUE)
plot(series.predict.a3.w.combined, ylim = c(0, 8000), col = "Red", ann = FALSE)
par(new = TRUE)
plot(series.predict.a4.w.combined, ylim = c(0, 8000), col = "Red", ann = FALSE)
par(new = TRUE)
plot(series.predict.a5.w.combined, ylim = c(0, 8000), col = "Red", ann = FALSE)
par(new = TRUE)
plot(Portfolio.unfiltered.timeSeries, ylim = c(0, 8000), col = "Black")

### Plot goes here - ARIMA Prediction versus Actual


#########################################################
# ARIMA - varying lag, compare results
#########################################################

(a4.w.111 <- arima(Portfolio.timeSeries.window, order = c(1, 1, 1)))
(a4.w.211 <- arima(Portfolio.timeSeries.window, order = c(2, 1, 1)))
(a4.w.311 <- arima(Portfolio.timeSeries.window, order = c(3, 1, 1)))
(a4.w.411 <- arima(Portfolio.timeSeries.window, order = c(4, 1, 1)))

series.predict.a4.w.111 <- predict(a4.w.111, 5)
series.predict.a4.w.211 <- predict(a4.w.211, 5)
series.predict.a4.w.311 <- predict(a4.w.311, 5)
series.predict.a4.w.411 <- predict(a4.w.411, 5)

series.predict.a4.w.111.combined <- ts(data = c(Portfolio.timeSeries.window, as.vector(series.predict.a4.w.111$pred)), start = c(2015, 01), frequency = 12)
series.predict.a4.w.211.combined <- ts(data = c(Portfolio.timeSeries.window, as.vector(series.predict.a4.w.211$pred)), start = c(2015, 01), frequency = 12)
series.predict.a4.w.311.combined <- ts(data = c(Portfolio.timeSeries.window, as.vector(series.predict.a4.w.311$pred)), start = c(2015, 01), frequency = 12)
series.predict.a4.w.411.combined <- ts(data = c(Portfolio.timeSeries.window, as.vector(series.predict.a4.w.411$pred)), start = c(2015, 01), frequency = 12)

plot(series.predict.a4.w.111.combined, ylim = c(0, 8000), col = "Red", ann = FALSE)
par(new = TRUE)
plot(series.predict.a4.w.211.combined, ylim = c(0, 8000), col = "Red", ann = FALSE)
par(new = TRUE)
plot(series.predict.a4.w.311.combined, ylim = c(0, 8000), col = "Red", ann = FALSE)
par(new = TRUE)
plot(series.predict.a4.w.411.combined, ylim = c(0, 8000), col = "Red", ann = FALSE)
par(new = TRUE)
plot(Portfolio.timeSeries, ylim = c(0, 8000), col = "Black")

### Plot goes here - ARIMA Prediction Varying Lag


#########################################################
# Time Series - forecast
#########################################################

# fit an ARIMA model
Portfolio.predictive.fit <- arima(Portfolio.timeSeries, order = c(1, 1, 1))

# predictive accuracy
library(forecast)
accuracy(Portfolio.predictive.fit)

# predict next 5 observations
#library(forecast)
forecast(Portfolio.predictive.fit, 6)
plot(forecast(Portfolio.predictive.fit, 6))

### Plot goes here - ARIMA Forecast

#########################################################
# Time Series - Seasonal
#########################################################

Portfolio.seasonal <- stl(Portfolio.timeSeries, s.window = "period")
plot(Portfolio.seasonal)

### Plot goes here - Time Series Seasonal


#########################################################
# Time Series - exponential model
#########################################################

# Automated forecasting using an exponential model
#library(forecast)
Portfolio.predictive.ets <- ets(Portfolio.timeSeries)
plot(Portfolio.predictive.ets)

### Plot goes here - NO PLOT YET


#########################################################
# Time Series - Automated ARIMA
#########################################################

# Automated forecasting using an ARIMA model
Portfolio.predictive.automated <- auto.arima(Portfolio.timeSeries)
plot(Portfolio.predictive.automated)

### Plot goes here - NO PLOT YET

