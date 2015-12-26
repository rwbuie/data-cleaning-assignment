The accompanying script, run_analysis.R, is part of a coursera course assignment, "getting and cleaning data"

The instructions provided are as follows:

-----------------------------------------------

You should create one R script called run_analysis.R that does the following. 
1.Merges the training and the test sets to create one data set.
2.Extracts only the measurements on the mean and standard deviation for each measurement. 
3.Uses descriptive activity names to name the activities in the data set
4.Appropriately labels the data set with descriptive variable names. 

5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

-----------------------------------------------

The source data file is at:


https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

In order to run the script successfully, the zip file should be downloaded and extracted.  The script should be in the same directory (beside) as the directory 'UCI HAR Dataset' so that you have the following directory structure:

README.txt (this document)
run_analysis.R
UCI HAR Dataset
  |--test
    |--...
  |--train
    |--...
  |--activity_labels.txt
  |--features.txt
  |--features_info.txt
  |__README.TXT
  

Additionally you will need dplyr

Open R and run the script 'run_analysis.R' to proceed.  The script is also documented for further reading.

the resulting datafram, 'average' is the finished tidy set

