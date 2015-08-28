time = gsub("(-|:| )", "\\.", Sys.time())
if(Sys.info()[4] == "JOSH_LAPTOP"){
    workingDir = "~/GitHub/romeHousePrices/"
} else if(Sys.info()[4] == "joshua-Ubuntu-Linux"){
    workingDir = "~/Documents/Github/romeHousePrices"
} else {
    stop("No directory for current user!")
}
files = dir(path = paste0(workingDir, "/R"), full.names = TRUE)
sapply(files, source)

## Small sample, Immobiliare Vendita
listingPages = getPropertyUrlsImmobiliare(numPages = 10)
save(listingPages, file = paste0("~/Documents/Github/romeHousePrices/Data/listingPagesImbVend_", time, ".RData"))
start = Sys.time()
d = lapply(listingPages, getPropertyDetailsImmobiliare)
finalData = rbindlist(d, fill = TRUE)
Sys.time() - start
nrow(finalData)
save(d, file = paste0(workingDir, "/Data/detailImbVend_", time, ".RData"))

## Small sample, Immobiliare Affitto
listingPages = getPropertyUrlsImmobiliare(numPages = 10, type = "affitto")
save(listingPages, file = paste0("~/Documents/Github/romeHousePrices/Data/listingPagesImbAff_", time, ".RData"))
start = Sys.time()
d = lapply(listingPages, getPropertyDetailsImmobiliare)
finalData = rbindlist(d, fill = TRUE)
Sys.time() - start
nrow(finalData)
save(d, file = paste0(workingDir, "/Data/detailImbAff_", time, ".RData"))

## Small sample, Mio Affitto
listingPages = getPropertyUrlsMioAffitto(numPages = 10)
save(listingPages, file = paste0("~/Documents/Github/romeHousePrices/Data/listingPages_", time, ".RData"))
start = Sys.time()
d = lapply(listingPages, getPropertyDetails)
finalData = rbindlist(d, fill = TRUE)
Sys.time() - start
nrow(finalData)
save(d, file = paste0("~/Documents/Github/romeHousePrices/Data/detailData_", time, ".RData"))

## Big sample, Immobiliare Vendita
listingPages = getPropertyUrlsImmobiliare(numPages = 100000)
save(listingPages, file = paste0("~/Documents/Github/romeHousePrices/Data/listingPagesImbVend_", time, ".RData"))
start = Sys.time()
d = lapply(listingPages, getPropertyDetailsImmobiliare)
finalData = rbindlist(d, fill = TRUE)
Sys.time() - start
nrow(finalData)
save(d, file = paste0(workingDir, "/Data/detailImbVend_", time, ".RData"))

## Big sample, Mio Affitto
listingPages = getPropertyUrlsMioAffitto(numPages = 100000)
save(listingPages, file = paste0("~/Documents/Github/romeHousePrices/Data/listingPages_", time, ".RData"))
start = Sys.time()
d = lapply(listingPages, getPropertyDetails)
finalData = rbindlist(d, fill = TRUE)
Sys.time() - start
nrow(finalData)
save(d, file = paste0("~/Documents/Github/romeHousePrices/Data/detailData_", time, ".RData"))

## Small sample, Immobiliare Affitto
listingPages = getPropertyUrlsImmobiliare(numPages = 100000, type = "affitto")
save(listingPages, file = paste0("~/Documents/Github/romeHousePrices/Data/listingPagesImbAff_", time, ".RData"))
start = Sys.time()
d = lapply(listingPages, getPropertyDetailsImmobiliare)
finalData = rbindlist(d, fill = TRUE)
Sys.time() - start
nrow(finalData)
save(d, file = paste0(workingDir, "/Data/detailImbAff_", time, ".RData"))