# Getting and Cleaning Data Course Project

## Introduction

In this repo, the following files are available:

* run_analysis.R : R script to merge and clean the original datasets
* Tidy.txt : the clean data extracted from the original datasets using run_analysis.R
* CodeBook.md : the CodeBook explaining the various variables in the datasets
* README.md : overall project and code discussion

## Project Description
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.
 
You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 

1. a tidy data set as described below, 
2. a link to a Github repository with your script for performing the analysis, and 
3. a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. 
4. You should also include a README.md in the repo with your scripts. 

This repo explains how all of the scripts work and how they are connected.  

One of the most exciting areas in all of data science right now is wearable computing - see for example [this article](http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/) . 
Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. 
The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 
A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

You should create one R script called run_analysis.R that does the following. 

* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive variable names. 
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## run_analysis.R script 

### Required Libraries
library(dplyr)
library(data.table)

### Loading the datasets

```R
features <- read.table("UCI HAR Dataset/features.txt")
activities <- read.table("UCI HAR Dataset/activity_labels.txt")

# Read training data
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
activityTrain <- read.table("UCI HAR Dataset/train/y_train.txt")
featuresTrain <- read.table("UCI HAR Dataset/train/X_train.txt")

# Read test data
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
activityTest <- read.table("UCI HAR Dataset/test/y_test.txt")
featuresTest <- read.table("UCI HAR Dataset/test/X_test.txt") 
```

### 1. Merges the training and the test sets to create one data set.

```R
subjectTrainTest <- rbind(subjectTrain, subjectTest)
activityTrainTest <- rbind(activityTrain, activityTest)
featuresTrainTest <- rbind(featuresTrain, featuresTest)

# Set column names
colnames(subjectTrainTest) <- "Subject"
colnames(activityTrainTest) <- "Activity"
colnames(featuresTrainTest) <- features$V2

mergedData <- cbind(featuresTrainTest,activityTrainTest,subjectTrainTest)
```

### 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

```R
# Extract columns indexes with mean and std substring in the name
columnsMeanSTD <- grep(".*Mean.*|.*Std.*", names(mergedData), ignore.case=TRUE, value=TRUE)
columnsMeanSTD <- union(c("Subject","Activity"), columnsMeanSTD)
mergedData <- mergedData[,columnsMeanSTD]
```

### 3. Uses descriptive activity names to name the activities in the data set

```R
mergedData$Activity <- as.character(mergedData$Activity)
for (i in 1:6) {
    mergedData$Activity[mergedData$Activity == i] <- as.character(activityLabels[i,2])
}
mergedData$Activity <- as.factor(mergedData$Activity)
```

### 4. Appropriately labels the data set with descriptive variable names. 

We start by looking at the original column names: 

```R
names(mergedData)
```

