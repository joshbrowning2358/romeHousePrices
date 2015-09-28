#mark time start script for saving datasets
time = gsub("(-|:| )", "\\.", Sys.time())

#set wd
if(Sys.info()[4] == "JOSH_LAPTOP"){
    workingDir = "C:/Users/rockc_000/Documents/GitHub/romeHousePrices/"
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
## RESPONSE (JOSH): Yeah, we probably don't need them.  Deleting the save calls now :)
## NOTE 2 (FROM !JOSH): I've been meaning to pay for 1 tb of storage on DB everymonth. How about
## I just create a shared folder and keep the final data there?
## RESPONSE (JOSH): Perfect!
## Note 3 (FROM MICHAEL): I promise I'll do it. The internet in this damn house isn't 
## good enough to attempt to scrape from casa.it. Have to mess w/ it Monday.
## I like your approach to saving the .csv files.


files = dir(path = paste0(workingDir, "/R"), full.names = TRUE)
sapply(files, source)

library(data.table)
library(rvest)

## Small sample, Immobiliare Vendita
listingPages = getPropertyUrlsImmobiliare(numPages = 10)
start = Sys.time()
d = lapply(listingPages, getPropertyDetailsImmobiliare)
finalData = rbindlist(d, fill = TRUE)
Sys.time() - start
nrow(finalData)
save(finalData, file = paste0(workingDir, "/Data/detail_ImbVend_", time, ".RData"))

## Small sample, Immobiliare Affitto
listingPages = getPropertyUrlsImmobiliare(numPages = 10, type = "affitto")
start = Sys.time()
d = lapply(listingPages, getPropertyDetailsImmobiliare)
finalData = rbindlist(d, fill = TRUE)
Sys.time() - start
nrow(finalData)
save(finalData, file = paste0(workingDir, "/Data/detail_ImbAff_", time, ".RData"))

## Small sample, Mio Affitto
listingPages = getPropertyUrlsMioAffitto(numPages = 10)
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
start = Sys.time()
# d = lapply(listingPages, getPropertyDetailsImmobiliare)
d = list()
for(i in 1:length(listingPages)){
    ## Save data in chunks to avoid memory issues
    if(i %% 1000 == 0){
        d[[1000]] = getPropertyDetailsImmobiliare(listingPages[[i]])
        finalData = rbindlist(d, fill = TRUE)
        print(paste0(i, "/", length(listingPages), " runs completed so far")) 
        print(Sys.time() - start)
        write.csv(finalData, file = paste0(workingDir, "/Data/detail_ImbVend_",
                                           i, "_", time, ".csv"),
                  row.names = FALSE)
        rm(d, finalData)
        gc()
        d = list()
    } else {
        d[[i %% 1000]] = getPropertyDetailsImmobiliare(listingPages[[i]])
    }
}
## Paste all .csv files together
setwd(paste0(workingDir, "Data"))
systemCommand = paste0("copy detail_ImbVend_*_", time, ".csv detail_ImbVend_",
                       time, ".csv")
systemCommand = shQuote(systemCommand)
if(paste0("detail_ImbVend_", time, ".csv") %in% list.files()){
    stop("File to be created already exists!")
}
## Windows syntax to send the above command to the shell.  This will paste these
## .csv files together:
shell(systemCommand)

## Big sample, Immobiliare Affitto
listingPages = getPropertyUrlsImmobiliare(numPages = 100000, type = "affitto")
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
save(finalData, file = paste0(workingDir, "/Data/detail_Mio_", time, ".RData"))







## Big sample, Casa. it, vendita
listingPages = getPropertyUrlsCasa(numPages = 100000)
start = Sys.time()

d = list()
for(i in 1:length(listingPages)){
  d[[i %% 1000]] = getPropertyDetailsCasa(listingPages[[i]])
  ## Save data in chunks to avoid memory issues
  if(i %% 1000 == 0){
    finalData = rbindlist(d, fill = TRUE)
    print(paste0(i, "/", length(listingPages), " runs completed so far"))
    print(Sys.time() - start)
    write.csv(finalData, file = paste0(workingDir, "/Data/detail_ImbVend_",
                                       i, "_", time, ".csv"),
              row.names = FALSE)
    d = list()
  }
}
Sys.time() - start