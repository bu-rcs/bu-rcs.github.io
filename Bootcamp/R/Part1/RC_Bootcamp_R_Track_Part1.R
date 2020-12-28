## ------------------------------------
## Research Computing BootCamp
## Boston University

## R Track: Part 1 - Introduction to R
## ------------------------------------


### **************************************************************************
### Basic Arithmetic
### **************************************************************************
4 + 7


### Assigning values to a variable

# R uses an arrow sign to assign a value to a variable:
x <- 2.71

# We can read this line as *2.71 is assigned to x*. 
# In many cases you can use equal sign `=` as well, 
# but in R it is a good practice to use arrow `<-` for assignments and 
# equal sign `=` to specify the values of arguments in functions.

#### *Note:*
# Object names in R can use letters, digits, dots, and underscores. Spaces and other special characters cannot be used to name R objects.


# Print out the value of a variable in the console window:
print(x)

# Another way to print out the value of a variable:
x

# Assign a value to a variable and prints its value on the console
( x <- 2.71 )



#### **Exercise**
# Assign numeric values to variables `a` and `b` and then 
# calculate `a + b`, `a * b`, `a - b`, and `a /b `.





### **************************************************************************
### Data types in R
### **************************************************************************

# Objects in R can have different types.
# Basic Data types in R:

# - Numeric (real numbers)
# - Integer (whole numbers)
# - Logical (TRUE/FALSE)
# - Character (strings)
# - Complex

# Numeric is the default data type for numbers in R:
x <- 5.24
class(x)
typeof(x)
# Numeric values are stored with *double* precision.


# To store value as an integer, we can add L symbol at the end:
i <- 3L
class(i)
typeof(i)


# The logical data type stores boolean values:
ans <- TRUE
class(ans)


# The character data type variables store single characters or strings. 
# Double or single commas can be used to define a character value:
my.name <- "Katia Bulekova"






### **************************************************************************
### R Functions
### **************************************************************************

# As many other languages, R has built-in functions, i.e 
# sqrt(), log(), round(), etc. 
# Many other functions are defined in R packages that you can install 

# Functions can have zero, one, or more arguments.
# Some arguments have default values
args(round) # List function arguments

# The argument digits in the round() function has a default value 0. 
# So if we call this function and do not use the argument digits, 
# the value of x will be rounded to the nearest whole number. 
# If we want to round x to one decimal place, we need to set digits to one:
round(x, digits=1)

# or simply:
round(x, 1)

 
#### Note:
# It is  recommended to specify the argument names as it makes your code 
# easier to understand and share with others. 
# When you name arguments, their order does not matter!





### **************************************************************************
### R Help
### **************************************************************************

# R comes with comprehensive help system.
# Use one question mark in front of the function name if you know function's name.
# Use two question marks, if you do not know function name and 
# you search for a topic. 
# If your search includes more than one word, use quotes:
  
# Search for a help topic for round() function:
?round

# List all R help topics that include "standard deviation" phrase:
??"standard deviation"


#### **Exercise**
# Find help topics for *working directory* phrase. 
# From the resulting list select the function that comes from base package. 
# Read the description of the function and execute it in your console window. 
# Do not forget parenthesis. 

  




### **************************************************************************
### R Data Structures
### **************************************************************************

## R has five common data structures:
  
# Homogeneous:
# - vector
# - matrix/array

# Heterogeneous
# - data frame
# - list

## The following functions help to explore data structures:
# typeof(), length(), class(), str(), summary()

  


### **************************************************************************
### Vectors
### **************************************************************************

# A vector is a collection of elements of the same type (mode). 
# Most commonly vectors are 
# - character
# - logical
# - integer
# - numeric

# We can use function c() to define a vector:
  

# numeric vector
x_num <- c(5.6, 3.2, 7.8, 9.1)

# character vector
x_char <- c("copper", "iron", "silver", "lead", "gold" )

