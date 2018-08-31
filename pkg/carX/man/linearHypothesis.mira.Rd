\name{linearHypothesis.mira}
\alias{linearHypothesis.mira}
\title{Linear Hypothesis Tests for mira Objects}

\description{
This function provides a \code{"mira"} method for the \code{\link[car]{linearHypothesis}} function in the \pkg{car} package. \code{\link[mice]{mira}} objects are produced by fitting statistical models to multiply imputed data sets using functions in the \pkg{mice} package: \code{\link[mice]{mice-package}}.
}
\usage{
\method{linearHypothesis}{mira}(model, hypothesis.matrix, rhs = NULL, ...)
}

\arguments{
  \item{model}{an object of class \code{"mira"} produced by the \pkg{mice} package, \code{\link[mice]{mice-package}}.}
  \item{hypothesis.matrix}{hypothesis in matrix or symbolic form: see \code{\link[car]{linearHypothesis}} for details.}
  \item{rhs}{right-hand side vector for the hypothesis, defaults to zeros.}
  \item{\dots}{not used.}
}

\references{
J. Fox, \emph{Applied Regression Analysis and Generalized Linear Models, 3rd ed.}, Sage, 2016.

S. van Buuren, \emph{Flexible Imputation of Missing Data, 2nd ed.}, Chapman and Hall, 2018.
}

\author{John Fox \email{jfox@mcmaster.ca}}

\seealso{\code{\link[car]{linearHypothesis}}, \code{\link[mice]{mira}}, \code{\link[mice]{mice-package}}.}

\examples{
if (require(mice)){
    nhanes2$age <- factor(nhanes2$age, 
        labels=c("age20.39", "40.59", "60.99"))
    imps <- mice(nhanes2, m=10, print=FALSE, seed=12345)
    models <- with(imps, lm(chl ~ age + bmi))
    linearHypothesis(models, c("age40.59", "age60.99"))
}

if (require(mice)){
    linearHypothesis(models, "age40.59 = age60.99")

}
}

\keyword{htest}
\keyword{models}
