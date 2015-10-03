##' Get Number of Pages (Mio Affitto)
##' 
##' This function returns the number of listing pages available on the
##' immobiliare house sale site.
##' 
##' @param type 
##' 
##' @return An integer giving the number of pages.
##'

getNumPagesMioAffitto = function(){
    url = "http://www.mioaffitto.it/search?provincia=77&poblacion=70708"
    html = read_html(url)
    cast = html_nodes(html, ".property-list-title-count")
    listings = gsub("[^0-9]", "", html_text(cast))
    pages = ceiling(as.numeric(listings) / 15)
    pages
}