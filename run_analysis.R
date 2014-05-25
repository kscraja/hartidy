# R script to tidy up the HAR dataset. as a project work 

# reading features names
featureLabels <- read.table("./HARDataset//features.txt")
featureLabels <- featureLabels$V2 # just picking the feature names

#reading activity labels
activityLabels <- read.table("./HARDataset//activity_labels.txt")
names(activityLabels) <- c("ActivityCode", "ActivityName")

#loading training data
trainData <- read.table("./HARDataset/train/X_train.txt")
names(trainData) <- featureLabels # setting feature names a column names

#attaching activity names to the train data
trainActivityLabel <- read.table("./HARDataset/train/y_train.txt") # loading activity code - name map
trainData$ActivityCode <- trainActivityLabel$V1
#trainData <- merge(trainData, activityLabels, by.x = "ActivityCode", by.y="ActivityCode") # merging activity map and train map

#attaching subject ids to the train data
trainSubjectList <- read.table("./HARDataset/train/subject_train.txt")
trainData$SubjectId <- trainSubjectList$V1

#loading test data
testData <- read.table("./HARDataset/test/X_test.txt")
names(testData) <- featureLabels # setting feature names a column names

#attaching activity names to the test data
testActivityLabel <- read.table("./HARDataset/test/y_test.txt") # loading activity code - name map
testData$ActivityCode <- testActivityLabel$V1
#testData <- merge(testData, activityLabels, by.x = "ActivityCode", by.y="ActivityCode") # merging activity map and train map

#attaching subject ids to the test data
testSubjectList <- read.table("./HARDataset/test/subject_test.txt")
testData$SubjectId <- testSubjectList$V1

#merging train and test data
data <- rbind(trainData, testData)

# filtering the columns to be selected
cnames <- names(data)
cnames <- c(cnames[grep("(mean|std)", perl=TRUE, cnames)], "ActivityCode", "SubjectId")

#pruning out unwanted columns
data <- data[,cnames] # only retaining columns containing mean and std in their names

#capturing only average values of each variable for each activity and each subject
# tidyData :: second data that is asked for
tidyData <- aggregate(data, by=list(data$ActivityCode, data$SubjectId), FUN=mean)
tidyData$Group.1 <- NULL
tidyData$Group.2 <- NULL
#attaching ActivityName as another column for reading purposes
tidyData <- merge(tidyData, activityLabels, by.x = "ActivityCode", by.y="ActivityCode") # merging activity map and train map
write.table(tidyData, "./tidyData2.txt")

#attaching ActivityName as another column for reading purposes
#tidyData0 :: first part of the exercise
tidyData0 <- merge(data, activityLabels, by.x = "ActivityCode", by.y="ActivityCode") # merging activity map and train map
write.table(tidyData0, "./tidyData1.txt")