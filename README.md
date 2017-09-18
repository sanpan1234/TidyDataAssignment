# TidyDataAssignment
As described in the course project outline, the end goal of this project is to prepare a tidy data set from a bunch of 'messy' datasets. 

This repo contains the required artifacts:
1) a tidy data set as described below
2) a code book that describes the variables, the data, and any transformations or work that was performed to clean up the data called CodeBook.md. 
3) a README.md (this file), that explains how the only script for this project (run_analysis.R) works.

Following is a description of all the steps performed by the script (run_analysis.R):

Step 0: Two packages are used in the script for various features provided by them: **stringr** and **dplyr**. 
```{r cars}
#'stringr' package has some useful functions to work with strings
library(stringr)
#'dplyr' package is a life saver! 
library(dplyr)
```

Step 1: Download and unzip the 'messy' dataset zip file into a subfolder of the working directory. This root folder is referred to by the variable **data_root_folder**. This folder is _not included_ in the repo.

```{r cars}
data_root_folder <- "./UCI HAR Dataset/"
train_data_folder <- str_c(data_root, "train/")
test_data_folder <- str_c(data_root, "test/")
```
