#Study Design

The input dataset for this analysis project is the UCI HAR Dataset available from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.  

The initial UCI HAR Dataset contained a TEST set of subjects and observations;  a TRAIN set of subjects and observations; a list of activities and a set of features. This information was combined to prepare a unified dataset, which included 561 variables recorded for each of the subjects.  The files which represent this information were as follows:

* features.txt': List of all variables measured.

* activity_labels.txt': Lookup data to map identifier and description of the activity performed.

* train/X_train.txt': Training set of observations.

* train/y_train.txt': Training labels.

* train/subject_train.txt': Identifier of each subject for which the observations belong.

* test/X_test.txt': Test set of observations.

* test/y_test.txt': Test labels.

* test/subject_test.txt': Identifier of each subject for which the observations belong.

An additional features_info.txt file is contained in this dataset which includes a detailed description of each of the variables.

From the 561 variables in the unified dataset, only those variables which represent a measurement of the mean or standard devation for each measurement were extracted with the other variables being ignored.  The number of columns representing the mean was 46 and the number of columns representing the standard deviation was 33, leaving a total number of 79.  

The columns in the original dataset which represented the mean were identifed by matching `mean()` and ignoring all other variations, meaning the following variables, which although contained the term `Mean` were excluded:
* angle(tBodyAccMean,gravity)
* angle(tBodyAccJerkMean),gravityMean)
* angle(tBodyGyroMean,gravityMean)
* angle(tBodyGyroJerkMean,gravityMean)
* angle(X,gravityMean)
* angle(Y,gravityMean)
* angle(Z,gravityMean)

Two additional variables were included in the dataset, one for the subject and another for the activity that was performed. This created a dataset of 10299 observations of 81 variables.

This dataset was then grouped by the activity being performed and the subject performing the activity and the average of each of the mean and standard deviation variables for that subject's activity were calculated.

The final output dataset that has been produced includes 180 observations of 81 variables.

#Code Book

The final output dataset includes variables from three different categories - Measurement Variables, Subject Identifier Variable and Activity Identifier Variable.

**Variable 1 - `activity_name`**
This is the Activity Identifier variable that provides a text value that represents the name of the activity performed by the subject.

**Variable 2 - `subject`**
This is the Subject Identifier variable that provides a numeric value that represents the identifier of the subject that performed the activity

**Variables 3:81**
These variables are Measurement Variables that provides numeric values that represent the average of each of the variables read from the UCI HAR Dataset, for each activity, for each subject.

The variables from the original study have been enhanced and enriched for readability.  Namely, the following transformations have been performed:

* Special characters such as '()/-_' have been removed
* `t` has been replaced with `Time`
* `f` has been replaced with `Frequency`
* `Mag` has been replaced with `Magnitude`
* `GyroJerk` has been replaced with `AngularAcceleration`
* `Gyro` has been replaced with `AngularSpeed`
* `mean` has been replaced with `Mean`
* `std` has been replaced with `StdDeviation`
* `AverageOf` has been prefixed to the variable name

For example, the original variable `tBodyAcc-mean()-X` from the UCI HAR Dataset has been averaged for each activity and subject and the variable has been renamed as `AverageOfTimeBodyAccelerationMeanX`.  So, columns 3, 4 and 5 will contain the following variable names:

`AverageOfTimeBodyAccelerationMeanX`	
This represents the average of TimeBodyAccelerationMean of direction X, for both test and training data sets, for each activity, for each subject.

`AverageOfTimeBodyAccelerationMeanY`
This represents the average of TimeBodyAccelerationMean of direction Y, for both test and training data sets, for each activity, for each subject.

`AverageOfTimeBodyAccelerationMeanZ`	
This represents the average of TimeBodyAccelerationMean of direction Z, for both test and training data sets, for each activity, for each subject	

This pattern continues up to and including variable 81.
