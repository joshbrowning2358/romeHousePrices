##' Get Property Details for Casa.it #copied from immobiliare function
##' 
##' This function takes the url for a listing page and extracts the relevant
##' data from it (i.e. square meters, bathrooms, rooms, price, elevator,
##' restructured, ...)
##' 
##' @param url The url of the property listing.
##'   
##' @return A data.table (with one row) containing the variables available for
##'   this dataset.
##' 
##' @export
##'

getPropertyDetailsCasa = function(url){
  
    #Check to make sure URL works
    fail = try({
        htmlCode = read_html(url)
    })
    if(is(fail, "try-error")){
        warning("Page could not be read!  Returning NULL.")
        return(NULL)
    }
    
    ##########################
    ## features not in table #
    ##########################
    #indirizzo
    indirizzo = html_nodes(htmlCode,".titlecontact , h1")
    indirizzo = html_text(indirizzo)
    test = grepl(" in ",indirizzo)
      
      #sometimes, two elements in list have "in", but usually not capital RM
      if(sum(test) > 1){
        test = grepl("RM",indirizzo)
        indirizzo = indirizzo[test]
        } else if (sum(test) == 1){
          indirizzo = indirizzo[!test]
        } else {
          print(paste0("Error"," ",url, "Not readable"))
        }
    
    #zona
    zona = html_nodes(htmlCode, "#listing_info .zone")
    zona = html_text(zona)
    zona = zona[1]
    
    #description
#     descrizione = html_nodes(htmlCode, ".body")
#     descrizione = html_text(descrizione)
    
    #agency riferimento
    riferimento = html_nodes(htmlCode, ".property_id")
    riferimento = html_text(riferimento)
    riferimento = gsub("Codice annuncio ","", riferimento)
    
    #price
    prezzo = html_nodes(htmlCode, ".price")
    prezzo = html_text(prezzo)
    
    #############################
    #extract features from table#
    #############################
    table.features <- html_nodes(htmlCode,"#features li")
    table.features <- html_text(table.features)
    
    #split to create names from values, names are features
    propertyDetails = strsplit(table.features, ":")
    names = lapply(propertyDetails, function(x) x[1])
    values = lapply(propertyDetails, function(x) x[2])
    
    #remove column names
    col.names <- c("Caratteristiche generali","Caratteristiche interne","Caratteristiche esterne")
    test <- match(col.names,names)
    
    #subset to remove NAs in test
    test <- test[!is.na(test)]
    names <- names[-(test)]
    values <- values[-(test)]
    
    #if a name is present without a value, then value = TRUE, example: ascensore
    replace <- is.na(values)
    values[replace] <- "TRUE"
    
    #format from table
    names <- unlist(names)
    values <- unlist(values)
    
    
    #Create data.table using features not in table
    data <- data.table(indirizzo = indirizzo,
                       zona = zona,
                       riferimento = riferimento,
                       #descrizione = descrizione,
                       prezzo = prezzo)
    
    
    #Add features contained in table
    for(i in 1:length(names)){
      data[, (names[i]) := values[i]]
    }
    
    data$url <- url
    
data
}
