##' Get Number of Pages
##' 
##' This function returns the number of listing pages available on the
##' immobiliare house sale site.
##' 
##' @return An integer giving the number of pages.
##'

getNumPages = function(){
    url = "http://www.immobiliare.it/Roma/vendita_case-Roma.html"
    html = html(url)
    cast = html_nodes(html, "#pageCount strong:nth-child(2)")
    as.numeric(html_text(cast))
}
