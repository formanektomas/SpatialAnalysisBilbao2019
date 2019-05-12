#####     Introduction to R: selected commands and objects     #####
#
#
#
##### Summing, multiplying and other basic operations among scalars
#
3+5
#
x <- 10 + rnorm(1, mean=0, sd=2)
x
x*x
x^2
x^3
x+x
sqrt(x)
log(x)
exp(x)
#
#
# Special "values": NaN and Inf
0/0 # Not a Number, undefined value
1/0 # Infinity
-1/0
#
#
##### Multiplying scalars and vectors
#
a <- c(3, 7, 11) # vector a has 3 elements
b <- 1:17        # b has 17 elements
c <- 1:6         # c has 6 elements
# 
# Multiplication  -  vectors
x
a
x*a # Each element of vector a is multiplied by scalar x 
# 
#
a
length(a)
c
length(c)
a*c # elements of a and c are individually multiplied, a 'loops' twice
#
#
# Multiplying two vectors (non-corresponding lengths)
a
length(a)
b
length(b)
a*b # element-wise multiplication is performed even if the length
# of the longer vector is not a multiple of the shorter object
# length - warning message is displayed
rm(list=ls())
#
#
#
##### Matrices
#
# Matrix: set a matrix, assign names to columns/rows, access matrix elements
?matrix 
M1 <- matrix( 1:9, ncol=3)
M1
# By default, R creates matrices by filling in columns.
# This may be changed using the byrow=TRUE argument
M2 <- matrix( 9:1, byrow=TRUE, ncol=3)
M2
dim(M1)
summary(M1) # columns treated as variables, rows as observations
#
#
?colnames
colnames(M1) <- c("CL_1", "CL_2", "CL_3")
M1
colnames(M1)
summary(M1)
#
## Assignment 1
## Use ?rownames & assign names to all rows of the M1 matrix
## .. you can use "RW_.." pattern to name the rows
#
#
# 
##### Matrix multiplication operator is %*%
#
M3 <- M1 %*% M2 
M3
colnames(M3) <- colnames(M1)
M3
#
#
#
###### Subsetting a vector
#
rm(list=ls())
vec <- 80:200
vec
vec[1] # show first element of "vec"
vec[1:10] # show elements 1-10 of "vec" (colon makes a sequence)
vec[c(1:10, 20, 50, 100)] # show selected elements of "vec"
vec[-c(1:10)] # show all elements of "vec" but the 1-10 elements
#
#
##### Subsetting a matrix
#
rm(list=ls())
set.seed(10)
M5 <- matrix(rnorm(25), ncol=5)
M5
M5[2,3] # the element in 2nd row and 3rd column is returned
# by default, this element is returned as a vector of length 1
# this "output simplification" may be turned off by using the argument drop=FALSE
# 
M5[2,3, drop=FALSE]
# 
M5[,2] # missing row ids: all rows, i.e. whole column is returned 
M5[, 2, drop=FALSE] # drop output simplification
M5[1,] # missing column ids: all columns, i.e. whole row is returned 
M5[1, , drop=FALSE]
M5[1:2,]
rm(list=ls())
#
#
#
## Subsetting a dataframe
mtcars <- mtcars # mtcars is a built-in dataset in R
head(mtcars)
str(mtcars)
# For dataframes, various subset options are available:
mtcars[1:3, c(3:5,7)]
mtcars[1:10,"hp"]
mtcars[1:10, c("hp", "vs", "cyl")]
# using $ to access variables from a DF
mtcars$mpg
mtcars$mpg[1:10]
#
#
#
#
##### Loops
# If you want to perform an operation multiple times, we can use:
#
# "for loop" -> we know how many times we want to do the operation
# "while loop" -> we dont know how many times, but we have a variable 
#               that will turn FALSE when the loop should stop
#
# We can put anything into the iterating vector
for (i in c("Hello","World!")) {
  print(i)
}
# When do we use for loop? 
# When you know how many times it will run!
for (i in 1:10) {
  print(mtcars[i,c("mpg","cyl","hp")])
}
#
#
#
#
##### Conditionals (Control structure if-else)
#
# Evaluate and execute the code only if some condition is evaluated to TRUE
#
i <- 100 + rnorm(1, mean = 0, sd = 10)
if (i > 100) {
    print(paste("i =", i, "and  i is bigger than 100."))
} else {
    print(paste("i =", i, "and i is lower or equal to 100."))
}
#
# For simple one-line evaluation, ifelse() may be used as well
?ifelse
ifelse(i > 100, "i > 100.", "i <= 100." )
#  
# 
#
#
#
#
#
#### Selected Logical operators
#
#    <         less than
#    <=	       less than or equal to
#    >	       greater than
#    >=	       greater than or equal to
#    ==	       exactly equal to
#    !=	       not equal to
#    x | y	   x OR y
#    x & y	   x AND y
#    xor(TRUE, FALSE) evaluates to TRUE if one elements evaluates
#                     to TRUE while other evaluates to FALSE
#    any()     TRUE if at least one element evaluates to TRUE
#    all()     TRUE if all elements evaluate to TRUE
#
rm(list=ls())
11 > 11
11 >= 11
8 == 9
8 != 9 # condition "not equal to" is evaluated 
(8 == 9) | TRUE
FALSE & TRUE
any(T, F, F)
all(T, F, T, T)
#
#
# Logical conditions used on data:
#
A <- -10:10
A
# Check data, find entries with values over 3
A > 3
# Return only values bigger than 3
A[A>3]
B <- A[A>3]
B # note that A and B have different dimensions
#
## which() command is used to find indices (positions) of elements
#          satisfying given condition
which(A == 0)
A[11] # the eleventh element of the vector A equals to 0...
# 
#
#
#
#
# 
#### Debugging 
#
# Need to debug? Use print(object) to verify your output.
# Google error messages (Copy and paste error messages to a web-browser).
# use https://stackoverflow.com/tags/r/info   to search for help
# You may consider using ?traceback, ?debug or ?browser.
#
#
# 