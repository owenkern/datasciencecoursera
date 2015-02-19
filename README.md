# datasciencecoursera
This repo was created for JHU's Data Science Specialization on Coursera.

## run_analysis.R
run_analysis.R is an R script, created for the Getting and Cleaning Data course project, that extracts the mean and standard deviation fields from UC Irvine's Human Activity Recognition test and training data sets, combines both data sets into one, and outputs both the combined data set and a summary table containing the average of each of these fields for each subject and each activity they performed.

### Step 1: Read the accelerometer and gyroscope data
The files X_test.txt and X_train.txt are fixed-width files, containing statistics based on data from the accelerometers and gyroscopes of Samsung Galaxy S II smartphones. Each field is 15 characters wide, with one blank space between fields. The desired fields are the first six in each of five groups of 40; the first two in each of five groups of 13; the first six in each of three groups of 79; and the first two in each of four groups of 13. The script generates numeric vectors `wanted2` and `wanted6`, and numeric objects `unwanted11`, `unwanted34`, and `unwanted73`, then concatenates these into a `widths` vector. This is then passed to `read.fwf()` along with the paths to X_test.txt and X_train.txt and a vector of column names, and the resultant data frames are stored as `test` and `train` respectively.

### Step 2: Add activity labels
The files y_test.txt and y_train.txt contain one number per line, indicating which of six activities was being done in the corresponding line of X_test.txt or X_train.txt. The script creates a character vector `activities`, then reads the files into `testLabels` and `trainLabels` using the `readLines()` function, coerces them to numeric vectors, and uses them as indices into `activities` to add an`activity` columns containing descriptive labels to each of `test` and `train`.

### Step 3: Add subject labels
The files subject_test.txt and subject_train.txt also contain one number per line, indicating which of 30 users did an activity in the corresponding line of X_test.txt or X_train.txt. The script reads the files using `readLines()`, coerces them to numeric vectors, and adds them to each of `test` and `train` as a `subject` column.

### Step 4: Combine and write the datasets
`test` and `train` are combined into the single data frame `data` using the `rbind()` function, then written out to tidy_data.txt using `write.table()` with `row.names = FALSE`.

### Step 5: Create the summary table
`data` is converted into `dataMelt` using the `melt()` function, keeping `subject` and `activity` as id variables, then cast into the table of means `summaries` using `dcast()`. Finally, this is written out to tidy_data_2.txt using `write.table()` with `row.names = FALSE`.