##' Clean Mio Affitto data
##' 
##' This function cleans up the Mio Affitto data by standardizing columns, 
##' converting variables to appropriate formats, etc.
##' 
##' @param data The Mio Affitto data.table
##'   
##' @return The same object as passed, but after some data cleaning.
##'
##' @export
##' 

# library(data.table)
# data = read.csv("~/../Dropbox/romeHouseData/Data/detail_Mio_2015.10.03.05.47.59.csv")
# data = data.table(data)

cleanMioAffitto = function(data){
    ## Convert characters to numeric
    data[, superficie := as.numeric(superficie)]
    data[, locali := as.numeric(locali)]
    data[, bagni := as.numeric(bagni)]
    data[, prezzo := as.numeric(prezzo)]
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
    data[, pictureCount := as.numeric(pictureCount)]
    setnames(data, grep("^Antichit", colnames(data), value = TRUE), "Antichita")
    data[, Antichita := gsub("^Pi.*", "Piu di 30 anni", Antichita)]
    ## May be slightly off here if more than one == "TRUE.  But, that's really
    ## an underlying problem with the data itself....
    data[, Gas := ifelse(Gas.autonomo == "TRUE", "autonomo",
                  ifelse(Gas.centralizzato == "TRUE", "centralizato", "nessuno"))]
    data[, c("Gas.autonomo", "Gas.centralizzato", "Gas.nessuno") := NULL]
    disCols = grep("^Disponibilit", colnames(data), value = TRUE)
    setnames(data, disCols, gsub("Disponibilit.", "Disponibilita", disCols))
    data[, Disponibilita := ifelse(Disponibilita.Immediata == "TRUE", "Immediata",
                            ifelse(Disponibilita.Non.immediata == "TRUE",
                                   "Non.immediata", NA))]
    data[, c("Disponibilita.Immediata", "Disponibilita.Non.immediata") := NULL]
    data[, Orientamento := ifelse(Orientamento.esposizione.su.tutti.i.lati == "TRUE", 4,
                           ifelse(Orientamento.tripla == "TRUE", 3,
                           ifelse(Orientamento.doppia == "TRUE", 3,
                           ifelse(Orientamento.unica == "TRUE", 1, NA))))]
    data[, c("Orientamento.esposizione.su.tutti.i.lati", "Orientamento.tripla",
             "Orientamento.doppia", "Orientamento.unica") := NULL]
    data[, Certificato.energetico := ifelse(Certificato.energetico.tipo.8 == "TRUE", "8",
                                     ifelse(Certificato.energetico.tipo.7 == "TRUE", "7",
                                     ifelse(Certificato.energetico.tipo.6 == "TRUE", "6",
                                     ifelse(Certificato.energetico.tipo.5 == "TRUE", "5",
                                     ifelse(Certificato.energetico.tipo.4 == "TRUE", "4",
                                     ifelse(Certificato.energetico.tipo.3 == "TRUE", "3",
                                     ifelse(Certificato.energetico.tipo.2 == "TRUE", "2",
                                     ifelse(Certificato.energetico.tipo.1 == "TRUE", "1",
                                     ifelse(Certificato.energetico.tipo.F == "TRUE", "F",
                                     ifelse(Certificato.energetico.tipo.G == "TRUE", "G",
                                            NA))))))))))]
    data[, c("Certificato.energetico.tipo.8", "Certificato.energetico.tipo.7",
           "Certificato.energetico.tipo.6", "Certificato.energetico.tipo.5",
           "Certificato.energetico.tipo.4", "Certificato.energetico.tipo.3",
           "Certificato.energetico.tipo.2", "Certificato.energetico.tipo.1",
           "Certificato.energetico.tipo.F", "Certificato.energetico.tipo.G") := NULL]
    data[, Armadi := as.numeric(Armadi)]
    setnames(data, grep("^Plaza.de.*rking.opcional", colnames(data), value = TRUE),
             "Plaza.de.parking.opcional")
    for(name in c("Ascensore", "Aria.condizionata", "Portiere",
                  "Ripostiglio.incluso", "Terrazza", "Balcone", "Giardino",
                  "Arredato", "Posto.auto.incluso", "Accesso.per.disabili",
                  "Forno", "Plaza.de.parking.opcional", "Attivazione.utenze",
                  "Telefono", "Sedie.e.tavoli", "Lavatrice", "Frigorifero",
                  "Lavastoviglie", "Utensili.da.cucina", "Zona.infantile",
                  "Animali.permessi", "Ventilatore", "TV", "Piscina",
                  "Microonde", "Videosorveglianza", "Accesso.a.internet",
                  "Palestra", "Stufa")){
        data[, c(name) := ifelse(is.na(get(name)), FALSE,
                          ifelse(get(name) == "TRUE", TRUE, FALSE))]
    }

    return(data)
}