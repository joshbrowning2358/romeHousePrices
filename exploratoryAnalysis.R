load("~/GitHub/romeHousePrices//Data/detailDataMioAff_2015.09.20.17.23.27.RData")

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

p = get_map(location=c(12.5, 41.91), zoom=12)
p = ggmap(p)
p + geom_point(data = finalData, aes(x = longitude, y = latitude,
                                   color = prezzio))
