#Welcome to my attempt at the assignment for getting and cleaning data course.
#Let's get to it.

#first, lets do a quick check for the necessary files

#this line of code check that the UCI HAR Dataset directory is in the correct relative structure to the working directory.  If not, you will get a half error.

if (dir.exists(".//UCI HAR Dataset")==TRUE) print("data set directory located, proceeding/n") else stop("something is not right, please check readme./")
  
#after examining the data set, we find that the x_*.txt, subject_*.txt and y_*.txt files are actually large tables
#further reading makes clear that subject.txt files contain the numer of the subject observed, y.txt files contain the type of body motion as described in activity_labels.txt, and x.txt files contain the observations as described in feature.txt
#this means that we can infer the column headers for y*.txt and subject*txt files, but must pull column headers for X*.txt files from features.txt
#since the project only calls for a few of the columns from x*.txt, it seems simpler to combine everything first, and attach labels after extracting what we want.


#first we will combine all of the test and train data into one large data frame.  We will also append the y_test and subjet_test data to the first two columns of this data frame.
#because only the data in x_test has labels for mean and standard deviation, we wont worry about the data contained in the intertial signals subdirectory

compile_data<-function(){
  table1<-function(){
    #lets use core R function to create a dataframe of the test data
    xtest<-read.table(".//UCI HAR Dataset/test/x_test.txt", header=FALSE, strip.white = TRUE)

    stest<-read.table(".//UCI HAR Dataset/test/subject_test.txt", header=FALSE, strip.white = TRUE)

    ytest<-read.table(".//UCI HAR Dataset/test/y_test.txt", header=FALSE, strip.white = TRUE)

    return(cbind(stest,ytest,xtest))
  }

  table2<-function(){
    #lets use core R functions to create data frame of the train data
    xtest<-read.table(".//UCI HAR Dataset/train/x_train.txt", header=FALSE, strip.white = TRUE)
    
    stest<-read.table(".//UCI HAR Dataset/train/subject_train.txt", header=FALSE, strip.white = TRUE)
    
    ytest<-read.table(".//UCI HAR Dataset/train/y_train.txt", header=FALSE, strip.white = TRUE)
    
    return(cbind(stest,ytest,xtest))
  }
  #lets return a single dataframe that contains the compiled data
  return(rbind(table2(),table1()))
  
}

compiled<-compile_data()
#now we need to get just the data we want, those observations of the mean and standard deviation
#mean and standard dev are indicated by functions with the "mean" or "std" in their name as described in features.txt
#even better, they use mean() and std() consistently, so lets create a function that searches for these and pulls out those columns for us
#we have to assume that the order in that file matches the order of columns

#lets rename the first two columns to keep track of them
names(compiled)[c(1,2)]<-c("subject","activity")

#and then lets give the rest of the columns descriptive names.  These are taken from the features.txt file
temp<-read.table(".//UCI HAR Dataset/features.txt", header=FALSE, strip.white = TRUE)
names(compiled)[3:563]<-as.character(temp$V2)

#finally, it is clear the subjects and activities should be factors, so lets fix that
compiled[,1]<-as.factor(compiled[,1])
compiled[,2]<-as.factor(compiled[,2])

#lets go through the file features.txt and identify which colums we need
list<-function() {
  test<-read.table(".//UCI HAR Dataset/features.txt", header=FALSE, strip.white = TRUE)
  list1<-grep("*mean()*", test[,2])
  list2<-grep("*std()*", test[,2])
  list3<-c(list1,list2)
  return(list3)
}

#notice the +2 when subsetting from list.  the features.txt files is numbered from x*.txt, not from the combination of x+the others
extracted<-compiled[,c(1,2,list()+2)]

#now lets name the activities.  These are found in activity_labels.txt

temp<-read.table(".//UCI HAR Dataset/activity_labels.txt", header=FALSE, strip.white=TRUE)


#now let's change the names list of activity numbers into factors, and then reassign level names

levels(extracted[,2])<-temp[,2]



#now, our final step, to create a final data frame with the averages of each column by subject and activity
#dplyr is great for this, so lets use it!
library(dplyr)
#create a local data frame
average <- tbl_df(extracted)
#group by subject and activity
average <-group_by(average, subject, activity)
#create our averages
average<-summarize_each(average, funs(mean))

