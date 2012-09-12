\name{ScatterplotSmoothers}
\alias{ScatterplotSmoothers}
\alias{gamLine}
\alias{quantregLine}
\alias{loessLine}

\title{
Smoothers to Draw Lines on Scatterplots
}

\description{
These smoothers are used to draw nonparametric-regression lines on scatterplots produced by
the \code{\link{scatterplot}} and \code{\link{scatterplotMatrix}} functions. The functions aren't meant to
be called directly by the user, although the user can supply options via the \code{smoother.args} argument,
the contents of which vary by the smoother (see \emph{Details} below). The \code{gamLine} smoother uses the
\code{\link[mgcv]{gam}} function in the \pkg{mgcv} package, the \code{loessLine} smoother uses the
\code{\link[stats]{loess}} function in the \pkg{stats} package, and the \code{quantregLine} smoother uses the
\code{\link[quantreg]{rqss}} function in the \pkg{quantreg} package.
}

\usage{
gamLine(x, y, col, log.x, log.y, by.groups, smoother.args)

loessLine(x, y, col, log.x, log.y, by.groups, smoother.args)

quantregLine(x, y, col, log.x, log.y, by.groups, smoother.args)
}

\arguments{
  \item{x}{$x$ coordinates of points.}
  \item{y}{$y$ coordinates of points.}
  \item{col}{line color.}
  \item{log.x}{\code{TRUE} if the $x$-axis is logged.}
  \item{log.y}{\code{TRUE} if the $y$-axis is logged.}
  \item{by.groups}{\code{TRUE} if plotting is by groups.}
  \item{smoother.args}{additional options accapted by the smoother, in the form of a list of
    named values (see \emph{Detaisl} below).}
}

\details{
    *** details to come ***
    }
    
\author{John Fox \email{jfox@mcmaster.ca} and Sanford Weisberg.}

\seealso{\code{\link{scatterplot}}, \code{\link{scatterplotMatrix}}, \code{\link[mgcv]{gam}},
    \code{\link[stats]{loess}}, and \code{\link[quantreg]{rqss}}.}
    

\keyword{hplot}
