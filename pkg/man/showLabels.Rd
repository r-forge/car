\name{showLabels}
\Rdversion{1.1}
\alias{showLabels}
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
showLabels(x, y, labels=NULL, id.var = NULL, 
     id.method = if(is.null(id.var)) "xy" else "none",
     id.n = 3, id.cex=1, id.col=NULL, show=TRUE, ...)
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
  \item{id.var}{
Either a vector of the length of x to determine which points are to
be labeled, or a list of less than length(x) labels or observation
numbers of the points to be labeled, or NULL indicating that 
\code{id.method} will be used to determine the labeling method.  See
the details below.
}
  \item{id.method}{
How points are to be identified if \code{id.var} is not explicitly
provided.  See Details below.
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
  \item{show}{If TRUE, labels are drawn on the plot.  If FALSE, then the labels 
are returned but not shown on the plot.}
  \item{...}{additional arguments passed to \code{identify} or to \code{text}.}
}
\details{
The arguments \code{id.var} and  \code{id.method} determine how the points 
to be identified are selected.  Here are the options for \code{id.method}: 
\itemize{
\item{id.method = "none"}
\item{id.method = "identify"}{identify points interactively using the \code{\link{identify}}
function}
\item{id.method = "x"}{select points according to their value of \code{abs(x - mean(x))}}
\item{id.method = "y"}{select points according to their value of \code{abs(y - mean(y))}}
\item{id.method = "xy"}{select points according to both \code{"x"} and \code{"y"}}
\item{id.method = "mahal"}{Treat \code{(x. y)} as if it were a bivariate sample, and
select cases according to their Mahalanobis distance from 
\code{mean(x), mean(y)}}}.

Alternatively and in addition, the \code{id.var} can be used to use any other 
variable to select the labels.  For example, in \code{m} is the \code{lm} model,
the setting \code{id.var = residuals(m, type="pearson")} will label the points
with the \code{id.n} absolute value of the Person residual, while setting
\code{id.var = cooks.distance(m1)} will label the points with the largest 
value of Cook's distance.  Finally setting \code{id.var = c(1, 3, 4)} will label
observations 1, 3 and 4 regardless of their location.

Both \code{id.var} and \code{id.method} can be used simultaneously, but this
is likely to be rather confusing.  
}
\value{
A utility function used for its side-effect of drawing labels on a plot.
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
# Although intended for use with other car functions, this function can be
# used directly
plot(education ~ income, Prestige)
with(Prestige, showLabels(income, education, 
     labels = rownames(Prestige), id.method="x"))
m <- lm(education ~ income, Prestige)
plot(education ~ income, Prestige)
abline(m)
with(Prestige, showLabels(income, education, 
     labels=rownames(Prestige), id.var=residuals(m)))
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ utilities }

