\name{carWeb}
\alias{carWeb}

\title{ Access to the R Companion to Applied Regression website }
\description{
  This function will access the website for An R Companion to Applied Regression} 

\usage{
carWeb(page = c("webpage", "errata", "taskviews"), rfile, data)

}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{page}{ A character string indicating what page to open. The default 
          "webpage" will open the main webpage, "errata" displays the
          Errata sheet for the book, and "taskviews" fetches and displays
          a list of available task views from CRAN.
 }
  \item{rfile}{The quoted name of a chapter in \emph{A Companion to Applied 
         Regression}, like "chap-1", "chap-2", up to "chap-8".  All the R
         commands used in that chapter will be displayed in your browser, where
         you can save them as a text file.
  }
  \item{data}{The quoted name of a data file in \emph{An R Companion to Applied 
         Regression}, like "Duncan.txt" or "Prestige.txt".  The file will be
         opened in your web browser. 
  }
}

\value{
  Either a webpage or a pdf document is displayed.  Only one of the three 
  choices, page, rfile or data, should be used. 
}

\author{ Sanford Weisberg, based on the function UsingR in the UsingR
package by John Verzani }


\examples{

\dontrun{carWeb()}
}
\keyword{ interface }% at least one, from doc/KEYWORDS
