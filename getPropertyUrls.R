##' Get Property urls
##' 
##' This function gets the urls for each of the detailed, property listing 
##' pages.
##' 
##' @param numPages The number of pages which should be loaded (and 15 urls are 
##'   generally scraped per page).  If numPages is more than the number of pages
##'   available (likely something in the ~2000 range), this function ends at the
##'   last one (with a warning).
##'   
##' @return A character vector containing the urls for all the individual 
##'   listings.
##'   

getPropertyUrls = function(numPages){
    base = "http://www.immobiliare.it/Roma/vendita_case-Roma.html"
    listingPages = c()
    errors = 0
    totalPages = getNumPages()
    if(numPages > totalPages){
        warning("Only ", totalPages, " pages available!  numPages has been ",
                "adjusted down.")
        numPages = totalPages
    }
    for(i in 1:numPages){
        fail = try({
            ## Make sure i is never in scientific notation
            url = paste0(base, "?pag=", formatC(i, format = "f", digits = 0))
            mainHtml <- html(url)
            newPages = html_nodes(mainHtml, ".annuncio_title a")
            newPages = sapply(newPages, html_attr, name = "href")
            listingPages = c(listingPages, newPages)
        })
        if(is(fail, "try-error"))
            errors = errors + 1
    }
    if(errors > 0)
        warning("We had", errors, "errors on loading pages.")
    return(listingPages)
}
