#### Spatial error model & KNN-based neighbors
#  
#
#
#  
#   Example of a spatial error model for NUTS2 regions of
#   Austria, Czech Republic, Germany, Hungary, Poland, Slovakia
#
#
# 
# Data, data description & plots
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
knns <- knearneigh(coords, k=12, longlat=T) # returns 12 nearest neighbors
nb.knn <- knn2nb(knns, sym = T) # converts object into neighbours list
W.matrix <- nb2listw(nb.knn) # calculates spatial weights
summary(W.matrix)
#
#
#
# # Basic OLS model for subsequent model selection & tests
OLS.1 <- lm(U_pc_2012 ~ I(EUR_HAB_EU_2011-EUR_HAB_EU_2010) + TechEmp_2012, data=CE_data)
summary(OLS.1)
AIC(OLS.1)
BIC(OLS.1)
#
# Specification test (spatial dependence) for KNN-based neigbors, k = 12
lm.LMtests(OLS.1, W.matrix, test=c("LMlag", "LMerr", "RLMlag", "RLMerr"))
#
#
#
#
# Spatial error model for KNN, k = 12
?spatialreg::errorsarlm
spatial.err <- errorsarlm(U_pc_2012 ~ I(EUR_HAB_EU_2011-EUR_HAB_EU_2010) + TechEmp_2012, 
                            data=CE_data, W.matrix)
summary(spatial.err)
AIC(spatial.err)
BIC(spatial.err)
#
#
## Assignment 1
## Replicate the Actual vs. fitted values plot as in 
## Spatial lag model (W4_R_9_Spatial_lag.R)
##
#
#
#
#
## Assignment 
## Use a spatial error model "spatial.err" (line 58) and
## replicate the coefficient stability plots as shown in previous example:
## LogLik, AIC, all beta-coefficients and the spatial error AR term
## Use KNN-based neigbors, for k = 2 to k = 11 
## .. use increments of 1 (add one neigbor at a time)
#
#
#
#
#
#
#
#