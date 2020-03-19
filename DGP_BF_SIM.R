rm(list=ls())
install.packages('truncnorm')


library(pacman)
p_load(
  latex2exp, estimatr, lfe, tidyverse, data.table, parallel,
  tidyr, reshape2, viridis, RColorBrewer, plyr, dplyr, purrr, truncnorm, data.table, magrittr
)

#preliminaries

j=1000 #j neighborhoods
n=10000 #n individuals per hood
gender=c(1,0)
race=c('white', 'asian', 'black', 'hispanic')
#create income levels 

nn <- 1e4
set.seed(1234)
sims <- c(rtruncnorm(2*nn/3, a=0, b=10e4, mean=6e4, sd=1.5e4),
          rtruncnorm(nn/3, a=0, b=1e6, mean=1.1e5, sd=2e4))
#create individuals' incomes 
#2016 men: asian 117%, black 73%, hispanic 69%
#2016 women: white 79%, asian 87%, black 65%, hispanic 58%

income_data=as.data.table(1:n)
names(income_data[1])="i"
income_data[,base:=sample(sims, n, replace = T)]
income_data[,gender:=sample(gender, n, replace = T)]#keep for now
income_data[,race:=sample(race, n, replace = T)]
income_data$race%<>%as.factor()
income_data[, white:= ifelse(race=='white', 1, 0)]
income_data[, asian:= ifelse(race=='asian', 1, 0)]
income_data[, black:= ifelse(race=='black', 1, 0)]
income_data[, hispanic:= ifelse(race=='hispanic', 1, 0)]
income_data%<>%mutate(real_income= base*white + base*asian*1.17 + base*black*.73 + base*hispanic*.69)

#create neighborhood 
rm(list = ls(neighborhood))
k=100

?rnorm
neighborhood_function<-function(hood){
  
  income_data=as.data.table(1:n)
  income_data[,base:=sample(sims, n, replace = T)]
  income_data[,gender:=sample(gender, n, replace = T)]#keep for now
  income_data[,race:=sample(race, n, replace = T)]
  income_data$race%<>%as.factor()
  income_data[, white:= ifelse(race=='white', 1, 0)]
  income_data[, asian:= ifelse(race=='asian', 1, 0)]
  income_data[, black:= ifelse(race=='black', 1, 0)]
  income_data[, hispanic:= ifelse(race=='hispanic', 1, 0)]
  income_data%<>%mutate(real_income= base*white + base*asian*1.17 + base*black*.73 + base*hispanic*.69)
  
  neighborhood=as.data.table(sample_n(income_data, k, replace = T))
  names(neighborhood)[1]='i'
  neighborhood[, neighborhood:=hood]
  neighborhood[, amenity_u:=runif(1, max = 4e3, min = 1.5e3)]
  neighborhood[, house_price_u:=rnorm(1, mean = 3e5, sd=5e4)]
  
  neighborhood[, brownfield:=0]
  neighborhood[, amenity_level:=amenity_u+brownfield]
  neighborhood[,house_price:= mean(real_income)+house_price_u]
  neighborhood%<>%select(-i)
  return(neighborhood)
}

temp<-neighborhood_function(1)

full_data<-do.call('rbind', lapply(FUN = neighborhood_function, 1:j))
i<- as.data.table(rownames(full_data))
full_data<-cbind(i, full_data)
names(full_data)[1]='i'
