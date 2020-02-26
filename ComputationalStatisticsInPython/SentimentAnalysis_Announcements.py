#################################
# Load and clean data
# - Load libraries
# - Clean data
#################################

# changing directory
import os

# data frames
import pandas as pd

# linear algebra
import numpy as np


# Set working directory

os.chdir("../Data")
workingDirectory = os.getcwd()
workingDirectory

# Get data
announcementsFilePath = workingDirectory + "\\AnnouncementSentimentData.csv"
announcements = pd.read_csv(announcementsFilePath, sep=",", encoding='iso-8859-1')

# format date
announcements['AnnDate'] = pd.to_datetime(announcements['AnnDate'], format='%m/%d/%Y', yearfirst = True)

# sort by date
announcements = announcements.sort_values(['AnnDate'] , ascending=True)


#################################
# Sentime Analysis
#################################

# add column for guess, 
# column for correctness, match=1


