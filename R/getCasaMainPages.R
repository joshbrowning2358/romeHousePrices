##' Create urls to feed to get PropertyUrlsCasa
##' 
##' This function gets the urls for each of the detailed, property listing 
##' pages.
##' 
##'
##' @param type A character string, either "vendita" or "affitto", indicating
##'   which type of urls should be scraped.
##'   
##' @return A character vector containing the urls for all the individual 
##'   MAIN pages for listing
##'   
##' @export
##' 

getCasaMainPages <- function(type = "vendita"){
 
   ## Data Quality Checks
  stopifnot(type %in% c("vendita", "affitto"))
  
  if(type == "vendita"){
    
    base = "http://www.casa.it/vendita-residenziale/per-"
    end = "-in-roma%2c+rm%2c+lazio/lista-"

    #must create ranges of prices for scraping data to bypass site page limit
    k = 1000
    prices = c(50,100,150,200,250,300,350,400,450,500,550,600,
            650,700,850,900,950,1000,1250,1500,1750,2000,2250,
            2500,2750,3000,4000,5000,10000)
    
    prices = k*prices
  } else if (type == "affitto"){
    
    base = "http://www.casa.it/affitti-residenziale/per-"
    end = "-in-roma%2c+rm%2c+lazio/lista-"
    
    prices <- c(50,100,150,200,250,300,350,400,450,500,650,700,
                750,800,850,900,950,1000,1100,1200,1300,1400,1500,
                1600,1700,1800,1900,2000,2500,3000,3500,4000,4500,
                5000,5500,6000,6500,7000,7500,8000,8500,9500,10000)
  }
  
  #create set of low range and high rang
  low.d <- c()
  high.d <- c()

  #skip last iteration b/c we upper bound would be NA
  for(i in 1:(length(prices)-1)){
      low.d <- append(low.d, prices[i]) 
      high.d <- append(high.d,prices[i+1])
    }
  
  #put all info in 1 data.frame  
  house.range <- data.frame(low = as.numeric(low.d),
                            high = as.numeric(high.d))
  
  
  #function to paste together urls
  build <- function(df){
    url <- paste0(base,
           format(df[,1], scientific = FALSE),
           "-",
           format(df[,2],scientific = FALSE),
           end)
    url
  }
  
  base.urls <- build(house.range)
  base.urls <- gsub(" ","",base.urls)   

}
