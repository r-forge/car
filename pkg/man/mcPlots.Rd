\name{mcPlots}
\alias{mcPlots}
\alias{mcPlot}
\alias{marginalPlot}
\alias{marginalPlot.lm}


\title{Draw Linear Model Marginal and Conditional Plots in Parallel}
\description{
  These functions take a fitted \code{lm} object and draw two plots for each regressor, one showing the marginal relationship between the response and the regressor, centered but otherwise ignoring all other regressors, and the other an added-variable plot, showing the conditional relationship of Y and X given all other regressors.  The added variable plot by default is drawn using the same xlim and ylim as the centered marginal plot to emphasize that conditioning removes variation in both the regressor and the response.
}

\usage{
mcPlots(model, terms=~., intercept=FALSE, layout=NULL, ask, main, ...)

mcPlot(model, ..., marginal.scale=TRUE, new=TRUE)

marginalPlot(model, ...)

\method{marginalPlot}{lm}(model, variable,
  	id.method = list(abs(residuals(model, type="pearson"))),
		labels, 
		id.n = if(id.method[1]=="identify") Inf else 0,
		id.cex=1, id.col=palette()[1],
		col = palette()[1], col.lines = palette()[2],
		xlab, ylab, pch = 1, lwd = 2, main=paste("Centered Marginal Plot:", variable), grid=TRUE,
		ellipse=FALSE, ellipse.args=NULL, ...)

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
  \item{layout}{ 
If set to a value like \code{c(1, 2)} or \code{c(6, 2)}, the layout
of the graph will have this many rows and columns.  If not set, the program
will select an appropriate layout of up to c(4,2); with more than 4 regressors, graphs
will be drawing one-pair-at-a-time, with user input required between pairs of graphs
}
\item{main}{The title of the plot; if missing, one will be supplied.
}
\item{ask}{If \code{TRUE}, ask the user before drawing the next plot; if \code{FALSE} don't ask.
}
\item{\dots}{\code{mcPlots} passes these arguments to \code{mcPlot}.  
  \code{mcPlot} passes them to \code{plot}. 
}
  \item{id.method,labels,id.n,id.cex,id.col}{Arguments for the labelling of
    points.  The default is \code{id.n=0} for labeling no points.  See
    \code{\link{showLabels}} for details of these arguments.
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
  \item{grid}{If \code{TRUE}, the default, a light-gray background grid is put on the graph.}
  \item{ellipse}{If \code{TRUE}, plot a concentration ellipse; default is \code{FALSE}.}
  \item{ellipse.args}{Arguments to pass to the \code{link{dataEllipse}} function, in the form of a list
    with named elements; e.g., \code{ellipse.args=list(robust=TRUE))} will cause the ellipse to be plotted using
    a robust covariance-matrix.}
  \item{marginal.scale}{Consider an added-variable plot of Y versus X given Z.  If this argument is \code{FALSE} then the limits on the horizontal axis are determined by the range of the residuals from the regression of X on Z and the limits on the vertical axis are determined by the range of the residuals from the regressnio of Y on Z.  If the argument is \code{TRUE}, then the limits on the horizontal axis are determined by the range of X minus it mean, and on the vertical axis by the range of Y minus its means; adjustment is made if necessary to include outliers.  This scaling allows visualization of the correlations between Y and Z and between X and Z.  For example, if the X and Z are highly correlated, then the points will be concentrated on the middle of the plot.}
  \item{new}{if \code{TRUE}, the default, the plot window is reset using \code{par{mfrow=c(1, 2)}}.  If \code{FALSE}, the layout of the plot window is not reset.}  
}

\details{
  For an \code{lm} object \code{model}, the \code{marginalPlot} function will produde a marginal graph of the response in \code{mode} versus the secified regressor.  both the response and the regressor are centered by subtracting their means.  The \code{mcPlot} is a convience front-end that draws two plots side-by-side:  the result of \code{marginalPlot} and the results of \code{avPlot} for the same regressor. The \code{avPlot} is scaled to have the same \code{xlim} and \code{ylim} as the \code{marginalPlot}, to better display the effects of conditioning on other regressors and the effects of colinearity. 
}

\value{
  These functions are used for their side effect id producing
  plots.
}

\references{
  Cook, R. D. and Weisberg, S. (1999)
  \emph{Applied Regression, Including Computing and Graphics.} Wiley.

  Fox, J. (2008)
  \emph{Applied Regression Analysis and Generalized Linear Models},
  Second Edition. Sage.  
  
  Fox, J. and Weisberg, S. (2011) 
  \emph{An R Companion to Applied Regression}, Second Edition, Sage.
  
  Weisberg, S. (2014) \emph{Applied Linear Regression}, Fourth Edition, Wiley.
}

\author{John Fox \email{jfox@mcmaster.ca}, Sanford Weisberg \email{sandy@umn.edu}}

\seealso{\code{\link{avPlots}}, \code{\link{residualPlots}}, \code{\link{crPlots}}, \code{\link{ceresPlots}}, 
\code{link{dataEllipse}}
}

\examples{
m1 <- lm(partic ~ tfr + menwage + womwage + debt + parttime, data = Bfox)
marginalPlot(m1, "womwage")
mcPlot(m1, "womwage")
mcPlots(m1, ~ . - debt) # avoids "asking" to draw the graph
}

\keyword{hplot}
\keyword{regression}
