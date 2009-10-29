\name{avPlots}
\alias{avPlots}
\alias{avp}
\alias{avPlot}
\alias{avPlot.lm}
\alias{avPlot.glm}

\title{Added-Variable Plots}
\description{
  These functions construct added-variable (also called 
  partial-regression) plots for  linear and generalized linear
  models.
}

\usage{
avPlots(model,vars=~., layout=NULL, ask, main="Added Variable Plot", ...)

avp(...)

avPlot(model, ...)

\method{avPlot}{lm}(model, variable,
    identify.points = "xy",
    labels = names(residuals(model)[!is.na(residuals(model))]),
    id.n = 3, cex.identify=0.75, 
    col = palette()[2], col.lines = col[1],
    xlab, ylab, pch = 1, lwd = 2,  ...)

\method{avPlot}{glm}(model, variable, 
    identify.points = "xy",
    labels = names(residuals(model)[!is.na(residuals(model))]),
    id.n = 3, cex.identify=0.75, 
    col = palette()[2], col.lines = col[1],
    xlab, ylab, pch = 1, lwd = 2,  type=c("Wang", "Weisberg"), ...)
}
\arguments{
  \item{model}{model object produced by \code{lm} or \code{glm}.}
  \item{vars}{ A one-sided formula that specifies a subset of the predictors. 
One
  added-variable plot is drawn for each specified.  The default
  \code{~.} is to plot against all numeric predictors.  For example, the
  specification \code{vars = ~.-X3} would plot against all predictors
  except for \code{X3}.  Factors and nonstandard predictors such as B-splines are 
  skipped.  If this argument is a quoted name of one of the predictors, the 
  added-variable plot is drawn for that predictor only.}
\item{variable}{A quoted string giving the name of a variable for the horizontal
axis}
\item{layout}{ If set to a value like \code{c(1,1)} or \code{c(4,3)}, the layout
  of the graph will have this many rows and columns.  If not set, the program will
  select an appropriate layout.  If the number of graphs exceed nine, you must 
  select the layout yourself, or you will get a maximum of nine per page.}
\item{main}{The title of the plot}
\item{ask}{If TRUE, ask the user before drawing the next plot; FALSE if don't ask.}
\item{\dots}{\code{avPlots} passes these arguments to \code{avPlot}.  
  \code{avPlot}
  passes them to \code{plot}. }
  \item{labels}{observation names, used only if identify.points is not FALSE.}
  \item{identify.points}{Should case labels be printed on the plot?  If FALSE,
no labels are printed.  If TRUE, case labels can be added interactively.  If
\code{identify.points} is a character string selected from
\code{c("x", "y", "xy", "mahal")}, or a list of values, then extreme
points will be automatically labeled.  See the documentation for the argument \code{ids}
in \code{\link{showExtremes}} for details.}
  \item{id.n}{If \code{identify.points} indicates automatric point identification,
  then this number of extreme points will be marked.}
  \item{cex.identify}{Character expansion for point labels with
\code{identify.points} is not 
  FALSE.}
  \item{col}{color for points; the default is the \emph{second} entry
    in the current color palette (see \code{\link[grDevices]{palette}}
    and \code{\link[graphics]{par}}).}
  \item{col.lines}{color for the fitted line.}
  \item{pch}{plotting character for points; default is \code{1} 
    (a circle, see \code{\link[graphics]{par}}).}
  \item{lwd}{line width; default is \code{2} (see \code{\link[graphics]{par}}).}
\item{xlab}{x-axis label.  If omitted a label will be constructed.}
\item{ylab}{y-axis label.  If omitted a label will be constructed.}
  \item{type}{if \code{"Wang"} use the method of Wang (1985);
    if \code{"Weisberg"} use the method in the Arc software associated with
    Cook and Weisberg (1999).}
}

\details{
  The function intended for direct use is \code{avPlots} (for which \code{avp}
  is an abbreviation). By default, these functions are used interactively
  through a text menu.
}

\value{
  \code{NULL}. These functions are used for their side effect: producing
  plots.
}

\references{
  Cook, R. D. and Weisberg, S. (1999)
  \emph{Applied Regression, Including Computing and Graphics.} Wiley.

  Fox, J. (1997)
  \emph{Applied Regression, Linear Models, and Related Methods.} Sage.
  
  Wang, P C. (1985)
  Adding a variable in generalized linear models.
  \emph{Technometrics} \bold{27}, 273--276.
  
  Weisberg, S. (2005). \emph{Applied Linear Regression}, 3rd Edition, Wiley.
}

\author{John Fox \email{jfox@mcmaster.ca}, Sanford Weiberg \email{sandy@umn.edu}}

\seealso{\code{\link{residualPlots}} ,\code{\link{crPlots}}, \code{\link{ceresPlots}},
% \code{\link{leveragePlots}}
}

\examples{
    \dontrun{
avPlots(lm(prestige~income+education+type, data=Duncan))

avPlots(glm(partic != "not.work" ~ hincome + children, 
  data=Womenlf, family=binomial))
    }
}

\keyword{hplot}
\keyword{regression}
