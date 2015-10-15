##' Clean Address file
##' 
##' This function takes a data.table with columns street, number and city and 
##' performs some cleaning operations to it.  Additional columns may exist, and 
##' they will be ignored.
##' 
##' @param d The data.table containing the data of interest.
##' @param deleteRows Logical.  Should duplicated rows be removed from this
##'   dataset?
##'   
##' @return A data.table with the same structure as what was passed, but 
##'   possibly modified to clean up names or delete duplicate rows.
##' 
##' @export
##' 

cleanAddressFile = function(d, deleteRows = TRUE){
    d[, street := gsub("\\s$", "", street)]
    d[!grep("(di roma|de roma)", street),
      street := gsub(" roma$", "", street)]
    if(deleteRows){
        d[, firstOccurence := (1:.N) == 1, by = c("street", "number", "city")]
        d = d[(firstOccurence), ]
        d[, firstOccurence := NULL]
    }
    return(d)
}