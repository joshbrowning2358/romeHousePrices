##' Get Property Details for Mio Affitto
##' 
##' This function takes the url for a listing page and extracts the relevant
##' data from it (i.e. square meters, bathrooms, rooms, price, elevator,
##' restructured, ...)
##' 
##' @param url The url of the property listing.
##' 
##' @example
##' getPropertyDetailsMioAffitto("http://www.mioaffitto.it/affitto_appartamento_roma/tiburtina-appartamento-in-affitto_2892995.html")
##' 
##' @return A data.table (with one row) containing the variables available for
##'   this dataset.
##'

getPropertyDetailsMioAffitto = function(url){
    fail = try({
        htmlCode = html(url)
    })
    if(is(fail, "try-error")){
        warning("Page could not be read!  Returning NULL.")
        return(NULL)
    }
    propertyDetails = html_nodes(htmlCode, ".margin-bottom-20 li")
    propertyDetails = gsub("- ", "", html_text(propertyDetails))
    mainDetails = html_nodes(htmlCode, ".detail-resume")
    mainDetails = gsub("(\n|\t)", "", html_text(mainDetails[[1]]))
    prezzio = gsub("(\n| )", "", mainDetails)
    prezzio = gsub("[^0-9\\.].*", "", prezzio)
    prezzio = gsub("\\.", "", prezzio)
    superficie = gsub("m2.*", "", mainDetails)
    superficie = gsub(".* ", "", superficie)
    locali = gsub(" Loc.*", "", mainDetails)
    locali = gsub(".* ", "", locali)
    bagni = gsub(" Bagno.*", "", mainDetails)
    bagni = gsub(".* ", "", bagni)
    mapDetails = html_text(html_nodes(htmlCode, "address"))
    mapDetails = gsub("^\n[ a-zA-Z:]*\n *", "", mapDetails)
    pictureCount = html_node(htmlCode, ".detail-gallery-count")
    if(is.null(pictureCount)){
        pictureCount = 0
    } else {
        pictureCount = gsub("(\n| |1/)", "", html_text(pictureCount))
    }
    description = html_text(html_nodes(htmlCode, "h2 , .detail-description span"))
    description = paste(description[[1]], description[[2]])
    agency = html_nodes(htmlCode, ".detail-agency-info")
    # priceHist = html_attr(html_nodes(htmlCode, "#chart_precios")[[1]], name = "src")
    data = data.table(
        ## Remove all non-numeric characters
        superficie = superficie, locali = locali, bagni = bagni,
        prezzio = prezzio,
        indirizzio = gsub("\n.*", "", mapDetails),
        zona = gsub("(.*Zona: |Quartiere:\n.*)", "", mapDetails),
        quartiere = gsub("(.*Quartiere:\n *|\n *\n *$)", "", mapDetails),
        description = gsub("(\n|\t)", "", description),
        pictureCount = pictureCount,
        agency = ifelse(length(agency) > 0, TRUE, FALSE),
        url = url
    )
    ## Split into name/values if applicable, otherwise just name
    propertyDetails = strsplit(propertyDetails, ":")
    names = lapply(propertyDetails, function(x) x[1])
    names = gsub(" $", "", names)
    names = gsub("\\s+", "\\.", names)
    values = lapply(propertyDetails, function(x){
        if(length(x) == 2) return(x[2])
        if(length(x) == 1) return(TRUE)
        stop("Vector of length not equal to 1 or 2 found!")
    })
    values = gsub("(^ | $)", "", values)
    for(i in 1:length(names)){
        data[, (names[i]) := values[i]]
    }
    return(data)
}
