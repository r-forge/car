# fancy scatterplot matrices (J. Fox)

# last modified: 24 September 2009 by J. Fox

scatterplotMatrix <- function(x, ...){
	UseMethod("scatterplotMatrix")
}

scatterplotMatrix.formula <- function (x, data=NULL, subset,  ...) {
	m <- match.call(expand.dots = FALSE)
	if (is.matrix(eval(m$data, sys.frame(sys.parent())))) 
		m$data <- as.data.frame(data)
	m$... <- NULL
	m[[1]] <- as.name("model.frame")
	m$formula <- NULL
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
	X <- eval(m, sys.frame(sys.parent()))
	if (!groups) scatterplotMatrix(X, ...)
	else{
		ncol<-ncol(X)
		scatterplotMatrix.default(X[, -ncol], groups=X[, ncol], ...)
	}
}

scatterplotMatrix.default <- function(x, labels=colnames(x), 
	diagonal=c("density", "boxplot", "histogram", "oned", "qqplot", "none"), adjust=1, nclass,
	plot.points=TRUE, smooth=TRUE, spread=smooth && !by.groups, span=.5, reg.line=lm, transform=FALSE,
	ellipse=FALSE, levels=c(.5, .95), robust=TRUE,
	groups, by.groups=FALSE,
	col=rep(palette(), length.out=n.groups + 1), pch=1:n.groups, lwd=1, lwd.smooth=lwd,
	cex=par("cex"), cex.axis=par("cex.axis"), cex.labels=NULL, 
	cex.main=par("cex.main"),
	legend.plot=length(levels(groups)) > 1, row1attop=TRUE, ...){
	spread # force evaluation
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
	if (!(missing(groups))){
		x <- na.omit(cbind(as.data.frame(groups), x))
		groups <- as.factor(as.character(x[, 1]))
		x <- x[,-1]
	}
	else x <- na.omit(x)
	if (missing(nclass)) nclass <- n.bins(x[, 1])
	reg <- function(x, y, col){
		mod<-reg.line(y~x)
		y.hat <- fitted.values(mod)
		x <- model.matrix(mod)[,2]
		min <- which.min(x)
		max <- which.max(x)
		lines(c(x[min], x[max]), c(y.hat[min], y.hat[max]), lty=2, lwd=lwd, col=col)
	}
	# The following panel function adapted from Richard Heiberger
	panel.density <- function(x, ...){
		dens.x <- density(x, adjust = adjust)
		lines(dens.x$x, min(x) + dens.x$y * diff(range(x))/diff(range(dens.x$y)))
		points(x, rep(min(x), length(x)), pch = "|", col = col[1])
	}
	panel.histogram <- function(x, ...){
		par(new=TRUE)
		hist(x, main="", axes=FALSE, nclass=nclass, col=col[2])
	}
	panel.boxplot <- function(x, ...){
		par(new=TRUE)
		boxplot(x, axes=FALSE, main="", col=col[2])
	}
	# The following panel function adapted from Richard Heiberger
	panel.oned <- function(x, ...) {
		range <- range(x)
		delta <- diff(range)/50
		y <- mean(range)
		segments(x - delta, x, x + delta, x, col = col[1])
	}
	panel.qqplot <- function(x, ...){
		par(new=TRUE)
		qqnorm(x, axes=FALSE, xlab="", ylab="", main="", col=col[1])
		qqline(x)
	}
	panel.blank <- function(x, ...) NULL
	which.fn <- match(match.arg(diagonal),
		c("density", "boxplot", "histogram", "oned", "qqplot", "none"))
	diag <- list(panel.density, panel.boxplot, panel.histogram, panel.oned, panel.qqplot, panel.blank)[[which.fn]]
	groups <- as.factor(if(missing(groups)) rep(1, length(x[, 1])) else groups)
	n.groups <- length(levels(groups))
	if (n.groups > length(col) - 1) stop("number of groups exceeds number of available colors")
	if (transform != FALSE | length(transform) == ncol(x)){
		if (transform == TRUE & length(transform) == 1) transform <- box.cox.powers(x)$lambda
		for (i in 1:ncol(x)){
			x[, i] <- box.cox(x[, i], transform[i])
			labels[i] <- paste(labels[i], "^(", round(transform[i],2), ")", sep="")
		}
	}          
	pairs(x, labels=labels,
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
				}
			}
			if (!by.groups){
				if (is.function(reg.line)) abline(reg.line(y ~ x),lty=2, lwd=lwd, col=col[1])
				if (smooth) lowess.line(x, y, col=col[1], span)
				if (ellipse) dataEllipse(x, y, plot.points=FALSE, levels=levels, col=col[1],
						robust=robust, lwd=1)
			}
		}, ...
	)
	if(legend.plot) {
		frac <- 1/ncol(x)
		legend(1 - .95*frac, 0.8*frac,
			legend=levels(groups), pch=pch, col=col[2:(n.groups+1)],
			cex=cumprod(par("fin"))[2]*sqrt(frac)/(sqrt(n.groups)*20))
	}
}

spm <- function(x, ...){
	scatterplotMatrix(x, ...)
}            
