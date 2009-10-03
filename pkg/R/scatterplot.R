# fancy scatterplots  (J. Fox)

# last modified 2 October 2009

scatterplot <- function(x, ...){
	UseMethod("scatterplot", x)
}

scatterplot.formula <- function (x, data, subset, xlab, ylab, legend.title, identify.points="mahal", labels, ...) {
	na.save <- options(na.action=na.omit)
	on.exit(options(na.save))
	na.pass <- function(dframe) dframe
	m <- match.call(expand.dots=FALSE)
	if (is.matrix(eval(m$data, sys.frame(sys.parent())))) 
		m$data <- as.data.frame(data)
	m$na.action <- na.pass
	m$legend.title <- m$labels <- m$identify.points <- m$xlab <- m$ylab <- m$... <- NULL
	m[[1]] <- as.name("model.frame")
	if (!inherits(x, "formula") | length(x) != 3) 
		stop("invalid formula")    
	x <- as.character(c(x))
	x <- as.formula(sub("\\|", "+", x))
	m$formula <- x
	if (missing(data)){ 
		X <- na.omit(eval(m, parent.frame()))
		if (identify.points != FALSE && missing(labels)) labels <- labels[as.numeric(gsub("X", "", row.names(X)))]
	}
	else{
		if (identify.points != FALSE && !missing(labels)) row.names(data) <- labels
		X <- eval(m, parent.frame())
		if (identify.points != FALSE) labels <- row.names(X)
	}
	names <- names(X)
	if (missing(xlab)) xlab <- names[2]
	if (missing(ylab)) ylab <- names[1]
	if (ncol(X) == 2) scatterplot(X[,2], X[,1], xlab=xlab, ylab=ylab, 
			labels=labels, identify.points=identify.points, ...)
	else {
		if (missing(legend.title)) legend.title <- names[3]
		scatterplot(X[,2], X[,1], groups=X[,3], xlab=xlab, ylab=ylab,  
			legend.title=legend.title, labels=labels, identify.points=identify.points, ...)
	}
}


