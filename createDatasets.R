library(data.table)
library(rvest)
library(romeHousePrices)

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
    ## Save data in chunks to avoid memory issues
    if(i %% 100 == 0){
        print(paste0(i, "/", length(listingPages), " runs completed so far")) 
        print(Sys.time() - start)
    }
    d[[i]] = getPropertyDetailsImmobiliare(listingPages[[i]])
}
finalData = rbindlist(d, fill = TRUE)
write.csv(finalData, file = paste0(savingDir, "/detail_ImbVend_", time, ".csv"),
          row.names = FALSE)

## Big sample, Immobiliare Affitto
listingPages = getPropertyUrlsImmobiliare(numPages = 100000, type = "affitto")
start = Sys.time()
# d = lapply(listingPages, getPropertyDetailsImmobiliare)
d = list()
for(i in 1:length(listingPages)){
    ## Save data in chunks to avoid memory issues
    if(i %% 100 == 0){
        print(paste0(i, "/", length(listingPages), " runs completed so far")) 
        print(Sys.time() - start)
    }
    d[[i]] = getPropertyDetailsImmobiliare(listingPages[[i]])
}
finalData = rbindlist(d, fill = TRUE)
write.csv(finalData, file = paste0(savingDir, "/detail_ImbAff_", time, ".csv"),
          row.names = FALSE)


## Big sample, Mio Affitto
listingPages = getPropertyUrlsMioAffitto(numPages = 100000)
start = Sys.time()
# d = lapply(listingPages, getPropertyDetailsMioAffitto)
d = list()
for(i in 1:length(listingPages))
    d[[i]] = getPropertyDetailsMioAffitto(listingPages[[i]])
finalData = rbindlist(d, fill = TRUE)
Sys.time() - start
finalData[, c("longitude", "latitude") := rep(NA_real_, .N)]
addresses = lapply(finalData$indirizzio, addressToCoord, source = "google")
addresses = do.call(rbind, addresses)
finalData[, longitude := addresses$Longitude]
finalData[, latitude := addresses$Latitude]
# finalData[, c("longitude", "latitude") := as.list(addressToCoord(indirizzio))]
Sys.time() - start
nrow(finalData)
write.csv(finalData, file = paste0(savingDir, "/detail_Mio_", time, ".csv"),
          row.names = FALSE)







## Big sample, Casa Vendita
listingPages = getPropertyUrlsCasa(numPages = 10000000)
start = Sys.time()

d = list()
for(i in 1:length(listingPages)){
  ## Save data in chunks to avoid memory issues
  if(i %% 1000 == 0){
    d[[1000]] = getPropertyDetailsCasa(listingPages[[i]])
    finalData = rbindlist(d, fill = TRUE)
    print(paste0(i, "/", length(listingPages), " runs completed so far")) 
    print(Sys.time() - start)
    write.csv(finalData, file = paste0(savingDir, "/detail_ImbVend_",
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
## Paste all .csv files together

## Big sample, Casa AFFITTO
listingPages = getPropertyUrlsCasa(numPages = 10000000, type = "affitto")
start = Sys.time()

d = list()
for(i in 1:length(listingPages)){
  ## Save data in chunks to avoid memory issues
  if(i %% 1000 == 0){
    d[[1000]] = getPropertyDetailsCasa(listingPages[[i]])
    finalData = rbindlist(d, fill = TRUE)
    print(paste0(i, "/", length(listingPages), " runs completed so far")) 
    print(Sys.time() - start)
    write.csv(finalData, file = paste0(savingDir, "/Data/detail_CasaAff_",
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


dataFiles = list.files(dir, pattern = ".csv")
mioFiles = dataFiles[grepl("^detail_Mio.*.csv", dataFiles)]
for(file in mioFiles){
    d = read.csv(paste0(dir, file))
    ## Only clean if it hasn't been cleaned yet
    if(!is.numeric(d$prezzio)){
        d = cleanMioAffitto(data.table(d))
        write.csv(d, file = paste0(dir, gsub(".csv", "_cleaned.csv", file)))
    }
}

imbFiles = dataFiles[grepl("^detail_Imb.*.csv", dataFiles)]
for(file in imbFiles){
    d = read.csv(paste0(dir, file))
    if(!is.numeric(d$prezzio)){
        d = cleanImb(data.table(d))
        write.csv(d, file = paste0(dir, gsub(".csv", "_cleaned.csv", file)))
    }
}