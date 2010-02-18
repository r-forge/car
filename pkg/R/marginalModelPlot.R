#############################################
# marginal model plots    Rev 12/30/09
# To do:
# If u has two levels, loess goes nuts.  Check and fix.
# Allow a Groups arg that will draw the plot for the specified group
# write mmpControl to control margins in the plot.
# BUG:  sd's are WRONG with weights; see cards data
#############################################
marginalModelPlot <- function(...){mmp(...)}
mmp <- function(m, ...){UseMethod("mmp")}

mmp.lm <- 
function (m, variable, mean = TRUE, sd = FALSE,
    xlab = deparse(substitute(variable)), degree = 1, span = 2/3, key=TRUE,
    lineColors = palette()[c(4,2)], 
    ...)
{
    mmp.default(m, variable, mean, sd, xlab, degree, span, key, lineColors, ...)
}

mmp.default <-
function (m, variable, mean = TRUE, sd = FALSE,
    xlab = deparse(substitute(variable)), degree = 1, span = 2/3, key=TRUE,
    lineColors = palette()[c(4,2)], 
    id.var=NULL, labels, id.method="y", id.n=3, id.cex=1, id.col=NULL, ...)
{
    if (missing(variable)) {
        xlab <- "Fitted values"
        u <- fitted(update(m,na.action=na.exclude))
    } else {
        u <- variable}
    if(missing(labels)) labels <- names(residuals(m)[!is.na(residuals(m))])
    na.cases <- attr(m$model,"na.action")
    if(length(na.cases)>0) u <- u[-na.cases]
    zpred <- function(...){pmax(predict(...),0)}
    plot(u, m$model[, 1], xlab = xlab, ylab = colnames(m$model[1]),
        ...)
    if(key){
       outerLegend(c("Data", "Model"), lty=1:2, col=1:2,
          bty="n", cex=0.75, fill=1:2, border=1:2, horiz=TRUE, offset=0)
    #mtext(side=3, line=1.0, outer=FALSE, "Data (solid)", adj=0, cex=0.7, col=lineColors[1])
    #mtext(side=3, line=0.1, outer=FALSE, "Model (dashed)", adj=0, cex=0.7, col=lineColors[2])
       }
 #   if(key) mtext( side=3, line=0.1, outer=FALSE, c("Data (solid)","Model (dashed)"), adj=c(0, 1), 
 #          cex=0.7, col=lineColors)
    loess.y <- loess(m$model[, 1] ~ u, degree = degree,
        span = span)
    loess.yhat <- loess(predict(m) ~ u, degree = degree,
        span = span)
    new <- seq(min(u), max(u), length = 200)
    if (mean == TRUE) {
        lines(new, predict(loess.y, data.frame(u = new)), lty = 1,
            col = lineColors[1])
        lines(new, predict(loess.yhat, data.frame(u = new)),
            lty = 2, col = lineColors[2])
    }
    if (sd == TRUE) {
        loess.y.var <- loess(residuals(loess.y)^2 ~ u, degree = degree,
            span = span)
        lines(new, predict(loess.y, data.frame(u = new)) +
            sqrt(zpred(loess.y.var,data.frame(u = new))), lty = 1, col = lineColors[1])
        lines(new, predict(loess.y, data.frame(u = new)) - sqrt(zpred(loess.y.var,
            data.frame(u = new))), lty = 1, col = lineColors[1])
        loess.yhat.var <- loess(residuals(loess.yhat)^2 ~ u,
            degree = degree, span = span)
        s2 <- summary(m)$sigma^2
        lines(new, predict(loess.yhat, data.frame(u = new)) +
            sqrt(s2 + zpred(loess.yhat.var, data.frame(u = new))),
            lty = 2, col = lineColors[2])
        lines(new, predict(loess.yhat, data.frame(u = new)) -
            sqrt(s2 + zpred(loess.yhat.var, data.frame(u = new))),
            lty = 2, col = lineColors[2])
    }    
    showLabels(u, m$model[, 1], labels=labels,
        id.var=id.var, id.method=id.method, id.n=id.n, id.cex=id.cex,
        id.col=id.col)
}

