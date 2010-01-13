# last modified 13 January 2010 by J. Fox

symbox <- function(x, ...){
	UseMethod("symbox")
}

symbox.formula <- function(formula, data=NULL, subset, na.action=NULL, ylab=NULL, ...){
	variable <- all.vars(formula)
	if (length(variable) != 1) stop("the formula must specify one variable")
	m <- match.call(expand.dots = FALSE)
	if (is.matrix(eval(m$data, parent.frame()))) 
		m$data <- as.data.frame(data)
	m$ylab <- m$... <- NULL
	m$na.action <- na.action
	require(stats, quietly = TRUE)
	m[[1]] <- as.name("model.frame")
	mf <- eval(m, parent.frame())
	if (is.null(ylab)) ylab <- paste("Transformations of", variable)
	symbox(mf[[variable]], ylab=ylab, ...)
}

symbox.default <- function(x, powers = c(-1, -0.5, 0, 0.5, 1), start=0, ylab="", ...) {
    if (!(is.vector(x) && is.numeric(x))) stop("x should be a numeric vector.")
    x <- x + start
    if (min(x) <= 0) stop("negative values for x are not allowed (after start applied)")
    result <- outer(x, powers,  "^")
    result[, powers < 0] <- - result[,powers < 0]
    result[, powers == 0] <- log(x)
    result <- as.data.frame(scale(result))
    names <- as.character(powers)
    names[powers == 0] <- "log"
    names(result) <- names
    boxplot(result, xlab="Powers", ylab=ylab)
}
