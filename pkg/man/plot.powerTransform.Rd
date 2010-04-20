\name{plot.powerTransform}
\Rdversion{1.1}
\alias{plot.powerTransform}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ plot method for powerTransform objects
}
\description{
This function provides a simple function for plotting data using power 
transformations
}
\usage{

\method{plot}{powerTransform}(x, z = NULL, round = TRUE, plot = pairs, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{name of the power transformation object
}
  \item{z}{
  Additional variables of the same length as those used to get the transformation
  to be plotted, default is NULL.
}
  \item{round}{
  If TRUE, the default, use rounded transforms, if FALSE use the mles.
}
  \item{plot}{
  Plotting method.  Default is \code{pairs}.  Another possible choice is
  \code{scatterplot.matrix} from the \code{car} package.
}
  \item{\dots}{
  Optional arguments passed to the plotting method
}
}
\details{
The data used to estimate transformations using \code{powerTransform} are plotted
in the transformed scale.
}
\value{
None.  Produces a graph as a side-effect.
}
\references{
Weisberg, S. (2005) \emph{Applied Linear Regression}, third edition. Wiley.

Fox, J. and Weisberg, S. (in press).  \emph{An R Companion to Applied Linear Regression},
second edition, Sage.
}
\author{ Sanford Weisberg, sandy@stat.umn.edu }


\seealso{
See Also as \code{\link{powerTransform}}
}
\examples{
summary(a3 <- powerTransform(cbind(len, ADT, trks, sigs1) ~ hwy, Highway1))
with(Highway1, plot(a3, z=rate, col=as.numeric(hwy)))
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ hplot }
\keyword{ regression }% __ONLY ONE__ keyword per line
