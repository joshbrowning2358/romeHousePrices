library(romeHousePrices)
library(adehabitatHR)
library(maptools)

assignDirectory()

address = fread(paste0(workingDir, "/Data/addressDatabase.csv"))
address = address[latitude >= 41.6 & latitude <= 42.2 &
                  longitude >= 12.2 & longitude <= 12.8 &
                  !is.na(CAP), ]

p = ggmap::get_map(location=c(12.5, 41.91), zoom=10)
p = ggmap::ggmap(p)
p + geom_point(data = address, aes(x = longitude, y = latitude,
                                   color = factor(CAP)))

p = ggmap::get_map(location=c(12.5, 41.91), zoom=14)
p = ggmap::ggmap(p)
p + geom_point(data = address, aes(x = longitude, y = latitude,
                                   color = factor(CAP)))

p = ggmap::get_map(location=c(12.50866, 41.88001), zoom=15)
p = ggmap::ggmap(p)
p + geom_point(data = address, aes(x = longitude, y = latitude,
                                   color = CAP == "00183"), size = 4)


## Estimate region with minimum convex polygon
capPoints = address[CAP == "00183", ]
coordinates(capPoints) = c("longitude", "latitude")
region = mcp(xy = capPoints[, "CAP"], percent = 100)
plot(region)
inPolygon = mapply(point.in.polygon, point.x = address[, longitude],
                   point.y = address[, latitude],
                   pol.x = region@polygons[[1]]@Polygons[[1]]@coords[, "longitude"],
                   pol.y = region@polygons[[1]]@Polygons[[1]]@coords[, "latitude"])
table(inPolygon)
## Should have more interior points...
name = paste0(savingDir, "/CAP/shapefile_", "00183")
writeOGR(obj = region, dsn = "shapefile_00183.kml", layer = "shapefile_00183",
         driver = "KML")
