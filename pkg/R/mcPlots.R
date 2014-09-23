# September 22, 2014 mcPlots, by S. Weisberg
# 'mc' stands for Marginal and Conditional:  for the specified regressor X in model, 
# the marginal plot of Y vs X with both centered is plotted at the left and
# e(Y|Z) vs e(X|Z) on the right in the same scale.


mcPlots <- function(model, terms=~., intercept=FALSE, layout=NULL, ask, 
		main, ...){
	terms <- if(is.character(terms)) paste("~",terms) else terms
	vform <- update(formula(model),terms)
	if(any(is.na(match(all.vars(vform), all.vars(formula(model))))))
		stop("Only predictors in the formula can be plotted.")
	terms.model <- attr(attr(model.frame(model), "terms"), "term.labels")
	terms.vform <- attr(terms(vform), "term.labels")
	terms.used <- match(terms.vform, terms.model)
	mm <- model.matrix(model) 
	model.names <- attributes(mm)$dimnames[[2]]
	model.assign <- attributes(mm)$assign
	good <- model.names[!is.na(match(model.assign, terms.used))]
	if (intercept) good <- c("(Intercept)", good)
	nt <- length(good)
	if (nt == 0) stop("No plots specified")
	if (missing(main)) main <- if (nt == 1) paste("Added-Variable Plot:", good) else "Added-Variable Plots"
  if (nt == 0) stop("No plots specified")
  if (nt > 1 & (is.null(layout) || is.numeric(layout))) {
    if(is.null(layout)){
         layout <- switch(min(nt, 4), c(1, 2), c(2, 2), c(3, 2), c(4, 2))
#        layout <- switch(min(nt, 9), c(1, 1), c(1, 2), c(2, 2), c(2, 2), 
#                            c(3, 2), c(3, 2), c(3, 3), c(3, 3), c(3, 3))
    }
    ask <- if(missing(ask) || is.null(ask)) layout[1] < nt else ask
    op <- par(mfrow=layout, ask=ask, no.readonly=TRUE, 
            oma=c(0, 0, 1.5, 0), mar=c(5, 4, 1, 2) + .1)
    on.exit(par(op))
    }
	res <- as.list(NULL)
	for (term in good) res[[term]] <- mcPlot(model, term, new=FALSE, ...)
	mtext(side=3,outer=TRUE,main, cex=1.2)
	invisible(res)
}

mcPlot <- function(model, ..., marginal.scale=TRUE, new=TRUE){
  if(new){
    op <- par(mfrow=c(1, 2))
    on.exit(par(op))
  }
  marginalPlot(model, ...)
  avPlot(model, ..., marginal.scale=marginal.scale)
}

marginalPlot <-  function(model, ...) UseMethod("marginalPlot")

marginalPlot.lm <- function(model, variable,
		id.method = list(abs(residuals(model, type="pearson"))),
		labels, 
		id.n = if(id.method[1]=="identify") Inf else 0,
		id.cex=1, id.col=palette()[1],
		col = palette()[1], col.lines = palette()[2],
		xlab, ylab, pch = 1, lwd = 2, main=paste("Centered Marginal Plot:", variable), grid=TRUE,
		ellipse=FALSE, ellipse.args=NULL, ...){
	variable <- if (is.character(variable) & 1 == length(variable))
				variable
			else deparse(substitute(variable))
	if(missing(labels)) 
		labels <- names(residuals(model)[!is.na(residuals(model))])
	else deparse(substitute(variable))
	mod.mat <- model.matrix(model)
	var.names <- colnames(mod.mat)
	var <- which(variable == var.names)
	if (0 == length(var))
		stop(paste(variable, "is not a column of the model matrix."))
	response <- response(model)
	responseName <- responseName(model)
	if (is.null(weights(model)))
		wt <- rep(1, length(response))
	else wt <- weights(model)
  res <- lm(cbind(mod.mat[, var], response) ~ 1, weights=wt)$residuals
	xlab <- if(missing(xlab)) paste(var.names[var], " (centered)") else xlab
	ylab <- if(missing(ylab)) paste(responseName, " (centered)")  else ylab
	plot(res[, 1], res[, 2], xlab = xlab, ylab = ylab, type="n", main=main, ...)
	if(grid){
		grid(lty=1, equilogs=FALSE)
		box()}
	points(res[, 1], res[, 2], col=col, pch=pch, ...)
	abline(lsfit(res[, 1], res[, 2], wt = wt), col = col.lines, lwd = lwd)
	if (ellipse) {
		ellipse.args <- c(list(res, add=TRUE, plot.points=FALSE), ellipse.args)
		do.call(dataEllipse, ellipse.args)
	}
	showLabels(res[, 1],res[, 2], labels=labels, 
			id.method=id.method, id.n=id.n, id.cex=id.cex, 
			id.col=id.col) 
}


