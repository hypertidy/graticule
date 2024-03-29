% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lonlat.R
\name{lonlat}
\alias{lonlat}
\title{Add longitude latitude lines to a plot}
\usage{
lonlat(
  x,
  na.rm = FALSE,
  lon = FALSE,
  lat = FALSE,
  ...,
  plot = TRUE,
  add = TRUE
)
}
\arguments{
\item{x}{input raster}

\item{na.rm}{logical, remove missing values from generated coordinates}

\item{lon}{if TRUE, only longitude plotted}

\item{lat}{if TRUE (and `lon = FALSE`) only latitude plotted}

\item{...}{passed to [graphics::contour()]}

\item{plot}{logical, plot the result}

\item{add}{logical, add to current plot or instantiate one}
}
\value{
RasterBrick of the longitude and latitude values,  two layers

(invisibly) the raster (RasterBrick) object with longitude and latitude values of the input
 as two layers, otherwise this function used for side-effect (drawing on a plot)
}
\description{
Use the coordinates of the input raster to generate coordinate rasters, these are
then used in a contour plot.
}
\details{
Plot is added to an existing plot by default.
}
\examples{
plot(c(-180, 180), c(-90, 90))
lonlat(raster::raster())

p <- raster::projectExtent(raster::raster(), "+proj=igh")
lonlat(p, add = FALSE)
lonlat(p, levels = seq(-180, 180, by  =15), add = FALSE)

lonlat(p, levels = seq(-180, 180, by = 5), add = FALSE, lon = TRUE)
lonlat(p, levels = seq(-180, 180, by = 15), add = TRUE, lat = TRUE)
}
