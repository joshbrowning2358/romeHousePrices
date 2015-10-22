#explore a bit Imb Casa_vendita

library(data.table)
library(dplyr)
library(rvest)
library(romeHousePrices)

if(Sys.info()[4] == "JOSH_LAPTOP"){
  workingDir = "~/GitHub/romeHousePrices"
  savingDir = "~/../Dropbox/romeHouseData/"
} else if(Sys.info()[4] == "joshuaUbuntuLinux"){
  workingDir = "~/Documents/Github/romeHousePrices"
} else if(Sys.info()[4] =="Michaels-MacBook-Pro-2.local"||
          Sys.info()[4] == "Michaels-MBP-2.lan"){
  workingDir = "~/Dropbox/romeHousePrices/" 
  savingDir = "~/DropBox/romeHouseData/" #for michael's mac yo
} else {
  stop("No directory for current user!")
}


dataFiles = list.files(savingDir, pattern = ".csv")
mioFiles = dataFiles[grepl("^detail_ImbCasa.*.csv", dataFiles)]

d <- read.csv(paste0(savingDir,mioFiles[5]),stringsAsFactors = FALSE)
nrow(d)
ncol(d)
colnames(d)
sapply(d,class)

#explore indirizzo
head(d[,1])
tail(d[,1])

length(unique(d[,1]))
sum(d[,1] == "Roma")

#####################
## clean addresses ##
#####################
#replace addresses on "Roma" with NA
test.i <- d$indirizzo == "Roma"
d$indirizzo[test.i] <- "NA"

####################
## create CAP     ##
####################

d$cap <- gsub(".*, ","",d$indirizzo)
d$cap <- gsub("-.*","",d$cap)
test.cap <- grepl("[0-9]{5}",d$cap)
d$cap[!test.cap] <- "NA"

