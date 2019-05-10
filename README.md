#  Introduction to spatial analysis in R  
  
20-21 May 2019, Bilbao,     
Universidad del País Vasco    

**Seminar held by:**  
[Tomas Formanek](https://formanektomas.github.io/)     
Department of Econometrics (Faculty of Informatics and Statistics)  
University of Economics, Prague  
 
---

## Day 1 (20. 5. 2019): R/RStudio for spatial analysis

### Seminar 1: R & RStudio (09:00 - 10:15)   
- General [R](https://www.r-project.org/) / [RStudio](https://www.rstudio.com/products/RStudio/) introduction  
- Global environment, commands, packages 
- Linear regression in R (syntax)  



### Seminar 2: Data handling and plotting I. -- Tools (10:30 - 11:45)  
- Data types and basic data operations (filtering and merging data frames)   
- `{tidyverse}` [packages](https://www.rstudio.com/products/rpackages/), introduction  
- Simple plots with `{ggplot2}`, adding features (layers)   
- Data handling with focus on long and short format with `{tidyr}` package
- `{dplyr}` package and its  basic features 
  

### Seminar 3: Data handling and plotting II. -- Choropleths (12:00 - 13:15)  
- `{sf}` package for handling spatial data  
- [Eurostat](http://ec.europa.eu/eurostat) data and R (data search, download)
- Maps in `{ggplot2}`  
- Choropleths (infomaps) in `{ggplot2}`
 

---

## Day 2 (21. 5. 2019): Spatial analysis -- an introduction  

### Seminar 1: Introduction to spatial statistics with applications in R (09:00 - 10:15) 
- Spatial data: basic features and analysis tools (stationarity, semivariogram)  
- Simple predictions based on spatial data (spatial interpolation, krigging)  


### Seminar 2: Introduction to spatial econometrics (10:30 - 11:45)  
- Spatial structure (definition of neighbors)  
- Spatial dependency and corresponding tests  


### Seminar 3: Spatial econometric models (12:00 - 13:15)  
- Spatial econometric models for cross-sectional (CS) data   
- Estimation and interpretation of selected spatial CS model types   
- Robustness of the estimated models with respect to changing spatial structure


---  

### Instructions for course participants

Please observe the following instructions:

- Bring your own laptop/notebook, make sure you have access to the Internet (e.g. through **eduroam** at Universidad del País Vasco)  
- Have [R](https://www.r-project.org/) version 3.6.0 (3.5.3 is also OK) installed on your device (PC/Mac/Linux)  
- Have [RStudio](https://www.rstudio.com/products/rstudio/download/) installed (free desktop version 1.2.1335 or newer)  
- Setup an *R working directory* (e.g. on your machine's Desktop) - see instructions [Changing the Working Directory](https://support.rstudio.com/hc/en-us/articles/200711843-Working-Directories-and-Workspaces)  
- Download all files from [GitHub repository](https://github.com/formanektomas/SpatialAnalysisBilbao2019) to your *R working directory*  (if not familiar with Git/GitHub, just use the green button "Clone or download")  
- Install all packages for the course - run the file `R_Packages.R` downloaded from GitHub repository for this course.  
- If you have no previous exprerience with R/RStudio and have troubles following the above instruction, you may consider taking a free R/RStudio online course before attending to the seminar on spatial analysis, e.g.:  [R Basics - R Programming Language Introduction](https://www.udemy.com/r-basics/)  

