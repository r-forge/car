\name{carWeb}
\alias{carWeb}

\title{ Access to the R Companion to Applied Regression website }
\description{
  This function will access the website for \emph{An R Companion to Applied Regression}, or setup files or data.}

\usage{
carWeb(page = c("webpage", "errata", "taskviews", "ethics"), script, data, setup)

}
\arguments{
  \item{page}{ A character string indicating what page to open. The default
          \code{"webpage"} will open the main web page, \code{"errata"} displays the
          errata sheet for the book, \code{"taskviews"} fetches and displays
          a list of available task views from CRAN and \code{"ethics"} fetches the
          American Statistical Association Ethics Committee Ethical Guidelines for Statistical
          practice.
 }
  \item{script}{The quoted name of a chapter in \emph{An R Companion to Applied
         Regression}, like \code{"chap-1"}, \code{"chap-2"}, up to \code{"chap-8"}.  All the R
         commands used in that chapter will be displayed in your browser, where
         you can save them as a text file.
  }
  \item{data}{The quoted name of a data file in \emph{An R Companion to Applied
         Regression}, like \code{"Duncan.txt"} or \code{"Prestige.txt"}.  The file will be
         opened in your web browser.  You do not need to specify the extension \code{.txt}
  }
  \item{setup}{If not missing then ALL the files in the data directory are downloaded to the current
         working directory.}
}

\value{
  Either a web page or a PDF document is displayed, or files discussed in the R Companion are downloaded.  Only one of the three
  arguments \code{page}, \code{download}, or \code{data}, should be used.
}

\references{
  Fox, J. and Weisberg, S. (2011)
  \emph{An R Companion to Applied Regression}, Second Edition, Sage.
}

\author{ Sanford Weisberg, based on the function \code{UsingR} in the \pkg{UsingR}
package by John Verzani }


\examples{

\dontrun{carWeb()}
}
\keyword{ interface }
