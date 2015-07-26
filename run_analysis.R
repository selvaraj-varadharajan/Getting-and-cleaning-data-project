library(plyr)
setwd("C:\\Coursera\\R\\DataAnalysis\\data\\Project")

# Reading the datasets and creating the dataframe objects 

x_train <- read.table(".\\UCIHARDataset\\train\\X_train.txt")
y_train <- read.table(".\\UCIHARDataset\\train\\y_train.txt")
subject_train <- read.table(".\\UCIHARDataset\\train\\subject_train.txt")


x_test <- read.table(".\\UCIHARDataset\\test\\X_test.txt")
y_test <- read.table(".\\UCIHARDataset\\test\\y_test.txt")
subject_test <- read.table(".\\UCIHARDataset\\test\\subject_test.txt")

# Merging the train and test datasets to create consolidated datasets for x,y and subject

x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)


# Extracting only the measurements on the mean and standard deviation for each measurement

features <- read.table(".\\UCIHARDataset\\features.txt")

# getting the columns with mean() or std() in their names
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# subsetting the desired columns
x_data <- x_data[, mean_and_std_features]

# correct the column names
names(x_data) <- features[mean_and_std_features, 2]

# Use descriptive activity names to name the activities in the data set

activities <- read.table(".\\UCIHARDataset\\activity_labels.txt")

# update values with correct activity names
y_data[, 1] <- activities[y_data[, 1], 2]

# correct column name
names(y_data) <- "activity"

# Appropriately label the data set with descriptive variable names

# correct column name
names(subject_data) <- "subject"

# bind all the data in a single data set
all_data <- cbind(x_data, y_data, subject_data)

# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject

# 66 <- 68 columns but last two (activity & subject)
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "tidy_averages_data.txt", row.name=FALSE)