scatterplot.default <- function(x, y, smooth=TRUE, spread=!by.groups, span=.5, reg.line=lm, boxplots="xy",
	xlab=deparse(substitute(x)), ylab=deparse(substitute(y)), las=par("las"),
	lwd=1, lwd.smooth=lwd, identify.points="mahal", id.n=3, labels, log="", jitter=list(), xlim=NULL, ylim=NULL,
	cex=par("cex"), cex.axis=par("cex.axis"), cex.lab=par("cex.lab"), 
	cex.main=par("cex.main"), cex.sub=par("cex.sub"), cex.identify=cex,
	groups, by.groups=!missing(groups), legend.title=deparse(substitute(groups)), 
	ellipse=FALSE, levels=c(.5, .95), robust=TRUE,
	col=rep(palette(), length.out=n.groups + 1), pch=1:n.groups, 
	legend.plot=!missing(groups), reset.par=TRUE, ...){
	logged <- function(axis=c("x", "y")){
		axis <- match.arg(axis)
		0 != length(grep(axis, log))
	}
	lowess.line <- function(x, y, col, span) {
		if (logged("x")) x <- log(x)
		if (logged("y")) y <- log(y)
		valid <- complete.cases(x, y)
		x <- x[valid]
		y <- y[valid]
		ord <- order(x)
		x <- x[ord]
		y <- y[ord]
		if (!spread){
			fit <- loess.smooth(x, y, span=span)
			x <-if (logged("x")) exp(fit$x) else fit$x  
			y <-if (logged("y")) exp(fit$y) else fit$y
			lines(x, y, lwd=lwd.smooth, col=col)
		}
		else{
			fit <- loess(y ~ x, degree=1, family="symmetric", span=span)
			res <- residuals(fit)
			pos <- res > 0
			pos.fit <- loess(res^2 ~ x, span=span, degree=0, family="symmetric", subset=pos)
			neg.fit <- loess(res^2 ~ x, span=span, degree=0, family="symmetric", subset=!pos)
			if (logged("x")) x <- exp(x)
			y <- if (logged("y")) exp(fitted(fit)) else fitted(fit) 
			lines(x, y, lwd=lwd.smooth, col=col)
			y.pos <- if (logged("y")) exp(fitted(fit)[pos] + sqrt(fitted(pos.fit)))  
				else fitted(fit)[pos] + sqrt(fitted(pos.fit))
			lines(x[pos], y.pos, lwd=lwd.smooth, lty=3, col=col)
			y.neg <- if (logged("y")) exp(fitted(fit)[!pos] - sqrt(fitted(neg.fit)))
				else fitted(fit)[!pos] - sqrt(fitted(neg.fit))
			lines(x[!pos], y.neg, lwd=lwd.smooth, lty=3, col=col)
		}
	}
	reg <- function(x, y, col){
		if (logged("x")) x <- log(x)
		if (logged("y")) y <- log(y)
		mod <- reg.line(y ~ x)
		y.hat <- fitted.values(mod)
		x <- model.matrix(mod)[, 2]
		min <- which.min(x)
		max <- which.max(x)
		if (!logged("x")){
			x1 <- x[min]
			x2 <- x[max]
		}
		else {
			x1 <- exp(x[min])
			x2 <- exp(x[max])
		}
		if (!logged("y")){
			y1 <- y.hat[min]
			y2 <- y.hat[max]
		}
		else {
			y1 <- exp(y.hat[min])
			y2 <- exp(y.hat[max])
		}
		lines(c(x1, x2), c(y1, y2), lty=2, lwd=lwd, col=col)
	}
	hbox <- function(x){
		if (logged("x")){
			log.x <- "x"
			.x <- log(x)		
		}
		else {
			log.x <- ""
			.x <- x
		}
		plot(x, seq(0, 1, length=length(x)), type="n", axes=FALSE, xlab="", ylab="", log=log.x, xlim=xlim)
		res <- boxplot.stats(.x, coef = 1.5, do.conf=FALSE)
		if (logged("x")){
			res$stats <- exp(res$stats)
			if (!is.null(res$out)) res$out <- exp(res$out)
		}
		LW <- res$stats[1]
		Q1 <- res$stats[2]
		M <- res$stats[3]
		Q3 <- res$stats[4]
		UW <- res$stats[5]
		lines(c(Q1, Q1, Q3, Q3, Q1), c(0, 1, 1, 0, 0))
		lines(c(M, M), c(0, 1))
		lines(c(LW, Q1), c(.5, .5))
		lines(c(Q3, UW), c(.5, .5))
		if (!is.null(res$out)) points(res$out, rep(.5, length(res$out)), cex=cex)
	}
	vbox <- function(y){
		if (logged("y")){
			log.y <- "y"
			.y <- log(y)
		}
		else {
			log.y <- ""
			.y <- y
		}
		plot(seq(0, 1, length=length(y)), y, type="n", axes=FALSE, xlab="", ylab="", log=log.y, ylim=ylim)
		res <- boxplot.stats(.y, coef = 1.5, do.conf=FALSE)
		if (logged("y")){
			res$stats <- exp(res$stats)
			if (!is.null(res$out)) res$out <- exp(res$out)
		}
		LW <- res$stats[1]
		Q1 <- res$stats[2]
		M <- res$stats[3]
		Q3 <- res$stats[4]
		UW <- res$stats[5]
		lines(c(0, 1, 1, 0, 0), c(Q1, Q1, Q3, Q3, Q1))
		lines(c(0, 1), c(M, M))
		lines(c(.5, .5), c(LW, Q1))
		lines(c(.5, .5), c(Q3, UW))
		if (!is.null(res$out)) points(rep(.5, length(res$out)), res$out, cex=cex)
	}
#	label.outliers <- function(x, y, cutoff, labels, col){
#		if (logged("x")) x <- log(x)
#		if (logged("y")) y <- log(y)
#		cutoff <- 2*qf(cutoff, 2, length(x) - 1)
#		X <- na.omit(data.frame(x, y, labels, stringsAsFactors=FALSE))
#		res <- cov.trob(X[, c("x", "y")])
#		d <- mahalanobis(X[, c("x", "y")], res$center, res$cov)
#		which <- which(d > cutoff)
#		if (length(which) == 0) return(NULL)
#		x <- X$x
#		y <- X$y
#		labels <- X$labels
#		pos <- ifelse(x[which] <= mean(range(X$x)), 4, 2)
#		if (logged("x")) x <- exp(x)
#		if (logged("y")) y <- exp(y)
#		text(x[which], y[which], labels[which], pos=pos, col=col, cex=cex.identify)
#		labels[which]
#	}
	# force evaluation of some arguments
	by.groups
	legend.plot
	legend.title
	spread 
	if (identify.points != FALSE && missing(labels)){
		labels <- if (is.null(names(y)))
				seq(along=y)
			else names(y)
	}
	mar <- par("mar")
	mfcol <- par("mfcol")
	if (reset.par) on.exit(par(mar=mar, mfcol=mfcol))
	if( FALSE == boxplots) boxplots <- ""
	if (!missing(groups)){
		if (identify.points != FALSE){
			data <- na.omit(data.frame(groups, x, y, labels, stringsAsFactors=FALSE))
			groups <- data[,1]
			.x <- data[,2]
			.y <- data[,3]
			labels <- data[,4]
		}
		else {
			data <- na.omit(data.frame(groups, x, y))
			groups <- data[,1]
			.x <- data[,2]
			.y <- data[,3]
		}
		top <- if (legend.plot) 4 + length(levels(as.factor(groups)))
			else mar[3]
	}
	else{
		.x <- x
		.y <- y
		top <- mar[3]
	}
	groups <- as.factor(if(missing(groups)) rep(1, length(.x)) else as.character(groups))
	layout(matrix(c(1, 0, 3, 2), 2, 2),
		widths = c(5, 95),
		heights= c(95, 5))
	par(mar=c(mar[1], 0, top, 0))
	if (length(grep("y", boxplots)) > 0) vbox(.y) 
	else plot(0, 0, xlab="", ylab="", axes=FALSE, type="n", xlim=xlim, ylim=ylim)
	par(mar=c(0, mar[2], 0, mar[4]))
	if (length(grep("x", boxplots)) > 0) hbox(.x) 
	else plot(0, 0, xlab="", ylab="", axes=FALSE, type="n", xlim=xlim, ylim=ylim)
	par(mar=c(mar[1:2], top, mar[4]))
	plot(.x, .y, xlab=xlab, ylab=ylab, las=las, log=log, cex=cex, cex.axis=cex.axis, cex.lab=cex.lab,
		cex.main=cex.main, cex.sub=cex.sub, type="n", xlim=xlim, ylim=ylim, ...)
	n.groups <- length(levels(groups))
	if (n.groups > length(col) - 1) stop("number of groups exceeds number of available colors")
	indices <- NULL
	range.x <- if (logged("x")) range(log(.x)) else range(.x)
	for (i in 1:n.groups){
		subs <- groups == levels(groups)[i]
		points(if (is.null(jitter$x) || jitter$x == 0) .x[subs] else jitter(.x[subs], factor=jitter$x), 
			if (is.null(jitter$y) || jitter$y == 0) .y[subs] else jitter(.y[subs], factor=jitter$y), 
			pch=pch[i], col=col[i + 1], cex=cex)
		if (by.groups){
			if (smooth) lowess.line(.x[subs], .y[subs], col=col[i + 1], span=span)
			if (is.function(reg.line)) reg(.x[subs], .y[subs], col=col[i + 1])
			if (ellipse) {
				X <- na.omit(data.frame(x=.x[subs], y=.y[subs]))
				if (logged("x")) X$x <- log(x)
				if (logged("y")) X$y <- log(y)
				with(X, dataEllipse(x, y, plot.points=FALSE, lwd=1, log=log,
					levels=levels, col=col[i + 1], robust=robust))
			}
		}
		if (!is.logical(identify.points)) 
			indices <- c(indices, showExtremes(
					.x[subs], 
					.y[subs], 
					labels=labels[subs], ids=identify.points, log=log, id.n=id.n, cex.id=cex.identify, col=col[i + 1],
					range.x=range.x))
	}
	if (!by.groups){
		if (smooth) lowess.line(.x, .y, col=col[1], span=span)
		if (is.function(reg.line)) reg(.x, .y, col=col[1])
		if (ellipse) {
			X <- na.omit(data.frame(x=.x, y=.y))
			if (logged("x")) X$x <- log(X$x)
			if (logged("y")) X$y <- log(X$y)
			with(X, dataEllipse(x, y, plot.points=FALSE, lwd=1, log=log, levels=levels, col=col[1],
				robust=robust))
		}
		if (!is.logical(identify.points)) indices <- showExtremes(
				.x, 
				.y,
				labels=labels, ids=identify.points, log=log, id.n=id.n, cex.id=cex.identify, col=col[1])
	}
	if (legend.plot) {
		xpd <- par(xpd=TRUE)
		on.exit(par(xpd=xpd), add=TRUE)
		usr <- par("usr")
		legend(usr[1], usr[4] + 1.2*top*strheight("x"), legend=levels(groups), 
			pch=pch, col=col[2:(n.groups+1)], pt.cex=cex, cex=cex.lab, title=legend.title)
	}
	if (identify.points == TRUE) indices <- labels[identify(.x, .y, labels)]
	if (is.null(indices)) invisible(indices) else if (is.numeric(indices)) sort(indices) else indices
}

sp <- function(...) scatterplot(...)
