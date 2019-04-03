## Maps and choropleths with {ggplot2}
#
library(dplyr)
library(eurostat)
library(sf)
library(ggplot2)
library(RColorBrewer)
rm(list = ls())
#
#
#### Simple maps with {ggplot2}
#
# Get the spatial data for NUTS regions and cast it as a sf object
options(readr.default_locale=readr::locale(tz="Europe/Berlin"))
df60 <- eurostat::get_eurostat_geospatial(resolution = 60)
#
#
# Example of map for Germany - NUTS 2
Germany60 <- df60 %>%   
  dplyr::filter(LEVL_CODE == 2 & CNTR_CODE %in% ("DE")) %>% 
  dplyr::select(NUTS_ID)
# ggplot2 map
ggplot() + 
  geom_sf(data = Germany60)
#
# LAEA geometry
laea = st_crs("+proj=laea +lat_0=51 +lon_0=11") 
GermanyLAEA <- st_transform(Germany60,laea)
ggplot() + 
  geom_sf(data = GermanyLAEA)
#
#
#
#
#### Simple choropleths with {ggplot2}
#
# 1) Read in a dataset 
# .. Disposable income of private households by NUTS 2 regions
# http://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=tgs00026
#
Income.DF <- eurostat::get_eurostat("tgs00026", time_format = "num") 
summary(Income.DF)
#
# 2) Filter data for plotting
Income <- Income.DF %>% 
  dplyr::filter(time %in% c(2010,2015), nchar(as.character(geo)) == 4) 
# note that the "nchar()" does nothing here as all data are NUTS2 already (ID is 4-digit)
# .. generally, NUTS1 and NUTS0 summarized data would be present in Eurostat datasets
summary(Income)
#
# 3) Merge with {sf} spatial data
# .. if you want LAEA geometry, use transformation before joining.
Income.sf <- Income %>% 
  dplyr::left_join(df60, ., by = c("NUTS_ID" = "geo"))   
# .. geo becomes character vector, which is OK
summary(Income.sf) # PPS/Hab for all NUTS2 regions and for two years + shapefiles
#
#
# 4) Plot the data 
# We shall use {RColorBrewer} for color-coding
?scale_fill_gradientn
?brewer.pal
# The sequential palettes names are 
# Blues BuGn BuPu GnBu Greens Greys Oranges OrRd PuBu 
# PuBuGn PuRd Purples RdPu Reds YlGn YlGnBu YlOrBr YlOrRd
# .. from 3 different values up to 9 different values.
# The diverging palettes are 
# BrBG PiYG PRGn PuOr RdBu RdGy RdYlBu RdYlGn Spectral
#
#
# 4a) 2015 only, Germany only
Plot1DF <- Income.sf%>%   
  dplyr::filter(time == 2015 & CNTR_CODE %in% ("DE"))
summary(Plot1DF)
#
ggplot(Plot1DF) +
  geom_sf(aes(fill = values)) +
  scale_fill_gradientn('PPS/Hab', colours=brewer.pal(9, "Greens"))+
  ggtitle("PPS per Habitant") +
  theme_bw()
#
#
# 4b) Plot 2010 & 2015, Germany and Austria 
Plot2DF <- Income.sf%>%   
  dplyr::filter(time %in% c(2010,2015) & CNTR_CODE %in% c("DE","AT"))
summary(Plot2DF)
#
ggplot(Plot2DF) +
  geom_sf(aes(fill = values)) +
  scale_fill_gradientn('PPS/Hab', colours=brewer.pal(9, "Greens"))+
  ggtitle("PPS per Habitant") +
  facet_wrap(~time, ncol=2)+
  theme_bw()
#
#
# 4c) Plot 2015, Spain
Plot3DF <- Income.sf%>%   
  dplyr::filter(time %in% c(2015) & CNTR_CODE %in% c("ES"))
summary(Plot3DF)
#
ggplot(Plot3DF) +
  geom_sf(aes(fill = values)) +
  scale_fill_gradientn('PPS/Hab', colours=brewer.pal(9, "YlGn"))+
  ggtitle("PPS per Habitant") +
  theme_dark()
#
# We can avoid plotting Canary islands by limiting x and y coordinates
ggplot(Plot3DF) +
  geom_sf(aes(fill = values)) +
  scale_fill_gradientn('PPS/Hab', colours=brewer.pal(9, "YlGn"))+
  ggtitle("PPS per Habitant") +
  coord_sf(xlim = c(-10, 5), ylim = c(35, 45))
  # x: 10 st. zapadni delky az 5 st. vychodni delky
  # y: 35 st. severni sirky az 45 st. severni sirky
#
#
# 4d) Plot 2015, Spain & Portugal, add state border-lines
Plot4DF <- Income.sf%>%   
  dplyr::filter(time %in% c(2010) & CNTR_CODE %in% c("ES","PT"))
summary(Plot4DF)
#
borders <- df60 %>%   
  dplyr::filter(LEVL_CODE == 0 & CNTR_CODE %in% c("ES","PT")) %>%
  dplyr::select(NUTS_ID) %>% st_geometry()
#
ggplot() + # note the changed data argument...
  geom_sf(data=Plot4DF, aes(fill = values)) + # data for choropleth
  scale_fill_gradientn('PPS/Hab', colours=brewer.pal(9, "PuBu"))+ # scale and colors
  geom_sf(data=borders, color = "gray30", lwd=1, fill=NA) + # borders - from own DF
  labs(title="PPS per Habitant", y="Latitude", x="Longitude")+ # labels
  coord_sf(xlim = c(-10, 5), ylim = c(35, 45))+ # map range
  theme_light()  # theme
#
## Quick exercise 1:
## Repeat previous plot, but switch "Plot4DF" and "borders" line-ordering
#
#
#
## Quick exercise 2:
## Plot a choropleth as follows:
## - Czech Republic and Slovak Republic
## - 2010 and 2015 (use facets - organize in one column)
## - add state borders.
## - use "Greens" palette with 7 levels
#
#
#
#
#
#### Simple choropleths with {ggplot2} - binary data
#
# Say, we want to plot the data for Germany, 2015
# and distinguish only above-average from below-average (Germany-wide) values:
#
# 5) 2015 only, Germany only
Plot5DF <- Income.sf%>%   
  dplyr::filter(time == 2015 & CNTR_CODE %in% ("DE"))
#
meanVal <- mean(Plot5DF$values)
Plot5DF$RichReg <- ifelse(Plot5DF$values >= meanVal,1,0)
#
ggplot(Plot5DF) +
  geom_sf(aes(fill = factor(RichReg)))
#
ggplot(Plot5DF) +
  geom_sf(aes(fill = RichReg))+
  scale_fill_gradientn('PPS/Hab', colours=brewer.pal(3, "Greens"),breaks=NULL)
#
#