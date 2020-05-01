\name{Import}
\alias{Import}
\title{
Import data from many file formats
}
\description{
Uses the \code{import} function from the \pkg{rio} package to read a data.frame from a variety of file types.  The \code{Import} function includes 2 additional arguments adding row names and for converting character and logical variables to factors for some file types.}
\usage{
Import(file, format, ..., row.names=TRUE,
       stringsAsFactors = getOption("stringsAsFactors"))
}
\arguments{
  \item{file}{
A character string naming a file, URL, or single-file .zip or .tar archive.  See the details below.  If the file name has an extension like \code{.xlsx} or \code{.csv} then the type of file is inferred from the extension.
}
  \item{format}{
If an extension is not present in the file name or it is wrong, the file format can be set with this argument; see \code{\link[rio]{import}}.
}
  \item{\dots}{
Additional arguments passed to \code{\link[rio]{import}}.  
}
  \item{row.names}{
If \code{TRUE}, the default, the left-most character variable that has all unique elements is removed from the data frame and set to be \code{row.names}.  To match \code{import}, set \code{row.names=FALSE}.
}
  \item{stringsAsFactors}{
If \code{TRUE}, then character variables that do not have all unique elements are converted to factors. The default is determined by the value of \code{getOption("stringsAsFactors")} whose "factory fresh" default for R versions >= 4.0.0 is equal to \code{FALSE} and is \code{TRUE} for earlier versions of R. }
}
\details{
This function calls the \code{\link[rio]{import}} function to read a data frame from a file.  Many file types are supported.  For files of type \code{"txt", "csv", "xlsx", "xls"} or \code{ "ods"} the arguments \code{row.names} and \code{stringsAsFactors} can be used to add row names and convert character variables to factors, respectively.   Many more details are given on the man page for \code{import}.
}
\value{
A data frame.  See \code{\link[rio]{import}} for more details
}

\author{Sanford Weisberg \email{sandy@umn.edu}}

\seealso{
\code{\link[rio]{import}}, \code{\link{Export}}
}
\examples{
head(Duncan, 3) # first three rows
Export(Duncan, "Duncan.csv", keep.row.names="occupation")
Duncan2 <- Import("Duncan.csv") # Automatically restores row.names and factors
brief(Duncan2) 
identical(Duncan, Duncan2) # FALSE because type is of a different class
Duncan3 <- Import("Duncan.csv", stringsAsFactors=TRUE) 
brief(Duncan3) 
identical(Duncan, Duncan3) # TRUE type is of same class
# cleanup
unlink("Duncan.csv")
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ utilities }% use one of  RShowDoc("KEYWORDS")
\keyword{ connections }% __ONLY ONE__ keyword per line
