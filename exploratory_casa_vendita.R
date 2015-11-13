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


dataFiles = list.files(savingDir, pattern = ".Rdta")
mioFiles = dataFiles[grepl("^Vend_Casa", dataFiles)]

load(paste0(savingDir,mioFiles))
d <- as.data.frame(master)

#########################
##   GENERAL CLEANING  ##
#########################

# REMOVE DUPLICATES
d <- unique(d)

#clean column names
colnames(d) <- gsub("[^a-zA-Z0-9]","",colnames(d))

#randomly sample some rows:
# set.seed(1)
# samp <- sample(1:nrow(master),100)
# d <- d[samp,]

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

##############################
##    ZONA                  ##
## *FIND WAY TO SOLVE NA    ##
##############################
blank <- d$zona == ""
d$zona[blank] = "NA"

# tab <-  d %>% group_by(zona) %>% summarize(num=length(indirizzo))
# tab$share = tab$num/nrow(d)
# tab$share <- round(tab$share, digits = 3)
# tab

############################
##      CLEAN PRICE       ##
############################
d$prezzo  <- gsub("^[€]","",d$prezzo)
d$prezzo <- gsub("[€] .*","",d$prezzo)
d$prezzo <- gsub("^ ","",d$prezzo)
d$prezzo <- gsub(" $","",d$prezzo)
d$prezzo <- gsub("[^a-zA-Z0-9]","",d$prezzo)

#change price withheld to NA
d$prezzo <- as.numeric(d$prezzo)


############################
##        CATEGORIA       ##
############################
#OK

############################
##      TIPOLOGIA         ##
############################
# tab <- d %>% group_by(Tipologia) %>% summarize(n())
# tab


###########################
##      BAGNI            ##
#*filter bagni for reasonable number, or use bagni x sq. meter for model?
###########################
tab <- d %>% group_by(Bagni) %>% summarize(n())

test <- filter(d, Bagni > 10)
head(test)
test2 <- select(test,url,Bagni, tipologia)

##########################
## LOCALI               ##
##########################
# tab <- d %>% group_by(Locali) %>% summarize(n())
# data.frame(tab)
###########################################################


###########################
## PIANO                 ##
###########################
terra = grepl("terra",d$Piano)
d$Piano[terra] <- 0
#tab <- d %>% group_by(Piano) %>% summarize(n())

###########################
##    STATO AL ROGITO    ##
###########################
#OK

##########################
##    CONDIZIONI        ##
##########################
#OK
#unique(d$Condizioni)


#########################
##    METRIQUADRI      ##
#########################
d$Metriquadri <- gsub(" mq","",d$Metriquadri)
gsub("\\.","",d$Metriquadri)


unique(d$Metriquadri)
quantile(d$Metriquadri, probs = seq(0,1,.05), na.rm = TRUE)
colnames(d)


colnames(d)[1] <- "indirizzio"



d <- data.table(d)
save(d,file = paste0(savingDir,"Data","DataVend_Casa2015-10-24cleaneded.RData."))

start.time = Sys.time()
pullNewAddresses()
#load(paste0(savingDir,"Data","Vend_Casa",Sys.Date(),"cleaned.RData"))
address.time = Sys.time() - start.time
address.time
pullGridAddresses()
#x <- read.csv(paste0(list.files()[7],"/addressDatabase.csv"))
# tartu_map <- get_map(location = "rome", maptype = "satellite", zoom = 12)
# ggmap(tartu_map, extent = "device") + geom_point(aes(x = lon, y = lat), colour = "red", 
#                                                  alpha = 0.1, size = 2, data = tartu_housing_xy_wgs84_a)
