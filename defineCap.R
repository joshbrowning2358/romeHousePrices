library(romeHousePrices)
library(adehabitatHR)
library(maptools)

assignDirectory()

address = fread(paste0(workingDir, "/Data/addressDatabase.csv"))
address = address[latitude >= 41.6 & latitude <= 42.2 &
                  longitude >= 12.2 & longitude <= 12.8 &
                  !is.na(CAP), ]

## Estimate region with alpha-hull
for(currentCAP in unique(address$CAP)){
    center = address[CAP == currentCAP, c(mean(longitude), mean(latitude))]
    p = ggmap::get_map(location=center, zoom=14)
    p = ggmap::ggmap(p)
    
    pointsInHull = 1
    alpha = 1
    while(pointsInHull > 0){
        capPoints = address[CAP == currentCAP, c("latitude", "longitude"), with = FALSE]
        capPoints = unique(capPoints)
        hull = capPoints[, alphahull::ahull(x = longitude, y = latitude, alpha = alpha)]
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
        coordinates(polygon) = c("x1", "y1")
        polygon = Polygon(coords = polygon)
        polygon = Polygons(list(polygon), 1)
        polygon = SpatialPolygons(list(polygon))
        coords = data.frame(polygon@polygons[[1]]@Polygons[[1]]@coords)
        print(p + geom_point(data = address, aes(x = longitude, y = latitude,
                                           color = CAP == currentCAP)) +
            geom_path(data = coords, aes(x = X1, y = X2))
        )
    
        inPolygon = mapply(point.in.polygon, point.x = address[, longitude],
                           point.y = address[, latitude],
                           MoreArgs = list(
                                pol.x = polygon@polygons[[1]]@Polygons[[1]]@coords[, 1],
                                pol.y = polygon@polygons[[1]]@Polygons[[1]]@coords[, 2]))
        badPoints = address[inPolygon > 0 & CAP != currentCAP, ]
        pointsInHull = nrow(badPoints)
        cat("With alpha =", alpha, "we have", pointsInHull, "bad points")
        alpha = alpha / 2
        readline("Next?")
    }
    
    name = paste0("shapefile_", currentCAP)
    setwd(paste0(savingDir, "/CAP/"))
    writeOGR(obj = region, dsn = paste0(name, ".kml"), layer = name, driver = "KML")
}