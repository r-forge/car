# changed point marking, 25 November 2009 by S. Weisberg
#  deleted the cutoff for Cook's D, and the coloring of the circles
#  inserted default labeling of the id.n largest Cook D.
# 13 January 2009: changed to label points by all of hatvalues,
#  studentized residuals, and Cook's Ds. J. Fox
# 14 April 2010: set id.n = 0. J. Fox

# moved from Rcmdr 5 December 2006

influencePlot <- function(model, ...){
    UseMethod("influencePlot")
    }

influencePlot.lm <- function(model, scale=10, 
#    col=c(1,2), 
#    id.var = cooks.distance(model), 
    labels,
#    id.method = "none",
    id.n = 0, id.cex=1, id.col=NULL,
    ...){ 
	hatval <- hatvalues(model)
	rstud <- rstudent(model)
	if (missing(labels)) labels <- names(rstud)
	cook <- sqrt(cooks.distance(model))
	scale <- scale/max(cook, na.rm=TRUE)
	p <- length(coef(model))
	n <- length(rstud)
#	cutoff <- sqrt(4/(n - p))
	plot(hatval, rstud, xlab='Hat-Values',
			ylab='Studentized Residuals', type='n', ...)
	abline(v=c(2, 3)*p/n, lty=2)
	abline(h=c(-2, 0, 2), lty=2)
#	points(hatval, rstud, cex=scale*cook, 
#			col=ifelse(cooks <- cook > cutoff, col[2], col[1]))
	points(hatval, rstud, cex=scale*cook)
#	noteworthy <- showLabels(hatval, rstud, labels=labels, 
#            id.var=id.var, id.method=id.method, id.n=id.n, id.cex=id.cex,
#            id.col=id.col)
	which.rstud <- order(abs(rstud), decreasing=TRUE)[1:id.n]
	which.cook <- order(cook, decreasing=TRUE)[1:id.n]
	which.hatval <- order(hatval, decreasing=TRUE)[1:id.n]
	which.all <- union(which.rstud, union(which.cook, which.hatval))
	noteworthy <- showLabels(hatval, rstud, labels=labels, id.var=which.all, id.n=id.n,
		id.cex=id.cex, id.col=id.col)
  	if (length(noteworthy > 0))
	return(data.frame(StudRes=rstud[noteworthy], Hat=hatval[noteworthy],
	        CookD=cook[noteworthy]))
  }
