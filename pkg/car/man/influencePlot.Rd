\name{influencePlot}
\alias{influencePlot}
\alias{influencePlot.lm}
\alias{influencePlot.lmerMod}
\alias{influence.plot}

\title{Regression Influence Plot}
\description{
  This function creates a \dQuote{bubble} plot of Studentized residuals versus hat values, with the areas of the
  circles representing the observations proportional to the value Cook's distance. Vertical reference lines are drawn
  at twice and three times the average hat value, horizontal reference lines at -2, 0, and 2 on the
  Studentized-residual scale.
}

\usage{
influencePlot(model, ...)

\method{influencePlot}{lm}(model, scale=10,  
 xlab="Hat-Values", ylab="Studentized Residuals", id=TRUE, 
 fill=TRUE, fill.col=carPalette()[2], fill.alpha=0.5, ...)

\method{influencePlot}{lmerMod}(model, ...)
}

\arguments{
  \item{model}{a linear, generalized-linear, or linear mixed model; the \code{"lmerMod"} method calls the \code{"lm"} method and can take the same arguments.}
  \item{scale}{a factor to adjust the size of the circles.
  }
  \item{xlab, ylab}{axis labels.
  }
  \item{id}{settings for labelling points; see \code{link{showLabels}} for details. To omit point labelling, set
\code{id=FALSE}; the default, \code{id=TRUE} is equivalent to \code{id=list(method="noteworthy", n=2, cex=1, col=carPalette()[1], location="lr")}.  
The default \code{method="noteworthy"} is used only in this function and indicates setting labels for points with large Studentized residuals, hat-values or Cook's distances.  Set 
\code{id=list(method="identify")} for interactive point identification.}
  \item{fill}{if \code{TRUE} (the default) fill the circles, with the opacity of the filled color proportional to Cook's D, using the \code{\link[scales]{alpha}} function in the \pkg{scales} package to compute the opacity of the fill.}
  \item{fill.col}{color to use for the filled points, taken by default from the second element of the \code{\link{carPalette}} color palette.}
  \item{fill.alpha}{the maximum alpha (opacity) of the points.}
  \item{\dots}{arguments to pass to the \code{plot} and \code{points} functions.}
}

\value{
  If points are identified, returns a data frame with the hat values, 
Studentized residuals and Cook's distance of the identified points.  If
no points are identified, nothing is returned.  This function is primarily
used for its side-effect of drawing a plot.
}

\references{
  Fox, J. (2016)
  \emph{Applied Regression Analysis and Generalized Linear Models},
  Third Edition. Sage.  
  
  Fox, J. and Weisberg, S. (2019) 
  \emph{An R Companion to Applied Regression}, Third Edition, Sage.
}

\author{John Fox \email{jfox@mcmaster.ca}, minor changes by S. Weisberg
\email{sandy@umn.edu} and a contribution from Michael Friendly}


\seealso{\code{\link{cooks.distance}}, \code{\link{rstudent}}, \code{\link[scales]{alpha}}, \code{\link{carPalette}},
\code{\link{hatvalues}}, \code{\link{showLabels}}}

\examples{
influencePlot(lm(prestige ~ income + education, data=Duncan))
\dontrun{ # requires user interaction to identify points
influencePlot(lm(prestige ~ income + education, data=Duncan), 
    id=list(method="identify"))
}
}

\keyword{regression}
