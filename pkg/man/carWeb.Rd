\name{carWeb}
\alias{carWeb}

\title{ Access to the Compainion to Applied Linear Regression website }
\description{
  This function will access the website for Applied Linear Regression} 

\usage{
carWeb(what = c("webpage", "errata", "taskviews"))

}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{what}{ A character string indicating what page to open. The default 
          "webpage" will open the main webpage, "errata" displays the
          Errata sheet for the book, and "taskviews" fetches and displays
          a list of available task views from CRAN.
 }
}

\value{
  Either a webpage or a pdf document is displayed.  
}

\author{ Sanford Weisberg, based on the function UsingR in the UsingR
package by John Verzani }


\examples{

\dontrun{carWeb()}
}
\keyword{ interface }% at least one, from doc/KEYWORDS
