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



getPropertyUrlsCasa = function(numPages, type = "vendita"){
  
  
  ## Data Quality Checks
  stopifnot(is.numeric(numPages))
  stopifnot(type %in% c("vendita", "affitto"))
  
  if(type == "vendita"){
    base = "http://www.casa.it/vendita-residenziale/in-roma%2c+rm%2c+lazio/lista-"
  } else if(type == "affitto"){
    base =  "http://www.casa.it/affitti-residenziale/in-roma%2c+rm%2c+lazio/lista-"
  } else {
    stop("Current type not yet implemented!")
  }
  
  
  listingPages = c()
  errors = 0
  totalPages = getNumPagesCasa()
  if(numPages > totalPages){
    warning("Only ", totalPages, " pages available!  numPages has been ",
            "adjusted down.")
    numPages = totalPages
  }

  for(i in 1:numPages){
    fail = try({
    ## Make sure i is never in scientific notation
    url = paste0(base, formatC(i, format = "f", digits = 0),"?preferredState=laz")
    mainHtml <- html(url)
    newPages = html_nodes(mainHtml, ".name")
    newPages = sapply(newPages, html_attr, name = "href")
    newPages = paste0("http://www.casa.it/",newPages)
    listingPages = c(newPages,listingPages)
    })
    if(is(fail,"try-error"))
      errors = errors +1
  }
  
  if(errors > 0)
    warning("We had",errors,"errors on loading pages.")
  return(listingPages)
  
}  
  
  #   for(i in 1:numPages){
  #     fail = try({
  #       ## Make sure i is never in scientific notation
  #       url = paste0(base, "?pag=", formatC(i, format = "f", digits = 0))
  #       mainHtml <- html(url)
  #       newPages = html_nodes(mainHtml, ".annuncio_title a")
  #       newPages = sapply(newPages, html_attr, name = "href")
  #       listingPages = c(listingPages, newPages)
  #     })
  #     if(is(fail, "try-error"))
  #       errors = errors + 1
  #   }
  #   if(errors > 0)
  #     warning("We had", errors, "errors on loading pages.")
  #   return(listingPages)
  # }  
  
  
#   for(i in 1:numPages){
#     ## Make sure i is never in scientific notation
#     url = paste0(base, formatC(i, format = "f", digits = 0),"?preferredState=laz")
#     mainHtml <- html(url)
#     newPages = html_nodes(mainHtml, ".name")
#     newPages = sapply(newPages, html_attr, name = "href")
#     newPages = paste0("http://www.casa.it/",newPages)
#     listingPages = c(newPages,listingPages)
#   }
#   

  
  
return(listingPages)
}