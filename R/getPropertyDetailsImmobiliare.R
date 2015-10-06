##' Get Property Details for Immobiliare
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
##' @export
##' 

getPropertyDetailsImmobiliare = function(url){
    fail = try({
        htmlCode = read_html(url)
    })
    if(is(fail, "try-error")){
        warning("Page could not be read!  Returning NULL.")
        return(NULL)
    }
    propertyDetails = html_nodes(htmlCode, "#details td")
    propertyDetails = gsub("(\t|\n|:|\\s$)", "", html_text(propertyDetails))
    mainDetails = html_nodes(htmlCode, ".dettaglio_superficie")
    mainDetails = gsub("(\n|\t)", "", html_text(mainDetails[[1]]))
    mainDetails = strsplit(mainDetails, split = "\\|")[[1]]
    mapDetails = html_nodes(htmlCode, ".indirizzo_mappa")
    mapDetails = lapply(mapDetails, html_text)
    pictureCount = html_nodes(htmlCode, "#dettaglio_cont_bigimg")
    if(length(pictureCount) == 0){
        pictureCount = 0
    } else {
        pictureCount = gsub("(\n|\t|.* di| )", "",
                            html_text(pictureCount[[1]]))
    }
    description = try(html_text(html_nodes(htmlCode, ".descrizione")[[1]]))
    if(is(description, "try-error")){
        description = ""
    }
    superficie = gsub("[^(0-9)]", "", grep("mÂ²", mainDetails, value = TRUE))
    if(length(superficie) == 0) superficie = NA
    locali = gsub("[^(0-9)]", "", grep("local", mainDetails, value = TRUE))
    if(length(locali) == 0) locali = NA
    bagni = gsub("[^(0-9)]", "", grep("bagn", mainDetails, value = TRUE))
    if(length(bagni) == 0) bagni = NA
    prezzo = gsub("[^(0-9)]", "", grep("¬", mainDetails, value = TRUE))
    if(length(prezzo) == 0) prezzo = NA
    data = data.table(
        ## Remove all non-numeric characters
        superficie = superficie,
        locali = locali,
        bagni = bagni,
        prezzo = prezzo,
        indirizzio = gsub("(\n|\t)", "", mapDetails[1]),
        zona = gsub("(\n|\t)", "", mapDetails[2]),
        quartiere = gsub("(\n|\t)", "", mapDetails[3]),
        description = gsub("(\n|\t)", "", description),
        pictureCount = pictureCount,
        url = url
    )
    names = propertyDetails[seq(1, length(propertyDetails)-1, 2)]
    names = gsub(" ", "\\.", names)
    values = propertyDetails[seq(2, length(propertyDetails), 2)]
    badNames = names == ""
    names = names[!badNames]
    values = values[!badNames]
    for(i in 1:length(names)){
        ## Only add the variable if it's not in there already.  Superficie, for
        ## example, is repeated.
        if(!tolower(names[i]) %in% colnames(data)){
            data[, (names[i]) := values[i]]
        }
    }
    return(data)
}
