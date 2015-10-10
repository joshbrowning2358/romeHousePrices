library(romeHousePrices)
library(neuralnet)
library(nnet)
library(randomForest)
library(rpart)
library(e1071)
assignDirectory()

address = fread(paste0(workingDir, "/Data/addressDatabase.csv"))
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
model = rpart(CAP ~ latitude + longitude, data = address,
              control = rpart.control(minsplit = 1, cp = .000001))
model = svm(x = address[, c("latitude", "longitude"), with = FALSE],
            y = factor(address[, CAP]), kernel = "radial")
mean(predict(model, type = "class") == address[, CAP])
table(predict(model, type = "class"), address[, CAP])


res = 100
grid = expand.grid(latitude  = seq(41.87, 41.89, length.out = res),
                   longitude = seq(12.495, 12.525, length.out = res))
grid$CAP = predict(model, newdata = grid)

p = ggmap::get_map(location=c(12.50866, 41.88001), zoom=15)
p = ggmap::ggmap(p)
p + geom_tile(data = grid, aes(x = longitude, y = latitude,
                               color = CAP == "00183"), alpha = .3) +
    geom_point(data = address, aes(x = longitude, y = latitude,
                                   color = CAP == "00183"), size = 2)

p = ggmap::get_map(location=c(12.50866, 41.88001), zoom=15)
p = ggmap::ggmap(p)
p + geom_point(data = address, aes(x = longitude, y = latitude,
                                   color = CAP == "00183"), size = 4)
