---
title: "README"
author: "Sam Murray"
date: "9/28/2021"
output: github_document
---

**Import libraries**
```{r library}
#install.packages("nycflights13")
library(dplyr)
library(nycflights13)
library(ggplot2)
```
**Q1) Number of flights with missing departure time**
```{r Q1-part1}
flights %>% 
  mutate(isPresent = is.na(dep_time)) %>% 
  summarize(total_canceled_flights = sum(isPresent))
```
**Q1 part2) Looking at observations with missing depature time, other columns with missing values**
```{r Q1-part2}
flights %>% 
  mutate(isPresent = is.na(dep_time)) %>% 
  filter(isPresent == T) %>% 
  select(which(colMeans(is.na(.))==1))
```
**Q2) Change dep_time and sched_dep_time to minutes from midnight**
```{r Q2}
flights %>% 
  select(dep_time, sched_dep_time)

flights = flights %>% 
  #get hour number by using integer division by 100 and multiply by 60 to get minutes, then find remainder by 100 to get just minutes and add
  mutate(dep_time = ((dep_time %/% 100)*60 + (dep_time %% 100)),
         sched_dep_time = ((sched_dep_time %/% 100)*60 + (sched_dep_time %% 100)))

flights %>% 
  select(dep_time, sched_dep_time)
```
**Q3) Pattern in canceled flights per day**
```{r Q3}
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


