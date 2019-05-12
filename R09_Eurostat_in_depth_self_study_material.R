#### Eurostat database and data manipulation using {reshape2} ####
#
#
#
#
#
############################################################
#################### {reshape2} package ####################
############################################################
#
#
#
#
options(readr.default_locale=readr::locale(tz="Europe/Berlin"))
rm(list = ls())
require(dplyr)
require(reshape2) # install.packages("reshape")
#
### Data files in melted and cast formats ###
#
#
## Melting & casting data: a simple example
#
mydata <- as.data.frame(matrix(c(1,1,2,2,2010,2015,2010,2015,5,6,17,18,11,12,23,24),ncol = 4))
colnames(mydata) <- c("ID", "Time", "DEBT", "GDP")
mydata$ID <- as.factor(c("CZ","CZ","AT","AT")) 
mydata # Original data.frame
#
## melt() command is analogous to gather() from {tidyr}
?melt
# To melt a dataset, we restructure it into a format where each measured variable 
# (DEBT and GDP) is in its own row, along with all the variables needed 
# to uniquely identify it (ID and Time).
# .. hence, ID and Time are used as arguments to the melt() function
molten <- melt(mydata, id.vars = c("ID", "Time"))
molten
# alternative arguments used, same results:
molten <- melt(mydata, measure.vars = c("DEBT", "GDP"))
molten
#
#
#
## dcast() is similar to spread() from {tidyr}, offers additional functionality
?dcast # if casting into a data.frame, acast() for arrays, matrices, ...
# Melted data may be cast in different shapes
# The dcast() function starts with melted data and reshapes it using a formula:
# newdata <- cast(molten, formula, ...)
#
# .. the formula takes the form:
# ..rowvar1 + rowvar2 + …  ~  colvar1 + colvar2 + …
#
# .... rowvar1 + rowvar2 + … set of variables that define the rows of new (cast) dataframe
# .... colvar1 + colvar2 + … variables that define the columns of new dataframe
# 
#
# Example 1 - back to original dataframe
dcast(molten, ID + Time ~ variable)
mydata # original data for comparison
# 
# Example 2 - alternative ordering of the "row-defining" information
dcast(molten, Time + ID ~ variable)
#
# Example 3 - wide format: IDs in rows
dcast(molten, ID ~ variable + Time)
#
# Example 4 - wide format: data organized as time series
dcast(molten, Time ~ ID + variable)
dcast(molten, Time ~ variable + ID)
#
#
#
## Quick Assignment
rm(list=ls())
myData1 <- read.csv("datasets/CE_data.csv")
head(myData1,10)
tail(myData1,10)
summary(myData1[,1:3])
str(myData1)
#
## The dataset is in molten (long) format
## 2  observed variables: "GDP" and "UNEM"
## 3  countries: AT, CZ, DE
## 77 quarters: 1995Q1 to 2014Q1
## .... 2 x 3 x 77 = 462 rows of data
##
## Note: conversion of "time" to actual date format may be performed as follows
# require(zoo)
# myData1$Time <- as.yearqtr(myData1$time)
## or
# myData.zoo <- zoo(myData1, order.by = as.yearqtr(myData1$time))
#
#
#
#
# 
## 1] Use dcast() to produce a time-series object "table1", 
##    with time obs. in rows and VARIABLE.NAME_COUNTRY.ID in columns
#
#    i.e.
#
#    time   GDP_AT   GDP_CZ    GDP_DE    .....
# ----------------------------------------------
#  1995Q1  45115.4  10523.0  472917.2    .....
#  ......   ......   ......    ......   
#
table1 <- dcast(       )
head(table1)
#
## 2] Use dcast() to produce a time-series object "table1", 
##    with time obs. in rows and COUNTRY.ID_VARIABLE.NAME in columns
##    .. simply reverse column names from e.g. GDP_AT to AT_GDP
#
table2 <- dcast(       )
head(table2)
#
## 3] Use dcast() to produce a "panel.data" table
#    with heading as follows:
#
#     ID        time        GDP      UNEM
#  ----------------------------------------------
#     AT      1995Q1       ....      .....
#
#
#
panel.data <- dcast(       )
head(panel.data)
#
#
#
#
#
#
#
############################################################
#################### {eurostat} package ####################
############################################################
#
# Data from the Eurostat database are downloaded in a molten form 
# & often need to be reshaped using the dcast() function...
#
#
#
#
#### Example 1 - GDP data from Eurostat (CR, SR, AT)
#
# Retrieving Eurostat data using the {eurostat} package
rm(list=ls())
require("eurostat") # install.packages("eurostat")
help(package="eurostat")
#
?get_eurostat_toc
# TOC.eurostat <- get_eurostat_toc()
# head(TOC.eurostat)
#
?search_eurostat # grep syntax is used to search for particular character strings
GDP.series <- search_eurostat(".*GDP",fixed = F)
View(GDP.series) # GDP.series
# Say, we choose to work with "GDP and main components..." (annual data)
# ... the download may take a few moments....
?get_eurostat # note the "time_format" and other arguments
GDP <- get_eurostat("nama_10_gdp")
head(GDP, 50)
# Data are downloaded in a 'molten' form. 
# 
#
#### Using Eurostat data ####
#
## Step 1 ## 
# Know your data
#
# http://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=nama_10_gdp&lang=en
#
# In order to filter & reformat our data, we need to be aware 
# of the different variables contained within the dataset. 
#
GDP.labels <- label_eurostat(GDP, fix_duplicated = T)
colnames(GDP)
# Measurement units of the obs. variable 
unique(GDP$unit) 
View(cbind(as.character(unique(GDP$unit)),as.character(unique(GDP.labels$unit))))
# Obs. variable code (nomenclature: national accounts indicator)
unique(GDP$na_item) 
View(cbind(as.character(unique(GDP$na_item)),as.character(unique(GDP.labels$na_item))))
# Geographic units
unique(GDP$geo)
View(cbind(as.character(unique(GDP$geo)),as.character(unique(GDP.labels$geo))))
# time span of the observations
range(GDP$time) # we did not use: get_eurostat(..., time_format = "argument")
# 
#
#
## Step 2 ## 
# Filtering
#
# Say, we only want the B1GQ - Gross domestic product at market prices from "na_item"
# AND we only want the CP_MEUR - Current prices, million euro from "unit"
# AND we only want data for CZ, SK and AT from "geo
GDP.dataset <- GDP %>% 
  filter(na_item == "B1GQ", 
         unit == "CP_MEUR", 
         geo %in% c("CZ", "SK", "AT"))
