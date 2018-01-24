\name{Import}
\alias{Import}
\title{
Import
}
\description{
Use the \code{import} function from the \code{rio} package to read a data.frame from a variety of file types.  This function includes 3 additional arguments adding row names and for converting character and logical variables to factors.}
\usage{
Import(file, format, ..., row.names=TRUE,
                   stringsAsFactors = default.stringsAsFactors())
}
\arguments{
  \item{file}{
A character string naming a file, URL, or single-file .zip or .tar archive.  See the details below.
}
  \item{format}{
An optional character string code of file format, which can be used to override the format inferred from file. Shortcuts include: "," (for comma-separated values), ";" (for semicolon-separated values), and "|" (for pipe-separated values).  See details below.
}
  \item{\dots}{
Additional arguments.  The arguments \code{setclass} and \code{which}, if present, are passed to \code{\link[rio]{import}}.  Additional arguments are passed by \code{import} to the functions in other packages that it calls.
}
  \item{row.names}{
If \code{TRUE}, the default, the left-most character variable that has all unique elements is removed from the data frame and set to be \code{row.names}.  To match \code{import}, set \code{row.names=FALSE}.
}
  \item{stringsAsFactors}{
If \code{TRUE}, then character variables that do not have all unique elements are converted to factors. The default is determined by the value of \code{options("stringsAsFactors")} whose "factory fresh" default is equal to \code{TRUE}.  To get the default behavior of the \code{import} function, set \code{stringsAsFractors=FALSE}. }
}
\details{
This function always calls the \code{\link[rio]{import}} function to read a data frame from a file.  Many type of file are supported.  The \code{Import} function allows the user to set \code{row.names}, and automatically convert character and logical variables to factors, but only if the \code{format} of the file is one of \code{"txt", "csv", "xlsx", "xls", "ods"}.  Many more details are given at the man page for \code{import}.
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
head(Duncan2, 3) # first three rows
identical(Duncan, Duncan2)
# cleanup
unlink("Duncan.csv")
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ utilities }% use one of  RShowDoc("KEYWORDS")
\keyword{ connections }% __ONLY ONE__ keyword per line
