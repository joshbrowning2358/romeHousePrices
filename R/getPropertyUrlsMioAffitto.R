##' Get Property urls for Mio Affitto
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

getPropertyUrlsMioAffitto = function(numPages){
    ## Data Quality Checks
    stopifnot(is.numeric(numPages))

    base = "http://www.mioaffitto.it/search?provincia=77&poblacion=70708"

    listingPages = c()
    errors = 0
    totalPages = getNumPagesMioAffitto()
    if(numPages > totalPages){
        warning("Only ", totalPages, " pages available!  numPages has been ",
                "adjusted down.")
        numPages = totalPages
    }
    for(i in 1:numPages){
        fail = try({
            ## Make sure i is never in scientific notation
            url = paste0(base, "&page=", formatC(i, format = "f", digits = 0))
            mainHtml <- html(url)
            newPages = html_nodes(mainHtml, ".property-title")
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
