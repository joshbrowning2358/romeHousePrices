##' Get Directory
##' 
##' This function uses the information at Sys.info() to assign a working 
##' directory and saving directory.  The names of the two objects created are 
##' workingDir and savingDir, and they are assigned to the global environment so
##' as to not require returning/assigning by this function.
##' 
##' @return No value is returned, but workingDir and savingDir are written to
##'   the global environment.
##' 
##' @export
##'

assignDirectory = function(){
    if(Sys.info()[4] == "JOSH_LAPTOP"){
        workingDir <<- "~/GitHub/romeHousePrices"
        savingDir <<- "~/../Dropbox/romeHouseData/Data/"
    } else if(Sys.info()[4] == "joshua-Ubuntu-Linux"){
        workingDir <<- "~/Documents/Github/romeHousePrices"
        savingDir <<- "~/Dropbox/romeHouseData/Data/"
    } else if(Sys.info()[4] =="Michaels-MacBook-Pro-2.local"||
              Sys.info()[4] == "Michaels-MBP-2.lan"){
        workingDir <<- "~/Dropbox/romeHousePrices/" 
        savingDir <<- "~/DropBox/romeHouseData/Data/" #for michael's mac yo
    } else {
        stop("No directory for current user!")
    }
}