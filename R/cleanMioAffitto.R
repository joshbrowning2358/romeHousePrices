##' Clean Mio Affitto data
##' 
##' This function cleans up the Mio Affitto data by standardizing columns, 
##' converting variables to appropriate formats, etc.
##' 
##' @param data The Mio Affitto data.table
##'   
##' @return The same object as passed, but after some data cleaning.
##' 

cleanMioAffitto = function(data){
    ## Convert characters to numeric
    data[, superficie := as.numeric(superficie)]
    data[, locali := as.numeric(locali)]
    data[, bagni := as.numeric(bagni)]
    data[, prezzio := as.numeric(prezzio)]
    data[, indirizzio := tolower(indirizzio)]

    data[grep("^l' inserzionista ha", indirizzio),
              indirizzio := NA]
    data[, zona := tolower(zona)]
    data[grep("^l' inserzionista ha deciso di occultare", zona),
              zona := NA]
    data[grepl(":", zona), zona := NA]
    data[, quartiere := tolower(quartiere)]
    data[grep("^l' inserzionista ha deciso di occultare", quartiere),
              quartiere := NA]
    data[grepl(":", quartiere), quartiere := NA]
    data[, quartiere := gsub("/.*", "", quartiere)]
    
    data[, Aria.condizionata := ifelse(is.na(Aria.condizionata), FALSE,
                                     ifelse(Aria.condizionata == "TRUE",
                                            TRUE, FALSE))]
    
    return(data)
}