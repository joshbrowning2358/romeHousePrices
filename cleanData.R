library(data.table)

if(Sys.info()[4] == "joshua-Ubuntu-Linux"){
    dir = "~/../Dropbox/romeHouseData/Data/"
} else {
    dir = "~/../Dropbox/romeHouseData/Data/"
}

dataFiles = list.files(dir, pattern = ".csv")
mioFiles = dataFiles[grepl("^detail_Mio.*.csv", dataFiles)]
for(file in mioFiles){
    d = read.csv(paste0(dir, file))
    d = cleanMioAffitto(data.table(d))
    write.csv(d, file = paste0(dir, file))
}

imbFiles = dataFiles[grepl("^detail_Imb.*.csv", dataFiles)]
for(file in imbFiles){
    d = read.csv(paste0(dir, file))
    d = cleanImb(data.table(d))
    write.csv(d, file = paste0(dir, file))
}