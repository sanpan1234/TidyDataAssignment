# Getting and Cleaning Data Course Project Submission
As described in the course project outline, the end goal of this project is to prepare a tidy data set from a bunch of 'messy' datasets. 

This repo contains the required artifacts:
1) a tidy data set as described below
2) a code book that describes the variables, the data, and any transformations or work that was performed to clean up the data called CodeBook.md. 
3) a README.md (this file), that explains how the only script for this project (run_analysis.R) works.

Following is a description of all the steps performed by the script (run_analysis.R):

**Step 0**: Two packages are used in the script for various features provided by them: **stringr** and **dplyr**. 
```{r}
#'stringr' package has some useful functions to work with strings
library(stringr)
#'dplyr' package is a life saver! 
library(dplyr)
```

**Step 1**: Download and unzip the 'messy' dataset zip file into a subfolder of the working directory. This root folder is referred to by the variable **data_root_folder**. This folder is _not included_ in the repo but _commented_ code to download and unzip the file is included at the top of the script and can be used if needed.

```{r}
data_root_folder <- "./UCI HAR Dataset/"
train_data_folder <- str_c(data_root, "train/")
test_data_folder <- str_c(data_root, "test/")
```
**Step 2**: **Load datasets into R** - ```read.table``` is used to read data into R as data frames. First the ```features.txt``` and ```activity_labels.txt``` are loaded and later used to provide the column names for ```X_train.txt/X_test.txt``` datasets and providing labels for activities respectively. Then the training and test datasets are loaded and merged using ```cbind()```. **Project Task #4** is accounted for in this step by providing column names for each load of dataset.

**Step 3 (Project Task #1):** The training and the test sets are merged using ```rbind()``` to create one data set. At the same time, ```dplyr``` is used to create the tibble we need for later processing.
```merged_all_df <- tbl_df(merged_all)```

**Step 4 (Project Task #2):** Next project task requires us to _extract only the measurements on the mean and standard deviation for each measurement_. This is accomplished using the handy ```select()``` verb of ```dplyr``` package to extract activity, subject and the mean and standard deviation variables from the combined dataset.

**Step 4 (Project Tasks #3/#4):** These tasks require us to use descriptive activity names to name the activities in the data set and to appropriately label the data set with descriptive variable names. Variable names (task #4) are taken care while loading the datasets by providing ```col.names```. This step uses ```dplyr's inner_join()``` to join ```activityLabels``` with the dataset to provide descriptive activity labels.

**Step 4 (Project Task #5):** _"From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject."_ ```dplyr group_by()``` comes in very handy to group the data frame by activity and then by subject. Then ```dplyr summarize_all()``` is used to get the averages for all variables in the groups. The final tidy dataset is written out to a file.

```
grouped_mean_std_df <- group_by(mean_std_df, activity_name, subject_num)
final_tidy_data_df <- summarise_all(grouped_mean_std_df, funs(mean))
write.table(final_tidy_data_df, "final_tidy_dataset.txt", row.names = FALSE)
```

**TidyDataAssignment.Rproj** is a RStudio project file that allows opening the repo content as a project in RStudio (can be safely ignore if not using RStudio!).