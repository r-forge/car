\name{which.names}
\alias{which.names}
\alias{whichNames}

\title{Position of Row Names}
\description{
  These functions return the indices of the supplied row names of a data frame
  or names of another object, such as a vector or list. \code{whichNames} is just an alias for \code{which.names}.
}
\usage{
which.names(names, object)
whichNames(...)
}

\arguments{
  \item{names}{a name or character vector of names.}
  \item{object}{a data frame or or an object with a names attribute.}
  \item{\dots}{arguments to be passed to \code{which.names}.}
}

\value{
Returns the index or indices of \code{names} in row names of the data frame of names of an object of another class. Then names of the indices are the corresponding matched row names or names.
}

\author{John Fox \email{jfox@mcmaster.ca}}

\references{
  Fox, J. and Weisberg, S. (2011) 
  \emph{An R Companion to Applied Regression}, Second Edition, Sage.
}

\examples{
which.names(c('minister', 'conductor'), Duncan)
}
\keyword{utilities}
