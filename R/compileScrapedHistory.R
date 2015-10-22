##' Compile scraped history
##' 
##' This function takes the scraped history files for average house prices by 
##' CAP from immobiliare and creates one main data file for plotting.
##' 
##' @param dir The directory where all the individual files are stored.
##'   
##' @return No value is returned, but a file called allHistoricalData.csv is
##'   created in dir.
##' 
##' @export
##' 

compileScrapedHistory = function(dir = paste0(savingDir, "historical/data_by_cap/scraped_data/")){
    files = list.files(dir, pattern = "^samplehousingprice")
    allData = lapply(files, function(file){
        date = gsub("samplehousingpricedata_|.csv", "", file)
        if(grepl("-", date)){
            date = as.Date(date, format = "%Y-%m-%d")
        } else {
            date = as.Date(date, format = "%d.%m.%Y")
        }
        data = fread(paste0(dir, file))
        data[, date := date]
        return(data)
    })
    allData = do.call("rbind", allData)
    allData[, V1 := NULL]
    write.csv(allData, file = paste0(dir, "allHistoricalData.csv"),
              row.names = FALSE)
}