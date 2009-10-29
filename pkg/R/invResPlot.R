inverseResponsePlot <- function(object,lambda=c(-1,0,1),xlab=NULL, ...)
    UseMethod("inverseResponsePlot")

inverseResponsePlot.lm <- function(object,lambda=c(-1,0,1),xlab=NULL,...) {
  mf <- object$model
  if (is.null(mf)) mf <- update(object,model=TRUE,method="model.frame")
  xlab <- if(is.null(xlab)) names(mf)[1]
  y <- mf[,1]
  yhat <- predict(object)
  invTranPlot(y,yhat,lambda=lambda,xlab=xlab,...)
}

invResPlot <- function(object, ...) UseMethod("inverseResponsePlot")