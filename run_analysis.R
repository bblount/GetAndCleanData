## Coursera.org
## Getting and Cleaning Data - Johns Hopkins University - Data Science Specialization
##
## This script downloads the data for the Getting and Cleaning Data Course Project

## NOTE for peer reviewer: For this project, use of chaining was limited to make it easier
## to explain the thought process in a step by step manner.  For a non-academic exercise, 
## more chaining will be leveraged.


## set the working directory
setwd("~/Documents/workspace/datasciencecoursera/GettingAndCleaningData/project")

## Load needed libraries
library(dplyr)

## The data for the project is located here: 
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
##
## The run_analysis.R script:
## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean and standard deviation for each measurement. 
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names. 
## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## 1) Merges the training and the test sets to create one data set.
     ##### Load the key files
     activity_labels <- read.table("data/UCI HAR Dataset/activity_labels.txt")
     features <- read.table("data/UCI HAR Dataset/features.txt")
     
     ##### Load the test files
     subject_test <- read.table("data/UCI HAR Dataset/test/subject_test.txt")
     X_test <- read.table("data/UCI HAR Dataset/test/X_test.txt")
     y_test <- read.table("data/UCI HAR Dataset/test/y_test.txt")
     
     ##### Load the train files
     subject_train <- read.table("data/UCI HAR Dataset/train/subject_train.txt")
     X_train <- read.table("data/UCI HAR Dataset/train/X_train.txt")
     y_train <- read.table("data/UCI HAR Dataset/train/y_train.txt")

     ##### Merge the data sets 
     X_combined <- rbind(X_test, X_train)
     y_combined <- rbind(y_test, y_train)
     subject_combined <- rbind(subject_test, subject_train)
       
     ## rename the V2 column to activity - this is to avoid confusion when later combining with the measurements that also has a V2 column
     activity_labels <- rename(activity_labels, activity_id = V1, activity = V2)
     
     
## 2) Extracts only the measurements on the mean and standard deviation for each measurement. 
       ## My working assumption is that any variable with mean or std was to be included in the set of variables in the data set.
       ## Therefore I performed a regular expression search, using grepl, and used a parameter to ignore case.  For example, 
       ## grepl would return true for both "mean" and "Mean".  As a result, I have 86 variables returned in my filter for 
       ## mean and standard deviation.
       X_mean_std_filter <- filter(features, grepl('mean|std', V2, ignore.case = TRUE))
       X_mean_std_result <- select(X_combined, X_mean_std_filter$V1)
       
       ## next combine columns from the disparate sets to make one data frame that can be used for adding labels and analysis
       subj_activity <- cbind(subject_combined, y_combined) # combine the subjects and activities (y)
       colnames(subj_activity) <- c("subject_id", "activity_id")
       result_subj_activity_feature <- cbind(subj_activity, X_mean_std_result) # add features measurements (X) to the subjects and activities
       

## 3) Uses descriptive activity names to name the activities in the data set
       ## merge in the activity labels and assign back to result data set
       result_subj_activity_feature <- merge(result_subj_activity_feature, activity_labels, by.x = "activity_id", by.y = "activity_id")
       ## drop the activity_id column and reorder columns in data set to have subject first, followed by activity, then the measurements
       result_subj_activity_feature <- result_subj_activity_feature[c(2,89,3:88)] 
       
       
## 4) Appropriately labels the data set with descriptive variable names. 
      ## rename columns using subject_id, activity and the measurement names from the features.txt file
      ## My working assumption is that the measurement labels have meaning abbreviations.  Specifically,
      ## we know that we have three axes (X, Y, Z), that there are accelerometer measurements (Acc), gyrosocpic measurements (Gyro),
      ## gravitational measurements(Gravity), etc., or combinations thereof.
      colnames(result_subj_activity_feature) <- c("subject_id", "activity", as.character(X_mean_std_filter$V2))
      Step4TidyDF <- result_subj_activity_feature


## 5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
      ## Use the result from Step 4, group by subject_id and activity and calculate the mean for each grouping
      ## This will produce a data set with 180 rows with 86 variables comprised of 2 group variables subject_id and activity, and 86 
      ## calculated means (one for each measurement).
      Step5TidyDF <- group_by(Step4TidyDF, subject_id, activity) %>% summarize_each(c("mean"))
     
     
     
     
     
