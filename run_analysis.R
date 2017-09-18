###Download and unzip if needed, uncomment for first time run of the script
###Or change the data_root variable below to the right path
#fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(fileUrl,destfile="./Dataset.zip")
## unzipped into root folder - should create the data_root path  
#unzip(zipfile="./Dataset.zip",exdir=".")

#'stringr' package has some useful functions to work with strings
library(stringr)
#'dplyr' package is a life saver! 
library(dplyr)

#Original Data paths - downloaded data is stored here#
#Just change the data_root to the path to the folder where the data was downloaded and the 
#script should run just fine!!
data_root_folder <- "./UCI HAR Dataset/"
train_data_folder <- str_c(data_root, "train/")
test_data_folder <- str_c(data_root, "test/")

#str_c is used to join (concatenate) folder with file names
#get column names
#The second column has the names for features in x_train.txt dataset.
features <- read.table(str_c(data_root_folder, "features.txt"), col.names = c("srNo", "feature"))
activityLabels <- read.table(str_c(data_root_folder, "activity_labels.txt"), 
                             col.names = c("activity_num", "activity_name"))

#get the training datasets, only dataset needing features (as colnames) read above is the x_train
###Project Item #4 is accounted for here using the col.names 
x_train <- read.table(str_c(train_data_folder, "X_train.txt"), col.names = features$feature)
y_train <- read.table(str_c(train_data_folder, "y_train.txt"), col.names = c("activity_num"))
subject_train <- read.table(str_c(train_data_folder, "subject_train.txt"), 
                            col.names = c("subject_num"))
#merge all the training datasets
merged_train <- cbind(y_train, subject_train, x_train)

#get the test datasets, only dataset needing features (as colnames) read above is the X_test
###Project Task #4 is accounted for here using the col.names
x_test <- read.table(str_c(test_data_folder, "X_test.txt"), col.names = features$feature)
y_test <- read.table(str_c(test_data_folder, "y_test.txt"), col.names = c("activity_num"))
subject_test <- read.table(str_c(test_data_folder, "subject_test.txt"), 
                            col.names = c("subject_num"))
#merge all the test datasets
merged_test <- cbind(y_test, subject_test, x_test)

###Project Task #1 - Merges the training and the test sets to create one data set.
#merge training and test datasets
merged_all <- rbind(merged_train, merged_test)
#using dplyr for ease of functionality. Create the tibble.
merged_all_df <- tbl_df(merged_all)

###Project Task #2 Extracts only the measurements on the mean and standard deviation 
###for each measurement.
#uses dplyr 'select' verb to extract activity, subject and the mean and standard deviation
#variables
mean_std_df <- select(merged_all_df, activity_num, subject_num, 
                      contains(".mean.."), contains(".std.."))

###Project Tasks #3/#4
####3.Uses descriptive activity names to name the activities in the data set
###4. Appropriately labels the data set with descriptive variable names.
###This is already covered above when the data was read with feature names as column names
#descriptive activity labels using dplyr join on activity_num
mean_std_df <- inner_join(mean_std_df, activityLabels)
#activity numbers are not needed as we have the labels now
mean_std_df <- select(mean_std_df, -activity_num)

###Project Task #5
###From the data set in step 4, creates a second, independent tidy data set 
###with the average of each variable for each activity and each subject.
#dplyr group_by is used to group the data frame by activity and then by subject
grouped_mean_std_df <- group_by(mean_std_df, activity_name, subject_num)
#dplyr summarize_all is used to get averages for all variables in the groups
final_tidy_data_df <- summarise_all(grouped_mean_std_df, funs(mean))
#write this dataset so that it's available in GitHub repo
write.table(final_tidy_data_df, "final_tidy_dataset.txt", row.names = FALSE)
