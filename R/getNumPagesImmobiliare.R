##' Get Number of Pages for Immobiliare
##' 
##' This function returns the number of listing pages available on the
##' immobiliare house sale site.
##' 
##' @param type 
##' 
##' @return An integer giving the number of pages.
##'

getNumPagesImmobiliare = function(){
    url = "http://www.immobiliare.it/Roma/vendita_case-Roma.html"
    html = read_html(url)
    cast = html_nodes(html, "#pageCount strong:nth-child(2)")
    as.numeric(html_text(cast))
}