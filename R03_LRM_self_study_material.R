#####  LRM with cross-sectional data  ##### 
#
#
rm(list=ls())
lungCapacity <- read.table("datasets/LungCapacity.txt", header = T, sep = "\t")
#
# Here, we evaluate lung capacity in kids (age 3 - 19), using various regressors
class(lungCapacity)
dim(lungCapacity)
head(lungCapacity)
str(lungCapacity) # complex information
summary(lungCapacity) # class-specific information is provided
pairs(lungCapacity) # the same result as plot(lungCapacity)
hist(lungCapacity$LungCap)
#
#### Linear regression models
#
# Simple linear regression
lrm1 <- lm(LungCap ~ Age, data=lungCapacity)
summary(lrm1)
# Multiple linear regression
lrm2 <- lm(LungCap ~ Age + Height + Smoke , data=lungCapacity)
summary(lrm2)
# Smoke is a "factor". Notice that it is included into
# the LRM as a dummy, with r-1 levels being included.
# The first category to appear in the data is chosen as 'reference'
# .. Intercept included by default, can be excluded using "- 1"
# 
# Re-level may be used for interpretation/presentation purposes:
lungCapacity$Smoke <- relevel(lungCapacity$Smoke, ref= "yes")
summary(lm(LungCap ~ Age + Height + Smoke , data=lungCapacity))$coefficients
#
#
# Sometimes, we want to start the regression analysis by including
# all regressors: "~ ." uses all the variables except the dependent
# variable as regressors.
#
lrm5 <- lm(LungCap ~ ., data = lungCapacity)
summary(lrm5)
#
#
# Simple model comparison (requires identical dependent variable)
lrm1
lrm2
# F-test for linear parameter restrictions: 
# H0: expanding lrm1 to lrm3 is not statistically
# significant
anova(lrm1, lrm2)
# Likelihood ratio test
library(lmtest) # install.packages("lmtest")
lrtest(lrm1, lrm2) # 2 * ( LL(ur) - LL(restr) ) follows chisq(q) under H_0
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
#
#