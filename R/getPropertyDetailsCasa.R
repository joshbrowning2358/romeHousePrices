##' Get Property Details for Casa.it #copied from immobiliare function
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

getPropertyDetailsCasa = function(url){
    fail = try({
        htmlCode = html(url)
    })
    if(is(fail, "try-error")){
        warning("Page could not be read!  Returning NULL.")
        return(NULL)
    }
    #propertyDetails = html_nodes(htmlCode, "#details td")                      come back!
    #propertyDetails = gsub("(\t|\n|:|\\s$)", "", html_text(propertyDetails))
    mainDetails = html_nodes(htmlCode, "#features li , #features span")
    mainDetails = gsub("(\n|\t)", "", html_text(mainDetails))
#     mainDetails = strsplit(mainDetails, split = "\\|")[[1]]
#     mapDetails = html_nodes(htmlCode, ".indirizzo_mappa")
#     mapDetails = lapply(mapDetails, html_text)
#     pictureCount = html_nodes(htmlCode, "#dettaglio_cont_bigimg")
#     if(length(pictureCount) == 0){
#         pictureCount = 0
#     } else {
#         pictureCount = gsub("(\n|\t|.* di| )", "",
#                             html_text(pictureCount[[1]]))
#     }
#     description = html_text(html_nodes(htmlCode, ".descrizione")[[1]])
#     data = data.table(
#         ## Remove all non-numeric characters
          superficie = gsub("\\ mq", " m²", mainDetails[17])
#         locali = gsub("[^(0-9)]", "", mainDetails[2]),
          bagni = gsub("Bagni:", "", mainDetails[6])
#         prezzio = gsub("[^(0-9)]", "", mainDetails[4]),
#         indirizzio = gsub("(\n|\t)", "", mapDetails[1]),
#         zona = gsub("(\n|\t)", "", mapDetails[2]),
#         quartiere = gsub("(\n|\t)", "", mapDetails[3]),
#         description = gsub("(\n|\t)", "", description),
#         pictureCount = pictureCount
#     )
#     names = propertyDetails[seq(1, length(propertyDetails)-1, 2)]
#     names = gsub(" ", "\\.", names)
#     values = propertyDetails[seq(2, length(propertyDetails), 2)]
#     badNames = names == ""
#     names = names[!badNames]
#     values = values[!badNames]
#     for(i in 1:length(names)){
#         data[, (names[i]) := values[i]]
#     }
#     return(data)
}
