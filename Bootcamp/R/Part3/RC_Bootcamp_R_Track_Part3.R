## ------------------------------------
## Research Computing BootCamp
## Boston University

## R Track: Part 3 - Data Visualization in R
## ------------------------------------


# Examining complex patterns and correlations in data requires visualization to 
# present the results in a digestible form. 
# Part Three presents various ways to plot and visualize data. 
# Different plotting techniques and formats are presented, along with 
# various ways to format and configure their display and appearance.
# 
# R plotting libraries are designed to produce high-quality graphics.
# 
# Various types of plots allow to generate plots of:
#   
# - a single variable
# - two variables
# - multiple variables
# - networks
# - time series
# - many other special plots

library(readr)
library(ggplot2)
library(dplyr)


# Let's read the two dataset we explored in the previous workshop and merge them together:

NE.health <- read_csv("https://github.com/bu-rcs/bu-rcs.github.io/raw/main/Bootcamp/Data/NE_HealthData.csv") %>%
  rename(poor_health = "% Fair or Poor Health",
         p_smokers = "% Smokers",
         p_obese = "% Adults with Obesity",
         p_inactive = "% Physically Inactive",
         p_college="% Some College",
         p_housing_problems = "% Severe Housing Problems") %>%
  select(State, County, poor_health : p_inactive, p_college, p_housing_problems) %>%
  filter( !is.na(County) )



NE.demogr <- read_csv("https://github.com/bu-rcs/bu-rcs.github.io/raw/main/Bootcamp/Data/NE_DemographicsData.csv") %>%
  rename( life_exp = "Life Expectancy", 
          ph_distress = "% Frequent Physical Distress",
          limit_healthy_food = "% Limited Access to Healthy Foods",
          house_income = "Median Household Income",
          N_black = "# Black",
          N_rural = "# Rural") %>%
  select(State : house_income, Population, N_black, N_rural) %>%
  filter( !is.na(County) )


NE.data <- inner_join( NE.health, NE.demogr, by = c("State", "County"))
glimpse (NE.data)    # similar to str() but slightly different format of output







##-----------------------------------------------------------------------------
## Using R Graphics for data exploration
##-----------------------------------------------------------------------------


### Brief introduction to ggplot2 syntax

# ggplot2 expects 3 main components:
#   
# - data - dataframe, containing variable(s) of interest
# - aes - attributes of graphics, i.e. variables to be displayed along axis, color, shape, etc.
# - geom - geometric shape, i.e. scatterplot, histogram, etc.

ggplot( NE.data, aes(x = p_inactive, y = p_obese)) + geom_point()



### ***********************
### Histogram 
### **********************

# **Variation** - tendency of the variable values to change from observation to observation.
# Each measurement of a variable includes a small amount of error that 
# varies from one observation to another. To better understand 
# the pattern in variation is to display the variable's distribution

# For a continuous variable, we use a *histogram*:
ggplot( NE.data, aes (x = life_exp) ) + geom_histogram( binwidth = 1)


# Let's take a look at another variable - *N_rural*
ggplot( NE.data, aes (x = N_rural) ) + geom_histogram( bins = 10 )

# We can see here that this variable is not normally distributed, 
# There are very few counties with a very small number of rural areas. 
# Majority of counties have about 30K rural households. 
# But this graph has a very long right tail - there are some few counties
# that have about 150K rural households.

# When we look at a histogram, we should ask the following questions:
  
  # - Which values are most common and why?
  # - Which values are most rare and why?
  # - How many clusters are there in the graph? 
  # - How many observations in each cluster?
  # - Can we explain these clusters?
  # - Are there any unusual values?
  
  
#   Let's take a look at the distribution of *p_inactive* variable:
ggplot( NE.data, aes (x = p_inactive) ) + geom_histogram( binwidth = 1 )


# We might want to explore, which county has more than 30% of inactive adults (and why):
NE.data %>% filter (p_inactive > 30)

# We can see that this is Aroostook County in Maine - the largest American county 
# by land east of the Mississippi River (it is larger than three USA States!) 
# Now, once we identify the observation, we can further explore information 
# we have to understand why percentage of inactive adults is so high in this county.


#### **Exercise**

# Plot histograms for *house_income* and *p_housing_problems*. Select appropriate
# bandwidth for each histogram and compare the shapes.
# ggplot( ... , aes (x = ... ) ) + geom_histogram(  binwidth = ... )








### --------------------------------------------------------------
### Boxplot
### --------------------------------------------------------------

# Another useful tool to explore the variable variation is a boxplot.
# 
# Boxplot graph shows:
#   
# - median value
# - maximum and minimum values in a variable and potential outliers
# - interquartile range
# - 25th and 75th percentile values

ggplot( NE.data, aes (x = p_inactive) ) + geom_boxplot()

# We can compare the variation of this variable across various states:
ggplot( NE.data, aes (x = State, y = p_inactive) ) + geom_boxplot()


# Boxplot however hides the distribution within a box. So sometimes it is useful to
# display the actual values within boxplot. We can do that by adding *geom_jitter*:
  
