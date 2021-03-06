% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/import_Filter.R
\name{import_Filter}
\alias{import_Filter}
\title{Function to import a filter}
\usage{
import_Filter(file.name, thickness = NULL)
}
\arguments{
\item{file.name}{\link{character} (required): name of the .FLT file containing the filter properties.}

\item{thickness}{\link{numeric} (default): Thickness of the filter (by default thickness = reference thickness).}
}
\value{
The function creates a new \code{\linkS4class{Filter}} object.
}
\description{
This function import the properties of a filter previously saved in a .FLT file.
}
\examples{
folder <- system.file("extdata", package="LumReader")

file.name <- 'example' # !!! no extension !!! #

file <-paste(folder, '/', file.name, sep="")

example <- import_Filter(file)

plot_Filter(example)

}
\author{
David Strebler, University of Cologne (Germany).
}

