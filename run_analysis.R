library(dplyr)
library(tidyr)

run_analysis <- function() {
    ## This function acts as the driver, responsible for combining the composite training and test datasets and 
    ## returning the mean of each of the "mean/stddev" variables in a tidy dataset.

    ## Setup filename locations.
    column_names_file <- "UCI HAR Dataset/features.txt"; activity_labels_file <- "UCI HAR Dataset/activity_labels.txt"
    
    ## Read in the names of the variables and the names of the activities used.
    measurement_names <- prepare_column_names(column_names_file)
    activity_names <- prepare_activity_labels(activity_labels_file)

    ## Prepare the test category dataset, combining the results, activities and subject.
    result_file <- "UCI HAR Dataset/test/X_test.txt"; activity_file <- "UCI HAR Dataset/test/y_test.txt"; subject_file <- "UCI HAR Dataset/test/subject_test.txt"
    test_category <- prepare_category_results(result_file, activity_file, subject_file, activity_names, measurement_names)

    ## Prepare the training category dataset, combining the results, activities and subject.
    result_file <- "UCI HAR Dataset/train/X_train.txt"; activity_file <- "UCI HAR Dataset/train/y_train.txt"; subject_file <- "UCI HAR Dataset/train/subject_train.txt"
    train_category <- prepare_category_results(result_file,activity_file,subject_file,activity_names,measurement_names)

    ## Combine the test and training and extract only those columns for mean or standard devation figures.
    test_and_train_mean_std_vars <- return_clean_mean_std_vars_only(rbind(test_category, train_category))

    ## Return a tidy dataset containing the mean of the mean/std dev variables, by activity and subject.
    return(return_mean_by_activity_and_subject(test_and_train_mean_std_vars))
}

return_mean_by_activity_and_subject <- function(dataframe) {
    names(dataframe) <- gsub('mean', 'Mean', names(dataframe))
    names(dataframe) <- gsub('std', 'StdDeviation', names(dataframe))
    
    return(summarise_each(group_by(dataframe, activity_name, subject), funs(mean)))
}

return_clean_mean_std_vars_only <- function(all_vars) {
    ## This function extracts only the variables for mean or standard devation and include the subject and activity name.
    ## The column names are then renamed to include a meaningful prefix, for the final tidy dataset.
    
    subset_vars_df <- select(all_vars, matches("(subject)+|(activity_name)+|(mean)+|(std)+", ignore.case = FALSE))
    col_names_df <- data.frame(colname = colnames(subset_vars_df))
    
    enriched_df <- mutate(col_names_df, colnameadjusted = paste("AverageOf", colname, sep=''))
    colnames(subset_vars_df)[2:(ncol(subset_vars_df)-1)] <- enriched_df[2:(nrow(enriched_df)-1),"colnameadjusted"]
    
    return(subset_vars_df)
}

prepare_column_names <- function(column_names_file) {
    tempdf<-(as.data.frame(mutate(tbl_df(read.table(column_names_file, header = FALSE, sep = "")), unique_col = gsub("[^0-9A-Za-z///' ]", "",V2))))
    newdf <- mutate(tbl_df(tempdf), unique_col = gsub('^t', 'Time', unique_col))
    newdf <- mutate(tbl_df(newdf), unique_col = gsub('^f', 'Frequency', unique_col))
    newdf <- mutate(tbl_df(newdf), unique_col = gsub('Acc', 'Acceleration', unique_col))
    newdf <- mutate(tbl_df(newdf), unique_col = gsub('Mag', 'Magnitude', unique_col))
    newdf <- mutate(tbl_df(newdf), unique_col = gsub('GyroJerk', 'AngularAcceleration', unique_col))
    newdf <- mutate(tbl_df(newdf), unique_col = gsub('Gyro', 'AngularSpeed', unique_col))
    
    return(as.data.frame(newdf))    
}

prepare_activity_labels <- function(activity_labels_file) {
    return(tbl_df(read.table(activity_labels_file, header = FALSE, sep = "",col.names=c("activity_id", "activity_name"))))
}

prepare_category_results <- function(result_file, activity_file, subject_file, activity_labels, measurement_names) {
    result_data <- read.table(result_file, header = FALSE, sep = "")
    
    ## Rename the columns to their meaningful names.
    colnames(result_data) <- measurement_names[,3]
    
    ## Read in exercise labelling data.
    activities <- read.table(activity_file, header = FALSE, sep = "")
    
    ## Add the activity of the test to the dataset in the first column.
    activity_result_data <- cbind(activities, result_data)
    
    ## Rename the activity ID column to something more appropriate.
    colnames(activity_result_data)[1] <- "activity_id"
    
    ## Join the activity reference data set with the activity test data set
    enriched_activity_df <- as.data.frame(inner_join(activity_result_data, activity_labels, by ="activity_id" ))
    
    ## Read in the subjects involved in the event.
    subjects <- read.table(subject_file, header = FALSE, sep = "")
    
    ## Add the subject of the test to the dataset in the first column
    subject_activity_data <- cbind(subjects, enriched_activity_df)
    
    ## Rename the first column to something appropriate
    colnames(subject_activity_data)[1] <- "subject"
    
    ## Unduplicated column names provided in Features.txt: 561
    ## Dedpulicated column names returned by function below: 477
    ## Total duplicate columns in dataset: 84
    
    return(subject_activity_data[, !duplicated(colnames(subject_activity_data))])
}