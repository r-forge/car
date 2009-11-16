\name{residualPlots}
\alias{residualPlots}
\alias{residualPlots.lm}
\alias{residualPlots.glm}
\alias{residualPlot}
\alias{residCurvTest}
\alias{tukeyNonaddTest}
\title{Residual plots and curvature tests for linear model fits}
\description{
Plots the residuals versus each term in a mean function and versus
fitted values.  Also computes a curvature test for each of the plots
by adding a quadratic term and testing the quadratic to be zero.  This
is Tukey's test for nonadditivity when plotting against fitted values.
}
\usage{
### This is a generic function with only one required argument:

residualPlots (model, ...)

\S3method{residualPlots}{lm}(model, vars = ~., layout = NULL, ask, 
                 main = "Residual Plots", fitted = TRUE, plot = TRUE, ...)

\S3method{residualPlots}{glm}(model, ...)

### The following are three related functions:    

residualPlot(model, variable = "fitted", type = "pearson", 
                 plot = TRUE,     
                 add.quadratic = TRUE, 
                 id.var = NULL, 
                 labels = names(residuals(model)[!is.na(residuals(model))]),
                 id.method = "xy",
                 id.n = 3, id.cex = .75,
                 col = palette()[2], col.lines = col[1], 
                 xlab, ylab, pch = 1, lwd = 2, ...)      
                    
residCurvTest(model,variable)

tukeyNonaddTest(model)
}
\arguments{
  \item{model}{ 
A regression object 
}
  \item{vars}{
A one-sided formula that specifies a subset of the predictors. One
residual plot is drawn for each specified.  The default
\code{~.} is to plot against all predictors.  For example, the
specification \code{vars = ~.-X3} would plot against all predictors
except for \code{X3}.  Some nonstandard predictors, such as B-splines, are 
skipped.
}
  \item{layout}{ 
If set to a value like \code{c(1,1)} or \code{c(4,3)}, the layout
of the graph will have this many rows and columns.  If not set, the program
will select an appropriate layout.  If the number of graphs exceed nine, you 
must select the layout yourself, or you will get a maximum of nine per page.
}
  \item{ask}{
If TRUE, ask the user before drawing the next plot; FALSE if don't
ask.
}
  \item{main}{
Main title for the graphs.  Sue \code{main=""} for no title.
}
  \item{fitted}{
If TRUE, the default, include the plot against fitted values.
}
  \item{plot}{
If TRUE, draw the plot(s).
}
  \item{...}{
Additional arguments passed to \code{residualPlot} and then the
\code{plot}.
}
  \item{variable}{
Quoted variable name for the horizontal axis, or 
\code{"fitted"} to the plot versus fitted values.
}
  \item{type}{
Type of residuals to be used.  Pearson residuals are 
appropriate for \code{lm} objects since there are equivalent to ordinary residuals
with ols and correctly weighted residuals with wls.  Any quoted string that
is an appropriate value of the \code{type} argument to
\code{\link{residuals.lm}}.
}
  \item{add.quadratic}{
if TRUE, fits the quadratic regression of the
vertical axis on the horizontal axis.  Ignored for glms.
}
  \item{id.var}{
if not NULL, the values of this variable are used to find the
observations to label.  See \code{\link{showLabels}} for details.
} 
  \item{labels}{
Values to use to label points.  The default is to use the
row names from the data or the row numbers.
}
  \item{id.method}{
selects how points are to be selected for labeling.  See \code{\link{showLabels}}
for details.
}
  \item{id.n}{
Number of points to identify.  If \code{id.method="xy"} then
up to \code{id.n} points will be identified in each direction for both
extreme horizontal and vertical points.   To turn off point labeling either set
\code{id.n=0} or \code{id.method="none"}.
}     
  \item{id.cex}{
character expansion factor for point labels.
}
  \item{col}{
default color for points
}
  \item{col.lines}{
default color for lines
}
  \item{xlab}{
X-axis label.  If not specified, a useful label is constructed by
the function.
}
  \item{ylab}{
Y-axis label.  If not specified, a useful label is constructed by
the function.
}
  \item{pch}{
plotting character.
}
  \item{lwd}{
line width for lines.
}
  }
\details{
\code{residualPlots} draws all residuals plots, versus
each term specified first-order term in the model (interactions are
automatically skipped) and versus fitted values,  and returns all the
curvature tests.  \code{residualPlot}, which is called by \code{residualPlots},
should be viewed as an internal function, and is included here to display its
arguments, which can be used with \code{residualPlots} as well.  
\code{residCurvTest} computes the curvature test only.  For any factors a
boxplot will be drawn.  For any polynomials, plots are against the linear term.
For other non-standard predictors like B-splines are skipped.
}
\value{
For lm objects,
returns a data.frame with one row for each plot drawn, one column for 
the curvature test statistic, and a second column for the corresponding
p-value.  This function is used primarily for its side effect of drawing
residual plots. 
}
\references{S. Weisberg (2005), \emph{Applied
Linear Regression}, third edition, Wiley, Chapter 8}
\author{Sanford Weisberg, \email{sandy@stat.umn.edu}}

\seealso{See Also \code{\link{lm}}, \code{\link{identify}},
\code{\link{showExtremes}} }


\examples{
residualPlots(lm(longley))
}
\keyword{ hplot }% at least one, from doc/KEYWORDS
\keyword{ regression }% __ONLY ONE__ keyword per line
