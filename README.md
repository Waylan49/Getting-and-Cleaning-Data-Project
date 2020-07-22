---
title: "Gettign and Cleaning Data Project"
author: "Weilun Chiu"
---

## Step 1: Download & read data into R

```{r, fig.height=5, fig.width=5}
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, "Project_data.zip")
unzip(zipfile="Project_data.zip")

list.files()
```

So now we have the target files in our folder, the next thing we need is to read te data into our R.


```{r, fig.height=5, fig.width=5}
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
```

After reading the data into R, we need to give the column names for each datasets since originally it dones't have it.

```{r, fig.height=5, fig.width=5}
colnames(x_train)<-features[,2]
colnames(y_train)<-"Activity_ID"
colnames(subject_train)<-"Subject_ID"


colnames(x_test)<-features[,2]
colnames(y_test)<-"Activity_ID"
colnames(subject_test)<-"Subject_ID"

colnames(activity_labels)<-c("Activity_ID", "Activity_Desc.")
```

So now we have column namse for each dataset, now we can try to combine the data. 
Let's combine the train data first. 

```{r, fig.height=5, fig.width=5}
Train_Data<-cbind(subject_train, y_train, x_train)
Test_Data<-cbind(subject_test, y_test, x_test)
```

Now we have our complete train and test data, let's combine these two data sets together. 

```{r, fig.height=5, fig.width=5}
Combined_Data<-rbind(Train_Data, Test_Data)
```


##Part 2: Extract the desired Data
We only need measurements on the mean and standard deviation for each measurement.

```{r, fig.height=5, fig.width=5}
xtract_Data<-select(Combined_Data, Subject_ID, Activity_ID, contains("mean()"), contains("std()"))
```



##Part 3 & 4: Name the activities
Uses descriptive activity names to name the activities in the data set.
Appropriately labels the data set with descriptive variable names.

```{r, fig.height=5, fig.width=5}
Extract_Data$Activity_ID<-factor(Extract_Data$Activity_ID, labels=activity_labels$Activity_Desc.)
write_xlsx(Extract_Data, "Combined_Tidy_Data.xlsx")
```


##Part 5: 
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

```{r, fig.height=5, fig.width=5}
Summarized_Data<-Extract_Data %>% group_by(Subject_ID, Activity_ID) %>% summarise_if(is.numeric, funs(mean))
write_xlsx(Summarized_Data, "Summarized_Tidy_Data.xlsx")
```
