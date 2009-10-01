\name{qqPlot}
\alias{qqPlot}
\alias{qqp}
\alias{qqPlot.default}
\alias{qqPlot.lm}
\alias{qqPlot.glm}

\title{Quantile-Comparison Plots}
\description{
 Plots empirical quantiles of a variable, or of studentized residuals from
 a linear model, against theoretical quantiles of a comparison distribution.
}
\usage{
qqPlot(x, ...)

qqp(...)

\method{qqPlot}{default}(x, distribution="norm", ylab=deparse(substitute(x)),
	xlab=paste(distribution, "quantiles"), main=NULL, las=par("las"),
	envelope=.95, identify=c("auto", TRUE, FALSE), labels, col=palette()[2], 
	lwd=2, pch=1, cex=par("cex"), cex.identify=cex,
	line=c("quartiles", "robust", "none"), ...)

\method{qqPlot}{lm}(x, xlab=paste(distribution, "Quantiles"),
	ylab=paste("Studentized Residuals(", deparse(substitute(x)), ")", sep=""), main=NULL, 
	distribution=c("t", "norm"), line=c("robust", "quartiles", "none"), las=par("las"),
	simulate=TRUE, envelope=.95, identify=c("auto", TRUE, FALSE), labels=names(rstudent), reps=1000, 
	col=palette()[2], lwd=2, pch=1, cex=par("cex"), cex.identify=cex, ...)
}

\arguments{
  \item{x}{vector of numeric values or \code{lm} object.}
  \item{distribution}{root name of comparison distribution -- e.g., \code{norm} for the
    normal distribution; \code{t} for the t-distribution.}
  \item{ylab}{label for vertical (empirical quantiles) axis.}
  \item{xlab}{label for horizontal (comparison quantiles) axis.}
  \item{main}{label for plot.}
  \item{envelope}{confidence level for point-wise confidence envelope, or 
    \code{FALSE} for no envelope.}
  \item{identify}{if \code{"auto"} (the default), outlying points are identified automatically;
  	if \code{TRUE}, points are identified interactively by left-clicking near them; right-click
  	to exit from interactive-point-identification mode.}
  \item{labels}{a vector of point labels; if absent, the function tries to determine reasonable
  	labels, and, failing that, will use observation numbers.}
  \item{las}{if \code{0}, ticks labels are drawn parallel to the
    axis; set to \code{1} for horizontal labels (see \code{\link[graphics]{par}}).}
  \item{col}{color for points and lines; the default is the \emph{second} entry
    in the current color palette (see \code{\link[grDevices]{palette}}
    and \code{\link[graphics]{par}}).}
  \item{pch}{plotting character for points; default is \code{1} 
    (a circle, see \code{\link[graphics]{par}}).}
  \item{cex}{factor for expanding the size of plotted symbols; the default is
    \code{1}.}
  \item{cex.identify}{set size of the text for point labels; the default is \code{cex} (which is typically \code{1}).}
  \item{lwd}{line width; default is \code{2} (see \code{\link[graphics]{par}}).}
  \item{line}{\code{"quartiles"} to pass a line through the quartile-pairs, or
    \code{"robust"} for a robust-regression line; the latter uses the \code{rlm}
    function in the \code{MASS} package. Specifying \code{line = "none"} suppresses the line.}
  \item{simulate}{if \code{TRUE} calculate confidence envelope by parametric bootstrap;
    for \code{lm} object only. The method is due to Atkinson (1985).}
  \item{reps}{integer; number of bootstrap replications for confidence envelope.}
  \item{\dots}{arguments such as \code{df} to be passed to the appropriate quantile function.}
}

\details{
  Draws theoretical quantile-comparison plots for variables and for studentized residuals
  from a linear model. A comparison line is drawn on the plot either through the quartiles
  of the two distributions, or by robust regression. 
  
  Any distribution for which quantile and
  density functions exist in R (with prefixes \code{q} and \code{d}, respectively) may be used. 
  Studentized residuals from linear models are plotted against the appropriate t-distribution.
  
  The function \code{qqp} is an abbreviation for \code{qqPlot}.
}
\value{
  These functions return the labels of identified points.
}
\references{
  Fox, J. (2008)
  \emph{Applied Regression Analysis and Generalized Linear Models, Second Edition.} Sage.

  Atkinson, A. C. (1985)
  \emph{Plots, Transformations, and Regression.} Oxford.
}
\author{John Fox \email{jfox@mcmaster.ca}}

\seealso{\code{\link[stats]{qqplot}}, \code{\link[stats]{qqnorm}},
 \code{\link[stats]{qqline}}}

\examples{
x<-rchisq(100, df=2)
qqPlot(x)
qqPlot(x, dist="chisq", df=2)

qqPlot(lm(prestige ~ income + education + type, data=Duncan), simulate=TRUE, envelope=.99)
}

\keyword{distribution}
\keyword{univar}
\keyword{regression}
