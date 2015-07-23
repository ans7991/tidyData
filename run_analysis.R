install.packages("plyr")
install.packages("dplyr")
install.packages("reshape2")
library(plyr)
library(dplyr)
library(reshape2)
library(stringr)

features <- read.table("UCI HAR Dataset/features.txt")
test_x <- read.table("UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("UCI HAR Dataset/test/y_test.txt")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
train_x <- read.table("UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("UCI HAR Dataset/train/y_train.txt")
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

combined_data <- rbind(test_x, train_x)
combined_y <- rbind(test_y, train_y)
combined_subjects <- rbind(test_subjects, train_subjects)

namesList <- as.character(features$V2)
namesList <- make.names(namesList, unique=TRUE)
names(combined_data) <- namesList

combined_data <- cbind(combined_y, combined_data)
names(combined_subjects) = c('subjects')
combined_data <- cbind(combined_subjects, combined_data)

sub_data <- select(combined_data, subjects, V1, contains(".mean."), contains(".std."))

sub_data$subjects <- as.factor(sub_data$subjects)
sub_data$V1 <- as.factor(sub_data$V1)

sub_data$V1 <- mapvalues(sub_data$V1, from = c("1", "2", "3", "4", "5", "6"), 
                         to = c("Walking", "WalkingUpStairs", "WalkingDownStairs", "Sitting", "Standing", "Lying"))

names(sub_data) <- str_replace_all(names(sub_data), "[.][.]", "")
names(sub_data) <- str_replace_all(names(sub_data), "BodyBody", "Body")
names(sub_data) <- str_replace_all(names(sub_data), "tBody", "Body")
names(sub_data) <- str_replace_all(names(sub_data), "fBody", "FFTBody")
names(sub_data) <- str_replace_all(names(sub_data), "tGravity", "Gravity")
names(sub_data) <- str_replace_all(names(sub_data), "fGravity", "FFTGravity")
names(sub_data) <- str_replace_all(names(sub_data), "Acc", "Acceleration")
names(sub_data) <- str_replace_all(names(sub_data), "Gyro", "AngularVelocity")
names(sub_data) <- str_replace_all(names(sub_data), "Mag", "Magnitude")
for(i in 3:68) {if (str_detect(names(sub_data)[i], "[.]std")) 
{names(sub_data)[i] <- paste0("StandardDeviation", str_replace(names(sub_data)[i], "[.]std", ""))}}
for(i in 3:68) {if (str_detect(names(sub_data)[i], "[.]mean")) 
{names(sub_data)[i] <- paste0("Mean", str_replace(names(sub_data)[i], "[.]mean", ""))}}
names(sub_data) <- str_replace_all(names(sub_data), "[.]X", "XAxis")
names(sub_data) <- str_replace_all(names(sub_data), "[.]Y", "YAxis")
names(sub_data) <- str_replace_all(names(sub_data), "[.]Z", "ZAxis")

split_set <- split(select(sub_data, 3:68), list(sub_data$subjects, sub_data$V1))
mean_set <- lapply(split_set, function(x) apply(x, 2, mean, na.rm=TRUE))
tidy_set <- data.frame(t(sapply(mean_set,c)))

factors <- data.frame(t(sapply(strsplit(rownames(tidy_set), "[.]"),c)))
tidy_set <- cbind(factors, tidy_set)

tidy_set <- dplyr::rename(tidy_set,TestSubject = X1, Activity = X2)
tidy_set$TestSubject <- as.factor(tidy_set$TestSubject)
tidy_set$Activity <- as.factor(tidy_set$Activity)
rownames(tidy_set) <- NULL

test_set <- select(filter(sub_data, V1=="Walking" & subjects==1), MeanBodyAccelerationXAxis)

tidy_set_val <- select(filter(tidy_set, TestSubject==1 & Activity=="Walking"), MeanBodyAccelerationXAxis)$MeanBodyAccelerationXAxis
result <- all.equal(mean(test_set$MeanBodyAccelerationXAxis), tidy_set_val)
print("Data calculation verification--TRUE indicates the verification passed:")
print(result)

test_set <- select(filter(sub_data, V1=="Sitting" & subjects==5), StandardDeviationFFTBodyAccelerationXAxis)
tidy_set_val <- select(filter(tidy_set, TestSubject==5 & Activity=="Sitting"), StandardDeviationFFTBodyAccelerationXAxis)$StandardDeviationFFTBodyAccelerationXAxis
result <- all.equal(mean(test_set$StandardDeviationFFTBodyAccelerationXAxis), tidy_set_val)
print(result)

write.table(tidy_set, "tidy_data_set.txt", row.names=FALSE)