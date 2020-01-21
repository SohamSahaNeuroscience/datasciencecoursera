fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "HARdataset.zip")
unzip("HARdataset.zip")
subj_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
subj_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
activity_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "activity")
activity_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "activity")
data_train <- read.table("UCI HAR Dataset/train/X_train.txt")
data_test <- read.table("UCI HAR Dataset/test/X_test.txt")


##data merging
alldata <- rbind(data_train, data_test)

##Feature selection
features <- read.table("UCI HAR Dataset/features.txt")
names(alldata) <- features$V2

##Extract mean and SD
extr_mean_sd <- c(grep("mean\\(",names(alldata)),grep("std\\(", names(alldata)))
extr_mean_sd <- extr_mean_sd[order(extr_mean_sd)]
extracted_data <- alldata[,extr_mean_sd]

##Use activity names
allsubjects <- rbind(subj_train, subj_test)
allactivity <- rbind(activity_train, activity_test)
extracted_data <- cbind(alldata[,extr_mean_sd], allsubjects, allactivity)

actlabels <- read.table("UCI HAR Dataset/activity_labels.txt")
extracted_data$activity <- factor(extracted_data$activity, labels = actlabels$V2)

library(data.table)
dtalldata <- data.table(extracted_data)
tidydata <- dtalldata[,lapply(.SD,mean), by = .(activity, subject)]
write.table(tidydata, file = "tidydata.txt", row.names = FALSE)






