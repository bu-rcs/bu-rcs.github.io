## ------------------------------------
## Research Computing BootCamp
## Boston University

## R Track: Part 2 - Data Processing and Handling
## ------------------------------------




# To work with a dataset various operations are needed to bring it to a usable state within a program. 
# Part Two walks through this process, covering 
# - reading in data from files
# - cleaning the data
# - formatting the data
# - manipulating the data in memory.
# 
# This session will teach you how to explore your data in a systematic way. 
# By the end of it you will learn how to:
#   
# - ready, tidy, subset, and transform your dataset
# - learn about patterns within your dataset and ask appropriate questions about your data
# - how to build your workflow in the most orginized and efficient way
# 
# During this session we will be using *tibbles* which are similar to R's *data frames*.
# *Tibbles* make R data manipulations much easier. They are defined in the **tibble** package
# which is a part of the *tidyverse* set of packages.
# To access the functions defined in an R package, we can use  library()  function:
library(tidyverse)


### **************************************************************************
### Reading Data using *readr* package
### **************************************************************************

# *readr* package comes with its own set of functions for 
# reading retangular data (like 'csv', 'tsv', and fwf'). 
# They are designed to parse many types of data. 
# These functions generally faster than regular  read.csv()  and similar functions. 

# To be able to use this functions,  you can load *tidyverse* package or 
# load *readr* package: 
#library(readr)

# Read CSV file
NE.health <- read_csv("https://github.com/bu-rcs/bu-rcs.github.io/raw/main/Bootcamp/Data/NE_HealthData.csv")


#### **Exercise**
  
# Download DemographicsData.csv file:
# https://github.com/bu-rcs/bu-rcs.github.io/raw/main/Bootcamp/Data/NE_DemographicsData.csv

# use read_csv() function to read it. Save results in a variable with a name demogr
demogr <- read_csv("https://github.com/bu-rcs/bu-rcs.github.io/raw/main/Bootcamp/Data/NE_DemographicsData.csv")

  






# display class of the NE.health object
class(NE.health)

# Explore the structure of NE.health
str(NE.health)


##  Since  NE.health  is not only a *data.frame*, but also a *tibble*, 
# some R functions behave differently:

print( NE.health )


## When printing a tibble  print()  function outputs only those observations and columns
## that fit the Console window screen. We can modify this behavior using optional arguments:
  

# print 12 observations and all columns
print( NE.health, n = 12, width = Inf )


## Tidyverse packages use the following abbreviations to describe the type of each variable:
  
# - *int*  - integers
# - *dbl*  - real numbers (numeric or double precision)
# - *chr*  - character vectors (or strings)
# - *dttm* - date and time vectors
# - *date* - dates
# - *lgl*  - logical vectors
# - *fct*  - factors


  
  
#### **Exercise**
# Use head(), str(), names(), summary(), and View() functions 
# to explore demogr dataset. 
head(demogr)
str(demogr)
names(demogr)
summary(demogr)



  


### **************************************************************************
### Data Transformations using *dplyr* package
### **************************************************************************

# Before we can analyze data, we often need to transform the data to get it in the right format.
# 
# To do this we might need to rename columns, filter some rows and possibly exclude some columns.
# We might need to create some new variables or reorder the observations or columns.
# 
# All these operations can easily be done with a *dplyr* package (which is part of *tidyverse*)
# 
# There are five key dplyr functions:
  
# - filter()    - subset the datasets
# - select()    - select specific columns
# - mutate()    - modify existing or create new variables/columns
# - arrange()   - reorder rows
# - summarise() - collapse dataset to a summary

# Above functions can be used in conjunction with group_by()
# which allows perform operations on the dataset split into groups.

# In addition there are many other useful functions including:
  
# -  rename()     - rename columns
# -  count()      - count observations by group
# -  case_when()  - vectorised *if()* function






  
### **************************************************************************
### *rename()* - rename columns
### **************************************************************************

