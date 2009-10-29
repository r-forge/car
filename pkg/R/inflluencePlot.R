# last modified 26 September 2009 by J. Fox

# moved from Rcmdr 5 December 2006

influencePlot <- function(model, ...){
    UseMethod("influencePlot")
    }

influencePlot.lm <- function(model, scale=10, col=c(1,2), identify=c("auto", TRUE, FALSE),
		labels=names(rstud), cex.identify=par("cex"), col.identify=par("col"), ...){
	identify <- as.character(identify[1])
	identify <- match.arg(identify, c("auto", TRUE, FALSE))
	hatval <- hatvalues(model)
	rstud <- rstudent(model)
	cook <- sqrt(cooks.distance(model))
	scale <- scale/max(cook, na.rm=TRUE)
	p <- length(coef(model))
	n <- length(rstud)
	cutoff <- sqrt(4/(n - p))
	plot(hatval, rstud, xlab='Hat-Values',
			ylab='Studentized Residuals', type='n', ...)
	abline(v=c(2, 3)*p/n, lty=2)
	abline(h=c(-2, 0, 2), lty=2)
	points(hatval, rstud, cex=scale*cook, 
			col=ifelse(cooks <- cook > cutoff, col[2], col[1]))
	if (identify == "TRUE"){
		which <- identify(hatval, rstud, labels, col=col.identify,
				cex=cex.identify)
		return(labels[which])
	}
	else if (identify == "auto"){
		noteworthy <- cooks | hatval > 2*p/n | abs(rstud) > 2
		pos <- ifelse((hatval - sum(rev(range(hatval)))/2) <= 0, 4, 2)
		text(hatval[noteworthy], rstud[noteworthy], labels[noteworthy],  pos=pos[noteworthy],
				cex=cex.identify, col=col.identify)
		return(labels[noteworthy])
	}
}
