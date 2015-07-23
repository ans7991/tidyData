Read data in tidy_data_set.txt into R as:
  
  read.table("tidy_data_set.txt", header=TRUE, colClasses=c('factor', 'factor', rep('numeric', 66)))

Overview

codebook.md describes the variables and transformations.

Running run_analysis.R script

The script assumes that the data source files are in the directory UCI HAR Dataset that's in the current working directory.
The references to file locations for the data set are written to work with Mac/Linux systems.