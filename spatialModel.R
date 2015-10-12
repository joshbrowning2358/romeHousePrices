library(romeHousePrices)

assignDirectory()

load(paste0(savingDir, "detail_Mio_2015.10.05.06.28.32_cleaned.RData"))
d

## Variogram
library(gstat)
library(sp)
d = d[!is.na(latitude), ]
d = d[latitude <= 41.9+.5 & latitude >= 41.9-.5 &
      longitude >= 12.5-.5 & longitude >= 12.5-.5, ]
coordinates(d) = c("latitude", "longitude")
v = variogram(prezzo ~ 1, data = d, cloud = TRUE)
ggplot(v, aes(x = dist, y = gamma)) +
    geom_smooth()

v = variogram(I(prezzo/superficie) ~ 1, data = d, cloud = TRUE)
ggplot(v, aes(x = dist, y = gamma)) +
    geom_smooth()
