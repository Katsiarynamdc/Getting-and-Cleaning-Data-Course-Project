path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(path, "Data.zip"))

if (!file.exists("UCI HAR Dataset")) { 
     unzip("Data.zip") 
}
test_data <- read.table(file.path(folder, 'test', 'X_test.txt'))
test_activity <- read.table(file.path(folder, 'test', 'y_test.txt'))
test_subject <- read.table(file.path(folder, 'test', 'subject_test.txt'))

train_data <- read.table(file.path(folder, 'train', 'X_train.txt'))
train_activity <- read.table(file.path(folder, 'train', 'y_train.txt'))
train_subject <- read.table(file.path(folder, 'train', 'subject_train.txt'))

data_all <- rbind(train_data, test_data)
activity_all <- rbind(train_activity, test_activity)
subject_all <- rbind(train_subject, test_subject)

all_data <- cbind(subject_all, activity_all, data_all)

feat <- read.table(file.path(folder, 'features.txt'))
req_features <- grep('-(mean|std)\\(\\)', feat[, 2]) + 2
all_data <- all_data[, c(1, 2, req_features)]

activities <- read.table(file.path(folder, 'activity_labels.txt'))
all_data[, 2] <- activities[all_data[, 2], 2]

colnames(all_data) <- c(
  'subject',
  'activity',
  gsub('\\-|\\(|\\)', '', as.character(feat[req_features, 2]))
)

all_data[, 2] <- as.character(all_data[, 2])

final_melted <- melt(all_data, id = c('subject', 'activity'))
final_avg <- dcast(final_melted, subject + activity ~ variable, mean)

write.table(final_avg, file=file.path("cleandata.txt"), row.names = FALSE, quote = FALSE)
