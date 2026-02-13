#' Add longitude latitude lines to a plot
#'
#' Use the coordinates of the input raster to generate coordinate rasters, these are
#' then used in a contour plot.
#'
#' Plot is added to an existing plot by default.
#'
#' @param x input SpatRaster
#' @param na.rm logical, remove missing values from generated coordinates
#' @param ... passed to [graphics::contour()]
#' @param plot logical, plot the result
#' @param add logical, add to current plot or instantiate one
#' @param lon if TRUE, only longitude plotted
#' @param lat if TRUE (and `lon = FALSE`) only latitude plotted
#'
#' @return SpatRaster of the longitude and latitude values, two layers
#' @export
#' @return (invisibly) the SpatRaster object with longitude and latitude values of the input
#'  as two layers, otherwise this function used for side-effect (drawing on a plot)
#' @importFrom terra rast ncell values crs xFromCell yFromCell xyFromCell contour
#' @importFrom graphics contour
#' @examples
#' plot(c(-180, 180), c(-90, 90))
#' lonlat(terra::rast())
#'
#' p <- terra::project(terra::rast(), "+proj=igh")
#' lonlat(p, add = FALSE)
#' lonlat(p, levels = seq(-180, 180, by  =15), add = FALSE)
#'
#' lonlat(p, levels = seq(-180, 180, by = 5), add = FALSE, lon = TRUE)
#' lonlat(p, levels = seq(-180, 180, by = 15), add = TRUE, lat = TRUE)
lonlat <- function(x, na.rm = FALSE, lon = FALSE, lat = FALSE, ..., plot = TRUE, add = TRUE) {
  x <- x[[1]]
  ll <- FALSE
  if (is.na(terra::crs(x)) || terra::crs(x) == "") {
    message("no projection metadata on raster, assuming longlat")
    ll <- TRUE
  }
    cell <- seq_len(terra::ncell(x))
    if (na.rm) cell <- cell[!is.na(terra::values(x))]
    lons <- terra::rast(x)
    lats <- terra::rast(x)
    if (ll) {
      lons[cell] <- terra::xFromCell(x, cell)
      lats[cell] <- terra::yFromCell(x, cell)
    } else {
      xy <- terra::xyFromCell(x, cell)
      suppressWarnings(xy <- reproj::reproj_xy(xy, lonlatp4(), source = terra::crs(x)))
      lons[cell] <- xy[, 1]
      lats[cell] <- xy[, 2]
    }
    if (plot) {
      if (lon || !lat) terra::contour(lons, add = add, ...)
      if (!lon) terra::contour(lats, add = TRUE, ...)
    }
  invisible(c(lons, lats))
}
