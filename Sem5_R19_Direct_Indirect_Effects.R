#### Impacts - direct and indirect effects (spillovers) 
#### using
#### Spatial lag model
#### Spatial Durbin model 
#
#
#  
# Data, data description & plots
library(ggplot2) # install.packages("ggplot2")
library(spdep) # install.packages("spdep")
rm(list=ls())
CE_data <- read.csv("datasets/NUTS2_data.csv")
# head(CE_data, 15)
# tail(CE_data, 10)
# plot(CE_data[ , c(4:7)])
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
# Step 2 Spatial lag model estimation, impacts
#
spatial.lag <- lagsarlm(U_pc_2012 ~ I(EUR_HAB_EU_2011-EUR_HAB_EU_2010) + TechEmp_2012, 
                        data=CE_data, W.matrix)
summary(spatial.lag)
# Impacts
?impacts
impacts(spatial.lag, listw= W.matrix)
#
impacts.obj <- impacts(spatial.lag, listw= W.matrix, R=500)
summary(impacts.obj, zstats=T, short=T)
# 
plot(impacts.obj)
#
#
#
# Step 3 Spatial Durbin model estimation: coefficients & impacts
#
spatial.Durbin <- lagsarlm(U_pc_2012 ~ I(EUR_HAB_EU_2011-EUR_HAB_EU_2010) + TechEmp_2012, 
                        data=CE_data, W.matrix, Durbin = T)
#
summary(spatial.Durbin) # Note the sign on spatial lag of TechEmp
#
# Impacts
impacts(spatial.Durbin, listw= W.matrix)
#
impacts.obj2 <- impacts(spatial.Durbin, listw= W.matrix, R=500)
summary(impacts.obj2, zstats=T, short=T)
plot(impacts.obj2)
#
#
#
#
#
## Quick Exercise:
## Evaluate stability of the results with respect to
## changing spatial structure
## use kNN method to set-up neighbors, as follows:
?knearneigh # use k = 4
?knn2nb     # use symmetric transformation: sym = T
W.matrix <- nb2listw()   # use nb2listw with the output from knn2bn

##
#
#
#
#