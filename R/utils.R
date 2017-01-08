#' @importFrom raster xmin xmax
xrange <- function(x) {
  c(xmin(x), xmax(x))
}
#' @importFrom raster ymin ymax
yrange <- function(x) {
  c(ymin(x), ymax(x))
}

## from spex
#' @importFrom quadmesh quadmesh
#' @importFrom sf st_sfc st_as_sf
#' @importFrom raster as.data.frame projection
qm_rasterToPolygons <- function(x, all_layers = TRUE) {
  ## create dense mesh of cell corner coordinates
  qm <- quadmesh::quadmesh(x)
  ## split the mesh and construct simple features POLYGONS (without checking them)
  l <- lapply(split(t(qm$vb[1:2, qm$ib]), rep(seq_len(ncol(qm$ib)), each = 4)), function(x) structure(list(matrix(x, ncol = 2)[c(1, 2, 3, 4, 1), ]),
                                                                                                      class = c("XY", "POLYGON", "sfg")))
  ## get all the layers off the raster
  if (all_layers) {
    sf1 <- raster::as.data.frame(x)
  } else {
    sf1 <- raster::as.data.frame(x[[1]])
  }
  ## add the geometry column
  sf1[["geometry"]] <- sf::st_sfc(l, crs = raster::projection(x))
  ## cast as simple features object
  sf::st_as_sf(sf1)
}

#' @importFrom methods as
qm_rasterToPolygons_sp <- function(x) {
  as(qm_rasterToPolygons(x), "Spatial")
}


