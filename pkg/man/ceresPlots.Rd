\name{ceresPlots}
\alias{ceresPlots}
\alias{ceresPlot}
\alias{ceresPlot.lm}
\alias{ceresPlot.glm}

\title{Ceres Plots}
\description{
  These functions calculate Ceres plots for linear and generalized
  linear models.
}
\usage{
ceresPlots(model, vars = ~., layout = NULL, ask, main, 
    ...)

ceresPlot(model, ...)

\method{ceresPlot}{lm}(model, variable, id.var = residuals(model, type = "pearson"), 
    id.method = "x", labels, id.n = 3, id.cex = 1, id.col = NULL, 
    line = TRUE, smooth = TRUE, span = 0.5, iter, las = par("las"), 
    col = palette()[2], pch = 1, lwd = 2, main = "Ceres Plot", 
    ...)

\method{ceresPlot}{glm}(model, ...)
}

\arguments{
  \item{model}{model object produced by \code{lm} or \code{glm}.}
  \item{vars}{ A one-sided formula that specifies a subset of the predictors. 
One component-plus-residual plot is drawn for each term.  The default
\code{~.} is to plot against all numeric predictors.  For example, the
specification \code{vars = ~.-X3} would plot against all predictors
except for \code{X3}.  Factors and nonstandard predictors such as B-splines are 
skipped.  If this argument is a quoted name of one of the predictors, the 
component-plus-residual plot is drawn for that predictor only.
}
  \item{layout}{ If set to a value like \code{c(1,1)} or \code{c(4,3)}, the layout
of the graph will have this many rows and columns.  If not set, the program will
select an appropriate layout.  If the number of graphs exceed nine, you must 
select the layout yourself, or you will get a maximum of nine per page.}
  \item{ask}{If TRUE, ask the user before drawing the next plot; FALSE if don't ask.
This is relevant only if not all the graphs can be drawn in one window.}
  \item{main}{The title of the plot; if missing, one will be supplied.
}
  \item{\dots}{\code{ceresPlots} passes these arguments to \code{ceresPlot}.  
\code{ceresPlot} passes them to \code{plot}. 
}  
  \item{variable}{A quoted string giving the name of a variable for the horizontal
axis}
  \item{id.var}{values to be used to identify points.  By default, the Pearson
residuals from the model are used.  See \code{\link{showLabels}} for details.
}
  \item{id.method}{Additional methods to identify points, see 
\code{\link{showLabels}}  for details.
}
  \item{labels}{observation names}
  \item{id.n}{Number of points to identify.  Set \code{id.n=0} for no
point identification.}
  \item{id.cex}{Character expansion for point labels.
}
  \item{id.col}{Color for point labels.
}
  \item{line}{\code{TRUE} to plot least-squares line.
}
  \item{smooth}{\code{TRUE} to plot nonparametric-regression (lowess) line.
}
  \item{span}{span for lowess smoother.
}
  \item{iter}{number of robustness iterations for nonparametric-regression smooth;
    defaults to 3 for a linear model and to 0 for a non-Gaussian glm.
}
  \item{las}{if \code{0}, ticks labels are drawn parallel to the
    axis; set to \code{1} for horizontal labels (see \code{\link[graphics]{par}}).
}
  \item{col}{color for points and lines; the default is the \emph{second} entry
    in the current color palette (see \code{\link[grDevices]{palette}}
    and \code{\link[graphics]{par}}).
}
  \item{pch}{plotting character for points; default is \code{1} 
    (a circle, see \code{\link[graphics]{par}}).
}
  \item{lwd}{line width; default is \code{2} (see \code{\link[graphics]{par}}).
}
}
\details{
  Ceres plots are a generalization of component+residual (partial
  residual) plots that are less prone to leakage of nonlinearity
  among the predictors.
  
  The function intended for direct use is \code{ceresPlots}. 
  
  The model cannot contain interactions, but can contain factors. 
  Factors may be present in the model, but Ceres plots cannot be drawn
  for them.
}
\value{
  \code{NULL}. These functions are used for their side effect: producing
  plots.
}
\references{ 
  Cook, R. D. and Weisberg, S. (1999)
  \emph{Applied Regression, Including Computing and Graphics.} Wiley.

  Fox, J. (2008)
  \emph{Applied Regression, Linear Models, and Related Methods},
  second ed. Sage.
  
  Fox, J. and Weisberg, S. (2011)  \emph{An R Companion to Applied Regression},
  second ed. Sage.
  
  Weisberg, S. (2005)  \emph{Applied Linear Regression}, third ed. Wiley.
}
\author{John Fox \email{jfox@mcmaster.ca}}

\seealso{\code{\link{crPlots}}, \code{\link{avPlots}}, \code{\link{showLabels}}}

\examples{
ceresPlots(lm(prestige~income+education+type, data=Prestige), ~.-type)
}

\keyword{hplot}
\keyword{regression}
