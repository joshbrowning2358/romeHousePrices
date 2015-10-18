##' Get Property urls for Casa.IT in Rome
##' 
##' This function gets the urls for each of the detailed, property listing 
##' pages.
##' 
##' @param url is the starting url of the properties to be scraped
##'   
##' @return A character vector containing the urls for all the individual 
##'   listings.
##'   
##' @export
##' 

## ENHANCEMENT:   If numPages more than the number of pages available 
##   (likely something in the ~2000 range), this function should end safely at 
##   the last one (with a warning).
#get scrape data from casa.it

# library(rvest)

getPropertyUrlsCasa = function(url){
  
  
  ## Data Quality Checks
#   stopifnot(is.numeric(numPages))
#   stopifnot(type %in% c("vendita", "affitto"))
  
#   if(type == "vendita"){
#     base = "http://www.casa.it/vendita-residenziale/in-roma%2c+rm%2c+lazio/lista-"
#   } else if(type == "affitto"){
#     base =  "http://www.casa.it/affitti-residenziale/in-roma%2c+rm%2c+lazio/lista-"
#   } else {
#     stop("Current type not yet implemented!")
#   }
#   
  
  url = paste0(url,1)
  
  mainHtml = read_html(url)
  numPages = getNumPagesCasa(url)
  
  
  listingPages = c()
  errors = 0
  totalPages = numPages
#   if(numPages > totalPages){
#     warning("Only ", totalPages, " pages available!  numPages has been ",
#             "adjusted down.")
#     numPages = totalPages
#   }

  if(numPages > 201){
    print(paste0("Number of pages =",numPages,". adjusting to 201 for ",url))
    numPages = 201
  }
  
  
  for(i in 1:numPages){
    fail = try({
      
      #if first iteration, don't change url from base, otherwise put i
      if(i == 1){
        url.temp = url
      } else {
        url.temp = paste0(substr(url, 1, nchar(url)-1),i)
      }
      ## Make sure i is never in scientific notation
    #url = paste0(base, formatC(i, format = "f", digits = 0))
    mainHtml <- read_html(url.temp)
    newPages = html_nodes(mainHtml, ".name")
    newPages = sapply(newPages, html_attr, name = "href")
    newPages = paste0("http://www.casa.it",newPages)
    listingPages = c(newPages,listingPages)
    #print(i)
    })
    if(is(fail,"try-error"))
      errors = errors +1
  }
  
  if(errors > 0)
    warning("We had",errors,"errors on loading pages.")
  return(listingPages)
  
}  

  
