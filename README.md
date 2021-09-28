README
================
Sam Murray
9/28/2021

**Import libraries**

``` r
#install.packages("nycflights13")
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(nycflights13)
```

    ## Warning: package 'nycflights13' was built under R version 3.6.2

``` r
library(ggplot2)
```

**Q1) Number of flights with missing departure time**

``` r
flights %>% 
  mutate(isPresent = is.na(dep_time)) %>% 
  summarize(total_canceled_flights = sum(isPresent))
```

    ## # A tibble: 1 x 1
    ##   total_canceled_flights
    ##                    <int>
    ## 1                   8255

**Q1 part2) Looking at observations with missing depature time, other
columns with missing values**

``` r
flights %>% 
  mutate(isPresent = is.na(dep_time)) %>% 
  filter(isPresent == T) %>% 
  select(which(colMeans(is.na(.))==1))
```

    ## # A tibble: 8,255 x 5
    ##    dep_time dep_delay arr_time arr_delay air_time
    ##       <int>     <dbl>    <int>     <dbl>    <dbl>
    ##  1       NA        NA       NA        NA       NA
    ##  2       NA        NA       NA        NA       NA
    ##  3       NA        NA       NA        NA       NA
    ##  4       NA        NA       NA        NA       NA
    ##  5       NA        NA       NA        NA       NA
    ##  6       NA        NA       NA        NA       NA
    ##  7       NA        NA       NA        NA       NA
    ##  8       NA        NA       NA        NA       NA
    ##  9       NA        NA       NA        NA       NA
    ## 10       NA        NA       NA        NA       NA
    ## # … with 8,245 more rows

**Q2) Change dep\_time and sched\_dep\_time to minutes from midnight**

``` r
flights %>% 
  select(dep_time, sched_dep_time)
```

    ## # A tibble: 336,776 x 2
    ##    dep_time sched_dep_time
    ##       <int>          <int>
    ##  1      517            515
    ##  2      533            529
    ##  3      542            540
    ##  4      544            545
    ##  5      554            600
    ##  6      554            558
    ##  7      555            600
    ##  8      557            600
    ##  9      557            600
    ## 10      558            600
    ## # … with 336,766 more rows

``` r
flights = flights %>% 
  #get hour number by using integer division by 100 and multiply by 60 to get minutes, then find remainder by 100 to get just minutes and add
  mutate(dep_time = ((dep_time %/% 100)*60 + (dep_time %% 100)),
         sched_dep_time = ((sched_dep_time %/% 100)*60 + (sched_dep_time %% 100)))

flights %>% 
  select(dep_time, sched_dep_time)
```

    ## # A tibble: 336,776 x 2
    ##    dep_time sched_dep_time
    ##       <dbl>          <dbl>
    ##  1      317            315
    ##  2      333            329
    ##  3      342            340
    ##  4      344            345
    ##  5      354            360
    ##  6      354            358
    ##  7      355            360
    ##  8      357            360
    ##  9      357            360
    ## 10      358            360
    ## # … with 336,766 more rows

**Q3) Pattern in canceled flights per day**

``` r
flights %>% 
  
  #add columns for each day of the year (1-1 to 12-31) 
  mutate(day_of_year = paste(month, day, sep = "-"),
         canceled = is.na(air_time)) %>% 
  
  group_by(day_of_year) %>% 
  
  summarize(canceled_flights = sum(canceled),
            proportion_of_flights_canceled = canceled_flights/n(),
            avg_delay = sum(dep_delay,na.rm=T)/n()) %>% 
  
  ggplot(aes(x=proportion_of_flights_canceled ,y=avg_delay)) + geom_point()
```

![](README_files/figure-gfm/Q3-1.png)<!-- -->
