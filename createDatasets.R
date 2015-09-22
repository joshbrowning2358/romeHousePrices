#mark time start script for saving datasets
time = gsub("(-|:| )", "\\.", Sys.time())

#set wd
if(Sys.info()[4] == "JOSH_LAPTOP"){
    workingDir = "~/GitHub/romeHousePrices/"
} else if(Sys.info()[4] == "joshua-Ubuntu-Linux"){
    workingDir = "~/Documents/Github/romeHousePrices"
} else if(Sys.info()[4] =="Michaels-MacBook-Pro-2.local"||
          Sys.info()[4] == "Michaels-MBP-2.lan"){
    workingDir = "~/Dropbox/romeHousePrices/"        #for michael's mac yo
} else {
    stop("No directory for current user!")
}

## NOTE (FROM JOSH): I'm trying to standardize the file names here.  I'm 
## thinking listing_(site)_(date).RData or detail_(site)_(date).RData.  Sound
## good?
## NOTE (FROM MR): One thing I never really understood, why are we saving the listing urls? They're going
## to be in the final dataset right? 
## NOTE 2 (FROM !JOSH): I've been meaning to pay for 1 tb of storage on DB everymonth. How about
## I just create a shared folder and keep the final data there?

files = dir(path = paste0(workingDir, "/R"), full.names = TRUE)
sapply(files, source)

library(data.table)
library(rvest)

## Small sample, Immobiliare Vendita
listingPages = getPropertyUrlsImmobiliare(numPages = 10)
save(listingPages, file = paste0(workingDir, "/Data/listing_ImbVend_", time, ".RData"))
start = Sys.time()
d = lapply(listingPages, getPropertyDetailsImmobiliare)
finalData = rbindlist(d, fill = TRUE)
Sys.time() - start
nrow(finalData)
save(finalData, file = paste0(workingDir, "/Data/detail_ImbVend_", time, ".RData"))

## Small sample, Immobiliare Affitto
listingPages = getPropertyUrlsImmobiliare(numPages = 10, type = "affitto")
save(listingPages, file = paste0(workingDir, "/Data/listing_ImbAff_", time, ".RData"))
start = Sys.time()
d = lapply(listingPages, getPropertyDetailsImmobiliare)
finalData = rbindlist(d, fill = TRUE)
Sys.time() - start
nrow(finalData)
save(finalData, file = paste0(workingDir, "/Data/detail_ImbAff_", time, ".RData"))

## Small sample, Mio Affitto
listingPages = getPropertyUrlsMioAffitto(numPages = 10)
save(listingPages, file = paste0(workingDir, "/Data/listing_MioAff_", time, ".RData"))
start = Sys.time()
# d = lapply(listingPages, getPropertyDetailsMioAffitto)
d = list()
for(i in 1:length(listingPages))
    d[[i]] = getPropertyDetailsMioAffitto(listingPages[[i]])
finalData = rbindlist(d, fill = TRUE)
Sys.time() - start
finalData[!grepl("L' inserzionista ha", indirizzio),
          c("longitude", "latitude") := as.list(addressToCoord(indirizzio))]
Sys.time() - start
nrow(finalData)
save(finalData, file = paste0(workingDir, "Data/detail_Mio_", time, ".RData"))


## Big sample, Immobiliare Vendita
listingPages = getPropertyUrlsImmobiliare(numPages = 100000)
save(listingPages, file = paste0(workingDir, "/Data/listing_ImbVend_", time, ".RData"))
start = Sys.time()
# d = lapply(listingPages, getPropertyDetailsImmobiliare)
d = list()
for(i in 1:length(listingPages))
    d[[i]] = getPropertyDetailsImmobiliare(listingPages[[i]])
finalData = rbindlist(d, fill = TRUE)
Sys.time() - start
nrow(finalData)
save(finalData, file = paste0(workingDir, "/Data/detail_ImbVend_", time, ".RData"))

## Big sample, Immobiliare Affitto
listingPages = getPropertyUrlsImmobiliare(numPages = 100000, type = "affitto")
save(listingPages, file = paste0(workingDir, "/Data/listing_ImbAff_", time, ".RData"))
start = Sys.time()
# d = lapply(listingPages, getPropertyDetailsImmobiliare)
d = list()
for(i in 1:length(listingPages))
    d[[i]] = getPropertyDetailsImmobiliare(listingPages[[i]])
finalData = rbindlist(d, fill = TRUE)
Sys.time() - start
nrow(finalData)
save(finalData, file = paste0(workingDir, "/Data/detail_ImbAff_", time, ".RData"))

## Big sample, Mio Affitto
listingPages = getPropertyUrlsMioAffitto(numPages = 100000)
save(listingPages, file = paste0(workingDir, "/Data/listing_Mio_", time, ".RData"))
start = Sys.time()
# d = lapply(listingPages, getPropertyDetailsMioAffitto)
d = list()
for(i in 1:length(listingPages))
    d[[i]] = getPropertyDetailsMioAffitto(listingPages[[i]])
finalData = rbindlist(d, fill = TRUE)
Sys.time() - start
finalData[, c("longitude", "latitude") := rep(NA_real_, .N)]
addresses = finalData[, sapply(indirizzio, addressToCoord, source = "google")]
finalData[, longitude := addresses[1, ]]
finalData[, latitude := addresses[2, ]]
# finalData[, c("longitude", "latitude") := as.list(addressToCoord(indirizzio))]
Sys.time() - start
nrow(finalData)
save(finalData, file = paste0(workingDir, "/Data/detail_Mio_", time, ".RData"))








## Small sample, casa.it, in vendita
start = Sys.time()
listingPages = getPropertyUrlsCasa(numPages = 10)#used super small sample
save(listingPages, file = paste0(workingDir,"Data/listing_Casa_", time, ".RData"))
d = list()
for(i in 1:length(listingPages)){
  d[[i]] = getPropertyDetailsCasa(listingPages[[i]])
  #print(i)
}
finalData = rbindlist(d, fill = TRUE)
Sys.time() - start

