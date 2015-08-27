##' Get Property Details
##' 
##' This function takes the url for a listing page and extracts the relevant
##' data from it (i.e. square meters, bathrooms, rooms, price, elevator,
##' restructured, ...)
##' 
##' @param url The url of the property listing.
##'   
##' @return A data.table (with one row) containing the variables available for
##'   this dataset.
##'

getPropertyDetails = function(url){
    htmlCode <- html(url)
    propertyDetails = html_nodes(htmlCode, "#details td")
    mainDetails = html_nodes(htmlCode, ".dettaglio_superficie")
    mainDetails = gsub("(\n|\t)", "", html_text(propertyDetails[[1]]))
    mainDetails = strsplit(mainDetails, split = "\\|")[[1]]
    mapDetails = html_nodes(htmlCode, ".indirizzo_mappa")
    mapDetails = lapply(mapDetails, html_text)
    data = data.table(
        ## Remove all non-numeric characters
        superficie = gsub("[^(0-9)]", "", mainDetails[1]),
        locali = gsub("[^(0-9)]", "", mainDetails[2]),
        bagni = gsub("[^(0-9)]", "", mainDetails[3]),
        prezzio = gsub("[^(0-9)]", "", mainDetails[4]),
        indirizzio = gsub("(\n|\t)", "", mapDetails[1]),
        zona = gsub("(\n|\t)", "", mapDetails[2]),
        quartiere = gsub("(\n|\t)", "", mapDetails[3])
    )
    for(i in seq(1, length(propertyDetails)-1, 2)){
        ## Remove junk characters
        name = gsub("(\n|\t|:|)", "", html_text(propertyDetails[[i]]))
        ## Remove trailing spaces
        name = gsub("\\s$", "", name)
        ## Convert spaces to periods
        name = gsub(" ", "\\.", name)
        value = gsub("(\n|\t)", "", html_text(propertyDetails[[i+1]]))
        data[, (name) := value]
    }
    return(data)
}
