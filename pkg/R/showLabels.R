# last modified 27 December 2009 by J. Fox

# methods:
#   'x' x - mean(x)
#   'y' y - mean(y)
#   'xy' both 'x' and 'y'
#   'mahal' rowSums( qr.Q(qr(cbind(1,x,y))) ^ 2

showLabels <- function(x, y, labels=NULL,
	id.var = NULL, id.method = if(is.null(id.var)) "xy" else "none",
	id.n = 3, id.cex=1, id.col=NULL, show=TRUE, ...) {  
	if ( show ==FALSE | (id.n <= 0L & id.method != "identify")) 
		return(invisible(NULL))
	if (is.null(id.col))
		id.col <- palette()[1]
	if (is.null(labels))
		if(!is.null(id.var)) labels <- names(id.var)
	if (is.null(labels))
		labels <- paste(seq_along(x))           
# missing values
	ismissing <- is.na(x) | is.na(y) | is.na(labels)
	if( length(id.method) == length(x) ) 
		ismissing <- ismissing | is.na(labels)
	if( any(ismissing) ) {
		x <- x[!ismissing]
		y <- y[!ismissing]
		labels <- labels[!ismissing]
		if (length(id.var) == length(ismissing)) 
			id.var <- id.var[!ismissing]
	}
	all.inds <- NULL
	if (!is.null(id.var)) {
		all.inds <- showLabels(x, y, labels, NULL, id.method, id.n, id.cex, 
			id.col, show)
		if (length(id.var) == length(x))
			ind <- order(-abs(id.var))[1L:id.n] else
			ind <- if(is.character(id.var)) match(id.var, labels) else id.var
	} 
	else { 
		if (id.method == "xy") { 
			result <- c(showLabels(x, y, labels, NULL, id.method="x", id.n, id.cex, id.col, show),
				showLabels(x, y, labels, NULL, id.method="y", id.n, id.cex, id.col, show))
			if (length(result) == 0) return(invisible(NULL)) else return(result)
		} 
		else {
			if (id.method == "logxy") { 
				result <- c(showLabels(x, y, labels, NULL, id.method="logx", id.n, id.cex, id.col, show),
					showLabels(x, y, labels, NULL, id.method="logy", id.n, id.cex, id.col, show))
				if (length(result) == 0) return(invisible(NULL)) else return(result)
			} 
			else {
				id.var <- switch(id.method,
					none = return(invisible(NULL)),
					identify = {
						result <- labels[identify(x, y, labels, cex=id.cex, col=id.col, ...)]
						if (length(result) == 0) return(invisible(NULL)) else return(result)
					},
					x = x - mean(x, na.rm = TRUE),
					y = y - mean(y, na.rm = TRUE),
					logx = suppressWarnings(if(all(x) > 0) 
								abs(log(x) - mean(log(x), na.rm = TRUE)) else return(invisible(NULL))),
					logy = suppressWarnings(if(all(y) > 0) 
								abs(log(y) - mean(log(y), na.rm = TRUE)) else return(invisible(NULL))),
					mahal = rowSums( qr.Q( qr(cbind(1, x, y) ) )^2),
					logmahal = suppressWarnings(if(all(x) > 0 & all(y) > 0)
								rowSums( qr.Q(qr(cbind(1, log(x), log(y))))^2 ) else return(invisible(NULL)))) }}
		ind <-  order(-abs(id.var))[1L:id.n]
	}
	labpos <- c(4,2)[1+as.numeric(x > mean(range(x)))]
	for (i in ind) {
		text(x[i], y[i], labels[i], cex = id.cex, xpd = TRUE,
			col = id.col, pos = labpos[i], offset = 0.25, ...)} 
	result <- unique(c(all.inds,labels[ind]))
	if (length(result) == 0) return(invisible(NULL)) else return(result)
}






