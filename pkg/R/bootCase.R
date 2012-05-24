# March 9, 2012 modified by SW as suggested by Derek Ogle to return an object
# of class c("bootCase", "matrix").  
# May 2012 added methods for 'bootCase'

nextBoot <- function(object, sample){UseMethod("nextBoot")}
nextBoot.default <- function(object, sample){
   update(object, subset=sample)
   }
nextBoot.lm <- function(object, sample) nextBoot.default(object, sample)
nextBoot.nls <- function(object,sample){
# modify to assure resampling only rows in the original subset 9/1/2005
   update(object,subset=sample,start=coef(object),
    data=data.frame(update(object,model=TRUE)$model))}

bootCase <- function(object, f=coef, B=999){UseMethod("bootCase")}
bootCase.lm <- function(object, f=coef, B=999) {
    bootCase.default(object, f, B, names(resid(object)))
#    bootCase.default(update(object, 
#             data=na.omit(model.frame(object))), f, B)
    }
bootCase.glm <- function(object, f=coef, B=999) {
    bootCase.lm(object, f, B)
    }
bootCase.nls <- function(object, f=coef, B=999) {
    bootCase.default(object, f, B, seq(length(resid(object))))
    }
bootCase.default <- function (object, f=coef, B = 999, rows)
{       
    n <- length(resid(object))
    opt<-options(show.error.messages = FALSE)
    on.exit(options(opt))
    pointEstimate <- f(object)
    coefBoot <- matrix(0, nrow=B, ncol=length(f(object)))
    colnames(coefBoot) <- names(pointEstimate)  # adds names if they exist
    class(coefBoot) <- c("bootCase", "matrix")
    count.error <- 0
    i <- 0
    while (i < B) {
		assign(".boot.sample", sample(rows, replace=TRUE), envir=.GlobalEnv)
        obj.boot <- try(update(object, subset=.boot.sample))
        if (is.null(class(obj.boot))) {
            count.error <- 0
            i <- i + 1
            coefBoot[i, ] <- f(obj.boot)
        }
        else {
            if (class(obj.boot)[1] != "try-error") {
                count.error <- 0
                i <- i + 1
                coefBoot[i, ] <- f(obj.boot)
            }
            else {
                count.error <- count.error + 1
            }
        }
        if (count.error >= 25) {
            options(show.error.messages = TRUE)
            stop("25 consecutive bootstraps did not converge.  Bailing out.")}
    }
	remove(".boot.sample", envir=.GlobalEnv)
	attr(coefBoot, "pointEstimate") <- pointEstimate
    return(coefBoot)
}

summary.bootCase <- function(boot, conf.level=0.95, ci.method="naive") {
  ci.naive <- function(x) {
    quantile(x, c( (1 - conf.level)/2, 1 - (1 - conf.level)/2))} 
  b.mean <- apply(boot, 2, mean)
  b.sd <- apply(boot, 2, sd)
  b.ci <- t(apply(boot, 2, function(x) switch(ci.method, naive=ci.naive(x))))
  ans <- cbind(attr(boot, "pointEstimate"),  b.mean, b.sd, b.ci)
  colnames(ans)[1:3] <- c("Point Estimate", "boot ave", "boot sd")
  ans
  }

histogram.bootCase <- function(boot, ...) {
  panel2 <- function(x, ...) {
     est <- attr(boot, "pointEstimate")[panel.number()]
     panel.histogram(x, ...)
     abline(v=est)
     }
  boot1 <- stack(as.data.frame(boot))
  histogram( ~ values | ind, boot1, panel = panel2)
  }

  
  
  
histogram.bootCase <- function(boot, xlab="value", ...) {
  require(latticeExtra)
  panel <- function(x, ...) {
    est <- as.numeric(attr(boot, "pointEstimate")[panel.number()] )
    panel.histogram(x, ...)
    print(est)
    abline(v=est)
    }
  xyplot.list(as.data.frame(betahat.boot), FUN=histogram, panel=panel, ...) 
  }
  


  
  

  
  
