\name{showExtremes}
\Rdversion{1.1}
\alias{showExtremes}
\title{
Utility function to identify and mark extreme points in a 2D plot.
}
\description{
This function is called by several graphical functions in the \code{art}
package to mark extreme points in a 2D plot.  Although the user is unlikely
to call this function directly, the documentation below applies to all
these other functions.
}
\usage{
showExtremes(x, y, labels = NULL, ids = "xy", cex.id = 0.75, 
    id.n = 3, res = y - mean(y, na.rm = TRUE))
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{
Plotted horizontal coordinates
}
  \item{y}{
plotted vertical coordinates
}
  \item{labels}{
Plotting labels.  If NULL, case numbers will be used.
}
  \item{ids}{
How points are to be identified.  See Details below.
}
  \item{cex.id}{
Controls the size of the plotted labels
}
  \item{id.n}{
Number of points to be identified.  If \code{ids = "xy"} then up \code{id.n}
points will be identified in the horizontal direction and \code{id.n} in the 
vertical direction.
}
  \item{res}{
For many plots, points identified in the vertical direction should be 
based on residuals.  By default the residuals \code{y - mean(y)} are used
but this argument can be any set of values for ordering the vertical axis.
}
}
\details{
The argument \code{ids} determines how the points to be identified are 
selected.  Here are the options: 
\itemize{
\item{ids = "x"}{select points according to their value of \code{abs(x - mean(x))}}
\item{ids = "y"}{select points according to their value of \code{abs(res)}}
\item{ids = "xy"}{select points according to both \code{"x"} and \code{"y"}}
\item{ids = "mahal"}{Treat \code{(x. y)} as if it were a bivariate sample, and
select cases according to their Mahalanobis distance from \code{mean(x), mean(y)}}
} 
Alternatively, \code{ids} can be a list of \code{length(x)}, and then those values
will be used to label points.  For example, setting \code{ids = abs(cooks.distance(m))}
would label according to the absolute value of Cook's distances applied to 
an object \code{m}.  In this case the absolute value isn't needed because 
\code{cooks.distance} is strictly positive.
}
\value{
A utility function used for its side-effect of drawing labels on a plot.
}
\references{
  Fox, J. (2008).
  \emph{Applied Regression, Linear Models, and Related Methods.},
  2nd Edition, Sage.
  
  Weisberg, S. (2005). \emph{Applied Linear Regression}, 3rd Edition, Wiley.
}
\author{John Fox \email{jfox@mcmaster.ca}, Sanford Weiberg \email{sandy@umn.edu}}

\seealso{\code{\link{avPlots}}, \code{\link{residualPlots}},
%\code{\link{mmPlots}}, 
\code{\link{crPlots}}, \code{\link{leveragePlots}}
}

\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
showExtremes <- function(x, y, labels = NULL,
     ids = "xy", cex.id=.75, id.n=3, res=y-mean(y,na.rm=TRUE)) {
  if(id.n > 0L) {
    if (is.null(labels))
      labels <- paste(1L:length(res))
    getPoints <- function(z) {
       names(z) <- labels
       iid <- 1L:id.n
       zs <- z[order(-z)[iid]]
       match(names(zs),labels)
       }
    ind <- if (!is.character(ids)) {
      if (length(ids) == length(x)) getPoints(ids) else
      stop("identify.points argument is of wrong length")} else
      switch(ids,
        x= getPoints(abs(x-mean(x,na.rm=TRUE))),
        y= getPoints(abs(res)),
        xy= c(getPoints(abs(x-mean(x,na.rm=TRUE))),
              getPoints(abs(res))),
        mahal= getPoints(rowSums( qr.Q(qr(cbind(1,x,y))) ^ 2)))
  labpos <- c(4,2)[1+as.numeric(x > mean(range(x)))]
  for (i in ind) {
    text(x[i], y[i], labels[i], cex = cex.id, xpd = TRUE,
      pos = labpos[i], offset = 0.25)}
  } }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ utilities }

