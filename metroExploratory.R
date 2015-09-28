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
address = addressToCoord(paste0(metro$stopName, "metro loc: Rome"))
metro[, longitude := address$Longitude]
metro[, latitude := address$Latitude]
save(metro, file = "~/GitHub/romeHousePrices/Data/metroData.RData")
