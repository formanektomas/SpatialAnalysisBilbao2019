#####     Introduction to ggplot2: basic plots & features
#
#
#
#
### Why ggplot2?  
#
# Pretty plots
# A systematic way of preparing plots
# Sophisticated graphs in a few lines - code does not require updating if data change.
# Unified, statistically-oriented approach to graphical representation.
# GG stands for Grammar of Graphics
#
#
#
###  Usefull ggplot2 websites
#
# http://docs.ggplot2.org/current/
# http://www.r-bloggers.com/basic-introduction-to-ggplot2/
# http://onepager.togaware.com/GGPlot2O.pdf
#
#
#
#####################################################################
#
# Data
#
library(ggplot2) # install.packages("ggplot2")
#
#### Examples based on the Diamonds dataset from {ggplot2}
rm(list=ls())
?diamonds
head(diamonds)
summary(diamonds)
str(diamonds)
# For plot readability, we shall use only 3.000 rows of the dataset (randomly selected)
#
?sample
?base:::sample
set.seed(10) # to ensure consistent random selection for the whole class
small <- diamonds[sample(nrow(diamonds),3000),] 
#
#####################################################################
#
# Example 1: Basic scatterplot price ~ carat
#
# [A]
# Simple plot using the R base plotting device:
plot(small$price~small$carat) # {graphics} package
#
# Plot repeated using {ggplot2}:
ggplot(small, aes(x=carat,y=price))+
  # First, we create ggplot object and populate it with a data frame,
  # along with basic aesthetics parameters (what is on the x and y axes)
  geom_point() # this layer defines plot type / scatterplot
#
# 
# [B]
# Adding colours - different colour for each "cut" 
ggplot(small, aes(x=carat,y=price, colour=cut))+ # amend basic aesthetics
  geom_point()
# Alternatively:
ggplot(small, aes(x=carat,y=price))+
  geom_point(aes(colour=cut))
#
# [C]
# Adding title to the plot
# .. Each plot feature is a "layer" 
# .. that may be expressed as additional line of code
ggplot(small, aes(x=carat,y=price))+ # note the `+` syntax
  geom_point(aes(colour=cut))+
  ggtitle("Price ~ carat plot example") # new layer  
#
# [D] 
# Adding facets - plotting data in "tiles" - for each cut-type
ggplot(small, aes(x=carat,y=price))+ 
  geom_point(aes(colour=cut))+
  ggtitle("Price ~ carat plot example")+
  facet_wrap(~cut) # this layer defines facets
#
# [E]
# Say, we want all facets in on column:
ggplot(small, aes(x=carat,y=price))+ 
  geom_point(aes(colour=cut))+
  ggtitle("Price ~ carat plot example")+
  facet_wrap(~cut, ncol=1) 
#
## Quick assignment 1
?facet_wrap
## Using the ?facet_wrap command, how do you amend the previous plot
## so that facets are arranged into 3 rows (and corresponding number
## of columns)?
#
# [F]
# Say, we want to add linear trend to the data
ggplot(small, aes(x=carat,y=price))+ 
  geom_point(aes(colour=cut))+
  ggtitle("Price ~ carat plot example")+
  facet_wrap(~cut, ncol=1)+
  geom_smooth(method= "lm") # new layer - linear trend
#
## Quick assignment 2
?geom_smooth
## Remove confidence intervals from the previous plot
#
## Quick assignment 3
## How would you re-combine the facetted plot [F] into a single plot?
#
# [G]
# Say, we want to facet for each cut & color combination
unique(small$cut)
unique(small$color)
#
ggplot(small, aes(x=carat,y=price))+ 
  geom_point(aes(colour=cut))+
  ggtitle("Price ~ carat plot example")+
  facet_wrap(cut~color, ncol=7)+ # facetting changed here
  geom_smooth(method= "lm")
#
# Alternative (transposed) plot
ggplot(small, aes(x=carat,y=price))+ 
  geom_point(aes(colour=cut))+
  ggtitle("Price ~ carat plot example")+
  facet_wrap(color~cut, ncol=5)+ # facetting changed here
  geom_smooth(method= "lm")
#
#
#####################################################################
#
#
#
# Additional ggplot2 examples:
#
#
# Histograms: 
ggplot(small, aes(x=price)) + 
  geom_histogram()
#
# Organize histogram into 10 'bins'
ggplot(small, aes(x=price)) + 
  geom_histogram(bins = 10)
#
# Show the composition of each bin:
ggplot(small, aes(x=price, fill=cut)) +
  geom_histogram(bins = 10)
#
# Using position="dodge" one can more easily compare each sub-bins:
ggplot(small, aes(x=price,fill=cut)) +
  geom_histogram(bins = 10, position="dodge")
#
# position="fill" is useful for showing relative proportions
ggplot(small, aes(x=price,fill=cut)) +
  geom_histogram(bins = 10, position="fill")
#
#
#
#
# Density plots are better suited than histograms for continuous variables:
ggplot(small, aes(x=price)) + 
  geom_density()
#
ggplot(small, aes(x=price, fill=cut)) +
  geom_density()
#
# We can use some transparency to distinguish between the distributions:
ggplot(small, aes(x=price,fill=cut)) +
  geom_density(alpha=0.5)
#
# Or use coloured lines instead of fill:
ggplot(small, aes(x=price,colour=cut)) +
  geom_density()
#
#
# geom_boxplot is used for box plots.
ggplot(small, aes(x=cut,y=price)) +
  geom_boxplot()
#
# We can color the boxes and use "themes"
ggplot(small, aes(x=cut, y=price, fill=cut)) + 
  geom_boxplot() +
  theme_dark() # different "themes" are available.
#
ggplot(small, aes(x=cut, y=price, fill=cut)) + 
  geom_boxplot() +
  theme_minimal() # different "themes" are available.
#
#
#
#
#