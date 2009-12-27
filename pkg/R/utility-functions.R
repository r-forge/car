
# Utility functions (J. Fox)

# last modified 26 December 2009 by J. Fox

# function to find "nice" numbers

nice <- function(x, direction=c("round", "down", "up"), lead.digits=1){
	direction <- match.arg(direction)
	if (length(x) > 1) return(sapply(x, nice, direction=direction, lead.digits=lead.digits))
	if (x == 0) return(0)
	power.10 <- floor(log(abs(x),10))
	if (lead.digits > 1) power.10 <- power.10 - lead.digits + 1
	lead.digit <- switch(direction,
		round=round(abs(x)/10^power.10),
		down=floor(abs(x)/10^power.10),
		up=ceiling(abs(x)/10^power.10))
	sign(x)*lead.digit*10^power.10
}

has.intercept <- function (model, ...) {
	UseMethod("has.intercept")
}

has.intercept.default <- function(model, ...) any(names(coefficients(model))=="(Intercept)")

term.names <- function (model, ...) {
	UseMethod("term.names")
}

term.names.default <- function (model, ...) {
	term.names <- labels(terms(model))
	if (has.intercept(model)) c("(Intercept)", term.names)
	else term.names
}

predictor.names <- function(model, ...) {
	UseMethod("predictor.names")
}

predictor.names.default <- function(model, ...){
	predictors <- attr(terms(model), "variables")
	as.character(predictors[3:length(predictors)])
}

responseName <- function (model, ...) {
	UseMethod("responseName")
}

responseName.default <- function (model, ...) deparse(attr(terms(model), "variables")[[2]])

response <- function(model, ...) {
	UseMethod("response")
}

response.default <- function (model, ...) model.response(model.frame(model))

is.aliased <- function(model){
	!is.null(alias(model)$Complete)
}

df.terms <- function(model, term, ...){
	UseMethod("df.terms")
}

df.terms.default <- function(model, term, ...){
	if (is.aliased(model)) stop("Model has aliased term(s); df ambiguous.")
	if (!missing(term) && 1 == length(term)){
		assign <- attr(model.matrix(model), "assign")
		which.term <- which(term == labels(terms(model)))
		if (0 == length(which.term)) stop(paste(term, "is not in the model."))
		sum(assign == which.term)
	}
	else {
		terms <- if (missing(term)) labels(terms(model)) else term
		result <- numeric(0)
		for (term in terms) result <- c(result, Recall(model, term))
		names(result) <- terms
		result
	}
}

df.terms.multinom <- function (model, term, ...){
	nlev <- length(model$lev)
	if (!missing(term) && 1 == length(term)) {
		assign <- attr(model.matrix(model), "assign")
		which.term <- which(term == labels(terms(model)))
		if (0 == length(which.term))
			stop(paste(term, "is not in the model."))
		sum(assign == which.term) * (nlev - 1)
	}
	else {
		terms <- if (missing(term))
				labels(terms(model))
			else term
		result <- numeric(0)
		for (term in terms) result <- c(result, Recall(model,
					term))
		names(result) <- terms
		result
	}
}

df.terms.polr <- function (model, term, ...){
	if (!missing(term) && 1 == length(term)) {
		assign <- attr(model.matrix(model), "assign")
		which.term <- which(term == labels(terms(model)))
		if (0 == length(which.term))
			stop(paste(term, "is not in the model."))
		sum(assign == which.term)
	}
	else {
		terms <- if (missing(term))
				labels(terms(model))
			else term
		result <- numeric(0)
		for (term in terms) result <- c(result, Recall(model,
					term))
		names(result) <- terms
		result
	}
}

mfrow <- function(n, max.plots=0){
	# number of rows and columns for array of n plots
	if (max.plots != 0 && n > max.plots)
		stop(paste("number of plots =",n," exceeds maximum =", max.plots))
	rows <- round(sqrt(n))
	cols <- ceiling(n/rows)
	c(rows, cols)
}

inv <- function(x) solve(x)

coefnames2bs <- function(g, para.names, parameterPrefix="b"){
	metas <- c("(", ")", "[", "]", "{", "}", ".", "*", "+", "^", "$", ":", "|")
	metas2 <- paste("\\", metas, sep="")
	metas3 <- paste("\\\\", metas, sep="")
	for (i in seq(along=metas))
		para.names <- gsub(metas2[i], metas3[i], para.names) # fix up metacharacters
	para.order <- order(nchar(para.names), decreasing=TRUE) 
	para.names <- para.names[para.order] # avoid partial-name substitution
	std.names <- if ("(Intercept)" %in% para.names)
				paste(parameterPrefix, 0:(length(para.names) - 1), sep = "")
			else paste(parameterPrefix, 1:length(para.names), sep = "")
	std.names.ordered <- std.names[para.order]
	for (i in seq(along=para.names)){
		g <- gsub(para.names[i], std.names.ordered[i], g) 
	}
	list(g=g, std.names=std.names)
}


showLabelsScatter <- function(x, y, labels, id.var = NULL,
	id.method = "mahal", log="", id.cex=.75, id.n=3, id.col=palette()[1], 
	range.x=range(.x), show=TRUE) {
	if (id.method == "none" || id.n == 0 || !show) return(invisible(NULL))
	if(id.n > 0L) {
		if (missing(labels))
			labels <- if (!is.null(id.var)) names(id.var)
				else as.character(seq(along=x))
		getPoints <- function(z) {
			names(z) <- labels
			iid <- seq(length=id.n)
			zs <- z[order(-z)[iid]]
			match(names(zs), labels)
		}
		logged <- function(axis=c("x", "y")){
			axis <- match.arg(axis)
			0 != length(grep(axis, log))
		}
		valid <- complete.cases(x, y)
		x <- x[valid]
		y <- y[valid]
		labels <- labels[valid]
		if (length(id.var) == length(valid)) 
			id.var <- id.var[valid]
		.x <- if (logged("x")) log(x) else x
		.y <- if (logged("y")) log(y) else y
		ind <- if (!is.null(id.var)) {
				if (length(id.var) == length(x)) order(-abs(id.var))[1L:id.n] 
				else if(is.character(id.var)) match(id.var, labels) else id.var
			}
			else switch(id.method,
					x = getPoints(abs(.x - mean(.x))),
					y = getPoints(abs(.y - mean(.y))),
					xy = union(getPoints(abs(.x - mean(.x))),
						getPoints(abs(.y - mean(.y)))),
					mahal= getPoints(rowSums(qr.Q(qr(cbind(1, .x, .y))) ^ 2)))
		ind <- na.omit(ind)
		if (length(ind) == 0) return(invisible(NULL))
		labpos <- c(4, 2)[1 + as.numeric(.x > mean(range.x))]
		text(x[ind], y[ind], labels[ind], cex = id.cex, xpd = TRUE,
			pos = labpos[ind], offset = 0.25, col=id.col)
		return(labels[ind])
	} 
}

