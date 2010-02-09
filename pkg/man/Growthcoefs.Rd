\name{Growthcoefs}
\Rdversion{1.1}
\alias{Growthcoefs}
\docType{data}
\title{
Growth coefficients
}
\description{
These data are used in an example of Chapter 7 of A Companion to Applied
Regression
}
\usage{data(Growthcoefs)}
\format{
  A data frame with 14 observations on the following 6 variables.
  \describe{
    \item{\code{year}}{Year of Growth}
    \item{\code{age}}{Age}
    \item{\code{coef.m1}}{Coefficient estimate linear model}
    \item{\code{SE.m1}}{SEs for linear model}
    \item{\code{coef.n1}}{Estimate from mixed-model}
    \item{\code{SE.n1}}{SEs for mixed-model}
  }
}

\source{  This file provides data for use in an example in Chapter 7 of Fox and
Weisberg (in press).  The data are output from the models described in
Weisberg, Spangler and Richmond (2010).
}
\references{
Sanford Weisberg, George Spangler, and Laurie S. Richmond (2010). Mixed
effects models for fish growth, \emph{Canadian Journal of Fisheries and Aquatic
Sciences}, 67, 269-277.

J. Fox and S. Weisberg (in press).
 \emph{An R Companion to Applied Regression, Second Edition},
 Sage.
}
\examples{
data(Growthcoefs)
}
\keyword{datasets}
