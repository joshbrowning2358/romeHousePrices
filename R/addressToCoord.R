##' Address to Coordinate
##' 
##' This function maps an address (text) to the latitude and longitude
##' coordinates.
##' 
##' @param address A text string containing the address.
##' 
##' @return A vector of longitude and latitude values.
##' 

addressToCoord = function(address){
    ggmap::geocode(address, source = "google")
}