# logical vector
x_log <- c(TRUE, FALSE, FALSE, TRUE)


  
#### **Exercise**
# Define numeric, character, and logical vectors. 
# Use typeof(), length(), class(), str(), summary() functions to explore these vectors. 
# Compare the outputs of summary() function for numeric, character and logical vectors.

  
### Appending elements to a vector
  
# We can add more elements to a vector using the same c() function:
x_num <- c(-1.7, x_num, -2.4)
x_num


### Vectors from a Sequence
# Using : operator we can create a sequence of values (an integer vector):
( seq1 <- 1:50 )
( seq2 <- 25:4 )
# **Note:** Both starting and ending values are included in the resulting vector.

  
#### **Exercise**
# Search for a help topic for function mean() ( ?mean ). 
# Using this function calculate an average value of any numeric vector you defined so far.


## Other functions include:

# For numeric vectors:
# max(), min(), median(), sd(), sum(), prod()

# For character vectors: 
# nchar(), unique(), strtrim(), substring()

# For logical vectors: 
# sum(),  which()

  




### **************************************************************************
### Operations between vectors
### **************************************************************************

# We can perform operations on one, two or more vectors:
  
# define a vector with distances in inches
heights <- c(65, 69, 60, 71, 66, 68, 64)

# convert to centimeters
heights * 2.54




# define two vectors (heights in inches and weight in pounds)
heights <- c(65, 69, 60, 71, 66, 68, 64)
weights <- c(130, 142, 125, 180, 179, 154, 146)

# Calculate BMI
( bmi <- (weights/heights^2) * 703 )






### **************************************************************************
### Vector slicing
### **************************************************************************

# R uses square brackets [] to slice/subset vectors:

# extract second value from a vector
x_num[2]

# get all elements starting from second and ending with fourth
x_num[2:4]

#get first and fourth element
x_num[ c(1,4) ]


  
### **************************************************************************
### Missing values
### **************************************************************************

# Missing values in R are represented with the NA word. 
# It can be used for all types of vectors:
  

# numeric vector
x_num <- c(5.6, 3.2, NA, 7.8, 9.1, NA)

# character vector
x_char <- c("copper", NA, "iron", "silver", "lead", NA, "gold" )

# logical vector
x_log <- c(TRUE, NA, FALSE, FALSE, NA, TRUE)




# Functions is.na() and anyNA() help to identify 
# if there are any missing value and if so, which one:

# Check if there are any missing values
anyNA(x_num)

# Check each element in a vector to see which elements are missing'
is.na(x_num)

# Identify indecies of the missing elements
which( is.na(x_num) )

# Check how many missing elements
sum( is.na(x_num) )


  
#Almost any computation involving a missing value will return a missing value. 
mean(x_num)  # Calculate mean value of vector x_num

# Many R functions have a special argument, that allows to remove all missing values:
mean(x, na.rm=TRUE) # Calculate mean value of vector x_num ignoring missing values

  
#### **Exercise**
# Apply summary() function to any numeric vector you defined that has 
# missing values. Examine the output. 

  




### **************************************************************************
### Factors
### **************************************************************************

# Factors in R are used to store categorical data. 
# When R vectors are converted to factors, 
# each unique value is assigned an integer value (label). 
# By default these integer labels are assigned alphabetically:

# define a character vector:
ans <- c("yes", "no", "no", "yes", "yes", "yes")
summary(ans)

# convert vector to factor:
ans <- factor(ans)
summary(ans)


# Sometimes, categorical data are coded as integer values 
# (for example 1-for female, 2-for male). 
# It makes sense to convert them to factors and assign appropriate labels:

# gender defined with integer values
gender <- c(1, 2, 2, 1, 1, 1, 2, 2, 1, 2, 2, 2)
summary (gender)

# convert vector to factor and assign appropriate labels
gender <- factor( gender, labels = c("female", "male"))
summary(gender)





  
### **************************************************************************
### Reading Data
### **************************************************************************

# R can read data written in many different formats. 
# Today we will read basic CSV file.
# The following two links gives many more examples of importing data 
# saved in different formats into R
#            https://cran.r-project.org/doc/manuals/r-release/R-data.html
#            https://www.datacamp.com/community/tutorials/r-data-import-tutorial