# We often need to simplify the names of columns to make them easier to use in the code.
# read_csv() and other tidyverse functions that read data do not modify original column names 
# and as a results those columns where special characters (like spaces or symbols) are used can
# only be used within back ticks.


# rename columns
NE.health_1 <- rename(NE.health, 
                      p.smokers = "% Smokers", 
                      p.obese = "% Adults with Obesity" )
names( NE.health_1 )
   



  
  
  
#### **Exercise**
# Use rename function to change the names of "Life Expectancy", 
# "% Frequent Physical Distress", "Median Household Income", and "% Female" columns.
# Name these columns *life_exp*, *ph_distress*, *house_inc*, *p_female*.
# Save your new dataset with a name *demogr1*.

demogr1 <- rename(demogr, life_exp = "Life Expectancy", 
                  ph_distress = "% Frequent Physical Distress",
                  house_inc = "Median Household Income",
                  p_female = "% Female" )
   







  
### **************************************************************************
### *select()* - select columns of interest
### **************************************************************************


# select four columns 
NE.health_2 <- select ( NE.health_1, FIPS, State, County, p.smokers, p.obese )
str(NE.health_2)
   


  
  
#### **Exercise**
# From *demogr1* data frame select columns *FIPS*, *State*, *County*, *life_exp*, 
# *ph_distress*, *house_inc*, *Population*, and *p_female*.
# Save result in a data frame with a name *demogr2*
  
demogr2 <- select(demogr1, FIPS, State, County, life_exp, ph_distress, 
                  house_inc, Population, p_female)
str(demogr2)
   







### **************************************************************************
### *filter()* - sub-setting rows using column values
### **************************************************************************

# Every first row in this dataset has a missing value for a county.
# This row is used to list overall values for each state. 
# For our analysis we might want to remove these rows:
  
  
# select only those observations where percent of smokers is greater than 15%
NE.health_3 <- filter ( NE.health_2, !is.na(County) )
head(NE.health_3)
   

# select only those observations where percent of smokers is greater than 15%
NE.health_subset1 <- filter ( NE.health_3, p.smokers > 15 )
head(NE.health_subset1)
   




### **********************
## Useful filter functions
### **********************

# -  ==  (equal) and  !=  (not equal)
# -  > ,  >= ,  < , and  <= 
# - is.na()
# - between()
# 
# We can connect two or more logical constructs using
# 
# -  &  (logical *and*)
# -  |  (logical *or*)
# -  !  (negation)


  
# select only those observations where percent of smokers is greater than 15% 
# or percent of obese adults is greater than 30%.Also exclude those observations
# where County is missing
NE.health_subset2 <- filter ( NE.health_2, 
                              !is.na(County) & (p.smokers > 15 | p.obese > 30 ))
head(NE.health_subset2)
   


  
#### **Exercise**
# In *demogr2* data leave only those observations where *County* is not missing, 
# *Population* is greater than 50K and 
# household income (*house_inc* ) is less than 75K. Store the result in a data frame
# called demogr_sub.

demogr_sub <- filter ( demogr2, 
                       !is.na(County) & Population > 50000 & house_inc < 75000 )
   








  
### **************************************************************************
### *mutate()* - create new or modify existing variables (columns)
### **************************************************************************


# Create a new column *both* that is equal TRUE if p.smokers > 15 and
# p.obese > 33 at the same time
NE.health_4 <- mutate ( NE.health_3, both = (p.smokers > 15 & p.obese > 30) )
head(NE.health_4)

  
#### **Exercise**
# Use demogr2 dataset (columns *Population* and *p_female*), calculate the female population
# for each observation. 
# Use  round()  function to round the result of calculation to the nearest whole number.
# Name the new column *n_female* and the resulting dataset demogr3.

demogr3 <- mutate ( demogr2, n_female = round (Population * p_female / 100) )
   








  
### **************************************************************************
### *arrange()* - sort the dataset by values in one or more columns
### **************************************************************************


