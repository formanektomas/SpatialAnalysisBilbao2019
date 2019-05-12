#### Coefficient stability in a spatial lag model
#
#    .. Conditional on varying neighbors definition
#    .. Distance based neighbors
#    .. Maximum neighbor distance thresholds, from 160 km to 1000 km.
#
#
#  
#   Example of a spatial lag model for NUTS2 regions of
#   Austria, Czech Republic, Germany, Hungary, Poland, Slovakia
#
#
# 
# Data, data description & plots
rm(list=ls())
CE_data <- read.csv("datasets/NUTS2_data.csv")
library(spdep) # install.packages("spdep")
library(spatialreg)
coords <- CE_data[,c("long", "lat")]
coords <- coordinates(coords)
IDs <- CE_data$NUTS_ID
#
#
# Data description:
# 
# U_pc_2012              Dependent variable, the general rate of unemployment 
#                        for a NUTS2 region i at time t (2012)
# EUR_HAB_EU_2011        region?s GDP per capita (current EUR prices of 2011) 
#                        expressed as percentage of EU average
# EUR_HAB_EU_2010 
# TechEmp_2012           percentage of employees working in the ?high-tech industry? 
#                        (NACE r.2 code HTC) in a given region and t = 2012
# NUTS_ID                NUTS2 region-identifier (NUTS.2010)
# long, lat              coordinates of regions' centroids
#
# NOTE: The "CE_data" dataframe contains the same data as the datasets used
#       in previous spatial data examples (1 - 3). Here, we only import data
#       for the variables & years used in the following spatial lag model.
#
#
#
#
#
# We crearte an "empty" data.frame to collect estimation results at different
# max. neighbor distance thresholds
s2.df <- data.frame(max.dist= 0, AIC= 0, LL= 0, 
                    Intercept= 0, GDP= 0, TechEmp= 0, 
                    lambda= 0, Intercept.SE= 0,
                    GDP.SE= 0, TechEmp.SE= 0, 
                    lambda.SE= 0)
#
# Main calculation: neighbors & W.matrices are calculated for
# distance thresholds from 160 km to 1.000 km (10-km iterations).
# Model data are stored into the "s2.df" data.frame
# .. calculation may take a few moments
#
for(j in 16:100) {
  nb <- dnearneigh(coords, d1=0, d2=j*10, longlat=T, row.names = IDs)
  W.m <- nb2listw(nb)
  spatial.lag <- lagsarlm(U_pc_2012 ~ I(EUR_HAB_EU_2011-EUR_HAB_EU_2010) + TechEmp_2012, data=CE_data,  W.m)
  s2.df <- rbind(s2.df, c(j*10, AIC(spatial.lag), 
                          spatial.lag$LL, 
                          spatial.lag$coefficients[1], 
                          spatial.lag$coefficients[2], 
                          spatial.lag$coefficients[3], 
                          spatial.lag$rho,
                          spatial.lag$rest.se[1], 
                          spatial.lag$rest.se[2], 
                          spatial.lag$rest.se[3], 
                          spatial.lag$rho.se))
} 
s2.df <- s2.df[-1,]
#
head(s2.df)
tail(s2.df)
#
#
#
# We may assess model stability (conditional on maximum neighbor distance threshold)
# by plotting the estimated beta & rho coefficients against maximum neighbor distances: 
# .. AIC and LogLik may be used to choose the "best" maximum distance thresholds:
#
min(s2.df$AIC)
which(s2.df$AIC == min(s2.df$AIC))
# Next, we show the "best" model, chosen using the AIC criteria:
s2.df[which(s2.df$AIC == min(s2.df$AIC)), ]
#
par(mfrow=c(3,2))
plot(s2.df$AIC~s2.df$max.dist, type="l", ylab="AIC value",xlab="Maximum neighbor distance (km)")
abline(v=250, lty=3)
#
plot(s2.df$LL~s2.df$max.dist, type="l", ylab="LogLik",xlab="Maximum neighbor distance (km)")
abline(v=250, lty=3)
#
plot(s2.df$Intercept~s2.df$max.dist, type="l", ylab="[Intercept]",xlab="Maximum neighbor distance (km)",
     ylim=c(1,8))
lines((s2.df$Intercept+s2.df$Intercept.SE)~s2.df$max.dist, type="l", lty=2, col="blue")
lines((s2.df$Intercept-s2.df$Intercept.SE)~s2.df$max.dist, type="l", lty=2, col="blue")
abline(v=250, lty=3)
#
plot(s2.df$GDP~s2.df$max.dist, type="l", ylab="[GDP]",xlab="Maximum neighbor distance (km)",
     ylim=c(-0.9,-0.2))
lines((s2.df$GDP+s2.df$GDP.SE)~s2.df$max.dist, type="l", lty=2, col="blue")
lines((s2.df$GDP-s2.df$GDP.SE)~s2.df$max.dist, type="l", lty=2, col="blue")
abline(v=250, lty=3)
#
plot(s2.df$TechEmp~s2.df$max.dist, type="l", ylab="[TechEmp]",xlab="Maximum neighbor distance (km)",
     ylim=c(-0.6,0))
lines((s2.df$TechEmp+s2.df$TechEmp.SE)~s2.df$max.dist, type="l", lty=2, col="blue")
lines((s2.df$TechEmp-s2.df$TechEmp.SE)~s2.df$max.dist, type="l", lty=2, col="blue")
abline(v=250, lty=3)
#
plot(s2.df$lambda~s2.df$max.dist, type="l", ylab="[lambda]",xlab="Maximum neighbor distance (km)",
     ylim=c(0.3, 1))
lines((s2.df$lambda+s2.df$lambda.SE)~s2.df$max.dist, type="l", lty=2, col="blue")
lines((s2.df$lambda-s2.df$lambda.SE)~s2.df$max.dist, type="l", lty=2, col="blue")
abline(v=250, lty=3)
#
par(mfrow=c(1,1))
#-------------------------------------------------------------
#
#
#
#
#
#