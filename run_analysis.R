## STEP 1

trainSubjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
trainActivities <- read.table("./UCI HAR Dataset/train/y_train.txt")
trainVariables <- read.table("./UCI HAR Dataset/train/X_train.txt")

testSubjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")
testActivities <- read.table("./UCI HAR Dataset/test/y_test.txt")
testVariables <- read.table("./UCI HAR Dataset/test/X_test.txt")

trainDataset <- cbind(trainSubjects, trainActivities, trainVariables)
testDataset <- cbind(testSubjects, testActivities, testVariables)

wideDataset <- rbind(trainDataset, testDataset)

## STEP 2

variables <- read.table("./UCI HAR Dataset/features.txt")
variableNames <- as.vector(variables[,2])

selection <- grepl("mean\\(\\)|std\\(\\)",variableNames)
columns <- append(c(TRUE,TRUE), selection)

narrowDataset <- wideDataset[,columns]

## STEP 3

activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
activityNames <- as.vector(activities[,2])

narrowDataset[,2] <- activityNames[narrowDataset[,2]]

## STEP 4

idNames <- c("subject","activity")
columnNames <- append(idNames, variableNames[selection])
colnames(narrowDataset) <- columnNames

## STEP 5

library(reshape2)
meltedDataset <- melt(data = narrowDataset, id=idNames, measure.vars = variableNames[selection])
tidyDataset <- dcast(meltedDataset, subject + activity ~ variable, mean)

outputFile <- "./TidyDataset.txt"
write.table(tidyDataset, outputFile, row.names=FALSE)
