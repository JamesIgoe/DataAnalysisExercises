################################################
# Optimized Data Storage and Loading
#
# Efficient R Programming: A Practical Guide to Smarter Programming
# https://kindle.amazon.com/work/efficient-programming-practical-guide-smarter-ebook/B01MYXOY04/B01N2RTX9Q
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
# load libraries for data loading
#
# readr
# data.table
# rio
# 
################################################

# readr - 
install.packages("readr", dependencies = TRUE)
library("readr")

# data.table - 
install.packages("data.table", dependencies = TRUE)
library("data.table")

# rio
install.packages("rio", dependencies = TRUE)
library("rio")


################################################
# load libraries for compression
#
# feather - python and R
# RProtoBuf - from Google
# 
################################################

# feather
install.packages("feather", dependencies = TRUE)
library("feather")

# RProtoBuf - compression from google
install.packages("RProtoBuf", dependencies = TRUE)
library("RProtoBuf")


################################################
# Load data, compare performance
################################################

# set Working directory
getwd()
setwd('../Data')

fileName <- "BigFiveScoresByState.csv"
fileName <- "Hofstede.csv"

# standard file load
Politics.csv <- read.csv(fileName, na.strings = c("", "NA"))

# rio implementation
file <- system.file(fileName, package = "efficent")
Politics.rio <- import(file)

# readr implementation
Politics.readr <- readr::read_csv(fileName)

# readr implementation
Politics.dt <- data.table::fread_csv(fileName)


################################################
# Write data, compare performance
################################################






