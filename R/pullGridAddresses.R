##' Pull Grid Addresses
##' 
##' This function steps up a grid of points around Rome and pulls addresses for
##' all the points in the grid.  These addresses are then added to the address
##' file.
##' 
##' @param width The width of the window around Rome
##' @param resolution A numeric value specifying how large the grid should be 
##'   (resolution x resolution points).
##' @param shift A numeric vector of length two that specifies how the window 
##'   should be shifted.
##'   
##' @return No object is returned, but the address file is updated.
##'   
##' @export
##' 

pullGridAddresses = function(width = runif(1, 0, .1), resolution = 10,
                             shift = runif(2,-.02,.02)){
    assignDirectory()
    cat("Using the following parameters:",
        "\nwidth:\t\t", width, "\nshift:\t\t", shift,
        "\nresolution:\t", resolution, "\n")
    
    ## Data Quality checks
    stopifnot(is.numeric(width))
    stopifnot(length(width) == 1)
    stopifnot(is.numeric(shift))
    stopifnot(length(shift) == 2)
    stopifnot(resolution > 0)
    stopifnot(length(resolution) == 1)
    lower = c(12.5, 41.9) - width + shift[1]
    upper = c(12.5, 41.9) + width + shift[2]
    
    grid = expand.grid(long = seq(lower[1], upper[1], length.out = resolution),
                       lat = seq(lower[2], upper[2], length.out = resolution))
    cat("Pulling", nrow(grid), "codes\n")
    myGeoCode = function(long, lat){
        out = try(revgeocode(c(long, lat)))
        if(is(out, "try-error"))
            return(NA)
        return(out)
    }
    suppressMessages({
    address = mapply(myGeoCode, long = grid$long, lat = grid$lat)
    })
    if(is(address, "list"))
        address = do.call("c", address)
    grid$address = address
    
    addressFile = fread(input = paste0(workingDir, "/Data/addressDatabase.csv"))
    addressFile[, street := as.character(street)]
    addressFile[, number := as.numeric(number)]
    addressFile[, city := as.character(city)]
    cat("Old address file:", nrow(addressFile), "rows.\n")
    
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
        x[2]
    })
    grid$city = sapply(elements, function(x){
        gsub("[0-9]* ", "", x[length(x)])
    })
    grid$CAP = sapply(elements, function(x){
        out = gsub("[A-Za-z]*", "", x[length(x)])
        out = gsub(" ", "", out)
        ifelse(out == "", NA, out)
    })
    grid$longitude = grid$long
    grid$latitude = grid$lat
    
    ## Update rows with multiple numbers
    toBind = grid[grepl("-", grid$number), ]
    numberVec = lapply(toBind$number, function(x){
        eval(parse(text = gsub("-", ":", x)))
    })
    nameVec = mapply(rep, x = rownames(toBind),
                     times = sapply(numberVec, length))
    if(is(nameVec, "list")){
        nameVec = do.call("c", nameVec)
    }
    toBind = toBind[nameVec, ]
    toBind[, "number"] = do.call("c", numberVec)
    grid = grid[!grepl("-", grid$number), ]
    grid = rbind(grid, toBind)
    
    grid = grid[, colnames(addressFile)]
    addressFile = rbind(addressFile, grid)
    addressFile = cleanAddressFile(addressFile)
    write.csv(addressFile, file = paste0(workingDir, "/Data/addressDatabase.csv"),
              row.names = FALSE)
    cat("New address file:", nrow(addressFile), "rows.\n")
}