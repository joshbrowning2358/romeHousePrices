##' Get Number of Pages for Trip Advisor
##' 
##' This function returns the number of activity pages available on the
##' Trip Advisor site.
##' 
##' @param type See ?getAttractionUrls. 
##' 
##' @return An integer giving the number of pages.
##' 
##' @export
##'

getNumPagesTripAdvisor = function(type = "Activity"){
    if(type == "Activity"){
        url = "http://www.tripadvisor.com/Attractions-g187791-Activities-Rome_Lazio.html"
    } else {
        stop("Current type not yet implemented!")
    }
    html = read_html(url)
    cast = html_nodes(html, "#pageCount strong:nth-child(2)")
    as.numeric(html_text(cast))
}


##' Get Attraction Urls for Trip Advisor
##' 
##' This function gets the urls for each of the attraction pages.
##' 
##' @param numPages The number of pages which should be loaded (and 15 urls are 
##'   generally scraped per page).  If numPages is more than the number of pages
##'   available, this function ends at the last one (with a warning).
##' @param type One of "Activities", 
##'   
##' @return A character vector containing the urls for all the individual 
##'   listings.
##'   
##' @export
##' 

getAttractionUrls = function(numPages, type = "Activities"){
    ## Data Quality Checks
    stopifnot(is.numeric(numPages))
    stopifnot(type %in% c("Activities")

    ## Use sprintf to substitute the %s with the appropriate number
    if(type == "Activities"){
        base = "http://www.tripadvisor.com/Attractions-g187791-Activities-oa%s-Rome_Lazio.html#ATTRACTION_LIST"
    } else {
        stop("Current type not yet implemented!")
    }
    
    listingPages = c()
    errors = 0
    totalPages = getNumPagesImmobiliare()
    if(numPages > totalPages){
        warning("Only ", totalPages, " pages available!  numPages has been ",
                "adjusted down.")
        numPages = totalPages
    }
    for(i in 1:numPages){
        fail = try({
            ## Make sure i is never in scientific notation
            url = paste0(base, "?pag=", formatC(i, format = "f", digits = 0))
            mainHtml <- read_html(url)
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
