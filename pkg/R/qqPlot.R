# Quantile-comparison plots (J. Fox)

# last modified 30 September 2009 by J. Fox

qqp <- function(...) qqPlot(...)

qqPlot<-function(x, ...) {
	UseMethod("qqPlot")
}

qqPlot.default <- function(x, distribution="norm", ylab=deparse(substitute(x)),
	xlab=paste(distribution, "quantiles"), main=NULL, las=par("las"),
	envelope=.95, identify=c("auto", TRUE, FALSE), labels, col=palette()[2], 
	lwd=2, pch=1, cex=par("cex"), cex.identify=cex,
	line=c("quartiles", "robust", "none"), ...){
	identify <- as.character(identify[1])
	identify <- match.arg(identify, c("auto", TRUE, FALSE))
	if (identify != "FALSE" && missing(labels)){
		labels <- if (is.null(names(x)))
				seq(along=x)
			else names(x)
	}
	line <- match.arg(line)
	good <- !is.na(x)
	ord <- order(x[good])
	ord.x <- x[good][ord]
	q.function <- eval(parse(text=paste("q", distribution, sep="")))
	d.function <- eval(parse(text=paste("d", distribution, sep="")))
	n <- length(ord.x)
	P <- ppoints(n)
	z <- q.function(P, ...)
	plot(z, ord.x, xlab=xlab, ylab=ylab, main=main, las=las, col=col, pch=pch,
		cex=cex)
	if (line == "quartiles" || line == "none"){
		Q.x <- quantile(ord.x, c(.25,.75))
		Q.z <- q.function(c(.25,.75), ...)
		b <- (Q.x[2] - Q.x[1])/(Q.z[2] - Q.z[1])
		a <- Q.x[1] - b*Q.z[1]
		abline(a, b, col=col, lwd=lwd)
	}
	if (line=="robust") {
		coef <- coef(rlm(ord.x ~ z))
		a <- coef[1]
		b <- coef[2]
		abline(a, b)
	}
	conf <- if (envelope == FALSE) .95 else envelope
	zz <- qnorm(1 - (1 - conf)/2)
	SE <- (b/d.function(z, ...))*sqrt(P*(1 - P)/n)
	fit.value <- a + b*z
	upper <- fit.value + zz*SE
	lower <- fit.value - zz*SE
	if (envelope != FALSE) {
		lines(z, upper, lty=2, lwd=lwd, col=col)
		lines(z, lower, lty=2, lwd=lwd, col=col)
	}
	result <- NULL
	if (identify != "FALSE") labels <- labels[good][ord]
	if (identify == "TRUE") {
		selected <- identify(z, ord.x, labels)
		result <- labels[selected]
	}
	else if (identify == "auto"){
		which <- ord.x < lower | ord.x > upper
		pos <- ifelse(z[which] <= mean(range(z)), 4, 2)
		if (any(which)) text(z[which], ord.x[which], labels[which], pos=pos, cex=cex.identify)
		result <- labels[which]
	}
	if (length(result) == 0) invisible(result) else if (is.numeric(result)) sort(result) else result
}

qqPlot.lm <- function(x, xlab=paste(distribution, "Quantiles"),
	ylab=paste("Studentized Residuals(", deparse(substitute(x)), ")", sep=""), main=NULL,
	distribution=c("t", "norm"), line=c("robust", "quartiles", "none"), las=par("las"),
	simulate=TRUE, envelope=.95, identify=c("auto", TRUE, FALSE), labels=names(rstudent), reps=1000, 
	col=palette()[2], lwd=2, pch=1, cex=par("cex"), cex.identify=cex, ...){
	result <- NULL
	distribution <- match.arg(distribution)
	line <- match.arg(line)
	rstudent <- rstudent(x)
	identify <- as.character(identify[1])
	identify <- match.arg(identify, c("auto", TRUE, FALSE))
	if (identify != "FALSE" && missing(labels)){
		labels <- if (is.null(names(rstudent)))
				seq(along=rstudent)
			else names(rstudent)
	}
	good <- !is.na(rstudent)
	rstudent <- rstudent[good]
	labels <- labels[good]
	sumry <- summary(x)
	res.df <- sumry$df[2]
	if(!simulate)
		result <- qqPlot(rstudent, distribution=if (distribution == "t") "t" else "norm", df=res.df-1, line=line,
			main=main, xlab=xlab, ylab=ylab, las=las, envelope=envelope, identify=identify, labels=labels, 
			col=col, lwd=lwd, pch=pch, cex=cex, cex.identify=cex.identify, ...)
	else {
		n <- length(rstudent)        
		ord <- order(rstudent)
		ord.x <- rstudent[ord]
		P <- ppoints(n)
		z <- if (distribution == 't') qt(P, df=res.df-1) else qnorm(P)
		plot(z, ord.x, xlab=xlab, ylab=ylab, main=main, las=las, pch=pch, col=col, cex=cex)
		yhat <- na.omit(fitted.values(x))
		S <- sumry$sigma
		Y <- matrix(yhat, n, reps) + matrix(rnorm(n*reps, sd=S), n, reps)
		X <- model.matrix(x)
		rstud <- apply(rstudent(lm(Y ~ X - 1)), 2, sort)
		lower <- apply(rstud, 1, quantile, prob=(1 - envelope)/2)
		upper <- apply(rstud, 1, quantile, prob=(1 + envelope)/2)
		lines(z, upper, lty=2, lwd=lwd, col=col)
		lines(z, lower, lty=2, lwd=lwd, col=col)
		if (line == "quartiles"){
			Q.x <- quantile(rstudent, c(.25,.75))
			Q.z <- if (distribution == 't') qt(c(.25,.75), df=res.df - 1) else qnorm(c(.25,.75))
			b <- (Q.x[2] - Q.x[1])/(Q.z[2] - Q.z[1])
			a <- Q.x[1] - b*Q.z[1]
			abline(a, b, col=col, lwd=lwd)
		}
		if (line=="robust"){
			coef <- coefficients(rlm(ord.x~z))
			a <- coef[1]
			b <- coef[2]
			abline(a, b, col=col, lwd=lwd)
		}
		labels <- labels[ord]
		if (identify == "TRUE") {
			selected <- identify(z, ord.x, )
			result <- labels[selected]
		}
		else if (identify == "auto"){
			which <- ord.x < lower | ord.x > upper
			pos <- ifelse(z[which] <= mean(range(z)), 4, 2)
			if (any(which)) text(z[which], ord.x[which], labels[which], pos=pos, cex=cex.identify)
			result <- labels[which]
		}
	}
	if (length(result) == 0) invisible(result) else if (is.numeric(result)) sort(result) else result
}

qqPlot.glm <- function(x, ...){
	stop("QQ plot for studentized residuals not available for glm")
}
