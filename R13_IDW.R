### A simple example of Inverse Distance Weight (IDW)
#
# amended from https://rpubs.com/hungle510/202761
library(sp)
library(gstat)
#
# Known sampled data of X,Y coordinates 
# with corresponding of Z value
X <- c(61,63,64,68,71,73,75)
Y <- c(139,140,129,128,140,141,128)
Z <- c(477,696,227,646,606,791,783) # 7 observed data-points
#
#  Sampled data of X, Y coordinate, Z is unknown
X0 <- 65
Y0 <- 137
#
#
# Create data frame for known sampled data
knowndt <- data.frame(X,Y,Z)
# Use coordinates function for known sampled data
coordinates(knowndt)  <- ~ X + Y
spplot(knowndt["Z"],colorkey=T)
#
# Repeat for X0,Y0:
unknowndt <- data.frame(X0,Y0)
coordinates(unknowndt)  <- ~ X0 + Y0
#
#
?idw
# set radius distance to infinity and expotinal parameter to 1
idwmodel = idw(Z ~1, knowndt, unknowndt, # constant mean, data, newdata
               maxdist = Inf, idp = 1) # no bounded distance, linear inverse weights
#
Z0 <- idwmodel@data$var1.pred
Z0
# Results can be plotted
# .. first, we need a convenient grid/raster
grid <- sp::spsample(knowndt,10000,type="regular") # 100 x 100 points grid
idw.p <- idw(Z ~1, knowndt, grid, maxdist = Inf, idp = 1) # IDW on the grid
#
gridded(idw.p) = T # this can be skipped, plot will contains points
spplot(idw.p["var1.pred"],colorkey=T)
#
# high p (power) of distance weights decay - Voronoi-like diagram
idw.Voronoi <- idw(Z ~1, knowndt, grid, maxdist = Inf, idp = 20)
gridded(idw.Voronoi) = T
spplot(idw.Voronoi["var1.pred"],colorkey=T)
#
## Quick exercise
## Calculate ZO for p = 2.
#
#
#