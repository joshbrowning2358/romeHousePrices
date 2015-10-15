##' Pull Grid Addresses
##' 
##' @param width width
##' @param shift shift
##' @param resolution resolution
##' 
##' @return No object is returned, but the address file is updated.
##' 
##' @export
##' 

pullGridAddresses = function(width = .1, shift = 0, resolution = 3){
    assignDirectory()
    
    ## Data Quality checks
    lower = c(12.5, 41.9) - width + shift
    upper = c(12.5, 41.9) + width + shift
    stopifnot(length(lower) == 2)
    stopifnot(length(upper) == 2)
    stopifnot(lower < upper)
    stopifnot(length(resolution) == 1)
    stopifnot(resolution > 0)
    
    grid = expand.grid(long = seq(lower[1], upper[1], length.out = resolution),
                       lat = seq(lower[2], upper[2], length.out = resolution))
    myGeoCode = function(long, lat){
        revgeocode(c(long, lat))
    }
    address = mapply(myGeoCode, long = grid$long, lat = grid$lat)
    if(is(address, "list"))
        address = do.call("c", address)
    grid$address = address
    
    addressFile = fread(input = paste0(workingDir, "/Data/addressDatabase.csv"))
    addressFile[, street := as.character(street)]
    addressFile[, number := as.numeric(number)]
    addressFile[, city := as.character(city)]
    
    ## Update address file with new data
    grid$address = gsub(", Italy", "", grid$address)
    grid$address = gsub(" RM", "", grid$address)
    elements = strsplit(grid$address, ",( )*")
    if(min(sapply(elements, length)) < 3){
        warning("The following addresses have length < 3:\n",
                paste0(grid$address[sapply(elements, length) < 3],
                       collapse = "\n"))
    }
    grid$street = sapply(elements, function(x) x[1])
    grid$number = sapply(elements, function(x){
        if(length(x) < 3)
            return(NA)
        out = x[2]
        if(grepl("-", out)){
            range = as.numeric(strsplit(out, "-")[[1]])
            out = sample(range[1]:range[2], size = 1)
        }
        return(as.numeric(out))
    })
    grid$city = sapply(elements, function(x){
        gsub("[0-9]* ", "", x[length(x)])
    })
    grid$CAP = sapply(elements, function(x){
        gsub(" [A-Za-z]*", "", x[length(x)])
    })
    grid$longitude = grid$long
    grid$latitude = grid$lat
    grid = grid[, colnames(addressFile)]
    addressFile = rbind(addressFile, grid)
    addressFile = cleanAddressFile(addressFile)
    write.csv(addressFile, file = paste0(workingDir, "/Data/addressDatabase.csv"),
              row.names = FALSE)
}