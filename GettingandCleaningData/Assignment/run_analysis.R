## Downloading and Reading in the Data
library(data.table)
library(dplyr)
library(tidyr)
library(knitr)

setwd("/Users/workingdirectory") # Set this to your working directory 

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "./data/Data.zip")

subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
subject_test  <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

activity_train <- read.table("./data/UCI HAR Dataset/train/Y_train.txt")
activity_test  <- read.table("./data/UCI HAR Dataset/test/Y_test.txt")

train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
train <- data.table(train)
test  <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
test <- data.table(test)

## Merging datasets
subject <- rbind(subject_train, subject_test)
setnames(subject, "V1", "subject")
activity <- rbind(activity_train, activity_test)
setnames(activity, "V1", "activity_num")
tot_data <- rbind(train, test)

subject <- cbind(subject, activity)
tot_data <- cbind(subject, tot_data)
tot_data <- data.table(tot_data)

setkey(tot_data, subject, activity_num)


## Reading in the features files
features <- read.table("./data/UCI HAR Dataset/features.txt")
setnames(features, names(features), c("featureNum", "feature_name"))
features <- data.table(features)


## Subsetting with only mean and std values
features <- features[grepl("mean\\(\\)|std\\(\\)", feature_name)]

features$feature_code <- features[, paste0("V", featureNum)]

select <- c(key(tot_data), features$feature_code)
tot_data <- tot_data[, select, with=FALSE]


## Reading in activity names and merging to tot_data
activity_names <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
activity_names <- data.table(activity_names)
setnames(activity_names, names(activity_names), c("activity_num", "activity_name"))

tot_data <- merge(tot_data, activity_names, by="activity_num", all.x=TRUE)

setkey(tot_data, subject, activity_num, activity_name)

## Melting the data based on variable name to get feature-wise values
tot_data <- data.table(melt(tot_data, key(tot_data), variable.name="feature_code"))

## Merging tot_data with features information
tot_data <- merge(tot_data, features[, list(featureNum, feature_code, feature_name)], by="feature_code", all.x=TRUE)

tot_data$activity <- factor(tot_data$activity_name) #converting to factor
tot_data$feature <- factor(tot_data$feature_name) #converting to factor

## Feature names
custom_grep <- function (text) {
  grepl(text, tot_data$feature)
}

## Two category features
n <- 2
y <- matrix(seq(1, n), nrow=n)

x <- matrix(c(custom_grep("^t"), custom_grep("^f")), ncol=nrow(y))
tot_data$domain_ftr <- factor(x %*% y, labels=c("Time", "Freq"))

x <- matrix(c(custom_grep("Acc"), custom_grep("Gyro")), ncol=nrow(y))
tot_data$instrument_ftr <- factor(x %*% y, labels=c("Accelerometer", "Gyroscope"))

x <- matrix(c(custom_grep("BodyAcc"), custom_grep("GravityAcc")), ncol=nrow(y))
tot_data$acceleration_ftr <- factor(x %*% y, labels=c(NA, "Body", "Gravity"))

x <- matrix(c(custom_grep("mean()"), custom_grep("std()")), ncol=nrow(y))
tot_data$variable_ftr <- factor(x %*% y, labels=c("Mean", "SD"))


## One category features
tot_data$jerk_ftr <- factor(custom_grep("Jerk"), labels=c(NA, "Jerk"))
tot_data$magnitude_ftr <- factor(custom_grep("Mag"), labels=c(NA, "Magnitude"))


## Three category features
n <- 3
y <- matrix(seq(1, n), nrow=n)
x <- matrix(c(custom_grep("-X"), custom_grep("-Y"), custom_grep("-Z")), ncol=nrow(y))
tot_data$axis_ftr <- factor(x %*% y, labels=c(NA, "X", "Y", "Z"))

setkey(tot_data, subject, activity, domain_ftr, acceleration_ftr, instrument_ftr, jerk_ftr, magnitude_ftr, variable_ftr, axis_ftr)

## TIDY data as output
tidy_data <- tot_data[, list(count = .N, average = mean(value)), by=key(tot_data)]


## Writing the tidy data to working directory
write.table(tidy_data, file = "tidydata.txt", quote=FALSE, sep="\t", row.names=FALSE)

## Run the markdown code file to generate the codebook
knit("markdown_generator.Rmd", output="Codebook.md", encoding="ISO8859-1", quiet=TRUE)
