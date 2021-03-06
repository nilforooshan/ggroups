% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tabA.R
\name{tabA}
\alias{tabA}
\title{Relationship matrix \strong{A} in a tabular format}
\usage{
tabA(ped)
}
\arguments{
\item{ped}{: \code{data.frame} with integer columns corresponding to ID, SIRE, DAM. Missing value is 0.}
}
\value{
Genetic relationship \code{data.frame}
}
\description{
Creates the pedigree-based additive genetic relationship \code{data.frame}.
}
\examples{
ped = data.frame(ID=1:6, SIRE=c(0,0,1,3,1,4), DAM=c(0,0,2,2,2,5))
tabA(ped)

}
