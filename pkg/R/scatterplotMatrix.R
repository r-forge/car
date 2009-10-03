# fancy scatterplot matrices (J. Fox)

# last modified: 2 October 2009 by J. Fox

scatterplotMatrix <- function(x, ...){
	UseMethod("scatterplotMatrix")
}

scatterplotMatrix.formula <- function (x, data=NULL, subset, identify.points="mahal", labels=NULL, ...) {
	m <- match.call(expand.dots = FALSE)
	if (is.matrix(eval(m$data, sys.frame(sys.parent())))) 
		m$data <- as.data.frame(data)
	m$identify.points <- m$labels <- m$formula <- m$... <- NULL
	m[[1]] <- as.name("model.frame")
	if (!inherits(x, "formula") | length(x) != 2) 
		stop("invalid formula")
	rhs <- x[[2]]
	if ("|" != deparse(rhs[[1]])){
		groups <- FALSE
	}
	else{
		groups <- TRUE
		x<-as.character(c(x))
		x<-as.formula(sub("\\|", "+", x))   
	}
	m$formula <-x
	if (missing(data)){ 
		X <- na.omit(eval(m, parent.frame()))
		if (identify.points != FALSE && missing(labels)) labels <- labels[as.numeric(gsub("X", "", row.names(X)))]
	}
	else{
		if (identify.points != FALSE && !missing(labels)) row.names(data) <- labels
		X <- eval(m, parent.frame())
		labels <-if (identify.points != FALSE) row.names(X)
			else NULL
	}
	if (!groups) scatterplotMatrix(X, identify.points=identify.points, labels=labels, ...)
	else{
		ncol<-ncol(X)
		scatterplotMatrix.default(X[, -ncol], groups=X[, ncol], identify.points=identify.points, labels=labels, ...)
	}
}

