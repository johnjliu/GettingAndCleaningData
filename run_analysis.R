#setwd("c:/coursera/getdata")


if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("reshape2")) {
  install.packages("reshape2")
}

require("data.table")
require("reshape2")

#6 activity labels - WALKING,WALKING_UPSTAIRS,WALKING_DOWNSTAIRS,SITTING,STANDING,LAYING   
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

# data column names - 477 columns
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

# Extract columns of mean and standard deviation
extract_features <- grepl("mean|std", features)

# Load X_test : 2947 obs. of  561 variables
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")

# Y_test data : 2947 obs. of 1 variable  (Activity_ID)
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")

# subject_test data : 2947 obs. of 1 variable
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# Assign 561 column names
names(X_test) = features

# Extract columns with mean and standard deviation : 2947 obs. of  79 variables
X_test = X_test[,extract_features]

# Add activity_Label to Y_test
Y_test[,2] = activity_labels[Y_test[,1]]
names(Y_test) = c("Activity_ID", "Activity_Label")


#Assign column name to subject_test
names(subject_test) = "subject"

# Bind test data :  2947 obs. of  82 variables(1 + 2 + 79)
test_data <- cbind(as.data.table(subject_test), Y_test, X_test)

# Load X_train data : 7352 obs. of  561 variables
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")

# Load y_train data : 7352 obs. of  1 variable
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

# Load subject_train data : 7352 obs. of  1 variable
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

names(X_train) = features

# Extract columns with mean and standard deviation : 7352 obs. of  79 variables
X_train = X_train[,extract_features]

# Add Activity_Label to Y_train
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")


names(subject_train) = "subject"

# Bind train data : 7352 obs. of  82 variables (1 + 2 + 79)
train_data <- cbind(as.data.table(subject_train), y_train, X_train)

# Merge test and train data : 10299 obs. of  82 variables
data = rbind(test_data, train_data)


#key columns
id_labels = c("subject", "Activity_ID", "Activity_Label")

#82 - 3 = 79 column names
data_labels = setdiff(colnames(data), id_labels)

#melt data using id_lables as key : 813621 obs. of  5 variables
melt_data = melt(data, id = id_labels, measure.vars = data_labels)

# cast back and use mean : 180 obs. of  82 variables
tidy_data = dcast(melt_data, subject + Activity_ID + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt", row.name=FALSE)

