##' Get Metro Data
##' 
##' This function pulls the locations of the metro stops using the names of the metro stations as provided by the ATAC website.
##' 
##' @param file The file location where the metro data should be saved.
##' 
##' @return No file is returned, but the metro station locations are saved to the provided directory.
##' 
##' @export
##' 

getMetroData = function(file = "~/../Dropbox/romeHouseData/"){

    metroA = c('Battistini', 'Cornelia', 'Baldo degli Ubaldi', 'Valle Aurelia',
               'Cipro', 'Ottaviano - San Pietro - Musei Vaticani', 'Lepanto',
               'Flaminio - Piazza del Popolo', 'Spagna',
               'Barberini - Fontana di Trevi', 'Repubblica - Teatro dellOpera',
               'Termini', 'Vittorio Emanuele', 'Manzoni - Museo della Liberazione',
               'San Giovanni', 'Re di Roma', 'Ponte Lungo', 'Furio Camillo',
               'Colli Albani', 'Arco di Travertino', 'Porta Furba - Quadraro',
               'Numidio Quadrato', 'Lucio Sestio', 'Giulio Agricola', 'Subaugusta',
               'Cinecitta', 'Anagnina')
    
    metroB = c('Rebibbia', 'Ponte Mammolo', 'S.M. del Soccorso', 'Pietralata',
               'Monti Tiburtini', 'Quintiliani', 'Tiburtina F.S.', 'Jonio', 'Conca dOro',
               'Libia', 'SantAgnese - Annibaliano', 'Bologna', 'Policlinico',
               'Castro Pretorio', 'Termini', 'Cavour', 'Colosseo', 'Circo Massimo',
               'Piramide', 'Garbatella', 'Basilica S. Paolo', 'Marconi', 'EUR Magliana',
               'EUR Palasport', 'EUR Fermi', 'Laurentina')
    metro = data.table(stopName = c(metroA, metroB))
    address = sapply(paste0(metro$stopName, " metro Roma"), addressToCoord)
    metro[, longitude := do.call("c", address[1, ])]
    metro[, latitude := do.call("c", address[2, ])]
    save(metro, file = file)
}