scatterplotMatrix.default <- function(x, var.labels=colnames(x), 
	diagonal=c("density", "boxplot", "histogram", "oned", "qqplot", "none"), adjust=1, nclass,
	plot.points=TRUE, smooth=TRUE, spread=smooth && !by.groups, span=.5, reg.line=lm, 
	transform=FALSE, family=c("bcPower", "yjPower"),
	ellipse=FALSE, levels=c(.5, .95), robust=TRUE,
	groups=NULL, by.groups=FALSE, identify.points="mahal", id.n=3, labels,
	col=rep(palette(), length.out=n.groups + 1), pch=1:n.groups, lwd=1, lwd.smooth=lwd,
	cex=par("cex"), cex.axis=par("cex.axis"), cex.labels=NULL, 
	cex.main=par("cex.main"), cex.identify=cex,
	legend.plot=length(levels(groups)) > 1, row1attop=TRUE, ...){
	spread # force evaluation
	if (identify.points == TRUE) stop("interactive point identification not permitted")
	family <- match.arg(family)
	lowess.line <- function(x, y, col, span) {
		valid <- complete.cases(x, y)
		x <- x[valid]
		y <- y[valid]
		ord <- order(x)
		x <- x[ord]
		y <- y[ord]
		if (!spread){
			fit <- loess.smooth(x, y, span=span)
			lines(fit$x, fit$y, lwd=lwd.smooth, col=col)
		}
		else{
			fit <- loess(y ~ x, degree=1, family="symmetric", span=span)
			res <- residuals(fit)
			pos <- res > 0
			pos.fit <- loess(res^2 ~ x, span=span, degree=0, family="symmetric", subset=pos)
			neg.fit <- loess(res^2 ~ x, span=span, degree=0, family="symmetric", subset=!pos)
			lines(x, fitted(fit), lwd=lwd.smooth, col=col)
			y.pos <- fitted(fit)[pos] + sqrt(fitted(pos.fit))
			lines(x[pos], y.pos, lwd=lwd.smooth, lty=3, col=col)
			y.neg <- fitted(fit)[!pos] - sqrt(fitted(neg.fit))
			lines(x[!pos], y.neg, lwd=lwd.smooth, lty=3, col=col)
		}
	}
#	label.outliers <- function(x, y, cutoff, labels, col){
#		cutoff <- 2*qf(cutoff, 2, length(x) - 1)
#		X <- na.omit(data.frame(x, y, labels, stringsAsFactors=FALSE))
#		res <- cov.trob(X[, c("x", "y")])
#		d <- mahalanobis(X[, c("x", "y")], res$center, res$cov)
#		which <- which(d > cutoff)
#		if (length(which) == 0) return()
#		x <- X$x
#		y <- X$y
#		labels <- X$labels
#		pos <- ifelse(x[which] <= mean(range(X$x)), 4, 2)
#		text(x[which], y[which], labels[which], pos=pos, col=col, cex=cex.identify)
#	}
	if (identify.points != FALSE && missing(labels)){
		labels <- rownames(x)
		if (is.null(labels)) labels <- as.character(seq(length.out=nrow(x)))
	}
	if (!(missing(groups))){
		x <- na.omit(data.frame(groups, labels, x, stringsAsFactors=FALSE))
		groups <- as.factor(as.character(x[, 1]))
		labels <- x[, 2]
		x <- x[, -(1:2)]
	}
	else x <- na.omit(x)
	if (missing(nclass)) nclass <- "FD"
	reg <- function(x, y, col){
		mod<-reg.line(y ~ x)
		y.hat <- fitted.values(mod)
		x <- model.matrix(mod)[,2]
		min <- which.min(x)
		max <- which.max(x)
		lines(c(x[min], x[max]), c(y.hat[min], y.hat[max]), lty=2, lwd=lwd, col=col)
	}
	legendPlot <- function(){
		usr <- par("usr")
		legend("bottomleft", bg="white",
				legend=levels(groups), pch=pch, col=col[2:(n.groups+1)],
				cex=cex)
	}	
	do.legend <- legend.plot	
# The following panel function adapted from Richard Heiberger
	panel.density <- function(x, ...){
		dens.x <- density(x, adjust = adjust)
		lines(dens.x$x, min(x) + dens.x$y * diff(range(x))/diff(range(dens.x$y)))
		rug(x)
		if (do.legend) legendPlot()
		do.legend <<- FALSE
	}
	panel.histogram <- function(x, ...){
		par(new=TRUE)
		hist(x, main="", axes=FALSE, breaks=nclass, col=col[2])
		if (do.legend) legendPlot()
		do.legend <<- FALSE
	}
	panel.boxplot <- function(x, ...){
		par(new=TRUE)
		boxplot(x, axes=FALSE, main="", col=col[2])
		if (do.legend) legendPlot()
		do.legend <<- FALSE
	}
	# The following panel function adapted from Richard Heiberger
	panel.oned <- function(x, ...) {
		range <- range(x)
		delta <- diff(range)/50
		y <- mean(range)
		segments(x - delta, x, x + delta, x, col = col[1])
		if (do.legend) legendPlot()
		do.legend <<- FALSE
	}
	panel.qqplot <- function(x, ...){
		par(new=TRUE)
		qqnorm(x, axes=FALSE, xlab="", ylab="", main="", col=col[1])
		qqline(x)
		if (do.legend) legendPlot()
		do.legend <<- FALSE
	}
	panel.blank <- function(x, ...){
		if (do.legend) legendPlot()
		do.legend <<- FALSE
	}
	which.fn <- match(match.arg(diagonal),
		c("density", "boxplot", "histogram", "oned", "qqplot", "none"))
	diag <- list(panel.density, panel.boxplot, panel.histogram, panel.oned, panel.qqplot, panel.blank)[[which.fn]]
	groups <- as.factor(if(missing(groups)) rep(1, length(x[, 1])) else groups)
	n.groups <- length(levels(groups))
	if (n.groups > length(col) - 1) stop("number of groups exceeds number of available colors")
	if (transform != FALSE | length(transform) == ncol(x)){
		if (transform == TRUE & length(transform) == 1){
			transform <- if (by.groups) coef(powerTransform(as.matrix(x) ~ groups, family=family), round=TRUE)
						else coef(powerTransform(x, family=family), round=TRUE)
			}
		for (i in 1:ncol(x)){
			x[, i] <- if (family == "bcPower") 
						bcPower(x[, i], transform[i])
					else yjPower(x[, i], transform[i])
			var.labels[i] <- paste(var.labels[i], "^(", round(transform[i],2), ")", sep="")
		}
	}
	labs <- labels
	pairs(x, labels=var.labels, 
		cex.axis=cex.axis, cex.main=cex.main, cex.labels=cex.labels, cex=cex,
		diag.panel=diag, row1attop = row1attop,
		panel=function(x, y, ...){ 
			for (i in 1:n.groups){
				subs <- groups == levels(groups)[i]
				if (plot.points) points(x[subs], y[subs], pch=pch[i], col=col[i + 1], cex=cex)
				if (by.groups){
					if (smooth) lowess.line(x[subs], y[subs], col=col[i + 1], span)
					if (is.function(reg.line)) reg(x[subs], y[subs], col=col[i + 1])
					if (ellipse) dataEllipse(x[subs], y[subs], plot.points=FALSE, 
								levels=levels, col=col[i + 1], robust=robust, lwd=1)
					if (identify.points != FALSE) 
						showExtremes(x[subs], y[subs], labs[subs], ids=identify.points,
							id.n=id.n, col=col[i + 1])
				}
			}
			if (!by.groups){
				if (is.function(reg.line)) abline(reg.line(y ~ x),lty=2, lwd=lwd, col=col[1])
				if (smooth) lowess.line(x, y, col=col[1], span)
				if (ellipse) dataEllipse(x, y, plot.points=FALSE, levels=levels, col=col[1],
						robust=robust, lwd=1)
				if (identify.points != FALSE) showExtremes(x, y, ids=identify.points, 
						id.n=id.n, labs, col=col[1])
			}
		}, ...
	)
}

spm <- function(x, ...){
	scatterplotMatrix(x, ...)
} 



