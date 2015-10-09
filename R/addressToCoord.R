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
##' @export
##' 

addressToCoord = function(address, source = "google"){
    if(is.na(address)){
        return(data.frame(longitude = NA, latitude = NA, CAP = NA))
    }
    out = try(ggmap::geocode(address, source = source, output = "more"))
    if(is(out, "try-error") | is.na(out["lon"])){
        return(data.frame(longitude = NA, latitude = NA, CAP = NA))
    }
    out = try({
        if(!"postal_code" %in% colnames(out)){
            out$postal_code = NA_character_
        }
        out = out[, c("lon", "lat", "postal_code")]
        colnames(out) = c("longitude", "latitude", "CAP")
        out
    })
    if(is(out, "try-error")){
        return(data.frame(longitude = NA, latitude = NA, CAP = NA))
    }
    return(out)
}