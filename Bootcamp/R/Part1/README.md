Research Computing Bootcamp
================
Boston University

<style type="text/css">

body{ /* Normal  */
  font-size: 12px;
}
td {  /* Table  */
  font-size: 8px;
}
code.r{ /* Code block */
    font-size: 12px;
    background-color: #FAEAEA; 
}
pre { /* Code block - determines code spacing between lines */
    font-size: 12px;
     
}
</style>

<br><br>

### R Track: Part 1

This Bootcamp will teach you how to analyze a dataset using R
programming language. We will go over:

  - Import your data into R
  - Clean (tidy) data
  - Transform Data
  - Explore the data using visualization tools
  - Run basic statistical analysis
  - Communicate results

#### Basic Arithmetic

Let’s try to perform basic arithmetic operations, i.e:

``` r bg-success
4 + 7
```

    ## [1] 11

We can also use brackets and basic math functions:

``` r
3.5 + (7 - 9)/5.8 - log(1.2)
```

    ## [1] 2.972851

#### Assigning values to a variable

R uses an arrow sign to assign a value to a variable:

``` r
x <- 2.71
```

#### Data types in R

Basic Data types in R:

  - Numeric
  - Integer
  - Logical
  - Character

Numeric is the default data type for numbers in R:

``` r
x <- 5.24
class(x)
```

    ## [1] "numeric"

``` r
typeof(x)
```

    ## [1] "double"

Numeric values are stored with *double* precision.

To store value as an integer, we can add *L* symbol at the end:

``` r
i <- 3L
class(i)
```

    ## [1] "integer"

``` r
typeof(i)
```

    ## [1] "integer"

The logical data type stores boolean values:

``` r
ans <- TRUE
class(ans)
```

    ## [1] "logical"

The character data type variables store single characters or strings.
Double or single commas can be used to define a character value:

``` r
my.name <- "Katia Bulekova"
```
