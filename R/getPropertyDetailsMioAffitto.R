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

# url = "http://www.mioaffitto.it/affitto_appartamento_roma/tiburtina-appartamento-in-affitto_2892995.html"

getPropertyDetailsMioAffitto = function(url){
    htmlCode <- html(url)
    propertyDetails = html_nodes(htmlCode, ".margin-bottom-20 li")
    propertyDetails = gsub("- ", "", html_text(propertyDetails))
#     mainDetails = html_nodes(htmlCode, ".dettaglio_superficie")
#     mainDetails = gsub("(\n|\t)", "", html_text(mainDetails[[1]]))
#     mainDetails = strsplit(mainDetails, split = "\\|")[[1]]
    mapDetails = html_text(html_nodes(htmlCode, "address"))
    mapDetails = gsub("^\n[ a-zA-Z:]*\n *", "", mapDetails)
    indirizzo = gsub("\n.*", "", mapDetails)
    zona = gsub("(.*Zona: |Quartiere:\n.*)", "", mapDetails)
    quartiere = gsub("(.*Quartiere:\n *|\n *\n *$)", "", mapDetails)
#     pictureCount = html_nodes(htmlCode, "#dettaglio_cont_bigimg")
#     if(length(pictureCount) == 0){
#         pictureCount = 0
#     } else {
#         pictureCount = gsub("(\n|\t|.* di| )", "",
#                             html_text(pictureCount[[1]]))
#     }
    description = html_text(html_nodes(htmlCode, "h2 , .detail-description span"))
    description = paste(description[[1]], description[[2]])
    # priceHist = html_attr(html_nodes(htmlCode, "#chart_precios")[[1]], name = "src")
    data = data.table(
        ## Remove all non-numeric characters
        superficie = gsub("[^(0-9)]", "", mainDetails[1]),
        locali = gsub("[^(0-9)]", "", mainDetails[2]),
        bagni = gsub("[^(0-9)]", "", mainDetails[3]),
        prezzio = gsub("[^(0-9)]", "", mainDetails[4]),
        indirizzio = gsub("(\n|\t)", "", mapDetails[1]),
        zona = gsub("(\n|\t)", "", mapDetails[2]),
        quartiere = gsub("(\n|\t)", "", mapDetails[3]),
        description = gsub("(\n|\t)", "", description),
        pictureCount = pictureCount
    )
    names = propertyDetails[seq(1, length(propertyDetails)-1, 2)]
    names = gsub(" ", "\\.", names)
    values = propertyDetails[seq(2, length(propertyDetails), 2)]
    badNames = names == ""
    names = names[!badNames]
    values = values[!badNames]
    for(i in 1:length(names)){
        data[, (names[i]) := values[i]]
    }
    return(data)
}
