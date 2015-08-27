time = gsub("(-|:| )", "\\.", Sys.time())
if(Sys.info()[4] == "JOSH_LAPTOP"){
    workingDir = "~/GitHub/romeHousePrices/"
} else if(Sys.info()[4] == "jb"){
    workingDir = "~/Documents/Github/romeHousePrices"
} else {
    stop("No directory for current user!")
}
files = dir(path = paste0(workingDir, "/R"), full.names = TRUE)
sapply(files, source)

## Small sample
listingPages = getPropertyUrls(numPages = 10)
start = Sys.time()
d = lapply(listingPages, getPropertyDetails)
finalData = rbindlist(d, fill = TRUE)
Sys.time() - start
nrow(finalData)
save(d, file = paste0(workingDir, "/Data/venditaDetailData_", time, ".RData"))

## Small sample
listingPages = getPropertyUrls(numPages = 10, type = "affitto")
start = Sys.time()
d = lapply(listingPages, getPropertyDetails)
finalData = rbindlist(d, fill = TRUE)
Sys.time() - start
nrow(finalData)
save(d, file = paste0(workingDir, "/Data/affittoDetailData_", time, ".RData"))

## Full dataset
listingPages = getPropertyUrls(numPages = 2718)
save(listingPages, file = paste0("~/Documents/Github/romeHousePrices/Data/listingPages_", time, ".RData"))
start = Sys.time()
d = lapply(listingPages, getPropertyDetails)
finalData = rbindlist(d, fill = TRUE)
Sys.time() - start
nrow(finalData)
save(d, file = paste0("~/Documents/Github/romeHousePrices/Data/detailData_", time, ".RData"))