\name{carWeb}
\alias{carWeb}

\title{ Access to the Compainion to Applied Linear Regression website }
\description{
  This function will access the website for Applied Linear Regression} 

\usage{
carWeb(page = c("webpage", "errata", "taskviews"), rfile, data, xls)

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
  \item{data}{The quoted name of a data file in \emph{A Companion to Applied 
         Regression}, like "Duncan" or "Prestige".  All these data files are
         already in the car package.
  }
    \item{xls}{The quoted name of a Excel file referenced in \emph{A Companion 
         to Applied Regression}, like "Datasets.xls".  Unlike the previous two
         arguments, you should include the extension ".xls" in specifying
         the file name.
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