head(GDP.dataset)
# each measured variable (GDP) is in its own row, along with all the variables needed 
# to uniquely identify it (geo and time).
#
# Save for subsequent use
write.csv(GDP.dataset, "datasets/GDPdata.csv", row.names = F)
#
#
## Step 3 ## 
# reshape the data using dcast() 
#
# We will now rearrange the data using the dcast() 
# function so that the data frame contains a column 
# for GDP in each country. We want individual years as rows.
GDP.new.dataset <- dcast(GDP.dataset, time ~ geo, value.var = "values")
View(GDP.new.dataset)
#
# By amending the cast formula, we can include "CP_MEUR" in the name of each variable:
GDP.new.dataset <- dcast(GDP.dataset, time ~ unit+geo, value.var = "values")
View(GDP.new.dataset)
#
#
## Step 4 ## 
#
# Use the data
library(zoo)
head(GDP.new.dataset)
GDP.zoo <- zoo(GDP.new.dataset[,2:4], order.by = GDP.new.dataset$time)
# ! Note that the coredata for a zoo object is a matrix, 
#   which means that all the data must be of the same type. 
#   So, if you want a numeric zoo object you will have to get rid of the timestamp column.
#
# Now, the usual data operations on TS may be performed easily
head(GDP.zoo)
GDP.zoo$CP_MEUR_AT_lag1 <- stats::lag(GDP.zoo$CP_MEUR_AT, k = -1) # note the the -1 for "t-1"
GDP.zoo$CP_MEUR_AT_d1 <- GDP.zoo$CP_MEUR_AT - GDP.zoo$CP_MEUR_AT_lag1 # 1st differences for AT
head(GDP.zoo)
#
# Normally, we have to use long-format datasets in ggplot
# {zoo} has an autoplot() function that provides simple interface to ggplot:
require(ggplot2)
autoplot(GDP.zoo[,1:3]) + 
  ggtitle("GDP time series")
