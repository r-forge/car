# influence index plot  written 9 Dec 09 by S. Weisberg
# 21 Jan 10: added wrapper influenceIndexPlot(). J. Fox
# 30 March 10: bug-fixes and changed arguments, S. Weisberg
# 15 October 13:  Bug-fix on labelling x-axis
# 25 April 2016:  For compatibility with Rcmdr, change na.action=exclude to na.action=na.omit SW.
# 2016-07-23: add ... argument to call to lines(). J. Fox
# 2017-02-12: consolidated id argument
# 2017-11-30: substitute carPalette() for palette(). J. Fox
# 2019-01-02: add lmerMod method and make lm method work for it. J. Fox
# 2019-11-14: change class(x) == "y" to inherits(x, "y")

influenceIndexPlot <- function(model, ...){
    UseMethod("infIndexPlot")
}

infIndexPlot <- function(model, ...){
    UseMethod("infIndexPlot")
}

infIndexPlot.lm <- function(model, vars=c("Cook", "Studentized", "Bonf", "hat"), id=TRUE, grid=TRUE, 
                            main="Diagnostic Plots", ...){
    id <- applyDefaults(id, defaults=list(method="y", n=2, cex=1, col=carPalette()[1], location="lr"), type="id")
    if (isFALSE(id)){
        id.n <- 0
        id.method <- "none"
        labels <- id.cex <- id.col <- id.location <- NULL
    }
    else{
        labels <- id$labels
        if (is.null(labels)) labels <- row.names(model.frame(model))
        id.method <- id$method
        id.n <- if ("identify" %in% id.method) Inf else id$n
        id.cex <- id$cex
        id.col <- id$col
        id.location <- id$location
    }
    # Added for compatibility with Rcmdr
    if(inherits(na.action(model),  "exclude")) model <- update(model, na.action=na.omit)
    # End addition
    what <- pmatch(tolower(vars), 
                   tolower(c("Cook", "Studentized", "Bonf", "hat")))
    if(length(what) < 1) stop("Nothing to plot")
    names <- c("Cook's distance", "Studentized residuals",
               "Bonferroni p-value", "hat-values")
    # check for row.names, and use them if they are numeric.
    op <- par(mfrow=c(length(what), 1), mar=c(1, 4, 0, 2) + .0,
              mgp=c(2, 1, 0), oma=c(6, 0, 6, 0))
    oldwarn <- options()$warn
    options(warn=-1)
    xaxis <- as.numeric(row.names(model.matrix(model)))
    options(warn=oldwarn)
    if (any (is.na(xaxis))) xaxis <- 1:length(xaxis)
    on.exit(par(op))
    outlier.t.test <- pmin(outlierTest(model, order=FALSE, n.max=length(xaxis),
                                       cutoff=length(xaxis))$bonf.p, 1)
    nplots <- length(what)
    plotnum <- 0
    for (j in what){
        plotnum <- plotnum + 1 
        y <- switch(j, cooks.distance(model), rstudent(model),
                    outlier.t.test, hatvalues(model))
        plot(xaxis, y, type="n", ylab=names[j], xlab="", xaxt="n", tck=0.1, ...)
        if(grid){
            grid(lty=1, equilogs=FALSE)
            box()}
        if(j==3) {
            for (k in which(y < 1)) lines(c(xaxis[k], xaxis[k]), c(1, y[k]), ...)}
        else {
            points(xaxis, y, type="h", ...)}  
        points(xaxis, y, type="p", ...)  
        if (j == 2) abline(h=0, lty=2 )
        axis(1, labels= ifelse(plotnum < nplots, FALSE, TRUE))
        showLabels(xaxis, y, labels=labels,
                   method=id.method, n=id.n, cex=id.cex,
                   col=id.col, location=id.location)
    }
    mtext(side=3, outer=TRUE ,main, cex=1.2, line=1)
    mtext(side=1, outer=TRUE, "Index", line=3)
    invisible()
}

infIndexPlot.lmerMod <- function(model, ...){
  infIndexPlot.lm(model, ...)
}
