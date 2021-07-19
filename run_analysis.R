library("dplyr","reshape2") # Loads the dplyr and reshape2 packages into R

# Changes the directory to the UCI HAR Dataset folder
# (to help save some time typing out locations of directories).
# Change the path such that you are in the UCI HAR Dataset

setwd("/Users/alex/Desktop/UCI HAR Dataset/")

# Reading in relevant data to R (X test, test labels, subject test,
# x training data, y training data, subject training, features,
# and activities data as table variables).

feat.var <- read.table("features.txt", col.names = c("col_number","variables"))
activ.lab <- read.table("activity_labels.txt", col.names = c("ident","activity"))
x.test <- read.table("test/X_test.txt", col.names = feat.var$variables)
y.test <- read.table("test/y_test.txt", col.names = "ident")
subj.test <- read.table("test/subject_test.txt", col.names = "subject")
x.train <- read.table("train/X_train.txt", col.names = feat.var$variables)
y.train <- read.table("train/y_train.txt", col.names = "ident")
subj.train <- read.table("train/subject_train.txt", col.names = "subject")

# Merge all test data into one by x or y, all subject data from both training
# and testing, then merge everything into one by combining the columns so the 
# subject information is to the far left, then y data, then x data, with the 
# training data first and the testing data last going down rows. Also clean 
# up the data so that only variables with the subject and ident along with 
# anything that contains "mean" or "std" in its variable name.

x.data <- rbind(x.train,x.test); y.data <- rbind(y.train,y.test)
subj.merged <- rbind(subj.train,subj.test)
merged.data <- cbind(subj.merged,y.data,x.data)
tidy.data <- merged.data %>% select(subject, ident,
                                    contains("mean"), contains("std"))

# Replace the ident variable with names from the activ.lab object such
# that the numbers listed in activities now becomes the new values

tidy.data$ident <- activ.lab[tidy.data$ident, 2]

# Rename variables such that they are more descriptive

names(tidy.data)[2] = "activity"
names(tidy.data) <- gsub("Acc","accelerometer ", names(tidy.data))
names(tidy.data) <- gsub("Gyro","gyroscope ", names(tidy.data))
names(tidy.data) <- gsub("BodyBody","body ", names(tidy.data))
names(tidy.data) <- gsub("Body","body ", names(tidy.data))
names(tidy.data) <- gsub("Mag","magnitude ", names(tidy.data))
names(tidy.data) <- gsub("^t","time ", names(tidy.data))
names(tidy.data) <- gsub("^f","frequency ", names(tidy.data))
names(tidy.data) <- gsub("tBody","time body", names(tidy.data))
names(tidy.data) <- gsub(".mean","mean ", names(tidy.data), ignore.case = TRUE)
names(tidy.data) <- gsub("-mean()","mean ", names(tidy.data), ignore.case = TRUE)
names(tidy.data) <- gsub("-std()","standard dev ", names(tidy.data), ignore.case = TRUE)
names(tidy.data) <- gsub("-freq()","frequency ", names(tidy.data), ignore.case = TRUE)
names(tidy.data) <- gsub("angle","angle ", names(tidy.data))
names(tidy.data) <- gsub("gravity","gravity ", names(tidy.data), ignore.case = TRUE)
names(tidy.data) <- gsub("Jerk","Jerk ", names(tidy.data))
names(tidy.data) <- gsub("...X"," X", names(tidy.data))
names(tidy.data) <- gsub("...Y"," Y", names(tidy.data))
names(tidy.data) <- gsub("...Z"," Z", names(tidy.data))

# Convert the names of the tidy.data variables to a vector, then melt
# the tidy.data with indexes of "subject" and "activity", with the
# measurement variables being the third to 88th columns from the tidy data
# since the first two columns are the categorical variables we want to 
# organize by. Then, recast the data breaking up each subject and each
# activity and calculating the mean of each variable for each activity and
# each subject. Rename each new table such that the first column matches,
# so that they can be bound using rbind() and saved as one file later.

tidy.names <- as.vector(names(tidy.data))
melt.tidy.data <- melt(tidy.data, id = c("subject","activity"),
                       measure.vars = tidy.names[3:88])
summary.data.subject <- dcast(melt.tidy.data, subject ~ variable,mean)
names(summary.data.subject)[1] <- "subject or activity id"
summary.data.activity <- dcast(melt.tidy.data, activity ~ variable,mean)
names(summary.data.activity)[1] <- "subject or activity id"
merged.results <- rbind.data.frame(summary.data.subject,summary.data.activity)

# clean up the Global Environment so that only the tidy data is present

remove(activ.lab,feat.var,merged.data,subj.merged,
       subj.test,subj.train,x.data,x.test,x.train,
       y.data,y.test,y.train,melt.tidy.data,tidy.data,tidy.names,
       summary.data.activity,summary.data.subject)

# Write the results into a .txt file with the given title, then 
# look at it in R

write.csv2(merged.results, "Means_of_Subjects_and_Activities.txt",row.names = FALSE)
View(merged.results)