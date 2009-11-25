# Modified Nov. 24, 2009 by S. Weisberg to use showLabels
# rather than showExtremes

residualPlots <- function(model, ...){UseMethod("residualPlots")}

residualPlots.lm <- function(model, vars= ~.,
     layout=NULL, ask, main="Residual Plots", 
     fitted=TRUE, plot=TRUE, ...){
  mf <- attr(model.frame(model), "terms")
  vform <- update(formula(model),vars)
  if(any(is.na(match(all.vars(vform), all.vars(formula(model))))))
     stop("Only predictors in the formula can be plotted.")
  terms <- attr(mf, "term.labels") # this is a list
  vterms <- attr(terms(vform), "term.labels")
# drop interactions (order > 1)
  vterms <- setdiff(vterms, terms[attr(mf, "order") > 1])
# keep only terms that are numeric or integer or factors or poly
  good <- NULL
  for (term in vterms) if(
      inherits(model$model[[term]], "numeric") |
      inherits(model$model[[term]], "integer") |
      inherits(model$model[[term]], "factor") | 
      inherits(model$model[[term]], "poly")) good <- c(good,term)
  nt <- length(good) + fitted
  if (nt == 0) stop("No plots specified")
  if(is.null(layout)){
   layout <- switch(min(nt,9), c(1,1), c(1,2), c(2,2), c(2,2),
                               c(3,2), c(3,2), c(3,3), c(3,3), c(3,3))}
  nr <- 0
  ask <- if(missing(ask) || is.null(ask)) prod(layout)<nt else ask
  op <- par(mfrow=layout, ask=ask, no.readonly=TRUE, 
            oma=c(0, 0, 1.5, 0), mar=c(5, 4, 1, 2) + .1)
  on.exit(par(op))
  ans <- NULL     
  if(!is.null(good)){
    for (term in good){
     nr <- nr+1
     ans <- rbind(ans,residualPlot(model, term, plot=plot, ...))
     row.names(ans)[nr] <- term
    } }
  # Tukey's test
  if (fitted == TRUE){
   ans <- rbind(ans,residualPlot(model,"fitted",plot=plot,...))
   row.names(ans)[nr+1] <- "Tukey test"
   ans[nr+1,2] <- 2*pnorm(abs(ans[nr+1,1]),lower.tail=FALSE)}
  mtext(side=3,outer=TRUE,main, cex=1.2)
  dimnames(ans)[[2]] <- c("Test stat", "Pr(>|t|)")
  ans}
  
residualPlots.glm <- function(model, ...) {
 invisible(residualPlots.lm(model,...))
 }
 
residualPlot <- function(model, ...) UseMethod("residualPlot")

residualPlot.lm <- function(model, variable = "fitted", type = "pearson", 
                 plot = TRUE,     
                 add.quadratic = TRUE, 
                 id.var = NULL, 
                 labels,
                 id.method = "xy",
                 id.n = 3, id.cex=1, id.col=NULL, 
                 col = palette()[2], col.lines = col[1], 
                 xlab, ylab, pch = 1, lwd = 2, ...) {
 curvature <- class(model)[1] == "lm"
 string.capitalize <- function(string) {
     paste(toupper(substring(string,1,1)),substring(string,2),sep="")}
 if(missing(labels)) labels <-  names(residuals(model)[!is.na(residuals(model))])
 ylab <- paste(string.capitalize(type),"residuals")
 col <- match(variable,names(model$model))
 if(is.na(col) && variable != "fitted")
   stop(paste(variable,"is not a term in the mean function"))
 horiz <- if(variable == "fitted") predict(model) else model$model[[col]]
 lab <- if(variable == "fitted") {"Fitted values"} else variable
 ans <-
   if(inherits(horiz,"poly")) {
       horiz <- horiz[,1]
       lab <- paste("Linear part of",lab)
       c(NA,NA)}
   else if (class(horiz) == "factor") c(NA,NA)
   else if (curvature == TRUE) residCurvTest(model,variable)
   else  c(NA,NA)
# ans <- if (class(horiz) != "factor")  else c(NA,NA)
 if(plot==TRUE){
  plot(horiz,residuals(model,type=type),xlab=lab,ylab=ylab,...)
  abline(h=0,lty=2)
  if(class(horiz) != "factor") {
    if(add.quadratic==TRUE & curvature==TRUE){
        new <- seq(min(horiz),max(horiz),length=200)
        lm2 <- lm(residuals(model,type=type)~poly(horiz,2))
        lines(new,predict(lm2,list(horiz=new)),lty=3,lwd=2)
        }}}
  if (!is.factor(horiz)) {  
        showLabels(horiz, residuals(model, type=type), labels=labels, 
            id.var=id.var, id.method=id.method, id.n=id.n, id.cex=id.cex,
            id.col=id.col)
     }
  ans}
 
# September 24, 2009  Curvature testing is ONLY for lm's!
residCurvTest <- function(model,variable) {
 if(variable == "fitted") tukeyNonaddTest(model) else {
  if(is.na(match(variable, attr(model$terms,"term.labels"))))
     stop(paste(variable,"is not a term in the mean function")) else {
     xsqres <- qr.resid(model$qr,model.frame(model)[[variable]]^2)
     r <- residuals(model, type="pearson")
     m1 <- lm(r ~ xsqres, weights=weights(model))
     df.correction <- sqrt((df.residual(model)-1) / df.residual(m1))
     test <- summary(m1)$coef[2,3] * df.correction
     c(Test=test, Pvalue=2 * pt(-abs(test),df.residual(model)-1))
     }}}
residCurvTest.glm <- function(model) c(NA,NA)  # the above function might be OK...
     
tukeyNonaddTest <- function(model){
 qr <- model$qr
 fitsq <- qr.resid(qr,predict(model,type="response")^2)
 r <- residuals(model,type="pearson")
 m1 <- lm(r~fitsq,weights=weights(model))
 df.correction <- sqrt((df.residual(model)-1)/df.residual(m1))
 tukey <- summary(m1)$coef[2,3] * df.correction
 c(Test=tukey,Pvalue=2*pnorm(-abs(tukey)))
 }

