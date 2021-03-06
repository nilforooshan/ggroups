% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/buildA.R
\name{buildA}
\alias{buildA}
\title{Relationship matrix \strong{A}}
\usage{
buildA(ped)
}
\arguments{
\item{ped}{: \code{data.frame} with integer columns corresponding to ID, SIRE, DAM. Missing value is 0.}
}
\value{
Relationship \code{matrix} \strong{A}
}
\description{
Builds the pedigree-based additive genetic relationship matrix.
}
\examples{
ped = data.frame(ID=1:6, SIRE=c(0,0,1,3,1,4), DAM=c(0,0,2,2,2,5))
buildA(ped)

}
