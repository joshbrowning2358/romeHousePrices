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

setwd(paste0(workingDir, "/.."))
devtools::document("romeHousePrices")
detach("package:romeHousePrices", unload = TRUE)
system("R CMD build romeHousePrices")
packages = dir(".", pattern = "romeHousePrices_.*tar.gz")
versions = gsub("([a-zA-Z]*_|\\.tar\\.gz)", "", packages)
system(paste0("R CMD check romeHousePrices_", max(versions), ".tar.gz"))
install.packages(paste0("romeHousePrices_", max(versions), ".tar.gz"), type = "src", repo = NULL)
