#### Spatial filtering by Getis (illustrative example)
#
#
#  
#   Example of a spatial lag model for NUTS2 regions of
#   Austria, Czech Republic, Germany, Hungary, Poland, Slovakia
#
#
# 
# Data, data description & plots
library(spdep) # install.packages("spdep")
rm(list=ls())
CE_data <- read.csv("datasets/NUTS2_data.csv")
CE_data$log.GDP <- log(CE_data$EUR_HAB_EU_2011)
head(CE_data, 15)
plot(CE_data[ , c(4,7,8)])
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
#
#      U_pc_2012 <- log.GDP + TechEmp_2012
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
# Step 2 Spatial filtering
#
#
# Getis filtering can be applied for 
# positively autocorrelated data with natural origin:
moran.test(CE_data$U_pc_2012,W.matrix)
moran.test(CE_data$log.GDP,W.matrix)
moran.test(CE_data$TechEmp_2012,W.matrix)
#
#
#
# Getis G* z-score
?localG
localG(CE_data$U_pc_2012, W.matrix)
# For spatial filtering, we need
# - return_internals = TRUE 
#   .. G(i) and E(G) are used in filtering
# - GeoDa=FALSE = T 
#   .. exclude "self-neighborhood" - use G(i) not G*(i)
# - filtering is usually calculated based on connectivity matrix (C, not W)
#   .. see syntax below
localG(CE_data$U_pc_2012, nb2listw(nb250km, style="B"), return_internals = T, GeoDa = T)
#
# Spatial filter for unemployment
U.Ftr <- localG(CE_data$U_pc_2012, nb2listw(nb250km, style="B"), return_internals = T, GeoDa = T)
Getis.m <- as.data.frame(attr(U.Ftr, which = "internals")) # retrieve "internals"
CE_data$U_ddot <- CE_data$U_pc_2012 * (Getis.m$EG/Getis.m$G ) # "multiplicative filter"
#
# Spatial filter for log.GDP
GDP.Ftr <- localG(CE_data$log.GDP, nb2listw(nb250km, style="B"), return_internals = T, GeoDa = T)
Getis.m2 <- as.data.frame(attr(GDP.Ftr, which = "internals")) # retrieve "internals"
CE_data$lGDP_ddot <- CE_data$log.GDP * (Getis.m2$EG/Getis.m2$G ) # "multiplicative filter"
#
# Spatial filter for TechEmp_2012
Tech.Ftr <- localG(CE_data$TechEmp_2012, nb2listw(nb250km, style="B"), return_internals = T, GeoDa = T)
Getis.m3 <- as.data.frame(attr(Tech.Ftr, which = "internals")) # retrieve "internals"
CE_data$Tech_ddot <- CE_data$TechEmp_2012 * (Getis.m3$EG/Getis.m3$G ) # "multiplicative filter"
#
#
# Note the change in spatial dependency (we allow for negative sp. dep.)
moran.test(CE_data$U_ddot,W.matrix, alternative = "two.sided")
moran.test(CE_data$lGDP_ddot,W.matrix, alternative = "two.sided")
moran.test(CE_data$Tech_ddot,W.matrix, alternative = "two.sided")
#
#
#
# Step 3 OLS-estimation using filtered data
#
F.OLS <- lm(U_ddot ~ lGDP_ddot+Tech_ddot, data = CE_data)
summary(F.OLS)
#
#
#
#
#
########################################################################
# Evaluation of robustness with respect to spatial structure
########################################################################
#
#
# We crearte an "empty" data.frame to collect estimation results at different
# max. neighbor distance thresholds
s2.df <- data.frame(max.dist= 0, AIC= 0, LL= 0, R2=0,
                    Intercept= 0, GDP= 0, TechEmp= 0,
                    Intercept.SE= 0, GDP.SE= 0, TechEmp.SE= 0)
