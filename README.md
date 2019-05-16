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
    + If you experience [problems](https://github.com/rstudio/rstudio/issues/3661) while compiling `Rmd` files, you may consider installing the newest version of [Pandoc document converter](https://pandoc.org/installing.html). 
    + (Pandoc is part of RStudio instalation, new version solves the file conversion problems)
- Setup an *R working directory* (e.g. on your machine's Desktop) - see instructions [Changing the Working Directory](https://support.rstudio.com/hc/en-us/articles/200711843-Working-Directories-and-Workspaces)  
- Download all files from [GitHub repository](https://github.com/formanektomas/SpatialAnalysisBilbao2019) to your *R working directory*  (if not familiar with Git/GitHub, just use the green button "Clone or download")  
- Install all packages for the course - run the file `R_Packages.R` downloaded from GitHub repository for this course.  
- If you have no previous exprerience with R/RStudio and have troubles following the above instructions, you may consider taking a free R/RStudio online course before attending to the seminar on spatial analysis, e.g.:  [R Basics - R Programming Language Introduction](https://www.udemy.com/r-basics/)  


--- 

### Additional study materials and resources

- [Kleiber, Zeileis (2008): Applied Econometrics with R](https://www.springer.com/gp/book/9780387773162)  
    + From introductory to advanced econometric analysis using R/RStudio  
- [Bivand, Pebesma, Gómez-Rubio (2013): Applied Spatial Data Analysis with R](https://link.springer.com/book/10.1007%2F978-1-4614-7618-4)  
    + Predates `{sf}` package  
- [Simple Features for R](https://r-spatial.github.io/sf/) 
- [List of R packages for different types of spatial analysis](https://cran.r-project.org/web/views/Spatial.html)  