ggplot( NE.data, aes (x = State, y = p_inactive) ) + 
  geom_boxplot() + 
  geom_jitter( width = .25)

#The above plot allows us to better see the variable's distribution within each state



#### **Exercise**

# Plot boxplots for *life_exp* per State. Use *geom_jitter()* to better see the 
# distribution of the variable within each boxplot.
# ggplot( ..., aes (x = ..., y = ...) ) + 
#   geom_boxplot() + 
#   geom_jitter( )








### --------------------------------------------------------------------------
### Violin plot
### --------------------------------------------------------------------------

# Another way to compare shapes of distributions of a continuous variable 
# is to use a violin plot:

ggplot( NE.data, aes (x = State, y = p_inactive) ) + 
  geom_violin() + 
  geom_jitter( width = .25)








### --------------------------------------------------------------------------
### Bar chart
### --------------------------------------------------------------------------

# To explore the distribution of a categorical variable, use a bar chart.
# In our dataset, State is a categorical variable. Using a bar chart we can
# compare the number of Counties within each State

ggplot( NE.data, aes (x = State) ) + 
  geom_bar() 






### --------------------------------------------------------------------------
### Scatterplot
### --------------------------------------------------------------------------

# To explore the relationship between two numeric variables, we can use a scatterplot

ggplot( NE.data, aes(x = p_inactive, y = poor_health)) + geom_point()


# It seems that there some positive correlationship between these two variables.
# Let's try to add a linear regression line:
ggplot( NE.data, aes(x = p_inactive, y = poor_health)) + 
  geom_point() +
  geom_smooth ( method = lm )



  
#### **Exercise**
# 1. Create scatterplots between for *life_exp* and *ph_distress*.
# 2. Add a linear regression line to your plot.







## *****************************************************************************
##
## Communicating your story with plots
##
## *****************************************************************************
  
# Now, when we are familiar with basic ggplot2 syntax and plots, let's improve our plots to 
# learn more from our data and better communicate the results to others.

# We will use the full dataset that includes all USA States:


USA.health <- read_csv("https://github.com/bu-rcs/bu-rcs.github.io/raw/main/Bootcamp/Data/USA_HealthData.csv") %>%
  rename(poor_health = "% Fair or Poor Health",
         p_smokers = "% Smokers",
         p_obese = "% Adults with Obesity",
         p_inactive = "% Physically Inactive",
         p_college="% Some College",
         p_housing_problems = "% Severe Housing Problems") %>%
  select(State, County, poor_health : p_inactive, p_college, p_housing_problems) %>%
  filter( !is.na(County) )
  
  
  
USA.demogr <- read_csv("https://github.com/bu-rcs/bu-rcs.github.io/raw/main/Bootcamp/Data/USA_DemographicsData.csv") %>%
  rename( life_exp = "Life Expectancy", 
          ph_distress = "% Frequent Physical Distress",
          limit_healthy_food = "% Limited Access to Healthy Foods",
          house_income = "Median Household Income",
          N_black = "# Black",
          N_rural = "# Rural") %>%
  select(State : house_income, Population, N_black, N_rural) %>%
  filter( !is.na(County) )


USA.data <- inner_join( USA.health, USA.demogr, by = c("State", "County"))


USA.regions <- read_csv("https://github.com/bu-rcs/bu-rcs.github.io/raw/main/Bootcamp/Data/us_states_census_regions.csv")

# Add the names of Regions
USA.data <- merge(USA.data, USA.regions, by = "State")

glimpse (USA.data)    # similar to str() but slightly different format of output









### --------------------------------------------------------------------------
### Adding Title and axis labels to the plot
### --------------------------------------------------------------------------

# We will start with a simple scatterplot

ggplot( USA.data, aes(x = p_inactive, y = poor_health)) + geom_point()

# In this plot we would like to add a title and change labels for x and y axes.
# We can do it in two ways:

ggplot( USA.data, aes(x = p_inactive, y = poor_health)) + 
  geom_point() + 
  ggtitle ("Adults with Poor Health vs.Physically Inactive") + 
  xlab( "Physically Inactive (%)") + 
  ylab( "Poor Health (%)")

# or

ggplot( USA.data, aes(x = p_inactive, y = poor_health)) + 
  geom_point() + 
  labs( title = "Adults with Poor Health vs.Physically Inactive",
        subtitle="USA Population", 
        x =  "Physically Inactive (%)",  
        y = "Poor Health (%)")



# Sometimes it is useful to change the limits of x and/or y axes:
  
ggplot( USA.data, aes(x = p_inactive, y = poor_health)) + 
  geom_point(alpha = 0.1) + 
  labs( title = "Adults with Poor Health vs.Physically Inactive",
        x =  "Physically Inactive (%)",  
        y = "Poor Health (%)") + 
  xlim(0,50) + 
  ylim(0,50)


# Together with the regression line:
  
