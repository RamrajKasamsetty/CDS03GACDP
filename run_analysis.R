run_analysis <- function(){
  
  # All the variable are used camelCase notation for easy readability.
  
  #load all the libraries needed for running the script
  library(dplyr)
  
  # All the data assumed to be under the "UCI HAR Dataset" folder
  # The folder "UCI HAR Dataset" and this run_analysis script needs to be in same folder.
  
  #file paths which needs to be loaded before merging
    
  fileFeatures  <- "UCI HAR Dataset/features.txt"
  
  fileTestRawdata   <- "UCI HAR Dataset/test/X_test.txt"
  fileTestSubject   <- "UCI HAR Dataset/test/subject_test.txt"
  fileTestActivity  <- "UCI HAR Dataset/test/Y_test.txt"
  
  fileTrainRawdata  <- "UCI HAR Dataset/train/X_train.txt"
  fileTrainSubject  <- "UCI HAR Dataset/train/subject_train.txt"
  fileTrainActivity <- "UCI HAR Dataset/train/Y_train.txt"
  
  #Load the data from all of the files above
  
  variableNamesOfRawData <- read.table(fileFeatures)
  
  testSubject  <- read.table(fileTestSubject)
  testActivity <- read.table(fileTestActivity)
  testRawData  <- read.table(fileTestRawdata)
  
  trainSubject  <- read.table(fileTrainSubject)
  trainActivity <- read.table(fileTrainActivity)
  trainRawData  <- read.table(fileTrainRawdata)
  
  # Rename the variables in each test and train files before merging
  
  # Rename all names of columns of test measurements
  # by extracting the names as char vector from functions file
  names(testRawData) <- as.character(variableNamesOfRawData[,2])
  
  testSubject  <- rename(testSubject, volunteerId = V1)
  testActivity <- rename(testActivity, activityId = V1)
  
  # Rename all names of columns of train measurements
  # by extracting the names as char vector from func
  names(trainRawData) <- as.character(variableNamesOfRawData[,2])
  
  trainSubject  <- rename(trainSubject, volunteerId = V1)
  trainActivity <- rename(trainActivity, activityId = V1)
  
  # Merging the test measurements with subject and activity data columns by cbind
  testRawData <- cbind(testRawData,testSubject)
  testRawData <- cbind(testRawData,testActivity)
  
  # Merging the train measurements with subject and activity data columns by cbind
  trainRawData <- cbind(trainRawData,trainSubject)
  trainRawData <- cbind(trainRawData,trainActivity)
  
  # Merge the training and the test sets to create one data set as combined call cdata
  cdata  <- rbind(testRawData, trainRawData)

  # Extracts only the measurements on the mean and standard deviation for each measurement. 
  # Before extracting finding the column index for mean, standard deviation by grep
  # then added the two column position which are subject and activity coulmns 
  # those are added manually so added +1 and +2 to factors file.  
  meanIndices <- grep("mean()", names(cdata), ignore.case = TRUE)
  stdIndices <- grep("std()", names(cdata), ignore.case = TRUE)
  
  clist <- c(meanIndices, stdIndices)
  clist <- c(clist, nrow(variableNamesOfRawData)+1)
  clist <- c(clist, nrow(variableNamesOfRawData)+2)
  clist <- sort(clist)
  
  # Finally selected only the mean and standard deviation columns along with activity
  # and subject
  set1 <- cdata[,clist]
  
  # Extacted activity id as char and replaced with descriptive activity names
  # after replacing then attached to the data frame via cbind and dropped the 
  # activity id column from dataframe.
  
  activity <-  as.character(set1$activityId)
  
  activity[activity == "1"] <- "WALKING"
  activity[activity == "2"] <- "WALKING_UPSTAIRS"
  activity[activity == "3"] <- "WALKING_DOWNSTAIRS"
  activity[activity == "4"] <- "SITTING"
  activity[activity == "5"] <- "STANDING"
  activity[activity == "6"] <- "LAYING"
  
  set1 <- cbind(set1, activity)
  
  # drop the activity id column as it is not needed anymore
  set1 <- select(set1 , -activityId)
  
  # Extract column names as vectors for maniuplating the names
  rawColNames <- names(set1)
  
  # replace (, ), - from names
  rawColNames <- gsub("\\(", "", rawColNames)
  rawColNames <- gsub("\\)", "", rawColNames)
  rawColNames <- gsub("-", "", rawColNames)
  rawColNames <- gsub("tBodyAccmean", 
                      "Measured in Time Body Acceleration Mean in direction ", rawColNames)
  
  rawColNames <- gsub("tBodyAccstd", 
                      "Measured in Time Body Acceleration Standard Deviation in direction ", 
                      rawColNames)
  
  
  # Assigning back the column Names from char vector
  names(set1) <- rawColNames
  
  # There must be a better way. like pattern matching to find and replace the variables in
  # a fine way
  
  # average of each variable for each activity and each subject and assigned to set2 data
  set2 <- set1 %>% group_by(activity, volunteerId) %>% summarise_each(funs(mean))
  
  write.table(set2, file="final.txt" , row.name = FALSE)
  
}
