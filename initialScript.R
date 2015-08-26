library(rvest)
library(data.table)

##' Get Property urls
##' 
##' This function gets the urls for each of the detailed, property listing 
##' pages.
##' 
##' @param numPages The number of pages which should be loaded (and 15 urls are 
##'   generally scraped per page).  If more than the number of pages available 
##'   (likely something in the ~2000 range), this function will end safely at 
##'   the last one (with a warning).
##'   
##' @return A character vector containing the urls for all the individual
##'   listings.
##'   

getPropertyUrls = function(numPages){
    base = "http://www.immobiliare.it/Roma/vendita_case-Roma.html"
    listingPages = c()
    for(i in 1:numPages){
        ## Make sure i is never in scientific notation
        url = paste0(base, "?pag=", formatC(i, format = "f", digits = 0))
        mainHtml <- html(url)
        newPages = html_nodes(mainHtml, ".annuncio_title a")
        newPages = sapply(newPages, html_attr, name = "href")
        listingPages = c(listingPages, newPages)
    }
    return(listingPages)
}

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
    propertyDetails = html_nodes(htmlCode, "#details td , .dettaglio_superficie")
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
    for(i in seq(2, length(propertyDetails), 2)){
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

listingPages = getPropertyUrls(numPages = 10)
d = lapply(listingPages, getPropertyDetails)
finalData = rbindlist(d, fill = TRUE)
