# Getting and Cleaning Data
Jeffrey Gardner

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

You should create one R script called run_analysis.R that does the following. 
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


# Set the working directory
```
setwd("C:/Users/JG186057/workspace-r/UCI HAR Dataset")
library("reshape2")
library("plyr")
```

# Import all of the necessary data
```
activity_labels <- read.table("activity_labels.txt")
features <- read.table("features.txt", stringsAsFactors=FALSE)
train_set <- read.table("train/X_train.txt")
train_labels <- read.table("train/y_train.txt")
train_subject <- read.table("train/subject_train.txt")
test_set <- read.table("test/X_test.txt")
test_labels <- read.table("test/y_test.txt")
test_subject <- read.table("test/subject_test.txt")
```

# Merges the training and the test sets to create one data set.
```
train_set <- cbind(train_subject, train_labels, train_set)
test_set <- cbind(test_subject, test_labels, test_set)
data_set <- rbind(train_set, test_set)
```

# Uses descriptive activity names to name the activities in the data set
```
colnames(data_set) <- c("subject", "activity", features[,2])
```

# Appropriately labels the data set with descriptive variable names. 
```
data_set$activity <- activity_labels[,2][match(data_set$activity, activity_labels[,1])]
```

# Extracts only the measurements on the mean and standard deviation for each measurement. 
```
data_set1 <- data_set[,c(1,2,grep("mean\\(\\)|std\\(\\)", colnames(data_set)))]
```

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
```
dataMelt <- melt(data_set, id=c("subject", "activity"),
	measure.vars=colnames(data_set1[,3:ncol(data_set1)]))
tidyData <- aggregate(dataMelt[,4], list(dataMelt$subject, dataMelt$activity, dataMelt$variable), mean)
colnames(tidyData ) <- c("subject", "activity", "variable", "mean")
tidyData <- tidyData[order(tidyData$subject, tidyData$activity, tidyData$variable),]
```

# Writes the tidy data table to a text file for output
```
write.table(tidyData, file = "tidyData.txt", append = FALSE, quote = TRUE, sep = " ",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE,
            col.names = TRUE, qmethod = c("escape", "double"),
            fileEncoding = "")
```
