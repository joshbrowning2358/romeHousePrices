##' Clean Immobiliare data
##' 
##' This function cleans up the Immobiliare data by standardizing columns, 
##' converting variables to appropriate formats, etc.
##' 
##' @param data The Immobiliare data.table
##'   
##' @return The same object as passed, but after some data cleaning.
##' 

cleanImb = function(data){
    data[, superficie := as.numeric(superficie)]
    data[, locali := as.numeric(locali)]
    data[, bagni := as.numeric(bagni)]
    data[, prezzio := as.numeric(prezzio)]
    data[, Piano := as.numeric(Piano)]
    if(any(!is.na(data$Spese.condominiali) &
           !grepl("mensili", data$Spese.condominiali)))
        stop("A spese condominiali is not listed mensili!  Check data...")
    data[, Spese.condominiali :=
             as.numeric(gsub("[^0-9\\.]", "", Spese.condominiali))]
    if(any(!is.na(data$Spese.aggiuntive) &
           !grepl("mensili", data$Spese.aggiuntive)))
        stop("A spese aggiuntive is not listed mensili!  Check data...")
    data[, Spese.aggiuntive :=
             as.numeric(gsub("[^0-9\\.]", "", Spese.aggiuntive))]
    data[, Totale.Piani := as.numeric(Totale.Piani)]
    data[, pictureCount := as.numeric(pictureCount)]
    
    ## Remove accented a
    setnames(data, grep("Terreno.propriet", colnames(data), value = TRUE),
             "Terreno.proprieta")
    data[, Terreno.proprieta := as.numeric(gsub("[^0-9\\.]", "", Terreno.proprieta))]
    setnames(data, grep("Tipo.propriet", colnames(data), value = TRUE),
             "Tipo.proprieta")
    
    # Looking for Si (with accented i)
    data[, Libero := grepl("^S", Libero)]
    data[, Terrazzo := grepl("^S", Terrazzo)]
    data[, Balcone := grepl("^S", Balcone)]
    data[, Ascensore := grepl("^S", Ascensore)]
    data[, Condizionatore := grepl("^S", Condizionatore)]
    
    data[, indirizzio := tolower(indirizzio)]
}