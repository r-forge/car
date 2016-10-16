adaptiveKernel <- function(x, bw=bw.nrd0, adjust=1.0, n=500, from, to, cut=3, na.rm=TRUE){
    varname <- deparse(substitute(x))
    if (na.rm) x <- na.omit(x)
    if (!is.numeric(bw)){
        bw <- bw(x)
    }
    bw <- adjust*bw
    if (missing(from)){
        from <- min(x) - cut*bw
    }
    if (missing(to)){
        to <- max(x) + cut*bw
    }
    x0 <- seq(from, to, length=n)
    p <- AdaptiveKernel(x0, x, bw)
    result <- list(x=x0, y=p, n=n, bw=bw*adjust, call=match.call(), data.name=varname, has.na=FALSE)
    class(result) <- "density"
    result
}
