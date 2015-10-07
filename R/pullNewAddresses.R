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
    datasets = dir(path = savingDir, pattern = "cleaned.csv", full.names = TRUE)
    addressFile = fread(input = paste0(savingDir, "addressDatabase.csv"))
    addressFile[, street := as.character(street)]
    addressFile[, number := as.numeric(number)]
    addressFile[, city := as.character(city)]
    
    i = 1
    while(codesRemaining > 0 & i <= length(datasets)){
        d = read.csv(datasets[i], stringsAsFactors = FALSE)
        if(!"latitude" %in% colnames(d)){
            d$latitude = NA
        }
        if(!"longitude" %in% colnames(d)){
            d$longitude = NA
        }
        indices = which(!is.na(d$indirizzio) & is.na(d$longitude))
        newAddresses = as.character(d$indirizzio[indices])
        newAddresses = gsub(", roma", "", newAddresses)
        newAddresses = data.table(
            street = stringr::str_extract(pattern = "[^0-9]*",
                                           string = newAddresses),
            number = stringr::str_extract(pattern = "[0-9]*$",
                                          string = newAddresses),
            city = "roma", latitude = NA_real_, longitude = NA_real_,
            index = indices)
        newAddresses[, street := gsub(", *$", "", street)]
        newAddresses[, number := as.numeric(number)]
        
        ## Update new addresses with any already on file
        newAddresses = merge(newAddresses, addressFile,
                             by = c("street", "number", "city"),
                             all.x = TRUE, suffixes = c(".old", ""))
        newAddresses[, c("latitude.old", "longitude.old") := NULL]
        
        ## If latitude and longitude are not missing now, add back to d
        fromFile = newAddresses[!is.na(latitude), ]
        d$latitude[fromFile$index] = fromFile$latitude
        d$longitude[fromFile$index] = fromFile$longitude
        newAddresses = newAddresses[is.na(latitude), ]
        newAddresses = newAddresses[!is.na(street), ]
        
        ## Look up missing addresses
        if(nrow(newAddresses) > codesRemaining){
            newAddresses = newAddresses[1:codesRemaining, ]
        }
        ## Force latitude/longitude to NA real instead of NA logical so that we
        ## don't have type problems with data.table.
        newAddresses[, c("latitude", "longitude") := rep(NA_real_, .N)]
        fullAddress = newAddresses[, paste(street, ifelse(is.na(number), "", number), city)]
        coords = lapply(fullAddress, addressToCoord, source = "google")
        coords = do.call(rbind, coords)
        stopifnot(nrow(coords) == nrow(newAddresses))
        newAddresses[, latitude := coords$Latitude]
        newAddresses[, longitude := coords$Longitude]
        
        ## Add newly found addresses back to d and to address database
        d$latitude[newAddresses$index] = newAddresses$latitude
        d$longitude[newAddresses$index] = newAddresses$longitude
        write.csv(d, file = datasets[i], row.names = FALSE)
        newAddresses[, index := NULL]
        addressFile = rbind(addressFile, unique(newAddresses))
        write.csv(addressFile, file = paste0(savingDir, "addressDatabase.csv"),
                  row.names = FALSE)
        
        codesRemaining = geocodeQueryCheck(userType = "free")
        i = i + 1
    }
}