mmp.glm <- function (m, variable, mean = TRUE, sd = FALSE,
    xlab = deparse(substitute(variable)), degree = 1, span = 2/3, key=TRUE,
    lineColors = palette()[c(4,2)],
    id.var=NULL, labels, id.method="y", id.n=3, id.cex=1, id.col=NULL, ...)
{
    if (missing(variable)) {
        xlab <- "Linear Predictor"
        u <- fitted(update(m,na.action=na.exclude))
    }  else {
        u <- variable }
    if(missing(labels)) labels <- names(residuals(m)[!is.na(residuals(m))])
    na.cases <- attr(m$model,"na.action")
    if(length(na.cases)>0) u <- u[-na.cases]
    fr.mmp <- function(family, x) {
        if (family == "binomial")
            pmax(0, pmin(1, x))
        else if (family == "poisson")
            pmax(0, x)
        else if (family == "gamma")
            pmax(0, x)
        else x
    }
    response <- m$model[, 1]
    fam <- m$family$family
    if (is.matrix(response))
        response <- response[, 1]/apply(response, 1, sum)
    plot(u, response, xlab = xlab, ylab = colnames(m$model[1]),
        ...)
    if(key){
    outerLegend(c("Data", "Model"), lty=1:2, col=1:2,
          bty="n", cex=0.75, fill=1:2, border=1:2, horiz=TRUE, offset=0)
    #mtext(side=3, line=1.0, outer=FALSE, "Data (solid)", adj=0, cex=0.7, col=lineColors[1])
    #mtext(side=3, line=0.1, outer=FALSE, "Model (dashed)", adj=0, cex=0.7, col=lineColors[2])
       }
    loess.y <- loess(response ~ u, degree = degree, span = span)
    loess.yhat <- loess(predict(m, type = "response") ~
        u, degree = degree, span = span)
    new <- seq(min(u), max(u), length = 200)
    pred.loess.y <- fr.mmp(fam, predict(loess.y, data.frame(u = new)))
    pred.loess.yhat <- fr.mmp(fam, predict(loess.yhat, data.frame(u = new)))
    if (mean == TRUE) {
        lines(new, pred.loess.y, lty = 1, col = lineColors[1])
        lines(new, pred.loess.yhat, lty = 2, col = lineColors[2])
    }
    if (sd == TRUE) {
        loess.y.var <- loess(residuals(loess.y)^2 ~ u, degree = degree,
            span = span)
        pred.loess.y.var <- pmax(0, predict(loess.y.var, data.frame(u = new)))
        lines(new, fr.mmp(fam, pred.loess.y + sqrt(pred.loess.y.var)),
            lty = 1, col = lineColors[1])
        lines(new, fr.mmp(fam, pred.loess.y - sqrt(pred.loess.y.var)),
            lty = 1, col = lineColors[1])
        loess.yhat.var <- loess(residuals(loess.yhat)^2 ~ u,
            degree = degree, span = span)
        pred.loess.yhat.var <- pmax(0, predict(loess.yhat.var,
            data.frame(u = new)))
        varfun <- summary(m)$dispersion * m$family$variance(predict(m,
            type = "response"))/if (!is.null(m$prior.weights))
            m$prior.weights
        else 1
        loess.varfun <- loess(varfun ~ u, degree = degree, span = span)
        pred.loess.varfun <- pmax(0, predict(loess.varfun, data.frame(u = new)))
        sd.smooth <- sqrt(pred.loess.yhat.var + pred.loess.varfun)
        lines(new, fr.mmp(fam, pred.loess.yhat + sd.smooth),
            lty = 2, col = lineColors[2])
        lines(new, fr.mmp(fam, pred.loess.yhat - sd.smooth),
            lty = 2, col = lineColors[2])
    }
    showLabels(u, m$model[, 1], labels=labels,
        id.var=id.var, id.method=id.method, id.n=id.n, id.cex=id.cex,
        id.col=id.col)
}

marginalModelPlots <- function(...) mmps(...)

mmps <- function(m, vars=~., fitted=TRUE, layout=NULL, ask,
        main, ...){
  vars <- update(m,vars,na.action=NULL,method="model.frame")
  dataClasses <- attr(attr(vars,"terms"),"dataClasses")[-1]
  terms <- names(dataClasses)[dataClasses == "numeric"]
  nt <- length(terms)+fitted
  if (missing(main)) main <- if (nt == 1) "Marginal Model Plot" else "Marginal Model Plots"
  if(is.null(layout)){
   layout <- switch(min(nt,9),
                           c(1,1),c(1,2),c(2,2),c(2,2),c(3,2),c(3,2),
                           c(3,3),c(3,3),c(3,3))}
  ask <- if(missing(ask) || is.null(ask)) prod(layout)<nt else ask
  if( prod(layout) > 1) {
    op <- par(mfrow=layout, ask=ask, no.readonly=TRUE, 
            oma=c(0, 0, 2.5, 0), mar=c(5, 4, 1.5, 1.5) + .1)  
    on.exit(par(op))
  }
  for (term in terms){
    j <- match(term,names(vars))
    mmp(m,vars[,j],xlab=term,...)}
  if(fitted==TRUE) mmp(m,...)
  mtext(side=3,outer=TRUE,main, line=0.5, cex=1.2)
  }
