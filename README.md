# GACDCourseProject
(Coursera) 03 Getting and Cleaning Data Course Project

   All the variable are used camelCase notation for easy readability.
  
   load all the libraries needed for running the script
  
   All the data assumed to be under the "UCI HAR Dataset" folder
   The folder "UCI HAR Dataset" and this run_analysis script needs to be in same folder.
  
	Loaded all the files which mentioned in the folder paths
  
   Rename the variables in each test and train files before merging since the default values
   are V1, V2 etc and the activity and subject files are also having same coulmn names.
   
   As a first step merged the train data with subject and activity data.
   
   repeated the same with test data also.

	 Merge the training and the test sets to create one data set as combined call cdata
  
  Before extracting finding the column index for mean, standard deviation by grep
   then added the two column position which are subject and activity coulmns 
   those are added manually so added +1 and +2 to factors file.  

   selected only the measurements on the mean and standard deviation for each measurement. 
    
   Finally selected only the mean and standard deviation columns along with activity
   and subject
  
     Extacted activity id as char and replaced with descriptive activity names
   after replacing then attached to the data frame via cbind and dropped the 
   activity id column from dataframe.
  
     drop the activity id column as it is not needed anymore
  
     Extract column names as vectors for maniuplating the names
  
     replace (, ), - from names
  
     Assigning back the column Names from char vector
  
     There must be a better way. like pattern matching to find and replace the variables in
   a fine way
  
   average of each variable for each activity and each subject and assigned to set2 data
   
   write the output to a file to upload for project submission
