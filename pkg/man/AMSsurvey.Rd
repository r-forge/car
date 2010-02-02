\name{AMSsurvey}
\alias{AMSsurvey}
\docType{data}
\title{
American Math Society Survey Data
}
\description{
Counts of new PhDs in the mathematical sciences for 2008-09 categorized by type
of institution, gender, and US citizenship status.
}
\usage{data(AMSsurvey)}
\format{
  A data frame with 24 observations on the following 5 variables.
  \describe{
    \item{\code{type}}{a factor with levels \code{I(Pu)} for group I
public universities, \code{I(Pr)} for group I private universities, \code{II}
\code{III}, \code{IV}, \code{Va} for the corresponding groups of universities}
    \item{\code{class}}{a factor with levels \code{Female:Non-US} \code{Female:US} \code{Male:Non-US} \code{Male:US}}
    \item{\code{sex}}{a factor with levels \code{Female}, \code{Male} of the
recipient}
    \item{\code{citizen}}{a factor with levels \code{Non-US}, \code{US} giving
citizenship status}
    \item{\code{count}}{The number of individuals of each type}
  }
}
\details{
These data are produced yearly by the AMS; see
\url{http://www.ams.org/employment/surveyreports.html}.  These data are from
Supplementary Table 4 in the 2008-09 data.
}
\source{
%%  ~~ reference to a publication or URL from which the data were obtained ~~
}
\references{
Phipps, Polly, Maxwell, James W. and Rose, Colleen
(2009), \emph{2009 Annual Survey of the Mathematical Sciences},
57, {250--259}, Supplementary Table 4,
\url{http://www.ams/org/employment/2009Survey-First-Report-Supp-Table4.pdf}
}
\examples{
data(AMSsurvey)
}
\keyword{datasets}
