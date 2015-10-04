##' Extract n characters from the right of a string
##' 
##' This function takes a string, and a number and extracts the number characters
##' from the right of the string
##' Taken from http://stackoverflow.com/questions/7963898/extracting-the-last-n-characters-from-a-string-in-r
##'  
##' @param x character vector
##' @param n is the number of characters to extract
##'   
##' @return the n characters from the right of the string
##'
##' @export
##' 



substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
  
}