library(data.table)
library(ggplot2)
library(glmnet)
library(sqldf)
library(reshape2)

load("~/GitHub/romeHousePrices/Data/detail_Mio_2015.09.23.06.45.02.RData")

# finalData = finalData[(Aria.condizionata), ]
finalData[, roundSuper := round(superficie/25) * 25]
ggplot(finalData, aes(x = prezzio, fill = factor(roundSuper))) + geom_bar()
ggplot(finalData, aes(x = prezzio, fill = factor(roundSuper))) + geom_bar() +
    xlim(c(0,2001))
ggplot(finalData, aes(x = prezzio, fill = factor(roundSuper))) +
    geom_bar(position = "fill") +
    xlim(c(0,2001))

# finalData = finalData[!(agency), ]
# finalData = finalData[zona %in% c("ardeatino, colombo, garbatella",
#                                   "marconi, ostiense, san paolo",
#                                   "trastevere, aventino, testaccio"), ]
# finalData = finalData[locali > 3, ]

ggplot(finalData, aes(x = prezzio, fill = factor(roundSuper))) + geom_bar()
ggplot(finalData, aes(x = prezzio, fill = factor(roundSuper))) + geom_bar() +
    xlim(c(0,2001))

p = ggmap::get_map(location=c(12.5, 41.91), zoom=12)
p = ggmap::ggmap(p)
p + geom_point(data = finalData, aes(x = longitude, y = latitude,
                                   color = prezzio), size = 4) +
    scale_color_continuous(trans = "log10")
load("~/GitHub/romeHousePrices/Data/metroData.RData")
p + geom_point(data = finalData, aes(x = longitude, y = latitude,
                                   color = prezzio), size = 4) +
    scale_color_continuous(trans = "log10") +
    geom_point(data = metro, aes(x = longitude, y = latitude), size = 4,
               color = "red")

d = read.csv.sql(file = "C:/Users/rockc_000/Documents/GitHub/romeHousePrices/Data/detail_ImbVend_2015.09.23.06.03.15.csv",
                 sql = "select
                            superficie, locali, bagni, prezzio, indirizzio,
                            zona, quartiere, pictureCount
                        from
                            file",
                 sep = ",", filter = 'tr.exe -d ^" ')
d = read.csv(file = "~/GitHub/romeHousePrices/Data/detail_ImbVend_2015.09.23.06.03.15.csv")
d = d[, c("superficie", "locali", "bagni", "prezzio", "indirizzio", "zona",
          "quartiere", "pictureCount", "Riscaldamento", "Condizionatore",
          "Totale.Piani", "Ascensore", "Spese.condominiali")]
d$superficie = as.numeric(as.character(d$superficie))
d$locali = as.numeric(as.character(d$locali))
d$bagni = as.numeric(as.character(d$bagni))
d$prezzio = as.numeric(as.character(d$prezzio))
d$pictureCount = as.numeric(as.character(d$pictureCount))
d = d[is.na(d$bagni) | d$bagni < 10, ]
d = d[is.na(d$superficie) | d$superficie < 2000, ]
d = d[is.na(d$locali) | d$locali < 20, ]
d = d[d$prezzio <= 5000, ]
toPlot = melt(d, id.vars = "prezzio",
              measure.vars = c("superficie", "locali", "bagni", "pictureCount"))
ggplot(toPlot, aes(x = value, y = prezzio)) + geom_point() +
    facet_wrap( ~ variable, scale = "free") + geom_smooth()
toPlot = melt(d, id.vars = "prezzio",
              measure.vars = c("zona", "quartiere", "Riscaldamento",
                               "Condizionatore", "Totale.Piani", "Ascensore"))
ggplot(toPlot, aes(x = value, y = prezzio)) + geom_boxplot() +
    facet_wrap( ~ variable, scale = "free")
