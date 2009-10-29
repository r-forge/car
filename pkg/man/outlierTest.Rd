\name{outlierTest}
\alias{outlierTest}
\alias{outlierTest.lm}
\alias{outlierTest.glm}
\alias{print.outlierTest}

\title{Bonferroni Outlier Test}

\description{
  Reports the Bonferroni p-values for studentized residuals in
  linear and generalized linear models, based on a t-test for
  linear models and normal-distribution test for generalized linear models.
}

\usage{
outlierTest(model, ...)

\method{outlierTest}{lm}(model, cutoff=0.05, n.max=10, order=TRUE, 
	labels=names(rstudent), ...)

\method{print}{outlierTest}(x, digits=5, ...)
}

\arguments{
  \item{model}{an \code{lm} or \code{glm} model object.}
  \item{cutoff}{observations with Bonferonni p-values exceeding
  	\code{cutoff} are not reported, unless no observations are
  	nominated, in which case the one with the largest studentized
  	residual is reported.}
  \item{n.max}{maximum number of observations to report (default, \code{10}).}
  \item{order}{report studenized residuals in descending order of magnitude? 
  	(default, \code{TRUE}).}
  \item{labels}{an optional vector of observation names.}
  \item{...}{arguments passed down to methods functions.}
  \item{x}{\code{outlierTest} object.}
  \item{digits}{number of digits for reported p-values.}
}

\details{
  For a linear model, p-values reported use the t distribution with degrees of
  freedom one less than the residual df for the model. For a generalized
  linear model, p-values are based on the standard-normal distribution. The Bonferroni
  adjustment multiplies the usual two-sided p-value by the number of 
  observations. The \code{lm} method works for \code{glm} objects. To show all
  of the observations set \code{cutoff=Inf} and \code{n.max=Inf}.
}

\value{
  an object of class \code{outlierTest}, which is normally just
  printed.
}

\references{
  Cook, R. D. and Weisberg, S. (1984)
  \emph{Residuals and Influence in Regression.} Wiley.
  
  Fox, J. (2008)
  \emph{Applied Regression Analysis and Generalized LInear Models, Second Edition.} Sage.
  
  Williams, D. A. (1987)
  Generalized linear model diagnostics using the deviance and single
  case deletions. \emph{Applied Statistics} \bold{36}, 181--191.
}

\author{John Fox \email{jfox@mcmaster.ca}}

\examples{
data(Duncan, package="car")
outlierTest(lm(prestige ~ income + education, data=Duncan))

data(cloud, package="alr3")
outlierTest(lm(logb(Rain, 2) ~ S + logb(C, 2) + logb(P, 2) + E + A, data=cloud, subset=-2))
}

\keyword{regression}
\keyword{htest}
