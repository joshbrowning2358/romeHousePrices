library(data.table)

if(Sys.info()[4] == "joshua-Ubuntu-Linux"){
    dir = "~/Documents/Github/romeHousePrices/"
} else {
    dir = "~/GitHub/romeHousePrices/"
}

dataFiles = list.files(paste0(dir, "Data"))
mioFiles = dataFiles[grepl("^detail_Mio.*.RData", dataFiles)]
for(file in mioFiles){
    load(paste0(dir, "Data/", file))
    finalData = cleanMioAffitto(finalData)
    save(finalData, file = paste0(dir, "Data/", file))
}

imbFiles = dataFiles[grepl("^detail_Imb.*.RData", dataFiles)]
for(file in imbFiles){
    load(paste0(dir, "Data/", file))
    finalData = cleanImb(finalData)
    save(finalData, file = paste0(dir, "Data/", file))
}