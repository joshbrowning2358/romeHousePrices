load("~/GitHub/romeHousePrices/Data/detailMioAff_SMALL_2015.09.02.18.53.29.RData")
library(data.table)
finalData

setwd("~/Professional Files/eBags")
load("Rpackages")
for (p in setdiff(packages, installed.packages()[,"Package"]))
    install.packages(p)
