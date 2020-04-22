# Getting and Cleaning Data Course Project
# Cesar Benjumea


# ------------- Download the data ---------------------------------------------------------------------
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
wd <- getwd()
temp <- tempfile()
download.file(url,temp)
unzip(zipfile = temp, exdir = wd)

# ---------------------- 1 ----------------------------------------------------------------------------
# ------------- Read the train and test files ---------------------------------------------------------
# Inertial Signals not included in the analysis 
# see https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/

# test variables
x_test <- read.table('./UCI HAR Dataset/test/X_test.txt', stringsAsFactors = FALSE)
y_test <- read.table('./UCI HAR Dataset/test/y_test.txt', stringsAsFactors = FALSE)
subject_test <- read.table('./UCI HAR Dataset/test/subject_test.txt', stringsAsFactors = FALSE)

dat_test <- cbind(subject_test, y_test, x_test)

# train variables
x_train <- read.table('./UCI HAR Dataset/train/X_train.txt', stringsAsFactors = FALSE)
y_train <- read.table('./UCI HAR Dataset/train/y_train.txt', stringsAsFactors = FALSE)
subject_train <- read.table('./UCI HAR Dataset/train/subject_train.txt', stringsAsFactors = FALSE)

dat_train <- cbind(subject_train, y_train, x_train)

# labeling variable names
features <- read.table('./UCI HAR Dataset/features.txt', stringsAsFactors = FALSE)
names(dat_test) <- c("subject", "activity", features[,2])
names(dat_train) <- c("subject", "activity", features[,2])
#str(dat_test)
#str(dat_train)

my_data <- rbind(dat_test,dat_train)

#clean workspace
rm(list=c("dat_test", "dat_train", "x_test", "x_train", "y_test", "y_train", "subject_train", "subject_train", "features"))

# ---------------------- 2 ----------------------------------------------------------------------------
# ------------- Extract measurements of means ---------------------------------------------------------
# Extract columns containing mean() and std() - and the angle variables (coumns 557 to 563)
varnames <- names(my_data)
meannames <- grep( "std|mean\\(\\)", varnames)

my_data_names <- names(my_data[,c(1,2,meannames, 557:563)])
my_data2 <- my_data[my_data_names]

# clean workspace
rm("my_data")
# ---------------------- 3 ----------------------------------------------------------------------------
# ------------- Replace values with descriptive names -------------------------------------------------
activity_labels <- read.table('./UCI HAR Dataset/activity_labels.txt', stringsAsFactors = FALSE)
activity_labels
#table(my_data2$labels)
my_data2$activity <- activity_labels[,2][match(my_data2$activity, activity_labels[,1])]

table(my_data2[,2]) # Everything looks fine

# ---------------------- 4 ----------------------------------------------------------------------------
# ------------- Add varnames --------------------------------------------------------------------------
# already done
head(names(my_data2))

# ---------------------- 5 ----------------------------------------------------------------------------
# ------------- Add varnames --------------------------------------------------------------------------
# Create a tidy data set with the average of each variable for each activity and each subject.
tidy_data <- aggregate( . ~ subject + activity, data = my_data2, FUN = mean )

# Export tidy data set to excel file
write.table(tidy_data, "tidy_data.txt", row.names = FALSE )

