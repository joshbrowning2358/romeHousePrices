library(romeHousePrices)
library(neuralnet)
library(nnet)
library(randomForest)
assignDirectory()

address = fread(paste0(savingDir, "/addressDatabase.csv"))
address = address[latitude >= 41.6 & latitude <= 42.2 &
                  longitude >= 12.2 & longitude <= 12.8 &
                  !is.na(CAP), ]

p = ggmap::get_map(location=c(12.5, 41.91), zoom=10)
p = ggmap::ggmap(p)
p + geom_point(data = address, aes(x = longitude, y = latitude,
                                   color = factor(CAP)))

model = neuralnet(CAP ~ latitude + longitude, hidden = c(20, 3),
                  data = address)
model = nnet(x = address[, c("latitude", "longitude"), with = FALSE],
             y = factor(address[, CAP]), size = 20)
model = randomForest(x = address[, c("latitude", "longitude"), with = FALSE],
                     y = factor(address[, CAP]), mtry = 2, ntree = 10000) 
mean(predict(model) == address[, CAP])
table(predict(model), address[, CAP])

res = 100
grid = expand.grid(latitude  = seq(41.6, 42.2, length.out = res),
                   longitude = seq(12.2, 12.8, length.out = res))
grid$CAP = predict(model, newdata = grid)
