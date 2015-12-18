# run_analysis.R
# Jeffrey Gardner

setwd("C:/Users/JG186057/workspace-r/UCI HAR Dataset")

library("reshape2")
library("plyr")

activity_labels <- read.table("activity_labels.txt")
features <- read.table("features.txt", stringsAsFactors=FALSE)
train_set <- read.table("train/X_train.txt")
train_labels <- read.table("train/y_train.txt")
train_subject <- read.table("train/subject_train.txt")
test_set <- read.table("test/X_test.txt")
test_labels <- read.table("test/y_test.txt")
test_subject <- read.table("test/subject_test.txt")

train_set <- cbind(train_subject, train_labels, train_set)
test_set <- cbind(test_subject, test_labels, test_set)

data_set <- rbind(train_set, test_set)

colnames(data_set) <- c("subject", "activity", features[,2])

data_set$activity <- activity_labels[,2][match(data_set$activity, activity_labels[,1])]

data_set1 <- data_set[,c(1,2,grep("mean\\(\\)|std\\(\\)", colnames(data_set)))]

dataMelt <- melt(data_set, id=c("subject", "activity"),
	measure.vars=colnames(data_set1[,3:ncol(data_set1)]))

tidyData <- aggregate(dataMelt[,4], list(dataMelt$subject, dataMelt$activity, dataMelt$variable), mean)

colnames(tidyData ) <- c("subject", "activity", "variable", "mean")

tidyData <- tidyData[order(tidyData$subject, tidyData$activity, tidyData$variable),]

write.table(tidyData, file = "tidyData.txt", append = FALSE, quote = TRUE, sep = " ",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE,
            col.names = TRUE, qmethod = c("escape", "double"),
            fileEncoding = "")
