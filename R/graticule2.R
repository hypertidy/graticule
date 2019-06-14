graticule_tiles <- function(lons = seq(-180, 180, by = 15), lats = seq(-84, 84, by = 12), nverts = 24, proj = NULL) {
 grid <- raster::raster(raster::extent(range(lons), range(lats)),
                         ncols = length(lons) + 1, nrow = length(lats) + 1)

  ll <- vector("list", ncell(grid))
  ## loop extents of every pixel (I know, I know)
  for (i in seq_along(ll)) {
    ex <- raster::extentFromCells(grid, i)
    ll[[i]] <- ll_extent(ex)
  }
  xx <- do.call(raster::spPolygons, ll)

  xx <- sp::SpatialPolygonsDataFrame(xx, data.frame(x = 1:length(xx)))
  raster::projection(xx) <-   "+proj=longlat +datum=WGS84"
  #plot(spTransform(xx, "+proj=laea"))
 if (!is.null(proj))  sp::spTransform(xx, proj) else xx
}


ll_extent <- function(ext, nverts = 24, mindist = 1e5) {
  ## technically we don't need meridionally segmentation, but this is general enough
## for any set of segments assumed to be rhumb lines
dat2 <- matrix(c(spex::xlim(ext),
                 spex::ylim(ext))[c(1, 2, 2, 2, 2, 1, 1, 1,
                                    3, 3, 3, 4, 4, 4, 4, 3)],
               ncol = 2)
l <- purrr::map(seq(1, nrow(dat2), by = 2),
                ~{
                  xy <- dat2[c(.x, .x + 1), ]
                  dst <- geosphere::distRhumb(xy[1, ], xy[2, ])
                  nn <- if (is.null(mindist)) nverts else round(dst/mindist)
                  nn <- max(c(nn, 3))  ## there's got to be a limit
                  cbind(approx(xy[,1], n = nn)$y, approx(xy[,2], n = nn)$y)
                })
do.call(rbind, lapply(l, head, -1))
}
