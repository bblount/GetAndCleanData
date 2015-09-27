## Coursera.org
## Getting and Cleaning Data - Johns Hopkins University - Data Science Specialization
##

## This script downloads the data for the Getting and Cleaning Data Course Project
## set the working directory
setwd("~/Documents/workspace/datasciencecoursera/GettingAndCleaningData/project")

## check if the data directory exists and create it if it does not exist
if (!file.exists("data")) {
  dir.create("data")
}

## set fileUrl to hold the value of the URL and file to download
## The data is located here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## download the file and save the date of the download
download.file(fileUrl, destfile = "./data/UCI_HAR_Dataset.zip", method = "curl")
dateDownloaded <- date()

## unzip the file
unzip("./data/UCI_HAR_Dataset.zip", exdir = "./data")
