library(romeHousePrices)
library(scales)
library(caret)

assignDirectory()

load(paste0(savingDir, "detail_ImbVend_2015.10.05.05.28.53_cleaned.RData"))

## Variogram
library(gstat)
library(sp)

d = d[!is.na(latitude), ]
d = d[latitude <= 41.9+.5 & latitude >= 41.9-.5 &
      longitude <= 12.5+.5 & longitude >= 12.5-.5, ]
d = d[!is.na(prezzo), ]
d = d[superficie >= 10, ]
d = d[superficie <= 1000, ]
d = d[prezzo / superficie >= 100, ]

# coordinates(d) = c("latitude", "longitude")
# v = variogram(prezzo ~ 1, data = d, cloud = TRUE)
# ggplot(v, aes(x = dist, y = gamma)) +
#     geom_smooth()
# 
# v = variogram(I(prezzo/superficie) ~ 1, data = d, cloud = TRUE)
# ggplot(v, aes(x = dist, y = gamma)) +
#     geom_smooth()
# 

ggplot(d, aes(x = longitude, y = latitude, color = prezzo / superficie)) +
    geom_point() + scale_color_continuous(trans = "log10")

fit = lm(I(prezzo / superficie) ~ superficie + locali + bagni + CAP +
             latitude + longitude, data = d)
summary(fit)
fit = lm(I(prezzo / superficie) ~ CAP, data = d)
summary(fit) # explains 36% of variance
fit = lm(I(prezzo / superficie) ~ 1, data = d)
fit2 = step(object = fit, scope = I(prezzo / superficie) ~ CAP + bagni + locali,
           direction = "both", data = d)

d[, longitudeGroup := findInterval(longitude,
                                   quantile(longitude, probs = 0:10/10))]
d[, latitudeGroup := findInterval(latitude,
                                   quantile(latitude, probs = 0:10/10))]
ggplot(d, aes(x = latitude, y = prezzo / superficie,
              group = longitudeGroup, color = longitudeGroup)) +
    geom_smooth(se = FALSE)
ggplot(d, aes(x = longitude, y = prezzo / superficie,
              group = latitudeGroup, color = latitudeGroup)) +
    geom_smooth(se = FALSE)


d = d[!is.na(locali) & !is.na(bagni), ]
d[, prezzoXsuperficie := prezzo / superficie]

fitControl <- trainControl(## 10-fold CV
                           method = "repeatedcv",
                           number = 10,
                           ## repeated ten times
                           repeats = 10)
fit.lm = train(prezzoXsuperficie ~ locali + bagni + zona + quartiere + CAP +
          latitude + longitude, data = d[1:1000, ], method = "lm",
          trControl = fitControl)
fit.lm
fit.gbm = train(prezzoXsuperficie ~ locali + bagni + zona + quartiere + CAP +
          latitude + longitude, data = d[1:1000, ], method = "gbm",
          trControl = fitControl)
fit.gbm
