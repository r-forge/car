#-------------------------------------------------------------------------------
# Revision history:
# 2009-09-28 by J. Fox (/renamed)
# 2012-06-29 Rewritted by S. Weisberg.  The 'data' argument is now ignored but kept for compatibility
#-------------------------------------------------------------------------------

# score test of nonconstant variance (J. Fox)

ncvTest <- function(model, ...){
	UseMethod("ncvTest")
}

getModelFrame <- function(model, terms) {
  model <- update(model, data=model.frame(model))
  if ((!is.null(class(model$na.action))) && class(model$na.action) == 'exclude') 
		model <- update(model, na.action=na.omit)
  mf2 <- try(update(model, as.formula(terms), method="model.frame"),
     silent=TRUE)
# This second test is used for models like m1 <- lm(longley) which
# fail the first test becasue update doesn't work
  if(class(mf2) == "try-error")
       mf2 <- try(update(model, as.formula(terms),
               method="model.frame", data=model.frame(model)), silent=TRUE)
  if(class(mf2) == "try-error") stop("argument 'terms' not interpretable.")
  mf2
}


ncvTest.lm <- function (model, var.formula, ...) {
	if ((!is.null(class(model$na.action))) && class(model$na.action) == 'exclude') 
		  model <- update(model, na.action=na.omit)
	sumry <- summary(model)
	residuals <- residuals(model, type="pearson") # suggested by S. Weisberg
	S.sq <- df.residual(model)*(sumry$sigma)^2/sum(!is.na(residuals))
	.U <- (residuals^2)/S.sq
	if (missing(var.formula)) {
		mod <- lm(.U ~ fitted.values(model))
		varnames <- "fitted.values"
		var.formula <- ~fitted.values
		df <- 1
	}
	else {  
                mf2 <- getModelFrame(model, var.formula)
                mf2$.U <- .U
                form <- as.formula(paste(".U ~ ", as.character(var.formula)[[2]], sep=""))         
                mod <- update(model, form, data=mf2, weights=NULL)
		df <- sum(!is.na(coefficients(mod))) - 1
	}
	SS <- anova(mod)$"Sum Sq"
	RegSS <- sum(SS) - SS[length(SS)]
	Chisq <- RegSS/2
	result <- list(formula=var.formula, formula.name="Variance", ChiSquare=Chisq, Df=df, 
		p=pchisq(Chisq, df, lower.tail=FALSE), test="Non-constant Variance Score Test")
	class(result) <- "chisqTest"
	result
}

ncvTest.glm <- function(model, ...){
	stop("requires lm object")
}

print.chisqTest <- function(x, ...){
	title <- if (!is.null(x$test)) x$test else "Chisquare Test"
	cat(title,"\n")
	if (!is.null(x$formula)) cat(x$formula.name, 
			"formula:", as.character(x$formula), "\n")
	cat("Chisquare =", x$ChiSquare,"   Df =", x$Df,
		"    p =", x$p, "\n")
	invisible(x)
}
