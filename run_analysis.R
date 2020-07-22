library(dplyr)

setwd("C:/Users/Waylan/Desktop/Getting_and_Cleaning_Data_Project")


url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, "Project_data.zip")
unzip(zipfile="Project_data.zip")

list.files()

setwd("./UCI HAR Dataset/train")

x_train<-read.table("X_train.txt")
y_train<-read.table("y_train.txt")
subject_train<-read.table("subject_train.txt")


setwd("../")
setwd("./test")

x_test<-read.table("X_test.txt")
y_test<-read.table("y_test.txt")
subject_test<-read.table("subject_test.txt")

setwd("../")
features<-read.table("features.txt")
activity_labels<-read.table("activity_labels.txt")

colnames(x_train)<-features[,2]
colnames(y_train)<-"Activity_ID"
colnames(subject_train)<-"Subject_ID"


colnames(x_test)<-features[,2]
colnames(y_test)<-"Activity_ID"
colnames(subject_test)<-"Subject_ID"

colnames(activity_labels)<-c("Activity_ID", "Activity_Desc.")


Train_Data<-cbind(subject_train, y_train, x_train)
Test_Data<-cbind(subject_test, y_test, x_test)

Combined_Data<-rbind(Train_Data, Test_Data)


##Part 2: Extract the desired Data
Extract_Data<-select(Combined_Data, Subject_ID, Activity_ID, contains("mean()"), contains("std()"))


##Part 3 & 4: Name the activities
Extract_Data$Activity_ID<-factor(Extract_Data$Activity_ID, labels=activity_labels$Activity_Desc.)
write.table(Extract_Data, "Combined_Tidy_Data.txt")


##Part 5: Summarize the data

Summarized_Data<-Extract_Data %>% group_by(Subject_ID, Activity_ID) %>% summarise_if(is.numeric, funs(mean))
write.table(Summarized_Data, "Summarized_Tidy_Data.txt")
