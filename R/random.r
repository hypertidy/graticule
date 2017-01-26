## random graticules

#' Generate random graticules.
#'
#' All arguments are optional and will be auto sampled sensibly if not specified.
#' @param family central longitude
#' @param lon_0
#' @param lat_0
#' @param radius
#' @param ...
#'
#' @return see \code{\link{auto_graticule}}
#' @in
#' rgrat()
rgrat <- function(family = NULL, lon_0 = NULL, lat_0 = NULL, radius = NULL, datum = NULL, ...) {
  if (is.null(family)) family <- sample(proj_family[["family"]], 1L)
  if (is.null(lon_0))  lon_0 <- runif(1L, -180, 180)
  if (is.null(lat_0))  lat_0 <- runif(1L, -90, 90)
  if (is.null(radius)) radius <- runif(1L, 1.0, 6378183 *  pi)
  if (is.null(datum)) datum <- "WGS84" ##todo proj -ld/-le etc.
  crs <- sprintf("+proj=%s +lon_0=%f +lat_0=%f +datum=%s", family, lon_0, lat_0, datum)
  if (is.na(projection(crs))) {
    print(crs)
    stop("cannot build CRS from that input")
  }
  r <- try(raster(extent(-radius, radius, -radius, radius), crs = crs))
  if (inherits(r, "try-error")) stop(sprintf("cannot build raster from %s with radius: %f", crs, radius))
  x <- try(auto_graticule(r, ...))

  if (inherits(x, "try-error")) {
    print(crs)
    print(radius)
    stop("something went wrong")
  }
  x
 }
