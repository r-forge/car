\name{showLabels}
\Rdversion{1.1}
\alias{showLabels}
\alias{showLabels1}
\title{
Utility function to identify and mark extreme points in a 2D plot.
}
\description{
This function is called by several graphical functions in the \code{car}
package to mark extreme points in a 2D plot.  Although the user is unlikely
to call this function directly, the documentation below applies to all
these other functions.
}
\usage{
showLabels(x, y, labels=NULL, id.method="identify",  
  id.n = 3, id.cex=1, id.col=NULL, ...)
     
showLabels1(x, y, labels=NULL, id.method="identify",
	id.n = 3, id.cex=1, id.col=NULL, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{
Plotted horizontal coordinates.
}
  \item{y}{
Plotted vertical coordinates.
}
  \item{labels}{
Plotting labels.  If NULL, case numbers will be used.  If labels are long, the
\code{\link{substr}} function can be used to shorten them.
}
  \item{id.method}{
How points are to be identified.  See Details below.
}
  \item{id.n}{
Number of points to be identified.  If set to zero, no points are identified.  
}
  \item{id.cex}{
Controls the size of the plotted labels.  The default is 0.75.
}
  \item{id.col}{
Controls the color of the plotted labels.  The default is the default color.
}
  \item{...}{additional arguments passed to \code{identify} or to \code{text}.}
}
\details{
The argument \code{id.method} determine how the points 
to be identified are selected.  The default value of \code{id.method="identify"},
then the \code{\link{identify}} is used to identify points interactively using
the mouse.  Up to \code{id.n} points can be identified, so if you set 
\code{id.n=0}, which is the default in many \code{car} functions, then no
point identification is done.

Automatic point identification can be done depending on the value of the
argument \code{id.method}.
\itemize{
   \item id.method = "x" select points according to their value of \code{abs(x - mean(x))}
   \item id.method = "y" select points according to their value of \code{abs(y - mean(y))}
   \item id.method = "mahal" Treat \code{(x. y)} as if it were a bivariate sample, and
select cases according to their Mahalanobis distance from  \code{mean(x), mean(y)}
   \item id.method = "logx", "logy" or "logmahal" can be used if the plot is drawn
using logged-axes.
  \item id.method can be a vector of the same length as \code{x} consisting of 
values to determine the points to be labelled.  For example, for a linear model
\code{m}, setting \code{id.method=cooks.distance(m), id.n=4} will label the 
points corresponding to the four largest values of Cook's distance, or
\code{id.method = abs(residuals(m, type="pearson")), id.n =2} would label
the two observations corresponding to the largest absolute Pearson residuals.
  \item id.method can be a list of case numbers or case-labels, in which case
  those cases will be labelled, as long as \code{id.n} is greater than zero.
}

With \code{showLabels}, the \code{id.method} argument can be list, so, for
example \code{idmethod=list("x", "y")} would label according to the horizontal 
and vertical axes variables.
}
\value{
A utility function used for its side-effect of drawing labels on a plot. 
Although intended for use with other car functions, this function can be
used directly.
}
\references{
  Fox, J. (2008).
  \emph{Applied Regression, Linear Models, and Related Methods.},
  2nd Edition, Sage.
  
  Fox, J. and Weisberg, S. (in press).  \emph{Companion to Applied Regression},
    2nd Edition, Sage.
  
  Weisberg, S. (2005). \emph{Applied Linear Regression}, 3rd Edition, Wiley.
}
\author{John Fox \email{jfox@mcmaster.ca}, Sanford Weisberg \email{sandy@umn.edu}}

\seealso{\code{\link{avPlots}}, \code{\link{residualPlots}},
%\code{\link{mmPlots}}, 
\code{\link{crPlots}}, \code{\link{leveragePlots}}
}

\examples{
plot(education ~ income, Prestige)
with(Prestige, showLabels(income, education, 
     labels = rownames(Prestige), id.method=list("x", "y"), id.n=3))
m <- lm(education ~ income, Prestige)
plot(education ~ income, Prestige)
abline(m)
with(Prestige, showLabels(income, education, 
     labels=rownames(Prestige), id.method=residuals(m), id.n=4))
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ utilities }

