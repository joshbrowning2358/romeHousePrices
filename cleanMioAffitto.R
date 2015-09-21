library(data.table)

if(Sys.info()[4] == "joshua-Ubuntu-Linux"){
    dir = "~/Documents/GitHub/romeHousePrices/"
} else {
    dir = "~/GitHub/romeHousePrices/"
}

dataFiles = list.files(paste0(dir, "/Data"))
mioFiles = dataFiles[grepl("^detailDataMio.*.RData", dataFiles)]
mioDates = as.POSIXct(gsub("[^0-9]", "", mioFiles), format = "%Y%m%d%H%M%S")
mioFile = mioFiles[mioDates == max(mioDates)]
load(paste0(dir, "/Data/", mioFile))

finalData[, superficie := as.numeric(superficie)]
finalData[, locali := as.numeric(locali)]
finalData[, bagni := as.numeric(bagni)]
finalData[, prezzio := as.numeric(prezzio)]
finalData[, indirizzio := tolower(indirizzio)]
finalData[grep("^l' inserzionista ha", indirizzio),
          indirizzio := NA]
finalData[, zona := tolower(zona)]
finalData[grep("^l' inserzionista ha deciso di occultare", zona),
          zona := NA]
finalData[grepl(":", zona), zona := NA]
finalData[, quartiere := tolower(quartiere)]
finalData[grep("^l' inserzionista ha deciso di occultare", quartiere),
          quartiere := NA]
finalData[grepl(":", quartiere), quartiere := NA]
finalData[, quartiere := gsub("/.*", "", quartiere)]

finalData[, Aria.condizionata := ifelse(is.na(Aria.condizionata), FALSE,
                                 ifelse(Aria.condizionata == "TRUE", TRUE, FALSE))]

save(finalData, file = paste0(dir, "/Data/", mioFile))
