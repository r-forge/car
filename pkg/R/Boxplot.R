# checked in 19 December 2009 by J. Fox

Boxplot <- function(y, ...){
	UseMethod("Boxplot")
}

Boxplot.default <- function(y, g, labels, id.method=c("y", "identify", "none"), xlab, ylab, ...){
	id.method <- match.arg(id.method)
	if (missing(ylab)) ylab <- deparse(substitute(y))
	if (missing(labels)) labels <- seq(along=y)
	if (missing(g)){
		valid <- complete.cases(y, labels)
		y <- y[valid]
		labels <- labels[valid]
		b <- boxplot(y, ylab=ylab, ...)
		if (id.method == "none") return(invisible(NULL))
		else if (id.method == "identify"){
			res <- identify(rep(1, length(y)), y, labels)
			return(if(length(res) == 0) invisible(NULL) else labels[res])
		}
		else if (length(b$out) > 0){
			sel <- y %in% b$out
			labs <- labels[sel]
			text(1, y[sel], labs, pos=2)
			return(if(length(labs) == 0) invisible(NULL) else labs)
		} 
		else return(invisible(NULL))
	}
	else {
		if (missing(xlab)) xlab=deparse(substitute(g))
		valid <- complete.cases(y, labels, g)
		y <- y[valid]
		labels <- labels[valid]
		g <- g[valid]
		b <- boxplot(split(y, g), ylab=ylab, xlab=xlab, ...)
		g <- as.numeric(g)
		if (id.method == "none") return(invisible(NULL))
		else if (id.method == "identify"){
			res <- identify(g, y, labels)
			return(if(length(res) == 0) invisible(NULL) else labels[res])
		}
		else { 
			midx <- mean(par("usr")[1:2])
			identified <- character(0)
			if (length(b$out) > 0){
				groups <- unique(b$group)
				for (group in groups){
					grp <- g == group
					xx <- y[grp]
					labs <- labels[grp]
					sel <- xx %in% b$out[b$group == group]
					pos <- if (group < midx) 4 else 2
					glabs <- labs[sel]
					text(group, xx[sel], glabs, pos=pos)
					identified <- c(identified, glabs)
				}
			}
			return(if(length(identified) == 0) invisible(NULL) else identified)
		}
	}          
}

Boxplot.formula <- function(formula, data=NULL, subset, na.action=NULL, labels., id.method=c("y", "identify", "none"), xlab, ylab, ...){
	# much of this function adapted from graphics:boxplot.formula
	id.method <- match.arg(id.method)
	m <- match.call(expand.dots = FALSE)
	if (is.matrix(eval(m$data, parent.frame()))) 
		m$data <- as.data.frame(data)
	m$ylab <- m$id.method <- m$... <- NULL
	m$na.action <- na.action
	require(stats, quietly = TRUE)
	m[[1]] <- as.name("model.frame")
	mf <- eval(m, parent.frame())
	if (missing(labels.)) mf$"(labels.)" <- rownames(mf)
	lab.var <- which(names(mf) == "(labels.)")
	if (length(formula) == 3){
		response <- attr(attr(mf, "terms"), "response")
		if (missing(ylab)) ylab <- names(mf)[response]
		if (missing(xlab)) xlab <- names(mf)[-c(response, lab.var)]
		Boxplot(mf[[response]], mf[, -c(response, lab.var)], labels=mf[[lab.var]], xlab=xlab, ylab=ylab, id.method=id.method, ...)
	}
	else if (length(formula) == 2){
		if (missing(ylab)) ylab <- names(mf)[-lab.var]
		Boxplot(mf[, -lab.var], labels=mf[[lab.var]], ylab=ylab, id.method=id.method, ...)
	}
	else stop("improper Boxplot formula")   
}
