## Code to merge training and test data into one data set
setwd("/Users/andreasfelix/DataScience/Excercises/UCI HAR Dataset/combined")

# Loading required libraries
library(plyr)
library(dplyr)

# Reading in labels
activity_labels <- read.csv("activity_labels.txt",sep=" ",header=F)
names(activity_labels) <- c("activityID", "activityDes")
activity_labels

# Reading in features
features<- read.table("features.txt")

# Reading in training data
X_train <- read.table("X_train.txt")
subject_train <- read.table("subject_train.txt")
y_train <- read.table("y_train.txt")

# Column-bind train data, subject, excercise, data
train<- cbind(subject_train, y_train, X_train)

# Reading in test data
X_test<- read.table("X_test.txt")
subject_test<- read.table("subject_test.txt")
y_test<- read.table("y_test.txt")

# Column-bind test data, subject, excercise, data
test<- cbind(subject_test, y_test, X_test)

# Row bind train and test data sets
DF<-rbind(train,test)

# Assign meaningful variables names
names(DF)<-c("subjectID","activityID",as.character(features$V2))

# Join activity description
namedDF<- join(DF,activity_labels,by='activityID')

# Retain only mean and standard deviation

# First some data cleansing is necessary
to.remove <- as.character(features$V2[duplicated(features$V2)])
reducedDF<-namedDF

reducedDF <- reducedDF[, !(colnames(reducedDF) %in% to.remove)]

# Select only columns with mean and standard deviation
subsetDF <- select(reducedDF,contains("subjectID"), contains("activityDes"), contains("mean"), contains("std"))

# Create a second dataset with average of each activity and subject

tidyDF<- aggregate(subsetDF, by=list(subsetDF$subjectID, subsetDF$activityDes),  FUN=mean)

# Fix columns created with the aggregate function
tidyDF$subjectID <- NULL
tidyDF$activityDes <- NULL
colnames(tidyDF)[1:2]<-c("subjectID","activityFactor")
str(tidyDF)

# Write final dataset to file
write.table(tidyDF, "tidy_data.txt", row.name=FALSE)




