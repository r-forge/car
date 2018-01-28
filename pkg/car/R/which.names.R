# positions of names in a data frame (J. Fox)

# last modified 2018-01-28 by J. Fox

which.names <- function(names, object){
    row.names <- if (inherits(object, "data.frame")) row.names(object) else names(object)
    check <- outer(row.names, names, '==')
    if (!all(matched <- apply(check, 2, any))) 
        warning(paste(paste(names[!matched], collapse=", "), "not matched"))
    result <- which(apply(check, 1, any))
    names(result) <- row.names[result]
    result
    }
	
whichNames <- function(...) which.names(...)