ggplot( USA.data, aes(x = p_inactive, y = poor_health)) + 
  geom_point(alpha = 0.1) + 
  geom_smooth(method="lm")+
  labs( title = "Adults with Poor Health vs.Physically Inactive",
        x =  "Physically Inactive (%)",  
        y = "Poor Health (%)") + 
  xlim(0,50) + 
  ylim(0,50)


#### **Exercise**
  
# 1. Create scatterplots between for *life_exp* and *ph_distress*. 
# 2. Add a title and axes labels to your plot.
# 3. Draw a linear regression line








### --------------------------------------------------------------------------
### Barplots
### --------------------------------------------------------------------------

# Sometimes there is a need to compare two or more groups of populations.
# Let's create a categorical variable. We will assign a label to 
# each County based on the median household income. 

USA.data_extra <- USA.data %>%
  mutate( wealth = case_when(house_income < 50000 ~ "low",
                             house_income > 80000 ~ "high",
                             TRUE ~ "middle"))
table(USA.data_extra$wealth)


# Let's calculate USA population living in counties with low, middle and high
# income
res <- USA.data_extra %>% 
  group_by(wealth) %>% 
  summarise ( pop = sum(Population) / 1000000 )  # in Millions
res


# We can now use this table to draw a barplot:
ggplot(res, aes(x=wealth, y = pop )) +
  geom_bar( stat = "identity" ) + 
  ggtitle ( "USA population living in counties with low, middle and high income" ) + 
  ylab("Population, millions") +
  theme_bw()   # add black and white theme


# Sometimes it is useful to add values on top of each bar.
ggplot(res, aes(x=wealth, y = pop )) +
  geom_bar( stat = "identity" ) + 
  geom_text( aes (label = round(pop, 1) ), vjust = -0.5) + 
  ggtitle ( "USA population living in counties with low, middle and high income" ) + 
  ylab("Population, millions") +
  ylim(0, 225) +
  theme_bw()   # add black and white theme



#### **Exercise**
  
# Compute population living in each USA region and display in as a bar graph. 
# Add `coord_flip()` function to flip x and y axes.

# res <- USA.data_extra %>% 
#   group_by( ... ) %>% 
#   summarise ( pop = ... )  # in Millions
#
# ggplot( ... ) +








### --------------------------------------------------------------------------
### Grouped Barcharts
### --------------------------------------------------------------------------

# We would like to split each bar into groups using a categorical variable. 
# For example compare population living in type of community within each Region.
# We can create a table using two variables in the group_by function:
  
res <- USA.data_extra %>% 
  group_by(Region, wealth) %>% 
  summarise ( pop = sum(Population) / 1000000 )  # in Millions
res


# Now we will use a *fill* argument in the `aes()` call.
# We will also add a `position="dodge"` to the `geom_bar()` call:
  
ggplot(res, aes(x=Region, y = pop, fill = wealth )) +
  geom_bar( position="dodge", stat = "identity" ) +
  ggtitle ( "USA population living in each Region" ) + 
  ylab("Population, millions") +
  theme_bw()   # add black and white theme




# New England has less population than West South Ctr Region. So it is hard to 
# compare the relationship of three groups. We can modify the plot to
# "percent stacked" barchart. The only modification we need to mak is to set
# position="fill" in the geom_bar() call:
  
ggplot(res, aes(x=Region, y = pop, fill = wealth )) +
  geom_bar( position="fill", stat = "identity" ) +
  ggtitle ( "USA population living in each Region" ) + 
  ylab("Population, millions") +
  theme_bw()   # add black and white theme

  
# In some cases it is useful to display each set of bars in its own plot.
# To do this we can add facet_wrap() function. 
# We will also set x=wealth in the aes() call:
  
ggplot(res, aes(x=wealth, y = pop, fill = wealth )) +
  geom_bar( position="dodge", stat = "identity" ) +
  facet_wrap(~Region) +
  ggtitle ( "USA population living in each Region" ) + 
  ylab("Population, millions") +
  theme_bw()   # add black and white theme

  
### ------------------
#### **Exercise**
### ------------------
  
# Use facet_wrap() function to compare distributions (using histograms) of 
# *ph_distress* variable from *USA.data* dataset for different regions. 









#### -------------------------------------------------------------------------
#### Read more
#### -------------------------------------------------------------------------
  
# ggplot2 tutorial
#       http://r-statistics.co/Complete-Ggplot2-Tutorial-Part1-With-R-Code.html
# ggplot2 cheat sheet 
#       https://github.com/rstudio/cheatsheets/blob/master/data-visualization-2.1.pdf
# R graph gallery
#       https://www.r-graph-gallery.com/
# ggplot2 extensions
#       https://exts.ggplot2.tidyverse.org/gallery/




  
#### -------------------------------------------------------------------------
### Homework 
#### -------------------------------------------------------------------------

# 1. Using violin plot explore the distribution of p_smokers variable per Region.
# 2. Add geom_jitter to better see the distribution of values for each region
# 3. Plot *life_exp* variable vs. *p_smokers*. Add title and modify the axes labels to make the graph more clear
# 4. Which State has a county with the life_exp value greater than 100? Explore the demographics in this region.


