## As this script has no user-defined inputs, it does not define a
## function. It should be run by typing:
##
##  source("run_analysis.R")
##
## This script depends on the folder "UCI HAR Dataset" being in
## the working directory.

## Read in the data :
## Each data field in X_test and X_train has width 15
## 1 space between fields
## Want fields 1-6, 41-46, 81-86, 121-126, 161-166, 201, 202, 214,
## 215, 227, 228, 240, 241, 253, 254, 266-271, 345-350, 424-429,
## 503, 504, 516, 517, 529, 530, 542, 543
## (5 repeats of 6 wanted, 34 unwanted; 5 repeats of 2 wanted, 11
## unwanted; 3 repeats of 6 wanted, 73 unwanted; 4 repeats of 2
## wanted, 11 unwanted)

wanted2 <- rep(c(15, -1), 2)
wanted6 <- rep(c(15, -1), 6)
unwanted11 <- -16 * 11
unwanted34 <- -16 * 34
unwanted73 <- -16 * 73
widths <- c(
    rep(c(wanted6, unwanted34), times = 5),
    rep(c(wanted2, unwanted11), times = 5),
    rep(c(wanted6, unwanted73), times = 3),
    rep(c(wanted2, unwanted11), times = 4))
colNames <- c(
    "time_body_accel_mean_X",
    "time_body_accel_mean_Y",
    "time_body_accel_mean_Z",
    "time_body_accel_std_X",
    "time_body_accel_std_Y",
    "time_body_accel_std_Z",
    "time_grav_accel_mean_X",
    "time_grav_accel_mean_Y",
    "time_grav_accel_mean_Z",
    "time_grav_accel_std_X",
    "time_grav_accel_std_Y",
    "time_grav_accel_std_Z",
    "time_body_accel_jerk_mean_X",
    "time_body_accel_jerk_mean_Y",
    "time_body_accel_jerk_mean_Z",
    "time_body_accel_jerk_std_X",
    "time_body_accel_jerk_std_Y",
    "time_body_accel_jerk_std_Z",
    "time_body_gyro_mean_X",
    "time_body_gyro_mean_Y",
    "time_body_gyro_mean_Z",
    "time_body_gyro_std_X",
    "time_body_gyro_std_Y",
    "time_body_gyro_std_Z",
    "time_body_gyro_jerk_mean_X",
    "time_body_gyro_jerk_mean_Y",
    "time_body_gyro_jerk_mean_Z",
    "time_body_gyro_jerk_std_X",
    "time_body_gyro_jerk_std_Y",
    "time_body_gyro_jerk_std_Z",
    "time_body_accel_mean_total",
    "time_body_accel_std_total",
    "time_grav_accel_mean_total",
    "time_grav_accel_std_total",
    "time_body_accel_jerk_mean_total",
    "time_body_accel_jerk_std_total",
    "time_body_gyro_mean_total",
    "time_body_gyro_std_total",
    "time_body_gyro_jerk_mean_total",
    "time_body_gyro_jerk_std_total",
    "freq_body_accel_mean_X",
    "freq_body_accel_mean_Y",
    "freq_body_accel_mean_Z",
    "freq_body_accel_std_X",
    "freq_body_accel_std_Y",
    "freq_body_accel_std_Z",
    "freq_body_accel_jerk_mean_X",
    "freq_body_accel_jerk_mean_Y",
    "freq_body_accel_jerk_mean_Z",
    "freq_body_accel_jerk_std_X",
    "freq_body_accel_jerk_std_Y",
    "freq_body_accel_jerk_std_Z",
    "freq_body_gyro_mean_X",
    "freq_body_gyro_mean_Y",
    "freq_body_gyro_mean_Z",
    "freq_body_gyro_std_X",
    "freq_body_gyro_std_Y",
    "freq_body_gyro_std_Z",
    "freq_body_accel_mean_total",
    "freq_body_accel_std_total",
    "freq_body_accel_jerk_mean_total",
    "freq_body_accel_jerk_std_total",
    "freq_body_gyro_mean_total",
    "freq_body_gyro_std_total",
    "freq_body_gyro_jerk_mean_total",
    "freq_body_gyro_jerk_std_total")
message("Loading data...")
test <- read.fwf("UCI HAR Dataset/test/X_test.txt", widths, 
                 col.names = colNames)
train <- read.fwf("UCI HAR Dataset/train/X_train.txt", widths,
                  col.names = colNames)

## y_test and y_train have 1 column of data: numbers to be 
## converted to activity names
activities <- c("Walking", "Walking upstairs", "Walking downstairs",
                "Sitting", "Standing", "Laying")

message("Adding activity column...")
testLabels <- as.numeric(
    readLines("UCI HAR Dataset/test/y_test.txt"))
test$activity <- activities[testLabels]
trainLabels <- as.numeric(
    readLines("UCI HAR Dataset/train/y_train.txt"))
train$activity <- activities[trainLabels]

## subject_test and subject_train have 1 column of data: subject
## ID numbers, to be stored as numbers
message("Adding subject column...")
test$subject <- as.numeric(
    readLines("UCI HAR Dataset/test/subject_test.txt"))
train$subject <- as.numeric(
    readLines("UCI HAR Dataset/train/subject_train.txt"))

## Combine the test and training sets by row-binding
message("Combining and writing datasets...")
data <- rbind(test, train)
write.table(data, "tidy_data.txt", row.names = FALSE)

## Create the summary table
library(reshape2)
message("Creating summary dataset...")
dataMelt <- melt(data, id = c("subject", "activity"))
summaries <- dcast(dataMelt, subject + activity ~ variable, mean)
write.table(summaries, "tidy_data_2.txt", row.names = FALSE)

message("Done.")