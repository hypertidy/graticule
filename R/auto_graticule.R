grain <- function(x, n = 300) {
  ranges <- list(x = c(xmin(x), xmax(x)), y = c(ymin(x), ymax(x)))
  maxrange <- ranges[[which.max(unlist(lapply(ranges, diff)))]]
  diff(maxrange)/n
}

auto_graticule <- function(x, nlevels = 15L, nlevels_lon = nlevels, nlevels_lat = nlevels) {
  if (!inherits(x, "Spatial")) x<- as(x, "Spatial")
  proj <- raster::projection(x)
  r <- raster::raster(spex::spex(x), res = grain(x))
  cds <- rgdal::project(coordinates(r), proj, inv = TRUE)
  lon <- raster::setValues(r, cds[, 1L])
  lat <- raster::setValues(r, cds[, 2L])
  as(rbind(sf::st_as_sf(raster::rasterToContour(lon, nlevels = nlevels_lon)),
           sf::st_as_sf(raster::rasterToContour(lat, nlevels = nlevels_lat))), "Spatial")
}

