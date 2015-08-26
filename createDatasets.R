time = gsub("(-|:| )", "\\.", Sys.time())
files = dir(path = "~/Documents/Github/romeHousePrices/R", full.names = TRUE)
sapply(files, source)

listingPages = getPropertyUrls(numPages = 2718)
save(listingPages, file = paste0("~/Documents/Github/romeHousePrices/Data/listingPages_", time, ".RData"))
d = lapply(listingPages, getPropertyDetails)
finalData = rbindlist(d, fill = TRUE)
