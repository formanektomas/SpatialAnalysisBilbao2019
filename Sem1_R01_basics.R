#####     Introduction to R: selected commands and objects     #####
#
#
#
##### Summing, multiplying and other basic operations among scalars
#
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
a <- c(3, 7, 11)
b <- 1:17
c <- 1:6
# 
# Multiplying two vectors (corresponding lengths)
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
M3 <- M1%*%M2 
M3
colnames(M3) <- colnames(M1)
M3
#
a <- c(1,7,2)
M2%*%a # Multiply matrix by a vector, vectors are "column" by default
#        .. Note the dimension of the output...
#
# Transposing a matrix
M2
t(M2) # Transpose M2
M2 - t(t(M2))
rm(list=ls())
#
#
#
## Assignment 2
## a) Make a 5x5 matrix M5 using random numbers: iid N(0,1)
set.seed(10)
M5 <- matrix(rnorm(25), ncol=5)
## b) Use solve() function to calculate inverse matrix to M5
##    .. hint: use ?solve   
##    and save the result as "invM5".
## c) Multiply M5 and invM5 into the Console (do not save as a new object)
##    
## d) Round the output from c) to two decimal points
##    .. hint: use ?round 
#
#
#
#
###### Subsetting a vector
#
rm(list=ls())
vec <- 80:200
vec
vec[1] # show first element of "vec"
vec[1:10] # show elements 1-10 of "vec"
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
mtcars <- mtcars
head(mtcars)
str(mtcars)
# Subset:
mtcars[1:3, c(3:5,7)]
mtcars[1:10,"hp"]
mtcars[1:10, c("hp", "vs", "cyl")]
#
#
#
#
### using $ to access variables from a DF
#
mtcars$mpg
mtcars$mpg[1:10]
#
#
#
#
##### Loops
# If you want to perform an operation multiple times, we can use:
#
# For loop -> we know how many times we want to do the operation
# while loop -> we dont know how many times, but we have a variable 
#               that will turn FALSE when the loop should stop

# Simple loop, prints 1, 5, 6
for (j in c(1,5,6)) {
  print(j)
}
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
#
# While is a type of loop that is repeating the code until some condition is evaluated as false
#
# First, we set i equal to 2
rm(list=ls())
i <- 2 
while (i < 1*10^5) { 
  i <- i^2  
  print(i) # Prints the value to Console
}
# The condition here is (i<100000) which is true if i<100000 and false otherwise, 
# so if i>100000 the code will stop repeating. 
# .. Hence, what if we change the code and set i = 1?
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
#### Functions - basic rules and examples
#
# Declare a simple function - no arguments
myFunction1 <- function() {
  myNoise1 <- rnorm(30, mean=10, sd=0.5) #we set custom defaults for rnorm
  print(myNoise1) # alternatively, use return()
} 
# Run a function
myFunction1()
#
#
#
#
# Arguments are usually passed to (used in) funtions:
# 
myFunction3 <- function(n) {
  set.seed(1) # 
  myNoise3 <- rnorm(n, mean=10, sd=2.5)
  print(myNoise3)
}
# This function creates 'n' normally distr. random numbers with mean=10 and sd=0.5
# We have to provide 'n' as an argument to the function myFunction4()
myFunction3(10)
myFunction3(n = 4)
#
#
## 
## Assignment 3
## Create a function myFunction4, that would print (Console) n random
## numbers from a specified normal distribution (iid), i.e.
## for a given mean and standard deviation. 
## Your function will have three arguments: 
##  n (# random numbers returned), m (mean), and s (s.d.).
##
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
8 != 9
(8 == 9) | TRUE
FALSE & TRUE
xor(8 > 7, 8 != 8)
any(T, F, F)
all(T, F, T, T)
A <- -10:10
A
length(A)
any(A >= 12)
all(A <= 7)
#
## which() command is used to find indices of elements
#          satisfying given condition
which(A > 5)
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
# You may consider using ?traceback, ?debug or ?browser.
#
#
# 