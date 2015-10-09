library(romeHousePrices)
assignDirectory()

files = dir(paste0(savingDir, "/historical/data_by_cap/scraped_data"),
            full.names = TRUE)
dataByStreet = lapply(files, function(file){
    d = fread(file)
    d[, V1 := NULL]
})
lapply(dataByStreet, colnames)
dataByStreet = do.call("rbind", dataByStreet)
