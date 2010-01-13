\name{symbox}
\alias{symbox}
\alias{symbox.formula}
\alias{symbox.default}

\title{Boxplots for transformations to symmetry}

\description{\code{symbox} first transforms \code{x} to each of a series
    of selected powers, with each transformation standardized to mean 0 and
    standard deviation 1. The results are then displayed side-by-side in boxplots, permiting
    a visual assessment of which power makes the distribution reasonably symmetric.}

\usage{
symbox(x, ...)
\method{symbox}{formula}(formula, data=NULL, subset, na.action=NULL, ylab=NULL, ...)
\method{symbox}{default}(x, powers = c(-1, -0.5, 0, 0.5, 1), start=0, ylab="", ...)
}

\arguments{
    \item{x}{a numeric vector.}
    \item{formula}{a one-sided formula specifying a single numeric variable.}
    \item{data, subset, na.action}{as for statistical modeling functions (see, e.g., \code{\link{lm}}).}
    \item{ylab}{optional label for the vertical axis.}
    \item{powers}{a vector of selected powers to which \code{x} is to be raised. 
        A power of 0 is taken to mean $log(x)$. Negative
        powers are taken to mean $-x^p$, to preserve the order of the data.
        For meaningful comparison of powers,  1 should be included
        in the vector of powers.}
    \item{start}{a constant to be added to \code{x}; after adding the start, all data
        values must be positive.}
    \item{\ldots}{arguments to be passed down.}
    }

\value{as returned by \code{boxplot}.}

\author{Gregor Gorjanc, John Fox \email{jfox@mcmaster.ca}}

\references{
    Friendly, M. (2005)
    \emph{SAS System for Statistical Graphics, 2nd Edition.} 
    SAS Institute (In preparation).}
    
\seealso{\code{\link[graphics]{boxplot}}, \code{\link[MASS]{boxcox}}, \code{\link{bcPower}}}

\examples{
symbox(~ income, data=Prestige)
}

\keyword{hplot}
