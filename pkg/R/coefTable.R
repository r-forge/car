coefTable <- function(..., se=TRUE, digits=3){
    models <- list(...)
    n.models <- length(models)
    if (n.models < 1) return(NULL)
    coef.names <- unique(unlist(lapply(models, function(model)
                         names(coef(model)))))
    table <- matrix(NA, length(coef.names), n.models*(1 + se))
    rownames(table) <- coef.names
    colnames(table) <- if (se) paste(rep(c("Est.", "SE"), n.models),
                           rep(1:n.models, each=2))
        else paste(rep("Est.", n.models), 1:n.models)
    cat("\nCall:")
    for (i in 1:n.models){
        model <- models[[i]]
        fout <- deparse(model$call,width.cutoff=getOption("width") - 9)
        cat(paste("\n",i,": ", fout[1], sep=""))
        if(length(fout) > 1) for (f in fout[-1]) cat("\n",f)
        if (se)
          table[names(coef(model)), 2*(i - 1) + c(1, 2)] <-
                cbind(coef(model), sqrt(diag(vcov(model))))
        else table[names(coef(model)), i] <- coef(model)
    }
    cat("\n")
    printCoefmat(table, na.print="", digits=digits, tst.ind=NULL)
}


