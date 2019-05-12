#### Spatial lag model
#
#
#  
#   Example of a spatial lag model for NUTS2 regions of
#   Austria, Czech Republic, Germany, Hungary, Poland, Slovakia
#
#
# 
# Data, data description & plots
library(ggplot2) # install.packages("ggplot2")
library(spdep) # install.packages("spdep")
library(spatialreg)
rm(list=ls())
CE_data <- read.csv("datasets/NUTS2_data.csv")
head(CE_data, 15)
tail(CE_data, 10)
plot(CE_data[ , c(4:7)])
#
#
# Data description:
# 
# U_pc_2012              Dependent variable, the general rate of unemployment 
#                        for a NUTS2 region i at time t (2012)
# EUR_HAB_EU_2011        region’s GDP per capita (current EUR prices of 2011) 
#                        expressed as percentage of EU average
# EUR_HAB_EU_2010 
# TechEmp_2012           percentage of employees working in the “high-tech industry” 
#                        (NACE r.2 code HTC) in a given region and t = 2012
# NUTS_ID                NUTS2 region-identifier (NUTS.2010)
# long, lat              coordinates of regions' centroids
#
#
#      Unemployment model to be estimated:
#
#      U_pc_2012 <- I(EUR_HAB_EU_2011-EUR_HAB_EU_2010) + TechEmp_2012
#
#
#     Distance based neighbors - maximum neighbor distance threshold: 250 km
#
#
#
# Step 1 Prepare spatial objects for subsequent analysis:
#
# (a) coordinates and IDs
coords <- CE_data[,c("long", "lat")]
coords <- coordinates(coords)
IDs <- CE_data$NUTS_ID
# (b) identify neighbors given tau distance threshold
nb250km <- dnearneigh(coords, d1=0, d2=250, longlat=T, row.names = IDs)
summary(nb250km)
# (c) calculate the spatial weights matrix
W.matrix <- nb2listw(nb250km)
summary(W.matrix)
#
#
#
#
#
## Quick exercise 1
## Test the dependent variable of our model "U_pc_2012"
## for spatial dependency and show "Moran plot" for this variable
?moran.test

?moran.plot

##
##
#
#
# Step 2 Basic OLS model + model selection tests
#
OLS.1 <- lm(U_pc_2012 ~ I(EUR_HAB_EU_2011-EUR_HAB_EU_2010) + TechEmp_2012, data=CE_data)
summary(OLS.1)
#
?lm.LMtests
lm.LMtests(OLS.1, W.matrix, test=c("LMlag", "LMerr", "RLMlag", "RLMerr"))
# Both LMlag and RLMlag reject H0 of no spatial dependence
# LMerr test rejects H0, but its robust version RLMerr does not.
# Hence, we prefer & use the spatial lag model specificaton.
#
#
#
#
#
# Step 3 Spatial lag model estimation, tests & plots
#
?lagsarlm # note e.g. the "Dubin" argument
spatial.lag <- lagsarlm(U_pc_2012 ~ I(EUR_HAB_EU_2011-EUR_HAB_EU_2010) + TechEmp_2012, 
                        data=CE_data, W.matrix)
summary(spatial.lag)
?LR.sarlm # Test the spatial lag specification against OLS model
LR1.sarlm(spatial.lag)
LR.sarlm(spatial.lag, OLS.1)
#
# Test for spatial randomness in residuals from the spatial lag model
moran.test(spatial.lag$residuals, W.matrix, 
           randomisation=FALSE, alternative="two.sided")
#
# Breusch-Pagan test for heteroskedasticity, generalized for spatial models,
# .. taking rho coefficient into account
bptest.sarlm(spatial.lag)
#
# Basic fitted vs. actual plot:
# plot(CE_data$U_pc_2012, spatial.lag$fitted.values, pch=16)
#
# Enhanced ggplot2 figure:
Fitted_Lag_250km <- spatial.lag$fitted.values
plot.df <- as.data.frame(Fitted_Lag_250km)
plot.df$Actual <- CE_data$U_pc_2012
plot.df$CountryCode <- substring(CE_data$NUTS_ID, 1,2)
#
ggplot(plot.df, aes(Actual, Fitted_Lag_250km)) +
  scale_x_continuous(limits = c(0,20), expand = c(0,0)) +
  scale_y_continuous(limits = c(0,20), expand = c(0,0)) +
  geom_segment(aes(x=0, xend=20, y=0, yend=20), linetype=2) + 
  geom_point(aes(color = CountryCode), size = 3) +
  ggtitle("General unemployment rate in %") +
  theme_bw()
#
#
#
#
## Quick exercise 2
##
## 1) Enhance the SLM model by allowing for spatial lag in regressors
##    .. ie use SDM specicifaction
# spatial.Durbin <- 
  
## 2) Use LR test to evaluate 
##    - spatial.Durbin against OLS-based model
##    - spatial.Durbin against spatial.lag

## 3) Evaluate spatial dependency and heteroskedasticity in residuals 

## 4) Plot Actual vs Fitted values 
##    .. review the code starting on line 106 to include output
##    .. from the spatial.Durbin (not spatial.lag) model


## 5) Repeat the above steps while setting tau to 170 km.


##
##
#
#
#
#
#
#