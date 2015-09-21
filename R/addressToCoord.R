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
        return(c(NA, NA))
    out = try(ggmap::geocode(address, source = source))
    if(is(out, "try-error"))
        return(c(NA, NA))
    return(out)
}