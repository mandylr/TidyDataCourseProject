# TidyDataCourseProject

### run_analysis Summary

1. Load and merge test and train set
    - via a load_data() function that takes "test" and "train" as the inputs and locates the .txt files from the test and train folders within the working directory. These include the subject_, X_, and y_ files. 
    
2. Add subject, activity, and feature labels to column names
    - Load feature names from features.txt file provided 
    
3. Subset only the mean and standard deviation features from data set
    - Using grep() function to locate column names with "mean" or "std" in the name

4. Organize data by activity number and replace activity number with acitivy name
    - Loading activity_labels.txt and extracting the activity name and replacing the number in the data frame with the name from the list via:
```{r} 
    data$Activity <- act[data$Activity]
```

- Where act is the list of activity names where act[n] corresponds to the name of activity n

5. Order the data by subject # (1:30)
    - via the order() function
    
6. Take the mean of each feature for each activity and each subject
    - Using the plyr package
```{r}
    avg_data <- ddply(data, .(Subject, Activity), numcolwise(mean))
```

- This takes the average of each activity for each subject in all the numeric columns (i.e. the feaatures columns)