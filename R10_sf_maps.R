library(dplyr)
library(eurostat)
library(sf)
# https://r-spatial.github.io/sf/ 
# Get the spatial data - as an {sf} object
?get_eurostat_geospatial
options(readr.default_locale=readr::locale(tz="Europe/Berlin"))
df60 <- eurostat::get_eurostat_geospatial(resolution = 60)
#
# Inspect downloaded spatial data
class(df60)
str(df60)
head(df60)
tail(df60)
summary(df60)
#
#
#
# Use simple {sf} functionality for plotting NUTS0 to NUTS3 
# Example: different NUTS-levels in Germany
# .. plotss geographical features only
# .. for simplicity, we do not use ggplot2 here (see next excercise)
#
?plot.sf 
# Germany - NUTS 0
df60 %>%   
  dplyr::filter(LEVL_CODE == 0 & CNTR_CODE %in% ("DE")) %>% # filter country level data for Germany
  dplyr::select(NUTS_ID) %>% # this is just a "trick" to get a map - you can try to comment this line.... 
  plot() # plot.sf() is performed,, plot.sf() arguments can be used.
# Germany - NUTS 1
df60 %>%   
  dplyr::filter(LEVL_CODE == 1 & CNTR_CODE %in% ("DE")) %>%
  dplyr::select(NUTS_ID) %>% 
  plot(key.pos=2, key.width = lcm(2.3))
# Germany - NUTS 1 - borders only (B/W)
df60 %>%   
  dplyr::filter(LEVL_CODE == 1 & grepl("DE", NUTS_ID)) %>% # alternative filtering
  dplyr::select(NUTS_ID) %>% 
  st_geometry() %>% # plot boundaries only
  plot()
#
# Germany - Combine 2 plots: NUTS 3 and NUTS1 (borders only) for Germany
# .. we are plotting 2 plots: the second is overlayed on the first
# .. note the "reset=F" and "add=T" arguments that control this.
df60 %>%   
  dplyr::filter(LEVL_CODE == 3 & CNTR_CODE %in% ("DE")) %>%
  dplyr::select(NUTS_ID) %>% plot(main="NUTS3 Germany", reset=F)
# Add border-lines
df60 %>%
  dplyr::filter(LEVL_CODE == 1 & CNTR_CODE %in% ("DE")) %>%
  dplyr::select(NUTS_ID) %>% st_geometry() %>% plot(lwd=2, add=T, border="black")
#
#
# Plot data for multiple countries
df60 %>%   
  dplyr::filter(CNTR_CODE %in% (c("DE","CZ","PL","AT","SK"))) %>%
  dplyr::filter(LEVL_CODE == 2) %>%
  dplyr::select(NUTS_ID) %>% plot(main="Central Europe", reset=F)
# Add border-lines
df60 %>%
  dplyr::filter(LEVL_CODE == 0 & CNTR_CODE %in% (c("DE","CZ","PL","AT","SK"))) %>%
  dplyr::select(NUTS_ID) %>% st_geometry() %>% plot(lwd=2, add=T, border="black")
#
#
## Additional Self-study Eurostat-specific topics:
## Use Code > Comment / Uncomment lines command to run the code.
##
## Additional NUTS plot & corresponding information
## a] Data are available at different resolutions
## b] NUTS regions change over time - different NUTS "revisions" exist: 2003, 2006, 2010, 2013, 2016.
#
# df20.2003 <- eurostat::get_eurostat_geospatial(year="2003", resolution = 20)
# df1 <- eurostat::get_eurostat_geospatial(resolution = 01)
# #
# # Compare NUTS2 region CZ02 at 1:60mio and 1:1mio resolution:
# #
# df60 %>%   
#   dplyr::filter(LEVL_CODE == 2 & grepl("CZ02", NUTS_ID)) %>%
#   dplyr::select(NUTS_ID) %>% st_geometry() %>% plot(main="1:60mi0 resolution")
# df1 %>%   
#   dplyr::filter(LEVL_CODE == 2 & grepl("CZ02", NUTS_ID)) %>%
#   dplyr::select(NUTS_ID) %>% st_geometry() %>% plot(main="1:1mi0 resolution")
# #
# #
# # Compare NUTS2 region for Croatia, revisions 2003 and 2016
# #
# df20.2003 %>%   
#   dplyr::filter(LEVL_CODE == 2 & grepl("HR", NUTS_ID)) %>%
#   dplyr::select(NUTS_ID) %>% plot(main="Croatia, 3 regions, NUTS rev.2003",key.pos=1)
# df60 %>%   
#   dplyr::filter(LEVL_CODE == 2 & grepl("HR", NUTS_ID)) %>%
#   dplyr::select(NUTS_ID) %>% plot(main="Croatia, 2 regions, NUTS rev.2016",key.pos=1)
#
#
#
# Use different projection (geometry) settings
#
# A) Equidistant circular 
# at the center of the plot, one unit north equals one unit east.
df60 %>%   
  dplyr::filter(LEVL_CODE == 2 & CNTR_CODE %in% ("DE")) %>%
  dplyr::select(NUTS_ID) %>% 
  plot(key.pos=2,key.width = lcm(2.3), graticule=T, axes = T)
#
# B) 
laea = st_crs("+proj=laea +lat_0=51 +lon_0=11") 
# Lambert equal area
# .. mapping from a sphere to a disk 
# .. accurately represents area in all regions of the sphere, 
# .. but it does not accurately represent angles.
# .. Note: "centerpoint" lattitude and longite arguments are valid for Germany only
# .. should be adjusted to match plotted data....
# .. see https://r-spatial.github.io/sf/ for detailed information
df60 %>%   
  dplyr::filter(LEVL_CODE == 2 & CNTR_CODE %in% ("DE")) %>%
  dplyr::select(NUTS_ID) %>% 
  st_transform(laea) %>% 
  plot(key.pos=2,key.width = lcm(2.3), graticule=T, axes = T)
#
#
#
#
#
## Quick exercise
## Print plot of Belgium, Luxembourg and Netherlands at NUTS3 level, 
## add NUTS 0 borders, use "laea" projection
## .. remember the "reset=F" and "add=T" arguments
## .. choose appropriate "laea" centerpoint