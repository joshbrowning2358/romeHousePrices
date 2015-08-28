##' Get Number of Pages for Casa.it
##' 
##' This function returns the number of listing pages available on the
##' casa.it housing sale site.
##' 
##' @param type 
##' 
##' @return An integer giving the number of pages.
##'

getNumPagesImmobiliare = function(){
  url = "http://www.casa.it/vendita-residenziale/in-roma%2c+rm%2c+lazio/lista-1?preferredState=laz"
  html = html(url)
  cast = html_nodes(html, ".resultsInfo p")
  cast <- html_text(cast[[1]])
  castNew = gsub(".*[0-9] di ", "", cast)
  castNew = gsub(" [A-Za-z ]+","",castNew)
  
  as.numeric(castNew)
}
