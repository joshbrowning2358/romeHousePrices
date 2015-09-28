##' Address to Coordinate
##' 
##' This function maps an address (text) to the latitude and longitude
##' coordinates.
##' 
##' @param address A text string containing the address.
##' @param source See ?ggmap::geocode
##' 
##' @return A vector of longitude and latitude values.
##' 

addressToCoord = function(address, source = "google"){
    if(is.na(address))
        return(data.frame(Longitude = NA, Latitude = NA))
    out = try(ggmap::geocode(address, source = source))
    if(is(out, "try-error"))
        return(data.frame(Longitude = NA, Latitude = NA))
    colnames(out) = c("Longitude", "Latitude")
    return(out)
}