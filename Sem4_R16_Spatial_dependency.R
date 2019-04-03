## Maps and choropleths with {ggplot2}
#
library(dplyr)
library(eurostat)
library(sf)
library(ggplot2)
library(RColorBrewer)
library(spdep)
rm(list = ls())
#
# Get the spatial data for NUTS regions and cast it as a sf object
options(readr.default_locale=readr::locale(tz="Europe/Berlin"))
# df60 <- sf::st_as_sf(eurostat::get_eurostat_geospatial(output_class = "spdf", resolution = 60))
df60 <- eurostat::get_eurostat_geospatial(resolution = 60)
# Get GDP data (annual, NUTS2)
GDP.DF <- eurostat::get_eurostat("nama_10r_2gdp", time_format = "num") 
summary(GDP.DF)
# Filter "Central Europe", 2016, EUR-per-Hab   for plotting & analysis
GDP.CE <- GDP.DF %>% 
  dplyr::filter(time %in% c(2016), nchar(as.character(geo)) == 4) %>% # 2016 & NUTS2 only
  dplyr::filter(unit %in% c("EUR_HAB")) %>% # GDP per capita only
  dplyr::mutate(NUTS0 = substr(as.character(geo), start=1, stop=2)) %>% # retrieve NUTS0 id from NUTS2
  dplyr::filter(NUTS0 %in% c(c("AT","CZ","DE","HU","PL","SK")))
summary(GDP.CE)
# Merge with {sf} spatial data
GDP.sf <- GDP.CE %>% 
  dplyr::inner_join(df60, ., by = c("NUTS_ID" = "geo"))   
# Plot the data 
ggplot(GDP.sf) +
  geom_sf(aes(fill = values)) +
  scale_fill_gradientn('GDP \nEUR/Hab', colours=brewer.pal(9, "Greens"))+
  ggtitle("GDP in EUR per Habitant") +
  theme_bw()
#
## To perform spatial dependency test, we need a geo-coded data frame, e.g.:
#
#       | GDP | long | lat |
# Step 1: store long/lat coordinates of centroids
Centroids1 <- GDP.sf$NUTS_ID
GDP.sp <- as_Spatial(GDP.sf)
Centroids2 <- as.data.frame(coordinates(GDP.sp))
Centroids <- cbind(Centroids1,Centroids2)
colnames(Centroids) <- c("NUTS_ID","lon","lat")
head(Centroids,10)
# Merge with GDP data
GDP.data <- merge(GDP.CE,Centroids, by.x="geo", by.y="NUTS_ID")
head(GDP.data)
#
#
# To perform Moran test, we need to define spatial structure (neighbors) first:
coords <- GDP.data[,c("lon", "lat")] # spdep works with sp features and objects
coords <- coordinates(coords) # sp coordinates
IDs <- GDP.data$geo # separately provided IDs
?dnearneigh
nb250km <- dnearneigh(coords, d1=0, d2=250, longlat=T, row.names = IDs)
summary(nb250km)
#
#
#
# Moran I test for the observed GDP
#
?nb2listw # style = "W" (row standardization) is the default
W.matrix <- nb2listw(nb250km) 
summary(W.matrix) # not an actual W matrix...
#
?moran.test
moran.test(GDP.data$values, W.matrix, na.action=na.omit)
?moran.plot
# Spatial lag of GDP
# i.e. W.matrix %*% GDP vector is displayed on the y-axis.
moran.plot(GDP.data$values, W.matrix, zero.policy=T, labels=IDs)
#
#
#
# Local Moran I test 
#
?localmoran
LocMorTest <- localmoran(GDP.data$values, W.matrix, na.action=na.omit)
head(LocMorTest,20)
#
#
#
# Geary's C test
#
?geary.test
geary.test(GDP.data$values,W.matrix)
#
#
#
#
## Quick exercise:  
## Verify robustness of the Moran's I test with respect to 
## changing spatial structure assumptions
## use tau = 170 km, 300 km and 500 km.
## .. Produce Moran plots for the alternative thresholds
#
#
#