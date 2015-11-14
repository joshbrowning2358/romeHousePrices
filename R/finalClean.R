##' Final Clean
##' 
##' This function should be applied to any "cleaned" dataset to produce the
##' final dataset.  This function will enforce column types and ranges/factor
##' levels.  Note that misnamed columns will not be corrected.
##' 
##' @param data A data.table object of the dataset.
##' @param response Must be either "warn", "error", or "correct".  If an 
##'   observation fails to meet the formatting requirements, this specifies if a
##'   warning is thrown, an error is throw, or the function attempts to correct
##'   it (stopping if it can't).
##' 
##' @return The final cleaned dataset.
##' 
##' @export
##' 

finalClean = function(data, response = "error"){
    assignDirectory()
    conditions = fread(paste0(savingDir, "dataFormat.csv"))

    
}

##' Clean Column
##' 
##' This is just a helper function for the mapply in the above function.
##' 
##' @param data The data.table object containing the housing price data.  Note 
##'   that this must be a data.table as this function works by updating by 
##'   reference (which is possible only with data.tables).
##' @param ... Column names of the formatting file.
##' @param response Must be either "warn", "error", or "correct".  If an 
##'   observation fails to meet the formatting requirements, this specifies if a
##'   warning is thrown, an error is throw, or the function attempts to correct
##'   it (stopping if it can't).
##'   
##' @return No value is returned, but checks are done which may throw errors and
##'   data is updated.
##'   

cleanColumn = function(data, name, type, min, max, levels, description,
                       response){
    ## Data quality checks
    stopifnot(length(name) == 1)
    stopifnot(length(type) == 1)
    stopifnot(length(min) == 1)
    stopifnot(length(max) == 1)
    stopifnot(length(levels) == 1)
    stopifnot(length(description) == 1)
    
    ## Type check
    if(!is(data[, get(name)], type) & response == "warn"){
        warning("Column ", name, " is not ", type, "!")
    } else if(!is(data[, get(name)], type) & response == "error"){
        stop("Column ", name, " is not ", type, "!")
    } else if(!is(data[, get(name)], type) & response == "correct"){
        data[, c(name) := as(get(name), type)]
    }
    
    if(type == "numeric"){
        minObs = min(data[, get(name)], na.rm = TRUE)
        maxObs = max(data[, get(name)], na.rm = TRUE)
        ## MIN
        if(minObs < min & response == "warn"){
            warning("Column ", name, " has minimum value ", minObs,
                    " which is less than ", min, "!")
        } else if(minObs < min & response == "error"){
            stop("Column ", name, " has minimum value ", minObs,
                 " which is less than ", min, "!")
        } else if(minObs < min & response == "correct"){
            data[get(name) < min, c(name) := NA_real_]
        }
        
        ## MAX
        if(maxObs > max & response == "warn"){
            warning("Column ", name, " has maximum value ", ,maxObs,
                    " which is greater than ", max, "!")
        } else if(maxObs > max & response == "error"){
            stop("Column ", name, " has maximum value ", ,maxObs,
                 " which is greater than ", max, "!")
        } else if(maxObs > max & response == "correct"){
            data[get(name) > max, c(name) := NA_real_]
        }
        
    } else if(type == "character"){
        
    } else if(type == "factor"){
        allowedLevels = strsplit(levels, split = " *, *")[[1]]
        badLevels = data[!get(name) %in% allowedLevels, unique(get(name))]
        if(length(badLevels) > 0 & response == "warn"){
            warning("Invalid levels found for variable ", name, "!  Values ",
                    paste(badLevels, collapse = ", "), " were detected.",
                    sep = "")
        } else if(length(badLevels) > 0 & response == "error"){
            stop("Invalid levels found for variable ", name, "!  Values ",
                 paste(badLevels, collapse = ", "), " were detected.",
                 sep = "")
        } else if(length(badLevels) > 0 & response == "correct"){
            data[get(name) %in% badLevels, c(name) := NA]
        }
    } else if(type == "logical"){
        
    } else if(type == "date"){
        
    } else {
        stop(paste0("type ", type, " not recognized!"))
    }
}