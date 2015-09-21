
#mark time start script for saving datasets
time = gsub("(-|:| )", "\\.", Sys.time())

#set wd
if(Sys.info()[4] == "JOSH_LAPTOP"){
    workingDir = "~/GitHub/romeHousePrices/"
} else if(Sys.info()[4] == "joshua-Ubuntu-Linux"){
    workingDir = "~/Documents/Github/romeHousePrices"
} else if(Sys.info()[4] =="Michaels-MBP-2.lan"){
  workingDir = "~/Dropbox/romeHousePrices/"        #for michael's mac yo
} else {
    stop("No directory for current user!")
}


files = dir(path = paste0(workingDir, "/R"), full.names = TRUE)
sapply(files, source)

library(data.table)
library(rvest)

## Small sample, Immobiliare Vendita
listingPages = getPropertyUrlsImmobiliare(numPages = 10)
save(listingPages, file = paste0(workingDir, "/Data/listingPagesImbVend_SMALL_", time, ".RData"))
start = Sys.time()
d = lapply(listingPages, getPropertyDetailsImmobiliare)
finalData = rbindlist(d, fill = TRUE)
Sys.time() - start
nrow(finalData)
save(finalData, file = paste0(workingDir, "/Data/detailImbVend_SMALL_", time, ".RData"))

## Small sample, Immobiliare Affitto
listingPages = getPropertyUrlsImmobiliare(numPages = 10, type = "affitto")
save(listingPages, file = paste0(workingDir, "/Data/listingPagesImbAff_SMALL_", time, ".RData"))
start = Sys.time()
d = lapply(listingPages, getPropertyDetailsImmobiliare)
finalData = rbindlist(d, fill = TRUE)
Sys.time() - start
nrow(finalData)
save(finalData, file = paste0(workingDir, "/Data/detailImbAff_SMALL_", time, ".RData"))

## Small sample, Mio Affitto
listingPages = getPropertyUrlsMioAffitto(numPages = 10)
save(listingPages, file = paste0(workingDir, "/Data/listingPagesMioAff_SMALL_", time, ".RData"))
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
save(finalData, file = paste0(workingDir, "Data/detailMioAff_SMALL_", time, ".RData"))





## Small sample, casa.it
listingPages = getPropertyUrlsCasa(numPages = 10) #used super small sample
save(listingPages, file = paste0(workingDir,"Data/listingPagesCasa_", time, ".RData"))
start = Sys.time()





## Big sample, Immobiliare Vendita
listingPages = getPropertyUrlsImmobiliare(numPages = 100000)
save(listingPages, file = paste0(workingDir, "/Data/listingPagesImbVend_", time, ".RData"))
start = Sys.time()
d = lapply(listingPages, getPropertyDetailsImmobiliare)
finalData = rbindlist(d, fill = TRUE)
Sys.time() - start
nrow(finalData)
save(finalData, file = paste0(workingDir, "/Data/detailImbVend_", time, ".RData"))

## Big sample, Mio Affitto
listingPages = getPropertyUrlsMioAffitto(numPages = 100000)
save(listingPages, file = paste0(workingDir, "/Data/listingPagesMioAff_", time, ".RData"))
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
save(finalData, file = paste0(workingDir, "/Data/detailDataMioAff_", time, ".RData"))

## Big sample, Immobiliare Affitto
listingPages = getPropertyUrlsImmobiliare(numPages = 100000, type = "affitto")
save(listingPages, file = paste0(workingDir, "/Data/listingPagesImbAff_", time, ".RData"))
start = Sys.time()
d = lapply(listingPages, getPropertyDetailsImmobiliare)
finalData = rbindlist(d, fill = TRUE)
Sys.time() - start
nrow(finalData)
save(finalData, file = paste0(workingDir, "/Data/detailImbAff_", time, ".RData"))