# Sort by percent of smokers
NE.health_5 <- arrange ( NE.health_4, p.smokers )
head(NE.health_5)

# Sort by percent of obese adults in reverse order
NE.health_6 <- arrange ( NE.health_4, desc(p.obese) )
head(NE.health_6)
   


  
#### **Exercise**
# Sort *demogr3* dataset using *life_exp* variable starting from the hiest value.
# Store result in a data frame called *demogr4*. Use  head()  function to find 
# top six counties in New England with the highest life expectancy. 
demogr4 <- arrange ( demogr3, desc( life_exp ) )
   


  
### **************************************************************************
### *%>%* - Pipe 
### **************************************************************************


# In most cases we need to perform several operations on the input dataset before 
# we can analyse it. For example we might need to use some or all functions, that
# we learned so far -  rename() ,  filter() ,  mutate() ,  select() ,  arange() .

# So far we were saving each intermediate step in a separate variable (*demogr1*, *demogr2*, etc.)
# This is not ideal as our input dataset might be large and each variable requires a separate space in memory.
# It is also make it hard to remember which variable holds which data.frame.
# 
# *Tidyverse* packages use  %>%  (*pipe*) symbol to pass the result from one step to another.
# Pipe symbol allows to take the dataset on the left side and pass it as the first argument to 
# the function on the right side.
# 
# The following two ways of selecting three columns are equivalent

select ( NE.health, FIPS, State, County)

NE.health  %>%  select ( FIPS, State, County)
   


# Imagine that we need to perform the following operations after we read our data:
  
# 1. Rename columns
# 2. Select some columns
# 3. Filter rows (leaving only observations relevant to Massachusetts)
# 4. Sort observations by "Poor Health" column in reverse order

# We can use  %>%  symbol to do it in one operation:
  


MA.health <- NE.health  %>% 
  rename ( poor_health = "% Fair or Poor Health",
           smokers = "% Smokers", 
           obese = "% Adults with Obesity", 
           inactive = "% Physically Inactive", 
           some_college = "% Some College"
  ) %>%
  select ( FIPS, State, County, poor_health, smokers, obese, inactive, some_college) %>%
  filter ( ! is.na(County) & State == "Massachusetts" ) %>%  # County is not missing and MA only
  arrange ( desc(poor_health) )

head(MA.health)

   

  
#### **Exercise**
  
# Using pipe  %>%  symbol modify initial demogr dataset in the following way:
#   
# 1. rename "Life Expectancy", "% Frequent Physical Distress",and "Median Household Income" columns. Name these columns *life_exp*, *ph_distress*, *house_inc*
# 2. select FIPS, State, County, life_exp, ph_distress, house_inc columns
# 3. Leave (filter) only observations for Massachusetts
# 4. Arrange the dataset using *life_exp* column in descending order

# Name the resulting dataset *MA.demogr*.



MA.demogr <- demogr %>%
  rename(life_exp = "Life Expectancy", 
         ph_distress = "% Frequent Physical Distress",
         house_inc = "Median Household Income") %>%
  select(FIPS, State, County, life_exp, ph_distress, house_inc) %>%
  filter( ! is.na(County) & State == "Massachusetts") %>%
  arrange( desc(life_exp) )
print(MA.demogr)   


  







### **************************************************************************
### *summarise()* - Calculate summary 
### **************************************************************************


# Print number of observations  and
# mean value of percent of smokers value

MA.health %>% summarise ( N = n(), 
                          ave_percent_smokers = mean(smokers))
   



#### **Exercise**
  
# For the *MA.demogr* dataset calculate mean values for life expectancy and 
# median household income
MA.demogr %>% summarise ( mean_life_exp = mean(life_exp), 
                          median_household = median(house_inc))
   

  
  





### **************************************************************************
### *group_by()* - Grouping operator
### **************************************************************************

# *group_by()* function allows splitting the datasets into groups, 
# so we could apply other functions
# like mutate, arrange, and summarise per group.


# Find average percentage of smokers per state

