library(data.table)
library(ggplot2)
library(glmnet)
library(sqldf)

load("~/GitHub/romeHousePrices/Data/detail_Mio_2015.09.23.06.45.02.RData")

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

d = read.csv.sql(file = "~/GitHub/romeHousePrices/Data/detail_ImbVend_2015.09.23.06.03.15.csv",
                 sql = "select * from file where rownum <= 10")
for(i in 1:15*1000){
    d = read.csv(file = paste0("~/GitHub/romeHousePrices/Data/detail_ImbVend_",
                               i, "_2015.09.23.06.03.15.RData"))
    d$X = NULL
    d$Superficie = NULL
    d$Locali = NULL
    d$Bagni = NULL
    write.csv(d, file = paste0("~/GitHub/romeHousePrices/Data/detail_ImbVend_",
                               i, "_2015.09.23.06.03.15.csv"), row.names = FALSE)
}

