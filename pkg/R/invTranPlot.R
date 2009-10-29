invTranPlot <- function(x,...) UseMethod("invTranPlot")

invTranPlot.formula <- function(x, data, subset, na.action, ...) {
    mf <- call <- match.call()
    m <- match(c("x", "data", "subset", "na.action"), 
         names(mf), 0L)
    mf <- mf[c(1L,m)]
    mf$drop.unused.levels <- TRUE
    mf[[1L]] <- as.name("model.frame")     
    names(mf)[which(names(mf)=="x")] <- "formula"
    mf <- eval(mf, parent.frame())
    if(dim(mf)[2] != 2) stop("Formula must be of the form y ~ x")
    vx <- mf[,2]
    vy <- mf[,1]
    if( is.null(call$xlab) & is.null(call$ylab)) 
         invTranPlot(vx,vy,xlab=colnames(mf)[2],ylab=colnames(mf)[1],...) else
     if(is.null(call$xlab) & !is.null(call$ylab)) 
         invTranPlot(vx,vy,xlab=colnames(mf)[2],...) else
     if(!is.null(call$xlab) & is.null(call$ylab)) 
         invTranPlot(vx,vy,ylab=colnames(mf)[1],...) else
         invTranPlot(vx,vy,...)
  }   

invTranPlot.default<- function(x,y,lambda=c(-1,0,1),lty.lines=1:(1+length(lambda)),
        lwd.lines=2, col.lines=rainbow(length(lambda)+1,start=.7,end=.1),
        xlab=deparse(substitute(x)),ylab=deparse(substitute(y)),
        family="bcPower",optimal=TRUE,key="topleft",...){
 if (is.factor(x)) stop("Predictor variable may not be a factor")
 if (is.factor(y)) stop("Response variable may not be a factor")
 if (optimal){opt <- invTranEstimate(x,y,family=family,confidence=FALSE)
              lam <- c(opt$lambda,lambda)} else lam <- lambda
 fam <- match.fun(family)
 plot(x,y,xlab=xlab,ylab=ylab,...)
 rss <- NULL
 new <- seq(min(x,na.rm=TRUE),max(x,na.rm=TRUE),length=100)
 for (j in 1:length(lam)){
     m1 <- lm(y~fam(x,lam[j]))
     rss <- c(rss,deviance(m1))
     lines(new,predict(m1,data.frame(x=new)),lty=lty.lines[j],col=col.lines[j],
      lwd=lwd.lines)}
 if (class(key) == "logical") {
    if (key == TRUE) {
      print("Click mouse on plot to locate the key, or press Escape")
      loc <-locator(n=1)
      legend(loc[1],loc[2], legend =  as.character(round(lam,2)), 
          lwd=lwd.lines, lty=lty.lines, col=col.lines)}}
    else {
      loc <- key
      legend(loc[1],loc[2], legend =
as.character(round(lam,2)),lty=lty.lines,col=col.lines,cex=.75)}
 data.frame(lambda=lam,RSS=rss)
}

invTranEstimate <- function(x,y,family="bcPower",confidence=0.95){
  if (is.factor(x)) stop("Predictor variable may not be a factor")
  if (is.factor(y)) stop("Response variable may not be a factor")
  fam <- match.fun(family)
  f <- function(lambda,x,y,family){deviance(lm(y~fam(x,lambda)))}
  lhat <- optimize(f = function(lambda) f(lambda,x,y,family),interval=c(-10,10))
  if (confidence==FALSE){ return(list(lambda=lhat$minimum)) } else {
    g <- lm(y~fam(x,lhat$minimum))
    n = length(residuals(g))
    dev0 <- -n*log(deviance(g))
    cutoff <- qchisq(confidence,1)/2
    f1 <- function(lam) abs(dev0 + n*log(deviance(lm(y~fam(x,lam)))) -cutoff)
    lowlim <- optimize(f1, interval=c(-10,lhat$minimum))
    hilim <-  optimize(f1, interval=c(lhat$minimum,10))
    return(list(lambda=lhat$minimum,lowerCI=lowlim$minimum,upperCI=hilim$minimum))}
}
        

