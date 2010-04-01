\name{infIndexPlot}
\alias{infIndexPlot}
\alias{influenceIndexPlot}
\alias{infIndexPlot.lm}
\title{Influence index plot}
\description{
Provides index plots of Cook's distances,
leverages, Studentized residuals and outlier significance levels for a 
regression object.
}
\usage{
infIndexPlot(model, ...)

influenceIndexPlot(model, ...)

\method{infIndexPlot}{lm}(model,
     vars=c("Cook", "Studentized", "Bonf", "hat"), 
     main="Diagnostic Plots",
     id.var=NULL, labels, id.method = "y", id.n = 0, id.cex=1,
     id.col=NULL, ...) 

}
\arguments{
  \item{model}{A regression object of type lm or glm}
  \item{vars}{
All the quantities listed in this argument are plotted.  Use \dQuote{Cook}
for Cook's distances, \dQuote{Studentized} for Studentized
residuals, \dQuote{Bonf} for Bonferroni p-values for an outlier test, and 
and \dQuote{hat} for hat-values (or leverages).   Capitalization is optional.
All may be abbreviated by the first four characters, or three characters for 
\dQuote{hat}.
}
  \item{main}{main title for graph}
  \item{id.var, labels, id.method, id.n, id.cex, id.col}{
Arguements for point marking; see \code{\link{showLabels}} for the 
definitions.  With the default \code{id.n=0} points are not 
marked.}
  \item{\dots}{Arguments passed to \code{plot}}
}

\value{
Used for its side effect of producing a graph.  Produces four index plots
of Cook's distance, Studentized Residuals, the corresponding Bonferroni 
p-values for outlier tests, and leverages.
}
\references{ 
  Cook, R. D. and Weisberg, S. (1999)
  \emph{Applied Regression, Including Computing and Graphics.} Wiley.

  Fox, J. (2008)
  \emph{Applied Regression, Linear Models, and Related Methods,} second edition.
   Sage.
   
  Fox, J. and Weisberg, S. (in press).  \emph{An R Companion to Applied 
  Regression}, second edition.  Sage.
  
  Weisberg, S. (2005) 
  \emph{Applied Linear Regression}, third edition. Wiley.
}

\author{Sanford Weisberg, \email{sandy@stat.umn.edu}}

\seealso{ \code{\link{cooks.distance}}, \code{\link{rstudent}},
  \code{\link{outlierTest}}, \code{link{hatvalues}} }
\examples{
m1 <- lm(prestige ~ income + education + type, Duncan)
influenceIndexPlot(m1)
}

\keyword{ hplot }% at least one, from doc/KEYWORDS
\keyword{ regression }% __ONLY ONE__ keyword per line
