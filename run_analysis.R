## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## load data
X_train <- read.table("./UCI HAR Dataset-2/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset-2/train/y_train.txt")

X_test <- read.table("./UCI HAR Dataset-2/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset-2/test/y_test.txt")

subject_train <- read.table("./UCI HAR Dataset-2/train/subject_train.txt")
subject_test <- read.table("./UCI HAR Dataset-2/test/subject_test.txt")

activity_labels <- read.table("./UCI HAR Dataset-2/activity_labels.txt")
features <- read.table("./UCI HAR Dataset-2/features.txt")

## 1. Merges the training and the test sets to create one data set.



X_test <- read.table("./UCI HAR Dataset-2/test/X_test.txt", col.names=features[,2])
X_train <- read.table("./UCI HAR Dataset-2/train/X_train.txt", col.names=features[,2])
X <- rbind(X_test, X_train)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
interestingFeatures <- features[grep("(mean|std)\\(", features[,2]),]
mean_and_std <- X[,interestingFeatures[,1]]

# 3. Uses descriptive activity names to name the activities in the data set
y_test <- read.table("./UCI HAR Dataset-2/test/y_test.txt", col.names = c('activity'))
y_train <- read.table("./UCI HAR Dataset-2/train/y_train.txt", col.names = c('activity'))
y <- rbind(y_test, y_train)

labels <- read.table("./UCI HAR Dataset-2/activity_labels.txt")
for (i in 1:nrow(labels)) {
        code <- as.numeric(labels[i, 1])
        name <- as.character(labels[i, 2])
        y[y$activity == code, ] <- name
}
# 4. Appropriately labels the data set with descriptive activity names. 
X_with_labels <- cbind(y, X)
mean_and_std_with_labels <- cbind(y, mean_and_std)

# 5. Creates a second, independent tidy data set with the average of each variable 
#    for each activity and each subject. 
subject_test <- read.table("./UCI HAR Dataset-2/test/subject_test.txt", col.names = c('subject'))
subject_train <- read.table("./UCI HAR Dataset-2/train/subject_train.txt", col.names = c('subject'))
subject <- rbind(subject_test, subject_train)
averages <- aggregate(X, by = list(activity = y[,1], subject = subject[,1]), mean)

write.csv(averages, file="assignment.txt", row.names=FALSE)


