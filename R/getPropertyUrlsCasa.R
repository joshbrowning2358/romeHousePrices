library(rvest)

##' Get Property urls for Casa.IT in Rome
##' 
##' This function gets the urls for each of the detailed, property listing 
##' pages.
##' 
##' @param numPages The number of pages which should be loaded (and 15 urls are 
##'   generally scraped per page).
##'   
##' @return A character vector containing the urls for all the individual
##'   listings.
##'   

## ENHANCEMENT:   If numPages more than the number of pages available 
##   (likely something in the ~2000 range), this function should end safely at 
##   the last one (with a warning).
#get scrape data from casa.it



getPropertyUrlsCasa = function(numPages){
  base = "http://www.casa.it/vendita-residenziale/in-roma%2c+rm%2c+lazio/lista-"
  listingPages = c()
  for(i in 1:numPages){
    ## Make sure i is never in scientific notation
    url = paste0(base, formatC(i, format = "f", digits = 0),"?preferredState=laz")
    mainHtml <- html(url)
    newPages = html_nodes(mainHtml, ".name")
    newPages = sapply(newPages, html_attr, name = "href")
    newPages = paste0("http://www.casa.it/",newPages)
    listingPages = c(newPages,listingPages)
  }
  return(listingPages)
}