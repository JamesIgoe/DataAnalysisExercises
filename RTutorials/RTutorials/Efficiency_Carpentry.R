####################################
#
# Efficiency - Data Carpentry
# 
####################################

####################################
# setup
####################################

# clear memory between changes
rm(list = ls())

# update all packages
update.packages(ask = FALSE)

# set Working directory
getwd()
#setwd('../Data')
#setwd('../Documents/Visual Studio 2013/Projects/RTutorials/TutorialsPoint/Data')
#setwd('H:/Personal/Code/CodeDotNet/RTutorials/TutorialsPoint/Data')


####################################
# Load modules
####################################

library("tibble")
library("tidyr")
library("stringr")
library("readr")
library("dplyr")
library("data.table")


####################################
# Load modules
####################################

#install.packages("RSQLite", dependencies = TRUE)
library("RSQLite")

#install.packages("ggmap", dependencies = TRUE)
library("ggmap")


####################################
# tibble
####################################

library("tibble")
df_base <- data.frame(colA = "A", colB = "B")


# Try and guess the output of the following commands:

# neatly prints data frame
print(df_base)

# prints column A
df_base$colA

# NULL is more than 1 column, but if only one prints
df_base$col

# guessed error, produced NULL
df_base$colC


####################################
# Tidying data with tidyr and RegEx
# Not available in R 3.4
####################################

#install.packages("efficient", dependencies = TRUE)
#library("efficient")

fileName <- 'OECD - Quality of Life.csv'
tidy.df <- read.csv(fileName)
str(tidy.df)

tidy.df.tall <- gather(data = tidy.df, key, value, -Country)
str(tidy.df.tall)
head(tidy.df.tall)


####################################
# 
####################################