#
# Main calculation: neighbors & W.matrices are calculated for
# distance thresholds from 160 km to 1.000 km (10-km iterations).
# Model data are stored into the "s2.df" data.frame
# .. calculation may take a few moments
#
for(jj in 16:100) {
  nb <- dnearneigh(coords, d1=0, d2=jj*10, longlat=T, row.names = IDs)
  # U_pc filtering
  U.Ftr <- localG(CE_data$U_pc_2012, nb2listw(nb, style="B"), return_internals = T, GeoDa = T)
  Getis.m <- as.data.frame(attr(U.Ftr, which = "internals")) # retrieve "internals"
  CE_data$U_ddot <- CE_data$U_pc_2012 * (Getis.m$EG/Getis.m$G ) # "multiplicative filter"
  #
  # Spatial filter for log.GDP
  GDP.Ftr <- localG(CE_data$log.GDP, nb2listw(nb, style="B"), return_internals = T, GeoDa = T)
  Getis.m2 <- as.data.frame(attr(GDP.Ftr, which = "internals")) # retrieve "internals"
  CE_data$lGDP_ddot <- CE_data$log.GDP * (Getis.m2$EG/Getis.m2$G ) # "multiplicative filter"
  #
  # Spatial filter for TechEmp_2012
  Tech.Ftr <- localG(CE_data$TechEmp_2012, nb2listw(nb, style="B"), return_internals = T, GeoDa = T)
  Getis.m3 <- as.data.frame(attr(Tech.Ftr, which = "internals")) # retrieve "internals"
  CE_data$Tech_ddot <- CE_data$TechEmp_2012 * (Getis.m3$EG/Getis.m3$G ) # "multiplicative filter"
  #
  LRM <- lm(U_ddot ~ lGDP_ddot+Tech_ddot, data = CE_data)
  sLRM <- summary(LRM)
  #
  s2.df <- rbind(s2.df, c(jj*10, AIC(LRM), logLik(LRM), sLRM$r.squared, 
                          LRM$coefficients[1], 
                          LRM$coefficients[2], 
                          LRM$coefficients[3], 
                          sLRM$coefficients[1,2], 
                          sLRM$coefficients[2,2], 
                          sLRM$coefficients[3,2]))
} 
s2.df <- s2.df[-1,]
#
head(s2.df)
tail(s2.df)
#
#
#
basic.LRM <- lm(U_pc_2012 ~ log.GDP + TechEmp_2012, data=CE_data )
basic.sLRM <- summary(basic.LRM)
#
min(s2.df$AIC)
which(s2.df$AIC == min(s2.df$AIC))
# Next, we show the "best" model, chosen using the AIC criteria:
s2.df[which(s2.df$AIC == min(s2.df$AIC)), ]
#
#
par(mfrow=c(3,2))
#
plot(s2.df$AIC~s2.df$max.dist, type="l", ylab="AIC value",xlab="Maximum neighbor distance (km)",
     col="blue", lwd=1)
abline(v=250, lty=3)
abline(h= AIC(basic.LRM),lty=1, col="red", lwd=1)
#
plot(s2.df$LL~s2.df$max.dist, type="l", ylab="Log-Likelihood",xlab="Maximum neighbor distance (km)", 
     col="blue", lwd=1)
abline(v=250, lty=3)
abline(h= logLik(basic.LRM),lty=1, col="red", lwd=1)
#
plot(s2.df$R2~s2.df$max.dist, type="l", ylim=c(0, 1), ylab="R squared",xlab="Maximum neighbor distance (km)", 
     col="blue", lwd=1)
abline(v=250, lty=3)
abline(h= basic.sLRM$r.squared,lty=1, col="red", lwd=1)
#
plot(s2.df$Intercept~s2.df$max.dist, type="l", ylab="[Intercept]",xlab="Maximum neighbor distance (km)", 
     col="blue", ylim=c(10, 30), lwd=2)
lines((s2.df$Intercept+s2.df$Intercept.SE)~s2.df$max.dist, type="l", lty=2, col="blue")
lines((s2.df$Intercept-s2.df$Intercept.SE)~s2.df$max.dist, type="l", lty=2, col="blue")
abline(h= basic.sLRM$coefficients[1,1],lty=1, col="red", lwd=2)
abline(h= basic.sLRM$coefficients[1,1]+basic.sLRM$coefficients[1,2],lty=2, col="red")
abline(h= basic.sLRM$coefficients[1,1]-basic.sLRM$coefficients[1,2],lty=2, col="red")
abline(v=250, lty=3)

#
plot(s2.df$GDP~s2.df$max.dist, type="l", ylab="[GDP]",xlab="Maximum neighbor distance (km)", 
     col="blue", ylim=c(-5.5, 0.5), lwd=2)
lines((s2.df$GDP+s2.df$GDP.SE)~s2.df$max.dist, type="l", lty=2, col="blue")
lines((s2.df$GDP-s2.df$GDP.SE)~s2.df$max.dist, type="l", lty=2, col="blue")
abline(h= basic.sLRM$coefficients[2,1],lty=1, col="red", lwd=2)
abline(h= basic.sLRM$coefficients[2,1]+basic.sLRM$coefficients[2,2],lty=2, col="red")
abline(h= basic.sLRM$coefficients[2,1]-basic.sLRM$coefficients[2,2],lty=2, col="red")
abline(h=0,lty=2)
abline(v=250, lty=3)
#
plot(s2.df$TechEmp~s2.df$max.dist, type="l", ylab="[TechEmp]",xlab="Maximum neighbor distance (km)", col="blue",
     ylim=c(-0.2,+0.4), lwd=2)
lines((s2.df$TechEmp+s2.df$TechEmp.SE)~s2.df$max.dist, type="l", lty=2, col="blue")
lines((s2.df$TechEmp-s2.df$TechEmp.SE)~s2.df$max.dist, type="l", lty=2, col="blue")
abline(h= basic.sLRM$coefficients[3,1],lty=1, col="red", lwd=2)
abline(h= basic.sLRM$coefficients[3,1]+basic.sLRM$coefficients[3,2],lty=2, col="red")
abline(h= basic.sLRM$coefficients[3,1]-basic.sLRM$coefficients[3,2],lty=2, col="red")
abline(h=0,lty=2)
abline(v=250, lty=3)
#
#
#
par(mfrow=c(1,1))
#
#















