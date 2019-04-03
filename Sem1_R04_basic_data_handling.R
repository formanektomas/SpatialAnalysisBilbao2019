#####     Using packages/libraries, loading and writing external data   #####  
#
# R packages are usefull add-ons for specific tasks
# The ISLR package contains datasets for the book
# An Introduction to Statistical Learning 
# (with Applications in R)
#
rm(list=ls())
search() # search order for objects (commands, functions), inclucing
         # 'loaded' (active) packages. User-installed packages must be
         # 'loaded' at each R session: using require() or library()
#
# install.packages("ISLR")
# Install using R-Studio menus: Tools > Install Packages.
# For uninstall, see ?remove.packages
# 
library("ISLR") # Loads ('activates') the package/library
help(package = ISLR) # Documentation for package ‘ISLR’ version 1.0
#
search() 
# Notice the search-order. If there are two different data-sets
# named "Auto", in ILSR and in "datasets",
# ISLR's dataset is loaded and the other is "masked".
#
#
# Create a dataset in Global Environment, using the ISLR package
myData <- Auto # 'Auto" is a dataset in a ISLR package
class(myData)  
# Data frame is the most common table-like object used
# to store data.
str(myData) 
# There are multiple ways to preview the data
View(myData)
head(myData, 8) # Use ?head to find the default no. of displayed rows
tail(myData, 3)
#
# Accessing individual variables in a dataframe
myData$year
summary(myData$cylinders)
mean(myData$weight)
sd(myData$weight)
var(myData$weight)
#
# Let's create a new binary variable in myData: 
# eightCyl = 1 if the car has 8 cylinders and 0 otherwise
# 
myData$eightCyl <- 0
myData$eightCyl[myData$cylinders == 8] <- 1
View(myData)
# The same may be done using this one-line command
myData$eightCyl.v2 <- as.numeric(myData$cylinders == 8)
# 
#
# What happens if we drop the 'as.numeric()'  from previous command?
myData$eightCyl.v3 <- myData$cylinders == 8
#
# 
# We may remove any variable (column) from a data frame
myData$eightCyl <- NULL
# 
#
#
## Assignment 1
## The interpretation of the "origin" variable in myData
## is as follows:
##    1 = American, 2 = European, 3 = Japanese
## 
## a) Make a new variable carOrigin, as follows:
myData$carOrigin[myData$origin == 1] <- "American"
myData$carOrigin[1:100]
## b) Use the above example to fill in the "NA" values 
##    for European and Japanese cars
##
class(myData$carOrigin)
## c) Using the as.factor function, make carOrigin variable a Factor  
?as.factor # .. you only need to provide the "x = myData$carOrigin" argument
##
#
############################################################################
#
rm(list=ls())
#
#
#
#### Reading data from a file in the Working directory
#
# Header = TRUE by default for read.csv(), FALSE for read.table()
Auto <- read.csv("datasets/Auto.csv") 
str(Auto)
head(Auto)
#
#
Subset1 <- Auto[1:100, c(9, 7, 1)] # First 100 rows, 3 columns
str(Subset1)
head(Subset1)
#
# Data may be saved to disk (Working directory) as follows:
#
?write.table # Have a look at the arguments and their default values 
# .. hint: Note the row.names = TRUE argument 
write.csv(Subset1, file = "datasets/Subset1.csv", row.names = F)
#
Subset1.reload <- read.csv("datasets/Subset1.csv") # 
str(Subset1.reload) 
head(Subset1.reload)
rm(list=ls())
#
#
# 
#
#### Dealing with missing data - 'NA' values
#
#
#
v1 <- c(-10, 5, 3, 0, NA, 1, -1, NA, 4)
class(v1)
length(v1)
summary(v1) # No. of NA values is displayed
# 
# Some specific features of NA handling by R:
#
v1 >= 0 # (NA >= 0) is evaluated as NA
mean(v1)    
range(v1)   
# mean(), var(), sd()
# and other basic data analyses may not be performed
# unless NA's are dealt with properly.
#
mean(v1, na.rm=TRUE) # NA values are ignored during the calculation
#
#
is.na(v1) # Tests the objects, returns TRUE if object (vector element) is NA.
which(is.na(v1)) # returns the indices of TRUE values within a vector (object)
#
v2 <- v1[!is.na(v1)] # All non-NA values from v1 are saved to v2,
v3 <- c(na.omit(v1)) # same result as from the line above.
#
#
# 
#
# Missing values: Loading external data files with missing values (NAs)
#
# By default, only empty data fields get interpreted as NA's.
# (in logical, numeric, integer and complex fields)
# Other NA's (na.strings), such as "." or "Missing value" must be
# explicitly passed to the read.table / read.csv function
#
#
USA <- read.csv("datasets/USA_states.csv")
# Amended from the state.x77 dataset from the Datasets package
fix(USA) # Are there missing values? How are they encoded?
str(USA) 
# Note the class of variable with missinterpreted NA values...
#
## Assignment 3
?read.csv
## Amend the following "read.csv" command on line 161 to import the "USA_states.csv" file
## properly. 
USA <- read.csv("USA_states.csv", na.strings = c("...", ))
## 
## 
#
rm(list=ls())
#
#
#### Combining two datasets (matrices, dataframes)
#
#
## Add new rows / new observations / of given variables to a dataset:
?rbind
# Example
set.seed(1) # For reproducible random numbers in R 
myMatrix <- matrix(rnorm(60, mean=10, sd=4), ncol=6)
myMatrix # column names may be assigned
dim(myMatrix)
#
vect <- c(1:6)
myMatrix <- rbind(myMatrix, vect)
myMatrix # note the row.name "vect"
myMatrix <- rbind(myMatrix, c(10, 12, 13, 14, 15, 16))
myMatrix
# Also, note that proper dimensions need to observed for rbind()
myMatrix <- rbind(myMatrix, c(1:10))
#
#
# Have a look at the ?cbind function as well.
Data1 <- as.data.frame(matrix(rnorm(30, mean=10, sd=4), ncol=3))
Data1
class(Data1)
#
Data2 <- as.data.frame(matrix(rnorm(40, mean=10, sd=4), ncol=4))
colnames(Data2) <- c("X1","X2","X3","X4")
Data2
#
Data3 <- cbind(Data1,Data2)
Data3
#
#
# 
#########################################
# merge() function discussed separately #
#########################################