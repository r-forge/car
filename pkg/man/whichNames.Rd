\name{whichNames}
\alias{whichNames}

\title{Position of Row Names}
\description{
  This function returns the indices of row names in a data frame
  or a vector of names.
}
\usage{
whichNames(names, object)
}

\arguments{
  \item{names}{a name or character vector of names.}
  \item{object}{a data frame or character vector of (row) names.}
}

\value{
Returns the index or indices of \code{names} within \code{object}.
}

\author{John Fox \email{jfox@mcmaster.ca}}

\examples{
whichNames(c('minister', 'conductor'), Duncan)
## [1]  6 16
}
\keyword{utilities}
