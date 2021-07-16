# Getting-and-Cleaning-Data
Submission Area for the Final Project of the Coursera Course "Getting and Cleaning Data"

################################################################################

For this particular project, this R code will utilize the dplyr and reshape2 
packages in order to analyze the UCI Dataset. First, it sets the working 
directory to "UCI HAR Dataset", which could be in different locations and 
for me happened to be on my Desktop. If you need to check, change the path
so that it lets you start in the folder where the data is.

Then, the script loads several objects in such a way to order and combine the
separate testing and training data into two separate tables. They are combined,
and several steps are taken to make sure that certain column names are set so
the merge can be successful. Using the select() function, it cleans up the data
such that the columns called "subject", "ident", and anything the contains eiter
"mean" or "std" are kept according to the instructions.
