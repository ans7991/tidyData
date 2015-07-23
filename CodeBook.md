

The script performs the following operations to import, clean, and transform the data set.

Read the files from the test and training data and merge the training and test sets to create one data set.
Combine the values from the subject_test and subject_train files to create a single TestSubject column.
Combine the values from the Y_test and Y_train data to create a single Activity column(for instance, walking/sitting).
Combine the values from the X_test and X_train files to create additional variable columns, one column for each measurement and calculation included in the data set.

Clean up the column names to remove hyphens and parentheses and replace them with periods.
Extract only the measurements on the mean and standard deviation for each measurement.
Use the dplyr select function to create a subset of the data that only includes columns that have ".mean." and ".std." in their column names.

Use descriptive activity names to name the activities in the data set.
Use the mapvalues function to map the numeric activity values to descriptive names like "Walking" and "Standing."
Appropriately label the data set with descriptive variable names.

Use split/apply/combine logic. First, split the data by the subject and activity factors using the split method.
Next, use lapply to iterate over each item in the resulting list, and use apply to apply the mean method to calculate the average of each column.
The output of lapply is a list, so combine it back to a data frame.
Use strsplit to break the subject and activity factors back into separate sets, and use cbind to properly bind them as the first columns in the resulting data set.