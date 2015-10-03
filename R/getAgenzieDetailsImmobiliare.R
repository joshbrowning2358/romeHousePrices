##' Get contact details of housing agenices listed on immobiliare.it
##' 
##' This function takes the number of pages from the first page of the list of agencies from 
##' immobiliare.it, and a data frame with the list of agencies and contact details.
##' 
##' @param numPages The number of pages listing agencies from immobiliare.it
##'   
##' @return A data.table listing the agencies and contact details
##'

getAgenzieDetailsImmobiliare <- function(numPages){
  
  #set base url for scraping
  baseUrl <- "http://www.immobiliare.it/Roma/agenzie_immobiliari_provincia-Roma.html?pag="
  
  data <- list()
  
  for(i in 1:numPages){
    
      #Check to make sure URL works
      url <- paste0(baseUrl,i)
    
      fail = try({
        htmlCode = read_html(url)
      })
      
      if(is(fail, "try-error")){
        warning(paste0("Page",i,"could not be read!  Returning NULL."))
        return(NULL)
      }
    
      #scrape names from url
      names <- html_nodes(htmlCode, ".annuncio_title a")
      names <- html_text(names)
      
      #scrape address
      details <- html_nodes(htmlCode, ".luogo ")
      indirizzi <- html_text(details)
      
      indirizzi = gsub("^\r\n\t\t\t\t\t\t \t\r\n\t\t\t\t    ", "", indirizzi)
      indirizzi = gsub("\t\t.*","",indirizzi)
      
      #scrape CAP
      cap <- html_text(details)
      cap <- gsub("^\r\n\t\t\t\t\t\t \t\r\n\t\t\t\t    .* [0-9]+", "", cap) #remove prefix
      cap <- gsub("\t+","",cap) #remove "\t"s
      cap <- gsub(" - .*","",cap) #remove end part of string
      
      #remove five characters from the right
      source("R/substrRight.R")
      cap <- substrRight(cap, n = 5)
      
      #convert to numeric
      cap <- as.numeric(cap)
      
      data.t <- list(names = names,indirizzi = indirizzi,cap = cap)
      
      data[[i]] <- data.t
  }

  
  finalData = rbindlist(data,fill = TRUE)
      
    
}





