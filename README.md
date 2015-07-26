# ReadMe

This is the ReadMe file for **Coursera Getting and Cleaning Data course Project**. It is supplemented with the following files:

1. *TidyDataset.txt* - tidy data set
2. *run_analysis.R* - script for performing the analysis
3. *CodeBook.md* - code book that describes the variables, the data and the cleanup performed

These are accompanied by *Human Activity Recognition Using Smartphones Data Set* which can be downloaded from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) and should be unzipped to the same directory where the script is run. Alternatively, this code can be used (please note it has only been tested in Microsoft Windows 7 environment):

```{r}
temp <- tempfile()
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, temp)
unzip(temp)
unlink(temp)
```

## Tidy data set

To load the tidy data set from the working directory into R the following code can be used:

```{r}
data <- read.table("./TidyDataset.txt", header=TRUE)
View(data)
```

## Script breakdown

The R script used to generate the tidy data set assumes that it is run from the working directory and that the Samsung data set (*UCI HAR Dataset* directory with its contents) is already inside it. For the most part it is self-suficient with the exception of the package *reshape2* which should be installed prior to running the last step.

#### Step 1

For the first step we were instructed to merge the training and the test sets to create one data set. Script starts by reading 3 files into appropriate tables for each of the sets: 1-column table for subjects (`trainSubjects` and `testSubjects`), 1-column table for activities (`trainActivities` and `testActivities`) and 561-column table for variables (`trainVariables` and `testVariables`). It then combines them by columns into one table for each data set (`trainDataset` and `testDataset`), starting from subjects and activities columns. Finally, both data sets are combined by rows into one unique data set (`wideDataset`).


#### Step 2

In the second step the project instructions asked us to extract only the measurements on the mean and standard deviation for each measurement. Script does this by first reading the file with the list of variables into the table `variables`. Since this is a 2-column table in which the element order corresponds to the numbers in the 1st column and the 2nd column contains names of variables, script directly converts the 2nd column to a vector `variableNames`. It then uses the function `grepl` and regular expression pattern that matches either `mean()` or `std()` inside the `variableNames` vector to create a new vector `selection`. These selected variable names  along with the first two columns that contain identifiers for subjects and activities (`c(TRUE,TRUE)`) are added to the new vector `columns` using the function `append`. Based on the latter vector, the columns in wide data set are subsetted to a new narrow data set (`narrowDataset`).


#### Step 3

For the next step we were instructed to use descriptive activity names to name the activities in the data set. In order to achieve this, script first reads the file with the list of activities into table `activities` and from its 2nd column creates a new vector `activityNames` as described in the previous step. Based on the newly created vector it replaces the numerals in the 2nd column of `narrowDataset` with the relevant names of activities.


#### Step 4

For this step instruction was given to appropriately label the data set with descriptive variable names. Script first creates vector `columnNames` that contains names of all the columns in the data set using the function `append` based on previously defined vectors `idNames` for the first 2 columns containing identifiers and `variableNames[selection]` for the next 66 columns containing variables. Based on this vector script then renames the columns using the function `colnames`.


#### Step 5

For the final step we were instructed to use dataset from step 4 in order to create a second, independent tidy data set with the average of each variable for each activity and each subject. To achieve this, script uses two functions from the library *reshape2*: `melt` and `dcast`. First the wide-format data set from step 4 is melted into the long-format data set based on the appropriate previously defined vectors for identifiers and variables. Then the newly created data set (`meltedDataset`) is recast by calculating the mean of each variable for each subject and activity into the final data set named `tidyDataset`. Ultimately, output file is generated using the `write.table` function according to the instructions.
