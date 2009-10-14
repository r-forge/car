\name{car-deprecated}
\alias{car-deprecated}
\alias{av.plot}
\alias{av.plots}
\alias{box.cox}
\alias{bc}
\alias{box.cox.powers}
\alias{box.cox.var}
\alias{box.tidwell}
\alias{cookd}
\alias{ceres.plot}
\alias{ceres.plots}
\alias{cr.plot}
\alias{cr.plots}
\alias{durbin.watson}
\alias{levene.test}
\alias{leverage.plot}
\alias{leverage.plots}
\alias{linear.hypothesis}
\alias{qq.plot}
\alias{scatterplot.matrix}
\alias{spread.level.plot}

\title{Deprecated Functions in car Package}

\description{
  These functions are provided for compatibility with older versions of car only, and may be removed eventually.
}

\usage{
av.plot(...)
av.plots(...)
box.cox(...)
bc(...)
box.cox.powers(...)
box.cox.var(...)
box.tidwell(...)
cookd(...)
ceres.plot(...)
ceres.plots(...)
cr.plot(...)
cr.plots(...)
durbin.watson(...)
levene.test(...)
leverage.plot(...)
leverage.plots(...)
linear.hypothesis(...)
qq.plot(...)
scatterplot.matrix(...)
spread.level.plot(...)
}

\arguments{
  \item{\dots}{pass arguments down.}
}

\details{
\code{av.plot} and \code{av.plots} are now synonyms for the \code{\link[art:avPlots]{avPlot}} and \code{\link[art]{avPlots}} functions in the \pkg{art} package.

\code{box.cox} and \code{bc} are now synonyms for \code{\link[art]{bcPower}} in the \pkg{art} package.

\code{box.cox.powers} is now a synonym for \code{\link[art]{powerTransform}} in the \pkg{art} package.

\code{box.cox.var} is now a synonym for \code{\link[art]{boxCoxVariable}}.

\code{box.tidwell} is now a synonym for \code{\link[art]{boxTidwell}} in the \pkg{art} package.

\code{cookd} is now a synonym for \code{\link[stats:influence.measures]{cooks.distance}} in the \pkg{stats} package.

\code{ceres.plot} and \code{ceres.plots} are now synonyms for the \code{\link[art:ceresPlots]{ceresPlot}} and \code{\link[art]{ceresPlots}} 
functions in the \pkg{art} package.

\code{cr.plot} and \code{cr.plots} are now synonyms for the \code{\link[art:crPlots]{crPlot}} and \code{\link[art]{crPlots}} functions in the \pkg{art} package.

\code{durbin.watson} is now a synonym for \code{\link[art]{durbinWatsonTest}} in the \pkg{art} package.

\code{levene.test} is now a synonym for \code{\link[art]{leveneTest}} in the \pkg{art} package.

\code{leverage.plot} and \code{leverage.plots} are now synonyms for the \code{\link[art:leveragePlots]{leveragePlot}} and \code{\link[art]{leveragePlots}} 
functions in the \pkg{art} package.

\code{linear.hypothesis} is now a synonym for the \code{\link[art]{linearHypothesis}} function in the \pkg{art} package.

\code{qq.plot} is now a synonym for \code{\link{qqPlot}}.

\code{scatterplot.matrix} is now a synonym for \code{\link{scatterplotMatrix}}.

\code{spread.level.plot} is now a synonym for \code{\link{spreadLevelPlot}}.
}