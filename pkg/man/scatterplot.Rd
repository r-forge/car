\name{scatterplot}
\alias{scatterplot}
\alias{scatterplot.formula}
\alias{scatterplot.default}
\alias{sp}

\title{Scatterplots with Boxplots}
\description{
  Makes fancy scatterplots, with boxplots in the margins, a lowess
  smooth, and a regression line; \code{sp} is an abbreviation for
  \code{scatterplot}.
}
\usage{
scatterplot(x, ...)

\method{scatterplot}{formula}(x, data, subset, xlab, ylab, legend.title, 
	identify=c("auto", TRUE, FALSE), labels, ...)

\method{scatterplot}{default}(x, y, smooth=TRUE, spread=!by.groups, span=.5, 
	reg.line=lm, boxplots="xy", xlab=deparse(substitute(x)), ylab=deparse(substitute(y)), 
	las=par("las"), lwd=1, lwd.smooth=lwd, 
	identify=c("auto", TRUE, FALSE), cutoff=.99, labels, 
	log="", jitter=list(), xlim=NULL, ylim=NULL,
	cex=par("cex"), cex.axis=par("cex.axis"), cex.lab=par("cex.lab"), 
	cex.main=par("cex.main"), cex.sub=par("cex.sub"),
	groups, by.groups=!missing(groups), legend.title=deparse(substitute(groups)), 
	ellipse=FALSE, levels=c(.5, .95), robust=TRUE,
	col=rep(palette(), length.out=n.groups + 1), pch=1:n.groups, 
	legend.plot=!missing(groups), reset.par=TRUE, ...)
  
sp(...)
}

\arguments{
  \item{x}{vector of horizontal coordinates, or a ``model'' formula, of the form \code{y ~ x} or 
    (to plot by groups) \code{y ~ x | z}, where \code{z} evaluates to a factor 
    or other variable dividing the data into groups..}
  \item{y}{vector of verical coordinates.}
  \item{data}{data frame within which to evaluate the formula.}
  \item{subset}{expression defining a subset of observations.}
  \item{smooth}{if \code{TRUE} (the default) a loess nonparametric regression line is
    drawn on the plot.}
  \item{spread}{if \code{TRUE} (the default when there are no groups), a smoother is applied to
  	the root-mean-square positive and negative residuals from the loess line to display conditional spread and
  	asymmetry.}
  \item{span}{span for the loess smoother.}
  \item{reg.line}{function to draw a regression line on the plot
    or \code{FALSE} not to plot a regression line.}
  \item{boxplots}{if \code{"x"} a boxplot for \code{x} is drawn above the plot;
    if \code{"y"} a boxplot for \code{y} is drawn to the right of the plot;
    if \code{"xy"} both boxplots are drawn.}
  \item{xlab}{label for horizontal axis.}
  \item{ylab}{label for vertical axis.}
  \item{las}{if \code{0}, ticks labels are drawn parallel to the
    axis; set to \code{1} for horizontal labels (see \code{\link[graphics]{par}}).}
  \item{lwd}{width of linear-regression lines (default \code{1}).}
  \item{lwd.smooth}{width for smooth regression lines (default is the same as \code{lwd}).}
  \item{identify}{if \code{"auto"} (the default), outlying points are identified automatically;
  	if \code{TRUE}, points are identified interactive by left-clicking near them; right-click
  	to exit from interactive-point-identification mode.}
  \item{cutoff}{outliers are automatically identified by comparing to the contours of a
  	robustly estimated bivariate normal distribution; points beyond the contour given by
  	\code{cutoff} (default, \code{.99}) are flagged.}
  \item{labels}{a vector of point labels; if absent, the function tries to determine reasonable
  	labels, and, failing that, will use observation numbers.}
  \item{log}{same as the \code{log} argument to \code{\link{plot}}, to produce log axes.}
  \item{jitter}{a list with elements \code{x} or \code{y} or both, specifying jitter factors
    for the horizontal and vertical coordinates of the points in the scatterplot. The 
    \code{\link[base]{jitter}} function is used to randomly perturb the points; specifying a
    factor of \code{1} produces the default jitter. Fitted lines are unaffected by the jitter.}
  \item{xlim}{the x limits (min, max) of the plot; if \code{NULL}, determined from the data.}
  \item{ylim}{the y limits (min, max) of the plot; if \code{NULL}, determined from the data.}
  \item{groups}{a factor or other variable dividing the data into groups; groups are
    plotted with different colors and plotting characters.}
  \item{by.groups}{if \code{TRUE}, regression lines are fit by groups.}
  \item{legend.title}{title for legend box; defaults to the name of the groups variable.}
  \item{ellipse}{if \code{TRUE} data-concentration ellipses are plotted.}
  \item{levels}{level or levels at which concentration ellipses are plotted;
    the default is \code{c(.5, .95)}.}
  \item{robust}{if \code{TRUE} (the default) use the \code{cov.trob} function in the \code{MASS} package
    to calculate the center and covariance matrix for the data ellipse.}
  \item{col}{colors for points and lines; the default is the
    current color palette, starting at the \emph{second} entry and with the colors
    repeated if necessary.
    (see \code{\link[grDevices]{palette}} and \code{\link[graphics]{par}}).}
  \item{pch}{plotting characters for points; default is the plotting characters in
    order (see \code{\link[graphics]{par}}).}
  \item{cex, cex.axis, cex.lab, cex.main, cex.sub}{set sizes of various graphical elements; 
    (see \code{\link[graphics]{par}}).}
  \item{legend.plot}{if \code{TRUE} then a legend for the groups is plotted in the upper margin.}
  \item{reset.par}{if \code{TRUE} then plotting parameters are reset to their previous values
    when \code{scatterplot} exits; if \code{FALSE} then the \code{mar} and \code{mfcol} parameters are
    altered for the current plotting device. Set to \code{FALSE} if you want to add graphical elements
    (such as lines) to the plot.}
  \item{\dots}{other arguments passed down and to \code{plot}.}
}

\value{
  If points are identified, their labels are returned; otherwise \code{NULL} is returned invisibly.
}

\author{John Fox \email{jfox@mcmaster.ca}}


\seealso{\code{\link[graphics]{boxplot}},
  \code{\link[base]{jitter}} 
  \code{\link{scatterplotMatrix}}, \code{\link{dataEllipse}},
  \code{\link[graphics]{par}}, \code{\link[MASS]{cov.trob}}.}

\examples{

scatterplot(prestige ~ income, data=Prestige, ellipse=TRUE, levels=.99)

scatterplot(prestige ~ income|type, data=Prestige, span=1)

scatterplot(vocabulary ~ education, jitter=list(x=1, y=1), 
	data=Vocab, identify=FALSE, smooth=FALSE)

  \dontrun{
scatterplot(infant.mortality ~ gdp, identify=TRUE, data=UN)

scatterplot(infant.mortality ~ gdp, log="xy", identify=TRUE, data=UN)
  }
}

\keyword{hplot}
