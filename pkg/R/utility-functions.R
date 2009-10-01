
# Utility functions (J. Fox)

# last modified 1 October 2009 by J. Fox

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

has.intercept<-function (model, ...) {
	UseMethod("has.intercept")
}

has.intercept.default<-function(model, ...) any(names(coefficients(model))=="(Intercept)")



term.names<-function (model, ...) {
	UseMethod("term.names")
}

term.names.default<-function (model, ...) {
	term.names<-labels(terms(model))
	if (has.intercept(model)) c("(Intercept)", term.names)
	else term.names
}



predictor.names<-function(model, ...) {
	UseMethod("predictor.names")
}

predictor.names.default<-function(model, ...){
	predictors<-attr(terms(model),"variables")
	as.character(predictors[3:length(predictors)])
}



responseName<-function (model, ...) {
	UseMethod("responseName")
}

responseName.default<-function (model, ...) deparse(attr(terms(model), "variables")[[2]])

response<-function(model, ...) {
	UseMethod("response")
}

response.default<-function (model, ...) model.response(model.frame(model))

is.aliased<-function(model){
	!is.null(alias(model)$Complete)
}

df.terms<-function(model, term, ...){
	UseMethod("df.terms")
}


df.terms.default<-function(model, term, ...){
	if (is.aliased(model)) stop("Model has aliased term(s); df ambiguous.")
	if (!missing(term) && 1==length(term)){
		assign<-attr(model.matrix(model),"assign")
		which.term<-which(term==labels(terms(model)))
		if (0==length(which.term)) stop(paste(term, "is not in the model."))
		sum(assign==which.term)
	}
	else {
		terms<-if (missing(term)) labels(terms(model)) else term
		result<-numeric(0)
		for (term in terms) result<-c(result, Recall(model, term))
		names(result)<-terms
		result
	}
}

df.terms.multinom <- function (model, term, ...)
{
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

df.terms.polr <- function (model, term, ...)
{
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
	if (max.plots != 0 & n > max.plots)
		stop(paste("number of plots =",n," exceeds maximum =", max.plots))
	rows <- round(sqrt(n))
	cols <- ceiling(n/rows)
	c(rows, cols)
}



