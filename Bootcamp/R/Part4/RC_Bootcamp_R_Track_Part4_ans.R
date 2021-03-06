## ------------------------------------
## Research Computing BootCamp
## Boston University

## R Track: Part 4 - Using Statistical Tools for Data Analysis
## ------------------------------------



## Discovering and verifying meaningful patterns and correlations in 
## data requires quantitative techniques that can analyze the data in 
## a rigorous mathematical or algorithmic way. 
## Part Four presents how to use various basic statistical tools to 
## analyze the example dataset. The use of these tools is demonstrated and 
## various example diagnostics, patterns, and correlations are 
## examined in the example dataset.


library(readr)
library(ggplot2)
library(dplyr)

  
## Let's read the two dataset we explored in the previous workshops:

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

glimpse (USA.data)   


## -----------------------------------------------------------------------------
## Hypothesis Testing in R
## -----------------------------------------------------------------------------


## 1. State Hypothesis
## 2. Formulate an analysis plan
## 3. Perform analysis
## 4. Interpret results


## **Type I Error** - null hypothesis is rejected when it is true. 
## *significance level* - probability of Type I error 

## **Type II Error** - accepting a false null hypothesis. 
## *power* of the test - probability of Type II error 




### ********************************************
### Checking if a variable normally distributed
### ********************************************

## Let's take a look at the *life expectancy* variable.
ggplot( USA.data, aes (life_exp) ) + 
  geom_histogram(binwidth=1) + 
  geom_vline(xintercept=median(USA.data$life_exp, na.rm=T), 
             linetype="dashed", color = "red", size=1.) + 
  ggtitle ("USA Life expectancy distribution") + 
  xlab( "Life expectancy, years") +
  annotate(geom="text", 
           x=82, y=400, 
           label=round(median(USA.data$life_exp, na.rm=T),1),
           color="red") + 
  theme_bw()


##  Is this variable normally distributed?
##  Let's first perform some *visual* analysis
ggplot( USA.data, aes (life_exp) ) + 
  geom_density(color="darkgray", fill="lightgrey") + 
  geom_vline(xintercept=median(USA.data$life_exp, na.rm=T), 
             linetype="dashed", color = "red", size=.8) + 
  ggtitle ("USA Life expectancy distribution") + 
  xlab( "Life expectancy, years") +
  annotate(geom="text", 
           x=82, y=0.13, 
           label=round(median(USA.data$life_exp, na.rm=T),1),
           color="red") + 
  theme_bw()
  

ggplot( USA.data, aes (sample = life_exp) ) + 
  stat_qq() + stat_qq_line() + 
  ggtitle ("qq-plot of  Life expectancy variable") + 
  theme_bw()
  

## 1. **State Hypothesis**: 

### *Null-hypothesis* - the sample comes from a normal distribution. 
### *Alternative hypothesis* - the sample does not come from a normal distribution


## 2. **Formulate an analysis plan**

### We will run Shapiro-Wilks test of normality ((http://www.sthda.com/english/wiki/normality-test-in-r))


## 3. **Perform analysis**
shapiro.test(USA.data$life_exp)


## 4. **Interpret results**

### From the output, the p-value < 0.05 implying that the distribution of the data 
### is significantly different from normal distribution. 
### So we reject the *Null Hypothesis* - data are not normally distributed







### ********************************************
### Comparing two samples
### ********************************************

## Let's compare Life expectancy in New England and East South Ctr Region. 
## Let's first summarize our data and find median and mean values


USA.data %>%
  group_by(Region) %>%
  summarise ( mean = mean(life_exp, na.rm=T), median = median(life_exp, na.rm=T))



## Let's visually compare two distributions of this variable for both regions

ggplot( USA.data, aes (x=life_exp) ) + 
  geom_histogram(data = subset(USA.data, Region == "East South Ctr"), 
                 binwidth=1, fill = "red", alpha = 0.2) + 
  geom_histogram(data = subset(USA.data, Region == "New. Eng."), 
                 binwidth=1, fill = "blue", alpha = 0.2) + 
  geom_vline(xintercept=74.5, 
             linetype="dashed", color = "red", size=1.) + 
  geom_vline(xintercept=79.5, 
             linetype="dashed", color = "blue", size=1.) + 
  ggtitle ("USA Life expectancy in New England and East South Ctr Region") + 
  xlab( "Life expectancy, years") +
  annotate(geom="text", 
           x=75, y=77, 
           label=74.5,
           color="red") + 
  annotate(geom="text", 
           x=80, y=77, 
           label=79.5,
           color="blue") + 
  theme_bw()


  
  
## 1. **State Hypothesis**: 
  
###  *Null-hypothesis* - difference in means is equal to 0. 
###  *Alternative hypothesis* - true difference in means is not equal to 0.


## 2. **Formulate an analysis plan**
  
### We will run Welch Two Sample t-test 
### (https://www.datanovia.com/en/lessons/types-of-t-test/unpaired-t-test/welch-t-test/).


## 3. **Perform analysis**
  
x <- USA.data$life_exp[USA.data$Region == "New. Eng."]
y <- USA.data$life_exp[USA.data$Region == "East South Ctr"]
t.test(x,y)

  
## 4. **Interpret results**
  
### From the output, the p-value < 0.05 implying that the true difference in means is not
### equal to zero and we can reject *Null Hypothesis*. 
### It's always a good idea to include  in your report the
### 95% percent confidence interval and other  statistics along with the p-value.


#### **Exercise**

