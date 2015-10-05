##' Clean Immobiliare data
##' 
##' This function cleans up the Immobiliare data by standardizing columns, 
##' converting variables to appropriate formats, etc.
##' 
##' @param data The Immobiliare data.table
##'   
##' @return The same object as passed, but after some data cleaning.
##' 
##' @export
##'

# library(data.table)
# data = read.csv("~/../Dropbox/romeHouseData/Data/detail_ImbVend_2015.10.04.08.49.53.csv",
#                 stringsAsFactors = FALSE)
# data = data.table(data)

cleanImb = function(data){
    ## Clean up names/Remove accented a
    setnames(data, grep("Terreno.propriet", colnames(data), value = TRUE),
             "Terreno.proprieta")
    setnames(data, grep("Tipo.propriet", colnames(data), value = TRUE),
             "Tipo.proprieta")
    setnames(data, "A.reddito", "Areddito")
    
    data[, indirizzio := tolower(as.character(indirizzio))]
    data[indirizzio == "roma", indirizzio := NA]
    data[, indirizzio := gsub("..roma$", " roma", indirizzio)]
    data[, zona := gsub("zona: ", "", tolower(zona))]
    data[, quartiere := gsub("quartiere: ", "", tolower(quartiere))]
    data[, description := as.character(description)]
    data[, url := as.character(url)]
    data[, Data.annuncio := as.Date(as.character(Data.annuncio),
                                    format = "%d/%m/%Y")]
    data[, Tipo.Contratto := as.character(Tipo.Contratto)]
    data[, Tipo.Contratto := substr(Tipo.Contratto, 1, nchar(Tipo.Contratto)-1)]
    data[Piano == "piano terra", Piano := 0]
    data[Piano == "ultimo", Piano := Totale.Piani]
    data[Piano == ">10", Piano := ifelse(as.numeric(Totale.Piani) < 10,
                                         ## Not top floor, as we may create a
                                         ## variable piano == total.piani
                                         as.numeric(Totale.Piani) - 1,
                                         (as.numeric(Totale.Piani) + 10)/2)]
    ## Is this logic right/reasonable???
    data[Piano %in% c("interrato", "seminterrato"), Piano := 0]
    data[Piano == "piano rialzato", Piano := as.numeric(Totale.Piani) / 2]
    data[Piano == "su piu' livelli", Piano := as.numeric(Totale.Piani) / 2]
    for(name in c("superficie", "locali", "bagni", "prezzio", "pictureCount",
                  "Piano", "Totale.Piani", "Posti.Auto")){
        data[, c(name) := as.numeric(get(name))]
    }
    for(name in c("Libero", "Balcone", "Ascensore", "Cantina", "Terrazzo",
                  "Condizionatore", "Areddito")){
        data[, c(name) := as.character(get(name))]
        data[, c(name) := grepl("^S", get(name))]
    }
    data[, Classe.energetica := gsub("kWh.*", "", Classe.energetica)]
    data[, Classe.energetica := gsub(",", "\\.", Classe.energetica)]
    if(any(!is.na(data$Spese.condominiali) &
           !grepl("mensili", data$Spese.condominiali)))
        stop("A spese condominiali is not listed mensili!  Check data...")
    data[, Spese.condominiali :=
             as.numeric(gsub("[^0-9\\.]", "", Spese.condominiali))]
    data[, Tipo.proprieta := gsub("ropriet.*", "roprieta", Tipo.proprieta)]
    data[, Box := gsub("s.*, ", "", Box)]
        if(any(!is.na(data$Spese.aggiuntive) &
           !grepl("mensili", data$Spese.aggiuntive)))
        stop("A spese aggiuntive is not listed mensili!  Check data...")
    data[, Spese.aggiuntive :=
             as.numeric(gsub("[^0-9\\.]", "", Spese.aggiuntive))]
    data[, Terreno.proprieta := gsub("[^0-9].*", "", Terreno.proprieta)]
    data[, Terreno.proprieta := as.numeric(Terreno.proprieta)]
}