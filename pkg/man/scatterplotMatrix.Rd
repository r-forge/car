\name{scatterplotMatrix}
\alias{scatterplotMatrix}
\alias{scatterplotMatrix.formula}
\alias{scatterplotMatrix.default}
\alias{spm}
\title{Scatterplot Matrices}
\description{
  Enhanced scatterplot matrices with univariate displays down the diagonal;
  \code{spm} is an abbreviation for \code{scatterplotMatrix}.
  This function just sets up a call to \code{pairs} with custom panel functions.
}
\usage{

scatterplotMatrix(x, ...)

\method{scatterplotMatrix}{formula}(x, data=NULL, subset, identify.points="mahal", labels, ...)

\method{scatterplotMatrix}{default}(x, var.labels=colnames(x), 
	diagonal=c("density", "boxplot", "histogram", "oned", "qqplot", "none"), adjust=1, nclass,
	plot.points=TRUE, smooth=TRUE, spread=smooth && !by.groups, span=.5, reg.line=lm, 
	transform=FALSE, family=c("bcPower", "yjPower"),
	ellipse=FALSE, levels=c(.5, .95), robust=TRUE,
	groups=NULL, by.groups=FALSE, identify.points="mahal", id.n=3, labels,
	col=rep(palette(), length.out=n.groups + 1), pch=1:n.groups, lwd=1, lwd.smooth=lwd,
	cex=par("cex"), cex.axis=par("cex.axis"), cex.labels=NULL, 
	cex.main=par("cex.main"), cex.identify=cex,
	legend.plot=length(levels(groups)) > 1, row1attop=TRUE, ...)

spm(x, ...)
}

\arguments{
  \item{x}{a data matrix, numeric data frame, or a one-side ``model'' formula, of the form 
    \code{ ~ x1 + x2 + ... + xk} or \code{ ~ x1 + x2 + ... + xk | z} where \code{z}
    evaluates to a factor or other variable to divide the data into groups.}
  \item{data}{for \code{scatterplotMatrix.formula},
    a data frame within which to evaluate the formula.}
  \item{subset}{expression defining a subset of observations.}
  \item{identify.points}{if \code{"mahal"} (the default), relatively extreme points in each panel are identified automatically
  	according to their Mahalanobis distances from the centroid (point of means);
  	if \code{FALSE}, no point identification.
  	See \code{\link{showExtremes}} for details (but interactive point identification is not permitted.}
  \item{id.n}{Number of relatively extreme points to identify automatically in each panel (default, \code{3}).}
  \item{labels}{a vector of point labels; if absent, the function tries to determine reasonable
  	labels, and, failing that, will use observation numbers.}
  \item{var.labels}{variable labels (for the diagonal of the plot).}
  \item{diagonal}{contents of the diagonal panels of the plot.}
  \item{adjust}{relative bandwidth for density estimate, passed to 
    \code{density} function.}
  \item{nclass}{number of bins for histogram, passed to \code{hist}
    function.}
  \item{plot.points}{if \code{TRUE} the points are plotted in each 
    off-diagonal panel.}
  \item{smooth}{if \code{TRUE} a lowess smooth is plotted in each
    off-diagonal panel.}
  \item{spread}{if \code{TRUE} (the default when not smoothing by groups), a smoother is applied to
  	the root-mean-square positive and negative residuals from the loess line to display conditional spread and
  	asymmetry.}
  \item{span}{span for lowess smoother.}
  \item{reg.line}{if not \code{FALSE} a line is plotted using the
    function given by this argument; e.g., using \code{rlm} in
    package \code{MASS} plots a robust-regression line.}
  \item{transform}{if \code{TRUE}, multivariate normalizing power transformations
    are computed \code{\link{powerTransform}}, rounding the estimated powers to `nice' values for plotting; 
    if a vector of powers, one for each variable, these are applied prior to plotting. If  there are \code{groups}
    and \code{by.groups} is \code{TRUE}, then the transformations are estimated \emph{conditional} on the
    \code{groups} factor.}
  \item{family}{family of transformations to estimate: \code{"bcPower"} for the Box-Cox family or 
    \code{"yjPower"} for the Yeo-Johnson family (see \code{\link{powerTransform}}).}
  \item{ellipse}{if \code{TRUE} data-concentration ellipses are plotted in
    the off-diagonal panels.}
  \item{levels}{levels or levels at which concentration ellipses are plotted;
    the default is \code{c(.5, .9)}.}
  \item{robust}{if \code{TRUE} use the \code{cov.trob} function in the \code{MASS} package
    to calculate the center and covariance matrix for the data ellipse.}
  \item{groups}{a factor or other variable dividing the data into groups; groups are
    plotted with different colors and plotting characters.}
  \item{by.groups}{if \code{TRUE}, regression lines are fit by groups.}
  \item{pch}{plotting characters for points; default is the plotting characters in
    order (see \code{\link[graphics]{par}}).}
  \item{col}{colors for points and lines; the default is the
    in the current color palette, starting at the \emph{second} entry
    (see \code{\link[grDevices]{palette}} and \code{\link[graphics]{par}}).}
  \item{lwd}{width of linear-regression lines (default \code{1}).}
  \item{lwd.smooth}{width for smooth regression lines (default is the same as \code{lwd}).}
  \item{cex, cex.axis, cex.labels, cex.main}{set sizes of various graphical elements; 
    (see \code{\link[graphics]{par}}).}
  \item{cex.identify}{set size of the text for point labels; the default is \code{cex} (which is typically \code{1}).}
  \item{legend.plot}{if \code{TRUE} then a legend for the groups is plotted
    in the first diagonal cell.}
  \item{row1attop}{If \code{TRUE} (the default) the first row is at the top, as in a matrix, as
  	opposed to at the bottom, as in graph.}
  \item{...}{arguments to pass down.}
}

\value{
  \code{NULL}. This function is used for its side effect: producing
  a plot.
}

\author{John Fox \email{jfox@mcmaster.ca}}

\seealso{\code{\link[graphics]{pairs}}, \code{\link{scatterplot}},
  \code{\link{dataEllipse}}, \code{\link{powerTransform}}, 
  \code{\link{bcPower}}, \code{\link{yjPower}}, \code{\link[MASS]{cov.trob}},
  \code{\link{showExtremes}}.}

\examples{
scatterplotMatrix(~ income + education + prestige | type, data=Duncan)
scatterplotMatrix(~ income + education + prestige, 
    transform=TRUE, data=Duncan)
scatterplotMatrix(~ income + education + prestige | type, smooth=FALSE, 
	by.group=TRUE, transform=TRUE, data=Duncan)
}

\keyword{hplot}
