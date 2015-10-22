library(data.table)
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

setwd(workingDir)

files = dir(path = paste0(workingDir, "/R"), full.names = TRUE)
sapply(files, source)

#mark time start script for saving datasets
time = gsub("(-|:| )", "\\.", Sys.time())

#set wd
assignDirectory()

## Big sample, Immobiliare Vendita
listingPages = getPropertyUrlsImmobiliare(numPages = 100000)
start = Sys.time()
# d = lapply(listingPages, getPropertyDetailsImmobiliare)
d = list()
for(i in 1:length(listingPages)){
    if(i %% 100 == 0){
        print(paste0(i, "/", length(listingPages), " runs completed so far")) 
        print(Sys.time() - start)
    }
    d[[i]] = getPropertyDetailsImmobiliare(listingPages[[i]])
}
finalData = rbindlist(d, fill = TRUE)
write.csv(finalData, file = paste0(savingDir, "/detail_ImbVend_", time, ".csv"),
          row.names = FALSE)
finalData = read.csv(paste0(savingDir, "/detail_ImbVend_", time, ".csv"))
finalData = data.table(finalData)
d = cleanImb(finalData)
save(d, file = paste0(savingDir, "/detail_ImbVend_", time, "_cleaned.RData"))

## Big sample, Immobiliare Affitto
listingPages = getPropertyUrlsImmobiliare(numPages = 100000, type = "affitto")
start = Sys.time()
# d = lapply(listingPages, getPropertyDetailsImmobiliare)
d = list()
for(i in 1:length(listingPages)){
    if(i %% 100 == 0){
        print(paste0(i, "/", length(listingPages), " runs completed so far")) 
        print(Sys.time() - start)
    }
    d[[i]] = getPropertyDetailsImmobiliare(listingPages[[i]])
}
finalData = rbindlist(d, fill = TRUE)
write.csv(finalData, file = paste0(savingDir, "/detail_ImbAff_", time, ".csv"),
          row.names = FALSE)
finalData = read.csv(paste0(savingDir, "/detail_ImbAff_", time, ".csv"))
finalData = data.table(finalData)
d = cleanImb(finalData)
save(d, file = paste0(savingDir, "/detail_ImbAff_", time, "_cleaned.RData"))


## Big sample, Mio Affitto
listingPages = getPropertyUrlsMioAffitto(numPages = 100000)
start = Sys.time()
# d = lapply(listingPages, getPropertyDetailsMioAffitto)
d = list()
for(i in 1:length(listingPages)){
    if(i %% 100 == 0){
        print(paste0(i, "/", length(listingPages), " runs completed so far")) 
        print(Sys.time() - start)
    }
    d[[i]] = getPropertyDetailsMioAffitto(listingPages[[i]])
}
finalData = rbindlist(d, fill = TRUE)
Sys.time() - start
nrow(finalData)
write.csv(finalData, file = paste0(savingDir, "/detail_Mio_", time, ".csv"),
          row.names = FALSE)
finalData = read.csv(paste0(savingDir, "/detail_Mio_", time, ".csv"))
finalData = data.table(finalData)
d = cleanImb(finalData)
save(d, file = paste0(savingDir, "/detail_Mio_", time, "_cleaned.RData"))





