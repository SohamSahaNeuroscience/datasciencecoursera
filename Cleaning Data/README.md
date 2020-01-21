Script involves the following stages:

Downloads to R ids and descriptions for features being measured in experiment from file features.txt.
Loads the measurements from X_train.txt as a data frame
Column names are updated to be more user friendly using features description. 
Appropriately label the data set with descriptive variable names of Course Project.
Activity labels and subjects for measurements are also loaded from files train/y_train.txt and train/subject_train.txt and added to data frame as a separated columns.

Same process for test dataset and finally 2 rows of 2 data frames are merged together to form are data frame with complete data.
Merge the training and the test sets to create one data set of assignment.

To extract measurements that involves only mean and standard deviation values script uses grep, that finds column names that includes "mean()" or "std()". 
After that all new data frame with only necessary columns is created. 
Extract only the measurements on the mean and standard deviation for each measurement of assignment.

To provide descriptive values for activity labels a new variable "activitylabel" is added to dataset, that is a factor variable with levels mentioned in file activity_labels.txt.
Use descriptive activity names to name the activities in the data set of assignment.

Creates a melted data frame using activity label and subject as ids, after that mean values for all variables are calculated grouped by activity and subject and tidy data frame is created. 
Makes new data.table called tidydata by averaging of the each variable for each activity and each subject. 
Is not subsetting the data (no “i”), is calculating mean for all the columns (.SD = all columns exept ones used in “by” argument) using lapply in “j”, calculating by two groups(columns activity and subject) in “by” using .()
Writing the tidydata set in titydata.txt file.