# Read CSV file
NE.health <- read.csv("https://github.com/bu-rcs/bu-rcs.github.io/raw/main/Bootcamp/Data/NE_HealthData.csv")


# Functions in R that can be used for the exploration of the imported datasets:
  
# - View(x)    - view imported data
# - names(x)   - list column names
# - head(x)    - print first 6 records
# - tail(x)    - print last 6 records
# - summary(x) - print summary of each column in the dataset
# - str(x)     - print structure of the object

head(NE.health)
str(NE.health)
summary(NE.health)


## **Note:** R does not allow special characters (like % or a space character) 
# in column names, so `read.csv()` function changed *%* on `X` and 
# spaces on period characters. 
# Later we will learn how to rename columns (if we want to.)
                                               

                     

                            


### **************************************************************************
### Data Frames
### **************************************************************************

# Data frames in R are used for storing data tables - where each column is 
# a vector and each row is an observation. 
# All columns in data.frames have the same length.
                                               
# To extract columns from a data frame use a dollar sign $
unique( NE.health$State)   # list unique values in the column State

                                               
# Since each column in a data frame is a vector, we can apply functions on them:
max( NE.health$X..Smokers)
                                               
#### **Exercise**
                                                 
# 1. Use length() and unique() functions to State column to find 
#                   how many Stated are included in this dataset

# 2. using min(), max(), and mean() functions, find minimum, maximum, and 
#    average values for the column containing High School Graduation Rate

# 3. Use summary() function to get the same minimum, maximum, and 
#                                    average values as in  ex. #2.
                                               





                                                 
### **************************************************************************
### Slicing Data Frames
### **************************************************************************

#get third row
NE.health[3,]
                                               
#get third column
NE.health[,3]
                                               
#get first seven rows and second, forth, and fifth columns
NE.health[ 1:7, c(2,4,5) ]
                                               
                                





### **************************************************************************
### Installing R packages
### **************************************************************************

# R packages are collections of functions and data sets developed by 
# the community of researchers and programmers. 

# There are two official R repositories: 
#               [CRAN](https://cran.r-project.org/) 
#       [Bioconductor](https://www.bioconductor.org/).

# The first one contains packages applicable to many research areas, 
# while the second one is dedicated to the functions and datasets 
# related to high-throughput genomic data.
                                               
# [CRAN Task Views](https://cran.r-project.org/web/views/) allows you to browse 
# packages by topic and provide tools to automatically 
# install all packages for special areas of interest. 
                                               
# To install packages from the  CRAN use install.packages() function:
install.packages("readr")
                                               
                                               
# In RStudio, the list of installed packages are available 
# in the lower right window under *Packages tab*.
                                               



## For the next session, please install tidyverse. 
## tidyverse is a collection of very popular R packages that are used in 
## everyday data analysis.




                                                 
### **************************************************************************
### Additional Links
### **************************************************************************
# - R Package installation: 
#                 https://www.datacamp.com/community/tutorials/r-packages-guide
# - Installation of Bioconductor packages :  
#                 https://www.bioconductor.org/install/
# - Factors in R: 
#                 https://data-flair.training/blogs/r-factor-functions/
# - R Data Import and Export: 
#                 https://cran.r-project.org/doc/manuals/r-release/R-data.html
# - More on R Data Import and Export: 
#          https://www.datacamp.com/community/tutorials/r-data-import-tutorial









### **************************************************************************
### Homework (optional)
### **************************************************************************

# 1. Read [NE_DemographicsData.csv](https://github.com/bu-rcs/bu-rcs.github.io/raw/main/Bootcamp/Data/NE_DemographicsData.csv)
# 2. List column names, print the structure of the data frame. How many columns and how many rows are there?
# 3. Use summary() and other functions to explore the imported data frame
# 4. Which column(s) have missing values?
# 5. What is the minimum value of *Life Expectancy* column?
# 6. How many different county names are in the County column?
# 7. Calculate the total population in New England (use *Population* column)



