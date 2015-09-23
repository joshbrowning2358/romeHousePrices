library(data.table)
library(ggplot2)
library(glmnet)

load("~/GitHub/romeHousePrices/Data/detail_Mio_2015.09.23.06.45.02.RData")
load("~/GitHub/romeHousePrices/Data/detail_ImbAff_2015.08.27.05.58.13.RData")

finalData = finalData[(Aria.condizionata), ]
finalData[, roundSuper := round(superficie/25) * 25]
ggplot(finalData, aes(x = prezzio, fill = factor(roundSuper))) + geom_bar()
ggplot(finalData, aes(x = prezzio, fill = factor(roundSuper))) + geom_bar() +
    xlim(c(0,2001))
ggplot(finalData, aes(x = prezzio, fill = factor(roundSuper))) +
    geom_bar(position = "fill") +
    xlim(c(0,2001))

finalData = finalData[!(agency), ]
finalData = finalData[zona %in% c("ardeatino, colombo, garbatella",
                                  "marconi, ostiense, san paolo",
                                  "trastevere, aventino, testaccio"), ]
finalData = finalData[locali > 3, ]

ggplot(finalData, aes(x = prezzio, fill = factor(roundSuper))) + geom_bar()
ggplot(finalData, aes(x = prezzio, fill = factor(roundSuper))) + geom_bar() +
    xlim(c(0,2001))

p = ggmap::get_map(location=c(12.5, 41.91), zoom=12)
p = ggmap::ggmap(p)
p + geom_point(data = finalData, aes(x = longitude, y = latitude,
                                   color = prezzio))

load("~/GitHub/romeHousePrices/Data/detailDataMioAff_2015.09.20.17.23.27.RData")
