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
avPlots(model, terms= ~ ., intercept=FALSE, layout=NULL, ask, main, ...)

avp(...)

avPlot(model, ...)

\method{avPlot}{lm}(model, variable,
    id.var = residuals(model, type="pearson"),
    id.method = "x",
    labels, 
    id.n = 0, id.cex=1, id.col=NULL,
    col = palette()[2], col.lines = col[1],
    xlab, ylab, pch = 1, lwd = 2, 
    main="Added-variable Plot", ...)

\method{avPlot}{glm}(model, variable, 
    id.var = residuals(model, type="pearson"),
    id.method = "x",
    labels,
    id.n = 0, id.cex=1, id.col=NULL, 
    col = palette()[2], col.lines = col[1],
    xlab, ylab, pch = 1, lwd = 2,  type=c("Wang", "Weisberg"), 
    main="Added-variable Plot", ...)
}
\arguments{
  \item{model}{model object produced by \code{lm} or \code{glm}.
}
  \item{terms}{ A one-sided formula that specifies a subset of the predictors. 
One added-variable plot is drawn for each term.   For example, the
specification \code{terms = ~.-X3} would plot against all terms
except for \code{X3}. If this argument is a quoted name of one of the terms, the 
added-variable plot is drawn for that term only.
}
\item{intercept}{Include the intercept in the plots; default is \code{FALSE}.}
\item{variable}{A quoted string giving the name of a regressor in the model matrix for the horizontal
  axis
}
\item{layout}{ If set to a value like \code{c(1,1)} or \code{c(4,3)}, the layout
  of the graph will have this many rows and columns.  If not set, the program will
  select an appropriate layout.  If the number of graphs exceed nine, you must 
  select the layout yourself, or you will get a maximum of nine per page.}
\item{main}{The title of the plot; if missing, one will be supplied.
}
\item{ask}{If TRUE, ask the user before drawing the next plot; FALSE if don't ask.
}
\item{\dots}{\code{avPlots} passes these arguments to \code{avPlot}.  
  \code{avPlot} passes them to \code{plot}. 
}
  \item{id.var}{values to be used to identify points.  By default, the Pearson
residuals from the model are used.  See \code{\link{showLabels}} for details.
}
  \item{id.method}{Additional methods to identify points, see 
\code{\link{showLabels}}  for details.
}
  \item{labels}{observation names}
  \item{id.n}{Number of points to identify.  Set \code{id.n=0}, the default, for no
point identification.  The default value for \code{id.method} identifies both
extreme horizontal points and extreme residuals, so up to \code{2*id.n} points
will be labeled.}
  \item{id.cex}{Character expansion for point labels.
}
  \item{id.col}{Color for point labels.
}
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

  Fox, J. (2008)
  \emph{Applied Regression and Generalized Linear Models, Second Edition.} Sage.
  
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
avPlots(lm(prestige~income+education+type, data=Duncan))

avPlots(glm(partic != "not.work" ~ hincome + children, 
  data=Womenlf, family=binomial))
}

\keyword{hplot}
\keyword{regression}
