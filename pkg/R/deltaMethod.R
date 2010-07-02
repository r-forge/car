#-------------------------------------------------------------------------------
# Revision history:
# 2009-10-29: renamed var argument to .vcov; tidied code. John
# 2010-07-02; added method for survreg objects.
#-------------------------------------------------------------------------------

deltaMethod <- function (object, ...) {
	UseMethod("deltaMethod")
}

deltaMethod.default <- function (object, g, vcov., func=g, ...) {
	if (!is.character(g)) 
		stop("The argument 'g' must be a character string")
	coefest <- object
	charSubst <- function(x, oldchar) {
		sapply(x, function(x) paste(unlist(strsplit(x, oldchar)), 
					collapse = "_"))
	}
	g <- charSubst(g, oldchar = ":")
	for (c in c(":", "\\^", " ")) {
		names(coefest) <- charSubst(names(coefest), oldchar = c)
	}
	g <- parse(text = g)
	q <- length(coefest)
	for (i in 1:q) {
		assign(names(coefest)[i], coefest[i])
	}   
	est <- eval(g)
	names(est) <- NULL
	gd <- NULL
	for (i in 1:q) {
		gd <- c(gd, eval(D(g, names(coefest)[i])))
	}
	se.est <- as.vector(sqrt(t(gd) %*% vcov. %*% gd))
	data.frame(Estimate = est, SE = se.est, row.names = c(func))
}

deltaMethod.lm <- function (object, g, vcov. = vcov, parameterPrefix = "b", ...) {
	metas <- c("(", ")", "[", "]", "{", "}", ".", "*", "+", "^", "$", ":", "|")
	metas2 <- paste("\\", metas, sep="")
	metas3 <- paste("\\\\", metas, sep="")
	para <- coef(object)
	para.names <- names(para)
	for (i in seq(along=metas))
		para.names <- gsub(metas2[i], metas3[i], para.names) # fix up metacharacters
	para.order <- order(nchar(para.names), decreasing=TRUE) 
	para.names <- para.names[para.order] # avoid partial-name substitution
	std.names <- if ("(Intercept)" %in% names(para)) 
			paste(parameterPrefix, 0:(length(para) - 1), sep = "")
		else paste(parameterPrefix, 1:length(para), sep = "")
	std.names.ordered <- std.names[para.order]
	func <- g
	for (i in seq(along=para.names)){
		g <- gsub(para.names[i], std.names.ordered[i], g) 
	}
	vcov. <- if (is.function(vcov.)) 
			vcov.(object)
		else vcov.
	names(para) <- std.names
	deltaMethod.default(para, g, vcov., func)
}

# nls has named parameters so parameterPrefix is ignored
deltaMethod.nls <- function(object, g, vcov.=vcov,...){
	vcov. <- if(is.function(vcov.)) vcov.(object)
	deltaMethod.default(coef(object), g, vcov.)
}

deltaMethod.multinom <- function(object, g, vcov.=vcov, parameterPrefix="b", ...){
	out <- NULL
	coefs <- coef(object)
	if (!is.matrix(coefs)) {
		nn <- names(coefs)
		coefs <- matrix(coefs, nrow=1)
		colnames(coefs) <- nn
	}
	nc <- dim(coefs)[2]
	for (i in 1:dim(coefs)[1]){
		para <- coefs[i,]
		names(para) <- if ("(Intercept)" %in% names(para))
				paste(parameterPrefix, 0:(length(para)-1), sep="") else
				paste(parameterPrefix, 1:length(para), sep="")
		ans <- deltaMethod.default(para, g, vcov.(object)[(i - 1) + 1:nc, (i - 1) + 1:nc])
		rownames(ans)[1] <- paste(rownames(coefs)[i], rownames(ans)[1])
		out <- rbind(out,ans)
	}
	out}

deltaMethod.polr <- function(object,g,vcov.=vcov,...){
	sel <- 1:(length(coef(object)))
	vcov. <- if(is.function(vcov.)) vcov.(object)[sel, sel]
	deltaMethod.lm(object, g, vcov., ...)
}

# new method for survreg objects.
deltaMethod.survreg <- function (object, g, vcov. = vcov, parameterPrefix = "b", ...) {
	metas <- c("(", ")", "[", "]", "{", "}", ".", "*", "+", "^", "$", ":", "|")
	metas2 <- paste("\\", metas, sep="")
	metas3 <- paste("\\\\", metas, sep="")
	para <- c(coef(object), object$icoef[2])
	para.names <- names(para)
	for (i in seq(along=metas))
		para.names <- gsub(metas2[i], metas3[i], para.names) # fix up metacharacters
	para.order <- order(nchar(para.names), decreasing=TRUE) 
	para.names <- para.names[para.order] # avoid partial-name substitution
	std.names <- if ("(Intercept)" %in% names(para)) 
			paste(parameterPrefix, 0:(length(para) - 1), sep = "")
		else paste(parameterPrefix, 1:length(para), sep = "")
	std.names.ordered <- std.names[para.order]
	func <- g
	for (i in seq(along=para.names)){
		g <- gsub(para.names[i], std.names.ordered[i], g) 
	}
	vcov. <- if (is.function(vcov.)) 
			vcov.(object)
		else vcov.
	names(para) <- std.names
	deltaMethod.default(para, g, vcov., func)
}

t2 <- survreg(Surv(durable, durable>0, type='left') ~ -1 + age + quant,
	            data=tobin, dist='gaussian')




