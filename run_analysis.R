## Getting Data - taking all the files and making 1 data table
setwd("./Getting and Cleaning Data/UCI HAR Dataset")

## Putting together test data

features <- read.table("features.txt", header = FALSE, sep = "", stringsAsFactors = FALSE)

activity_labels <- read.table("activity_labels.txt", header = FALSE,
                              stringsAsFactors = FALSE, 
                              col.names = c("Number", "Activity"))

#Build Data - Start with Subject Numbers
test_subject <- read.table("./test/subject_test.txt", 
                     header = FALSE, 
                     sep = "", 
                     stringsAsFactors = FALSE, 
                     col.names = "Subject")

#Add Activity Number
test_activity <- read.table("./test/y_test.txt", 
                           header = F, 
                           sep = "",
                           stringsAsFactors = FALSE,
                           col.names = "Activity")

#Add feature data - using feature labels

test_feature_data <- read.table("./test/X_test.txt", header = F, sep = "",
                                stringsAsFactors = FALSE, 
                                col.names = features[[2]])

#Complete test data
test_data <- cbind(test_subject, test_activity, test_feature_data)

#Remove intermediate data
test_subject = NULL
test_activity = NULL
test_feature_data = NULL

#Repeat steps above with train data
train_subject <- read.table("./train/subject_train.txt", 
                           header = FALSE, 
                           sep = "", 
                           stringsAsFactors = FALSE, 
                           col.names = "Subject")

#Add Activity Number
train_activity <- read.table("./train/y_train.txt", 
                            header = F, 
                            sep = "",
                            stringsAsFactors = FALSE,
                            col.names = "Activity")

#Add feature data - using feature labels
train_feature_data <- read.table("./train/X_train.txt", header = F, sep = "",
                                stringsAsFactors = FALSE, 
                                col.names = features[[2]])

#Complete train data
train_data <- cbind(train_subject, train_activity, train_feature_data)

#Remove intermediate data
train_subject = NULL
train_activity = NULL
train_feature_data = NULL

# Complete test and train data
data <- rbind(test_data, train_data)

#Remove sep train and test data from memory
test_data <- NULL
train_data <- NULL

#Extract mean and std data
means <- grep("mean", names(data))
stds <- grep("std", names(data))

data <- data[, c(1,2, means, stds)]

# Adding activity Labels to Dataframe
act_length <- sapply(split(data, data$Activity), nrow) 
Activity <- c(rep(activity_labels[,2], act_length))

# Order data via Activity and change Numbers to Activity name
data <- data[order(data$Activity),]
data$Activity <- Activity

#Order by subject number
data <- data[order(data$Subject),]


write.csv(data, file = "UCI_HAR_Dataset_tidy.csv")

## find the average of each measurement for each subject doing each activity
## use plyr package to subset and average
## numcolwise only takes the mean by numeric columns

library(plyr)

avg_data <- ddply(data, .(Subject, Activity), numcolwise(mean))

## Save average file as .txt
write.table(avg_data, file = "UNC_HAR_Dataset_tidy_avg.txt", row.name = FALSE)
