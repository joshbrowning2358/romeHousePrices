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
currentCAP = "00181"
center = address[CAP == currentCAP, c(mean(longitude), mean(latitude))]
p = ggmap::get_map(location=center, zoom=14)
p = ggmap::ggmap(p)
p + geom_point(data = address, aes(x = longitude, y = latitude,
                                   color = CAP == currentCAP), size = 4)

capPoints = address[CAP == currentCAP, ]
coordinates(capPoints) = c("longitude", "latitude")
region = mcp(xy = capPoints[, "CAP"], percent = 100)
plot(region)
inPolygon = mapply(point.in.polygon, point.x = address[, longitude],
                   point.y = address[, latitude],
                   MoreArgs = list(
                        pol.x = region@polygons[[1]]@Polygons[[1]]@coords[, "longitude"],
                        pol.y = region@polygons[[1]]@Polygons[[1]]@coords[, "latitude"]))
table(inPolygon)
dim(capPoints)
badPoints = address[inPolygon > 0 & CAP != currentCAP, ]


capPoints = address[CAP == currentCAP, c("latitude", "longitude"), with = FALSE]
capPoints = unique(capPoints)
hull = capPoints[, alphahull::ahull(x = longitude, y = latitude, alpha = 0.01)]
plot(hull)
# polygon = data.frame(hull$arcs[, c("c1", "c2")])
polygon = data.frame(hull$ashape.obj$edges)
## Reorder the polygon.  Index corresponds to the point index, and the edges are
## written arbitrarily (i.e. not counterclockwise or following any particular 
## order).  Also, two edges can start at the same point (i.e. ind1 doesn't have
## to be the first index in clockwise order).
newPolygon = polygon
for(i in 1:(nrow(polygon)-1)){
    index1 = polygon$ind1 == newPolygon[i, "ind2"] &
        polygon$ind2 != newPolygon[i, "ind1"]
    index2 = polygon$ind2 == newPolygon[i, "ind2"] &
        polygon$ind1 != newPolygon[i, "ind1"]
    if(any(index1)){
        newPolygon[i+1, ] = polygon[index1, ]
    } else {
        newPolygon[i+1, ] = polygon[index2, c("ind2", "ind1", "x2", "y2", "x1",
                                              "y1", "mx2", "my2", "mx1", "my1",
                                              "bp2", "bp1")]
    }
}
polygon = newPolygon
coordinates(polygon) = c("x1", "y2")
polygon = Polygon(coords = polygon)
polygon = Polygons(list(polygon), 1)
polygon = SpatialPolygons(list(polygon))
plot(polygon)
inPolygon = mapply(point.in.polygon, point.x = address[, longitude],
                   point.y = address[, latitude],
                   MoreArgs = list(
                        pol.x = region@polygons[[1]]@Polygons[[1]]@coords[, "longitude"],
                        pol.y = region@polygons[[1]]@Polygons[[1]]@coords[, "latitude"]))
table(inPolygon)
dim(capPoints)
badPoints = address[inPolygon > 0 & CAP != currentCAP, ]


stop("Need to correct for points inside CAP that shouldn't be!")
name = paste0("shapefile_", currentCAP)
setwd(paste0(savingDir, "/CAP/"))
writeOGR(obj = region, dsn = paste0(name, ".kml"), layer = name, driver = "KML")
