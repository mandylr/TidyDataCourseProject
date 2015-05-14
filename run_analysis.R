## Getting Data - taking all the files and making 1 data table
setwd("./Getting_and_Cleaning_Data/UCI HAR Dataset")

## Fucntion to load and merge test and train data, 
## Note: The first column is subject # and the last column is the activity

load_data <- function(test = "test", train = "train"){
    test_files <- list.files(test, pattern = '\\.txt', full.names = TRUE)
    test_data <- data.frame(matrix(ncol = 0, nrow = 2947))
    for(file in test_files){
        test_data <- cbind(test_data, read.table(file, 
                                      header = FALSE,
                                      sep = "",
                                      stringsAsFactors = FALSE,
                                      ))
    }
    
    train_files <- list.files(train, pattern = "\\.txt", full.names = TRUE)
    train_data <- data.frame(matrix(ncol = 0, nrow = 7352))
    for(file in train_files){
        train_data <- cbind(train_data, read.table(file, 
                                                 header = FALSE,
                                                 sep = "",
                                                 stringsAsFactors = FALSE,
        ))
    }
    
    rbind(test_data, train_data)
}

## Test and train data loaded
data <- load_data()

#Load features data for column names
features <- read.table("features.txt", header = FALSE, sep = "", stringsAsFactors = FALSE)

# Name the columns of data frame using features
colnames(data) <- c("Subject", features[[2]], "Activity")

#Extract mean and std data and re-order so columns are:
## Subject, Activity, mean variables, std variables
means <- grep("mean", names(data))
stds <- grep("std", names(data))

data <- data[, c(1,563, means, stds)]

#Laad the activity lables to rename the activity numbers with names
activity_labels <- read.table("activity_labels.txt", header = FALSE,
                              stringsAsFactors = FALSE, 
                              col.names = c("Number", "Activity"))
act <- activity_labels[[2]]

# Adding Activiy label to data by numerical order
data <- data[order(data$Activity),]
data$Activity <- act[data$Activity]

#Order by subject number
data <- data[order(data$Subject, data$Activity),]

## If you want the tidy data - not the averaged data, run code below:
#write.csv(data, file = "UCI_HAR_Dataset_tidy.csv")

## find the average of each measurement for each subject doing each activity
## use plyr package to subset and average
## numcolwise only takes the mean of numeric columns

library(plyr)

avg_data <- ddply(data, .(Subject, Activity), numcolwise(mean))

## Save average file as .txt
write.table(avg_data, file = "UNC_HAR_Dataset_tidy_avg.txt", row.name = FALSE)
