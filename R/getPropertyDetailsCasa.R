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
    
    #extract main table
    mainDetails = html_nodes(htmlCode,"li , #features span")
    mainDetails = html_text(mainDetails)
    
    #price
    prezzo = html_nodes(htmlCode, ".price")
    prezzo = html_text(prezzo)
    
    #superficie
    superficie = grepl("^[00-99]+ mq",mainDetails)
    superficie = mainDetails[superficie]
    
    #bagno
    bagni = grepl("Bagni:", mainDetails)
    bagni = mainDetails[bagni]
    
    #locali
    locali = grepl("Locali:", mainDetails)
    locali = mainDetails[locali]
    
    
    #indirizzo
    indirizzo = html_nodes(htmlCode,".titlecontact , h1")
    indirizzo = html_text(indirizzo)
    test = grepl(" in ",indirizzo)
    indirizzo = indirizzo[!test]
    
    #zona
    zona = html_nodes(htmlCode, "#listing_info .zone")
    zona = html_text(zona)
    zona = zona[1]
    
    #description
    descrizione = html_nodes(htmlCode, ".body")
    descrizione = html_text(descrizione)
    
    #condominio
    condominio = html_nodes(htmlCode,"li:nth-child(6) , li:nth-child(6) span")
    condominio = html_text(condominio)
    test <- grepl("Spese Condom",condominio)
    condominio = condominio[test]
    
    
    
    mainDetails2 = html_nodes(htmlCode, ".featureList")
    mainDetails2 = html_text(mainDetails2)
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