## 1. Check if the variable *house_income* normally distributed
shapiro.test(USA.data$house_income)

## 2. Perform Welch t.test to compare *house_income* between New England Region and East South Ctr
x <- USA.data$house_income[USA.data$Region == "New. Eng."]
y <- USA.data$house_income[USA.data$Region == "East South Ctr"]
t.test(x,y)



### ********************************************
### Correlation and Covariance
### ********************************************

## From our previous sessions we saw that there is correlation between percent of smokers in a County
## and *poor health* variable:

ggplot( USA.data, aes(x = p_smokers, y = poor_health)) + 
  geom_point(alpha=0.1) + 
  geom_smooth(method = "lm") + 
    labs( title = "Adults with Poor Health vs. Percent of Smokers",
        subtitle="USA Population", 
        x =  "Smokers (%)",  
        y = "Poor Health (%)")


# The `cov()` functions computes covariance. 
# The `cor()` function calculates correlations between two vectors. 
# The `cor.test()` function performs test of significance of the correlation.


cov( USA.data$p_smokers, USA.data$poor_health)
cor( USA.data$p_smokers, USA.data$poor_health)
cor.test( USA.data$p_smokers, USA.data$poor_health)



#### **Exercise**

# Find correlation, covariance and perform test for correlation between *p_college* and 
# *p_smokers* variables.
cov( USA.data$p_smokers, USA.data$p_college)
cor( USA.data$p_smokers, USA.data$p_college)
cor.test( USA.data$p_smokers, USA.data$p_college)




### ********************************************
### Chi-square test of independence
### ********************************************


#Let's assign a label to each County based on the median household income:
USA.data_extra <- USA.data %>%
  mutate( wealth = case_when(house_income < 50000 ~ "low",
                             house_income > 80000 ~ "high",
                             TRUE ~ "middle"))

table(USA.data_extra$wealth)


  
#  We would like to test if there is a relationship between two categorical variables:
#  *wealth* and *Region*. 

# Let's first create a contingency table of these two variables:
table(USA.data_extra$Region, USA.data_extra$wealth)


## Let's also draw a barplot to visually represent the data:
ggplot(USA.data_extra) +
  aes(x = Region, fill = wealth) +
  geom_bar() +
  scale_fill_hue() +
  coord_flip() +
  theme_minimal()



##  1. **State Hypothesis**: 
###  *Null-hypothesis* - The variables *Region* and *wealth* are independent, 
###         there is no relationship between these two categorical variables. 
###  *Alternative hypothesis* - the variables are dependent. 
###         Knowing the value of one variable helps to predict the value of the other variable.


## 2. **Formulate an analysis plan**
  
### We will run Chi-square test of independence
### (http://www.sthda.com/english/wiki/chi-square-test-of-independence-in-r).


## 3. **Perform analysis**
res <- chisq.test( table(USA.data_extra$Region, USA.data_extra$wealth) )
res


##  When a warning such as *Chi-squared approximation may be incorrect* appears, 
## it means that the smallest expected frequencies is lower than 5. 
## To avoid this issue, we can either gather some levels or use the *Fisher's exact test*.

## 4. **Interpret results**

## From the output, the p-value < 0.05 implying that we can reject the Null hypothesis and state that there is a significant relationship between the *Region* and *wealth* variables.




### ********************************************
### Linear Regression
### ********************************************

### **Regression analysis** is a statistical technique for determining 
# the relationship between two or more than two variables.


# *Simple Linear Regression* - single explanatory variable

# *Multiple Linear Regression* - the value of the dependent variable depends on more than one
# explanatory variable.



# In order to visualise the linear relationship between independent and 
# dependent variables we use a scatterplot:
ggplot(USA.data) +
  aes(x = p_inactive, y = p_obese) +
  geom_point( alpha = .2) +
  labs( title = "p_obese vs. p_inactive",
        subtitle="USA Population", 
        x =  "p_inactive (%)",  
        y = "p_obese (%)")+
  theme_minimal()


## We can compute compute correlation between these two variables:
 cor( USA.data$p_obese,  USA.data$p_inactive)

# Now we can run linear regression:
lm.fit <- lm( p_obese ~ p_inactive, data = USA.data)
summary(lm.fit)


## R^2 allows us to measure how good this model is. In our case *R-squared* is about 0.3.
## So our model explains only 30% of the data variability. 

# We also should look at the residuals. 
# Their plot should look random - we should see no patterns:

residuals <- lm.fit$residuals
fitted <- lm.fit$fitted.values

res <- data.frame(residuals,fitted )
ggplot(res, aes(x = fitted, y = residuals)) + 
  geom_point(alpha = 0.2) +
  labs(title = "Residuals vs Fitted") + 
  theme_minimal()


#### **Exercise**
## Perform linear regression for variables *poor_health* and *p_smokers*.
lm.fit <- lm( poor_health ~ p_smokers, data = USA.data)
summary(lm.fit)




#### -------------------------------------------------------------------------
#### Read more
#### -------------------------------------------------------------------------

# T.test
#      http://www.sthda.com/english/wiki/t-test-analysis-is-it-always-correct-to-compare-means#t-test
# Correlation analysis
#      http://www.sthda.com/english/wiki/correlation-test-between-two-variables-in-r#correlation-formula
# Chi-square test of independence
#      http://www.sthda.com/english/wiki/chi-square-test-of-independence-in-r
# Linear Regression
#      https://www.datacamp.com/community/tutorials/linear-regression-R



