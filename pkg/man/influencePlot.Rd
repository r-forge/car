\name{influencPlot}
\alias{influencePlot}
\alias{influencePlot.lm}
\alias{influence.plot}

\title{Regression Influence Plot}
\description{
  This function creates a "bubble" plot of studentized residuals by hat values, with the areas of the
  circles representing the observations proportional to Cook's distances. Vertical reference lines are drawn
  at twice and three times the average hat value, horizontal reference lines at -2, 0, and 2 on the
  studentized-residual scale.
}

\note{
  This function used to be named \code{influence.plot}; the name was changed to avoid confusion with
  the \code{influence} generic function.
}

\usage{
influencePlot(model, ...)

\method{influencePlot}{lm}(model, scale = 10, labels, id.n = 0, 
	id.cex=1, id.col=palette()[1], ...)
}

\arguments{
  \item{model}{a linear or generalized-linear model.
  }
  \item{scale}{a factor to adjust the size of the circles.
  }
  \item{labels, id.n, id.cex, id.col}{settings for labelling
points; see \code{link{showLabels}} for details. To omit point labelling, set
\code{id.n=0}, the default.}
  \item{\dots}{arguments to pass to the \code{plot} function.
  }
}

\value{
  If points are identified, returns a data frame with the hat values, 
Studentized residuals and Cook's distance of the identified points.  If
no points are identified, nothing is returned.  This function is primarily
used for its side-effect of drawing a plot.
}

\references{
    J. Fox and S. Weisberg (2011). 
    \emph{An R and S-PLUS Companion to Applied Regression}, second
	edition. Sage.
}

\author{John Fox \email{jfox@mcmaster.ca}}


\seealso{\code{\link[stats]{cooks.distance}}, \code{\link[stats]{rstudent}}, 
\code{\link[stats]{hatvalues}}, \code{link{showLabels}}}

\examples{
    influencePlot(lm(prestige ~ income + education, data=Duncan))
}

\keyword{regression}
