###### Different progress for each limit
###### Code by Mauricio Collado

###### Different progress for each limit, start at max K

# erase
rm(list = ls(all = TRUE)) 


# packages
library(tidyverse)
library(here)
library(quadprog)
library(future)

# Where to save datasets
fileplace <- "3 Belize"
# Type of model, in this case we have the simple scenarios
fileplace1 <- "basket3"

########################################################################
########################################################################
# input parameters

# Technology array

qi1 <- 0.0708011	#	Lutjanus apodus
qi2 <- 0.017700275 #	Lutjanus mahogoni
qi3 <- 0.017700275	#	Haemulon parra
qi4 <- 0.017700275	#	Haemulon album


qi7 <- 0 #complete other with zero

# 0.0001

t1 <- c(t=1, q1 = qi1, q2 = qi2, q3 = qi3, q4 = qi4) # one technology is good
t2 <- c(t=2, q1 = qi7, q2 = qi7, q3 = qi7, q4 = qi7) # the other technology is useless

# Tech cost: t = tech, cost = cost per unit effort

c1 <- c(t=1, cost=1)
c2 <- c(t=2, cost=1)
#c3 <- c(t=3, cost=1)
#c4 <- c(t=4, cost=1)
#c5 <- c(t=5, cost=1)
#c6 <- c(t=6, cost=1)

# Years
years = 30

# define base, max and min temp
temp_min=19
temp_max=26
# temp = runif(years, min = temp_min, max = temp_max) 

temp = c(24.96186, 22.78344, 23.18393, 21.37994, 21.63414, 22.50235, 21.18345, 25.96468, 
         20.91578, 19.54157, 23.54480, 24.30295, 20.24743, 25.40967, 20.77083, 22.85526, 
         21.43720, 25.29788, 19.55776, 23.66476, 24.93708, 23.00850, 24.87281, 23.02251, 
         23.28070, 24.51235, 19.96620, 20.82423, 25.95001, 24.94559)

temp_base=mean(unlist(temp))

# define SST anomaly
temp_anom=temp-temp_base

########################################################################
########################################################################
# species parameters

k1 <- 321.9084813	#	Lutjanus apodus
k2 <- 810.2637926	#	Lutjanus mahogoni
k3 <- 316.1966481	#	Haemulon parra
k4 <- 417.9947039	#	Haemulon album

p1 <- 1867.158248
p2 <- 1867.158248
p3 <- 1867.158248
p4 <- 1867.158248

r1 <- 0.440541776	#	Lutjanus apodus
r2 <- 0.295120103	#	Lutjanus mahogoni
r3 <- 0.689627201	#	Haemulon parra
r4 <- 0.572614232	#	Haemulon album

prop=0.2

prop=0.6
prop1=0.2

s1 <- c(s=1, r=r1, K=k1, X=prop*k1, p=p1, tcoef=0) 
s2 <- c(s=2, r=r2, K=k2, X=prop1*k2, p=p2, tcoef=0) #	Lutjanus mahogoni
s3 <- c(s=3, r=r3, K=k3, X=prop*k3, p=p3, tcoef=0) 
s4 <- c(s=4, r=r4, K=k4, X=prop*k4, p=p4, tcoef=0) 

########################################################################
########################################################################
# quota parameters

# basket bundles 1
b1 <- c(s1 = 1, s2 = 1, s3 = 1, s4 = 1)

# msy info
msy_1 <- 35.45353352	#	Lutjanus apodus
msy_2 <- 59.78128349	#	Lutjanus mahogoni
msy_3 <- 54.51445234	#	Haemulon parra
msy_4 <- 59.83742909	#	Haemulon album

mortguess1_1 <- msy_1 + msy_2 + msy_3 + msy_4

mortguess1_1 <- rep(mortguess1_1 , each = 30)

mortguess1 <- c(0.00001, 0.00001, 0.00001, 0.00001, 0.00001, 24.23, 385.96, 561.46, 612, 
                612, 612, 612, 612, 612, 612, 612, 612, 612, 612,612, 612, 612, 612, 612, 
                612, 612, 612, 612, 612, 612)
                

#multiplier <- seq(0.05, 1, by = 0.05) 
multiplier <- seq(0.01, 1, by = 0.01) 

########################################################################
########################################################################
# input list

species = list(s1, s2, s3, s4)
tech = list(t1, t2)
cost = list(c1, c2)
baskets = list(b1)

########################################################################
########################################################################
# input list
# load function

source(here("functions_cc_fixed", "optimal_baskets_cc_op1.R"))
source(here("functions_cc_fixed", "qb_stock_m_cc_op1.R"))

# loop across each scenario
for (i in multiplier){
  mortguess2 <- mortguess1_1*i
  
  output <- optimal_baskets(species, tech, cost, baskets, mort_guess=mortguess2, years)
  
  csvname <- paste0("output_", i,"_.csv")
  csvfile <- paste(csvname, sep="")
  write.table(na.omit(output),here(fileplace, fileplace1,"results", csvfile),
              row.names=FALSE, sep=",")
}

########################################################################
########################################################################