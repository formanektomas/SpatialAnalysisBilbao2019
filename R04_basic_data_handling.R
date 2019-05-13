#### Reading data from a "folder/file" in the Working directory
#
# Header = TRUE by default for read.csv(), FALSE for read.table()
Auto <- read.csv("datasets/Auto.csv") 
str(Auto)
head(Auto)
#
# If the dataset is large and you only need some of the variables and/or observations,
# you may choose to subset and save a selected part of the data:
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
#
v2 <- v1[!is.na(v1)] # All non-NA values from v1 are saved to v2,
v3 <- c(na.omit(v1)) # same result as from the line above.
#
#
# 
#
# Missing values: Loading external data files with missing values (NAs)
#
# By default, only empty data fields and "NA" entries get interpreted as NA's.
# (in logical, numeric, integer and complex datasets)
# Other NA's (na.strings), such as ".", "XXX" or "Missing value" must be
# explicitly passed to the read.table / read.csv function
#