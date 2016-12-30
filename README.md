# Getting-and-Cleaning-Data-Project
Peer-graded Assignment for Coursera course 'Getting and Cleaning Data', from Johns Hopkins University

## Course project

Create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names.
5. Creates a second, independent tidy data 'final_averages.csv', set with the average of each variable for each activity and each subject.

# How to run this project:

1. Download the data for the project into a directory. Use the following dataset:

    https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


2. Download the run_analysis.R file from this repository. You may need to adjust the working directory in the Housekeeping section of the code.

3. Run the R file. It will automatically load the dependant libraries, read in the data files, produce the necessary datasets, and will write the final tidied data into file 'final_averages.csv'.

