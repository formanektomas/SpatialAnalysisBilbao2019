#####  LRM with cross-sectional data  ##### 
#
#
rm(list=ls())
lungCapacity <- read.table("datasets/LungCapacity.txt", header = T, sep = "\t")
#
#
class(lungCapacity)
sapply(lungCapacity, class)
dim(lungCapacity)
head(lungCapacity)
str(lungCapacity) # complex information
summary(lungCapacity) # class-specific information is provided
pairs(lungCapacity) # the same result as plot(lungCapacity)
#
# Basic data analysis
#
plot(lungCapacity$Smoke, lungCapacity$Age)
# plot(x, y, ...)
#
#
#
#
#### Linear regression models
#
#
lrm1 <- lm(LungCap ~ Age, data=lungCapacity)
summary(lrm1)
#
lrm2 <- lm(LungCap ~ Age + Height, data=lungCapacity)
summary(lrm2)
#
lrm3 <- lm(LungCap ~ Age + Height + Smoke , data=lungCapacity)
summary(lrm3)
# Smoke is a "factor". Notice that it is included into
# the LRM as a dummy, with r-1 levels being included.
# The first category to appear in the data is chosen as 'reference'
# 
# 
# What happens if we remove the intercept from lrm3 ?
#
# lrm3 without the intercept:
lrm4 <- lm(LungCap ~ Age + Height + Smoke -1, data=lungCapacity)
summary(lrm4)
#
# Note that Intercept gets excluded using "- 1"
# 
summary(lrm3)$coefficients
summary(lrm4)$coefficients
# Compare & interpret the coefficients of lrm3 and lrm4.
#
# Re-level may be used for interpretation/presentation purposes:
lungCapacity$Smoke <- relevel(lungCapacity$Smoke, ref= "yes")
summary(lm(LungCap ~ Age + Height + Smoke , data=lungCapacity))$coefficients
#
#
# Sometimes, we want to start the regression analysis by including
# all regressors: "~ ." uses all the variables except the dependent
# variable as regressors.
# Note: What if data frame contains variables with factors such as 
#       individual's names, addresses, etc.?
#
lrm5 <- lm(LungCap ~ ., data = lungCapacity)
summary(lrm5)
#
#
# Simple model comparison (requires identical dependent variable)
lrm1
lrm3
# F-test for linear parameter restrictions: 
# H0: expanding lrm1 to lrm3 is not statistically
# significant
anova(lrm1, lrm3)
str(anova(lrm1, lrm3))
# 
#
#
#### More LRM specification topics, interaction terms
#
# Logarithms log(x) and square roots sqrt(x)
# are easy to include into a LRM:
summary(lm(LungCap ~ Age + log(Height) + sqrt(Height), data = lungCapacity))
# 
# Due to R's formula evaluation properties, most
# regressor transformations need to be included using identity I() operator:
#
summary(lm(LungCap ~ Height^2 + 1/Age, data = lungCapacity))
# vs
summary(lm(LungCap ~ I(Height^2) + I(1/Age), data = lungCapacity))
# 
#### Polynomials
#
# Polynomials may be conveniently passed to lm() using the poly() function:
# For Height, Height^2, Height^3 and Height^4, we use 
# 
summary(lm(LungCap ~ poly(Height, degree=4, raw=TRUE), data = lungCapacity))
# Use ?poly() find out what "raw=TRUE" does.  
# 
#
#### Main effects and interaction terms
#
summary(lm(LungCap ~ Age*Height, data = lungCapacity))
#
# R solves the ' Age*Height' argument by including
# both 'main effects' and the 'interaction term'.
# NOTE: If the interaction term's coefficient is statistically
# significant, we should leave the main effects in our LRM
# regardless of their p-values. 
#
# Should we choose oterwise, we do so by using the I() operator.
# Here, we leave Height (main effect) out of the previous specification
summary(lm(LungCap ~ Age + I(Age*Height), data = lungCapacity))
#
#