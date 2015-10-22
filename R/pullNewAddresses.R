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
    datasets = dir(path = savingDir, pattern = "cleaned.RData", full.names = TRUE)
    ## Store on github to allow versioning and better conflict resolution
    ## (github works with .csv)
    addressFile = fread(input = paste0(workingDir, "/Data/addressDatabase.csv"))
    addressFile[, street := as.character(street)]
    addressFile[, number := as.numeric(number)]
    addressFile[, city := as.character(city)]
    
    i = 1
    while(codesRemaining > 0 & i <= length(datasets)){
        cat("Running code for", gsub(".*/", "", datasets[i]), "\n")
        load(datasets[i])
        if(!"latitude" %in% colnames(d)){
            d[, latitude := NA_real_]
        }
        if(!"longitude" %in% colnames(d)){
            d[, longitude := NA_real_]
        }
        if(!"CAP" %in% colnames(d)){
            d[, CAP := NA_character_]
        }
        d[indirizzio == "NA", indirizzio := NA_character_]
        indices = which(!is.na(d$indirizzio) & is.na(d$longitude))
        if(length(indices) == 0){
            i = i + 1
            next
        }
        newAddresses = as.character(d$indirizzio[indices])
        newAddresses = gsub(", roma", "", newAddresses)
        newAddresses = data.table(
            street = stringr::str_extract(pattern = "[^0-9]*",
                                           string = newAddresses),
            number = stringr::str_extract(pattern = "[0-9]*$",
                                          string = newAddresses),
            city = "roma", latitude = NA_real_, longitude = NA_real_,
            CAP = NA_character_, index = indices)
        newAddresses[, street := gsub(", *$", "", street)]
        newAddresses[, number := as.numeric(number)]
        newAddresses = cleanAddressFile(newAddresses, deleteRows = FALSE)
        
        ## Update new addresses with any already on file
        newAddresses = merge(newAddresses, addressFile,
                             by = c("street", "number", "city"),
                             all.x = TRUE, suffixes = c(".old", ""))
        newAddresses[, c("latitude.old", "longitude.old", "CAP.old") := NULL]
        
        ## If latitude and longitude are not missing now, add back to d
        fromFile = newAddresses[!is.na(latitude), ]
        d[fromFile$index, latitude := fromFile$latitude]
        d[fromFile$index, longitude := fromFile$longitude]
        d[fromFile$index, CAP := fromFile$CAP]
        newAddresses = newAddresses[is.na(latitude), ]
        newAddresses = newAddresses[!is.na(street), ]
        newAddresses = newAddresses[street != "NA", ]
        
        ## Look up missing addresses
        newAddresses[, firstObs := 1:nrow(.SD) == 1, by = c("street", "number")]
        newAddresses[, cumUnique := cumsum(firstObs)]
        if(max(newAddresses$cumUnique) > codesRemaining){
            newAddresses = newAddresses[cumUnique <= codesRemaining, ]
        }
        newAddresses[, c("firstObs", "cumUnique") := NULL]
        ## Force latitude/longitude to NA real instead of NA logical so that we
        ## don't have type problems with data.table.
        newAddresses[, c("latitude", "longitude") := rep(NA_real_, .N)]
        newAddresses[, CAP := rep(NA_character_, .N)]
        fullAddress = newAddresses[, paste(street, ifelse(is.na(number), "", number), city)]
        cat("Found", length(fullAddress), "addresses to look up.\n")
        suppressMessages({suppressWarnings({
            coords = lapply(fullAddress, addressToCoord, source = "google")
        })})
        coords = do.call(rbind, coords)
        stopifnot(nrow(coords) == nrow(newAddresses))
        newAddresses[, latitude := coords$latitude]
        newAddresses[, longitude := coords$longitude]
        newAddresses[, CAP := as.character(coords$CAP)]
        
        ## Add newly found addresses back to d and to address database
        cat("Saving data...\n")
        d[newAddresses$index, latitude := newAddresses$latitude]
        d[newAddresses$index, longitude := newAddresses$longitude]
        d[newAddresses$index, CAP := newAddresses$CAP]
        save(d, file = datasets[i])
        newAddresses[, index := NULL]
        if(nrow(newAddresses) > 0){
            addressFile = rbind(addressFile, unique(newAddresses))
            addressFile = addressFile[!is.na(latitude), ]
            addressFile = cleanAddressFile(addressFile, deleteRows = TRUE)
        }
        ## Store on github to allow versioning and better conflict resolution
        ## (github works with .csv)
        write.csv(addressFile, file = paste0(workingDir, "/Data/addressDatabase.csv"),
                  row.names = FALSE)
        
        codesRemaining = geocodeQueryCheck(userType = "free")
        i = i + 1
    }
}