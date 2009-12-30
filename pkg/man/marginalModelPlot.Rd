\name{mmps}
\alias{mmps}
\alias{mmp}
\alias{mmp.lm}
\alias{mmp.glm}
\alias{mmp.default}
\alias{marginalModelPlot}
\alias{marginalModelPlots}

\title{Marginal Model Plotting}
\description{
For a regression object, plots the response on the vertical axis versus
a linear combination \eqn{u} of terms in the mean function on the horizontal
axis.  Added to the plot are a \code{loess} smooth for the graph, along with
a loess smooth from the plot of the fitted values on \eqn{u}.  mmps is an alias
for marginalModelPlots, and mmp is an alias for marginalModelPlot.
}
\usage{
marginalModelPlots(...)

mmps(m, vars=~., fitted=TRUE, layout=NULL, ask,
        main="Marginal Model Plots", ...)

marginalModelPlot(...)

\method{mmp}{lm}(m, variable, mean = TRUE, sd = FALSE,
    xlab = deparse(substitute(variable)), degree = 1, span = 2/3, key=TRUE,
    lineColors = c("blue","red"), 
    ...)
    
\method{mmp}{default}(m, variable, mean = TRUE, sd = FALSE, xlab =
                 deparse(substitute(variable)), degree = 1, span = 2/3,
                 key = TRUE, lineColors = c("blue", "red"), id.var =   
                 NULL, labels, id.method = "y", id.n = 3, id.cex = 1,  
                 id.col = NULL, ...)
   
\method{mmp}{glm}(m, variable, mean = TRUE, sd = FALSE,
    xlab = deparse(substitute(variable)), degree = 1, span = 2/3, key=TRUE,
    lineColors = c("blue", "red"),
    id.var=NULL, labels, id.method="y", id.n=3, id.cex=1, id.col=NULL, ...)
}

\arguments{
\item{m}{A regression object, usually of type either lm or glm,
   for which there is a \code{predict} method defined. }
\item{vars}{A one-sided formula.  A marginal model plot will be drawn for
  each variable on the right-side of this formula that is not a factor.  The
  default is \code{~.}, which specifies that all the terms in 
  \code{formula(object} will be used.  See examples below.}
\item{fitted}{If the default TRUE, then a marginal model plot in the direction
  of the fitted values or linear predictor of a generalized linear model will
  be drawn.}
\item{layout}{A reasonable layout for the plots in the window is
  determined by the program.  If you don't like the default you can set your
  own layout:  \code{c(2,3)} means two rows and three columns.}
\item{ask}{If TRUE, ask before clearing the graph window to draw more plots.}
        \item{main}{
Main title for the array of plots.  Use \code{main=""} to suppress the title.
}
\item{\dots}{
Additional arguments passed from \code{mmps} to \code{mmp} and
then to \code{plot}.  Users should generally use \code{mmps}.
}
\item{variable}{ The quantity to be plotted on the horizontal axis.  The
  default is the predicted values \code{predict(object)}.  Can be any other
  vector of length equal to the number of observations in the object. }
\item{mean}{ If TRUE, compare mean smooths}
\item{sd}{ If TRUE, compare sd smooths }
\item{xlab}{ label for horizontal axis }
\item{degree}{Degree of the local polynomial, passed to \code{loess}.  The
  usual default for \code{loess} is 2, but the default here is 1.}
\item{span}{Span, the smoothing parameter for \code{loess}.  }
\item{key}{If TRUE, include a key at the top of the plot, if FALSE omit the
key}
  \item{id.var,id.method,labels,id.n,id.cex,id.col}{Arguments for labeling
points.  The default \code{id.n=0} suppresses labeling, and setting this
argument greater than zero will include labeling.  See
\code{\link{showLabels}} for these arguments.}
\item{lineColors}{ colors for data and model smooth, respectively }
}   
\details{
\code{mmp} and \code{marginalModelPlot} draw one marginal model plot.  
\code{mmps} and \code{marginalModelPlots} draws all marginal model plots,
versus each of the terms in the model and versus fitted values.  \code{mmps}
should not be used if some of the terms in the model are factors or
interactions.
}

\value{
Used for its side effect of producing plots. 
}

\seealso{\code{\link{loess}}, \code{\link{plot}} }

\references{ 

Fox, J. and Weisberg, S. (in press).
\emph{An R Companion to Applied Regression}, second edition.  Sage.


S. Weisberg (2005), \emph{Applied
Linear Regression}, third edition, Wiley, Chapter 8}

\author{Sanford Weisberg, \email{sandy@stat.umn.edu}}

\examples{
data(ufcwc, package="alr3")
c1 <- lm(Height ~ Dbh, ufcwc)
mmp(c1, ufcwc$Dbh, xlab="Diameter, Dbh", lineColors=c("black", "black"))
mmps(c1)

} 
\keyword{hplot }% at least one, from doc/KEYWORDS
\keyword{regression}
