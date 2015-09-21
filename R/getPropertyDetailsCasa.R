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

getPropertyDetailsCasa = function(url){
    fail = try({
        htmlCode = html(url)
    })
    if(is(fail, "try-error")){
        warning("Page could not be read!  Returning NULL.")
        return(NULL)
    }
    
    
    #indirizzo
    indirizzo = html_nodes(htmlCode,".titlecontact , h1")
    indirizzo = html_text(indirizzo)
    test = grepl(" in ",indirizzo)
    indirizzo = indirizzo[!test]
    
    #zona
    zona = html_nodes(htmlCode, "#listing_info .zone")
    zona = html_text(zona)
    zona = zona[1]
    
    #description
    descrizione = html_nodes(htmlCode, ".body")
    descrizione = html_text(descrizione)
    
    #condominio
    condominio = html_nodes(htmlCode,"li:nth-child(6) , li:nth-child(6) span")
    condominio = html_text(condominio)
    test <- grepl("Spese Condom",condominio)
    if(sum(test) == 0){
      condominio = "NA"
    } else {
      condominio = condominio[test] 
    }
    
    #agency riferimento
    riferimento = html_nodes(htmlCode, ".property_id")
    riferimento = html_text(riferimento)
    riferimento = gsub("Codice annuncio ","", riferimento)
    
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
    names <- names[-test]
    values <- values[-test]
    
    #if a name is present without a value, then value = TRUE, example: ascensore
    replace <- is.na(values)
    values[replace] <- "TRUE"
    
    #combined names, values into df and merge w/ features not in table
  

}
