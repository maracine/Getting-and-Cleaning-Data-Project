#------------------------------------------------------------------------------
#
# Peer-graded Assignment for Coursera course 'Getting and Cleaning Data'
#                   Johns Hopkins University
#
#                         Michel Racine
#                   Michel.A.Racine@gmail.com
# 
#                         December 2016
# 
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# Initialization / Housekeeping section
#------------------------------------------------------------------------------

# Set working directory; on my personal system, point to the appropriate DropBox folder
# Assume that the zip file has been pre-extracted into this base directory.
setwd("C:/Users/michel/Dropbox/Coursera/Data Science/Getting and Cleaning Data/Assignment/")

# This R script requires the dplyr and data.table packages; ensure that tbey are pre-loaded.
if (!require("dplyr")) {
  install.packages("dplyr")
}

require("dplyr")

if (!require("data.table")) {
  install.packages("data.table")
}

require("data.table")



#------------------------------------------------------------------------------
# A.	Merge the training and test data sets to create one combined data set
#------------------------------------------------------------------------------

# 1.	Load test & train data into separate dataframes
  
# Read in column header names for sensor data files; ignore the first column of the data file.
features <- read.table("features.txt", header=FALSE)[,2]

# Load test and train data files, using features vector to provide names of headers
# 
test <- read.table("test/X_test.txt", header=FALSE,  col.names=features)
train <- read.table("train/X_train.txt", header=FALSE,  col.names=features)

# Read in test and train Subject IDs; provide a meaningful header name.
train_subject <- read.table("train/subject_train.txt", header=FALSE)
test_subject <- read.table("test/subject_test.txt", header=FALSE)
names(test_subject) <- c("subject")
names(train_subject) <- c("subject")

# Read in Activity labels; provide meaningful header names.
activity_labels <- read.table("activity_labels.txt")
names(activity_labels) <- c("activity_label", "activity")

# Read in test and train Activities; provide a meaningful header name.
train_activities <- read.table("train/y_train.txt", header=FALSE)
test_activities <- read.table("test/y_test.txt", header=FALSE)
names(test_activities) <- c("activity_label")
names(train_activities) <- c("activity_label")

# Bbefore we combine test and drain data, inject column to indicate type of data (test or train). 
# Although this step is not discussed in the assignment text, I believe that best-practice calls for it.
test$dataset_type <- "Test"
train$dataset_type <- "Train"

# Combine test and train data with Subject IDs and Activities data
test <- cbind(test_subject, test_activities, test)
train <- cbind(train_subject, train_activities, train)
merged <- rbind(test,train)

# match activity labels with respective activity name
merged <- merge(merged, activity_labels, by.x="activity_label", by.y="activity_label")



#-------------------------------------------------------------------------------------------
# B. Extracts only the measurements on the mean and standard deviation for each measurement
#   Use descriptive activity names within the dataset, and use descriptive variable names
#-------------------------------------------------------------------------------------------

# Create vector to allow the restriction on the mean and standard deviation measurements. 
# Match 'mean' and 'std' strings anywhere in the variable names  
extract_features <- grep("mean|std", names(merged), ignore.case=TRUE )

# Select relevant variables: Subject, Activity, Type of dataset and all relevant mean/std measurements.
final <- select(merged, subject, activity, dataset_type, extract_features )

# Melt the final dataset into a tidy dataset; Note that we will keep the dataset_type variable 
# at this point, but will not use it in the grouping function for the final step.
id_labels   = c("subject", "activity", "dataset_type")
data_labels = setdiff(colnames(final), id_labels)
final_melted  = melt(final, id = id_labels, measure.vars = data_labels)

# Create the tidy data set. Use cast formula 'subject + activity ~ variable'.
final_averages <- dcast(final_melted, subject + activity ~ variable, mean)

# write the final data set to a csv file
write.csv(final_averages, "final_averages.csv", row.names=FALSE)

