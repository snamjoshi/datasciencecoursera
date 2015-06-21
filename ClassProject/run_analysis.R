## Set working directory and load libraries
# setwd("[PATH TO DATA FOLDER]/UCI HAR Dataset")

library(dplyr)
library(reshape2)

## Load labels and features
activity_labels <- read.table("activity_labels.txt", sep = "")
features <- read.table("features.txt", sep = "")

## Load test data
subject_test <- read.delim("test/subject_test.txt", header = FALSE)
X_test <- read.table("test/X_test.txt", sep = "")
Y_test <- read.table("test/y_test.txt", sep = "")

## Load train data
subject_train <- read.delim("train/subject_train.txt", header = FALSE)
X_train <- read.table("train/X_train.txt", sep = "")
Y_train <- read.table("train/y_train.txt", sep = "")

## 1. Merges the training and the test sets to create one data set.
X_test <- cbind(subject_test, X_test)
X_train <- cbind(subject_train, X_train)
fullData <- rbind(X_test, X_train)

## 4. Appropriately labels the data set with descriptive variable names. 
columnNames <- append(as.character(features$V2), "Subject", 0)
colnames(fullData) <- columnNames

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
fullDataMeanStd <- fullData[ ,c(1, grep("-mean()|-Mean()|-std()", columnNames))]

## 3. Uses descriptive activity names to name the activities in the data set
allActivities <- rbind(Y_test, Y_train)
allActivities <- cbind(allActivities, id = 1:length(allActivities$V1))
allActivities <- merge(allActivities, activity_labels)
allActivities <- arrange(allActivities, id)
allActivities <- allActivities[,-c(1,2)]

fullDataMeanStd <- cbind(Activity = allActivities, fullDataMeanStd)

## 5. From the data set in step 4, creates a second, independent tidy data set with the 
## average of each variable for each activity and each subject.

cleanDat <- melt(fullDataMeanStd, id = c("Activity", "Subject")) 
cleanDat <- aggregate(cleanDat$value, list(Activity = cleanDat[,1], Subject = cleanDat[,2], Feature = cleanDat[,3]), mean)
colnames(cleanDat) <- c("Activity", "Subject", "Feature", "Mean")

write.table(cleanDat, "tidyData.txt", row.names = FALSE)
