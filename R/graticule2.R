#' @noRd
#' @examples
#' lon <- seq(-40, 40, by = 10)
#' lat <- seq( -60, -40, by = 5)
#' g <- graticule_tiles(lon, lat, margin = TRUE)
#' xx <- seq(-90, 90, length = 10) + 147
#' yy <- seq(-90, 90, length = 5)
#'  g <- graticule_tiles(xx, yy, proj = "+proj=ortho +lon_0=147 +ellps=WGS84")
#'  plot(g, col = c("black", "grey"))
#'  prj <- "+proj=stere +lat_0=-90 +lat_ts=-70 +lon_0=0 +k=1 +x_0=0 +y_0=0 +a=6378273 +b=6356889.449 +units=m +no_defs"
#'  meridians <- seq(-180, 160, by = 20)
#'  parallels <- c(-80, -73.77, -68, -55, -45)
#'  polargrid <- graticule_tiles(lons = c(meridians, 180),
#'  lats = parallels,  proj = prj)
NULL

#' Graticule tiles
#' @noRd
#'
#' @importFrom stats approx
#' @importFrom utils head
graticule_tiles <- function(lons = seq(-180, 180, by = 15), lats = seq(-84, 84, by = 12),
                            nverts = 24, proj = NULL,
                            margin = FALSE) {
  if (length(lons) < 2) stop("length of argument `lons` is < 2")
  if (length(lats) < 2) stop("length of argument `lats` is < 2")
  grid <- raster::raster(raster::extent(range(lons), range(lats)),
                         ncols = length(lons)-1, nrow = length(lats)-1)


  if (margin) {

    cells <-
      c(raster::cellFromRow(grid, 1),             ## top margin
        raster::cellFromCol(grid, ncol(grid))[-c(1,nrow(grid))],      ## right margin
        utils::head(rev(raster::cellFromRow(grid, nrow(grid))), -1), ## bottom margin
        utils::head(rev(raster::cellFromCol(grid, 1)), -1))          ## left margin
  } else {
    cells <- seq_len(raster::ncell(grid))
  }

  ll <- vector("list", length(cells))
  ## loop extents of every pixel (I know, I know)
  p4 <- lonlatp4()
  for (i in seq_along(ll)) {
    ex <- raster::extentFromCells(grid, cells[i])
    m1 <- ll_extent(c(ex@xmin, ex@xmax), c(ex@ymin, ex@ymax))
    if (!is.null(proj)) {
      m1 <- reproj::reproj_xy(m1, proj, source = lonlatp4())
      p4 <- proj
    }
    ll[[i]] <- m1
  }
  xx <- do.call(raster::spPolygons, ll)

  xx <- sp::SpatialPolygonsDataFrame(xx, data.frame(x = 1:length(xx)))
  raster::projection(xx) <-   p4
  xx
}


ll_extent <- function(lonrange, latrange, nverts = 24, mindist = 1e5) {
  ## technically we don't need meridionally segmentation, but this is general enough
  ## for any set of segments assumed to be rhumb lines
  dat2 <- matrix(c(lonrange,
                   latrange)[c(1, 2, 2, 2, 2, 1, 1, 1,
                               3, 3, 3, 4, 4, 4, 4, 3)],
                 ncol = 2)
  l <- lapply(seq(1, nrow(dat2), by = 2),
                function(.x) {
                    xy <- dat2[c(.x, .x + 1), ]
                    suppressWarnings(dst <- geosphere::distRhumb(xy[1, ], xy[2, ]))
                    nn <- if (!is.null(nverts)) nverts else round(dst/mindist)
                    nn <- max(c(nn, 3))  ## there's got to be a limit
                    cbind(stats::approx(xy[,1], n = nn)$y, approx(xy[,2], n = nn)$y)
                  })
  do.call(rbind, lapply(l, head, -1))
}