```
 [1] "Subject"                              "Activity"                            
 [3] "tBodyAcc-mean()-X"                    "tBodyAcc-mean()-Y"                   
 [5] "tBodyAcc-mean()-Z"                    "tBodyAcc-std()-X"                    
 [7] "tBodyAcc-std()-Y"                     "tBodyAcc-std()-Z"                    
 [9] "tGravityAcc-mean()-X"                 "tGravityAcc-mean()-Y"                
[11] "tGravityAcc-mean()-Z"                 "tGravityAcc-std()-X"                 
[13] "tGravityAcc-std()-Y"                  "tGravityAcc-std()-Z"                 
[15] "tBodyAccJerk-mean()-X"                "tBodyAccJerk-mean()-Y"               
[17] "tBodyAccJerk-mean()-Z"                "tBodyAccJerk-std()-X"                
[19] "tBodyAccJerk-std()-Y"                 "tBodyAccJerk-std()-Z"                
[21] "tBodyGyro-mean()-X"                   "tBodyGyro-mean()-Y"                  
[23] "tBodyGyro-mean()-Z"                   "tBodyGyro-std()-X"                   
[25] "tBodyGyro-std()-Y"                    "tBodyGyro-std()-Z"                   
[27] "tBodyGyroJerk-mean()-X"               "tBodyGyroJerk-mean()-Y"              
[29] "tBodyGyroJerk-mean()-Z"               "tBodyGyroJerk-std()-X"               
[31] "tBodyGyroJerk-std()-Y"                "tBodyGyroJerk-std()-Z"               
[33] "tBodyAccMag-mean()"                   "tBodyAccMag-std()"                   
[35] "tGravityAccMag-mean()"                "tGravityAccMag-std()"                
[37] "tBodyAccJerkMag-mean()"               "tBodyAccJerkMag-std()"               
[39] "tBodyGyroMag-mean()"                  "tBodyGyroMag-std()"                  
[41] "tBodyGyroJerkMag-mean()"              "tBodyGyroJerkMag-std()"              
[43] "fBodyAcc-mean()-X"                    "fBodyAcc-mean()-Y"                   
[45] "fBodyAcc-mean()-Z"                    "fBodyAcc-std()-X"                    
[47] "fBodyAcc-std()-Y"                     "fBodyAcc-std()-Z"                    
[49] "fBodyAcc-meanFreq()-X"                "fBodyAcc-meanFreq()-Y"               
[51] "fBodyAcc-meanFreq()-Z"                "fBodyAccJerk-mean()-X"               
[53] "fBodyAccJerk-mean()-Y"                "fBodyAccJerk-mean()-Z"               
[55] "fBodyAccJerk-std()-X"                 "fBodyAccJerk-std()-Y"                
[57] "fBodyAccJerk-std()-Z"                 "fBodyAccJerk-meanFreq()-X"           
[59] "fBodyAccJerk-meanFreq()-Y"            "fBodyAccJerk-meanFreq()-Z"           
[61] "fBodyGyro-mean()-X"                   "fBodyGyro-mean()-Y"                  
[63] "fBodyGyro-mean()-Z"                   "fBodyGyro-std()-X"                   
[65] "fBodyGyro-std()-Y"                    "fBodyGyro-std()-Z"                   
[67] "fBodyGyro-meanFreq()-X"               "fBodyGyro-meanFreq()-Y"              
[69] "fBodyGyro-meanFreq()-Z"               "fBodyAccMag-mean()"                  
[71] "fBodyAccMag-std()"                    "fBodyAccMag-meanFreq()"              
[73] "fBodyBodyAccJerkMag-mean()"           "fBodyBodyAccJerkMag-std()"           
[75] "fBodyBodyAccJerkMag-meanFreq()"       "fBodyBodyGyroMag-mean()"             
[77] "fBodyBodyGyroMag-std()"               "fBodyBodyGyroMag-meanFreq()"         
[79] "fBodyBodyGyroJerkMag-mean()"          "fBodyBodyGyroJerkMag-std()"          
[81] "fBodyBodyGyroJerkMag-meanFreq()"      "angle(tBodyAccMean,gravity)"         
[83] "angle(tBodyAccJerkMean),gravityMean)" "angle(tBodyGyroMean,gravityMean)"    
[85] "angle(tBodyGyroJerkMean,gravityMean)" "angle(X,gravityMean)"                
[87] "angle(Y,gravityMean)"                 "angle(Z,gravityMean)"  
```

From the list above we can rename the following:

```R
names(mergedData)<-gsub("std()", "SD", names(mergedData))
names(mergedData)<-gsub("mean()", "MEAN", names(mergedData))
names(mergedData)<-gsub("^t", "time", names(mergedData))
names(mergedData)<-gsub("^f", "frequency", names(mergedData))
names(mergedData)<-gsub("Acc", "Accelerometer", names(mergedData))
names(mergedData)<-gsub("Gyro", "Gyroscope", names(mergedData))
names(mergedData)<-gsub("Mag", "Magnitude", names(mergedData))
names(mergedData)<-gsub("BodyBody", "Body", names(mergedData))
names(mergedData)<-gsub("freq()", "Frequency", names(mergedData))
```

to make variables name clearer (more descriptive).

### 5. From the data set in step 4, creates a second, independent tidy data set with 

```R
# reorder mergedData with variable means sorted by subject and Activity
mergedData$Subject <- as.factor(mergedData$Subject)
mergedData <- data.table(mergedData)

tidyData <- aggregate(. ~Subject + Activity, mergedData, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "Tidy.txt", row.names = FALSE)
```

