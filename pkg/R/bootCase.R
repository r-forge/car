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
    bootCase.default(update(object, data=model.frame(object)), f, B)
    }
bootCase.glm <- function(object, f=coef, B=999) {
    bootCase.lm(object, f, B)
    }
bootCase.nls <- function(object, f=coef, B=999) {
    bootCase.default(object, f, B)
    }
bootCase.default <- function (object, f=coef, B = 999)
{
    n <- length(resid(object))
    opt<-options(show.error.messages = FALSE)
    on.exit(options(opt))
    coefBoot <- NULL
    count.error <- 0
    i <- 0
#    
    while (i < B) {
        obj.nl <- try(update(object, subset=sample(1:n, replace = TRUE)))
        if (is.null(class(obj.nl))) {
            count.error <- 0
            i <- i + 1
            coefBoot <- rbind(coefBoot, f(obj.nl))
        }
        else {
            if (class(obj.nl)[1] != "try-error") {
                count.error <- 0
                i <- i + 1
                coefBoot <- rbind(coefBoot, f(obj.nl))
            }
            else {
                count.error <- count.error + 1
            }
        }
        if (count.error >= 25) {
            options(show.error.messages = TRUE)
            stop("25 consecutive bootstraps did not converge.  Bailing out.")}
    }
    return(coefBoot)
}