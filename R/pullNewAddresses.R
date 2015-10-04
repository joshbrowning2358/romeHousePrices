##' Pull New Addresses
##' 
##' This function searches through the current data files and adds on missing 
##' addresses (when the longitude and latitude are available).
##' 
##' @return No object is returned, but saved files are updated with addresses
##'   (if missing).
##'   
##' @export
##' 

pullNewAddresses = function(){
    assignDirectory()
    
    codesRemaining = geocodeQueryCheck(userType = "free")
    datasets = dir(path = savingDir, pattern = ".csv", full.names = TRUE)
    i = 1
    while(codesRemaining > 0 & i <= length(datasets)){
        d = read.csv(datasets[i])
        if(!"latitude" %in% colnames(d)){
            d$latitude = NA
        }
        if(!"longitude" %in% colnames(d)){
            d$longitude = NA
        }
        indices = !is.na(d$indirizzio) & is.na(d$longitude)
        newAddresses = d$indirizzio[indices]
        if(length(newAddresses) > codesRemaining){
            newAddresses = newAddresses[1:codesRemaining]
            indices = indices[1:codesRemaining]
        }
        coords = lapply(newAddresses, addressToCoord, source = "google")
        coords = do.call(rbind, coords)
        d$latitude[indices] = 
        d$longitude[indices] = 
        write.csv(d, file = datasets[i], row.names = FALSE)
        codesRemaining = geocodeQueryCheck(userType = "free")
        i = i + 1
    }
}