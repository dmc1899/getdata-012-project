# Getting and Cleaning Data - Course Project
This repo provides a codeBook describing both the location of the source data and an explanation of the variables and summary process performed and run_analysys.R script containing the sequence of steps to read in, summarise and output the summary data.

# Setup
The run_analysis.R script requires the use of two R libraries - dplyr and tidyr.  Both libraries should be installed before the script is executed.  The commands to issue are:
```
install.packages("dplyr")
install.packages("tidyr")
```

The run_analysis.R script requires the source dataset to be downloaded an unpacked in the working directory which contains the script.  The steps to follow are:
* Browse to https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
* Download the file and unzip to the same location as run_analysis.R

# Execution
The main driver function in the run_analysis.R script is `run_analysis`.  To execute the script the commands to issue are:
```
source("./run_analysis.R")
output_df <- run_analysis()
```
To view the output within R Studio, the command to issue is:
```
View(output_df)
```
To write the output to a CSV file for viewing in a third-party application, such as Excel, the command to issue is:
```
write.table(output_df,file="output_df.csv", row.names=FALSE, sep=",")
```

