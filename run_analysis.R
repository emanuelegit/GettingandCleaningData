library(data.table)
library(dplyr)

setwd("C:/Users/Emanuele/Dropbox/R/project")

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

### 1. Merges the training and the test sets to create one data set.
subjectTrainTest <- rbind(subjectTrain, subjectTest)
activityTrainTest <- rbind(activityTrain, activityTest)
featuresTrainTest <- rbind(featuresTrain, featuresTest)

# Set column names
colnames(subjectTrainTest) <- "Subject"
colnames(activityTrainTest) <- "Activity"
colnames(featuresTrainTest) <- features$V2

mergedData <- cbind(featuresTrainTest,activityTrainTest,subjectTrainTest)

### 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# Extract columns indexes with mean and std substring in the name
columnsMeanSTD <- grep(".*Mean.*|.*Std.*", names(mergedData), ignore.case=TRUE, value=TRUE)
columnsMeanSTD <- union(c("Subject","Activity"), columnsMeanSTD)
mergedData <- mergedData[,columnsMeanSTD]

### 3. Uses descriptive activity names to name the activities in the data set
mergedData$Activity <- as.character(mergedData$Activity)
for (i in 1:6) {
    mergedData$Activity[mergedData$Activity == i] <- as.character(activityLabels[i,2])
}
mergedData$Activity <- as.factor(mergedData$Activity)

### 4. Appropriately labels the data set with descriptive variable names. 
names(mergedData)<-gsub("std()", "SD", names(mergedData))
names(mergedData)<-gsub("mean()", "MEAN", names(mergedData))
names(mergedData)<-gsub("^t", "time", names(mergedData))
names(mergedData)<-gsub("^f", "frequency", names(mergedData))
names(mergedData)<-gsub("Acc", "Accelerometer", names(mergedData))
names(mergedData)<-gsub("Gyro", "Gyroscope", names(mergedData))
names(mergedData)<-gsub("Mag", "Magnitude", names(mergedData))
names(mergedData)<-gsub("BodyBody", "Body", names(mergedData))
names(mergedData)<-gsub("freq()", "Frequency", names(mergedData))

### 5. From the data set in step 4, creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject

# reorder mergedData with variable means sorted by subject and Activity
mergedData$Subject <- as.factor(mergedData$Subject)
mergedData <- data.table(mergedData)

tidyData <- aggregate(. ~Subject + Activity, mergedData, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "Tidy.txt", row.names = FALSE)