NE.health  %>% 
  rename ( smokers = "% Smokers" ) %>%
  filter( !is.na(County) ) %>%
  group_by ( State ) %>% 
  summarise ( ave_p_smokers = mean (smokers), .groups = "drop" )

   
  

#### **Exercise**
  
# For the *demogr* dataset calculate mean values for life expectancy and 
# median household income for each State

demogr %>% rename(life_exp = "Life Expectancy", 
                  house_inc = "Median Household Income") %>%
  filter( !is.na(County) ) %>%
  group_by(State) %>%
  summarise ( mean_life_exp = mean(life_exp), 
              median_household = median(house_inc))
   

  
  


### **************************************************************************
### Merging two datasets
### **************************************************************************

  
# If we have two or more tables of data, we often need to combine them. 
# In this workshop we have two tables *NE.health* and *demogr*. Both tables contain
# useful information, so to better understand the population we need to merge these tables together.
# 
# These tables could be merged in two ways: using common column *FIPS* or if it did not exist, we
# could could use *State* and *County* columns.
# 
# Package *dplyr* allows to combine two tables in 4 ways:
  
# -  inner_join()  - keeps all observations that are present in both table
# -  left_join()  - keeps all observations in the first table.
# -  right_join()  - keeps all observations in the second table.
# -  full_join()  - keeps all observations in both tables

# There are also *filtering* joins:
  
# -  semi_join()  - keeps all observations in the first table that have a match in the second table
# -  anti_join()  - drops all observations in the first table that have a match in the second table


# Let's see how these joins work with the two data tables we have.



# Use MA.health dataset. Use columns State, County, "% Fair or Poor Health", and
# "% Physically Inactive"
# Filter observations where County is missing
x <- NE.health %>%
  rename( poor_health = "% Fair or Poor Health", inactive = "% Physically Inactive") %>%
  filter( !is.na(County) ) %>%
  select(State, County, poor_health, inactive)



# From the "Demographics" dataset, extract "Life Expectancy", "% Frequent Physical Distress",
# and "Median Household Income"
y <- demogr %>%
  rename (life_exp = "Life Expectancy", ph_distress = "% Frequent Physical Distress", 
          house_income = "Median Household Income") %>%
  filter( !is.na(County) ) %>%
  select( State, County, life_exp, ph_distress, house_income)




# We will further modify our tables - we will remove Fairfield County observations
# from the x table and Hartford County observations from y
x <- x %>% filter( County != "Fairfield")
y <- y %>% filter( County != "Hartford")

# Now let's perform left, right, inner and full joins:
xy_left <- left_join(x, y, by=c("State", "County"))
xy_right <- right_join(x, y, by=c("State", "County"))
xy_inner <- inner_join(x, y, by=c("State", "County"))
xy_full <- full_join(x, y, by=c("State", "County"))

# print first few records of xy_full
print(xy_full %>% arrange(State, County))

   





  
### **************************************************************************
### Additional Links
### **************************************************************************

# readr package chearsheet
#            https://github.com/rstudio/cheatsheets/blob/master/data-import.pdf
# Useful tips on using read_csv and other functions from readr package 
#                                       https://r4ds.had.co.nz/data-import.html
# Data Transformation using dplyr package
#                                         https://r4ds.had.co.nz/transform.html 
# Merging two tables
#                                   https://r4ds.had.co.nz/relational-data.html




  
### Homework 
  
# 1. Read [USA_DemographicsData.csv](https://github.com/bu-rcs/bu-rcs.github.io/raw/main/Bootcamp/Data/USA_DemographicsData.csv)
# 2. Read [us_states_census_regions.csv](https://github.com/bu-rcs/bu-rcs.github.io/raw/main/Bootcamp/Data/us_states_census_regions.csv)
# 3. Rename columns that we used in this workshop that contain special characters
# 4. Join two tables together.
# 5. Calculate mean *Life Expectancy* and median *Household Income* values per State and per Region

