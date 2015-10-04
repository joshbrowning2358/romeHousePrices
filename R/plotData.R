##' Plot Data
##' 
##' This function takes one of the data.frames from the scraped sites and plots
##' it.
##' 
##' @param data The scraped dataset.
##' 
##' @return No object is returned, but a plot is generated.
##' 
##'

# library(ggplot2)
# library(ggmap)

plotData = function(data){
    ## Data Quality Checks
    if(!all(c("latitude", "longitude") %in% colnames(data)))
        stop("latitude and longitude must be present to plot!")
    
    toPlot = copy(finalData)
    toPlot[, prezzio := as.numeric(prezzio)]

    map <- get_map(location = c(lon = 12.5, lat = 41.9), zoom = 12, maptype = 'terrain')
    mapPlot <- ggmap(map) +
        geom_point(data=data, aes(x=longitude, y=latitude,
                                       color=as.numeric(prezzio)))
    print(mapPlot)
}