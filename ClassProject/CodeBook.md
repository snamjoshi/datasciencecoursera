## Getting and Cleaning Data Class Project
This file explains the script titled run_analysis.R

For this class project, we were asked to take data from the UCI HAR dataset and
arrange it according to instructions to make it "tidy" following the principles
we learned in Week 1 of the course. Below is an explanation of how my script
produces the tidy data required by the assignment as well as a codebook for all
variables contained in the script.

# CODEBOOK
** DATA FILES LOADED
* `activity_labels`: The activity number (1-6) and corresponding description of
the activity.

* `features`: The full list of features measured during the experiment

* `subject_test`: The ID for all subjects in the test data set

* `X_test`: The measurements for all features tested in the test data set

* `Y_test`: The activity performed by the subject in the test data set

* `subject_train`: The ID for all subjects in the training data set

* `X_train`: The measurements for all features tested in the training data set

* `Y_train`: The activity performed by the subject in the training data set

** VARIABLES CREATED

* `fullData`: All measurements for the test and training data bound by rows

* `columnNames`: Character vector containing the column names for the processed
data set.

* `fullDataMeanStd`: Processed data set after subsetting to only include features
with mean and standard deviation.

* `allActivities`: Descriptive activity names for the test and training data
sets

* `cleanDat`: Melting and aggregating by mean producing the final tidy data set

# DATA PROCESSING
First, the working directory is set, external packages are loaded, and the data
files are uploaded. For the test/training data, it was necessary to upload it
using the "" separator in order to get the data to display correctly.

The script must do all of the five following transformations to the data to
make it tidy. Below I outline how each of these steps was accomplished.

**1. Merges the training and the test sets to create one data set.**

The `cbind()` function is applied to the test and training sets to add in the
subject ID as the first column.

Then, `rbind()` is called to bind together the test and training sets into one
large data set.

**4. Appropriately labels the data set with descriptive variable names.**

Though this is the fourth requirement, it made more sense to do this step next.

A variable called `columnNames` is created which uses the feature names plus an
extra column to label the column that contains the subject ID. This is then set
to the column names for the large data set created in step 1.

**2. Extracts only the measurements on the mean and standard deviation for each 
measurement.**

In this step I subset the data frame so that only features pertaining to the
mean or standard deviation are selected.

`grep("-mean()|-Mean()|-std()", columnNames)` uses pattern matching to search
through the columns and only return the features that were computing mean or
standard deviation. The data frame is then subsetted on these features.
 
**3. Uses descriptive activity names to name the activities in the data set**

The `Y_test` and `Y_train` variables include the activities performed for the
test and training datasets respectively. They are coded with a number 1-6. In
order to complete this step, we must use the key provided by the file stored
in the variable `activity_labels`. 

First, `rbind()` is called to bind together the activity names. This follows
the same setup as in step 1 in which `X_test` and `X_train` were bound.

Next, an ID column is added to the above data frame. The reason for this will
be apparent in the next step.

`merge()` is used to replace the activity number with its actual name. However,
merge will rearrange the order of the rows. The ID column created above has
preserved the original ordering of the rows. Using `arrange()` on it allows us
to rearrange the row order as it should be. Finally all working columns are
dropped from the data frame and the activities column is added to the data
frame created in step 3.

**5. From the data set in step 4, creates a second, independent tidy data set** 
with the average of each variable for each activity and each subject.

This final step requires us to take the mean for the features by both activity
AND by subject.

First the data is melted into long form based on the `Activity` and `Subject` 
columns. `aggregate()` is used to take the mean of the value for the feature
and the other columns are returned. 

This produces a final tidy data set including each of the 6 activities for
every subject, and the average of the mean/std feature recorded for each of 
these activities.