##' Get number of pages listing housing agencies in Rome from immobiliare.it
##' 
##' This function takes the url of the first page of the list of agencies from 
##' immobiliare.it, and returns the number of pages listing agencies
##' 
##' @param url The url of the first page of agency listings
##'   
##' @return A one element list with number of pages
##'

getAgenzieNumImmobiliare <- function(url){
  
  #url = "http://www.immobiliare.it/Roma/agenzie_immobiliari_provincia-Roma.html?pag=1"
  
  
  #Check to make sure URL works
  fail = try({
    htmlCode = read_html(url)
  })
  if(is(fail, "try-error")){
    warning("Page could not be read!  Returning NULL.")
    return(NULL)
  }
  
  #get number of pages
  numPages <- html_nodes(htmlCode, "#pageCount strong:nth-child(2)")
  numPages <- html_text(numPages)
  numPages <- as.numeric(numPages) 

numPages  
  
}