#
#
#
#
#
#
#
#### Example 2 - Long-term unemployment data from the Eurostat database
#
#
rm(list=ls())
U.series <- search_eurostat("unemployment")
View(U.series)
# We choose: Long-term unemployment by sex - quarterly average, %
# http://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=une_ltu_q&lang=en
U.data <- get_eurostat("une_ltu_q")
dim(U.data)
#
## Step 1 ##
colnames(U.data)
unique(U.data$sex)
unique(U.data$indic_em) # Long term unemployment -- Very long term unemployment
unique(U.data$s_adj) # Seas. Unadjusted -- Adjusted data (not calendar adjusted) -- Trend cycle
unique(U.data$age)  # Y15-74 -- Y20-64
unique(U.data$unit) # % of active -- % of unemployment -- (000)s person
unique(U.data$geo)
range(U.data$time) # quarterly data
#
## Step 2
# Let's retrieve data for Austria, Czech Republic and Slovakia, 
# Share of long term on total unemployment (disregard M/F data)
U.AT_CZ_SK <- U.data %>% 
  filter(indic_em == "LTU", sex == "T", unit == "PC_UNE", s_adj == "SA", age == "Y15-74") %>% 
  filter(geo %in% c("AT","CZ","SK"))
#
## Step 3
U.AT_CZ_SK.ts <- dcast(U.AT_CZ_SK, time ~ indic_em + geo, value.var = "values")
#
## Step 4
# Plot the data
U.zoo <- zoo(x = U.AT_CZ_SK.ts[,4:2], order.by = as.yearqtr(U.AT_CZ_SK.ts$time)) 
# [,4:2] controls order of columns only... see plot
head(U.zoo)
autoplot.zoo(U.zoo, facets = NULL) + 
  geom_line() +
  scale_x_yearqtr(format = "%Y-Q%q") +
  xlab('Time') + 
  ylab('LTU to U ratio')
#  
#  
#
#
#
#### Example 3 - Join GDP and Long-term unemployment data 
#                for subsequent econometric analysis
#
## Step 1
# convert quarterly LT-Unemployment data to annual (our GDP dataset is annual)
U.Year <- U.AT_CZ_SK %>%
  mutate(year = as.numeric(substr(time,start = 1,stop = 4))) %>% 
  group_by(geo,year) %>%
  summarize(Unem=mean(values)) 
#
head(U.Year)
dcast(U.Year, year ~ geo)
mean(U.AT_CZ_SK.ts[8:11,2]) # AT average for 1999
colnames(U.Year)
#
## Step 2
# Combine with GDP data
GDP.data <- read.csv("datasets/GDPdata.csv")
colnames(GDP.data)
head(GDP.data) # we only need "geo", "values" - the GDP data and "year"
GDP.data$year <- as.numeric(substr(GDP.data$time,start = 1,stop = 4))
#
# Combine data
?base::merge
Combined.DF <- merge(U.Year, GDP.data[,c(3,5,6)], by=c("geo","year"))
head(Combined.DF)
colnames(Combined.DF) <- c("geo","year","LTU_U","GDP")
head(Combined.DF,22)
#
# Combined.DF is suitable for use in panel data analysis.
# Alternatively, wide format can be achieved in two steps:
Combined.DF %>% 
  melt(id.vars=c("year","geo"), variable.name="Obs.var") %>% 
  dcast(year ~ geo+Obs.var)
#
#