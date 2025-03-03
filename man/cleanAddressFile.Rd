% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/cleanAddressFile.R
\name{cleanAddressFile}
\alias{cleanAddressFile}
\title{Clean Address file}
\usage{
cleanAddressFile(d, deleteRows = TRUE)
}
\arguments{
\item{d}{The data.table containing the data of interest.}

\item{deleteRows}{Logical.  Should duplicated rows be removed from this
  dataset?}
}
\value{
A data.table with the same structure as what was passed, but
  possibly modified to clean up names or delete duplicate rows.
}
\description{
This function takes a data.table with columns street, number and city and
performs some cleaning operations to it.  Additional columns may exist, and
they will be ignored.
}

