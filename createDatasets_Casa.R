#script for Michael scraping Casa.it

##################################################################


####################
## CONFIGURATION  ##
####################


library(data.table)
library(dplyr)
library(rvest)
library(romeHousePrices)

if(Sys.info()[4] == "JOSH_LAPTOP"){
  workingDir = "~/GitHub/romeHousePrices"
  savingDir = "~/../Dropbox/romeHouseData/"
} else if(Sys.info()[4] == "joshuaUbuntuLinux"){
  workingDir = "~/Documents/Github/romeHousePrices"
} else if(Sys.info()[4] =="Michaels-MacBook-Pro-2.local"|
          Sys.info()[4] == "Michaels-MBP-2.lan"){
  workingDir = "~/Dropbox/romeHousePrices/" 
  savingDir = "~/DropBox/romeHouseData/" #for michael's mac yo
} else {
  stop("No directory for current user!")
}

setwd(workingDir)

files = dir(path = paste0(workingDir, "/R"), full.names = TRUE)
sapply(files, source)

#mark time start script for saving datasets
time = gsub("(-|:| )", "\\.", Sys.time())

#####################################################################


###################
##    VENDITA    ## 
###################

## LISTING
start = Sys.time()

urls <- getCasaMainPages(type = "vendita")

listingPages <- c()
for(i in 1:length(urls)){
  property.pages.temp <- getPropertyUrlsCasa(url = urls[i])
  listingPages <- append(listingPages,property.pages.temp)
}

listing.time <- Sys.time() - start
print(paste0("listing time was",listing.time))
write.csv(listingPages,file = paste0(savingDir,"listing_CasaVend_",time,".csv"))

##HARVESTING
start.harvest <- Sys.time()
d = list()
for(i in 1:length(listingPages)){
  ## Save data in chunks to avoid memory issues
  if(i %% 1000 == 0){
    d[[1000]] = getPropertyDetailsCasa(listingPages[[i]])
    finalData = rbindlist(d, fill = TRUE)
    print(paste0(i, "/", length(listingPages), " runs completed so far")) 
    print(Sys.time() - start)
    write.csv(finalData, file = paste0(savingDir, "/detail_VenditaCasa_",
                                       i, "_", time, ".csv"),
              row.names = FALSE)
    rm(d, finalData)
    gc()
    d = list()
  } else {
    d[[i %% 1000]] = getPropertyDetailsCasa(listingPages[[i]])
  }
  #print(i)  
}

harvest.time = Sys.time() - start.harvest
harvest.time

###########################
## Create master dataset ##
##  for vendita         ##
###########################
mioFiles = list.files(savingDir, pattern = "ImbCasa")

master <- read.csv(paste0(savingDir,mioFiles[1]),stringsAsFactors = FALSE)

for(i in 2:length(mioFiles)){
  temp <- read.csv(paste0(savingDir,mioFiles[i]), stringsAsFactors = FALSE)
  test <- colnames(temp) == "X" #in some datasets, row names were saved. must remove
  temp <- temp[,!test]
  
  if("Prezzo" %in% colnames(temp)){
    test <- grep("Prezzo", colnames(temp))
    
    temp <- temp[,-c(test)]
  }
  
  master <- rbind(master,temp)
  print(i)
}

###################
##    Affitto   ## 
###################

## LISTING
start = Sys.time()

urls <- getCasaMainPages(type = "affitto")

listingPages <- c()
for(i in 1:length(urls)){
  property.pages.temp <- getPropertyUrlsCasa(url = urls[i])
  listingPages <- append(listingPages,property.pages.temp)
}

listing.time <- Sys.time() - start
print(paste0("listing time was",listing.time))
write.csv(listingPages,file = paste0(savingDir,"listing_CasaAff_",time,".csv"))

##HARVESTING
start.harvest <- Sys.time()
d = list()
for(i in 1:length(listingPages)){
  ## Save data in chunks to avoid memory issues
  if(i %% 1000 == 0){
    d[[1000]] = getPropertyDetailsCasa(listingPages[[i]])
    finalData = rbindlist(d, fill = TRUE)
    print(paste0(i, "/", length(listingPages), " runs completed so far")) 
    print(Sys.time() - start)
    write.csv(finalData, file = paste0(savingDir, "/detail_AffCasa_",
                                       i, "_", time, ".csv"),
              row.names = FALSE)
    rm(d, finalData)
    gc()
    d = list()
  } else {
    d[[i %% 1000]] = getPropertyDetailsCasa(listingPages[[i]])
  }
  #print(i)  
}

harvest.time = Sys.time() - start.harvest
harvest.time


